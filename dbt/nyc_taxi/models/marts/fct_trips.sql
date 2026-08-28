with trips AS (select * from {{ ref('stg_trips')}}),
pickup_zone AS (select * from {{ ref('dim_zones')}}),
dropoff_zone AS (select * from {{ ref('dim_zones')}}),
filtered AS (
    select * from trips
    where trip_distance > 0
    and fare_amount >= 0
    and dropoff_datetime > pickup_datetime
),
final as (
    select
        filtered.trip_id,
        filtered.vendor_id,
        filtered.pickup_datetime,
        filtered.dropoff_datetime,
        datediff('minute', filtered.pickup_datetime, filtered.dropoff_datetime) as trip_duration_minutes,
        filtered.passenger_count,
        filtered.trip_distance,
        filtered.pickup_location_id,
        pickup_zone.borough as pickup_borough,
        pickup_zone.zone as pickup_zone,
        filtered.dropoff_location_id,
        dropoff_zone.borough as dropoff_borough,
        dropoff_zone.zone as dropoff_zone,
        case filtered.payment_type
            when 1 then 'credit_card'
            when 2 then 'cash'
            when 3 then 'no_charge'
            when 4 then 'dispute'
            when 5 then 'unknown'
            when 6 then 'voided_trip'
            else 'other'
        end as payment_type,
        filtered.fare_amount,
        filtered.extra_charge,
        filtered.mta_tax,
        filtered.tip_amount,
        filtered.tolls_amount,
        filtered.improvement_surcharge,
        filtered.congestion_surcharge,
        filtered.airport_fee,
        filtered.total_amount
    from filtered
    left join pickup_zone on filtered.pickup_location_id = pickup_zone.location_id
    left join dropoff_zone on filtered.dropoff_location_id = dropoff_zone.location_id

)
select * from final