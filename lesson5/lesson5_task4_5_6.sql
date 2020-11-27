 -- 1. Подсчитайте средний возраст пользователей в таблице users. 
 -- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 --  Следует учесть, что необходимы дни недели текущего года, а не года рождения. 
 -- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы. 
 
 
-- Подготовка 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');

UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE
  users
CHANGE
  created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE
  users
CHANGE
  updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;

 
 
 
 -- Task 1. 
  

SELECT COUNT(id) FROM users;
SELECT  SUM(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))/ COUNT(id) FROM users;
SELECT  AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;
 
-- Task 2.
 
SELECT
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
  COUNT(*) AS total
FROM
  users
GROUP BY
  day
ORDER BY
  total DESC;

-- Task 3.
DROP TABLE IF EXISTS vector;
CREATE TABLE vector (
  id SERIAL PRIMARY KEY,
  x INT,
  y INT,
  value INT
 
) COMMENT = 'Вектор';

INSERT INTO
  vector (x, y, value)
VALUES
  ('1', '1', '-1'),
  ('1', '2', '3'),
  ('1', '3', '4');
 
-- вариант 1
SELECT 
  EXP(SUM(LN(value))) 
FROM
  vector;
 
 
-- вариант 2, можно обрабатывать 0 и -1
WITH T AS(SELECT value FROM vector),
	P AS 
	(
		SELECT SUM(CASE WHEN value<0 THEN 1 ELSE 0 END) neg, -- число отрицательных значений
		SUM(CASE WHEN value=0 THEN 1 ELSE 0 END) zero, -- есть нули
		COUNT(value) total -- количество
		FROM T
	)
	SELECT 
	CASE WHEN zero > 0 THEN 0 ELSE 
          (CASE WHEN neg%2=1 THEN -1 ELSE +1 END) *exp(SUM(log(abs(value))))
    END
    mult_col  FROM T,P  GROUP BY  total;




