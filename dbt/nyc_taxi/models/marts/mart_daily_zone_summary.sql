-- aggregate mart: one row per pickup zone per day
select
    date_trunc('day', pickup_datetime) as trip_date,
    pickup_location_id,
    pickup_borough,
    pickup_zone,
    COUNT(*) as trip_count,
    sum(total_amount) as total_revenue,
    avg(trip_distance) as avg_trip_distance,
    avg(trip_duration_minutes) as avg_trip_duration_minutes,
    avg(tip_amount) as avg_tip_amount,
from {{ ref('fct_trips') }}
group by 
    date_trunc('day', pickup_datetime),
    pickup_location_id,
    pickup_borough,
    pickup_zone
