use std::{
    fs::{self, File},
    io::Write,
    path::PathBuf,
};

use crate::PointerTable;
use anyhow::{bail, Context};
use linked_hash_map::LinkedHashMap;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct SpriteMetadata {
    pub sprites: LinkedHashMap<String, PathBuf>,
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
    format!("${:x}", pixel)
}

pub fn generate_sprite(
    sprite_path: &PathBuf,
    out_path: &PathBuf,
    sprite_collection_name: &str,
    metadata: &SpriteMetadata,
) -> anyhow::Result<()> {
    let mut output = String::new();

    for (sprite_suffix, sprite_name) in metadata.sprites.iter() {
        let source_image_path = sprite_path
            .parent()
            .with_context(|| "Sprite path was empty.")?
            .join(sprite_name);

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

        let sprite_png = image::io::Reader::open(source_image_path.clone())?.decode()?;

        let height = sprite_png.height();
        let width = sprite_png.width();

        output += &format!("\n{}:\ndb {}, {}", sprite_suffix, height, width);

        let pixels = sprite_png
            .to_rgb8()
            .pixels()
            .map(|pixel| compress_color_space(pixel.0))
            .collect::<Vec<_>>();

        output += &pixels
            .chunks_exact(width as usize)
            .map(|pixle| pixle.join(","))
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
