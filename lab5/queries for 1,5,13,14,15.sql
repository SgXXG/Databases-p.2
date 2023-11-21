/* 1. ������� �������������, ����������� �������� ������ ���������
   � ����������� ����������� � ������� �������� �� ����� ����,
   �� ������������ ������ ����� ���������, �� �������
   ������� �������������, �.�. �� ����� � �������� ���� ����
   �� ���� �����, ������� �� ������ ��� ������� �� �����������
   ������� ���� */
CREATE OR ALTER VIEW reader_with_book
AS
SELECT s_id, s_name, book_count
FROM subscribers
         JOIN (SELECT sb_subscriber, COUNT(*) as book_count
               FROM subscriptions
               WHERE sb_is_active = 'Y'
               GROUP BY sb_subscriber) as counts ON subscribers.s_id = counts.sb_subscriber
WHERE book_count > 0;

SELECT *
FROM reader_with_book;

/* 5. ������� �������������, ������������ ��� ���������� �� �������
   subscriptions, ���������� ���� �� ����� sb_start � sb_finish
   � ������ "����-��-�� ��", ��� "��" - ���� ������ � ����
   ������ ������� �������� (�.�. "�����������", "�������" � �.�.)*/
CREATE OR ALTER VIEW modified_date
AS
SELECT sb_id,
       sb_subscriber,
       sb_book,
       CONCAT(CONVERT(varchar, sb_start, 23), ' ', (SELECT CASE DATEPART(dw, sb_start)
                                                               WHEN 1 THEN N'�����������'
                                                               WHEN 2 THEN N'�����������'
                                                               WHEN 3 THEN N'�������'
                                                               WHEN 4 THEN N'�����'
                                                               WHEN 5 THEN N'�������'
                                                               WHEN 6 THEN N'�������'
                                                               WHEN 7 THEN N'�������'
                                                               ELSE N'����������'
                                                               END)) AS sb_start,
       CONCAT(CONVERT(varchar, sb_start, 23), ' ', (SELECT CASE DATEPART(dw, sb_start)
                                                               WHEN 1 THEN N'�����������'
                                                               WHEN 2 THEN N'�����������'
                                                               WHEN 3 THEN N'�������'
                                                               WHEN 4 THEN N'�����'
                                                               WHEN 5 THEN N'�������'
                                                               WHEN 6 THEN N'�������'
                                                               WHEN 7 THEN N'�������'
                                                               ELSE N'����������'
                                                               END)) AS sb_finish,
       sb_is_active
FROM subscriptions;

SELECT *
FROM modified_date;


/*------------------------------------------------------------------------------------------------*/
/* 13. ������� �������, �� ����������� �������� � ���� ������
   ���������� � ������ �����, ���� ����������� ���� �� ���� �� ������� */
CREATE OR ALTER TRIGGER task_13
    ON subscriptions
    FOR INSERT
    AS
BEGIN
    IF ((SELECT COUNT(*)
         FROM inserted
         WHERE DATEPART(dw, sb_start) = 1
            OR DATEPART(dw, sb_finish = 1)
            OR (SELECT COUNT(*)
                FROM subscriptions as nested
                WHERE nested.sb_start > DATEADD(MONTH, GETDATE(), -6)
                  AND nested.sb_subscriber = inserted.sb_subscriber) > 100
            OR (SELECT COUNT(*)
                FROM subscriptions as nested
                WHERE DATEDIFF(DAY, sb_start, inserted.sb_finish)) < 3) > 0)
        BEGIN
            RAISERROR ('Error', 0, 0)
        END;
END;
/*-------------------------------------------------------------------------------------------------------------*/

/* 14. ������� �������, �� �����������
   ������ ����� ��������, � �������� �� �����
   ��������� ���� � ����� ����, ��� �������, ��� ��������� �����,
   ���������� �� �������� ���� �������� ��� ����, ���������� �����
   ������ ������ */
CREATE OR ALTER TRIGGER task_14
	ON subscriptions
    FOR INSERT
    AS
    BEGIN
        IF ((SELECT COUNT(*)
             FROM inserted
             WHERE (SELECT COUNT(*)
                    FROM subscriptions AS nested
                    WHERE nested.sb_is_active = 'Y'
                      AND nested.sb_subscriber = inserted.sb_subscriber) > 4
               AND (SELECT SUM(DATEDIFF(SECOND, GETDATE(), nested.sb_finish)) FROM subscriptions as nested) <
                   30 * 24 * 3600) > 0)
            BEGIN
                RAISERROR ('Error', 0, 0)
            END;
    END;

/* 15. ������� �������, ����������� ����������� � ���������� ������ �����
   �������, ��� ������� �� �������� ������� �������� ����� ����,
   ����, ������ - (�����), ' (��������) � �������� (�� ����������� ��� � �����
   ������ ������ �������) */
CREATE OR ALTER TRIGGER task_15
	ON authors
    FOR INSERT
    AS
    BEGIN
		IF ((SELECT COUNT(*)
			FROM inserted
            WHERE inserted.a_name NOT LIKE '[\w\d-'' ]*'
                 OR inserted.a_name LIKE '%  %') > 0)
            BEGIN
				RAISERROR ('Error', 0, 0)
            END;
    END;