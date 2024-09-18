-- Schema Design of Netflix

drop table if exists netflix;
create table netflix
(
	show_id varchar(6),
	type varchar(10),
	title char(150),
	director char(210),
	cast_ char(800),
	country char(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in char(80),
	description varchar(250)
);

select * from netflix;