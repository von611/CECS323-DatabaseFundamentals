1. (Outer Join)
//Getting all movies with their date of opening and closing also getting the theater’s name.
SELECT m.name AS Movie_Name, ms.opening_date AS Opening_Date, ms.date_of_last_show AS Date_Of_Last_Show, t.name AS Theaters_name
	FROM Movie m LEFT OUTER JOIN Movie Showings ms ON m.id = ms.mid
	INNER JOIN Theaters t ON t.tid = ms.tid;


2.(HAVING)(Aggregate)
//Find the movie with the biggest gross earnings and print the movie, studio, studio country name and gross amount
SELECT m.title AS Movie_title, s.name AS Studio_name, c.country_name AS Country_name, Max(m.gross_earnings)
FROM Movies m INNER JOIN Studio Producers sp ON m.id = sp.mid
	INNER JOIN Studios s ON s.sid = s.sid
	INNER JOIN Countries c ON s.sid=c.country_abbr
	HAVING MAX(m.gross_earnings);




3.(Subquery)
//Get movies over tomato meter of 3 and print the theater and country that movie is playing at. Also show the movie title and tomato meter.
SELECT t.name AS Theaters_name, c.country_name AS Country_name, m.title AS Movie_title, m.tomato_meter AS Tomato_meter
FROM Movies m INNER JOIN Movie Showings ms ON m.id = ms.mid
	INNER JOIN  Theaters t ON ms.tid = t.tid
	INNER JOIN Countries c ON t.country=c.country_abbr
WHERE m.id IN (SELECT id
FROM Movies 
WHERE tomato_meter>=3);


4.(Subquery)(Aggregate)(Outer Join)(MAX)
//Find the theater with the most movies and print that theater’s name with the country name and the max amount from that theater.
SELECT MAX(Amount_of_movies) AS Amount, t.name AS Theaters_name, c.country_name AS Country_name
FROM Theaters t INNER JOIN Countries c ON t.country = c.country_abbr
WHERE (Amount_of_movies, t.name) IN 
(SELECT COUNT(m.id) AS Amount_of_movies, t.name
FROM Movies m LEFT OUTER JOIN Movie Showings ms ON m.id = ms.mid
		INNER JOIN Theaters t ON ms.tid=t.tid)
	GROUP BY t.name;
	
5. (Aggregate)(Subquery)
//Find the movie with the lowest budget that is also PG rated and print the movie, budget, studio, and studio country.
SELECT m.title AS Movie_title, Min(m.budget) AS Budget, s.name AS Studio_name, c.country_name AS Country_name
FROM Movies m INNER JOIN Studio Producers sp ON m.id = sp.mid
	INNER JOIN Studios s ON s.sid = s.sid
	INNER JOIN Countries c ON s.sid=c.country_abbr
WHERE m.budget = (SELECT budget 
			FROM Movies
			WHERE mpaa_rating = ‘PG’;
6. (Set Difference)
//Find all movies that were not produced by studios in Japan and print the movie, the studio, and the country.
SELECT m.title AS Movie_title, s.name AS Studio_name, c.country_name AS Country_name
FROM Movies m INNER JOIN Studio Producers sp ON m.id = sp.mid
	INNER JOIN Studios s ON s.sid = s.sid
	INNER JOIN Countries c ON s.sid=c.country_abbr
MINUS
SELECT m.title AS Movie_title, s.name AS Studio_name, c.country_name AS Country_name
FROM Movies m INNER JOIN Studio Producers sp ON m.id = sp.mid
	INNER JOIN Studios s ON s.sid = s.sid
	INNER JOIN Countries c ON s.sid=c.country_abbr
WHERE c.country_name = ‘Japan’;
