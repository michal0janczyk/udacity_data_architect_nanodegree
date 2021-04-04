select business_name as "Bussines Name",
       dim_temp.TEMPERATURE_DATE as "Dim Date",
       dim_temp.TEMP_MIN as "Temp Min",
       dim_temp.TEMP_MAX as "Temp Max",
       dim_prec.precipitation as "Precipitation",
       dim_prec.precipitation_normal as "Precipitation Normal",
       dim_rev.stars as "Rating"
from DWH_FACT_YELP_RESTAURANT_REVIEW as fact_rest
left join DWH_DIM_LV_TEMPERATURE_DETAILS as dim_temp on fact_rest.temperature_date = dim_temp.temperature_date
left join DWH_DIM_LV_PRECIPITATION_DETAILS as dim_prec on fact_rest.precipitation_date = dim_prec.precipitation_date
left join DWH_DIM_YELP_REVIEW_DETAILS as dim_rev on fact_rest.review_id = dim_rev.review_id
