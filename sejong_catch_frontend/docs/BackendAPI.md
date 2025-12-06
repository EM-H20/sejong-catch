# Sejong Catch Backend API 명세서

> **API Version**: 1.0.0
> **OpenAPI**: 3.0.3
> **Base URL**: `http://152.67.219.91:8888`
> **Last Updated**: 2025-12-06

---

## 목차

1. [인증 (Auth)](#1-인증-auth)
2. [관리자 (Admin)](#2-관리자-admin)
3. [부스 타입 (Booth Masters)](#3-부스-타입-booth-masters)
4. [부스 (Booths)](#4-부스-booths)
5. [부스 관리자 (Booth Managers)](#5-부스-관리자-booth-managers)
6. [대기열 (Queues)](#6-대기열-queues)
7. [크롤러 (Crawler)](#7-크롤러-crawler)
8. [스키마 (Schemas)](#8-스키마-schemas)

---

## 인증 방식

Bearer Token (JWT) 인증을 사용합니다.

```
Authorization: Bearer <access_token>
```

---

## 1. 인증 (Auth)

### POST `/auth/login`
학번/비밀번호 로그인

**Request Body**
```json
{
  "studentId": "21000000",    // required
  "password": "P@ssw0rd!"     // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 로그인 성공 → `LoginResponse` |
| 400 | 필수 값 누락 |
| 401 | 인증 실패 |

**Response Example (200)**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "홍길동",
    "role": "student",
    "major": "컴퓨터공학과",
    "year": 3,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### POST `/auth/logout`
refreshToken 무효화

**Request Body**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 로그아웃 성공 (본문 없음) |
| 400 | 필수 값 누락 |

---

### POST `/auth/refresh`
저장된 refresh 토큰 검증 후 access 토큰 재발급 (refresh 유지)

**Request Body**
```json
{
  "studentId": "21000000"  // required - 학번 (provider_user_id)
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 재발급 성공 → `LoginResponse` |
| 400 | 필수 값 누락 |
| 401 | refresh 토큰이 만료/유효하지 않음 |
| 404 | 사용자 또는 refresh 토큰 없음 |

---

## 2. 관리자 (Admin)

### PATCH `/core/admin/users/{userId}/role`
유저 역할 변경 (admin ↔ student)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| userId | string | ✅ | 유저 UUID |

**Request Body**
```json
{
  "role": "admin"  // required - "student" | "admin"
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 변경 완료 |
| 400 | 잘못된 요청 |
| 404 | 유저 없음 |

---

## 3. 부스 타입 (Booth Masters)

### POST `/catch/booth-masters` 🔒
부스 타입 생성 (관리자)

**Request Body**
```json
{
  "name": "게임"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 201 | 생성 완료 |
| 400 | 잘못된 요청 |
| 409 | 이름 중복 |

---

### GET `/catch/booth-masters` 🔒
부스 타입 목록 조회 (관리자)

**Response Example (200)**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "게임",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### PATCH `/catch/booth-masters/{id}` 🔒
부스 타입 수정 (관리자)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | ✅ | 부스 타입 UUID |

**Request Body**
```json
{
  "name": "보드게임"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 수정 완료 |
| 400 | 잘못된 요청 |
| 404 | 대상 없음 |
| 409 | 이름 중복 |

---

### DELETE `/catch/booth-masters/{id}` 🔒
부스 타입 삭제 (관리자)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | ✅ | 부스 타입 UUID |

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 삭제 완료 |
| 404 | 대상 없음 |

---

## 4. 부스 (Booths)

### POST `/catch/booths` 🔒
부스 생성 (관리자/부스 관리자)

**Request Body**
```json
{
  "masterId": "11111111-1111-1111-1111-111111111111",  // required
  "title": "다트 게임",                                  // required
  "seatCount": 4,                                       // optional, min: 1
  "avgWaitMinutes": 10                                  // optional, min: 0
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 201 | 생성 완료 |
| 400 | 잘못된 요청 |
| 403 | 권한 없음 |
| 404 | master 없음 |

---

### GET `/catch/booths`
부스 목록 조회 (기본 OPERATING)

**Query Parameters**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| status | string | OPERATING | `PREPARING` \| `OPERATING` \| `ENDED` |

**Response Example (200)**
```json
{
  "data": [
    {
      "id": "uuid",
      "masterId": "uuid",
      "title": "다트 게임",
      "seatCount": 4,
      "avgWaitMinutes": 10,
      "status": "OPERATING",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### GET `/catch/booths/{boothId}`
부스 상세 조회

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 조회 성공 |
| 404 | 부스 없음 |

---

### PATCH `/catch/booths/{boothId}` 🔒
부스 정보 수정 (관리자/부스 관리자 또는 해당 부스 매니저)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |

**Request Body**
```json
{
  "title": "다트 게임 - 수정",  // optional
  "seatCount": 5,               // optional, min: 1
  "avgWaitMinutes": 8           // optional, min: 0
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 수정 완료 |
| 400 | 잘못된 요청 |
| 403 | 권한 없음 |
| 404 | 부스 없음 |

---

### PATCH `/catch/booths/{boothId}/status` 🔒
부스 상태 변경 (관리자/부스 관리자 또는 해당 부스 매니저)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |

**Request Body**
```json
{
  "status": "OPERATING"  // required - "PREPARING" | "OPERATING" | "ENDED"
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 상태 변경 완료 |
| 400 | 잘못된 요청/전이 불가 |
| 403 | 권한 없음 |
| 404 | 부스 없음 |

---

## 5. 부스 관리자 (Booth Managers)

### POST `/catch/booths/{boothId}/managers` 🔒
부스 관리자 추가 (앱 관리자)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |

**Request Body**
```json
{
  "userId": "22222222-2222-2222-2222-222222222222"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 201 | 매핑 생성 |
| 400 | 잘못된 요청 |
| 403 | 권한 없음 |
| 404 | 부스/유저 없음 |
| 409 | 이미 매핑됨 |

---

### GET `/catch/booths/{boothId}/managers` 🔒
부스 관리자 목록 조회 (앱 관리자)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 목록 반환 |
| 403 | 권한 없음 |
| 404 | 부스 없음 |

---

### DELETE `/catch/booths/{boothId}/managers/{userId}` 🔒
부스 관리자 해제 (앱 관리자)

**Path Parameters**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| boothId | string | ✅ | 부스 UUID |
| userId | string | ✅ | 유저 UUID |

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 해제 완료 |
| 403 | 권한 없음 |
| 404 | 매핑 없음 |

---

## 6. 대기열 (Queues)

### POST `/catch/queues/enqueue` 🔒
대기열 등록 (좌석이 비어 있으면 즉시 입장)

**Request Body**
```json
{
  "boothId": "uuid"  // required
}
```

**Response Example (201)**
```json
{
  "data": {
    "mode": "WAITING",  // "IN_SERVICE" | "WAITING"
    "remainingSeats": 2,
    "entry": {
      "id": "uuid",
      "boothId": "uuid",
      "userId": "uuid",
      "ticketNo": 15,
      "state": "WAITING",
      "joinedAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 201 | 등록 결과 |
| 400 | 잘못된 요청 |
| 401 | 인증 필요 |
| 404 | 부스 없음 |
| 409 | 이미 대기 또는 이용 중 |

---

### POST `/catch/queues/cancel` 🔒
내 대기 취소

**Request Body**
```json
{
  "boothId": "uuid"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 취소 완료 |
| 400 | 잘못된 요청 |
| 401 | 인증 필요 |
| 404 | 대기 없음 |

---

### POST `/catch/queues/me-status` 🔒
내 대기 순번 조회

**Request Body**
```json
{
  "boothId": "uuid"  // required
}
```

**Response Example (200)**
```json
{
  "data": {
    "boothId": "uuid",
    "userId": "uuid",
    "ticketNo": 15,
    "state": "WAITING",
    "teamsAhead": 3,
    "position": 4
  }
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 대기 정보 |
| 400 | 잘못된 요청 |
| 401 | 인증 필요 |
| 404 | 대기 없음 |

---

### POST `/catch/admin/queues/list` 🔒
부스 대기 목록 조회 (admin)

**Request Body**
```json
{
  "boothId": "uuid"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 대기 목록 |
| 400 | 잘못된 요청 |
| 401 | 인증 필요 |
| 403 | 권한 없음 |
| 404 | 부스 없음 |

---

### POST `/catch/admin/queues/rotate` 🔒
이용 종료 + 다음 팀 입장 (admin)

**Request Body**
```json
{
  "boothId": "uuid"  // required
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 200 | 회전 완료 |
| 400 | 잘못된 요청 |
| 401 | 인증 필요 |
| 403 | 권한 없음 |
| 404 | 부스 없음 |

---

## 7. 크롤러 (Crawler)

### POST `/crawler/notices`
크롤링 결과 업로드 (워커 → Node)

**Request Body**
```json
{
  "sourceId": "33333333-3333-3333-3333-333333333333",
  "baseUrl": "https://portal.sejong.edu",
  "category": "notice",
  "items": [
    {
      "href": "/notice/123",           // required
      "title": "시험 일정 안내",
      "summary": "2024-2학기 중간/기말 시험 일정",
      "category": "학사",
      "date": "2024-10-01",
      "published_at": "2024-10-01T09:00:00Z",
      "views": 120,
      "meta": {
        "writer": "교무처"
      }
    }
  ]
}
```

**Responses**
| Status | Description |
|--------|-------------|
| 204 | 업로드 완료 |
| 400 | 잘못된 요청 |
| 403 | 권한 없음 |
| 500 | 서버 오류 |

---

### GET `/crawler/crawl-results`
전체 크롤링 결과 조회

**Response Example (200)**
```json
{
  "data": [
    {
      "id": "uuid",
      "noticeKey": "notice-123",
      "articleNo": "123",
      "title": "시험 일정 안내",
      "url": "https://portal.sejong.edu/notice/123",
      "category": "학사",
      "views": 120,
      "publishedAt": "2024-10-01T09:00:00Z"
    }
  ]
}
```

---

## 8. 스키마 (Schemas)

### User
```typescript
{
  id: string;          // uuid
  email: string;       // email format
  name: string;
  role: "student" | "admin";
  major: string | null;
  year: number | null;
  createdAt: string;   // date-time
  updatedAt: string;   // date-time
}
```

### LoginResponse
```typescript
{
  user: User;
  accessToken: string;   // JWT access token
  refreshToken: string;  // JWT refresh token
}
```

### ErrorResponse
```typescript
{
  message: string;
}
```

### CatchBoothMaster
```typescript
{
  id: string;          // uuid
  name: string;
  createdAt: string;   // date-time
  updatedAt: string;   // date-time
}
```

### CatchBoothObject
```typescript
{
  id: string;          // uuid
  masterId: string;    // uuid
  title: string;
  seatCount: number;
  avgWaitMinutes: number;
  status: "PREPARING" | "OPERATING" | "ENDED";
  createdAt: string;   // date-time
  updatedAt: string;   // date-time
}
```

### CatchBoothManager
```typescript
{
  id: string;          // uuid
  boothObjectId: string;  // uuid
  userId: string;      // uuid
  createdAt: string;   // date-time
}
```

### CatchQueueEntry
```typescript
{
  id: string;          // uuid
  boothId: string;     // uuid
  userId: string;      // uuid
  ticketNo: number;
  state: "WAITING" | "IN_SERVICE" | "COMPLETED" | "CANCELED";
  joinedAt: string;    // date-time
}
```

### CatchQueueEnqueueResult
```typescript
{
  mode: "IN_SERVICE" | "WAITING";
  remainingSeats: number;
  entry: CatchQueueEntry;
}
```

### CrawlResult
```typescript
{
  id: string;          // uuid
  noticeKey: string | null;
  articleNo: string | null;
  title: string;
  url: string;         // uri format
  category: string | null;
  views: number;
  publishedAt: string | null;  // date-time
}
```

---

## 범례

| 아이콘 | 의미 |
|--------|------|
| 🔒 | 인증 필요 (Bearer Token) |
| ✅ | 필수 파라미터 |
