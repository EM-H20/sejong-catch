# 🔌 세종 캐치 - 축제 줄서기 API 명세서

## 📋 개요
세종대학교 축제 줄서기 시스템을 위한 RESTful API 명세서입니다.
Node.js 백엔드 서버와 Flutter 앱 간의 통신 규격을 정의합니다.

**Base URL**: `https://api.sejong-catch.com/v1`

---

## 🔐 인증 시스템

### Headers
```http
Authorization: Bearer {access_token}
Content-Type: application/json
X-Client-Version: 1.0.0
```

### 토큰 교환 플로우
1. Python 인증 서버 → `sejong_token` 발급
2. `/auth/exchange` → Node.js 앱 토큰 교환
3. 이후 모든 API 요청에 `access_token` 사용

---

## 🎪 Queue API

### 1. 큐 목록 조회
```http
GET /queues
```

**Query Parameters:**
- `status` (optional): `active`, `waiting`, `paused`, `closed`, `full`
- `type` (optional): `food`, `drink`, `event`, `game`, `photo`, `other`
- `location` (optional): 위치 필터링
- `limit` (optional): 페이지 크기 (기본: 20)
- `offset` (optional): 페이지 오프셋 (기본: 0)

**Response:**
```json
{
  "success": true,
  "data": {
    "queues": [
      {
        "id": "queue_chicken_bbq",
        "title": "BBQ 치킨부스 🔥",
        "description": "갓-갓 치킨! 바싹바싹 맛있어요",
        "type": "food",
        "location": "중앙광장 A구역",
        "status": "active",
        "operatorId": "operator_chicken_1",
        "operatorName": "치킨왕 박사장",
        "maxCapacity": 50,
        "currentCount": 23,
        "averageWaitTime": 8,
        "createdAt": "2024-05-15T10:00:00Z",
        "updatedAt": "2024-05-15T14:30:00Z",
        "startTime": "2024-05-15T11:00:00Z",
        "endTime": "2024-05-15T22:00:00Z",
        "imageUrl": "https://example.com/images/bbq_chicken.jpg",
        "notice": "현재 뿌링클만 있어요!"
      }
    ],
    "totalCount": 25,
    "hasMore": true
  }
}
```

### 2. 특정 큐 상세 조회
```http
GET /queues/{queueId}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "queue": { /* 큐 정보 */ },
    "participants": [
      {
        "position": 1,
        "userName": "홍길동",
        "joinedAt": "2024-05-15T14:05:00Z",
        "estimatedWaitTime": 5
      }
    ],
    "myParticipation": {
      "id": "participant_1",
      "position": 5,
      "status": "waiting",
      "joinedAt": "2024-05-15T14:05:00Z",
      "estimatedWaitTime": 25
    }
  }
}
```

### 3. 큐 생성 (Operator 이상)
```http
POST /queues
```

**Request Body:**
```json
{
  "title": "새로운 치킨부스",
  "description": "맛있는 치킨을 준비했습니다",
  "type": "food",
  "location": "중앙광장 C구역",
  "maxCapacity": 30,
  "startTime": "2024-05-15T12:00:00Z",
  "endTime": "2024-05-15T20:00:00Z",
  "notice": "양념치킨만 판매합니다"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "queue": { /* 생성된 큐 정보 */ }
  }
}
```

### 4. 큐 수정 (Operator)
```http
PUT /queues/{queueId}
```

### 5. 큐 삭제 (Operator)
```http
DELETE /queues/{queueId}
```

---

## 👥 Queue Participants API

### 1. 큐 참가
```http
POST /queues/{queueId}/join
```

**Request Body:**
```json
{
  "note": "뿌링클 2마리 주문 예정",
  "userPhone": "010-1234-5678"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "participant": {
      "id": "participant_123",
      "queueId": "queue_chicken_bbq",
      "position": 15,
      "status": "waiting",
      "estimatedWaitTime": 45,
      "joinedAt": "2024-05-15T14:30:00Z"
    }
  }
}
```

### 2. 큐 탈퇴
```http
DELETE /queues/{queueId}/leave
```

**Response:**
```json
{
  "success": true,
  "message": "줄서기를 취소했습니다"
}
```

### 3. 내 참가 현황 조회
```http
GET /participants/my
```

**Response:**
```json
{
  "success": true,
  "data": {
    "participations": [
      {
        "id": "participant_1",
        "queue": {
          "id": "queue_chicken_bbq",
          "title": "BBQ 치킨부스 🔥",
          "location": "중앙광장 A구역"
        },
        "position": 5,
        "status": "waiting",
        "estimatedWaitTime": 25,
        "joinedAt": "2024-05-15T14:05:00Z"
      }
    ]
  }
}
```

### 4. 참가자 호출 (Operator)
```http
POST /queues/{queueId}/call-next
```

**Response:**
```json
{
  "success": true,
  "data": {
    "calledParticipant": {
      "id": "participant_5",
      "userName": "김고객",
      "userPhone": "010-9876-5432",
      "note": "양념치킨 1마리",
      "calledAt": "2024-05-15T14:35:00Z"
    }
  }
}
```

### 5. 서비스 완료 처리 (Operator)
```http
POST /participants/{participantId}/complete
```

---

## 🔔 Notifications API

### 1. 내 알림 목록
```http
GET /notifications
```

**Query Parameters:**
- `unread` (optional): `true`, `false`
- `type` (optional): `position_update`, `call_notification`, `queue_paused`
- `limit` (optional): 기본 20

**Response:**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "notif_1",
        "type": "call_notification",
        "title": "차례가 되었습니다! 🔥",
        "message": "BBQ 치킨부스에서 호출했습니다. 5분 내에 방문해주세요.",
        "queueId": "queue_chicken_bbq",
        "isRead": false,
        "createdAt": "2024-05-15T14:30:00Z"
      }
    ],
    "unreadCount": 3
  }
}
```

### 2. 알림 읽음 처리
```http
PUT /notifications/{notificationId}/read
```

### 3. 알림 설정 조회/수정
```http
GET /notifications/settings
PUT /notifications/settings
```

---

## 📊 Statistics API (Admin/Operator)

### 1. 큐 통계 조회
```http
GET /queues/{queueId}/stats
```

**Query Parameters:**
- `period`: `hour`, `day`, `week`, `month`
- `startDate`: ISO 8601 날짜
- `endDate`: ISO 8601 날짜

**Response:**
```json
{
  "success": true,
  "data": {
    "summary": {
      "totalParticipants": 145,
      "completionRate": 87.5,
      "averageWaitTime": 12.3,
      "averageServiceTime": 3.5
    },
    "hourlyStats": [
      {
        "hour": 14,
        "participantCount": 23,
        "averageWaitTime": 8,
        "completionRate": 95.6
      }
    ]
  }
}
```

### 2. 전체 큐 현황 대시보드
```http
GET /admin/dashboard
```

---

## 🔄 Real-time Updates (WebSocket)

### 연결
```
WSS /ws/queues/{queueId}
Authorization: Bearer {access_token}
```

### 이벤트 타입
```json
{
  "type": "position_update",
  "data": {
    "participantId": "participant_1",
    "newPosition": 3,
    "estimatedWaitTime": 15
  }
}
```

```json
{
  "type": "queue_status_change",
  "data": {
    "queueId": "queue_chicken_bbq",
    "oldStatus": "active",
    "newStatus": "paused",
    "reason": "재료 보충 중"
  }
}
```

```json
{
  "type": "call_notification",
  "data": {
    "participantId": "participant_1",
    "message": "차례가 되었습니다!",
    "timeoutMinutes": 5
  }
}
```

---

## ❌ 에러 응답 형식

### 표준 에러 응답
```json
{
  "success": false,
  "error": {
    "code": "QUEUE_FULL",
    "message": "대기열이 가득 찼습니다",
    "details": {
      "maxCapacity": 50,
      "currentCount": 50
    }
  }
}
```

### 주요 에러 코드
- `UNAUTHORIZED`: 인증 실패
- `FORBIDDEN`: 권한 부족
- `QUEUE_NOT_FOUND`: 큐를 찾을 수 없음
- `QUEUE_FULL`: 대기열 만석
- `QUEUE_CLOSED`: 운영 종료된 큐
- `ALREADY_IN_QUEUE`: 이미 참가 중
- `PARTICIPANT_NOT_FOUND`: 참가자를 찾을 수 없음
- `INVALID_QUEUE_STATUS`: 잘못된 큐 상태
- `RATE_LIMIT_EXCEEDED`: 요청 한도 초과

---

## 🚀 성능 고려사항

### 1. 캐싱 전략
- **큐 목록**: Redis 캐시 5분
- **큐 상세**: Redis 캐시 1분
- **참가자 순서**: 실시간 업데이트 필요

### 2. Rate Limiting
- **일반 사용자**: 100 req/min
- **운영자**: 500 req/min
- **관리자**: 1000 req/min

### 3. 페이지네이션
- 기본 20개 항목
- 최대 100개 항목

---

## 🔒 보안 고려사항

### 1. 입력 검증
- 모든 사용자 입력 sanitization
- SQL Injection 방지
- XSS 방지

### 2. 권한 체크
```javascript
// 예시: 큐 수정 권한 체크
if (queue.operatorId !== user.id && user.role !== 'admin') {
  throw new ForbiddenError('큐 수정 권한이 없습니다');
}
```

### 3. 로깅 및 모니터링
- 모든 API 요청 로깅
- 의심스러운 활동 모니터링
- 큐 조작 이력 추적

---

이 API 명세서는 세종대학교 축제 줄서기 시스템의 모든 기능을 안정적이고 효율적으로 지원합니다! 🎉