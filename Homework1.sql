-- Exercise 1
SELECT Count(*)
FROM person
WHERE deathdate ISNULL;

-- Exercise 2
SELECT COUNT(*) 
FROM (
	SELECT m.id
	FROM involved i
	JOIN person p ON p.id = i.personId
	JOIN movie m ON m.id = i.movieId
	WHERE m.language = 'Portuguese'
	GROUP BY m.id HAVING AVG(p.height) > 175
) x

-- Exercise 3
SELECT COUNT(*)
FROM (
    SELECT movieid
    FROM movie_genre
    WHERE genre = 'Thriller'
    GROUP BY movieid HAVING COUNT(genre) > 1
) x

-- Exercise 4
SELECT COUNT(DISTINCT i1.personId)
FROM involved i1 
    JOIN involved i2 ON i1.movieId = i2.movieId
	JOIN person p ON i2.personId = p.id
WHERE i1.role = 'actor'
  AND i2.role = 'director'
  AND p.name = 'Akira Kurosawa';

-- Exercise 5
SELECT COUNT(*)
FROM (
    SELECT m.id
    FROM movie m
    JOIN involved i ON m.id = i.movieId
    WHERE m.year = 2010
      AND i.role = 'director'
    GROUP BY m.id
    HAVING COUNT(DISTINCT i.personId) = 2
) x

-- Exercise 6
SELECT COUNT(*)
FROM (
    SELECT 
        LEAST(i1.personId, i2.personId) AS actor1,
        GREATEST(i1.personId, i2.personId) AS actor2
    FROM 
        involved i1
    JOIN 
        involved i2 ON i1.movieId = i2.movieId 
    JOIN 
        movie m ON i1.movieId = m.id
    WHERE 
        i1.personId < i2.personId 
        AND i1.role = 'actor'
        AND i2.role = 'actor'
        AND m.year BETWEEN 2000 AND 2010
    GROUP BY 
        LEAST(i1.personId, i2.personId), 
        GREATEST(i1.personId, i2.personId)
    HAVING 
        COUNT(DISTINCT m.id) = 20
) x

-- Exercise 7


-- Exercise 8
SELECT COUNT(*)
FROM (
    SELECT i.personId
	FROM involved i 
		JOIN movie_genre mg ON mg.movieId = i.movieId
		JOIN genre g ON mg.genre = g.genre
	WHERE g.category  = 'Newsworthy'
	GROUP BY i.personId
	HAVING COUNT(DISTINCT g.genre) = (
		SELECT COUNT(*)
		FROM genre
		WHERE category = 'Newsworthy'
	)
	AND i.personId NOT IN (
        SELECT i2.personId
        FROM involved i2
	        JOIN movie_genre mg2 ON mg2.movieId = i2.movieId
	        JOIN genre g2 ON mg2.genre = g2.genre
        WHERE g2.category = 'Popular'
        GROUP BY i2.personId
        HAVING COUNT(DISTINCT g2.genre) = (
            SELECT COUNT(*)
            FROM genre
            WHERE category = 'Popular'
        )
    )
) x
