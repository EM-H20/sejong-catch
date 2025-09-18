# 🗄️ 세종 캐치 - 축제 줄서기 시스템 데이터베이스 스키마

## 📋 개요
세종대학교 축제 줄서기 시스템을 위한 데이터베이스 스키마 설계입니다.
실제 물리적 줄서기(치킨부스, 주점, 무대공연 등)를 디지털로 관리합니다.

---

## 🏗️ 테이블 구조

### 1. **users** 테이블 (사용자 관리)
```sql
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    username VARCHAR(50) NOT NULL,
    display_name VARCHAR(100),
    role ENUM('guest', 'student', 'operator', 'admin') DEFAULT 'guest',
    phone VARCHAR(20),
    department VARCHAR(100),
    student_id VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,

    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_student_id (student_id)
);
```

### 2. **queues** 테이블 (줄서기 큐 관리) 🎪
```sql
CREATE TABLE queues (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    type ENUM('food', 'drink', 'event', 'game', 'photo', 'other') NOT NULL,
    location VARCHAR(200) NOT NULL,
    status ENUM('waiting', 'active', 'paused', 'closed', 'full') DEFAULT 'waiting',

    -- 운영자 정보
    operator_id VARCHAR(50) NOT NULL,
    operator_name VARCHAR(100) NOT NULL,

    -- 용량 관리
    max_capacity INT DEFAULT 0, -- 0이면 무제한
    current_count INT DEFAULT 0,
    average_wait_time INT DEFAULT 0, -- 분 단위

    -- 시간 정보
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_time TIMESTAMP NULL,
    end_time TIMESTAMP NULL,

    -- 추가 정보
    image_url VARCHAR(500),
    notice TEXT, -- 공지사항 (예: "현재 치킨이 부족합니다")

    FOREIGN KEY (operator_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_type (type),
    INDEX idx_status (status),
    INDEX idx_location (location),
    INDEX idx_operator (operator_id),
    INDEX idx_created_at (created_at)
);
```

### 3. **queue_participants** 테이블 (줄서기 참가자) 👥
```sql
CREATE TABLE queue_participants (
    id VARCHAR(50) PRIMARY KEY,
    queue_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    user_name VARCHAR(100) NOT NULL, -- 비정규화 (성능)

    -- 순번 관리
    position INT NOT NULL, -- 현재 순번 (1부터 시작)
    status ENUM('waiting', 'called', 'serving', 'completed', 'cancelled', 'no_show') DEFAULT 'waiting',

    -- 시간 추적
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    called_at TIMESTAMP NULL, -- 호출된 시간
    completed_at TIMESTAMP NULL, -- 완료된 시간

    -- 연락처 및 메모
    user_phone VARCHAR(20),
    note TEXT, -- 특별 요청사항

    FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_queue_position (queue_id, position),
    INDEX idx_user_status (user_id, status),
    INDEX idx_status (status),
    INDEX idx_joined_at (joined_at),

    -- 한 사용자는 같은 큐에 중복 참가 불가
    UNIQUE KEY unique_user_queue (user_id, queue_id)
);
```

### 4. **queue_history** 테이블 (줄서기 이력 추적) 📊
```sql
CREATE TABLE queue_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    queue_id VARCHAR(50) NOT NULL,
    participant_id VARCHAR(50),
    action_type ENUM('queue_created', 'queue_opened', 'queue_paused', 'queue_closed',
                     'user_joined', 'user_called', 'user_served', 'user_completed',
                     'user_cancelled', 'user_no_show') NOT NULL,

    -- 상태 변화 추적
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    old_position INT,
    new_position INT,

    -- 시간 및 메타데이터
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50), -- 액션을 수행한 사용자
    metadata JSON, -- 추가 정보 (대기시간, 메모 등)

    FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE CASCADE,
    FOREIGN KEY (participant_id) REFERENCES queue_participants(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_queue_created (queue_id, created_at),
    INDEX idx_participant (participant_id),
    INDEX idx_action_type (action_type)
);
```

### 5. **queue_notifications** 테이블 (알림 관리) 🔔
```sql
CREATE TABLE queue_notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    queue_id VARCHAR(50) NOT NULL,
    participant_id VARCHAR(50),

    type ENUM('position_update', 'call_notification', 'queue_paused',
              'queue_closed', 'reminder') NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,

    -- 상태 관리
    is_read BOOLEAN DEFAULT false,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- 알림 채널
    send_push BOOLEAN DEFAULT true,
    send_sms BOOLEAN DEFAULT false,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE CASCADE,
    FOREIGN KEY (participant_id) REFERENCES queue_participants(id) ON DELETE CASCADE,
    INDEX idx_user_unread (user_id, is_read),
    INDEX idx_queue_type (queue_id, type),
    INDEX idx_created_at (created_at)
);
```

### 6. **queue_settings** 테이블 (큐 설정 관리) ⚙️
```sql
CREATE TABLE queue_settings (
    queue_id VARCHAR(50) PRIMARY KEY,

    -- 알림 설정
    notify_before_minutes INT DEFAULT 5, -- 몇 분 전에 알림
    auto_call_enabled BOOLEAN DEFAULT false, -- 자동 호출 여부
    call_timeout_minutes INT DEFAULT 5, -- 호출 타임아웃

    -- 운영 규칙
    allow_early_departure BOOLEAN DEFAULT true, -- 조기 이탈 허용
    max_wait_time_minutes INT DEFAULT 60, -- 최대 대기 시간
    position_buffer INT DEFAULT 3, -- 위치 버퍼 (몇 번째까지 미리 준비)

    -- 표시 설정
    show_wait_time BOOLEAN DEFAULT true,
    show_position BOOLEAN DEFAULT true,
    show_operator_contact BOOLEAN DEFAULT false,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE CASCADE
);
```

---

## 📊 뷰(View) 정의

### 1. **active_queues_view** - 활성 큐 요약
```sql
CREATE VIEW active_queues_view AS
SELECT
    q.id,
    q.title,
    q.type,
    q.location,
    q.status,
    q.current_count,
    q.max_capacity,
    q.average_wait_time,
    q.operator_name,
    q.notice,
    CASE
        WHEN q.max_capacity > 0 THEN (q.current_count / q.max_capacity * 100)
        ELSE 0
    END as capacity_percentage,
    q.created_at,
    q.updated_at
FROM queues q
WHERE q.status IN ('active', 'waiting', 'paused')
ORDER BY q.created_at DESC;
```

### 2. **user_queue_summary_view** - 사용자별 큐 참가 현황
```sql
CREATE VIEW user_queue_summary_view AS
SELECT
    u.id as user_id,
    u.username,
    COUNT(qp.id) as total_participations,
    COUNT(CASE WHEN qp.status = 'waiting' THEN 1 END) as waiting_count,
    COUNT(CASE WHEN qp.status = 'called' THEN 1 END) as called_count,
    COUNT(CASE WHEN qp.status = 'completed' THEN 1 END) as completed_count,
    COUNT(CASE WHEN qp.status = 'cancelled' THEN 1 END) as cancelled_count,
    MAX(qp.joined_at) as last_joined_at
FROM users u
LEFT JOIN queue_participants qp ON u.id = qp.user_id
GROUP BY u.id, u.username;
```

---

## 🔍 주요 인덱스 전략

### 성능 최적화를 위한 복합 인덱스
```sql
-- 큐별 대기 순서 조회 최적화
CREATE INDEX idx_queue_waiting_position ON queue_participants(queue_id, status, position);

-- 사용자별 활성 참가 조회 최적화
CREATE INDEX idx_user_active_participations ON queue_participants(user_id, status, joined_at);

-- 시간대별 큐 현황 조회 최적화
CREATE INDEX idx_queue_time_status ON queues(status, start_time, end_time);

-- 알림 발송 최적화
CREATE INDEX idx_notifications_pending ON queue_notifications(is_sent, created_at);
```

---

## 🚀 확장 고려사항

### 1. **큐 템플릿 시스템**
```sql
-- 자주 사용되는 큐 설정을 템플릿으로 저장
CREATE TABLE queue_templates (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('food', 'drink', 'event', 'game', 'photo', 'other'),
    default_capacity INT,
    default_wait_time INT,
    settings JSON, -- 기본 설정들
    created_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. **실시간 위치 추적** (향후 확장)
```sql
-- 실제 물리적 위치와 연동 (QR코드, NFC 등)
CREATE TABLE queue_checkpoints (
    id VARCHAR(50) PRIMARY KEY,
    queue_id VARCHAR(50) NOT NULL,
    checkpoint_type ENUM('entrance', 'waiting_area', 'service_point', 'exit'),
    qr_code VARCHAR(100) UNIQUE,
    location_coords POINT, -- GPS 좌표
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3. **통계 및 분석** (BigQuery/ClickHouse 고려)
```sql
-- 큐 성능 분석을 위한 집계 테이블
CREATE TABLE queue_daily_stats (
    date DATE,
    queue_id VARCHAR(50),
    total_participants INT,
    average_wait_time DECIMAL(5,2),
    completion_rate DECIMAL(5,2),
    peak_hour TINYINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (date, queue_id)
);
```

---

## 🔐 보안 및 권한

### RBAC (Role-Based Access Control) 구현
```sql
-- 테이블별 권한 설정 예시
GRANT SELECT ON queues TO 'guest_role';
GRANT SELECT, INSERT ON queue_participants TO 'student_role';
GRANT ALL PRIVILEGES ON queues TO 'operator_role';
GRANT ALL PRIVILEGES ON *.* TO 'admin_role';
```

---

## 📈 성능 모니터링 쿼리

### 자주 사용될 핵심 쿼리들
```sql
-- 1. 활성 큐 목록 (메인 화면)
SELECT * FROM active_queues_view WHERE status = 'active';

-- 2. 사용자의 현재 참가 현황
SELECT qp.*, q.title, q.location
FROM queue_participants qp
JOIN queues q ON qp.queue_id = q.id
WHERE qp.user_id = ? AND qp.status IN ('waiting', 'called', 'serving');

-- 3. 큐의 현재 대기 순서
SELECT position, user_name, joined_at, note
FROM queue_participants
WHERE queue_id = ? AND status = 'waiting'
ORDER BY position;

-- 4. 호출 대상 조회 (운영자용)
SELECT * FROM queue_participants
WHERE queue_id = ? AND status = 'waiting'
ORDER BY position LIMIT 1;
```

---

이 스키마는 **확장성**, **성능**, **실시간성**을 고려하여 설계되었으며,
세종대학교 축제의 모든 줄서기 시나리오를 효율적으로 처리할 수 있습니다! 🎉