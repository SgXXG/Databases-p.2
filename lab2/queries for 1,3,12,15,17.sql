/* 1. Показать всю информацию об авторах. */
SELECT * 
FROM authors;

/* 3. Показать без повторений идентификаторы книг, которые были взяты читателями. */
SELECT DISTINCT b_id
FROM books
	JOIN subscriptions ON books.b_id = subscriptions.sb_book
WHERE sb_is_active = 'Y';

/*
12. Показать идентификатор одного (любого) читателя, взявшего в библиотеке
   больше всего книг.
*/
SELECT TOP 1 sb_subscriber
FROM subscriptions
GROUP BY sb_subscriber
ORDER BY COUNT(*) DESC

/* 15.	Показать, сколько в среднем экземпляров книг есть в библиотеке. */
SELECT AVG(CAST(b_quantity as float)) AS "average_quantity"
FROM books
WHERE b_quantity > 0;

/*
17. Показать, сколько книг было возвращено и не возвращено в библиотеку
   (СУБД должна оперировать исходными значениями поля sb_is_active (т.е. «Y» и «N»),
   а после подсчёта значения «Y» и «N» должны быть преобразованы в «Returned» и
   «Not returned»).
*/
SELECT 'Returned', (SELECT COUNT(*) from subscriptions WHERE sb_is_active = 'N' GROUP BY sb_is_active)
UNION
SELECT 'Not Returned', (SELECT COUNT(*) from subscriptions WHERE sb_is_active = 'Y' GROUP BY sb_is_active)