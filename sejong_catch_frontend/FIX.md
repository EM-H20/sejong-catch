Node.js + Python 세종대 인증 시스템 (수정된 설계)
전체 아키텍처
[프론트엔드]
    ↓ ↑
[Node.js 백엔드]
    ↓ ↑
[MySQL DB]    [Python 인증 서버]
                    ↓ ↑
              [세종대 웹서비스]
역할 분담
서버	역할	담당 업무
Python	세종대 인증 전담	✅ 세종대 로그인 검증<br>✅ 사용자 정보 수집 (이름, 전공)<br>❌ JWT 생성 안 함<br>❌ DB 접근 안 함
Node.js	비즈니스 로직	✅ DB 관리 (유저 정보 저장/조회)<br>✅ JWT 생성/검증<br>✅ Refresh Token 관리<br>✅ API 엔드포인트 제공
MySQL	데이터 저장	✅ 유저 정보<br>✅ Refresh Token
데이터베이스 스키마
CREATE TABLE users (
  student_id VARCHAR(20) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  major VARCHAR(100),
  year INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL,
  refresh_token VARCHAR(512),
  refresh_token_expires_at TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,
  INDEX idx_last_login (last_login),
  INDEX idx_refresh_token_expires (refresh_token_expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
시나리오별 플로우
1️⃣ 첫 로그인 (회원가입)
┌─────────────┐
│  프론트엔드  │
└──────┬──────┘
       │
       │ POST /api/auth/login
       │ { student_id: "20231234", password: "***" }
       │ ⚠️ 이름, 전공 보내지 않음!
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 1. MySQL 조회
       │    SELECT * FROM users WHERE student_id = '20231234'
       │    결과: 없음 (신규)
       │
       │ 2. Python 서버로 인증 요청
       │    POST http://python:8000/api/verify
       │    { student_id: "20231234", password: "***" }
       ↓
┌─────────────┐
│   Python    │
└──────┬──────┘
       │
       │ 3. 세종대 인증 수행
       │    result = auth(id, password, methods=ClassicSession)
       │
       │ 4. Node.js로 응답
       │    {
       │      success: true,
       │      student_id: "20231234",
       │      name: "홍길동",        ← 세종대에서 가져온 정보
       │      major: "컴퓨터공학과",  ← 세종대에서 가져온 정보
       │      year: 3
       │    }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 5. DB에 유저 생성
       │    INSERT INTO users (student_id, name, major, year, last_login)
       │    VALUES ('20231234', '홍길동', '컴퓨터공학과', 3, NOW())
       │
       │ 6. JWT 토큰 생성
       │    access_token = jwt.sign(
       │      { sub: student_id, name, major },
       │      SECRET,
       │      { expiresIn: '15m' }
       │    )
       │
       │    refresh_token = jwt.sign(
       │      { sub: student_id },
       │      REFRESH_SECRET,
       │      { expiresIn: '7d' }
       │    )
       │
       │ 7. Refresh Token DB 저장
       │    UPDATE users SET
       │      refresh_token = '...',
       │      refresh_token_expires_at = NOW() + INTERVAL 7 DAY
       │    WHERE student_id = '20231234'
       │
       │ 8. 프론트로 응답
       │    {
       │      access_token: "eyJhbGc...",
       │      refresh_token: "eyJhbGc...",
       │      user: {
       │        student_id: "20231234",
       │        name: "홍길동",
       │        major: "컴퓨터공학과"
       │      }
       │    }
       ↓
┌─────────────┐
│  프론트엔드  │ 토큰 저장 (localStorage 또는 httpOnly cookie)
└─────────────┘
2️⃣ 재로그인 (기존 유저)
┌─────────────┐
│  프론트엔드  │
└──────┬──────┘
       │
       │ POST /api/auth/login
       │ { student_id: "20231234", password: "***" }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 1. MySQL 조회
       │    SELECT * FROM users WHERE student_id = '20231234'
       │    결과: 있음 (기존 유저)
       │
       │ 2. Python 서버로 인증 요청 (비밀번호 재확인)
       │    POST http://python:8000/api/verify
       ↓
┌─────────────┐
│   Python    │
└──────┬──────┘
       │
       │ 3. 세종대 인증 수행
       │    { success: true, ... }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 4. last_login 업데이트
       │    UPDATE users SET last_login = NOW()
       │    WHERE student_id = '20231234'
       │
       │ 5. 새 JWT 토큰 생성 (동일 프로세스)
       │    access_token + refresh_token 생성
       │
       │ 6. Refresh Token DB 업데이트
       │
       │ 7. 프론트로 응답
       ↓
┌─────────────┐
│  프론트엔드  │
└─────────────┘
3️⃣ Access Token 갱신
┌─────────────┐
│  프론트엔드  │ Access Token 만료됨 (15분 후)
└──────┬──────┘
       │
       │ POST /api/auth/refresh
       │ { refresh_token: "eyJhbGc..." }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 1. Refresh Token 검증
       │    decoded = jwt.verify(refresh_token, REFRESH_SECRET)
       │
       │ 2. DB와 비교 (토큰 탈취 방지)
       │    SELECT refresh_token, refresh_token_expires_at
       │    FROM users WHERE student_id = decoded.sub
       │
       │    - DB의 토큰과 요청 토큰 일치 확인
       │    - 만료 시간 확인
       │
       │ 3. 새 Access Token 생성
       │    new_access_token = jwt.sign(
       │      { sub: student_id, name, major },
       │      SECRET,
       │      { expiresIn: '15m' }
       │    )
       │
       │ 4. 프론트로 응답
       │    { access_token: "eyJhbGc..." }
       ↓
┌─────────────┐
│  프론트엔드  │ 새 Access Token으로 API 호출
└─────────────┘
4️⃣ 일반 API 요청 (인증된 사용자)
┌─────────────┐
│  프론트엔드  │
└──────┬──────┘
       │
       │ GET /api/users/me
       │ Authorization: Bearer {access_token}
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │
       │ 1. authMiddleware: Access Token 검증
       │    decoded = jwt.verify(access_token, SECRET)
       │
       │    ✅ 유효 → req.user = decoded
       │    ❌ 만료 → 401 Unauthorized
       │
       │ 2. DB 조회
       │    SELECT * FROM users WHERE student_id = decoded.sub
       │
       │ 3. 프론트로 응답
       │    {
       │      user: {
       │        student_id: "20231234",
       │        name: "홍길동",
       │        major: "컴퓨터공학과",
       │        created_at: "2025-01-15T10:30:00Z",
       │        last_login: "2025-01-16T14:20:00Z"
       │      }
       │    }
       ↓
┌─────────────┐
│  프론트엔드  │
└─────────────┘
API 엔드포인트 명세
1. 로그인
POST /api/auth/login
Content-Type: application/json

{
  "student_id": "20231234",
  "password": "my_password"
}
응답 (성공):
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "student_id": "20231234",
    "name": "홍길동",
    "major": "컴퓨터공학과",
    "year": 3
  }
}
응답 (실패):
{
  "error": "인증 실패: 학번 또는 비밀번호가 올바르지 않습니다."
}
2. Access Token 갱신
POST /api/auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
응답:
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
3. 내 정보 조회
GET /api/users/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
응답:
{
  "user": {
    "student_id": "20231234",
    "name": "홍길동",
    "major": "컴퓨터공학과",
    "year": 3,
    "created_at": "2025-01-15T10:30:00.000Z",
    "last_login": "2025-01-16T14:20:00.000Z"
  }
}
4. 로그아웃
POST /api/auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Node.js 처리:
// DB에서 Refresh Token 삭제
UPDATE users SET refresh_token = NULL WHERE student_id = decoded.sub
응답:
{
  "message": "로그아웃 되었습니다."
}
JWT 토큰 구조
Access Token (15분 만료)
{
  sub: "20231234",        // 학번
  name: "홍길동",
  major: "컴퓨터공학과",
  iat: 1234567890,
  exp: 1234568790         // 15분 후
}
Refresh Token (7일 만료)
{
  sub: "20231234",        // 학번만
  iat: 1234567890,
  exp: 1235172690         // 7일 후
}
보안 정책
✅ 구현해야 할 것
비밀번호 저장 금지
DB에 비밀번호 컬럼 없음
매번 세종대 서버로 인증
Refresh Token 관리
DB에 저장하여 탈취 방지
로그아웃 시 DB에서 삭제
갱신 시 DB 토큰과 비교