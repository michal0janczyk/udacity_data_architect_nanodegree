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
  name string,
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
  BUSINESSJSON:name,
  BUSINESSJSON:postal_code,
  BUSINESSJSON:review_count,
  BUSINESSJSON:stars,
  BUSINESSJSON:state
from "UDACITYPROJECT"."STAGING"."BUSINESS";

drop table if exists ods_yelp_checkin_details;
create table ods_yelp_checkin_details (
  business_id string,
  checkin_date string,
  constraint fk_checkin_business_id foreign key (business_id) references ods_yelp_business_details(business_id)
);

insert into ods_yelp_checkin_details
select
  CHECKINJSON:business_id,
  CHECKINJSON:date as checkin_date
from "UDACITYPROJECT"."STAGING"."CHECKIN";

drop table if exists ods_yelp_tip_details;
create table ods_yelp_tip_details (
  business_id string,
  compliment_count integer,
  date string,
  text string,
  user_id string,
  constraint fk_tip_business_id foreign key (business_id) references ods_yelp_business_details(business_id)
);

insert into ods_yelp_tip_details
select
  TIPJSON:business_id,
  TIPJSON:compliment_count,
  TIPJSON:date,
  TIPJSON:text,
  TIPJSON:user_id
from "UDACITYPROJECT"."STAGING"."TIP";

drop table if exists ods_yelp_covid_details;
create table ods_yelp_covid_details (
  Call_To_Action_enabled string,
  Covid_Banner string,
  Grubhub_enabled string,
  Request_a_Quote_Enabled string,
  Temporary_Closed_Until string,
  Virtual_Services_Offered string,
  business_id string,
  delivery_or_takeout string,
  highlights string,
  constraint fk_covid_business_id foreign key (business_id) references ods_yelp_business_details(business_id)
);

insert into ods_yelp_covid_details
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
  name string,
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
  USERJSON:name,
  USERJSON:review_count,
  USERJSON:useful,
  USERJSON:user_id,
  USERJSON:yelping_since as yelp_user_date
from "UDACITYPROJECT"."STAGING"."USER";

drop table if exists ods_lv_temperature_details;
create table ods_lv_temperature_details (
  lv_temperature_date string,
  temp_min string,
  temp_max string,
  normal_min string,
  normal_max string,
  constraint pk_temperature_date primary key (lv_temperature_date)
);

insert into ods_lv_temperature_details
select
  date as lv_temperature_date,
  min as temp_min,
  max as temp_max,
  normal_min,
  normal_max
from "UDACITYPROJECT"."STAGING"."TEMPERATURE";

drop table if exists ods_lv_precipitation_details;
create table ods_lv_precipitation_details (
  lv_precipitation_date string,
  precipitation string,
  precipitation_normal string,
  constraint pk_precipitation_details primary key (lv_precipitation_date)
);

insert into ods_lv_precipitation_details
select
  date as lv_precipitation_date,
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
  useful integer,
  user_id string,
  constraint pk_review_id primary key (review_id),
  constraint fk_review_business_id foreign key (business_id) references ods_yelp_business_details(business_id),
  constraint fk_review_user_id foreign key (user_id) references ods_yelp_user_details(user_id),
  constraint fk_review_precipitation_date foreign key (review_date) references ods_lv_temperature_details(lv_temperature_date),
  constraint fk_review_temperature_date foreign key (review_date) references ods_lv_precipitation_details(lv_precipitation_date)
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
  REVIEWJSON:useful,
  REVIEWJSON:user_id
from "UDACITYPROJECT"."STAGING"."REVIEW";





