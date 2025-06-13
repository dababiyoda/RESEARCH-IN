use actix_web::{post, web, HttpResponse, Responder};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct IngestRequest {
    pub url: String,
}

#[post("/ingest")]
pub async fn ingest(body: web::Json<IngestRequest>) -> impl Responder {
    if body.url.starts_with("http") {
        HttpResponse::Ok().body("ingested")
    } else {
        HttpResponse::BadRequest().body("invalid url")
    }
}
