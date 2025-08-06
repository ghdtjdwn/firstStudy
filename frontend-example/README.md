# 회원 관리 프론트엔드

Spring Boot 백엔드 API와 연동되는 React + Vite + Tailwind CSS 프론트엔드입니다.

## 🚀 실행 방법

### 1. 의존성 설치
```bash
npm install
```

### 2. 개발 서버 실행
```bash
npm run dev
```

### 3. 브라우저에서 확인
- http://localhost:5173 으로 접속

## 🔗 백엔드 연결

이 프론트엔드는 다음 백엔드 API와 연동됩니다:
- **URL**: http://localhost:8080/api/members
- **CORS**: 백엔드에서 localhost:5173 포트 허용됨

## 📁 프로젝트 구조

```
src/
├── App.jsx              # 메인 앱 컴포넌트
├── components/
│   ├── MemberForm.jsx   # 회원 추가 폼
│   └── MemberList.jsx   # 회원 목록
├── api/
│   └── member.js        # API 호출 함수
├── main.jsx             # 앱 진입점
└── index.css            # Tailwind CSS
```

## ✨ 주요 기능

- ✅ 회원 목록 조회
- ✅ 새 회원 추가
- ✅ 회원 삭제
- ✅ 로딩 상태 표시
- ✅ 에러 처리
- ✅ 반응형 디자인

## 🛠 기술 스택

- **React 18** - UI 라이브러리
- **Vite** - 빌드 도구
- **Tailwind CSS** - 스타일링
- **Axios** - HTTP 클라이언트

## 🔧 개발 환경

- Node.js 16+
- npm 또는 yarn
- 백엔드 API 서버 실행 필요 