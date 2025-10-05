# 세종대 인증 시스템 통합 가이드

**Python + Node.js + MySQL 기반 완전한 인증 시스템 구축 가이드**

---

## 📋 목차

- [전체 아키텍처](#전체-아키텍처)
- [역할 분담](#역할-분담)
- [데이터베이스 스키마](#데이터베이스-스키마)
- [인증 플로우](#인증-플로우)
- [Python 인증 서버](#python-인증-서버)
- [Node.js 백엔드](#nodejs-백엔드)
- [JWT 토큰 설계](#jwt-토큰-설계)
- [API 명세](#api-명세)
- [보안 가이드](#보안-가이드)
- [배포](#배포)

---

## 🏗️ 전체 아키텍처

```
[프론트엔드 (Flutte)]
    ↓ ↑
[Node.js 백엔드 (Express)]
    ↓ ↑
[MySQL DB]    [Python FastAPI 인증 서버]
                    ↓ ↑
              [세종대 웹서비스]
```

### 핵심 특징

- **Python**: 세종대 인증 전담 (stateless)
- **Node.js**: 비즈니스 로직, JWT 관리, DB 관리
- **MySQL**: 사용자 정보 + Refresh Token 저장
- **학번 = Primary Key**: 별도 UID 생성 불필요

---

## 👥 역할 분담

| 서버 | 역할 | 담당 업무 |
|------|------|----------|
| **Python FastAPI** | 세종대 인증 전담 | ✅ 세종대 로그인 검증<br>✅ 사용자 정보 수집 (이름, 전공, 학년)<br>❌ JWT 생성 안 함<br>❌ DB 접근 안 함 |
| **Node.js Express** | 비즈니스 로직 | ✅ DB 관리 (유저 저장/조회)<br>✅ JWT 생성/검증<br>✅ Refresh Token 관리<br>✅ API 엔드포인트 제공 |
| **MySQL** | 데이터 저장 | ✅ 유저 정보<br>✅ Refresh Token<br>❌ 비밀번호 저장 안 함 |

---

## 🗄️ 데이터베이스 스키마

### MySQL 테이블 설계

```sql
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
```

### 필드 설명

| 필드 | 출처 | 설명 |
|------|------|------|
| `student_id` | 로그인 요청 | 학번 (Primary Key) |
| `name` | Python → 세종대 서버 | 이름 |
| `major` | Python → 세종대 서버 | 학과 |
| `year` | Python → 세종대 서버 | 학년 |
| `created_at` | Node.js 생성 | 첫 로그인 시각 |
| `last_login` | Node.js 업데이트 | 마지막 로그인 |
| `refresh_token` | Node.js 생성 | Refresh Token (7일) |
| `refresh_token_expires_at` | Node.js 생성 | 만료 시각 |
| `is_active` | Node.js 관리 | 계정 활성 상태 |

**⚠️ 비밀번호 컬럼은 절대 생성하지 않습니다!**

---

## 🔄 인증 플로우

### 1️⃣ 첫 로그인 (회원가입)

```
┌─────────────┐
│  프론트엔드  │
└──────┬──────┘
       │ POST /api/auth/login
       │ { student_id: "20231234", password: "***" }
       │ ⚠️ 이름, 전공 보내지 않음!
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │ 1. MySQL 조회
       │    SELECT * FROM users WHERE student_id = '20231234'
       │    결과: 없음 (신규)
       │
       │ 2. Python 서버로 인증 요청
       │    POST http://python:8000/api/verify
       ↓
┌─────────────┐
│   Python    │
└──────┬──────┘
       │ 3. 세종대 인증 수행
       │    result = auth(id, password, methods=ClassicSession)
       │
       │ 4. Node.js로 응답
       │    { success: true, name: "홍길동", major: "컴공", year: 3 }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │ 5. DB에 유저 생성
       │    INSERT INTO users (student_id, name, major, year, ...)
       │
       │ 6. JWT 토큰 생성
       │    access_token (15분), refresh_token (7일)
       │
       │ 7. Refresh Token DB 저장
       │    UPDATE users SET refresh_token = '...', expires_at = ...
       │
       │ 8. 프론트로 응답
       │    { access_token, refresh_token, user }
       ↓
┌─────────────┐
│  프론트엔드  │ 토큰 저장 (Secure Storage)
└─────────────┘
```

### 2️⃣ Access Token 갱신

```
┌─────────────┐
│  프론트엔드  │ Access Token 만료 (15분 후)
└──────┬──────┘
       │ POST /api/auth/refresh
       │ { refresh_token: "..." }
       ↓
┌─────────────┐
│   Node.js   │
└──────┬──────┘
       │ 1. Refresh Token 검증
       │    jwt.verify(refresh_token, REFRESH_SECRET)
       │
       │ 2. DB와 비교 (탈취 방지)
       │    SELECT refresh_token FROM users WHERE student_id = ...
       │    DB 토큰과 요청 토큰 일치 확인
       │
       │ 3. 새 Access Token 생성
       │    jwt.sign({ sub, name, major }, SECRET, { expiresIn: '15m' })
       │
       │ 4. 응답
       │    { access_token: "..." }
       ↓
┌─────────────┐
│  프론트엔드  │ 새 토큰으로 API 호출
└─────────────┘
```

### 3️⃣ 로그아웃

```
POST /api/auth/logout
Authorization: Bearer {access_token}

→ Node.js: UPDATE users SET refresh_token = NULL WHERE student_id = ...
→ 응답: { message: "로그아웃 되었습니다." }
```

---

## 🐍 Python 인증 서버

### auth_service.py

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sejong_univ_auth import auth, ClassicSession

app = FastAPI()

class AuthRequest(BaseModel):
    student_id: str
    password: str

class AuthResponse(BaseModel):
    success: bool
    student_id: str
    name: str | None = None
    major: str | None = None
    year: int | None = None
    error: str | None = None

@app.post("/api/verify", response_model=AuthResponse)
async def verify_student(request: AuthRequest):
    try:
        result = auth(
            id=request.student_id,
            password=request.password,
            methods=ClassicSession  # 이름, 전공, 학년 모두 수집
        )

        if result.is_auth:
            return AuthResponse(
                success=True,
                student_id=request.student_id,
                name=result.body.get('name'),
                major=result.body.get('major'),
                year=result.body.get('year')
            )
        else:
            return AuthResponse(
                success=False,
                student_id=request.student_id,
                error="인증 실패: 학번 또는 비밀번호가 올바르지 않습니다."
            )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# 실행: uvicorn auth_service:app --host 0.0.0.0 --port 8000
```

**이게 전부입니다!** Python 서버는 더 이상 수정할 필요 없습니다.

---

## 📦 Node.js 백엔드

### 환경 설정

```bash
# .env
JWT_SECRET=your_strong_random_32_chars_secret
JWT_REFRESH_SECRET=different_strong_random_32_chars_secret
AUTH_SERVICE_URL=http://localhost:8000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=sejong_auth
NODE_ENV=development
PORT=3000

# CORS 설정 (선택사항)
# Flutter 앱 전용이면 불필요
# 웹 관리자 패널이 있다면 설정
# ALLOWED_ORIGINS=https://admin.example.com,https://dashboard.example.com
```

### server.js (Express)

```javascript
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();

// 환경 변수 검증
const requiredEnv = [
  'JWT_SECRET',
  'JWT_REFRESH_SECRET',
  'DB_HOST',
  'DB_USER',
  'DB_PASSWORD',
  'DB_NAME',
  'AUTH_SERVICE_URL'
];

for (const key of requiredEnv) {
  if (!process.env[key]) {
    console.error(`❌ Missing required environment variable: ${key}`);
    process.exit(1);
  }
}

// JWT Secret 강도 검증
if (process.env.JWT_SECRET.length < 32) {
  console.error('❌ JWT_SECRET must be at least 32 characters');
  process.exit(1);
}

if (process.env.JWT_REFRESH_SECRET.length < 32) {
  console.error('❌ JWT_REFRESH_SECRET must be at least 32 characters');
  process.exit(1);
}

console.log('✅ Environment variables validated');

// CORS 설정
// ⚠️ Flutter 앱: CORS 불필요 (네이티브 HTTP 클라이언트 사용)
// 개발용 또는 웹 관리자 패널이 있을 경우에만 필요
if (process.env.NODE_ENV === 'development') {
  // 개발 모드: 모든 origin 허용 (테스트 편의)
  app.use(cors({
    origin: '*',
    credentials: true
  }));
} else {
  // 프로덕션: Flutter 앱만 사용 시 CORS 불필요
  // 웹 관리자 패널 등이 있다면 특정 도메인만 허용
  const allowedOrigins = process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',')
    : [];

  if (allowedOrigins.length > 0) {
    app.use(cors({
      origin: allowedOrigins,
      credentials: true
    }));
  }
  // allowedOrigins가 비어있으면 CORS 미들웨어 사용 안 함 (Flutter 전용)
}

app.use(express.json());

// MySQL 연결 풀
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10
});

const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL;

// Rate Limiting
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { error: '너무 많은 인증 시도가 있었습니다. 15분 후 다시 시도해주세요.' }
});

/**
 * 로그인
 */
app.post('/api/auth/login', authLimiter, async (req, res) => {
  const { student_id, password } = req.body;

  if (!student_id || !password) {
    return res.status(400).json({ error: '학번과 비밀번호를 입력해주세요.' });
  }

  try {
    // 1. Python 인증 서비스 호출
    const pythonResponse = await axios.post(
      `${AUTH_SERVICE_URL}/api/verify`,
      { student_id, password },
      { timeout: 10000 }
    );

    const authData = pythonResponse.data;

    if (!authData.success) {
      return res.status(401).json({ error: authData.error || '인증에 실패했습니다.' });
    }

    // 2. MySQL에서 사용자 확인
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE student_id = ?',
      [student_id]
    );

    let user;

    if (rows.length === 0) {
      // 신규 사용자 생성 (Race Condition 처리)
      try {
        await pool.execute(
          `INSERT INTO users (student_id, name, major, year, last_login)
           VALUES (?, ?, ?, ?, NOW())`,
          [student_id, authData.name, authData.major, authData.year]
        );

        user = {
          student_id,
          name: authData.name,
          major: authData.major,
          year: authData.year
        };
      } catch (insertError) {
        // Duplicate Key Error: 동시 요청으로 이미 생성됨
        if (insertError.code === 'ER_DUP_ENTRY') {
          const [existingRows] = await pool.execute(
            'SELECT * FROM users WHERE student_id = ?',
            [student_id]
          );
          user = existingRows[0];
        } else {
          throw insertError;
        }
      }
    } else {
      // 기존 사용자 업데이트
      await pool.execute(
        'UPDATE users SET last_login = NOW() WHERE student_id = ?',
        [student_id]
      );
      user = rows[0];
    }

    // 3. JWT 토큰 생성
    const access_token = jwt.sign(
      {
        sub: student_id,
        name: user.name,
        major: user.major,
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + (60 * 15)  // 15분
      },
      process.env.JWT_SECRET
    );

    const refresh_token = jwt.sign(
      {
        sub: student_id,
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 7)  // 7일
      },
      process.env.JWT_REFRESH_SECRET
    );

    // 4. Refresh Token DB 저장
    await pool.execute(
      `UPDATE users SET
       refresh_token = ?,
       refresh_token_expires_at = DATE_ADD(NOW(), INTERVAL 7 DAY)
       WHERE student_id = ?`,
      [refresh_token, student_id]
    );

    // 5. 응답
    return res.status(201).json({
      access_token,
      refresh_token,
      user: {
        student_id: user.student_id,
        name: user.name,
        major: user.major,
        year: user.year
      }
    });

  } catch (error) {
    console.error('인증 오류:', error.message);
    return res.status(500).json({ error: '서버 오류가 발생했습니다.' });
  }
});

/**
 * Access Token 갱신
 */
app.post('/api/auth/refresh', async (req, res) => {
  const { refresh_token } = req.body;

  if (!refresh_token) {
    return res.status(400).json({ error: 'Refresh token이 필요합니다.' });
  }

  try {
    // 1. Refresh Token 검증
    const decoded = jwt.verify(refresh_token, process.env.JWT_REFRESH_SECRET);

    // 2. DB에서 토큰 확인
    const [rows] = await pool.execute(
      `SELECT student_id, name, major, refresh_token, refresh_token_expires_at
       FROM users WHERE student_id = ?`,
      [decoded.sub]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: '사용자를 찾을 수 없습니다.' });
    }

    const user = rows[0];

    // DB 토큰과 요청 토큰 비교
    if (user.refresh_token !== refresh_token) {
      return res.status(401).json({ error: '유효하지 않은 토큰입니다.' });
    }

    // 만료 확인
    if (new Date(user.refresh_token_expires_at) < new Date()) {
      return res.status(401).json({ error: '만료된 토큰입니다.' });
    }

    // 3. 새 Access Token 생성
    const new_access_token = jwt.sign(
      {
        sub: user.student_id,
        name: user.name,
        major: user.major,
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + (60 * 15)
      },
      process.env.JWT_SECRET
    );

    return res.json({ access_token: new_access_token });

  } catch (error) {
    return res.status(401).json({ error: '유효하지 않은 토큰입니다.' });
  }
});

/**
 * JWT 인증 미들웨어
 */
const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: '인증이 필요합니다.' });
  }

  const token = authHeader.substring(7);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: '유효하지 않은 토큰입니다.' });
  }
};

/**
 * 내 정보 조회
 */
app.get('/api/users/me', authMiddleware, async (req, res) => {
  const student_id = req.user.sub;

  try {
    const [rows] = await pool.execute(
      `SELECT student_id, name, major, year, created_at, last_login
       FROM users WHERE student_id = ?`,
      [student_id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: '사용자를 찾을 수 없습니다.' });
    }

    return res.json({ user: rows[0] });
  } catch (error) {
    return res.status(500).json({ error: '서버 오류가 발생했습니다.' });
  }
});

/**
 * 로그아웃
 */
app.post('/api/auth/logout', authMiddleware, async (req, res) => {
  const student_id = req.user.sub;

  try {
    await pool.execute(
      'UPDATE users SET refresh_token = NULL WHERE student_id = ?',
      [student_id]
    );

    return res.json({ message: '로그아웃 되었습니다.' });
  } catch (error) {
    return res.status(500).json({ error: '서버 오류가 발생했습니다.' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Node.js 서버 실행: http://localhost:${PORT}`);
});
```

### package.json

```json
{
  "name": "sejong-auth-backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "axios": "^1.6.0",
    "jsonwebtoken": "^9.0.2",
    "mysql2": "^3.6.0",
    "express-rate-limit": "^7.1.5",
    "dotenv": "^16.3.1"
  }
}
```

---

## 🔑 JWT 토큰 설계

### Access Token (15분)

```javascript
{
  sub: "20231234",        // 학번
  name: "홍길동",
  major: "컴퓨터공학과",
  iat: 1234567890,
  exp: 1234568790
}
```

### Refresh Token (7일)

```javascript
{
  sub: "20231234",        // 학번만
  iat: 1234567890,
  exp: 1235172690
}
```

**보안 원칙**:
- Access Token: 짧은 만료 (15분) - 탈취 피해 최소화
- Refresh Token: DB 저장 - 탈취 시 무효화 가능
- 로그아웃: DB에서 Refresh Token 삭제

---

## 📡 API 명세

### 1. 로그인

```http
POST /api/auth/login
Content-Type: application/json

{
  "student_id": "20231234",
  "password": "my_password"
}
```

**응답 (201 Created)**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "student_id": "20231234",
    "name": "홍길동",
    "major": "컴퓨터공학과",
    "year": 3
  }
}
```

### 2. Access Token 갱신

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**응답 (200 OK)**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

### 3. 내 정보 조회

```http
GET /api/users/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

**응답 (200 OK)**:
```json
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
```

### 4. 로그아웃

```http
POST /api/auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

**응답 (200 OK)**:
```json
{
  "message": "로그아웃 되었습니다."
}
```

---

## 🔒 보안 가이드

### 필수 보안 조치

#### 1. 비밀번호 저장 금지
```javascript
// ❌ 절대 금지
await pool.execute('INSERT INTO users (student_id, password) VALUES (?, ?)', [id, pw]);

// ✅ 올바른 방식
// 비밀번호는 Python 서버로만 전달, DB 저장 안 함
```

#### 2. Refresh Token DB 저장
```javascript
// DB에 저장하여 탈취 시 무효화 가능
await pool.execute(
  'UPDATE users SET refresh_token = ? WHERE student_id = ?',
  [refresh_token, student_id]
);

// 로그아웃 시 삭제
await pool.execute(
  'UPDATE users SET refresh_token = NULL WHERE student_id = ?',
  [student_id]
);
```

#### 3. Rate Limiting
```javascript
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15분
  max: 5,                     // 최대 5번
  message: { error: '너무 많은 인증 시도가 있었습니다.' }
});

app.post('/api/auth/login', authLimiter, async (req, res) => { ... });
```

#### 4. HTTPS 강제 (프로덕션)
```javascript
if (process.env.NODE_ENV === 'production' && req.protocol !== 'https') {
  return res.redirect('https://' + req.hostname + req.url);
}
```

#### 5. 환경 변수 관리
```bash
# .env 파일은 절대 Git에 커밋 안 함
echo ".env" >> .gitignore

# 프로덕션에서 강력한 시크릿 생성
openssl rand -base64 32  # JWT_SECRET
openssl rand -base64 32  # JWT_REFRESH_SECRET
```

### 추가 권장사항

- **CORS**: 프론트엔드 도메인만 허용
- **입력 검증**: 학번 형식 확인 (`/^\d{6,10}$/`)
- **로깅**: 민감정보 제외 (`student_id.substring(0, 3) + '***'`)
- **SQL Injection**: Prepared Statement 사용 (mysql2 자동 처리)

---

## 🚀 배포

### Docker Compose

```yaml
version: '3.8'

services:
  python:
    build: ./python-auth
    ports:
      - "8000:8000"
    environment:
      - PORT=8000
    restart: unless-stopped

  nodejs:
    build: ./nodejs-backend
    ports:
      - "3000:3000"
    environment:
      - AUTH_SERVICE_URL=http://python:8000
      - DB_HOST=mysql
      - DB_USER=root
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=sejong_auth
      - JWT_SECRET=${JWT_SECRET}
      - JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
      - NODE_ENV=production
    depends_on:
      - mysql
      - python
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
      - MYSQL_DATABASE=sejong_auth
    volumes:
      - mysql-data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped

volumes:
  mysql-data:
```

### init.sql

```sql
CREATE TABLE IF NOT EXISTS users (
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
```

### 실행

```bash
# 환경 변수 설정
cp .env.example .env
# .env 파일 수정 (JWT_SECRET, DB_PASSWORD 등)

# Docker Compose 실행
docker-compose up -d

# 로그 확인
docker-compose logs -f nodejs
```

---

## 🎯 핵심 포인트

### ✅ 반드시 기억할 것

1. **비밀번호 DB 저장 금지** - 매번 세종대 서버 인증
2. **Refresh Token DB 저장** - 탈취 방지 및 무효화 가능
3. **학번 = Primary Key** - 별도 UID 불필요
4. **Python은 인증만** - JWT, DB는 Node.js가 담당
5. **이름/전공은 Python이 수집** - 프론트가 보내는 거 신뢰 안 함

### 📊 시스템 흐름 요약

```
프론트 → Node.js (학번, 비번만)
           ↓
        Python (세종대 인증)
           ↓
        Node.js (DB 저장 + JWT 생성)
           ↓
        프론트 (토큰 받아서 저장)
```

### 🔄 토큰 관리 요약

```
Access Token (15분):
- 짧은 만료
- 매 API 요청마다 사용
- 만료 시 Refresh로 갱신

Refresh Token (7일):
- DB 저장 (탈취 방지)
- Access Token 갱신용
- 로그아웃 시 삭제
```

---

## 📚 참고 자료

- **sejong-univ-auth 라이브러리**: https://github.com/iml1111/sejong-univ-auth
- **FastAPI**: https://fastapi.tiangolo.com/
- **Express.js**: https://expressjs.com/
- **JWT 표준**: https://jwt.io/

---