with source as (
    select * from {{ source('raw_nyc_taxi', 'raw_trips')}}
),
renamed as (
    select 
        "VendorID" as vendor_id,
        to_timestamp_ntz("tpep_pickup_datetime" / 1000000) as pickup_datetime,
        to_timestamp_ntz("tpep_dropoff_datetime" / 1000000) as dropoff_datetime,
        "passenger_count" as passenger_count,
        "trip_distance" as trip_distance,
        "RatecodeID" as rate_code_id,
        "store_and_fwd_flag" as store_and_fwd_flag,
        "PULocationID" as pickup_location_id,
        "DOLocationID" as dropoff_location_id,
        "payment_type" as payment_type,
        "fare_amount" as fare_amount,
        "extra" as extra_charge,
        "mta_tax" as mta_tax,
        "tip_amount" as tip_amount,
        "tolls_amount" as tolls_amount,
        "improvement_surcharge" as improvement_surcharge,
        "total_amount" as total_amount,
        "congestion_surcharge" as congestion_surcharge,
        "Airport_fee" as airport_fee
    from source
),

fingerprinted as (
    select
        md5(
            nvl(vendor_id::string, '')          || '|' ||
            nvl(pickup_datetime::string, '')    || '|' ||
            nvl(dropoff_datetime::string, '')   || '|' ||
            nvl(passenger_count::string, '')    || '|' ||
            nvl(trip_distance::string, '')      || '|' ||
            nvl(rate_code_id::string, '')       || '|' ||
            nvl(pickup_location_id::string, '') || '|' ||
            nvl(dropoff_location_id::string, '')|| '|' ||
            nvl(payment_type::string, '')       || '|' ||
            nvl(fare_amount::string, '')        || '|' ||
            nvl(tip_amount::string, '')         || '|' ||
            nvl(total_amount::string, '')
        ) as trip_id,
        *
    from renamed
)

select * from fingerprinted
qualify row_number() over (partition by trip_id order by pickup_datetime desc) = 1