use std::env;
use reqwest::StatusCode;
use serde_json::json;
use tokio_postgres::NoTls;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?;
    let typesense_url = env::var("TYPESENSE_URL").unwrap_or_else(|_| "http://localhost:8108".to_string());
    let typesense_api_key = env::var("TYPESENSE_API_KEY")?;

    let (db_client, connection) = tokio_postgres::connect(&database_url, NoTls).await?;
    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("database connection error: {}", e);
        }
    });

    let http = reqwest::Client::new();
    let collection_url = format!("{}/collections/papers", typesense_url);
    let res = http
        .get(&collection_url)
        .header("X-TYPESENSE-API-KEY", &typesense_api_key)
        .send()
        .await?;

    if res.status() == StatusCode::NOT_FOUND {
        let schema = json!({
            "name": "papers",
            "fields": [
                {"name": "id", "type": "int64"},
                {"name": "title", "type": "string"},
                {"name": "abstract", "type": "string"}
            ]
        });
        http
            .post(format!("{}/collections", typesense_url))
            .header("X-TYPESENSE-API-KEY", &typesense_api_key)
            .json(&schema)
            .send()
            .await?
            .error_for_status()?;
    } else {
        res.error_for_status()?;
    }

    let rows = db_client
        .query("SELECT id, title, abstract FROM papers", &[])
        .await?;

    for row in &rows {
        let id: i64 = row.get("id");
        let title: String = row.get("title");
        let abstract_text: Option<String> = row.get("abstract");
        let doc = json!({
            "id": id,
            "title": title,
            "abstract": abstract_text.unwrap_or_default(),
        });

        http
            .post(format!("{}/collections/papers/documents?upsert=true", typesense_url))
            .header("X-TYPESENSE-API-KEY", &typesense_api_key)
            .json(&doc)
            .send()
            .await?
            .error_for_status()?;
    }

    println!("Ingested {} papers", rows.len());
    Ok(())
}
