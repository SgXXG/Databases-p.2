/* 1. �������� ��� ���������� �� �������. */
SELECT * 
FROM authors;

/* 3. �������� ��� ���������� �������������� ����, ������� ���� ����� ����������. */
SELECT DISTINCT b_id
FROM books
	JOIN subscriptions ON books.b_id = subscriptions.sb_book
WHERE sb_is_active = 'Y';

/*
12. �������� ������������� ������ (������) ��������, �������� � ����������
   ������ ����� ����.
*/
SELECT TOP 1 sb_subscriber
FROM subscriptions
GROUP BY sb_subscriber
ORDER BY COUNT(*) DESC

/* 15.	��������, ������� � ������� ����������� ���� ���� � ����������. */
SELECT AVG(CAST(b_quantity as float)) AS "average_quantity"
FROM books
WHERE b_quantity > 0;

/*
17. ��������, ������� ���� ���� ���������� � �� ���������� � ����������
   (���� ������ ����������� ��������� ���������� ���� sb_is_active (�.�. �Y� � �N�),
   � ����� �������� �������� �Y� � �N� ������ ���� ������������� � �Returned� �
   �Not returned�).
*/
SELECT 'Returned', (SELECT COUNT(*) from subscriptions WHERE sb_is_active = 'N' GROUP BY sb_is_active)
UNION
SELECT 'Not Returned', (SELECT COUNT(*) from subscriptions WHERE sb_is_active = 'Y' GROUP BY sb_is_active)