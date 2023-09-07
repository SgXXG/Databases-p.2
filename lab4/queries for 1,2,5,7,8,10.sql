/*
1. �������� � ���� ������ ���������� � ����� ����� ���������:
"����� �.�.", "������� �.�.", "�������� �.�."
*/
INSERT INTO subscribers(s_name)
VALUES			(N'����� �.�.'),
				(N'������� �.�.'),
				(N'�������� �.�.');

/*2. �������� � ���� ������ ���������� � ���, ��� ������ �� ����� 
	 ����������� ��������� 20-�� ������ 2016-�� ���� �� ����� ���� 
	 � ���������� ����� ����� ������������� ������.*/
INSERT INTO subscriptions
		   (sb_subscriber,
		    sb_book,
			sb_start,
			sb_finish,
			sb_is_active)
VALUES ((SELECT s_id FROM subscribers WHERE s_name = N'����� �.�.'),
		(SELECT b_id FROM books WHERE b_name = N'���� ������������� ������'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y'),

		((SELECT s_id FROM subscribers WHERE s_name = N'������� �.�.'),
		(SELECT b_id FROM books WHERE b_name = N'���� ������������� ������'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y'),

		((SELECT s_id FROM subscribers WHERE s_name = N'�������� �.�.'),
		(SELECT b_id FROM books WHERE b_name = N'���� ������������� ������'),
		CAST(N'2016-01-20' AS DATE),
		CAST(N'2016-02-20' AS DATE),
		N'Y')

/* 5. ��� ���� �����, ������������ �� 1-�� ������ 2012-�� ����, ��������� �������� ��� ������ �� 3 */
UPDATE subscriptions
SET sb_start = DATEADD(DAY, -3, sb_start)
WHERE sb_start < (SELECT {d '2012-01-01'});

SELECT * 
FROM subscriptions

/* 7.	������� ���������� ��� ���� ������� ��������� ����� � ��������������� 1. */
DELETE
FROM subscriptions
WHERE sb_book = 1;

/* 8. ������� ��� �����, ����������� � ����� ���������. */
DELETE 
FROM books
WHERE b_id IN (SELECT b_id FROM m2m_books_genres WHERE g_id = (SELECT g_id FROM genres WHERE g_name = N'��������'))

/* 10. �������� � ���� ������ ����� ���������, ������������, ���������. */
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'��������')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'��������');
END;
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'����������')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'����������');
END;
IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'�������')
BEGIN
	INSERT INTO genres (g_name)VALUES (N'�������');
END;