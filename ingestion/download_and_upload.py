"""
Download NYC Taxi source files locally, then upload them to the project's S3 landing bucket under one prefix per source table.

Source: NYC TLC's official public trip record data (CloudFront-hosted).
"""

import pathlib
import boto3
import requests

RAW_DIR = pathlib.Path(__file__).parent.parent / "data" / "raw"
BUCKET = "sowrabh-de-portfolio-nyctaxi-845587649385"

SOURCES = {
    "yellow_tripdate_2024-01.parquet":{
        "url": "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet",
        "s3_prefix": "trips"
    },
    "taxi_zone_lookup.csv":{
        "url": "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv",
        "s3_prefix": "zones"
    },
}

def download(filename: str, url: str) -> pathlib.Path:
    dest = RAW_DIR / filename
    if dest.exists():
        print(f"File downloaded: {dest}")
        return dest

    print(f"Downloading {url}")
    response = requests.get(url, stream=True, timeout=60)
    response.raise_for_status()

    with open(dest, "wb") as f:
        for chunk in response.iter_content(chunk_size = 1024 * 1024):
            f.write(chunk)

    print(f"saved: {dest} ({dest.stat().st_size / 1_000_000:.1f} MB)")
    return dest

def upload(local_path: pathlib.Path, s3_prefix: str) -> None:
    s3 = boto3.client("s3")
    key = f"{s3_prefix}/{local_path.name}"  
    print(f"Uploading to s3://{BUCKET}/{key}")
    s3.upload_file(str(local_path), BUCKET, key)
    print("done")

if __name__ == "__main__":
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    for filename, source in SOURCES.items():
        local_path = download(filename, source["url"])
        upload(local_path, source["s3_prefix"])