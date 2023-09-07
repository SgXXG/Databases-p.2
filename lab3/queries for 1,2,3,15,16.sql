/* 1. �������� ������ ����, � ������� ����� ������ ������ */
SELECT *
FROM books
WHERE (SELECT COUNT(*) FROM m2m_books_authors WHERE m2m_books_authors.b_id = books.b_id) > 1

/* 2. �������� ������ ����, ����������� ����� � ������ ����� */
SELECT *
FROM books
WHERE (SELECT COUNT(*) FROM m2m_books_genres WHERE m2m_books_genres.b_id = books.b_id) = 1

/* 3. �������� ��� ����� � �� ������� (������������ �������� ���� �� �����������) */
SELECT b_name,
	STUFF ((SELECT ',' + g_name
		FROM genres
			JOIN m2m_books_genres m2mbg ON genres.g_id = m2mbg.g_id AND books.b_id = m2mbg.b_id
		FOR XML PATH('')), 1, 1, '') as genres
FROM books

/* 15. �������� ���� ������� � ���������� ���� (�� ����������� ����, � "���� ��� �������") */
SELECT *,
	(SELECT COUNT(*)
	 FROM m2m_books_authors m2mba
	 WHERE authors.a_id = m2mba.a_id) as book_count
FROM authors

/*
16. �������� ���� ���������, �� ��������� �����, � ���������� �������������� ����
�� ������� ������ ��������
*/
SELECT s_id, s_name, book_count FROM subscribers
	JOIN (SELECT sb_subscriber, COUNT(*) as book_count
		FROM subscriptions
		WHERE sb_is_active = 'Y'
	GROUP BY sb_subscriber) as counts ON subscribers.s_id = counts.sb_subscriber