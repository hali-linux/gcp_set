provider "google" {
  credentials = file("credentials.json")
  project = "gcp-johnlee2022-352701"
  region = "asia-northeast3"
  zone = "asia-northeast3-a"
}
