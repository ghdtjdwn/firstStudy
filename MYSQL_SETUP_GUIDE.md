# MySQL 설정 가이드

## 📋 필수 정보
- **MySQL 버전**: 8.0.43
- **사용자명**: springuser
- **비밀번호**: rhdqnskgkwk78!
- **데이터베이스명**: member_db
- **포트**: 3306

## 🚀 설정 단계

### 1. MySQL 서버 시작
```bash
# Windows에서 MySQL 서비스 시작
net start mysql80

# 또는 MySQL Workbench에서 시작
```

### 2. 데이터베이스 및 사용자 생성
```bash
# root로 MySQL 접속
mysql -u root -p

# 또는 스크립트 실행
mysql -u root -p < mysql-setup.sql
```

### 3. 연결 테스트
```bash
# PowerShell에서 실행
.\test-mysql-connection.ps1
```

### 4. Spring Boot 실행
```bash
# 개발 환경 (MySQL 사용)
./gradlew bootRun --args='--spring.profiles.active=dev'
```

## 🔧 설정 파일

### application-dev.properties (개발용)
```properties
# MySQL 데이터베이스 설정
spring.datasource.url=jdbc:mysql://localhost:3306/member_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
spring.datasource.username=springuser
spring.datasource.password=rhdqnskgkwk78!
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA 설정
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```

### application-prod.properties (운영용)
```properties
# MySQL 데이터베이스 설정
spring.datasource.url=jdbc:mysql://localhost:3306/member_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
spring.datasource.username=${DB_USERNAME:springuser}
spring.datasource.password=${DB_PASSWORD:rhdqnskgkwk78!}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA 설정
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
```

## 🧪 테스트

### 1. MySQL 연결 테스트
```bash
.\test-mysql-connection.ps1
```

### 2. API 테스트
```bash
.\test-api-production-ready.ps1
```

### 3. 프론트엔드 연동 테스트
```bash
.\test-frontend-integration.ps1
```

## 🔍 문제 해결

### MySQL 연결 실패
1. MySQL 서버가 실행 중인지 확인
2. 포트 3306이 열려있는지 확인
3. 사용자 권한이 올바른지 확인

### 인증 오류
```bash
# MySQL에서 사용자 재생성
DROP USER IF EXISTS 'springuser'@'localhost';
DROP USER IF EXISTS 'springuser'@'%';
CREATE USER 'springuser'@'localhost' IDENTIFIED BY 'rhdqnskgkwk78!';
CREATE USER 'springuser'@'%' IDENTIFIED BY 'rhdqnskgkwk78!';
GRANT ALL PRIVILEGES ON member_db.* TO 'springuser'@'localhost';
GRANT ALL PRIVILEGES ON member_db.* TO 'springuser'@'%';
FLUSH PRIVILEGES;
```

### 문자 인코딩 문제
- URL에 `characterEncoding=UTF-8` 추가됨
- 데이터베이스 생성 시 `utf8mb4` 사용

## 📊 데이터 확인

### MySQL에서 직접 확인
```sql
USE member_db;
SELECT * FROM member;
```

### API로 확인
```bash
curl http://localhost:8080/api/members
```

## ✅ 완료 체크리스트

- [ ] MySQL 서버 실행
- [ ] 데이터베이스 생성 (member_db)
- [ ] 사용자 생성 (springuser)
- [ ] 권한 부여
- [ ] 연결 테스트 성공
- [ ] Spring Boot 실행 성공
- [ ] API 테스트 성공
- [ ] 프론트엔드 연동 성공 