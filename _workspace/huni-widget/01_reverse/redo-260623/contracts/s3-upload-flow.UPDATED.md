# S3/Garage 업로드 플로우 (갱신본 260623)

> R2 산출. 기존 `01_reverse/s3-upload-flow.md`(4월 위젯·S3만) → 6월 라이브 보강(Garage 추가).
> 모든 항목 근거 표기. 비밀값 [REDACTED].

## 1. 두 업로드 경로 (Garage 1차 + AWS 폴백) [라이브 검증]

위젯은 `isUseGarage="Y"` + uploadType="pdf"이면 GarageUploader를 렌더하고, Garage 발급 실패 시 AWS로 폴백한다.

```
GarageUploader.upload(file):
  validate(file)                         # PDF MIME or .pdf, size < 상한
  try:
    {filename, presignedURL} = POST {is}/api/garage/presigned-url  body {filename: file.name}
    PUT presignedURL  (Content-Type: file.type||application/pdf, body: file)  # status==200 필수
    s3_region = "GA"
  catch:
    {filename, presignedURL} = POST {is}/api/aws/presigned-url     body {filename: file.name}
    PUT presignedURL ...
    s3_region = "AWS"
  emit "upload" [{ gbn:"I", new_file_nm:filename, new_file_size:file.size,
                   org_file_nm:file.name, s3_file_size:null, s3_region }]
delete: emit "upload" [{ gbn:"D" }]
```
- `is` = `https://widget-api.redprinting.co.kr` [라이브 검증].
- deob 위치: GarageUploader L18233–18368, 폴백 L18302–18317, emit payload L18264–18274.

## 2. presigned 응답·발급 [라이브 검증]
| 항목 | Garage | AWS(폴백) |
|------|--------|-----------|
| upload host | `s3.redprinting.net` (자체호스팅 Garage 오브젝트스토어) | `s3.ap-northeast-2.amazonaws.com` |
| region(서명) | `garage` | `ap-northeast-2` |
| credential | `GK…` [REDACTED] | `AKIA…` [REDACTED] |
| bucket | `redprintingweb.tempo` | `redprintingweb.tempo` |
| object key | `<UUID>.pdf` | `<UUID>.pdf` |
| 만료 | X-Amz-Expires=3600(60분) | 3600 |
| payload | UNSIGNED-PAYLOAD | UNSIGNED-PAYLOAD |
| 서명 | AWS4-HMAC-SHA256 | AWS4-HMAC-SHA256 |

- PUT 라이브 200 검증(Garage). 샘플(redacted): `redo-260623/captures/garage-presigned-sample.json`.

## 3. 후니 어댑터 시사점
- 후니는 자체 업로드(S3/MinIO 등) 경로로 치환. 정규화 계약 경계 = `{new_file_nm, org_file_nm, file_size, region}` upload 이벤트.
- region 판별자(GA/AWS)는 후니에선 단일 스토어면 불요(어댑터서 흡수).

## 4. 미확정
- 서버측 isUseGarage 결정 로직. Garage/AWS 선택 서버 정책.
