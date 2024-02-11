use std::{
    fs::{self, File},
    io::Write,
    path::PathBuf,
};

use crate::PointerTable;
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

#[derive(Debug, Deserialize)]
pub struct SpriteMetadata {
    pub sprites: LinkedHashMap<String, Sprite>,
    pub pointer_table: Option<PointerTable>,
}

pub fn load_sprite_metadata(
    sprite_file: &PathBuf,
) -> anyhow::Result<LinkedHashMap<String, SpriteMetadata>> {
    let file = fs::read_to_string(sprite_file)?;
    Ok(toml::from_str(&file)?)
}

fn compress_color_space(rgb: [u8; 3]) -> String {
    let (red, green, blue) = (rgb[0], rgb[1], rgb[2]);
    let red = (red / 32) << 5;
    let green = green / 32;
    let blue = (blue / 64) << 3;
    let pixel = red | green | blue;

    format!("${:x}", pixel).to_uppercase()
}

pub fn generate_sprite(
    sprite_path: &PathBuf,
    out_path: &PathBuf,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let mut output = String::new();

    for (sprite_suffix, sprite) in metadata.sprites.iter() {
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

        let width = sprite_data.width();
        let height = sprite_data.height();

        output += &format!(
            "\n{}:\n\
            .width := {}\n\
            .height := {}\n\
            db .width, .height",
            sprite_suffix, width, height
        );

        let pixels = if let Some(rotation) = sprite.rotation {
            imageproc::geometric_transformations::rotate_about_center(
                &sprite_data.to_rgb8(),
                rotation.to_radians(),
                Interpolation::Bilinear,
                Rgb([0, 0, 0]),
            )
        } else {
            sprite_data.to_rgb8()
        }
        .pixels()
        .map(|pixel| compress_color_space(pixel.0))
        .collect::<Vec<_>>();

        output += &pixels
            .chunks_exact(width as usize)
            .map(|pixel| pixel.join(","))
            .map(|line| format!("\ndb {}", line))
            .collect::<String>();
    }

    if let Some(pointer_table) = &metadata.pointer_table {
        output += &format!("{}:", pointer_table.name);

        if let Some(offset) = pointer_table.offset {
            for _ in 0..offset {
                output += &format!("\ndl 0");
            }
        }

        for (sprite_suffix, _) in metadata.sprites.iter() {
            output += &format!("\ndl Sprite{}", sprite_suffix);
        }
    }

    let sprite_out = out_path.join(format!("{}.asm", sprite_collection_name));

    fs::create_dir_all(out_path.clone())?;

    let mut file = File::create(sprite_out)?;
    file.write_all(output.as_bytes())?;

    Ok(())
}
