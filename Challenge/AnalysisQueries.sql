-- Select statements
select * from customers limit 10
select * from products limit 10
select * from review_id_table limit 10
select * from vine_table limit 10

-- ANALYSIS:

-- ********************************************

-- QUERY 1: 
-- Number of reviews, Average Rating, Number of helpful votes

select vine,
	count(review_id) as number_reviews,
	avg(star_rating) as avg_star,
	avg(helpful_votes) as avg_helpful_votes,
	avg(total_votes) as avg_total_votes,
	(avg(helpful_votes) / avg(total_votes))*100 as "%_of_helpful",
	sum(helpful_votes) as sum_helpf_votes,
	sum(total_votes) as sum_total_votes
from vine_table
group by vine
order by vine asc


-- ********************************************

-- QUERY 2: 
-- Number of 5-star reviews Analysis
with five_stars as (
	select vine, count(star_rating) as five_stars_count
	from vine_table
	where star_rating =5
	group by vine
),
total as (
	select vine, count(review_id) as total_reviews
	from vine_table
	group by vine
)
select 
	five_stars.vine,
	((five_stars.five_stars_count::float) / (total.total_reviews::float)) * 100 as percentage_five_stars
from five_stars
inner join total on five_stars.vine = total.vine
order by vine asc

-- ********************************************

-- QUERY 3: 
-- Different voters
select vine.vine, 
	(count(distinct(rev.customer_id))::float)/(count(vine.review_id)::float) * 100 as "%_of_distinct_voters"
from vine_table as vine
inner join review_id_table as rev on rev.review_id=vine.review_id
group by vine
order by vine asc

