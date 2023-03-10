

# get the top 10 potato dishes from 1850
SELECT
    DISTINCT dish_name
FROM menu_item_denorm
WHERE
    (round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) == 1850) AND
    dish_name ILIKE '%potatoes%'
ORDER BY dish_times_appeared
LIMIT 10


# get the top 10 potato dishes from 2000
SELECT
    DISTINCT dish_name
FROM menu_item_denorm
WHERE
    (round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) == 2010) AND
    dish_name ILIKE '%potatoes%'
ORDER BY dish_times_appeared
LIMIT 10

# view the average length of the dish names
SELECT 
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS year,
    count(),
    round(avg(length(dish_name)), 2) AS average_title_length, 
    bar(avg(length(dish_name)), 0, 50, 80) AS average_title_length_visual
FROM menu_item_denorm
WHERE (year > 0) AND (year < 2020)
GROUP BY year
ORDER BY year


select 
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS year,
    avg(price)
from menu_item_denorm 
WHERE (year > 1849) AND (year < 2020)
GROUP BY year
ORDER BY year


select 
    avg(price), 
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS year  
from menu_item_denorm 
where dish_name ILIKE ('%beer%')
and (year > 1849) AND (year < 2020)
GROUP BY year
ORDER BY year