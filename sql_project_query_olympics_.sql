SELECT * FROM public.olympics_history 
SELECT * FROM public.olympics_history_noc_region

-- Write a SQL query to find the total no of Olympic Games held as per the dataset.

select count(distinct games) from olympics_history 

--Write a SQL query to list down all the Olympic Games held so far.

	
select distinct year , season , city 
from olympics_history 
order by year asc

	
	

--SQL query to fetch total no of countries participated in each olympic games.

select games , count(distinct noc) as total_countries_participated
from olympics_history 
group by games 
order by games  asc



--Write a SQL query to return the Olympic Games which had the highest participating countries
--and the lowest participating countries.

SELECT * FROM public.olympics_history 

select games  , count(distinct noc) as highest_participating_country 
from olympics_history 
group by games 
order by highest_participating_country  desc 


select games  , count(distinct noc) as Lowest_participating_country 
from olympics_history 
group by games 
order by lowest_participating_country  asc


-- by using CTE --

with participating_countries as(
	select games  , count(distinct noc) as olympic_participating_country 
	from olympics_history 
	group by games )

select games , olympic_participating_country 
from participating_countries
where olympic_participating_country =(select max(olympic_participating_country) from participating_countries)
or
olympic_participating_country =(select min(olympic_participating_country) from participating_countries);






5. Which nation has participated in all of the olympic games


SELECT NOC FROM (
          		SELECT DISTINCT NOC, Games
    			FROM OLYMPICS_HISTORY
				)  AS unique_participations

GROUP BY NOC
HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM OLYMPICS_HISTORY);




6.--Identify the sport which was played in all summer olympics.

with t1 as
          	(select count(distinct games) as total_games
          	from olympics_history where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from olympics_history where season = 'Summer'),
          t3 as
          	(select sport, count(games) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;





7. Which Sports were just played only once in the olympics.



SELECT Sport, COUNT(DISTINCT Games) AS no_of_games
FROM olympics_history
GROUP BY Sport
HAVING COUNT(DISTINCT Games) = 1;


by using cte 	


with t1 as
          	(select distinct games, sport
          	from olympics_history),
          t2 as
          	(select sport, count(games) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;




--8. Fetch the total no of sports played in each olympic games.


with t1 
as
(select distinct games, sport 
from olympics_history),
t2 
as
(select games , count(sport) as no_of_sport
from t1
group by games)

select * from t2
order by games asc



-- 	
-- 9. Fetch oldest athletes to win a gold medal 

with t1 as 
(select name , age , medal 
from public.olympics_history 
where medal='Gold' 
) ,
 
t2 as (
select name , age , medal 
from t1
where age != 'NA'
order by age desc)

select * from t2



-- 10  Find the Ratio of male and female athletes participated in all olympic games.



WITH t1 AS (SELECT COUNT(sex) AS total_count FROM public.olympics_history),
t2 AS (SELECT COUNT(sex) AS male_count FROM public.olympics_history WHERE sex = 'M'),
t3 AS (SELECT COUNT(sex) AS female_count FROM public.olympics_history WHERE sex = 'F')

SELECT
    CONCAT('1 : ', ROUND(t3.female_count::NUMERIC / t2.male_count::NUMERIC, 2)) AS male_to_female_ratio
FROM
    t1, t2, t3; 




-- 11 Fetch the top 5 athletes who have won the most gold medals. 

with t1 as
(select * from olympics_history 
where medal='Gold') ,

t2 as (
select name , count(medal) as max_medal 
	from t1 
	group by name 
  	order by max_medal desc
) 
select * from t2 




-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

select name , count(medal) as most_medal_by_person
from olympics_history  
where medal in ('Gold','Silver','Bronze')
group by name 
order by most_medal_by_person desc 
limit 5 ;






-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.


select distinct team  , count(medal) as most_medal_by_country 
from olympics_history  
where medal in ('Gold','Silver','Bronze')
group by team  
order by most_medal_by_country desc 



-- 14. List down total gold, silver and bronze medals won by each country.

select 
games as season , team as country  ,
sum(case when medal='Gold' then 1 else 0 end ) as gold_medal ,
sum(case when medal='Silver' then 1 else 0 end) as silver_medal ,
sum(case when medal='Bronze' then 1 else 0 end ) as bronze_medal 
from public.olympics_history 

where medal in ('Gold', 'Silver', 'Bronze')  
group by games , team
order by season , country ;



-- 15 List down total gold, silver and bronze medals won by each country 
--corresponding to each olympic games. 


select 
games as season , team as country  ,
sum(case when medal='Gold' then 1 else 0 end ) as gold_medal ,
sum(case when medal='Silver' then 1 else 0 end) as silver_medal ,
sum(case when medal='Bronze' then 1 else 0 end ) as bronze_medal 
from public.olympics_history 

where medal in ('Gold', 'Silver', 'Bronze')  
group by games , team
order by season , country ;



-- 16. In which Sport/event, India has won highest medals. 


with t1 as (
select * from olympics_history  
where noc='IND' ) , 

t2 as ( select sport , count(medal) as medal_won  
from t1 
where medal in ('Gold', 'Silver', 'Bronze')  
group by sport 
order by  medal_won  desc 
) 

select * from t2  




-- 20. Break down all olympic games where India won medal for Hockey 
-- and how many medals in each olympic games


with t1 as (
select * from olympics_history  
where noc='IND' and sport='Hockey' 
) , 
t2 as (
select distinct games , count(sport) as most_medal
from t1
group by games , team
order by games desc ) 

select * from t2 
