# S3 Presigned URL 업로드 플로우 (라이브 검증)

> 파이프라인 ① 1순위 미검증 영역. 라이브 테스트베드에서 presigned 발급 → 실제 S3 PUT 까지 end-to-end 검증 완료.
> 캡처: `01_reverse/captures/presigned_response_sample.json` (서명 REDACTED)
> 근거: `[라이브 검증]` = 실 HTTP 응답 / `[정적 분석]` = `deob_06_app_widget_sdk.js:545-561`

---

## 1. 발급 엔드포인트 [라이브 검증]

**`POST https://widget-api.redprinting.co.kr/api/aws/presigned-url`**
(로컬 프록시 경로: `POST /widget-api/api/aws/presigned-url`)

### 요청
```json
{ "file_name": "<원본 파일명>.pdf",
  "pdt_cod": "PRBKYPR",
  "content_type": "application/pdf" }
```
인증: 세션 쿠키 + (위젯 컨텍스트에서) `red-editor-token` 헤더. 라이브 호출 HTTP 200.

### 응답 [라이브 검증, HTTP 200]
```json
{
  "filename": "c2272057-a558-43be-8191-e14d49a5faf8.pdf",   // 서버 생성 UUID 파일명
  "presignedURL": "https://s3.ap-northeast-2.amazonaws.com/redprintingweb.tempo/<uuid>.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=[REDACTED-AKID]/<date>/ap-northeast-2/s3/aws4_request&X-Amz-Date=...&X-Amz-Expires=3600&X-Amz-Signature=[REDACTED]&X-Amz-SignedHeaders=...&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&x-amz-checksum-crc32=...&x-amz-sdk-checksum-algorithm=CRC32&x-id=PutObject"
}
```

응답 구조 분석 [라이브 검증]:
| 요소 | 값 | 의미 |
|------|----|----|
| `filename` | UUID v4 + `.pdf` | 서버가 충돌 방지용 새 파일명 생성. 클라이언트는 이 값을 주문 데이터에 보관 |
| S3 host | `s3.ap-northeast-2.amazonaws.com` | 서울 리전 |
| 버킷 | `redprintingweb.tempo` | **임시(tempo)** 업로드 버킷. 주문 확정 시 영구 버킷으로 이동 추정 |
| `X-Amz-Expires` | `3600` | presigned URL 유효시간 60분 |
| `X-Amz-Content-Sha256` | `UNSIGNED-PAYLOAD` | 본문 해시 미검증 → 단순 PUT 가능 |
| `x-id` | `PutObject` | PUT 전용 |
| 쿼리에 `x-amz-checksum-crc32` 포함 | - | AWS SDK가 CRC32 체크섬을 서명에 포함 |

> 자격증명(AKID·Signature)은 산출물에서 마스킹. 원본 캡처 시각: 2026-06-02. presigned는 발급 시점 1회용·60분 만료.

---

## 2. 업로드 PUT [라이브 검증]

**`PUT <presignedURL>`** — 본문에 파일 바이너리 직접 전송 (S3 직접, RedPrinting 서버 경유 없음).

```
PUT https://s3.ap-northeast-2.amazonaws.com/redprintingweb.tempo/<uuid>.pdf?...
Content-Type: application/pdf
Body: <PDF binary>
```
라이브 검증: 프로브 PDF(68 bytes) PUT → **HTTP 200**, 빈 응답 본문. 업로드 성공 확인.

> 주의: presigned 쿼리에 `X-Amz-SignedHeaders`·`x-amz-checksum-crc32`가 포함되므로, 운영 위젯의 실제 PUT은 동일 `Content-Type`과 (SDK 사용 시) checksum 헤더를 맞춰야 한다. 본 검증은 `Content-Type: application/pdf` + UNSIGNED-PAYLOAD 조합으로 성공.

---

## 3. 전체 플로우 (S3Uploader 컴포넌트) [정적 분석 + 라이브 검증]

`deob_06_app_widget_sdk.js:545-561` S3Uploader 컴포넌트 (원본 mod_06 line 2031~2165):

```
1. 파일 선택 (드래그&드롭 또는 파일 선택기)
2. 파일 유효성 검증 (확장자=application/pdf, 크기 제한 1GB)        [정적 분석]
3. POST /api/aws/presigned-url → { presignedURL, filename } 획득   [라이브 검증]
4. PUT presignedURL (S3 직접 업로드)                              [라이브 검증]
5. 업로드 결과를 부모에 emit('upload', 파일정보배열)              [정적 분석]
```

### 업로드 후 파일 정보 조회 [정적 분석]

`deob_05_app_api.js:1167 fetchS3FileInfo()`:
**`POST /ko/product/s3GetObjectJson`** body `{ file_name: <uuid>.pdf }` → 업로드된 파일 메타데이터(크기 등). 페이지수/사이즈 검증 용도. (presigned 발급과 별개 — RedPrinting 본 서버 경유)

### 주문 데이터에 반영되는 파일 정보 형태 [정적 분석]

`deob_06:1171-1193` `fileUploadInfo` 배열:
- `fileUploadInfo[0]` = 내지(inner), `fileUploadInfo[1]` = 표지(default)
- 각 항목: `{ org_file_nm (원본명), ... s3 filename ... }`
- 검증: 둘 다 필수일 때 누락 시 `주문불가-파일`, 내지·표지 `org_file_nm` 동일 시 `주문불가-파일명중복`

---

## 4. 후니 시사점

1. **업로드는 S3 직접(presigned PUT)** — 후니 위젯도 동일 패턴. 후니 어댑터가 `/presigned-url` 계약(요청: file_name·pdt_cod·content_type / 응답: filename·presignedURL)만 후니 백엔드에 맞춰주면 위젯 코드 불변.
2. 임시 버킷(`*.tempo`) → 주문확정 영구화 2단계. 후니도 임시/영구 분리 권장(미결제 업로드 정리 용이).
3. presigned 60분 만료 — 위젯은 업로드 직전 발급해야 함(미리 발급 금지).
4. 파일 키는 서버 생성 UUID — 클라이언트 파일명 노출/충돌 방지.

## 5. 잔존 미검증

- presigned 쿼리의 정확한 `X-Amz-SignedHeaders` 목록과 checksum 강제 여부(운영 위젯 SDK가 PUT 시 보내는 정확한 헤더 셋) — 프로브는 최소 헤더로 성공했으나 SDK 실 PUT 헤더는 미캡처. [미검증]
- 1GB 크기 제한·허용 확장자 화이트리스트의 서버측 강제 — 클라이언트 검증만 확인. [정적 분석, 서버측 미검증]
- 임시→영구 버킷 이동 시점/주체(주문확정 API) — 미캡처. [미검증]
