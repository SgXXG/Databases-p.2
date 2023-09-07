/*
1. Добавить в базу данных информацию о троих новых читателях:
"Орлов О.О.", "Соколов С.С.", "Беркутов Б.Б."
*/
INSERT INTO subscribers(s_name)
VALUES			(N'Орлов О.О.'),
				(N'Соколов С.С.'),
				(N'Беркутов Б.Б.');

/*2. Отразить в базе данных информацию о том, что каждый из троих 
	 добавленных читателей 20-го января 2016-го года на месяц взял 
	 в библиотеке книгу «Курс теоретической физики».*/
INSERT INTO subscriptions
		   (sb_subscriber,
		    sb_book,
			sb_start,
			sb_finish,
			sb_is_active)
VALUES ((SELECT s_id FROM subscribers WHERE s_name = N'Орлов О.О.'),
		(SELECT b_id FROM books WHERE b_name = N'Курс теоретической физики'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y'),

		((SELECT s_id FROM subscribers WHERE s_name = N'Соколов С.С.'),
		(SELECT b_id FROM books WHERE b_name = N'Курс теоретической физики'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y'),

		((SELECT s_id FROM subscribers WHERE s_name = N'Беркутов Б.Б.'),
		(SELECT b_id FROM books WHERE b_name = N'Курс теоретической физики'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y')

/* 5. Для всех выдач, произведённых до 1-го января 2012-го года, уменьшить значение дня выдачи на 3 */
UPDATE subscriptions
SET sb_start = DATEADD(DAY, -3, sb_start)
WHERE sb_start < (SELECT {d '2012-01-01'});

SELECT * 
FROM subscriptions

/* 7.	Удалить информацию обо всех выдачах читателям книги с идентификатором 1. */
DELETE
FROM subscriptions
WHERE sb_book = 1;

/* 8. Удалить все книги, относящиеся к жанру «Классика». */
DELETE 
FROM books
WHERE b_id IN (SELECT b_id FROM m2m_books_genres WHERE g_id = (SELECT g_id FROM genres WHERE g_name = N'Классика'))

/* 10. Добавить в базу данных жанры «Политика», «Психология», «История». */
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'Политика')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'Политика');
END;
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'Психология')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'Психология');
END;
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'История')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'История');
END;