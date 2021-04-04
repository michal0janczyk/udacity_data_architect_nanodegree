drop table if exists dwh_dim_yelp_business_details;
create table dwh_dim_yelp_business_details (
  business_id string,
  address string,
  attributes object,
  categories array,
  city string,
  hours object,
  is_open integer,
  latitude float,
  longitude float,
  business_name string,
  postal_code string,
  review_count integer,
  stars float,
  state string
);

insert into dwh_dim_yelp_business_details
select distinct business_id,
                address,
                attributes,
                categories,
                city,
                hours,
                is_open,
                latitude,
                longitude,
                business_name,
                postal_code,
                review_count,
                stars,
                state
from "UDACITYPROJECT"."ODS"."ODS_YELP_BUSINESS_DETAILS";

drop table if exists dwh_dim_yelp_checkin_details;
create table dwh_dim_yelp_checkin_details (
  checkin_id int,
  business_id string,
  checkin_date string
);

insert into dwh_dim_yelp_checkin_details(checkin_id, business_id, checkin_date)
select distinct checkin_id,
                business_id,
                checkin_date
from "UDACITYPROJECT"."ODS"."ODS_YELP_CHECKIN_DETAILS";

drop table if exists dwh_dim_yelp_tip_details;
create table dwh_dim_yelp_tip_details (
  tip_id int,
  business_id string,
  compliment_count integer,
  date string,
  tip_text string,
  user_id string
);

insert into dwh_dim_yelp_tip_details(tip_id, business_id, compliment_count, date, tip_text, user_id)
select distinct tip_id,
                business_id,
                compliment_count,
                date,
                tip_text,
                user_id
from "UDACITYPROJECT"."ODS"."ODS_YELP_TIP_DETAILS";

drop table if exists dwh_dim_yelp_covid_details;
create table dwh_dim_yelp_covid_details (
  covid_id int,
  Call_To_Action_enabled string,
  Covid_Banner string,
  Grubhub_enabled string,
  Request_a_Quote_Enabled string,
  Temporary_Closed_Until string,
  Virtual_Services_Offered string,
  business_id string,
  delivery_or_takeout string,
  highlights string
);

insert into dwh_dim_yelp_covid_details(covid_id, Call_To_Action_enabled, Covid_Banner, Grubhub_enabled, Request_a_Quote_Enabled, Temporary_Closed_Until, Virtual_Services_Offered, business_id, delivery_or_takeout, highlights)
select distinct covid_id,
                Call_To_Action_enabled,
                Covid_Banner,
                Grubhub_enabled,
                Request_a_Quote_Enabled,
                Temporary_Closed_Until,
                Virtual_Services_Offered,
                business_id,
                delivery_or_takeout,
                highlights
from "UDACITYPROJECT"."ODS"."ODS_YELP_COVID_DETAILS";

drop table if exists dwh_dim_yelp_user_details;
create table dwh_dim_yelp_user_details (
  user_id string,
  average_stars float,
  compliment_cool integer,
  compliment_cute integer,
  compliment_funny integer,
  compliment_hot integer,
  compliment_list integer,
  compliment_more integer,
  compliment_note integer,
  compliment_photos integer,
  compliment_plain integer,
  compliment_profile integer,
  compliment_writer integer,
  cool integer,
  elite array,
  fans integer,
  friends array,
  funny integer,
  user_name string,
  review_count integer,
  useful integer,
  yelp_user_date string
);

insert into dwh_dim_yelp_user_details
select distinct user_id,
                average_stars,
                compliment_cool,
                compliment_cute,
                compliment_funny,
                compliment_hot,
                compliment_list,
                compliment_more,
                compliment_note,
                compliment_photos,
                compliment_plain,
                compliment_profile,
                compliment_writer,
                cool,
                elite,
                fans,
                friends,
                funny,
                user_name,
                review_count,
                useful,
                yelp_user_date
from "UDACITYPROJECT"."ODS"."ODS_YELP_USER_DETAILS";

drop table if exists dwh_dim_lv_temperature_details;
create table dwh_dim_lv_temperature_details (
  temperature_date string,
  temp_min string,
  temp_max string,
  normal_min string,
  normal_max string
);

insert into dwh_dim_lv_temperature_details(temperature_date, temp_min, temp_max, normal_min, normal_max)
select distinct (left(temperature_date, 4) || '-' || substr(temperature_date,5,2) || '-' || substr(temperature_date,7,2)),
                temp_min,
                temp_max,
                normal_min,
                normal_max
from "UDACITYPROJECT"."ODS"."ODS_LV_TEMPERATURE_DETAILS";

drop table if exists dwh_dim_lv_precipitation_details;
create table dwh_dim_lv_precipitation_details (
  precipitation_date string,
  precipitation string,
  precipitation_normal string
);

insert into dwh_dim_lv_precipitation_details(precipitation_date, precipitation, precipitation_normal)
select distinct (left(precipitation_date, 4) || '-' || substr(precipitation_date,5,2) || '-' || substr(precipitation_date,7,2)),
                precipitation,
                precipitation_normal
from "UDACITYPROJECT"."ODS"."ODS_LV_PRECIPITATION_DETAILS";

drop table if exists dwh_dim_yelp_review_details;
create table dwh_dim_yelp_review_details (
  review_id string,
  cool integer,
  review_date string,
  funny integer,
  stars integer,
  review_text string,
  review_useful integer
 );

insert into dwh_dim_yelp_review_details(review_id, cool, review_date, funny, stars, review_text, review_useful)
select distinct review_id,
                cool,
                left(review_date, 10),
                funny,
                stars,
                text as review_text,
                review_useful
from "UDACITYPROJECT"."ODS"."ODS_YELP_REVIEW_DETAILS";

drop table if exists dwh_fact_yelp_restaurant_review;
create table dwh_fact_yelp_restaurant_review(
    business_id string,
    business_name string,
    review_id string,
    review_date string,
    user_id string,
    user_name string,
    temperature_date string,
    precipitation_date string,
    checkin_id int,
    checkin_date string,
    tip_id int,
    tip_text string,
    covid_id int,
    highlights string,
  constraint fk_business_id foreign key (business_id) references ODS.ODS_YELP_BUSINESS_DETAILS(business_id),
  constraint fk_review_id foreign key (review_id) references ODS.ODS_YELP_REVIEW_DETAILS(review_id),
  constraint fk_user_id foreign key (user_id) references ODS.ODS_YELP_USER_DETAILS(user_id),
  constraint fk_temperature_date foreign key (temperature_date) references ODS.ODS_LV_TEMPERATURE_DETAILS(temperature_date),
  constraint fk_precipitation_date foreign key (precipitation_date) references ODS.ODS_LV_PRECIPITATION_DETAILS(precipitation_date),
  constraint fk_checkin_id foreign key (checkin_id) references ODS.ODS_YELP_CHECKIN_DETAILS(checkin_id),
  constraint fk_tip_id foreign key (tip_id) references ODS.ODS_YELP_TIP_DETAILS(tip_id),
  constraint fk_covid_id foreign key (covid_id) references ODS.ODS_YELP_COVID_DETAILS(covid_id)
 );

insert into dwh_fact_yelp_restaurant_review
select distinct b.business_id,
                b.business_name,
                r.review_id,
                left(r.review_date, 10),
                u.user_id,
                u.user_name,
                (left(t.temperature_date, 4) || '-' || substr(t.temperature_date,5,2) || '-' || substr(t.temperature_date,7,2)),
                (left(p.precipitation_date, 4) || '-' || substr(p.precipitation_date,5,2) || '-' || substr(p.precipitation_date,7,2)),
                c.checkin_id,
                c.checkin_date,
                i.tip_id,
                i.tip_text,
                v.covid_id,
                v.highlights
from  ODS.ODS_YELP_BUSINESS_DETAILS as b,
      ODS.ODS_YELP_REVIEW_DETAILS as r,
      ODS.ODS_YELP_USER_DETAILS as u,
      ODS.ODS_LV_TEMPERATURE_DETAILS as t,
      ODS.ODS_LV_PRECIPITATION_DETAILS as p,
      ODS.ODS_YELP_CHECKIN_DETAILS as c,
      ODS.ODS_YELP_TIP_DETAILS as i,
      ODS.ODS_YELP_COVID_DETAILS as v
WHERE (b.business_id = r.business_id)
  and (r.user_id = u.user_id)
  and (left(r.review_date, 10) = (left(temperature_date, 4) || '-' || substr(temperature_date,5,2) || '-' || substr(temperature_date,7,2)))
  and (left(r.review_date, 10) = (left(precipitation_date, 4) || '-' || substr(precipitation_date,5,2) || '-' || substr(precipitation_date,7,2)))
  and (i.user_id = u.user_id)
  and (b.business_id = v.business_id)
  and (b.business_id = c.business_id);
