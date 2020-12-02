-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)
-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.


-- Task 3 -----------------------------------------------------------------------------
DROP TABLE storehouses_products;
CREATE TEMPORARY TABLE storehouses_products ( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	storehouse_id INT UNSIGNED, 
	value INT UNSIGNED);

INSERT INTO
  storehouses_products (storehouse_id, value)
VALUES
  (543, 0),
  (789, 2500),
  (3432, 0),
  (826, 30),
  (719, 500),
  (544, 0),
  (89, 2500),
  (432, 0),
  (26, 30),
  (19, 500),
  (38, 1),
  (638, 1);
 
SELECT * FROM storehouses_products;
DESC storehouses_products; 
SELECT * FROM storehouses_products ORDER BY IF(value = 0, 1, 0), value;

-- Task 4 -----------------------------------------------------------------------------

SELECT user_id, DATE_FORMAT(birthday,'%M') FROM profiles;

SELECT user_id, DATE_FORMAT(birthday,'%M') FROM profiles WHERE DATE_FORMAT(birthday,'%M') = 'May' OR DATE_FORMAT(birthday,'%M') = 'August';



-- Task 5 -----------------------------------------------------------------------------
DROP TABLE catalogs;
CREATE TEMPORARY TABLE catalogs ( 
	id INT UNSIGNED PRIMARY KEY, 
	value INT UNSIGNED);

INSERT INTO
  catalogs (id, value)
VALUES
  (543, 0),
  (789, 2500),
  (5, 10),
  (826, 30),
  (719, 500),
  (1, 11),
  (89, 2500),
  (2, 12),
  (26, 30),
  (19, 500),
  (38, 1),
  (638, 1);
 SELECT FIND_IN_SET(5,'5,1,2');

-- FIELD(id, 5, 1, 2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIND_IN_SET(id,'5,1,2');
-- 