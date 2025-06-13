use actix_web::{App, HttpServer};
use ingest::{ingest};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(ingest))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}
