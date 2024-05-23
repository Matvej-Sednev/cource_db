set search_path='course';

create sequence sq_location_id;

--add data
COPY course.rates(since, cost) FROM 'C:/hhh/db/course_work/Rates.csv' DELIMITER ';' CSV;
copy locations(city, street, house, flat) from 'C:\hhh\db\course_work\Locations.csv' delimiter ',' csv;
copy types(name, unit) from 'C:\hhh\db\type_counters.csv' delimiter ',' csv;
copy users(name, surname) from 'C:\hhh\db\Code_data_all_name.csv' delimiter ',' csv;
--copy measurements(value, mark) from 'C:\hhh\db\course_work\counter2.csv' delimiter ',' csv;
--copy types(name, unit) from 'C:\hhh\db\type_counters.csv' delimiter ',' csv; 
--copy locations(city, street, house, flat) from 'C:\hhh\db\course_work\Locations.csv' delimiter ',' csv;

create or replace procedure counter_gen() as
	$$
	DECLARE 
	i integer := 0;
	begin
	loop
		 insert into counters (location_id, type_id)
		 values (nextval('sq_location_id'), random()*(7-1)+1);
		 i:=i+1;
		 exit when i>6;
		end loop;
	end;
	$$ language plpgsql;


create or replace procedure insert_measur() as 
	$$
	declare 
	i integer := 1;
	begin
		loop
		create temporary table tp_counter (value float, mark timestamp);
		--if i = 1 then
			--copy tp_counter from 'C:\hhh\db\course_work\counter1.csv' delimiter ',' csv;
		if i = 1 then
			copy tp_counter from 'C:\hhh\db\course_work\counter2.csv' delimiter ',' csv;
		elsif i = 2 then
			copy tp_counter from 'C:\hhh\db\course_work\counter3.csv' delimiter ',' csv;
		elsif i = 3 then
			copy tp_counter from 'C:\hhh\db\course_work\counter4.csv' delimiter ',' csv;
		elsif i = 4 then
			copy tp_counter from 'C:\hhh\db\course_work\counter5.csv' delimiter ',' csv;
		elsif i = 5 then
			copy tp_counter from 'C:\hhh\db\course_work\counter6.csv' delimiter ',' csv;
			end if;
		insert into measurements (users_id, counter_id, value, mark)
		select i,i, value, mark from tp_counter;
		drop table if exists tp_counter;
		i := i + 1;
			exit when i > 4;
		end loop;
	end;
	$$language plpgsql;
call counter_gen();
call insert_measur();


