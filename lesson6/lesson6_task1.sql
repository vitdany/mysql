-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение.
-- Агрегация данных
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
-- 1. Создать и заполнить таблицы лайков и постов.
-- 2. Создать все необходимые внешние ключи и диаграмму отношений.
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

-- Task 1

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 100;

-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Заполняем посты
INSERT INTO posts 
  SELECT 
  	id,
    from_user_id, 
    FLOOR(1 + (RAND() * 20)),
    SUBSTRING_INDEX(body, ' ', 4), -- первые четыре слова
    body,
    media_id,
    TRUE,
    FALSE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM messages;

SELECT * FROM posts;

-- Task 2

-- Добавляем внешние ключи в БД vk
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;
SELECT * FROM profiles p2 ;
-- Добавляем внешние ключи




-- Таблица была испорчена в задании lesson5 task4, починим ее 
-- INSERT INTO
--   users (name, birthday_at, created_at, updated_at)
-- VALUES
--   ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
--   ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
--   ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
--   ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
--   ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
--   ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');
     
     
INSERT INTO users 
  SELECT 
    user_id, 
    city,
    birthday, 
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM profiles ORDER BY user_id DESC LIMIT 94;
   
DESC users;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(`id`)
      ON DELETE CASCADE;
     

select* from communities_users;
DELETE FROM `communities_users` WHERE user_id >100;
select* from users;


ALTER TABLE communities_users DROP FOREIGN KEY communities_user_id_fk;  
ALTER TABLE communities_users 
  ADD CONSTRAINT communities_user_id_fk 
    FOREIGN KEY communities_users(`user_id`) REFERENCES users(`id`);
    ON DELETE CASCADE;
   
   
   
ALTER TABLE communities_users DROP FOREIGN KEY community_id_fk;  
ALTER TABLE communities_users 
  ADD CONSTRAINT community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(`id`)
      ON DELETE CASCADE;     

     
ALTER TABLE posts DROP FOREIGN KEY posts_user_id_fk; 
ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(`id`),
  ADD CONSTRAINT posts_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(`id`),
 ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(`id`)
     ;         
 
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');    
    
SELECT * FROM likes;   
SELECT * FROM users;
SELECT * FROM target_types;

ALTER TABLE likes 
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(`id`),
  ADD CONSTRAINT likes_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(`id`)
     ;             
    
ALTER TABLE media 
  ADD CONSTRAINT media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(`id`);
   
   
ALTER TABLE friendship 
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_frend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
    ;

-- Изменяем тип столбца при необходимости
-- ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
-- ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;


-- Смотрим структурв таблицы
DESC messages;
-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Смотрим диаграмму отношений в DBeaver (ERDiagram)
-- Если нужно удалить
-- ALTER TABLE table_name DROP FOREIGN KEY constraint_name;

   
   
-- Task 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT COUNT(*) FROM likes;
SELECT * FROM likes;

-- Старый вариант
SELECT
  gen,
  SUM(count_likes) AS SUM 
  FROM (SELECT (SELECT gender FROM profiles WHERE user_id = users.id) AS gen,
        (SELECT COUNT(*) FROM likes WHERE user_id = users.id) AS count_likes 
        FROM users
        ) AS stats GROUP BY gen;

-- Новый вариант
SELECT
	(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
	COUNT(*) AS total
    FROM likes
    GROUP BY gender
    ORDER BY total DESC
    LIMIT 2;  

       
-- Task 4. Cколько лайков получили 10 самых молодых пользователей ?
SELECT SUM(count_like) AS SUM_LIKES
FROM
       (SELECT name,
        (SELECT birthday FROM profiles WHERE user_id = users.id) AS birthday,
		(SELECT COUNT(*) FROM likes WHERE user_id = users.id ) AS count_like
		FROM users ORDER BY birthday DESC LIMIT 10) AS stats;

-- Правильный вариант
SELECT SUM(likes_total) FROM  
  (SELECT 
    (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) AS likes_total  
    FROM profiles 
    ORDER BY birthday 
    DESC LIMIT 10) AS user_likes
;  
	
-- Task 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети       
SELECT name, (count_post+ count_media+ count_messages+ count_friend+ count_communities)AS ACT
FROM
       (SELECT name,
       (SELECT COUNT(*) FROM posts WHERE user_id = users.id) AS count_post,
       (SELECT COUNT(*) FROM media WHERE user_id = users.id) AS count_media,
	   (SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) AS count_messages,
	   (SELECT COUNT(*) FROM friendship WHERE user_id = users.id) AS count_friend,
	   (SELECT COUNT(*) FROM communities_users WHERE user_id = users.id) AS count_communities
       FROM users) AS stats
       ORDER BY ACT LIMIT 10;  
      
-- Исправленный вариант      
SELECT name, (SELECT COUNT(*) FROM posts WHERE user_id = users.id)  +
       (SELECT COUNT(*) FROM media WHERE user_id = users.id)  +
	   (SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) +
	   (SELECT COUNT(*) FROM friendship WHERE user_id = users.id) +
	   (SELECT COUNT(*) FROM communities_users WHERE user_id = users.id) AS count_activ
       FROM users
       ORDER BY count_activ LIMIT 10;  
      
-- взвешенная сумма     
SELECT name, (0.4*count_post + 0.2*count_media + 0.2*count_messages + 0.1*count_friend + 0.1*count_communities) AS W
FROM
       (SELECT name,
       (SELECT COUNT(*) FROM posts WHERE user_id = users.id) AS count_post,
       (SELECT COUNT(*) FROM media WHERE user_id = users.id) AS count_media,
	   (SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) AS count_messages,
	   (SELECT COUNT(*) FROM friendship WHERE user_id = users.id) AS count_friend,
	   (SELECT COUNT(*) FROM communities_users WHERE user_id = users.id) AS count_communities
       FROM users) AS stats 
          ORDER BY W LIMIT 10;      
