-- In SQL and RA, find authors of books that are in one of the genres of Science Fiction, Graphic Novel, or Fantasy and where their royalty share is at least 25%.

SELECT a.first_name || ' ' ||  a.last_name AS authors
    FROM authors a INNER JOIN author_titles at ON a.aid = at.author INNER JOIN titles t ON at.title = t.id
        WHERE ((t.genre = 'Science Fiction' AND at.royalty_share = 0.25) OR (t.genre = 'Graphic Novel' AND at.royalty_share = 0.25) OR (t.genre = 'Fantasy' AND at.royalty_share = 0.25));

-- In SQL and RA, find the name and phone number of every author from Venezuela, the title and year of publication of every book they've written, and the name of the book's publisher.

SELECT a.first_name || ' ' || a.last_name AS authors, a.phone, at.book_title, t.year, p.name AS publisher
    FROM authors a INNER JOIN countries c ON a.country = c.country LEFT OUTER JOIN author_titles ON at a.aid = at.author LEFT OUTER JOIN titles t ON at.title = t.tid LEFT OUTER JOIN publishers p ON t.publisher = p.pid
        WHERE c.name = 'Venezuela';

-- In SQL, for every publisher, retrieve their name and country. For each such publisher, summarize the books published in each genre. Thus, for each publisher and genre, find the number published books, the average sales price of these books, and the total number of books sold.

SELECT p.name, p.country, genre, p.description AS "summary", COUNT(t.tid), AVG(sales) AS average_sales_price, SUM(sales) AS total_of_books_sold
    FROM publisher p LEFT OUTER JOIN titles t ON p.pid = t.publisher
    GROUP BY p.name, country, genre;
    
-- In SQL, retrieve the authors who only have books published by the same publisher. Retrieve the author and publisher.

SELECT DISTINCT a.first_name || ' ' || a.last_name AS "authors", phone, p.name
    FROM authors a 
        INNER JOIN author_titles at ON a.aid = at.author 
        INNER JOIN titles t ON  at.title = t.title 
        INNER JOIN publishers p ON t.publisher = p.pid
    WHERE a.aid IN
    (SELECT at.author FROM  author_titles at ON a.aid = at.author INNER JOIN titles t ON at.title = t.title 
        GROUP BY at.author, 
            HAVING COUNT(DISTINCT publisher) = 1);

-- In SQL, retrieve the authors who only have books published by pubishers of the same country as the author. Retrieve the author and publisher.

SELECT a.first_name || ' ' || a.last_name AS "author", p.name AS "publisher"
    FROM authors a INNER JOIN author_titles at ON a.aid = at.author INNER JOIN titles t ON at.title = t.tid INNER JOIN publishers p ON t.publisher = p.pid
    WHERE a.country = p.country;
    
-- In SQL, write a query to determine whether the values in the royalty_share column are consistent with the share of the publisher. That is, if a book has three authors and the maximum_share of the publisher is 30%, then, the three authors will split the remaining 60%. Along with the SQL statement, you need to include an explanation of how the result of the SQL statement is used to answer this problem.

SELECT a.first_name, a.last_name, t.book_title
    FROM authors a INNER JOIN author_titles at ON a.aid = at.author INNER JOIN titles t ON at.title = t.id INNER JOIN publishers p ON p.pid=t.tid
    WHERE at.royalty_share = ((100-p.maximum_share) / COUNT(at.title));

-- In SQL, find the most popular genre(s) based on number of sales. Retrieve the name of the genre and the number of sales it's had.

SELECT t.book_title, t.genre, t.sales
    FROM titles t
    WHERE t.sales IN
        (SELECT MAX(sales)
            FROM titles);
            
-- In SQL, retrieve the book(s), including their authors, published in the last five years that have the most sales.

SELECT t.book_title, a.first_name, a.last_name
    FROM authors a INNER JOIN author_titles b ON a.aid = b.author
                INNER JOIN titles t ON t.tid = b.title
    WHERE t.year_published >= 2015 AND t.sales IN 
        (SELECT MAX(sales)
            FROM titles);