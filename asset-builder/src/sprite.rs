use std::{
    fs::{self, File},
    io::Write,
    path::PathBuf,
};

use anyhow::{bail, Context};
use image::Rgb;
use imageproc::geometric_transformations::Interpolation;
use linked_hash_map::LinkedHashMap;
use serde::Deserialize;
use serde_valid::Validate;

#[derive(Debug, Deserialize, Validate, Clone)]
pub struct ExpandedSprite {
    pub path: PathBuf,

    #[validate(minimum = -360.0)]
    #[validate(maximum = 360.0)]
    pub rotation: Option<f32>,
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
                rotation: None,
            },
            Self::Expanded(sprite) => sprite.clone(),
        }
    }
}

#[derive(Debug, Deserialize, Default, Clone)]
#[serde(rename_all = "snake_case")]
pub enum OutputType {
    #[default]
    Assembly,
    Binary,
}

#[derive(Debug, Deserialize)]
pub struct SpriteMetadata {
    pub sprites: LinkedHashMap<String, Sprite>,
    pub rotation: Option<f32>,
    pub output_type: Option<OutputType>,
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
    let pixel = red | green | blue;
    pixel
}

pub fn rgb_line_to_string(rgb: &[u8]) -> String {
    rgb.iter()
        .map(|pixel| format!("${:X}", pixel))
        .collect::<Vec<_>>()
        .join(",")
}

pub struct RawSprite<'a, T> {
    pub sprite_suffix: &'a str,
    pub width: u32,
    pub height: u32,
    pub pixels: T,
}

pub fn generate_assembly_sprite(output: &mut String, sprite: RawSprite<Vec<u8>>) {
    output.push_str(&format!(
        "\n{}:\n\
            .width := {}\n\
            .height := {}\n\
            db .width, .height",
        sprite.sprite_suffix, sprite.width, sprite.height
    ));

    output.push_str(
        &sprite
            .pixels
            .chunks_exact(sprite.width as usize)
            .map(rgb_line_to_string)
            .map(|line| format!("\ndb {}", line))
            .collect::<String>(),
    );
}

pub fn generate_binary_sprite(output: &mut Vec<u8>, mut sprite: RawSprite<Vec<u8>>) {
    output.push(sprite.width as u8);
    output.push(sprite.height as u8);
    output.append(&mut sprite.pixels);
}

pub fn get_pixel_data(
    sprite: &Sprite,
    sprite_path: &PathBuf,
    metadata: &SpriteMetadata,
) -> anyhow::Result<(u32, u32, image::ImageBuffer<Rgb<u8>, Vec<u8>>)> {
    let sprite = sprite.to_expanded();

    let source_image_path = sprite_path
        .parent()
        .with_context(|| "Sprite path was empty.")?
        .join(sprite.path);

    {
        let is_png = source_image_path
            .extension()
            .with_context(|| {
                format!(
                    "Failed to get extension of file: {}",
                    source_image_path.display()
                )
            })?
            .to_ascii_lowercase()
            == "png";

        if !is_png {
            bail!("Image format not supported; PNGs are only supported.");
        };
    }

    let sprite_data = image::io::Reader::open(source_image_path.clone())?.decode()?;

    let rotation =
        -1.0 * sprite.rotation.unwrap_or_default() + metadata.rotation.unwrap_or_default();

    let pixels = if rotation != 0.0 {
        imageproc::geometric_transformations::rotate_about_center(
            &sprite_data.to_rgb8(),
            rotation.to_radians(),
            Interpolation::Bilinear,
            Rgb([0, 0, 0]),
        )
    } else {
        sprite_data.to_rgb8()
    };

    let width = sprite_data.width();
    let height = sprite_data.height();

    Ok((width, height, pixels))
}

pub fn generate_sprite_file(
    sprite_path: &PathBuf,
    out_path: &PathBuf,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let output_type = metadata.output_type.clone().unwrap_or_default();

    match output_type {
        OutputType::Assembly => {
            generate_assembly_file(sprite_path, out_path, sprite_collection_name, metadata)
        }
        OutputType::Binary => {
            generate_binary_file(sprite_path, out_path, sprite_collection_name, metadata)
        }
    }
}

pub fn generate_assembly_file(
    sprite_path: &PathBuf,
    out_path: &PathBuf,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let mut output = String::new();

    for (sprite_suffix, sprite) in metadata.sprites.iter() {
        let (width, height, pixels) = get_pixel_data(sprite, sprite_path, metadata)?;

        let pixels = pixels
            .pixels()
            .map(|pixel| compress_color_space_rgb(pixel.0))
            .collect::<Vec<_>>();

        generate_assembly_sprite(
            &mut output,
            RawSprite {
                sprite_suffix,
                width,
                height,
                pixels,
            },
        );
    }

    let sprite_out = out_path.join(format!("{}.asm", sprite_collection_name));

    fs::create_dir_all(out_path.clone())?;

    let mut file = File::create(sprite_out)?;
    file.write_all(output.as_bytes())?;

    Ok(())
}

pub fn generate_binary_file(
    sprite_path: &PathBuf,
    out_path: &PathBuf,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let mut output = Vec::with_capacity(64 * 1_024);

    for (sprite_suffix, sprite) in metadata.sprites.iter() {
        let (width, height, pixels) = get_pixel_data(sprite, sprite_path, metadata)?;

        let pixels = pixels
            .pixels()
            .map(|pixel| compress_color_space_rgb(pixel.0))
            .collect::<Vec<_>>();

        generate_binary_sprite(
            &mut output,
            RawSprite {
                sprite_suffix,
                width,
                height,
                pixels,
            },
        );
    }

    let sprite_out = out_path.join(format!("{}.bin", sprite_collection_name));

    fs::create_dir_all(out_path.clone())?;

    let mut file = File::create(sprite_out)?;
    file.write_all(&output)?;

    Ok(())
}
