
-- ������������ ������� �� ���� ����������, ����������, ���������� � �����������
-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
-- 2. ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.
-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. ������ ������� ������ ������ ���������� � �����, ����� ���� �������.
-- 4. (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� (may, august)
-- 5. (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.

-- Task 1 -----------------------------------------------------------------------------
-- ������ ��������� �������, 
-- � ������� ����� ������� ��������� � ��������� ������ ��������
CREATE TEMPORARY TABLE tmp_users SELECT * FROM users;

SELECT * FROM tmp_users;

UPDATE tmp_users SET updated_at = NOW(), created_at = NOW();

INSERT INTO users SELECT * FROM tmp_users;
   
-- ������ ����� ������� �������   
UPDATE users t1, (SELECT id, created_at, updated_at FROM tmp_users) t2
SET t1.created_at = t2.created_at, t1.updated_at = t2.updated_at
WHERE t1.id = t2.id

SELECT * FROM users;


-- Task 2 -----------------------------------------------------------------------------
-- ������� ������ VARCHAR 20.10.2017 8:10.

DROP TABLE tmp_users;
CREATE TEMPORARY TABLE tmp_users SELECT * FROM users;

ALTER TABLE tmp_users CHANGE COLUMN created_at created_at VARCHAR(64);
ALTER TABLE tmp_users CHANGE COLUMN updated_at updated_at VARCHAR(64);

UPDATE tmp_users SET updated_at = DATE_FORMAT(updated_at, '%d.%m.%Y %h:%i');
UPDATE tmp_users SET created_at = DATE_FORMAT(created_at, '%d.%m.%Y %h:%i');

SELECT * FROM tmp_users;

DESC tmp_users;

-- ������ ������� ������ DATETIME � ����������� �������� �����
UPDATE tmp_users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
UPDATE tmp_users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');

ALTER TABLE tmp_users CHANGE COLUMN created_at created_at DATETIME;
ALTER TABLE tmp_users CHANGE COLUMN updated_at updated_at DATETIME;


-- Task 3 -----------------------------------------------------------------------------

-- �� �����.