select business_id,
       cool,
       funny,
       review_id string,
       stars integer,
       (left(t.temperature_date, 4) || '-' || substr(t.temperature_date,5,2) || '-' || substr(t.temperature_date,7,2)) as temp,
       (left(p.precipitation_date, 4) || '-' || substr(p.precipitation_date,5,2) || '-' || substr(p.precipitation_date,7,2)) as prec
from  ODS.ODS_YELP_REVIEW_DETAILS as r,
      ODS.ODS_LV_TEMPERATURE_DETAILS as t,
      ODS.ODS_LV_PRECIPITATION_DETAILS as p
WHERE (left(r.review_date, 10) = (left(temperature_date, 4) || '-' || substr(temperature_date,5,2) || '-' || substr(temperature_date,7,2)))
  and (left(r.review_date, 10) = (left(precipitation_date, 4) || '-' || substr(precipitation_date,5,2) || '-' || substr(precipitation_date,7,2)))

