CREATE DATABASE mybooking2; 
USE mybooking2;

-- Описание
-- Есть отели в определенной локации
-- есть номера в этих отелях
-- есть разные опции и коэффициенты для расчета цены на конкретные даты 
-- пользователь осуществляет поиск и арендует номер через процедуру брониронирования


-- 1. Создадим основные таблицы

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `first_name` varchar(100) NOT NULL COMMENT 'Имя пользователя',
  `last_name` varchar(100) NOT NULL COMMENT 'Фамилия пользователя',
  `email` varchar(100) NOT NULL COMMENT 'Почта',
  `phone` varchar(100) NOT NULL COMMENT 'Телефон',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) COMMENT='Пользователи';

INSERT INTO users(first_name, last_name, email, phone) VALUES
  ('Петя', 'Иванов',  'pt@yandex.ru' , '123-23-45' ),
  ('Владимир', 'Петров',  'vl@yandex.ru' , '123-23-46'),
  ('Дмитрий', 'Михалов',  'dm@yandex.ru' , '123-23-47')
 ;


DROP TABLE IF EXISTS `towns`;
CREATE TABLE `towns` (
`id_town` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`name_town` varchar(100) NOT NULL COMMENT 'Название',
  `y_town` double NOT NULL COMMENT 'Долгота в прямоугольной системе координат',
  `x_town` double NOT NULL COMMENT 'Широта в прямоугольной системе координат',
   PRIMARY KEY (`id_town`)
)

INSERT INTO towns(name_town, y_town, x_town) VALUES
  ('Москва',   50, 50 ),
  ('Дубна', 60, 70),
  ('Владимир', 50, 110),
  ('Рязань',  20, 120)
 ;

DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `filename` varchar(255) NOT NULL COMMENT 'Путь к файлу',
  `size` int NOT NULL COMMENT 'Размер файла',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT='Медиафайлы';

TRUNCATE TABLE media; 
INSERT INTO media(filename, size ) VALUES
  ( 'video1.mv', 1000 ),
  ( 'image1.png',  10),
  ( 'video2.mv', 1000 ),
  ( 'image2.png',  10)
 ;
SELECT * FROM media ;


DROP TABLE IF EXISTS `hotels`;
CREATE TABLE `hotels` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `media_id` int  unsigned NOT NULL COMMENT 'Ссылка на медиа',
  `hotel_name` varchar(100) NOT NULL COMMENT 'Название',
  `stars` enum('*', '**', '***') NOT NULL COMMENT 'Звезды',
  `email` varchar(100) NOT NULL COMMENT 'Почта',
  `phone` varchar(100) NOT NULL COMMENT 'Телефон',
  `y` double NOT NULL COMMENT 'Долгота в прямоугольной системе координат',
  `x` double NOT NULL COMMENT 'Широта в прямоугольной системе координат',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) COMMENT='Отели';


TRUNCATE TABLE hotels; 
INSERT INTO hotels(media_id, hotel_name,stars,email,phone,y,x) VALUES
  (1, 'Аврора', '*', 'avrora@gmail.com',  '2345678', 50, 51 ),
  (2, 'Заря',  '**',  'zaria@gmail.com',  '2345680', 65, 71),
  (3, 'Берег',  '**',  'bereg@gmail.com',  '2345681', 50, 110),
  (4, 'Звезда',  '***',  'zvesda@gmail.com',  '2345682', 50, 120)
 ;

SELECT * FROM hotels;
 
ALTER TABLE hotels DROP FOREIGN KEY hotels_media_id;
ALTER TABLE hotels
  ADD CONSTRAINT hotels_media_id
    FOREIGN KEY hotels(media_id) REFERENCES media(`id`)
      ;




 
DROP TABLE IF EXISTS `accomodations`;
CREATE TABLE `accomodations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `hotel_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
  `rooms_name` varchar(100) NOT NULL COMMENT 'Название номера',
  `level` enum('Стандарт', 'Люкс') NOT NULL COMMENT 'Категория',
  `floor` int NOT NULL COMMENT 'Этаж',
  `sqwer` int NOT NULL COMMENT 'Площадь',
  `rooms` int NOT NULL COMMENT 'Количество комнат',
  `kitchen` bool NOT NULL COMMENT 'Наличие кухни',
  `sleeps` int NOT NULL COMMENT 'Количество спальных мест',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
 ) COMMENT='Номера';


INSERT INTO accomodations(hotel_id, rooms_name, level, floor, sqwer, rooms, kitchen, sleeps) VALUES
  (1, 'А', 'Люкс',      1,  40, 2, True,  2),
  (1, 'Б', 'Стандарт',  2,  20, 1, False, 2),
  (2, 'А', 'Люкс',      1,  40, 2, True,  2),
  (2, 'Б', 'Стандарт',  2,  20, 1, False, 2),
  (3, 'А', 'Люкс',      1,  50, 2, True,  4),
  (3, 'Б', 'Стандарт',  2,  20, 1, False, 2),
  (4, 'А', 'Люкс',      1,  60, 2, True,  6),
  (4, 'Б', 'Стандарт',  2,  20, 1, False, 2)
 ;
SELECT * FROM accomodations;
-- DELETE FROM hotels WHERE id = 5;

ALTER TABLE accomodations DROP FOREIGN KEY accomodations_hotel_id;
ALTER TABLE accomodations
  ADD CONSTRAINT accomodations_hotel_id
    FOREIGN KEY accomodations(hotel_id) REFERENCES hotels(`id`)
      ON DELETE CASCADE;


-- Создадим каленадь цен, в зависимости от категории номера, у каждого отеля будет свой календарь
DROP TABLE IF EXISTS `periods`;
CREATE TABLE `periods` (
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`hotel_id` int unsigned NOT NULL COMMENT 'Идентификатор отеля',
	`level` enum('Стандарт', 'Люкс') NOT NULL COMMENT 'Категория',
	`name` varchar(100) NOT NULL COMMENT 'Название периода',
	`price` int NOT NULL COMMENT 'Стоимость номера',
 	`date_in` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время действия цены',
    `date_out` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время действия цены',
   PRIMARY KEY (`id`)
)    
COMMENT='Календарь цен';

TRUNCATE TABLE periods; 
INSERT INTO periods(hotel_id, level, name, price, date_in, date_out) VALUES
  (1,'Стандарт', 'Рабочие дни', 1000, '2020.12.01', '2020.12.04'),
  (1,'Стандарт', 'Выходные'   , 1200, '2020.12.05', '2020.12.06'),
  (1,'Стандарт', 'Праздники'  , 2000, '2020.12.31', '2021.01.10'),
  (1,'Люкс', 'Рабочие дни', 2000, '2020.12.01', '2020.12.04'),
  (1,'Люкс', 'Выходные'   , 2200, '2020.12.05', '2020.12.06'),
  (1,'Люкс', 'Праздники'  , 3000, '2020.12.31', '2021.01.10'),
  (2,'Стандарт', 'Рабочие дни', 2000, '2020.12.01', '2020.12.04'),
  (2,'Стандарт', 'Выходные'   , 2200, '2020.12.05', '2020.12.06'),
  (2,'Стандарт', 'Праздники'  , 2000, '2020.12.31', '2021.01.10'),
  (2,'Люкс', 'Рабочие дни', 3000, '2020.12.01', '2020.12.04'),
  (2,'Люкс', 'Выходные'   , 3200, '2020.12.05', '2020.12.06'),
  (2,'Люкс', 'Праздники'  , 3000, '2020.12.31', '2021.01.10'),
  (3,'Стандарт', 'Рабочие дни', 2000, '2020.12.01', '2020.12.04'),
  (3,'Стандарт', 'Выходные'   , 2200, '2020.12.05', '2020.12.06'),
  (3,'Стандарт', 'Праздники'  , 2000, '2020.12.31', '2021.01.10'),
  (3,'Люкс', 'Рабочие дни', 3000, '2020.12.01', '2020.12.04'),
  (3,'Люкс', 'Выходные'   , 3200, '2020.12.05', '2020.12.06'),
  (3,'Люкс', 'Праздники'  , 3000, '2020.12.31', '2021.01.10'),
  (4,'Стандарт', 'Рабочие дни', 3000, '2020.12.01', '2020.12.04'),
  (4,'Стандарт', 'Выходные'   , 3200, '2020.12.05', '2020.12.06'),
  (4,'Стандарт', 'Праздники'  , 3000, '2020.12.31', '2021.01.10'),
  (4,'Люкс', 'Рабочие дни', 4000, '2020.12.01', '2020.12.04'),
  (4,'Люкс', 'Выходные'   , 4200, '2020.12.05', '2020.12.06'),
  (4,'Люкс', 'Праздники'  , 4000, '2020.12.31', '2021.01.10')
 ;
SELECT * FROM periods;

ALTER TABLE periods DROP FOREIGN KEY periods_hotel_id;
ALTER TABLE periods
  ADD CONSTRAINT periods_hotel_id
    FOREIGN KEY periods(hotel_id) REFERENCES hotels(`id`)
      ON DELETE CASCADE;

DROP TABLE IF EXISTS `service`;
CREATE TABLE `service` (
 	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`name` varchar(100) NOT NULL COMMENT 'Название опции, поздний выезд или все включено, завтрак',
    PRIMARY KEY (`id`)
)    
COMMENT='Перечень услуг';

TRUNCATE TABLE service; 
INSERT INTO service(name) VALUES
  ('Завтрак'),
  ('Поздний выезд'),
  ('Трансфер');
  
  
-- справочник - расценки на сервис 
DROP TABLE IF EXISTS `service_price`;
CREATE TABLE `service_price` (
 	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`hotel_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
	`name_id` int unsigned NOT NULL  COMMENT 'Ссылка на опцию',
	`cost` int COMMENT 'Стоимость услуги',
    PRIMARY KEY (`id`)
)    
COMMENT='Расценки на сервис'; 
TRUNCATE TABLE service_price; 
INSERT INTO service_price(hotel_id, name_id, cost) VALUES
  (1, 1, 500),
  (1, 2, 500),
  (1, 3, 1000),
  (2, 1, 1500),
  (2, 2, 1500),
  (2, 3, 2000),
  (3, 1, 100),
  (3, 2, 100),
  (3, 3, 100),
  (4, 1, 1000),
  (4, 2, 2000),
  (4, 3, 3000)
  ;

ALTER TABLE service_price DROP FOREIGN KEY service_price_hotel_id;
ALTER TABLE service_price
  ADD CONSTRAINT service_price_hotel_id
    FOREIGN KEY service_price(hotel_id) REFERENCES hotels(`id`)
      ON DELETE CASCADE;
 
ALTER TABLE service_price DROP FOREIGN KEY service_name_id;
ALTER TABLE service_price
  ADD CONSTRAINT service_price_name_id
    FOREIGN KEY service_price(name_id) REFERENCES service(`id`)
      ON DELETE CASCADE;    
     

DROP TABLE IF EXISTS `service_user`;
CREATE TABLE `service_user` (
 	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`service_id` int unsigned NOT NULL COMMENT '',
	`user_id` int unsigned NOT NULL COMMENT '',
	`booking_id` int unsigned NOT NULL COMMENT '',
    PRIMARY KEY (`id`)
)    
COMMENT='Перечень услуг, выбранных пользователем';


TRUNCATE TABLE service_user; 
INSERT INTO service_user(service_id, user_id) VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 2),
  (1, 3),
  (1, 3)
  ;
       
     
     
DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking` (
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`user_id` int unsigned NOT NULL COMMENT '',
	`accomodations_id` int unsigned NOT NULL COMMENT '',
	`date_in` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Приезд',
    `date_out` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Выезд',
   PRIMARY KEY (`id`)
)
     
ALTER TABLE booking DROP FOREIGN KEY booking_accomodations_id;
ALTER TABLE booking
  ADD CONSTRAINT booking_accomodations_id
    FOREIGN KEY booking(accomodations_id) REFERENCES accomodations(`id`)
      ON DELETE CASCADE;
     
ALTER TABLE booking DROP FOREIGN KEY booking_user_id;
ALTER TABLE booking
  ADD CONSTRAINT booking_user_id
    FOREIGN KEY booking(user_id) REFERENCES users(`id`)
      ON DELETE CASCADE;




-- 2. Создадим запрос пользователя

 -- Как работает программа:
 -- Пользователь строит запрос по датам, выбирает город, выбирает опции в результате 
 -- выдается таблица с перечнем отелей и ценой проживания


-- Расчет растояний от гостиниц городов 
PREPARE len FROM
'SELECT tmp.hotel_name, tmp.name_town, SQRT(POW(tmp.x - tmp.x_town,2) + POW(tmp.y - tmp.y_town,2)) AS Len FROM
(SELECT * FROM hotels AS h
      JOIN towns AS t 
) AS tmp  
ORDER BY Len;';
EXECUTE len;

-- Лучше создадим view
DROP VIEW hoteltown;
CREATE VIEW hoteltown AS 
SELECT tmp.id, tmp.hotel_name, tmp.name_town, SQRT(POW(tmp.x - tmp.x_town,2) + POW(tmp.y - tmp.y_town,2)) AS Len FROM
(SELECT * FROM hotels AS h
      JOIN towns AS t 
 ) AS tmp  
ORDER BY Len;

SELECT * FROM hoteltown;

-- Создадим запрос пользователя с параметрами 
SET @R = 100; -- Радиуc поиска
SET @Town = 'Дубна';
SET @Breakfast = 'Завтрак';
SET @Check_in  = DATE('2020.12.03');
SET @Check_out = DATE('2020.12.06');
SET @RoomLevel = 'Стандарт';

SELECT * FROM  periods p3 ;


-- получим отели и периоды с ценами
SELECT * FROM 
	(
	SELECT * FROM periods p2 
	WHERE  (
	(@Check_in >= p2.date_in AND @Check_in <= p2.date_out) 
	OR (@Check_out >= p2.date_in AND @Check_out <= p2.date_out)
	) 
	AND p2.level = @Level
	) AS tmp ;
	JOIN (SELECT id, Len FROM hoteltown WHERE Len < @R and name_town = @Town ) AS L ON L.id = tmp.hotel_id ORDER BY L.Len;

-- теперь надо расчитать стоимость по дням
-- Зададим даты и посмотрим стоимость на эти даты

CREATE TABLE last_days (
  day INT
);

INSERT INTO last_days VALUES
(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

-- подзапрос разворачивает интервал дат по одному дню
SELECT (DATE(@Check_in + INTERVAL l.day DAY)) AS oneday 
FROM (last_days AS l) WHERE (DATE(@Check_in + INTERVAL l.day DAY)) <= @Check_out;


-- Стоимость отеля за период проживания
SELECT  hotel_id, SUM(price) AS Cost FROM periods p2 
		LEFT JOIN  
		(SELECT (DATE(@Check_in + INTERVAL l.day DAY)) AS oneday 
			FROM (last_days AS l) WHERE (DATE(@Check_in + INTERVAL l.day DAY)) <= @Check_out) AS tmp
			ON (tmp.oneday >= p2.date_in AND tmp.oneday <= p2.date_out)
WHERE oneday AND `level` = @RoomLevel GROUP BY hotel_id ORDER BY Cost;	

-- подключим опции
SELECT id, hotel_id, cost FROM service_price WHERE name = @Breakfast;


-- получим стоимость и растояние до города @town, 
-- пользователь может выбрать между ценой и растоянием до центра города
DROP TABLE tmp_table;
CREATE temporary TABLE tmp_table 
SELECT *,@Check_in, @Check_out,(s_cost*days+Cost) AS total FROM
	(SELECT  hotel_id, SUM(price) AS Cost, COUNT(*)AS days FROM periods p2 
			LEFT JOIN  
			(SELECT (DATE(@Check_in + INTERVAL l.day DAY)) AS oneday 
				FROM (last_days AS l) WHERE (DATE(@Check_in + INTERVAL l.day DAY)) <= @Check_out) AS tmp
				ON (tmp.oneday >= p2.date_in AND tmp.oneday <= p2.date_out)
	WHERE oneday AND `level` = @RoomLevel GROUP BY hotel_id ORDER BY Cost) AS sub	
LEFT JOIN -- подключим растояние до центра города
	(SELECT id, len FROM hoteltown h WHERE h.name_town = @town) AS lentown
	ON sub.hotel_id = lentown.id
LEFT JOIN -- подключим опции
	(SELECT id as s_id, hotel_id as s_hotel_id,  name AS s_name, cost AS s_cost FROM service_price WHERE name = @Breakfast) AS opt
	ON sub.hotel_id = s_hotel_id
ORDER BY Len;


SELECT * FROM tmp_table;



-- 3. Создадим процедуру бронирования
-- пользователь выбрал отель и теперь хочет забронировать его
-- заполним таблицу booking
SELECT * FROM users LIMIT 1;

SELECT u.id, accomodations.id AS room_id, @Check_in, @Check_out FROM users u, tmp_table t
LEFT JOIN accomodations ON accomodations.hotel_id = t.hotel_id
WHERE accomodations.`level` = @RoomLevel ORDER BY t.Len LIMIT 1;

INSERT INTO booking (user_id, accomodations_id, date_in, date_out) 
	SELECT u.id, accomodations.id AS room_id, @Check_in, @Check_out FROM users u, tmp_table t
	LEFT JOIN accomodations ON accomodations.hotel_id = t.hotel_id
	WHERE accomodations.`level` = @RoomLevel ORDER BY t.Len LIMIT 1;

SELECT * FROM booking b;

-- 4. Посмотрим какие номера в отеле свободнны или заняты

SET @Check_in2  = DATE('2020.12.06');
SET @Check_out2 = DATE('2020.12.08');

-- если таблица пустая
SELECT * FROM booking 
WHERE accomodations_id=4 and date_in > @Check_in2;

-- пустая ли таблица, безопансный вариант для больших данных
SELECT COUNT(*) FROM
				(SELECT * FROM booking b LIMIT 1) AS lim;

-- 5. Создадим тригер - который проверит валидность дат
DROP TRIGGER validate_days;
DELIMITER //

CREATE TRIGGER validate_days BEFORE INSERT ON booking
FOR EACH ROW BEGIN
  IF NEW.date_in IS NULL OR NEW.date_out IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'date are NULL';
  END IF;
  IF NEW.date_in > NEW.date_out THEN
    SIGNAL SQLSTATE '45001'
    SET MESSAGE_TEXT = 'Error date_in > date_out';
  END IF;
 
END//


INSERT INTO booking (user_id, accomodations_id, date_in, date_out) VALUES
(1, 4, NULL, @Check_out2 );
	
SELECT * FROM booking b;




