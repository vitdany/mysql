
CREATE DATABASE mybooking2; 
USE mybooking2;

-- Есть отели в определенной локации
-- есть номера в этих отелях
-- есть разные опции и коэффициенты для расчета цены на конкретные даты 
-- пользователь осуществляет поиск и арендует номера по определенной цене через процедуру брониронирования
-- данные соседних отелей будут храниться рядом блогодаря индексу Z-Order
-- для ускарения расчета цен в завмсимости от опции и класса номера надо рассчитывать все варианты цен на год(для упрощения на месяц вперед)
-- Инсайд https://habr.com/ru/post/323094/

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

INSERT INTO hotels(media_id, hotel_name,stars,email,phone,y,x) VALUES
  (1, 'Аврора', '*', 'avrora@gmail.com',  '2345678', 0, 1 ),
  (2, 'Заря',  '**',  'zaria2@gmail.com',  '2345680', 5, 11),
  (3, 'Берег',  '**',  'zaria2@gmail.com',  '2345681', 50, 110),
  (4, 'Звезда',  '***',  'zaria2@gmail.com',  '2345682', 50, 120),
 ;

SELECT * FROM hotels;
 
 
DROP TABLE IF EXISTS `accomodations`;
CREATE TABLE `accomodations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `hotel_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
  `rooms_name` varchar(100) NOT NULL COMMENT 'Название номера',
  `level` enum('Стандарт', 'Люкс') NOT NULL COMMENT 'Класс номера',
  `floor` varchar(100) NOT NULL COMMENT 'Этаж',
  `sqwer` varchar(100) NOT NULL COMMENT 'Площадь',
  `rooms` varchar(100) NOT NULL COMMENT 'Количество комнат',
  `kitchen` bool NOT NULL COMMENT 'Наличие кухни',
  `sleeps` int NOT NULL COMMENT 'Количество мест',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
 ) COMMENT='Номера';


INSERT INTO accomodations(hotel_id, rooms_name, level, floor, sqwer, rooms, kitchen, sleeps) VALUES
  (1, 'А', 'Люкс',      1,  40, 2, True,  2),
  (1, 'Б', 'Стандарт',  2,  20, 1, False, 2)
 ;
SELECT * FROM accomodations;
-- DELETE FROM hotels WHERE id = 5;

ALTER TABLE accomodations DROP FOREIGN KEY accomodation_hotel_id;
ALTER TABLE accomodations
  ADD CONSTRAINT accomodations_hotel_id
    FOREIGN KEY (hotel_id) REFERENCES hotels(`id`)
      ON DELETE CASCADE;

  
-- создаим справочник периоды на которые будем устанавливать ценовую политику
DROP TABLE IF EXISTS `periods`;
CREATE TABLE `periods` (
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`name` varchar(100) NOT NULL COMMENT 'Название периода, новый год , майские .. ',
 	`date_in` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время действия цены',
    `date_out` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время действия цены',
   PRIMARY KEY (`id`)
)    
COMMENT='справочник периоды';


-- для одного отеля можно создать несколько ценовых программ
DROP TABLE IF EXISTS `coefficients`;
CREATE TABLE `coefficients` (
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`hotel_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
	`name` varchar(100) NOT NULL COMMENT 'Название ценовой программы',
	`level` enum(0, 0.2) COMMENT 'Класс номера, уровень отделки',
  	`floor` double NOT NULL COMMENT 'Этаж ',
  	`sqwer` double NOT NULL COMMENT 'Площадь',
  	`rooms` double NOT NULL COMMENT 'Количество комнат',
  	`kitchen` double NOT NULL COMMENT 'Наличие кухни',
  	`sleeps` double NOT NULL COMMENT 'Количество мест',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    `period_id` int unsigned NOT NULL COMMENT 'Ссылка период',
    PRIMARY KEY (`id`)
)    
COMMENT='Коэффициенты для расчета цены'; 

-- справочник - расценки на сервис на определенную дату, период
DROP TABLE IF EXISTS `service`;
CREATE TABLE `service` (
 	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	`hotel_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
	`name` varchar(100) NOT NULL COMMENT 'Название опции, поздний выезд или все включено, завтрак',
	`cost` enum(0, 0.2) COMMENT 'Класс номера, уровень отделки',
	`period_id` int unsigned NOT NULL COMMENT 'Ссылка период',
    PRIMARY KEY (`id`)

-- оцениваем номера, нужен тригер или функция, total_cost, total_service_cost будет рассчитываться автоматически
DROP TABLE IF EXISTS `price`;
CREATE TABLE `price` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `accomodation_id` int unsigned NOT NULL COMMENT 'Ссылка на отель',
  `coefficient_id` int unsigned NOT NULL COMMENT 'Ссылка на коэффициенты',
  `base_cost` int unsigned NOT NULL COMMENT 'Базовая цена номера на дату или период',
  `total_cost` int unsigned NOT NULL COMMENT 'Итоговая цена с учетом коэффициентов',
  `total_service_cost` int unsigned NOT NULL COMMENT 'Итоговая цена с учетом коэффициентов и сервиса',
  `period_id` int unsigned NOT NULL COMMENT 'Ссылка период',
  PRIMARY KEY (`id`)
) COMMENT='Тариф и цена'; 

     
     