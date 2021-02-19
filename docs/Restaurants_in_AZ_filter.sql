USE Yelp;

SELECT *,
	AVG(r.stars) AS mean_stars
	FROM Business b 
		JOIN Reviews r USING (business_id)
		JOIN Users u USING (user_id)
	WHERE b.categories REGEXP 'Restaurants'
		AND b.categories NOT REGEXP 'Fast'
		AND b.city REGEXP 'Tempe'
		AND b.active = 'true'
		AND b.stars >= 4
        AND u.average_stars >= 4
        AND u.review_count >= 10
        AND r.review_text REGEXP 'out'
	GROUP BY b.business_name  -- Otherwise there are over 1000 reviews to read through
;


SELECT  -- Columns of interest, with lat and long for mapping purposes
		b.business_name AS 'Restaurant name',
        ROUND (AVG(r.stars), 1) AS 'Average stars', 
        COUNT(r.stars) AS 'Number of reviews',
        b.categories AS Cuisine,
        b.full_address AS Address,
		b.latitude, 
        b.longitude
	FROM Business b -- Joing the 3 tables
		JOIN Reviews r USING (business_id)
		JOIN Users u USING (user_id)
	WHERE b.categories REGEXP 'Restaurants' -- Add filters, we want non fast food restaurants, in Tempe, that are active, have high ratings (4/5 at least) and of those only focus on the YELP reviewers that have over 10 reivews and have an average of atleast 4 stars as reviewers(this is AVG in the SELECT clause). ALso outdorr resttaurants for COVID
		AND b.categories NOT REGEXP 'Fast'
		AND b.city REGEXP 'Tempe'
		AND b.active = 'true'
		AND b.stars >= 4
        AND u.average_stars >= 4
        AND u.review_count >= 10
        AND r.review_text REGEXP 'outside|outdoor|patio'
	GROUP BY b.business_name, b.stars, b.categories, b.full_address, b.latitude, b. longitude 
;

