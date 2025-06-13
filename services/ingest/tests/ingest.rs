use actix_web::{test, App};
use ingest::ingest;

#[actix_rt::test]
async fn test_valid() {
    let app = test::init_service(App::new().service(ingest)).await;
    let req = test::TestRequest::post()
        .uri("/ingest")
        .set_json(&serde_json::json!({"url":"http://example.com"}))
        .to_request();
    let resp = test::call_service(&app, req).await;
    assert!(resp.status().is_success());
}

#[actix_rt::test]
async fn test_invalid() {
    let app = test::init_service(App::new().service(ingest)).await;
    let req = test::TestRequest::post()
        .uri("/ingest")
        .set_json(&serde_json::json!({"url":"bad"}))
        .to_request();
    let resp = test::call_service(&app, req).await;
    assert_eq!(resp.status(), 400);
}
