use practice;

-- Drop if already exists
DROP TABLE IF EXISTS movie_directors;
DROP TABLE IF EXISTS movie_cast;
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS movies;

-- Movies table
CREATE TABLE movies (
  movie_id INT PRIMARY KEY,
  title VARCHAR(100),
  release_year INT,
  genre VARCHAR(50),
  rating FLOAT
);

-- Actors table
CREATE TABLE actors (
  actor_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  birth_year INT
);

-- Movie Cast table (many-to-many)
CREATE TABLE movie_cast (
  movie_id INT,
  actor_id INT,
  role VARCHAR(100),
  PRIMARY KEY (movie_id, actor_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

-- Directors table
CREATE TABLE directors (
  director_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50)
);

-- Movie Directors table (many-to-many)
CREATE TABLE movie_directors (
  movie_id INT,
  director_id INT,
  PRIMARY KEY (movie_id, director_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (director_id) REFERENCES directors(director_id)
);


-- Movies
INSERT INTO movies VALUES
(1, 'Inception', 2010, 'Sci-Fi', 8.8),
(2, 'The Dark Knight', 2008, 'Action', 9.0),
(3, 'Interstellar', 2014, 'Sci-Fi', 8.6),
(4, 'The Prestige', 2006, 'Drama', 8.5),
(5, 'Dunkirk', 2017, 'War', 7.9);

-- Actors
INSERT INTO actors VALUES
(1, 'Leonardo', 'DiCaprio', 1974),
(2, 'Christian', 'Bale', 1974),
(3, 'Matthew', 'McConaughey', 1969),
(4, 'Hugh', 'Jackman', 1968),
(5, 'Tom', 'Hardy', 1977);

-- Movie Cast
INSERT INTO movie_cast VALUES
(1, 1, 'Dom Cobb'),
(2, 2, 'Bruce Wayne'),
(3, 3, 'Cooper'),
(4, 4, 'Robert Angier'),
(5, 5, 'Farrier'),
(2, 5, 'Bane');

-- Directors
INSERT INTO directors VALUES
(1, 'Christopher', 'Nolan'),
(2, 'Steven', 'Spielberg');

-- Movie Directors
INSERT INTO movie_directors VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);



-- List all movies with their actors and the role they played.

select m.title, a.first_name, a.last_name
from movie_cast as mc
join movies as m
on mc.movie_id = m.movie_id
join actors as a
on mc.actor_id = a.actor_id;


-- Count how many actors were in each movie.

select m.title,
count(mc.actor_id) as total_actors
from movies as m
join movie_cast as mc
on m.movie_id = mc.movie_id
group by m.title;

-- Categorize movies by rating:

-- Excellent (>= 9)

-- Great (8–8.9)

-- Good (<8)


select movie_id, title, rating,
case
when rating >= 9 then 'Excellent'
when rating between 8 and 8.9 then 'Great'
else 'Good'
end as rating_category
from movies;

-- Rank movies by rating within each genre.

select title, genre, rating,
rank() over(partition by genre order by rating desc) as genre_rank
from movies;

-- List actors who played in the highest-rated movie.

select m.actor_id, a.first_name, a.last_name
from movie_cast as m
join actors as a
on m.actor_id = a.actor_id
where m.movie_id = (
select movie_id
from movies
order by rating desc
limit 1
);


-- Mark whether each actor was born before or after 1970

select first_name, last_name,
if(birth_year > 1970, 'after 1970', 'before 1970') as birth_year
from actors ;


-- How many movies did each director direct?

select 
d.first_name, d.last_name,
count(md.movie_id) as directors_count
from movie_directors as md
join directors as d
on md.director_id = d.director_id
group by d.director_id;


/*
Q1. List all actors and the movies they’ve acted in (with roles).
Q2. Which movies have more than 1 actor in them?
Q3. Find all movies released after 2010 with a rating above 8.5.
Q4. Show each movie along with the number of actors in it.
Q5. List top 3 highest-rated movies.
Q6. List all actors born before 1975.
Q7. Display all directors and how many movies they've directed.
Q8. List all genres along with the average rating per genre.
Q9. Rank movies by rating within each genre.
Q10. List actors who played in more than one movie.
Q11. List each director and their highest-rated movie.
Q12. Show a CASE statement to label each movie as:

Excellent (>=9)

Good (8-8.9)

Average (<8)

*/

-- Q1. List all actors and the movies they’ve acted in (with roles).
select first_name, last_name, title
from movie_cast as mc
join actors as a
on mc.actor_id = a.actor_id
join movies as m
on mc.movie_id = m.movie_id;

-- Q2. Which movies have more than 1 actor in them?

select mc.movie_id, m.title,
count(a.actor_id) as actor_count
from movie_cast as mc
join actors as a 
on mc.actor_id = a.actor_id
join movies as m
on mc.movie_id = m.movie_id
group by mc.movie_id;

-- Q3. Find all movies released after 2010 with a rating above 8.5.
select * from movies
where release_year > 2010 and rating > 8.5;

-- Q4. Show each movie along with the number of actors in it.

select mc.movie_id, m.title,
count(distinct mc.actor_id) as no_of_actors
from movies as m
join movie_cast as mc
on m.movie_id = mc.movie_id
group by m.movie_id;

-- Q5. List top 3 highest-rated movies.

select * from movies
order by rating desc
limit  3;

-- Q6. List all actors born before 1975.

select * from actors
where birth_year < 1975;

-- Q7. Display all directors and how many movies they've directed.

select m.director_id, d.first_name, d.last_name,
count(m.movie_id) as movie_count
from movie_directors as m
join directors as d
on m.director_id = d.director_id
group by
 m.director_id, d.first_name, d.last_name;

-- Q8. List all genres along with the average rating per genre.

select genre, 
avg(rating) as average_rating
from movies
group by genre;

-- Q9. Rank movies by rating within each genre.

select title, genre, rating,
rank() over(partition by genre order by rating desc) as rank_movie
from movies;


-- Q10. List actors who played in more than one movie.

SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(mc.movie_id) AS movie_count
FROM 
    actors a
JOIN 
    movie_cast mc ON a.actor_id = mc.actor_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name
HAVING 
    COUNT(mc.movie_id) > 1;
    
-- Q11. List each director and their highest-rated movie.


SELECT 
    d.director_id,
    d.first_name,
    d.last_name,
    m.title,
    m.rating
FROM 
    directors d
JOIN 
    movie_directors md ON d.director_id = md.director_id
JOIN 
    movies m ON md.movie_id = m.movie_id
WHERE 
    m.rating = (
        SELECT MAX(m2.rating)
        FROM movie_directors md2
        JOIN movies m2 ON md2.movie_id = m2.movie_id
        WHERE md2.director_id = d.director_id
    );
    
 /* 
 Q12. Show a CASE statement to label each movie as:

Excellent (>=9)

Good (8-8.9)

Average (<8)
 */ 
    
    SELECT 
    title,
    rating,
    CASE 
        WHEN rating >= 9 THEN 'Excellent'
        WHEN rating >= 8 THEN 'Good'
        ELSE 'Average'
    END AS rating_label
FROM 
    movies;

