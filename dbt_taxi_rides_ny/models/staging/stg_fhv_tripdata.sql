{{ config(materialized="view") }}

select
    {{ dbt_utils.generate_surrogate_key(["dispatching_base_num", "pickup_datetime"]) }}
    as tripid,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }}
    as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }}
    as dropoff_locationid,

    cast("pickup_datetime" as timestamp) as pickup_datetime,
    cast("dropoff_datetime" as timestamp) as dropoff_datetime,

    {{ dbt.safe_cast("SR_Flag", api.Column.translate_type("integer")) }} as sr_flag

from {{ source("staging", "fhv_trip") }}

where extract(year from cast(pickup_datetime as date)) = 2019

-- {% if var("is_test_run", default=true) %} limit 100 {% endif %}
