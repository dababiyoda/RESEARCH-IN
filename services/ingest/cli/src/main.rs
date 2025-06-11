use std::env;
use std::path::PathBuf;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 3 || args[1] != "watch" {
        eprintln!("Usage: ingest watch <ipfs-cid-file>");
        std::process::exit(1);
    }

    let file = PathBuf::from(&args[2]);
    ingest_core::watch(file).await
}
