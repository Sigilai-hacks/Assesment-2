CREATE DATABASE ecommerce_db;
USE ecommerce_db;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    category VARCHAR(100) NOT NULL,
    discounted_price INT,
    actual_price INT,
    discount_percentage VARCHAR(100) NOT NULL,
    rating VARCHAR(100) NOT NULL,
    rating_count INT,
    about_product VARCHAR(100) NOT NULL,
    user_id VARCHAR(100) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    review_id VARCHAR(100) NOT NULL,
    review_title VARCHAR(100) NOT NULL,
    review_content VARCHAR(100) NOT NULL,
    img_link VARCHAR(100) NOT NULL,
    product_link VARCHAR(100) NOT NULL,
    main_category VARCHAR(100) NOT NULL,
    discount_amount INT
);

SELECT 
    product_id,
    product_name,
    rating_count  
FROM 
    products
ORDER BY 
    rating_count DESC  
LIMIT 10;   

SELECT 
    category,
    AVG(CAST(rating AS DECIMAL(3, 1))) AS average_rating
FROM 
    products
WHERE 
    rating IS NOT NULL  
GROUP BY 
    category
ORDER BY 
    average_rating DESC
LIMIT 3;  
SELECT 
    product_id,
    product_name,
    CAST(REPLACE(discount_percentage, '%', '') AS DECIMAL(5,2)) AS clean_discount
FROM 
    products
WHERE 
    CAST(REPLACE(discount_percentage, '%', '') AS DECIMAL(5,2)) > 50
ORDER BY 
    clean_discount DESC;
    WITH RECURSIVE split_users AS (
  SELECT
    product_id,
    SUBSTRING_INDEX(user_id, ',', 1) AS single_user_id,
    SUBSTRING(user_id, LENGTH(SUBSTRING_INDEX(user_id, ',', 1)) + 2) AS remaining_user_ids
  FROM products
  UNION ALL
  SELECT
    product_id,
    SUBSTRING_INDEX(remaining_user_ids, ',', 1),
    SUBSTRING(remaining_user_ids, LENGTH(SUBSTRING_INDEX(remaining_user_ids, ',', 1)) + 2)
  FROM split_users
  WHERE remaining_user_ids != ''  
)
SELECT 
  single_user_id AS user_id,
  COUNT(*) AS total_reviews
FROM split_users
GROUP BY single_user_id
ORDER BY total_reviews DESC
LIMIT 1;    
SELECT 
    category,
    SUM(
        (LENGTH(TRIM(TRAILING ',' FROM review_id)) - 
        LENGTH(REPLACE(TRIM(TRAILING ',' FROM review_id), ',', '')) + 1)
    ) AS total_reviews
FROM 
    products
WHERE 
    review_id IS NOT NULL 
    AND TRIM(review_id) != '' 
GROUP BY 
    category
ORDER BY 
    total_reviews DESC
LIMIT 5;