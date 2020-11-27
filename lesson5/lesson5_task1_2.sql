
-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)
-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

-- Task 1 -----------------------------------------------------------------------------
-- Создаём временную таблицу, 
-- в которую будем вносить изменения и проверять работу запросов
CREATE TEMPORARY TABLE tmp_users SELECT * FROM users;

SELECT * FROM tmp_users;

UPDATE tmp_users SET updated_at = NOW(), created_at = NOW();

INSERT INTO users SELECT * FROM tmp_users;
   
-- замена полей рабочей таблицы   
UPDATE users t1, (SELECT id, created_at, updated_at FROM tmp_users) t2
SET t1.created_at = t2.created_at, t1.updated_at = t2.updated_at
WHERE t1.id = t2.id

SELECT * FROM users;


-- Task 2 -----------------------------------------------------------------------------
-- Зададим формат VARCHAR 20.10.2017 8:10.

DROP TABLE tmp_users;
CREATE TEMPORARY TABLE tmp_users SELECT * FROM users;

ALTER TABLE tmp_users CHANGE COLUMN created_at created_at VARCHAR(64);
ALTER TABLE tmp_users CHANGE COLUMN updated_at updated_at VARCHAR(64);

UPDATE tmp_users SET updated_at = DATE_FORMAT(updated_at, '%d.%m.%Y %h:%i');
UPDATE tmp_users SET created_at = DATE_FORMAT(created_at, '%d.%m.%Y %h:%i');

SELECT * FROM tmp_users;

DESC tmp_users;

-- Теперь зададим формат DATETIME с сохранением значений полей
UPDATE tmp_users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
UPDATE tmp_users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');

ALTER TABLE tmp_users CHANGE COLUMN created_at created_at DATETIME;
ALTER TABLE tmp_users CHANGE COLUMN updated_at updated_at DATETIME;













