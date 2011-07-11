/*  
Script modified for LACMTA from original 
contributed by Michael Perkins

example usage:
cat load.sql | mysql -u root
(assumes user is in same directory as GTFS source files)
*/


# +++++++ shapes.txt +++++++
# shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence
# 20068_1210,34.0547148859,-118.495558514,10001


CREATE DATABASE IF NOT EXISTS metro_gtfs;
USE metro_gtfs

# +++++++ agency.txt +++++++
# agency_name,agency_url,agency_timezone,agency_lang,agency_phone
# "Metro - Los Angeles",http://www.metro.net,America/Los_Angeles,en,"323.GO.METRO"

DROP TABLE IF EXISTS agency;

CREATE TABLE `agency` (
    agency_name VARCHAR(255),
    agency_url VARCHAR(255),
    agency_timezone VARCHAR(50),
    agency_phone VARCHAR(50),
    agency_id int(11) DEFAULT 0
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'agency.txt' INTO TABLE agency FIELDS TERMINATED BY ',' IGNORE 1 LINES;

# +++++++ calendar.txt +++++++
# service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
# DEC10-D01CAR-3_Sunday-99,0,0,0,0,0,0,1,20101212,20110619

DROP TABLE IF EXISTS calendar;

CREATE TABLE `calendar` (
    service_id VARCHAR(50),
	monday TINYINT(1),
	tuesday TINYINT(1),
	wednesday TINYINT(1),
	thursday TINYINT(1),
	friday TINYINT(1),
	saturday TINYINT(1),
	sunday TINYINT(1),
	start_date VARCHAR(10),	
	end_date VARCHAR(10),
	KEY `service_id` (service_id)
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'calendar.txt' INTO TABLE calendar FIELDS TERMINATED BY ',' IGNORE 1 LINES;


# +++++++ calendar_dates.txt +++++++
# service_id,date,exception_type
# DEC10-D01CAR-3_Sunday-99,20101225,1

DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE `calendar_dates` (
    service_id VARCHAR(50),
    `date` VARCHAR(8),
    exception_type INT(2),
    KEY `service_id` (service_id),
    KEY `exception_type` (exception_type)    
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'calendar_dates.txt' INTO TABLE calendar_dates FIELDS TERMINATED BY ',' IGNORE 1 LINES;


# +++++++ routes.txt +++++++
# route_id,route_short_name,route_long_name,route_desc,route_type,route_color,route_text_color,route_url
# 2-13047,	2/302,	Metro Local							,	,3,	,		,
# 761-13047,761,	Metro Rapid (Possible I-405 Detour)	,	,3,	000000,FFFFFF,http://www.metro.net/projects/I-405/


DROP TABLE IF EXISTS routes;

CREATE TABLE `routes` (
    route_id VARCHAR(50) PRIMARY KEY,
	route_short_name VARCHAR(50),
	route_long_name VARCHAR(255) NULL,
	route_desc TEXT,
	route_type INT(2) DEFAULT 0,
	route_color VARCHAR(6) DEFAULT "6699cc",
	route_text_color VARCHAR(6) DEFAULT "000000",
	route_url VARCHAR(50) DEFAULT "http://metro.net/lines/",
	agency_id INT(11) DEFAULT 1,
	KEY `route_short_name` (route_short_name)
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'routes.txt' INTO TABLE routes FIELDS TERMINATED BY ',' IGNORE 1 LINES;



# +++++++ stops.txt +++++++
# stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,stop_url
# 1,1,Paramount / Slauson,,33.973248,-118.113113, 

DROP TABLE IF EXISTS stops;

CREATE TABLE `stops` (
    stop_id INT(12) PRIMARY KEY,
	stop_code INT(11) ,
	stop_name VARCHAR(255),
	stop_desc VARCHAR(255),
	stop_lat DECIMAL(8,6),
	stop_lon DECIMAL(9,6),
	stop_url VARCHAR(50),
	zone_id INT(11) DEFAULT NULL,
	KEY `stop_lat` (stop_lat),
	KEY `stop_lon` (stop_lon)
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'stops.txt' INTO TABLE stops FIELDS TERMINATED BY ',' IGNORE 1 LINES;

# +++++++ trips.txt +++++++
# route_id,service_id,trip_id,trip_headsign,block_id,shape_id
# 460-13047,DEC10-D01CAR-1_Weekday-99,25842120,,7138371,4600097_1210

DROP TABLE IF EXISTS trips;

CREATE TABLE `trips` (
    route_id VARCHAR(50),
	service_id VARCHAR(50),
	trip_id VARCHAR(32) PRIMARY KEY,
	trip_headsign VARCHAR(255),
	block_id INT(11),
	shape_id VARCHAR(50),
	direction_id TINYINT(1),
	KEY `route_id` (route_id),
	KEY `service_id` (service_id),
	KEY `direction_id` (direction_id),
	KEY `block_id` (block_id)
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'trips.txt' INTO TABLE trips FIELDS TERMINATED BY ',' IGNORE 1 LINES;

# +++++++ transfers.txt +++++++
# from_stop_id,to_stop_id,transfer_type
# 80000078,80000028,0

DROP TABLE IF EXISTS transfers;

CREATE TABLE `transfers` (
    from_stop_id int(12),
    to_stop_id int(12),
	transfer_type INT(3),
	KEY `from_stop_id` (from_stop_id),
	KEY `to_stop_id` (to_stop_id),
	KEY `transfer_type` (transfer_type)
)ENGINE=InnoDB  ;

LOAD DATA LOCAL INFILE 'transfers.txt' INTO TABLE trips FIELDS TERMINATED BY ',' IGNORE 1 LINES;


# +++++++ stop_times.txt +++++++
# trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type
# 25842120,04:20:00,04:20:00,8634,1,460 Disneyland,0,0

DROP TABLE IF EXISTS stop_times;

CREATE TABLE `stop_times` (
    trip_id VARCHAR(32),
	arrival_time time,
	departure_time time,
	stop_id INT(12),
	stop_sequence INT(11),
	stop_headsign VARCHAR(255),
	pickup_type INT(2),
	drop_off_type INT(2),
	KEY `trip_id` (trip_id),
	KEY `stop_id` (stop_id),
	KEY `stop_sequence` (stop_sequence),
	KEY `pickup_type` (pickup_type),
	KEY `drop_off_type` (drop_off_type)
)ENGINE=InnoDB ;

LOAD DATA LOCAL INFILE 'stop_times.txt' INTO TABLE stop_times FIELDS TERMINATED BY ',' IGNORE 1 LINES;



