# ----------
# historical price of dishes
# ----------
SELECT
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS d,
    count(),
    round(avg(price), 2),
    bar(avg(price), 0, 100, 100)
FROM menu_item_denorm
WHERE (menu_currency = 'Dollars') AND (d > 0) AND (d < 2022)
GROUP BY d
ORDER BY d ASC;








# ----------
# get the top 10 potato dishes from 1850
# ----------
SELECT
    DISTINCT dish_name
FROM menu_item_denorm
WHERE
    (round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) == 1850) AND
    dish_name ILIKE '%potatoes%'
ORDER BY dish_times_appeared
LIMIT 10

















# ----------
# get the top 10 potato dishes from 2000
# ----------
SELECT
    DISTINCT dish_name
FROM menu_item_denorm
WHERE
    (round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) == 2010) AND
    dish_name ILIKE '%potatoes%'
ORDER BY dish_times_appeared
LIMIT 10

















# ----------
# view the average length of the dish names
# ----------
SELECT 
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS year,
    count(),
    round(avg(length(dish_name)), 2) AS average_title_length, 
    bar(avg(length(dish_name)), 0, 50, 80) AS average_title_length_visual
FROM menu_item_denorm
WHERE (year > 0) AND (year < 2020)
GROUP BY year
ORDER BY year








# -----------
# The average price of a beer
# ----------

SELECT
    round(toUInt32OrZero(extract(menu_date, '^\\d{4}')), -1) AS d,
    count(),
    round(avg(price), 2),
    bar(avg(price), 0, 50, 100),
    any(dish_name)
FROM menu_item_denorm
WHERE (menu_currency IN ('Dollars', '')) AND (d > 0) AND (d < 2022) AND (dish_name ILIKE '%beer%')
GROUP BY d
ORDER BY d ASC;
