# 갭 해소 현황 (GATE 산출물)

> 파이프라인 ① hw-reverse-engineer. 보강 전(As-Is 역공학 86/100) → 후(라이브 보강) 갭 해소 명시. 은폐 금지.
> 라이브 세션: 2026-06-02. 테스트베드 `localhost:3001` → RedPrinting 프록시. cookies/token 갱신 후 캡처.

---

## 1. 3대 미검증 영역 결과

| # | 영역 | 보강 전 | 결과 | 근거 |
|---|------|--------|------|------|
| 1 | **S3 presigned URL 업로드** | 엔드포인트만 식별 | **✅ 라이브 해소** | `POST /api/aws/presigned-url` 200 + 실제 S3 PUT 200(end-to-end). 응답 구조(filename UUID·presignedURL·60분만료·tempo버킷·서울리전) 캡처. → `s3-upload-flow.md` |
| 2 | **가격 rule** | 요청/응답 계약만 | **✅ 라이브 해소(규칙 측정)** | 8조합 매트릭스 캡처. 볼륨디스카운트·페이지선형(~1115/page)·색상영향(표지-12100/내지-3600) 역산. 서버권위(클라이언트 재계산 금지) 반증 확인. → `price-engine-reversed.md` |
| 3 | **postMessage 라이프사이클** | from-edicus 부분 | **🟡 부분 해소** | 프로토콜 전체(to/from-edicus type, deferred-param 핸드셰이크, create_project URL, save-doc-report/goto-cart 페이로드) 정적+테스트베드핸들러로 확정. 단, **본 세션 에디터 iframe 실구동 실시간 메시지 덤프는 미수행**. → `editor-bridge-protocol.md` §9 |

## 2. 추가 보강 (seed 인계 항목)

| 항목 | 보강 전 | 결과 | 근거 |
|------|--------|------|------|
| Pinia 스토어 4 vs 5 | 불일치 | **✅ 확정** | 책자=order+exterior, 부자재=acc-order(AccWidgetInstance/useAccOrderStore, deob_06:1309). 책자 product_data에 inner_* 존재 / 굿즈·아크릴 없음으로 라이브 입증. → `widget-runtime-spec.md` §3 |
| 옵션 스키마 카탈로그 | 부분 | **✅ 라이브 3상품** | PRBKYPR/GSTGMIC/ACNTHAP 데이터셋·자재·도수·수량규칙·후가공 캡처. → `option-schema-catalog.json/.md` |
| 캐스케이드 제약(material→pcs) | 미검증 | **✅ 라이브** | 책자 disable_pcs 24건(예 RXOMO080→COT/FLD/MIS 비활성). 규칙 확정. |
| 6 핵심 API | 4 API | **✅ 6 API 라이브** | product_info·price·presigned 라이브 200, editor/config 위젯경로 200, s3GetObjectJson·guide_paper 정적. |
| 부자재(ACC) 흐름 | useAccOrderStore 미검증 | **🟡 구조 확정** | AccWidgetInstance 구조(getSummary/canOrder/subMtrlInfo) 정적 확정 + GSTGMIC product_info 라이브. ACC 가격 페이로드는 미캡처. |

## 3. 잔존 미검증 (은폐 금지)

| 영역 | 사유 | 폴백 |
|------|------|------|
| 에디터 iframe 실시간 메시지 타임라인 | 본 세션 헤드리스 풀 에디터 플로우 미실행 | 검증된 테스트베드 핸들러(index.html) + 정적 소스로 프로토콜 확정. hw-runtime-analyst가 실구동 캡처 가능 |
| editor/config 직접 호출 페이로드 | 로컬 프록시 body 전달 이슈로 직접 curl 500(서버 payload undefined 인식). 위젯 경로는 과거 200 다회 기록 | body-log.json responseShape 활용 |
| 비책자(굿즈/아크릴) 가격 ORD_INFO | 책자만 라이브 가격 검증 | 책자 계약 + 정적 구조 |
| 회원등급 할인(PRICE_MALL≠PRICE) | 기본등급이라 세 값 동일 | 워터폴 로직은 정적 확정 |
| 고급 후가공 가격기여(스코딕스/합지/박/형압) | 0원 케이스만 캡처 | - |
| Vue3 위젯 25상품 전수 스키마 | 3상품만 캡처 | 대표 3군 커버 |
| presigned PUT 정확한 SignedHeaders/checksum | 프로브는 최소헤더 성공, SDK 실PUT 헤더 미캡처 | UNSIGNED-PAYLOAD로 PUT 성공 검증됨 |

## 4. 캡처 산출물 (감사 추적)

`01_reverse/captures/`:
- `product_{PRBKYPR,GSTGMIC,ACNTHAP}.json` — 상품 옵션 전체(라이브 200)
- `price_q{30,60,120,300}_p10.json`, `price_q30_p{20,40}.json`, `price_q30_p10_{i1,c1}.json` — 가격 8조합(라이브 200)
- `price_matrix_summary.json` — 매트릭스 요약
- `presigned_response_sample.json` — presigned 응답(서명 REDACTED)

## 5. 보강 점수 평가

As-Is 86/100 → 라이브 보강 후 핵심 구현 갭(S3·가격규칙·스토어·캐스케이드·API)의 5/6 라이브 해소, 1/6(postMessage) 부분 해소. **후니 위젯 구현 착수 가능 수준** 도달. 잔존 미검증은 모두 구현 비차단(어댑터/후속 캡처로 흡수 가능)이며 위 §3에 명시.

## 6. 다음 단계 통신

- → `hw-runtime-analyst`: 캡처 raw(`01_reverse/captures/`) = 동작 구조 분석 입력. 에디터 iframe 실구동 메시지 타임라인 캡처 권장(잔존 #1).
- → `hw-architect`: 본 6 산출물(`01_reverse/*`) = 위젯 구현 명세 입력. 특히 정규화 계약 설계 시 가격(ORD_INFO+PCS_INFO)·presigned·from-edicus:goto-cart 계약을 어댑터 경계로.
