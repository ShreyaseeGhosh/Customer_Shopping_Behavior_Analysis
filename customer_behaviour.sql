--CREATE DATABASE CustomerShoppingDB;

USE CustomerShoppingDB;
GO

--Total revenue generated for male vs female customers:
select gender, SUM(purchase_amount_usd) as Total_Purchase_Amt from dbo.customer_shopping_cleaned group by gender;

--Which customrs used a discount but still spent more than average purchase amount:
select * from dbo.customer_shopping_cleaned where discount_applied = 'Yes' and purchase_amount_usd > (select avg(purchase_amount_usd) from dbo.customer_shopping_cleaned);

--Which are the top 5 products with the highest average review rating?
WITH product_rating AS
(
    SELECT
        item_purchased,
        AVG(review_rating) AS avg_review_rating
    FROM dbo.customer_shopping_cleaned
    GROUP BY item_purchased
),
ranked_products AS
(
    SELECT
        item_purchased,
        avg_review_rating,
        DENSE_RANK() OVER (
            ORDER BY avg_review_rating DESC
        ) AS rating_rank
    FROM product_rating
)
SELECT *
FROM ranked_products
WHERE rating_rank <= 5;

