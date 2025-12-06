Admin


PATCH
/core/admin/users/{userId}/role
유저 역할 변경 (admin ↔ student)

Parameters
Try it out
Name	Description
userId *
string
(path)
userId
Request body

application/json
Example Value
Schema
{
  "role": "admin"
}
Responses
Code	Description	Links
204	
변경 완료

No links
400	
잘못된 요청

No links
404	
유저 없음

------------------

Auth

------------------
/auth/login

request body
{
  "studentId": "21000000",
  "password": "P@ssw0rd!"
}

response body
Code	Description	Links
200	
로그인 성공

Media type

application/json
Controls Accept header.
Example Value
Schema
{
  "user": {
    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "email": "user@example.com",
    "name": "string",
    "role": "student",
    "major": "string",
    "year": 0,
    "createdAt": "2025-12-05T23:26:03.472Z",
    "updatedAt": "2025-12-05T23:26:03.472Z"
  },
  "accessToken": "string",
  "refreshToken": "string"
}
No links
400	
필수 값 누락

Media type

application/json
Example Value
Schema
{
  "message": "string"
}
No links
401	
인증 실패

Media type

application/json
Example Value
Schema
{
  "message": "string"
}

------------------
POST
/auth/logout
refreshToken 무효화

Parameters
Try it out
No parameters

Request body

application/json
Example Value
Schema
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
Responses
Code	Description	Links
204	
로그아웃 성공 (본문 없음)

No links
400	
필수 값 누락

Media type

application/json
Example Value
Schema
{
  "message": "string"
}

-----------------

POST
/auth/refresh
저장된 refresh 토큰 검증 후 access 토큰 재발급 (refresh 유지)

Parameters
Try it out
No parameters

Request body

application/json
Example Value
Schema
{
  "studentId": "21000000"
}
Responses
Code	Description	Links
200	
재발급 성공

Media type

application/json
Controls Accept header.
Example Value
Schema
{
  "user": {
    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "email": "user@example.com",
    "name": "string",
    "role": "student",
    "major": "string",
    "year": 0,
    "createdAt": "2025-12-05T23:27:22.761Z",
    "updatedAt": "2025-12-05T23:27:22.761Z"
  },
  "accessToken": "string",
  "refreshToken": "string"
}
No links
400	
필수 값 누락

Media type

application/json
Example Value
Schema
{
  "message": "string"
}
No links
401	
refresh 토큰이 만료/유효하지 않음

Media type

application/json
Example Value
Schema
{
  "message": "string"
}
No links
404	
사용자 또는 refresh 토큰 없음

Media type

application/json
Example Value
Schema
{
  "message": "string"
}

-------------------------

Catch

-------------------------
POST
/catch/booths/{boothId}/managers
부스 관리자 추가 (앱 관리자)


Parameters
Try it out
Name	Description
boothId *
string
(path)
boothId
Request body

application/json
Example Value
Schema
{
  "userId": "22222222-2222-2222-2222-222222222222"
}
Responses
Code	Description	Links
201	
매핑 생성

No links
400	
잘못된 요청

No links
403	
권한 없음

No links
404	
부스/유저 없음

No links
409	
이미 매핑됨

-------------------

GET
/catch/booths/{boothId}/managers
부스 관리자 목록 조회 (앱 관리자)


Parameters
Try it out
Name	Description
boothId *
string
(path)
boothId
Responses
Code	Description	Links
200	
목록 반환

No links
403	
권한 없음

No links
404	
부스 없음

----------------------

DELETE
/catch/booths/{boothId}/managers/{userId}
부스 관리자 해제 (앱 관리자)


Parameters
Try it out
Name	Description
boothId *
string
(path)
boothId
userId *
string
(path)
userId
Responses
Code	Description	Links
204	
해제 완료

No links
403	
권한 없음

No links
404	
매핑 없음

No links

---------------------

POST
/catch/booth-masters
부스 타입 생성 (관리자)


Parameters
Try it out
No parameters

Request body

application/json
Example Value
Schema
{
  "name": "게임"
}
Responses
Code	Description	Links
201	
생성 완료

No links
400	
잘못된 요청

No links
409	
이름 중복

No links

-----------------------------
GET
/catch/booth-masters
부스 타입 목록 조회 (관리자)


Parameters
Try it out
No parameters

Responses
Code	Description	Links
200	
목록 반환

Media type

application/json
Controls Accept header.
Example Value
Schema
{
  "data": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "name": "string",
      "createdAt": "2025-12-05T23:32:01.279Z",
      "updatedAt": "2025-12-05T23:32:01.279Z"
    }
  ]

  -------------------------

PATCH
/catch/booth-masters/{id}
부스 타입 수정 (관리자)


Parameters
Try it out
Name	Description
id *
string
(path)
id
Request body

application/json
Example Value
Schema
{
  "name": "보드게임"
}
Responses
Code	Description	Links
200	
수정 완료

No links
400	
잘못된 요청

No links
404	
대상 없음

No links
409	
이름 중복

-----------------------------------

DELETE
/catch/booth-masters/{id}
부스 타입 삭제 (관리자)


Parameters
Try it out
Name	Description
id *
string
(path)
id
Responses
Code	Description	Links
204	
삭제 완료

No links
404	
대상 없음

--------------------------------------

POST
/catch/booths
부스 생성 (관리자/부스 관리자)


Parameters
Try it out
No parameters

Request body

application/json
Example Value
Schema
{
  "masterId": "11111111-1111-1111-1111-111111111111",
  "title": "다트 게임",
  "seatCount": 4,
  "avgWaitMinutes": 10
}
Responses
Code	Description	Links
201	
생성 완료

No links
400	
잘못된 요청

No links
403	
권한 없음

No links
404	
master 없음

-------------------------

