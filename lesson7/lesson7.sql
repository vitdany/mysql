-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

-- Task 1
-- Создаем таблицу заказы oders, справочник nomenclature

DROP TABLE IF EXISTS `oders`;
CREATE TABLE oders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_user INT UNSIGNED NOT NULL COMMENT 'Покупатель',
  id_product INT UNSIGNED NOT NULL COMMENT 'Товар, ссылка на номенклатуру',
  product_count INT UNSIGNED NOT NULL COMMENT 'Количество',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  PRIMARY KEY (`id`)
) COMMENT = 'Закзы';

DROP TABLE IF EXISTS `nomenclature`;
CREATE TABLE nomenclature (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL COMMENT 'Название товара',
  catalog_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на группу товаров - каталог', 
  PRIMARY KEY (`id`)
) COMMENT = 'Номенклатура';

INSERT INTO nomenclature (name, catalog_id) VALUES
  ('photo dev1',1),
  ('video dev1',2),
  ('audio dev1',3),
  ('photo dev2',1),
  ('video dev2',2),
  ('audio dev2',3),
  ('photo dev3',1),
  ('video dev3',2),
  ('audio dev3',3)
;
select * FROM nomenclature ;

-- Заполняем таблицу случайными значениями
INSERT INTO oders (id_user, id_product, product_count) 
SELECT FLOOR(1 + (RAND() * 100)) , FLOOR(1 + (RAND() * 9)), FLOOR(1 + (RAND() * 10)) FROM
(SELECT * FROM users) as tmp;
SELECT * FROM oders;

-- Список покупателей + количество заказанных товаров
SELECT tmp.id, tmp.name, sum(tmp.product_count) as sum_product FROM
(SELECT u.id, u.name, o.product_count
  FROM users AS u
  JOIN oders AS o
     ON o.id_user=u.id ) AS tmp 
    GROUP BY tmp.id ORDER BY tmp.id;
 
   
-- Task 2
--  Выведите список товаров products и разделов catalogs, который соответствует
-- товару.
-- Если я правильно понимаю, каталог это группы товаров, часть справочника товары или номенклатура

-- создадим таблицу каталог 
DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE catalogs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL COMMENT 'Название товара',
  PRIMARY KEY (`id`)
) COMMENT = 'Каталог';

INSERT INTO catalogs(name) VALUES
  ('photo'),
  ('video'),
  ('audio')  
;

SELECT
  p.id,
  p.name,
  c.name AS catalog
  FROM nomenclature AS p
    LEFT JOIN catalogs AS c
      ON p.catalog_id = c.id;
     
     
-- Task 3
-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS `flights`;
CREATE TABLE flights (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from` VARCHAR(255) NOT NULL COMMENT 'Название города',
  `to` VARCHAR(255) NOT NULL COMMENT 'Название города',
  PRIMARY KEY (`id`)
) COMMENT = 'рейсы';

INSERT INTO flights(`from`, `to`) VALUES
  ('Avalon', 'Atlantida'),
  ('Atlantida', 'Bielefeld'),
  ('Bielefeld', 'Avalon')  
;

DROP TABLE IF EXISTS `cities`;
CREATE TABLE cities (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(255) NOT NULL COMMENT 'Название города',
  `name` VARCHAR(255) NOT NULL COMMENT 'Название города',
  PRIMARY KEY (`id`)
) COMMENT = 'города';

INSERT INTO cities(`label`, `name`) VALUES
  ('Avalon', 'Авалон'),
  ('Atlantida', 'Атлантида'),
  ('Bielefeld', 'Билефельд')  
;

 SELECT
  f.id,
  cities_from.name AS `from`,
  cities_to.name AS `to`
  FROM flights AS f
      JOIN cities AS cities_from
      ON f.from = cities_from.label
      JOIN cities AS cities_to
    ON f.to = cities_to.label
   ORDER BY f.id;
   
     