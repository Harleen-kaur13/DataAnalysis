CREATE TABLE apple_store_description_combined AS
SELECT * from appleStore_description1
UNION ALL
SELECT * from appleStore_description2
UNION ALL
SELECT * from appleStore_description3
UNION ALL
SELECT * from appleStore_description4

**EXPLORATORY DATA Analysis **
--check the number  of distinct apps in both applestore

SELECT count(DISTINCT id) as distinct_app_id
from AppleStore

SELECT COUNT(DISTINCT id) as distinct_app_id
from apple_store_description_combined


--check for missing value 
SELECT COUNT(*) as Missing_values
from AppleStore where track_name is NULL or user_rating is NULL or prime_genre is NULL

SELECT COUNT(*) as Missing_values
from apple_store_description_combined where app_desc is NULL 


--finding number of apps per genre 
SELECT prime_genre,COUNT(*) as Num_apps
from AppleStore
group by prime_genre
order BY Num_apps DESC


SELECT min(user_rating)as Min_rating,
       max(user_rating)as max_rating,
       avg(user_rating)as avg_rating
from AppleStore



-- Checking if paid apps have higher rating than free app 
SELECT CASE
			WHEN price>0 then 'Paid'
   		    else 'Free'
       END AS app_type, 
       avg(user_rating) as avg_rating
from AppleStore
group by app_type

-- checking the avg rating for the apps that support multiple languages 
select CASE
            when lang_num<10 then '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            else '>30 languages'
          end as language_bucket,
          avg(user_rating)as avg_rating
 from AppleStore
 group by language_bucket
 order by avg_rating desc
 
 --select genre with low rating 
 select prime_genre,
        avg(user_rating) as Avg_rating
from AppleStore
group BY prime_genre
order by Avg_rating ASC
limit 10

--check if there exist an correlation between app_rating and length of description

SELECT CASE
          when length(B.app_desc)<500 then 'Short'
          when length(B.app_desc) between 500 and 1000 then 'Medium'
          else 'Long'
      end as description_length_bucket,
      avg(A.user_rating) AS avg_rating
      
from AppleStore as A 
join apple_store_description_combined as B 
on A.id=B.id
GROUP BY description_length_bucket
order by avg_rating DESC

--check the top rated app per each genre 
select 
     prime_genre,
     track_name,
     user_rating
 FROM(
   select prime_genre,
   track_name,
   user_rating,
   RANK() over (partition by prime_genre order by user_rating desc,rating_count_tot desc) as rank
   from
   AppleStore
 ) as a
 where 
 a.rank=1