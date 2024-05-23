drop schema if exists course cascade;
create schema course;

set search_path = 'course';

create sequence sq_users_id;
create sequence sq_types_id;
create sequence sq_locations_id;
create sequence sq_rates_id;
create sequence sq_counters_id;
create sequence sq_measurements_id;

create table users (
	id integer default nextval('sq_users_id') primary key,
	name varchar(25) not null,
	surname varchar(50) not null);
create table types (
	id integer default nextval('sq_types_id') primary key,
	name varchar(50) not null,
	unit varchar(5) not null);

create table locations (
	id integer default nextval('sq_locations_id') primary key,
	city varchar(75) not null,
	street varchar(75) not null,
	house integer not null,
	flat integer not null);

create table rates (
	id integer default nextval('sq_rates_id') primary key,
	since timestamp,
	cost float);

create table counters (
	id integer default nextval('sq_counters_id') primary key,
	location_id integer not null,
	type_id integer not null,
	rate_id integer,
	foreign key (location_id) references locations(id),
	foreign key (type_id) references types(id),
	foreign key (rate_id) references rates(id));

create table measurements (
	id integer default nextval('sq_measurements_id') primary key,
	users_id integer not null,
	counter_id integer not null,
	mark timestamp not null, 
	value float not null,
	foreign key (counter_id) references counters(id),
	foreign key (users_id) references users(id));



alter table counters add constraint fk_counters_locations foreign key (location_id) references locations (id) on delete cascade;
alter table counters add constraint fk_counters_types foreign key (type_id) references types (id) on delete cascade;
alter table counters add constraint fk_counters_rates foreign key (rate_id) references rates (id) on delete cascade;
alter table measurements add constraint fk_measurements_counters foreign key (counter_id) references counters (id) on delete cascade;

--check
alter table locations add constraint chk_locations_city_length check (length (city) >= 2);
alter table locations add constraint chk_locations_street_length check (length (street) >= 2);
alter table locations add constraint chk_locations_house_positive check (house > 0);
alter table locations add constraint chk_locations_flat_positive check (flat > 0);

alter table rates add constraint chk_rates_since_after_date check (since >= '2020-01-01'::timestamp);
alter table rates add constraint chk_rates_since_cost_positive_or_zero check (cost > 0.0);

create function fn_last_counter_value(counter integer) returns float language sql as $$
		select value from measurements where counter_id = counter order by mark desc limit 1; 
	$$;

alter table measurements add constraint chk_measurements_mark_after_date check (mark >= '2020-01-01'::timestamp);
alter table measurements add constraint chk_measurements_mark_not_in_future check (mark < now());
alter table measurements add constraint chk_measurements_value_positive_or_zero check (value >= 0.0);





