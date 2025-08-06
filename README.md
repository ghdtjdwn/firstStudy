# 회원 관리 API (Spring Boot)

프론트엔드와 협업하여 개발한 회원 관리 CRUD API입니다.

## 🚀 기능

| 기능 | 설명 | API |
|------|------|-----|
| 회원 목록 보기 | 등록된 회원 리스트를 보여줌 | `GET /api/members` |
| 회원 추가 | 이름 입력 후 등록 | `POST /api/members` |
| 회원 삭제 | 삭제 버튼 클릭 시 제거 | `DELETE /api/members/{id}` |

## 🛠 기술 스택

- **Backend**: Spring Boot 3.5.4
- **Database**: H2 (개발용), MySQL (운영용)
- **ORM**: Spring Data JPA
- **Validation**: Bean Validation
- **Testing**: JUnit 5 + MockMvc
- **API Documentation**: OpenAPI 3.0 (Swagger)
- **Logging**: SLF4J + Logback

## 📁 프로젝트 구조

```
src/main/java/com/example/festival/
├── controller/
│   └── MemberController.java      # REST API 엔드포인트
├── service/
│   └── MemberService.java         # 비즈니스 로직
├── repository/
│   └── MemberRepository.java      # 데이터 접근 계층
├── entity/
│   └── Member.java               # JPA 엔티티
├── exception/
│   ├── MemberNotFoundException.java  # 커스텀 예외
│   └── GlobalExceptionHandler.java   # 전역 예외 처리
└── config/
    └── DataInitializer.java      # 초기 데이터 설정
```

## 🚀 실행 방법

### 1. MySQL 설정
```bash
# MySQL 서버 시작 후
mysql -u root -p < mysql-setup.sql
```

### 2. 애플리케이션 실행
```bash
# 개발 환경 (MySQL + Swagger UI 활성화)
./gradlew bootRun --args='--spring.profiles.active=dev'

# 운영 환경 (MySQL + Swagger UI 비활성화)
./gradlew bootRun --args='--spring.profiles.active=prod'

# 기본 실행 (dev 프로필)
./gradlew bootRun
```

### 2. API 테스트
```bash
# PowerShell에서 실행
.\test-api-improved.ps1
```

### 3. H2 데이터베이스 콘솔
- URL: http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:testdb`
- Username: `sa`
- Password: (비어있음)

### 4. Swagger API 문서 (개발 환경에서만)
- URL: http://localhost:8080/swagger-ui.html
- API 명세서: http://localhost:8080/api-docs
- **운영 환경에서는 자동으로 비활성화됨**

## 📋 API 명세

### GET /api/members
전체 회원 목록을 조회합니다.

**응답 예시:**
```json
{
  "success": true,
  "message": "회원 목록 조회 성공",
  "data": [
    {"id": 1, "name": "Jin"},
    {"id": 2, "name": "Alice"},
    {"id": 3, "name": "Bob"}
  ],
  "timestamp": "2024-01-15T10:30:00",
  "errorCode": null
}
```

### POST /api/members
새 회원을 추가합니다.

**요청 예시:**
```json
{
  "name": "홍길동"
}
```

**응답 예시:**
```json
{
  "success": true,
  "message": "회원 추가 성공",
  "data": {
    "id": 4,
    "name": "홍길동"
  },
  "timestamp": "2024-01-15T10:30:00",
  "errorCode": null
}
```

### DELETE /api/members/{id}
지정된 ID의 회원을 삭제합니다.

**응답 예시:**
```json
{
  "success": true,
  "message": "회원 삭제 성공",
  "data": "ok",
  "timestamp": "2024-01-15T10:30:00",
  "errorCode": null
}
```

## ✅ 개선 사항

### 보안
- ✅ CORS 설정 개선: `@CrossOrigin("*")` → `@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:5173"})`

### 안정성
- ✅ 예외 처리 추가: `MemberNotFoundException`, `GlobalExceptionHandler`
- ✅ 유효성 검사 추가: `@NotBlank`, `@Size` 어노테이션

### 코드 품질
- ✅ `@Data` → `@Getter`/`@Setter` 변경 (순환참조 방지)
- ✅ 테스트 코드 작성: `MemberControllerTest`

### 개발자 경험
- ✅ Swagger/OpenAPI 문서화 추가
- ✅ 로깅 시스템 구축 (SLF4J)
- ✅ DELETE 존재 여부 확인 개선

### 프로덕션 레벨 개선
- ✅ API 응답 표준화 (ApiResponse<T>)
- ✅ Swagger 보안 설정 (프로필별 분기)
- ✅ 통합 테스트 추가 (@SpringBootTest)
- ✅ 환경별 설정 분리 (dev/prod/test)

### 유효성 검사 규칙
- 이름은 필수 (`@NotBlank`)
- 이름 길이: 1자 이상 50자 이하 (`@Size(min = 1, max = 50)`)

## 🧪 테스트

```bash
# 단위 테스트 실행
./gradlew test

# 통합 테스트 실행
./gradlew integrationTest
```

## 🔧 설정

### 개발 환경 (application-dev.properties)
```properties
# MySQL 데이터베이스
spring.datasource.url=jdbc:mysql://localhost:3306/member_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
spring.datasource.username=springuser
spring.datasource.password=rhdqnskgkwk78!

# JPA 설정
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### 운영 환경 (application-prod.properties)
```properties
# MySQL 데이터베이스
spring.datasource.url=jdbc:mysql://localhost:3306/member_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
spring.datasource.username=${DB_USERNAME:springuser}
spring.datasource.password=${DB_PASSWORD:rhdqnskgkwk78!}

# JPA 설정
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
```

## 🤝 프론트엔드 연동

프론트엔드에서 다음 URL로 API를 호출할 수 있습니다:

```javascript
// 회원 목록 조회
fetch('http://localhost:8080/api/members')

// 회원 추가
fetch('http://localhost:8080/api/members', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: '홍길동' })
})

// 회원 삭제
fetch('http://localhost:8080/api/members/1', {
  method: 'DELETE'
})
```

## 📝 라이센스

MIT License 