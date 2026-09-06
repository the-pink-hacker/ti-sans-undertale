use std::{
    fs::{self, File},
    io::Write,
    path::{Path, PathBuf},
};

use anyhow::{bail, Context};
use image::Rgb;
use imageproc::geometric_transformations::Interpolation;
use linked_hash_map::LinkedHashMap;
use serde::Deserialize;
use serde_valid::Validate;

#[derive(Debug, Deserialize, Clone, Default)]
#[serde(rename_all = "snake_case")]
pub enum ColorSpace {
    #[default]
    Rgb,
    Monochrome,
}

#[derive(Debug, Deserialize, Validate, Clone, Default)]
pub struct ExpandedSprite {
    pub path: PathBuf,
    #[validate(minimum = -360.0)]
    #[validate(maximum = 360.0)]
    pub rotation: Option<f32>,
    pub color_space: Option<ColorSpace>,
    pub header: Option<bool>,
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum Sprite {
    Path(PathBuf),
    Expanded(ExpandedSprite),
}

impl Sprite {
    pub fn to_expanded(&self) -> ExpandedSprite {
        match self {
            Self::Path(path) => ExpandedSprite {
                path: path.to_path_buf(),
                ..Default::default()
            },
            Self::Expanded(sprite) => sprite.clone(),
        }
    }
}

#[derive(Debug, Deserialize, Default, Clone, Copy)]
#[serde(rename_all = "snake_case")]
pub enum OutputType {
    #[default]
    C,
    Assembly,
}

#[derive(Debug, Deserialize)]
pub struct SpriteMetadata {
    pub sprites: LinkedHashMap<String, Sprite>,
    pub rotation: Option<f32>,
    pub output_type: Option<OutputType>,
    pub color_space: Option<ColorSpace>,
    pub header: Option<bool>,
}

pub fn load_sprite_metadata(
    sprite_file: &PathBuf,
) -> anyhow::Result<LinkedHashMap<String, SpriteMetadata>> {
    let file = fs::read_to_string(sprite_file)?;
    Ok(toml::from_str(&file)?)
}

fn compress_color_space_rgb(rgb: [u8; 3]) -> u8 {
    let (red, green, blue) = (rgb[0], rgb[1], rgb[2]);
    let red = (red / 32) << 5;
    let green = green / 32;
    let blue = (blue / 64) << 3;
    red | green | blue
}

fn rgb_line_to_string_assembly(rgb: &[u8]) -> String {
    rgb.iter()
        .map(|pixel| format!("${:X}", pixel))
        .collect::<Vec<_>>()
        .join(",")
}

fn rgb_line_to_string_c(rgb: &[u8]) -> String {
    rgb.iter()
        .map(|pixel| format!("0x{:X}", pixel))
        .collect::<Vec<_>>()
        .join(",")
}

fn rgb_line_to_monochrome(pixels: &[u8]) -> Vec<String> {
    let mut output = Vec::with_capacity(2);

    for chunk in pixels.chunks(8) {
        let mut byte = 0;

        for (i, pixel) in chunk.iter().enumerate() {
            if pixel != &0 {
                let bit = 7 - i;

                byte |= 1 << bit;
            }
        }

        output.push(byte.to_string());
    }

    output
}

fn unwrap_sprite_option_or<'a, T>(metadata: &'a Option<T>, sprite: &'a Option<T>, value: T) -> T
where
    T: Clone + Default,
{
    if let Some(sprite) = sprite {
        sprite.clone()
    } else {
        metadata.clone().unwrap_or(value)
    }
}

pub fn unwrap_sprite_option<'a, T>(metadata: &'a Option<T>, sprite: &'a Option<T>) -> T
where
    T: Clone + Default,
{
    if let Some(sprite) = sprite {
        sprite.clone()
    } else {
        metadata.clone().unwrap_or_default()
    }
}

pub struct RawSprite {
    pub width: u32,
    pub color_space: ColorSpace,
    pub pixels: Vec<u8>,
}

pub fn generate_assembly_sprite_pixels_rgb(output: &mut String, sprite: &RawSprite) {
    output.push_str(
        &sprite
            .pixels
            .chunks_exact(sprite.width as usize)
            .map(rgb_line_to_string_assembly)
            .map(|line| format!("\ndb {}", line))
            .collect::<String>(),
    );
}

pub fn generate_assembly_sprite_pixels_monochrome(output: &mut String, sprite: &RawSprite) {
    *output += &sprite
        .pixels
        .chunks_exact(sprite.width as usize)
        .map(|line| format!("\ndb {}", rgb_line_to_monochrome(line).join(",")))
        .collect::<String>();
}

pub fn generate_c_sprite_pixels_rgb(output: &mut String, sprite: &RawSprite) {
    output.push_str(
        &sprite
            .pixels
            .chunks_exact(sprite.width as usize)
            .map(rgb_line_to_string_c)
            .map(|line| format!("\n        {}", line))
            .collect::<Vec<String>>()
            .join(","),
    );
}

pub fn generate_c_sprite_pixels_monochrome(output: &mut String, sprite: &RawSprite) {
    *output += &sprite
        .pixels
        .chunks_exact(sprite.width as usize)
        .map(|line| format!("\n        {}", rgb_line_to_monochrome(line).join(",")))
        .collect::<Vec<String>>()
        .join(",");
}

pub fn check_for_png(path: &Path) -> anyhow::Result<()> {
    let is_png = path
        .extension()
        .with_context(|| format!("Failed to get extension of file: {}", path.display()))?
        .eq_ignore_ascii_case("png");

    if !is_png {
        bail!("Image format not supported; PNGs are only supported.");
    };

    Ok(())
}

pub fn get_pixel_data(
    sprite: &ExpandedSprite,
    sprite_path: &Path,
    metadata: &SpriteMetadata,
) -> anyhow::Result<(u32, u32, image::ImageBuffer<Rgb<u8>, Vec<u8>>)> {
    let source_image_path = sprite_path
        .parent()
        .with_context(|| "Sprite path was empty.")?
        .join(sprite.path.clone());

    check_for_png(&source_image_path)?;

    let sprite_data = image::ImageReader::open(source_image_path.clone())?.decode()?;

    let rotation = -sprite.rotation.unwrap_or_default() + metadata.rotation.unwrap_or_default();

    let pixels = if rotation != 0.0 {
        imageproc::geometric_transformations::rotate_about_center(
            &sprite_data.to_rgb8(),
            rotation.to_radians(),
            Interpolation::Bilinear,
            imageproc::geometric_transformations::Border::Constant(Rgb([0, 0, 0])),
        )
    } else {
        sprite_data.to_rgb8()
    };

    let width = sprite_data.width();
    let height = sprite_data.height();

    Ok((width, height, pixels))
}

pub fn generate_sprite_file(
    sprite_path: &Path,
    out_path: &Path,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let output_type = metadata.output_type.unwrap_or_default();

    match output_type {
        OutputType::C => {
            generate_sprite_file_c(sprite_path, out_path, sprite_collection_name, metadata)
        }
        OutputType::Assembly => {
            generate_sprite_file_assembly(sprite_path, out_path, sprite_collection_name, metadata)
        }
    }
}

pub fn generate_sprite_file_assembly(
    sprite_path: &Path,
    out_path: &Path,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let mut output = String::new();

    for (sprite_suffix, sprite) in metadata.sprites.iter() {
        let sprite = sprite.to_expanded();

        let (width, height, pixels) = get_pixel_data(&sprite, sprite_path, metadata)?;

        output += &format!(
            "\n{}:\n\
            .width := {}\n\
            .height := {}",
            sprite_suffix, width, height
        );

        let pixels = pixels
            .pixels()
            .map(|pixel| compress_color_space_rgb(pixel.0))
            .collect::<Vec<_>>();

        let color_space = unwrap_sprite_option(&metadata.color_space, &sprite.color_space);
        let header = unwrap_sprite_option_or(&metadata.header, &sprite.header, true);

        let raw_sprite = RawSprite {
            width,
            color_space,
            pixels,
        };

        if header {
            output += "\ndb .width, .height";
        }

        match raw_sprite.color_space {
            ColorSpace::Rgb => generate_assembly_sprite_pixels_rgb(&mut output, &raw_sprite),
            ColorSpace::Monochrome => {
                generate_assembly_sprite_pixels_monochrome(&mut output, &raw_sprite)
            }
        }
    }

    let sprite_out = out_path.join(format!("{}.asm", sprite_collection_name));

    fs::create_dir_all(out_path)?;

    let mut file = File::create(sprite_out)?;
    file.write_all(output.as_bytes())?;

    Ok(())
}

pub fn generate_sprite_file_c(
    sprite_path: &Path,
    out_path: &Path,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    fs::create_dir_all(out_path)?;

    let mut header_output = "#include <graphx.h>\n".to_string();
    let mut c_output = header_output.clone();

    for (sprite_suffix, sprite) in metadata.sprites.iter() {
        let sprite = sprite.to_expanded();

        let (width, height, pixels) = get_pixel_data(&sprite, sprite_path, metadata)?;
        let sprite_suffix_upper = sprite_suffix.to_uppercase();

        header_output += &format!(
            "\n#define SPRITE_{sprite_suffix_upper}_WIDTH {width}\n\
            #define SPRITE_{sprite_suffix_upper}_HEIGHT {height}"
        );

        let header = unwrap_sprite_option_or(&metadata.header, &sprite.header, true);
        if header {
            c_output += &format!(
                "\nconst gfx_sprite_t sprite_{sprite_suffix} = {{\n    \
                .width = {width},\n    \
                .height = {height},\n    \
                .data = {{"
            );
            header_output += &format!("\nextern const gfx_sprite_t sprite_{sprite_suffix};\n");
        } else {
            c_output += &format!("const uint8_t sprite_{sprite_suffix}[SPRITE_{sprite_suffix_upper}_WIDTH * SPRITE_{sprite_suffix_upper}_HEIGHT] = {{\n");
            header_output += &format!("\nconst uint8_t sprite_{sprite_suffix}[SPRITE_{sprite_suffix_upper}_WIDTH * SPRITE_{sprite_suffix_upper}_HEIGHT];\n");
        }

        let pixels = pixels
            .pixels()
            .map(|pixel| compress_color_space_rgb(pixel.0))
            .collect::<Vec<_>>();

        let color_space = unwrap_sprite_option(&metadata.color_space, &sprite.color_space);

        let raw_sprite = RawSprite {
            width,
            color_space,
            pixels,
        };

        match raw_sprite.color_space {
            ColorSpace::Rgb => generate_c_sprite_pixels_rgb(&mut c_output, &raw_sprite),
            ColorSpace::Monochrome => {
                generate_c_sprite_pixels_monochrome(&mut c_output, &raw_sprite)
            }
        }

        if header {
            c_output += "\n    }\n};\n";
        } else {
            c_output += "\n};\n"
        }
    }

    let c_out = out_path.join(format!("{}.c", sprite_collection_name));
    let mut file = File::create(c_out)?;
    file.write_all(c_output.as_bytes())?;

    let header_out = out_path.join(format!("{}.h", sprite_collection_name));
    let mut file = File::create(header_out)?;
    file.write_all(header_output.as_bytes())?;

    Ok(())
}
