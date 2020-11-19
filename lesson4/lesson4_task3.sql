CREATE TABLE `post` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������, ������� ������ ����",
  date_publish datetime NOT NULL COMMENT "���� � ����� �����",
  subject VARCHAR(128) NOT NULL COMMENT "���� �����",
  title VARCHAR(128) NOT NULL COMMENT "���������",
  body VARCHAR(512) NOT NULL COMMENT "���������� �����"
  
) 

CREATE TABLE `like_dislike` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������, ������� ������ like",
  post_id INT UNSIGNED NOT NULL COMMENT "������ �� ����",
  estimation ENUM('Like', 'Dislike') NOT NULL COMMENT "������",
  -- ��� ���������� ���������� �����
  UNIQUE (`post_id`,`user_id`) COMMENT '��������� ���������� ����'
) 

