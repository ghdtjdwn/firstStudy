-- MySQL 데이터베이스 설정 스크립트
-- MySQL 8.0.43 버전용

-- 1. 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS member_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 2. 사용자 생성 및 권한 부여
CREATE USER IF NOT EXISTS 'springuser'@'localhost' IDENTIFIED BY 'rhdqnskgkwk78!';
CREATE USER IF NOT EXISTS 'springuser'@'%' IDENTIFIED BY 'rhdqnskgkwk78!';

-- 3. 권한 부여
GRANT ALL PRIVILEGES ON member_db.* TO 'springuser'@'localhost';
GRANT ALL PRIVILEGES ON member_db.* TO 'springuser'@'%';

-- 4. 권한 적용
FLUSH PRIVILEGES;

-- 5. 데이터베이스 선택
USE member_db;

-- 6. 테이블 생성 (JPA가 자동으로 생성하지만, 수동으로도 가능)
CREATE TABLE IF NOT EXISTS member (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 7. 초기 데이터 삽입 (선택사항)
INSERT INTO member (name) VALUES 
    ('Jin'),
    ('Alice'),
    ('Bob')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- 8. 확인
SELECT 'MySQL 설정 완료!' as message;
SELECT COUNT(*) as member_count FROM member; 