use std::collections::HashSet;
use std::path::PathBuf;
use std::time::Duration;

use tokio::fs;
use tokio::io::AsyncReadExt;
use tokio::time::sleep;

/// Watch the given file for new IPFS CIDs and process them.
pub async fn watch(file: PathBuf) -> Result<(), Box<dyn std::error::Error>> {
    let mut seen = HashSet::new();
    loop {
        let mut data = String::new();
        if let Ok(mut f) = fs::File::open(&file).await {
            f.read_to_string(&mut data).await?;
            for cid in data.lines() {
                if seen.insert(cid.to_string()) {
                    process_cid(cid).await?;
                }
            }
        }
        sleep(Duration::from_secs(5)).await;
    }
}

async fn process_cid(_cid: &str) -> Result<(), Box<dyn std::error::Error>> {
    // 1. Download from IPFS
    // 2. Extract text using Apache Tika
    // 3. Split into ~500-token chunks
    // 4. Compute embeddings using sentence-transformers
    // 5. POST paper row and embeddings to Qdrant and Supabase
    Ok(())
}
