drop table if exists ods_yelp_business_details;
create table ods_yelp_business_details (
  address string,
  attributes object,
  business_id string,
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
  state string,
  constraint pk_business_id primary key (business_id)
);

insert into ods_yelp_business_details
select
  BUSINESSJSON:address,
  BUSINESSJSON:attributes,
  BUSINESSJSON:business_id,
  BUSINESSJSON:categories,
  BUSINESSJSON:city,
  BUSINESSJSON:hours,
  BUSINESSJSON:is_open,
  BUSINESSJSON:latitude,
  BUSINESSJSON:longitude,
  BUSINESSJSON:name as business_name,
  BUSINESSJSON:postal_code,
  BUSINESSJSON:review_count,
  BUSINESSJSON:stars,
  BUSINESSJSON:state
from "UDACITYPROJECT"."STAGING"."BUSINESS";

drop table if exists ods_yelp_checkin_details;
create table ods_yelp_checkin_details (
  checkin_id int autoincrement,
  business_id string,
  checkin_date string,
  constraint pk_checkin_id primary key (checkin_id),
  constraint fk_checkin_business_id foreign key (business_id) references ods_yelp_business_details(business_id)
);

insert into ods_yelp_checkin_details(business_id, checkin_date)
select
  CHECKINJSON:business_id,
  CHECKINJSON:date as checkin_date
from "UDACITYPROJECT"."STAGING"."CHECKIN";

drop table if exists ods_yelp_covid_details;
create table ods_yelp_covid_details (
  covid_id int autoincrement,
  Call_To_Action_enabled string,
  Covid_Banner string,
  Grubhub_enabled string,
  Request_a_Quote_Enabled string,
  Temporary_Closed_Until string,
  Virtual_Services_Offered string,
  business_id string,
  delivery_or_takeout string,
  highlights string,
  constraint pk_covid_id primary key (covid_id),
  constraint fk_covid_business_id foreign key (business_id) references ods_yelp_business_details(business_id)
);

insert into ods_yelp_covid_details(Call_To_Action_enabled, Covid_Banner, Grubhub_enabled, Request_a_Quote_Enabled, Temporary_Closed_Until, Virtual_Services_Offered, business_id, delivery_or_takeout, highlights)
select
  COVIDJSON:"Call To Action enabled" as Call_To_Action_enabled,
  COVIDJSON:"Covid Banner" as Covid_Banner,
  COVIDJSON:"Grubhub enabled" as Grubhub_enabled,
  COVIDJSON:"Request a Quote Enabled" as Request_a_Quote_Enabled,
  COVIDJSON:"Temporary Closed Until" as Temporary_Closed_Until,
  COVIDJSON:"Virtual Services Offered" as Virtual_Services_Offered,
  COVIDJSON:business_id,
  COVIDJSON:"delivery or takeout" as delivery_or_takeout,
  COVIDJSON:"highlights" as highlights
from "UDACITYPROJECT"."STAGING"."COVID";

drop table if exists ods_yelp_user_details;
create table ods_yelp_user_details (
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
  user_id string,
  yelp_user_date string,
  constraint pk_user_id primary key (user_id)
);

insert into ods_yelp_user_details
select
  USERJSON:average_stars,
  USERJSON:compliment_cool,
  USERJSON:compliment_cute,
  USERJSON:compliment_funny,
  USERJSON:compliment_hot,
  USERJSON:compliment_list,
  USERJSON:compliment_more,
  USERJSON:compliment_note,
  USERJSON:compliment_photos,
  USERJSON:compliment_plain,
  USERJSON:compliment_profile,
  USERJSON:compliment_writer,
  USERJSON:cool,
  USERJSON:elite,
  USERJSON:fans,
  USERJSON:friends,
  USERJSON:funny,
  USERJSON:name as user_name,
  USERJSON:review_count,
  USERJSON:useful,
  USERJSON:user_id,
  USERJSON:yelping_since as yelp_user_date
from "UDACITYPROJECT"."STAGING"."USER";

drop table if exists ods_yelp_tip_details;
create table ods_yelp_tip_details (
  tip_id int autoincrement,
  business_id string,
  compliment_count integer,
  date string,
  tip_text string,
  user_id string,
  constraint pk_tip_id primary key (tip_id),
  constraint fk_tip_user_id foreign key (user_id) references ods_yelp_user_details(user_id)
);

insert into ods_yelp_tip_details(business_id, compliment_count, date, tip_text, user_id)
select
  TIPJSON:business_id,
  TIPJSON:compliment_count,
  TIPJSON:date,
  TIPJSON:text as tip_text,
  TIPJSON:user_id
from "UDACITYPROJECT"."STAGING"."TIP";

drop table if exists ods_lv_temperature_details;
create table ods_lv_temperature_details (
  temperature_date string,
  temp_min string,
  temp_max string,
  normal_min string,
  normal_max string,
  constraint pk_temperature_date primary key (temperature_date)
);

insert into ods_lv_temperature_details(temperature_date, temp_min, temp_max, normal_min, normal_max)
select
  date as temperature_date,
  min as temp_min,
  max as temp_max,
  normal_min,
  normal_max
from "UDACITYPROJECT"."STAGING"."TEMPERATURE";

drop table if exists ods_lv_precipitation_details;
create table ods_lv_precipitation_details (
  precipitation_date string,
  precipitation string,
  precipitation_normal string,
  constraint pk_precipitation_date primary key (precipitation_date)
);

insert into ods_lv_precipitation_details(precipitation_date, precipitation, precipitation_normal)
select
  date as precipitation_date,
  precipitation,
  precipitation_normal
from "UDACITYPROJECT"."STAGING"."PRECIPITATION";


drop table if exists ods_yelp_review_details;
create table ods_yelp_review_details (
  business_id string,
  cool integer,
  review_date string,
  funny integer,
  review_id string,
  stars integer,
  text string,
  review_useful integer,
  user_id string,
  constraint pk_review_id primary key (review_id),
  constraint fk_review_business_id foreign key (business_id) references ods_yelp_business_details(business_id),
  constraint fk_review_user_id foreign key (user_id) references ods_yelp_user_details(user_id),
  constraint fk_review_precipitation_date foreign key (review_date) references ods_lv_precipitation_details(precipitation_date),
  constraint fk_review_temperature_date foreign key (review_date) references ods_lv_temperature_details(temperature_date)
);

insert into ods_yelp_review_details
select
  REVIEWJSON:business_id,
  REVIEWJSON:cool,
  REVIEWJSON:date,
  REVIEWJSON:funny,
  REVIEWJSON:review_id,
  REVIEWJSON:stars,
  REVIEWJSON:text,
  REVIEWJSON:useful as review_useful,
  REVIEWJSON:user_id
from "UDACITYPROJECT"."STAGING"."REVIEW";





