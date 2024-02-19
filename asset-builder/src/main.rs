mod cli;
mod sprite;

use clap::Parser;
use cli::{Args, Subcommand};
use sprite::{generate_sprite_file, load_sprite_metadata};

fn main() -> anyhow::Result<()> {
    let args = Args::parse();

    match args.subcommand {
        Subcommand::Sprites(sprite_args) => {
            let metadata = load_sprite_metadata(&sprite_args.sprite_path)?;

            for (sprite_name, metadata) in metadata.iter() {
                generate_sprite_file(
                    &sprite_args.sprite_path,
                    &sprite_args.out_path,
                    sprite_name,
                    metadata,
                )?;
            }

            Ok(())
        }
    }
}
