
-- ������� ������ ����
ALTER TABLE friendship DROP COLUMN requested_at;

-- ��������� ����� ���� � �������
ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body;

-- ������������ �������� ������
-- ������� ��� �������
SHOW TABLES;

-- ����������� ������ �������������
SELECT * FROM users LIMIT 10;

-- ������� ��������� ������� �������������
DESC users;

-- �������� � ������� ��������� �����
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at; 

-- ������� ��������� ��������
DESC profiles;

-- ����������� ������
SELECT * FROM profiles LIMIT 10;

-- �������� ������� ����
CREATE TEMPORARY TABLE genders (name CHAR(1));

INSERT INTO genders VALUES ('M'), ('F'); 

SELECT * FROM genders;

-- ��������� ���
UPDATE profiles SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);

-- ������� ��������� ������� ���������
DESC messages;

-- ����������� ������
SELECT * FROM messages LIMIT 10;

-- ��������� �������� ������ �� ����������� � ���������� ���������
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);
 
SELECT * FROM messages WHERE from_user_id = to_user_id;

-- ������� ���������� ������
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100) WHERE from_user_id = to_user_id;

 
-- ��������� ������ �� ����������
UPDATE messages SET  media_id = FLOOR(1 + RAND() * 100);

-- ������� ��������� ������� ������������� 
DESC media;

-- ����������� ������
SELECT * FROM media LIMIT 10;

-- �������� � ������� ��������� �����
UPDATE media SET updated_at = NOW() WHERE updated_at < created_at; 


-- ��������� ������ �� ������������ - ���������
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- ������ ��������� ������� �������� �����������
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- ��������� ����������
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

-- ���������
SELECT * FROM extensions;

-- ��������� ������ �� ����
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- ��������� ������ ������
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

-- ��������� ����������
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  

-- ���������� ������� ���������� ���������� ���
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- ����������� ���� �������������
SELECT * FROM media_types;

-- ������� ��� ����
DELETE FROM media_types;

-- ��������� ������ ����
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

-- DELETE �� ���������� ������� ���������������������,
-- ������� �������� TRUNCATE
TRUNCATE media_types;

-- ����������� ������
SELECT * FROM media LIMIT 10;

-- ��������� ������ ��� ������ �� ���
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

-- ������� ��������� ������� ������
DESC friendship;

-- ����������� ������
SELECT * FROM friendship LIMIT 10;

-- ��������� ������ �� ������
UPDATE friendship SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);

-- ���������� ������ ����� user_id = friend_id
UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;
 
-- ����������� ������ 
SELECT * FROM friendship_statuses;

-- ������� �������
TRUNCATE friendship_statuses;

-- ��������� �������� �������� ������
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
 
-- ��������� ������ �� ������ 
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 

-- ������� ��������� ������� �����
DESC communities;

-- ����������� ������
SELECT * FROM communities;

-- ������� ����� �����
DELETE FROM communities WHERE id > 20;

-- ����������� ������� ����� ������������� � �����
SELECT * FROM communities_users;

-- ��������� �������� community_id
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);

DELETE FROM communities_users WHERE community_id > 100;





