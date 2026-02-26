USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT 'movie' AS table_name, COUNT(*) AS total_rows FROM movie
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'director_mapping', COUNT(*) FROM director_mapping
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worldwide_gross_income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Q3 Part 1: Total number of movies released each year

SELECT 
    year AS Year,
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- Q3 Part 2: Total number of movies released month wise

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;
-- Insight:
-- Peak Months:
-- March (824) – Highest
-- September (809)
-- January (804)
-- October (801)
-- These months show strong release activity.

-- Low Activity Months:
-- December (438) – Lowest
-- July (493)
-- Clear dip observed in these months.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(id) AS number_of_movies
FROM movie
WHERE year = 2019
AND (
        country LIKE '%USA%'
     OR country LIKE '%India%'
    );




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Q5. Find the unique list of genres present in the dataset

SELECT DISTINCT genre
FROM genre
ORDER BY genre;




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:



SELECT 
    g.genre,
    COUNT(g.movie_id) AS number_of_movies
FROM genre g
GROUP BY g.genre
ORDER BY number_of_movies DESC
LIMIT 1;






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Q7. How many movies belong to only one genre?

SELECT 
    COUNT(*) AS movies_with_one_genre
FROM (
        SELECT 
            movie_id,
            COUNT(genre) AS genre_count
        FROM genre
        GROUP BY movie_id
        HAVING COUNT(genre) = 1
     ) AS single_genre_movies;





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Q8. What is the average duration of movies in each genre?

SELECT 
    g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration
FROM movie m
JOIN genre g 
    ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;








-- Q9. Rank of 'Thriller' genre based on number of movies


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
    genre,
    movie_count,
    genre_rank
FROM (
        SELECT 
            g.genre,
            COUNT(g.movie_id) AS movie_count,
            RANK() OVER (ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
        FROM genre g
        GROUP BY g.genre
     ) AS ranked_genres
WHERE genre = 'Thriller';










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Q10. Minimum and maximum values in ratings table

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
-- Q11. Top 10 movies based on average rating

SELECT 
    title,
    avg_rating,
    movie_rank
FROM (
        SELECT 
            m.title,
            r.avg_rating,
            RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
     ) AS ranked_movies
WHERE movie_rank <= 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Q12. Movie count grouped by median rating

SELECT 
    median_rating,
    COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
    production_company,
    movie_count,
    prod_company_rank
FROM (
        SELECT 
            m.production_company,
            COUNT(m.id) AS movie_count,
            RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        WHERE r.avg_rating > 8
          AND m.production_company IS NOT NULL
        GROUP BY m.production_company
     ) AS ranked_production
WHERE prod_company_rank = 1;









-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. Movies per genre in March 2017 (USA) with more than 1000 votes

SELECT 
    g.genre,
    COUNT(DISTINCT m.id) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
WHERE m.year = 2017
  AND MONTH(m.date_published) = 3
  AND m.country LIKE '%USA%'
  AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Q15. Movies starting with 'The' having avg_rating > 8

SELECT 
    m.title,
    r.avg_rating,
    g.genre
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
-- Q16. Movies released between 1 April 2018 and 1 April 2019
-- with median rating = 8

SELECT 
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND r.median_rating = 8;








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
--

-- Total votes for German movies
SELECT 
    'Germany' AS country,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.country LIKE '%Germany%'

UNION ALL

-- Total votes for Italian movies
SELECT 
    'Italy' AS country,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.country LIKE '%Italy%';







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


-- Q18. Find null values in names table

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Q19. Top three directors in top three genres with avg_rating > 8

SELECT 
    n.name AS director_name,
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
JOIN director_mapping dm 
    ON m.id = dm.movie_id
JOIN names n 
    ON dm.name_id = n.id

-- Join top 3 genres (derived table instead of IN + LIMIT)
JOIN (
        SELECT g2.genre
        FROM genre g2
        JOIN ratings r2 
            ON g2.movie_id = r2.movie_id
        WHERE r2.avg_rating > 8
        GROUP BY g2.genre
        ORDER BY COUNT(g2.movie_id) DESC
        LIMIT 3
     ) AS top_genres
ON g.genre = top_genres.genre

WHERE r.avg_rating > 8

GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Q20. Top two actors whose movies have median_rating >= 8

SELECT 
    n.name AS actor_name,
    COUNT(m.id) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN role_mapping rm 
    ON m.id = rm.movie_id
JOIN names n 
    ON rm.name_id = n.id
WHERE r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Q21. Top three production houses based on total votes

SELECT 
    production_company,
    vote_count,
    prod_comp_rank
FROM (
        SELECT 
            m.production_company,
            SUM(r.total_votes) AS vote_count,
            RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        WHERE m.production_company IS NOT NULL
        GROUP BY m.production_company
     ) AS ranked_production
WHERE prod_comp_rank <= 3;










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM (
        SELECT 
            n.name AS actor_name,
            SUM(r.total_votes) AS total_votes,
            COUNT(DISTINCT m.id) AS movie_count,
            ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
            RANK() OVER (
                ORDER BY 
                    (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC,
                    SUM(r.total_votes) DESC
            ) AS actor_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        JOIN role_mapping rm 
            ON m.id = rm.movie_id
        JOIN names n 
            ON rm.name_id = n.id
        WHERE m.country LIKE '%India%'
          AND rm.category = 'actor'
        GROUP BY n.name
        HAVING COUNT(DISTINCT m.id) >= 5
     ) AS ranked_actors
WHERE actor_rank = 1;








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Q23. Top five actresses in Hindi movies released in India

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM (
        SELECT 
            n.name AS actress_name,
            SUM(r.total_votes) AS total_votes,
            COUNT(DISTINCT m.id) AS movie_count,
            ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
            RANK() OVER (
                ORDER BY 
                    (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC,
                    SUM(r.total_votes) DESC
            ) AS actress_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        JOIN role_mapping rm 
            ON m.id = rm.movie_id
        JOIN names n 
            ON rm.name_id = n.id
        WHERE m.country LIKE '%India%'
          AND m.languages LIKE '%Hindi%'
          AND rm.category = 'actress'
        GROUP BY n.name
        HAVING COUNT(DISTINCT m.id) >= 3
     ) AS ranked_actresses
WHERE actress_rank <= 5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/
-- Q24. Classify thriller movies with at least 25,000 votes

SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
WHERE g.genre = 'Thriller'
  AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;










/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Q25. Genre-wise running total and moving average of avg duration

SELECT 
    genre,
    avg_duration,
    
    -- Running total
    ROUND(SUM(avg_duration) OVER (ORDER BY genre), 2) AS running_total_duration,
    
    -- Moving average
    ROUND(AVG(avg_duration) OVER (ORDER BY genre), 2) AS moving_avg_duration

FROM (
        SELECT 
            g.genre,
            ROUND(AVG(m.duration), 2) AS avg_duration
        FROM movie m
        JOIN genre g 
            ON m.id = g.movie_id
        GROUP BY g.genre
     ) AS genre_avg;
-- out put for genre wise movinf avg
/* # genre, avg_duration, running_total_duration, moving_avg_duration
'Action', '112.88', '112.88', '112.88'
'Adventure', '101.87', '214.75', '107.38'
'Comedy', '102.62', '317.37', '105.79'
'Crime', '107.05', '424.42', '106.11'
'Drama', '106.77', '531.19', '106.24'
'Family', '100.97', '632.16', '105.36'
'Fantasy', '105.14', '737.30', '105.33'
'Horror', '92.72', '830.02', '103.75'
'Mystery', '101.80', '931.82', '103.54'
'Others', '100.16', '1031.98', '103.20'
'Romance', '109.53', '1141.51', '103.77'
'Sci-Fi', '97.94', '1239.45', '103.29'
'Thriller', '101.58', '1341.03', '103.16' */







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Q26. Top 5 highest-grossing movies per year in top 3 genres

SELECT 
    genre,
    year,
    movie_name,
    worldwide_gross_income,
    movie_rank
FROM (
        SELECT 
            g.genre,
            m.year,
            m.title AS movie_name,
            m.worlwide_gross_income AS worldwide_gross_income,
            
            RANK() OVER (
                PARTITION BY m.year
                ORDER BY 
                    CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS UNSIGNED) DESC
            ) AS movie_rank
            
        FROM movie m
        JOIN genre g 
            ON m.id = g.movie_id
            
        -- Only Top 3 genres
        JOIN (
                SELECT genre
                FROM genre
                GROUP BY genre
                ORDER BY COUNT(movie_id) DESC
                LIMIT 3
             ) AS top_genres
        ON g.genre = top_genres.genre
        
        WHERE m.worlwide_gross_income IS NOT NULL
     ) AS ranked_movies
WHERE movie_rank <= 5
ORDER BY year, movie_rank;










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Q27. Top two production houses with highest hits among multilingual movies

SELECT 
    production_company,
    movie_count,
    prod_comp_rank
FROM (
        SELECT 
            m.production_company,
            COUNT(m.id) AS movie_count,
            RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        WHERE r.median_rating >= 8
          AND m.production_company IS NOT NULL
          AND POSITION(',' IN m.languages) > 0
        GROUP BY m.production_company
     ) AS ranked_production
WHERE prod_comp_rank <= 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

-- Q28. Top 3 actresses with Superhit Drama movies

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM (
        SELECT 
            n.name AS actress_name,
            SUM(r.total_votes) AS total_votes,
            COUNT(DISTINCT m.id) AS movie_count,
            ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 4) AS actress_avg_rating,
            
            RANK() OVER (
                ORDER BY 
                    (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC,
                    SUM(r.total_votes) DESC,
                    n.name ASC
            ) AS actress_rank
            
        FROM movie m
        JOIN ratings r 
            ON m.id = r.movie_id
        JOIN genre g 
            ON m.id = g.movie_id
        JOIN role_mapping rm 
            ON m.id = rm.movie_id
        JOIN names n 
            ON rm.name_id = n.id
            
        WHERE g.genre = 'Drama'
          AND r.avg_rating > 8
          AND rm.category = 'actress'
          
        GROUP BY n.name
     ) AS ranked_actresses
WHERE actress_rank <= 3;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
-- Q29. Details for top 9 directors

-- Q29. Top 9 directors detailed analysis (Compatible version)

SELECT 
    td.director_id,
    td.director_name,
    td.number_of_movies,
    ROUND(AVG(td.inter_movie_days),0) AS avg_inter_movie_days,
    ROUND(AVG(td.avg_rating),2) AS avg_rating,
    SUM(td.total_votes) AS total_votes,
    MIN(td.avg_rating) AS min_rating,
    MAX(td.avg_rating) AS max_rating,
    SUM(td.duration) AS total_duration
FROM (
        SELECT 
            dm.name_id AS director_id,
            n.name AS director_name,
            m.id AS movie_id,
            m.date_published,
            m.duration,
            r.avg_rating,
            r.total_votes,
            
            DATEDIFF(
                m.date_published,
                LAG(m.date_published) OVER (
                    PARTITION BY dm.name_id
                    ORDER BY m.date_published
                )
            ) AS inter_movie_days,
            
            COUNT(*) OVER (PARTITION BY dm.name_id) AS number_of_movies
            
        FROM director_mapping dm
        JOIN names n 
            ON dm.name_id = n.id
        JOIN movie m 
            ON dm.movie_id = m.id
        JOIN ratings r 
            ON m.id = r.movie_id
     ) td
WHERE td.number_of_movies IS NOT NULL
GROUP BY td.director_id, td.director_name
ORDER BY td.number_of_movies DESC
LIMIT 9;






