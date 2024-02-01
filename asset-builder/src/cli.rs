use std::path::PathBuf;

use clap::Parser;

#[derive(Debug, Parser)]
pub struct SpriteArgs {
    pub sprite_path: PathBuf,
    pub out_path: PathBuf,
}

#[derive(Debug, clap::Subcommand)]
pub enum Subcommand {
    Sprites(SpriteArgs),
}

#[derive(Debug, Parser)]
pub struct Args {
    #[command(subcommand)]
    pub subcommand: Subcommand,
}
