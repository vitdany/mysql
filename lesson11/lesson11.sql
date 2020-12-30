-- Практическое задание по теме “Оптимизация запросов”
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
-- 
-- Практическое задание по теме “NoSQL”
-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.


DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  table_name VARCHAR(255),
  target_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Лог';


DROP TRIGGER IF EXISTS trg_logs_create;
DELIMITER //
CREATE TRIGGER trg_logs_users AFTER INSERT ON users
FOR EACH ROW BEGIN
   INSERT INTO logs SET 
      created_at = NOW(), 
   	  target_id = NEW.id,
   	  table_name = 'users',
   	  name = NEW.name;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_logs_catalogs AFTER INSERT ON catalogs
FOR EACH ROW BEGIN
   INSERT INTO logs SET 
      created_at = NOW(), 
   	  target_id = NEW.id,
   	  table_name = 'catalogs',
   	  name = NEW.name;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_logs_products AFTER INSERT ON products
FOR EACH ROW BEGIN
   INSERT INTO logs SET 
      created_at = NOW(), 
   	  target_id = NEW.id,
   	  table_name = 'products',
   	  name = NEW.name;
END//
DELIMITER ;

INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Lenovo', 'Мышь', 890.00, 1),

INSERT INTO users(name, birthday_at) VALUES
  ('Марго', '1992-08-29');
 
INSERT INTO catalogs VALUES
  (NULL, 'Мышь')
  ;
SELECT * FROM logs;


# Task 2 cоздайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS InsertToUsers;

SELECT char(65+rand()*26, 65+rand()*26, 65+rand()*26 USING utf8);
SELECT
     UNIX_TIMESTAMP('1980-01-01') AS START,
     UNIX_TIMESTAMP('2000-12-31') AS END;
    
SELECT FROM_UNIXTIME(RAND() * (978249600 - 315561600) + 315561600) AS rand_date;    

DELIMITER //
CREATE FUNCTION InsertToUsers ( end_value INT )
RETURNS INT DETERMINISTIC
BEGIN
   DECLARE i INT;
   SET i = 0;
   WHILE i < end_value DO
     SET i = i + 1;
    INSERT INTO users(name, birthday_at) VALUES
        ( CHAR(65+rand()*26, 65+rand()*26, 65+rand()*26 USING utf8), 
        FROM_UNIXTIME(RAND() * (978249600 - 315561600) + 315561600));   	
    END WHILE;
   RETURN i;
END//
DELIMITER ;

SELECT InsertToUsers(1000000);
SELECT * FROM users;
SELECT * FROM users ORDER BY id DESC LIMIT 3;








