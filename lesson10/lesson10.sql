-- Задания на БД vk:
-- 
-- Проанализировать какие запросы могут выполняться наиболее
-- часто в процессе работы приложения и добавить необходимые индексы.
-- 
-- Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы;
-- среднее количество пользователей в группах;
-- самый молодой пользователь в группе;
-- самый старший пользователь в группе;
-- общее количество пользователей в группе;
-- всего пользователей в системе;
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.


-- Task 1
-- Самым частым обращением будет к таблице  users, profiles, messages.
-- самя частая операция - просмотр новых сообщений от пользователя, сортировка по дате создания сообщений
-- вторая, по частоте, операция - анализ действий пользователей и предусматривает сортировки и поиск 
-- дню рождения, полу.
-- Добавим индексы на колонки name,birthday,created_at, так как по ним 


CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX users_name_idx ON users(name);
CREATE INDEX messages_created_at_idx ON messages(created_at);
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- Task 2


SELECT COUNT(*) as total FROM
   (SELECT COUNT(*) AS counts
       FROM communities
      JOIN communities_users
        ON communities_users.community_id = communities.id
       GROUP BY communities_users.community_id) AS T; 

      -- раcсчитаем среднне
DELIMITER //
CREATE FUNCTION MY_AVE()
RETURNS INT DETERMINISTIC
BEGIN
	
	DECLARE total INT;
   SELECT COUNT(*)  FROM
   (SELECT COUNT(*) AS counts
       FROM communities
      JOIN communities_users
        ON communities_users.community_id = communities.id
       GROUP BY communities_users.community_id) AS T INTO total;
      
     
      RETURN total;
END//
DELIMITER ;
SELECT MY_AVE();

-- итоговый запрос
SELECT DISTINCT communities.name, 
  		(COUNT(communities_users.community_id) OVER()/MY_AVE()) AS average,
  		(SELECT COUNT(*) FROM users) AS users_total,
  		FIRST_VALUE(users.name) OVER w_yang as yang,
  		FIRST_VALUE(users.name) OVER w_old as older,
  		(COUNT(communities_users.user_id) OVER w / (SELECT count(*) FROM users)*100) AS '%%'
      FROM communities_users
      JOIN communities ON communities_users.community_id = communities.id
      JOIN users ON (users.id = communities_users.user_id)
	  JOIN profiles ON (communities_users.user_id=profiles.user_id)
     WINDOW w AS (PARTITION BY communities_users.community_id),
      w_old AS (PARTITION BY communities_users.community_id ORDER BY profiles.birthday DESC),
      w_yang AS (PARTITION BY communities_users.community_id ORDER BY profiles.birthday);
     
  

     
