with source as (
    select * from {{ source('raw_nyc_taxi', 'raw_zones') }}
),
renamed as (
    select location_id, borough, zone, service_zone from source
)
select * from renamed