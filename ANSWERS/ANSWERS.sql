-- 1
SELECT 
    ar.name 'Artist Name', r.name 'Record Label Name'
FROM
    record_label r
        JOIN
    artist ar ON r.id = ar.record_label_id
ORDER BY ar.name ASC
;	
	
	  
-- 2
SELECT 
    r.name 'Record Label Name'
FROM
    record_label r
        LEFT JOIN
    artist a ON r.id = a.record_label_id
WHERE
    a.record_label_id IS NULL
;	

	
-- 3
SELECT 
    ar.name 'Artist Name', COUNT(*) 'Number of Songs'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY ar.name
ORDER BY COUNT(*) DESC
;
   
   
-- 4
SELECT 
    ar.name 'Artist Name', COUNT(*) 'Number of Songs'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY ar.name
ORDER BY COUNT(*) DESC
LIMIT 1
;


-- 5
SELECT 
    ar.name 'Artist Name', COUNT(*) 'Number of Songs Recorded'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY ar.name
HAVING COUNT(*) = (SELECT 
        MIN(n)
    FROM
        (SELECT 
            ar.name a, COUNT(*) n
        FROM
            song s
        JOIN album al ON s.album_id = al.id
        JOIN artist ar ON al.artist_id = ar.id
        GROUP BY ar.name) temp1)
;


-- 6
SELECT 
    COUNT(*) 'Number of Artists Having Recorded the Least Number of Songs'
FROM
    (SELECT 
        ar.name Artist, COUNT(*)
    FROM
        song s
    JOIN album al ON s.album_id = al.id
    JOIN artist ar ON al.artist_id = ar.id
    GROUP BY ar.name
    HAVING COUNT(*) = (SELECT 
            MIN(n)
        FROM
            (SELECT 
            ar.name a, COUNT(*) n
        FROM
            song s
        JOIN album al ON s.album_id = al.id
        JOIN artist ar ON al.artist_id = ar.id
        GROUP BY ar.name) temp1)) temp2
;


-- 7
SELECT 
    temp.artist 'Artist Name',
    COUNT(*) 'Number of Songs greater than 5 minutes'
FROM
    (SELECT 
        ar.name artist, s.duration 'duration'
    FROM
        song s
    JOIN album al ON s.album_id = al.id
    JOIN artist ar ON al.artist_id = ar.id
    WHERE
        duration > 5) AS temp
GROUP BY temp.artist
;


-- 8
SELECT 
    ar.name 'Artist Name',
    al.name 'Album Name',
    s.name 'Song',
    s.duration 'duration',
    COUNT(*) 'Number of Songs less than 5 minutes'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
WHERE
    duration < 5
GROUP BY 1 , 2
;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- 9
SELECT 
    al.year 'Year', COUNT(*) 'Number of Songs Recorded'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY al.year
HAVING COUNT(*) = (SELECT 
        MAX(count)
    FROM
        (SELECT 
            al.year, COUNT(*) count
        FROM
            song s
        JOIN album al ON s.album_id = al.id
        JOIN artist ar ON al.artist_id = ar.id
        GROUP BY al.year) AS temp)
;	
	

 -- 10
SELECT 
    ar.name 'Artist Name',
    al.name 'Album Name',
    s.name 'Song',
    al.year 'Year Recorded',
    s.duration 'Duration'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
ORDER BY s.duration DESC
LIMIT 5
;


-- 11
SELECT 
    al.year 'Year', COUNT(*) 'Number of Albums Recorded'
FROM
    album al
GROUP BY al.year
;


	
-- 12
SELECT 
    MAX(count) 'Max Number of Albums Recorded per year for all Years'
FROM
    (SELECT 
        al.year 'Year', COUNT(*) count
    FROM
        album al
    GROUP BY al.year) AS temp
;



-- 13
SELECT 
    al.year 'Year', COUNT(*) 'Max Number of Albums Recorded'
FROM
    album al
GROUP BY al.year
HAVING COUNT(*) = (SELECT 
        MAX(count)
    FROM
        (SELECT 
            al.year 'Year', COUNT(*) count
        FROM
            album al
        GROUP BY al.year) AS temp)
;


-- 14
SELECT 
    ar.name 'Artist Name',
    SUM(s.duration) 'Total Duration of All Songs'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY ar.name
ORDER BY SUM(s.duration) DESC
;
 

-- 15
SELECT 
    ar.name 'Artist Name',
    al.name 'Album Name',
    - - s.name 'Song',
    - - s.duration 'duration'
FROM
    artist ar
        LEFT JOIN
    album al ON ar.id = al.artist_id
        LEFT JOIN
    song s ON s.album_id = al.id AND s.duration < 5
WHERE
    s.name IS NULL
;


-- 16
SELECT 
    ar.name AS 'Artist Name',
    al.name AS 'Album Name',
    s.name AS 'Song',
    s.duration AS 'Duration'
FROM
    artist ar
        JOIN
    album al ON al.artist_id = ar.id
        JOIN
    song s ON s.album_id = al.id
ORDER BY ar.name ASC , al.name ASC , s.name ASC
;


-- 17
SELECT 
    ar.name 'Artist Name',
    AVG(s.duration) 'Average Song Duration (min)'
FROM
    song s
        JOIN
    album al ON s.album_id = al.id
        JOIN
    artist ar ON al.artist_id = ar.id
GROUP BY ar.name
ORDER BY AVG(s.duration) DESC
LIMIT 3
;


-- 18
SELECT 
    al.name 'Album Name',
    FLOOR(SUM(s.duration)) 'Minutes',
    ROUND(MOD(SUM(s.duration), 1) * 60) 'Seconds'
FROM
    album al
        JOIN
    song s ON s.album_id = al.id
WHERE
    al.name LIKE 'Sgt. Pepper%'
GROUP BY al.name
;
   
   
-- 19
SELECT DISTINCT
    ar.name 'Artist Name'
FROM
    artist ar
        LEFT JOIN
    album al ON ar.id = al.artist_id AND year >= 1980
        AND year <= 1990
WHERE
    year IS NULL
ORDER BY ar.name
;	
	 

-- 20
SELECT DISTINCT
    ar.name 'Artist Name'
FROM
    artist ar
        LEFT JOIN
    album al ON ar.id = al.artist_id AND year >= 1980
        AND year <= 1990
WHERE
    year IS NOT NULL
ORDER BY ar.name
; 

 
