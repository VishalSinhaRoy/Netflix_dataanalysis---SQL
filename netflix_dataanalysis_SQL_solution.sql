-- Netflix Project 
-- Solution started

-- Different type of content Netflix carries
select distinct type 
from netflix;

select type, count(*) as content_counts
from netflix
group by type;


-- Percentage of different type of content in Netflix
select type, count(*) as content_counts, (count(*)*100.0/(select count(*) from netflix)) as percentage
from netflix
group by type;


-- Find the most common rating for the movies and TV shows
select type, rating
from 
	(select type, rating, count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by 1, 2) as tb
where ranking=1;


-- Release all the movies released in covid
select * from netflix
where type='Movie' and release_year=2020;


-- Which year has the highest number of release
select release_year, count(*) as max_release 
from netflix
group by release_year
order by max_release desc
limit 1;


-- Find the top 10 countries with the mostcontent on netflix
select unnest(string_to_array(country, ',')) as new_country, count(*) as total_content 
from netflix
group by 1
order by 2 desc
limit 10;


-- Identify the longest movie
select max(cast(split_part(duration, ' ', 1)as int))as longest_duration 
from netflix
where type='Movie';


-- Identify the longest tv show
select max(cast(split_part(duration, ' ', 1)as int))as longest_duration 
from netflix
where type='TV Show';


-- Average duration of movies and tv shows
select type, avg(cast(split_part(duration, ' ', 1)as int))as avg_movie_duration
from netflix
where type = 'Movie'
group by type
union all
select type, avg(cast(split_part(duration, ' ', 1)as int))as avg_tvshow_seasons
from netflix
where type='TV Show'
group by type;


-- Find the content that was added in recent 5 years
select *
from netflix
where to_date(date_added, 'Month DD, YYY')>=current_date-interval'5 years';


-- Find  all the movies/TV shows by director Rajiv Chilaka
select * 
from netflix
where director ilike '%Rajiv Chilaka%';


-- List all the TV shows with more than 5 seasons
select *, cast(split_part(duration, ' ', 1)as int) as seasons
from netflix
where type='TV Show' and cast(split_part(duration, ' ', 1)as int)>5;


-- Most common genres
select genre, count(*) as genre_count
from
	(select unnest(string_to_array(listed_in, ', ')) as genre
from netflix) as genres
group by 1
order by 2 desc;


-- Count the number of content item in each genre
select unnest(string_to_array(listed_in, ', '))as genre, count(*) as total_content
from netflix
group by 1;


-- Find the movie and title which contains multi-genre content in them
select type, title, array_length(string_to_array(listed_in, ', '),1)as count_of_genres
from netflix
where type='Movie' and array_length(string_to_array(listed_in, ', '),1)>1;


-- Find the Tv show and title which contains multi-genre content in them
select type, title, array_length(string_to_array(listed_in, ', '),1)as count_of_genres
from netflix
where type='TV Show' and array_length(string_to_array(listed_in, ', '),1)>1;


-- Find each year and the average number of content released by India on netflix
select extract(year from to_date(date_added, 'Month DD, YYYY'))as year, 
	count(*)as yearwise_content,
	count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100 as avg_content_per_year
from netflix
where country='India'
group by 1;


-- List all the movies that are documentaries
select *
from netflix
where listed_in ilike '%documentaries%';


-- Find all the content without a director
select * 
from netflix
where director is null;


-- Find how many movies actor Amitabh Bachchan appeared in last 10 years
select * 
from netflix
where cast_ ilike '%Amitabh Bachchan%' and release_year>extract(year from current_date)-10;


-- Find the top actors who have appeared in the highest number of movies produced in india
select unnest(string_to_array(cast_, ', ')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10;
	

-- Find the top directors and their most frequent actors/actresses
select director, unnest(string_to_array(cast_, ', '))as actor, count(*)as collaboration_count
from netflix
where director is not null and cast_ is not null
group by 1, 2
order by 3 desc
limit 10;


-- Who are the directors having most content in netflix
select director, count(*)as content_count
from netflix
where director is not null
group by 1
order by 2 desc
limit 10;


-- Categorize the content based on the keywords 'kill', 'violence' and 'sex' etc. Label them as '18+', 'bad' and rest as 'good'
with cte_table as
(select *,
	case
	when description ilike '%sex%' or description ilike '%rape%' then '18+_content'
	when description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
	else 'Normal_content'
	end as content_category
from netflix)
select content_category, count(*) as total_content
from cte_table
group by 1;