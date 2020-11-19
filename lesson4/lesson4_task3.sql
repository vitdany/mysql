CREATE TABLE `post` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который создал пост",
  date_publish datetime NOT NULL COMMENT "Дата и время поста",
  subject VARCHAR(128) NOT NULL COMMENT "Тема поста",
  title VARCHAR(128) NOT NULL COMMENT "Заголовок",
  body VARCHAR(512) NOT NULL COMMENT "Содержание поста"
  
) 

CREATE TABLE `like_dislike` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который создал like",
  post_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пост",
  estimation ENUM('Like', 'Dislike') NOT NULL COMMENT "Оценка",
  -- Для исключения повторного лайка
  UNIQUE (`post_id`,`user_id`) COMMENT 'Составной уникальный ключ'
) 

