-- Task 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT COUNT(*) FROM likes;
SELECT * FROM likes;
SELECT gender, COUNT(*) AS total
  FROM profiles
   JOIN likes ON profiles.user_id = likes.user_id
     GROUP BY gender LIMIT 1;
    
    
-- Task 4. Cколько лайков получили 10 самых молодых пользователей ?
SELECT SUM(total) FROM
(SELECT profiles.user_id, profiles.birthday, COUNT(likes.user_id) AS total
  FROM profiles
    JOIN likes
  	ON profiles.user_id = likes.user_id
  GROUP BY likes.user_id
  ORDER BY profiles.birthday DESC LIMIT 10) as total_likes;
 
 
-- Task 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети 
SELECT users.id, COUNT(users.id) AS total_likes
  FROM users
    LEFT JOIN media
      ON users.id = media.user_id
    LEFT JOIN posts 
      ON users.id = posts.user_id 
    LEFT JOIN communities_users 
      ON users.id = communities_users.user_id   
    LEFT JOIN friendship 
      ON users.id = friendship.user_id   
  GROUP BY users.id
  ORDER BY total_likes
  LIMIT 10;
     
     
     
     
     
     
     