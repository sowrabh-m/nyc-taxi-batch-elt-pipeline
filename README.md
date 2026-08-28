# Batch ELT Foundation - NYC Taxi (S3 -> Snowflake -> dbt)

Project 1 of a Snowflake Data Engineer portfolio. 
Goal: the base ELT pattern every later project builds on - land raw files is S3, load into Snowflake with 'COPY INTO', model with dbt (staging -> marts), test with dbt tests.

## Status
🔶 In progress - scaffolding stage.

## Architecture
_TODO - fill in once the pipeline is built: diagram, s3 bucket layout, Snowflake database/schema layout, dbt staging/marts model list._

## Stack
- **Source data:** NYC Taxi trip records (yellow cab, one month) + taxi zone lookup
- **Landing:** AWS S3
- **Warehouse:** Snowflake (`COPY INTO` from an external stage)
- **Transformation:** dbt (dbt-core + dbt-snowflake adapter)

## Why this dataset
Two joinable tables (trip records + zone lookup), well-documented schema, size is controllable by picking a single month - enough to exercise staging/marts layering and dbt tests without needing big-data tooling yet.

## Setup
_TODO - document once environment/credentials setup is finalized: venv + requirements.txt, AWS credentials, Snowflake 'profiles.yml' (git-ignored)._

## What I'd do differently at scale
_TODO - fill in at the end, per the portfolio roadmap's capstone habit._

