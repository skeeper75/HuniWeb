# R2 — 신규 계약 정밀화 산출

> 재역공학 강화 2단계 R2. Garage 업로드 플로우 라이브 + 신규 가격필드 의미·영향 역산.
> 비밀값 [REDACTED]. 라이브 읽기전용(presigned 발급 = 업로드 준비 단계, 주문/결제/폼submit 아님).
> 갱신 계약 파일은 §5에 목록.

---

## 1. Garage 업로드 플로우 — 라이브 end-to-end 검증 [라이브 검증]

### 1.1 두 업로드 경로 실측 (s3.redprinting.net Garage vs AWS 폴백)
| 구분 | Garage(1차) | AWS(폴백) |
|------|-------------|-----------|
| 발급 | `POST {is}/api/garage/presigned-url` | `POST {is}/api/aws/presigned-url` |
| body | `{"filename":"<원본명>"}` | 동일 |
| 응답 | `{filename:"<UUID>.pdf", presignedURL:"..."}` | 동일 shape |
| 업로드 host | **`s3.redprinting.net`** (자체호스팅 Garage 오브젝트스토어) | `s3.ap-northeast-2.amazonaws.com` |
| region(서명) | `garage` | `ap-northeast-2` |
| credential prefix | `GK…` ([REDACTED]) | `AKIA…` ([REDACTED]) |
| bucket | `redprintingweb.tempo` | 동일 |
| 만료 | X-Amz-Expires=3600(60분) | 동일 |
| payload sha | UNSIGNED-PAYLOAD | 동일 |

- **PUT 검증**: Garage presignedURL로 `PUT` (Content-Type application/pdf, UNSIGNED-PAYLOAD) → **status 200**. end-to-end 동작 확정.
- 발급·PUT 모두 redacted 샘플 보존: `captures/garage-presigned-sample.json` (Credential/Signature [REDACTED]).

### 1.2 폴백 로직 (R0 L18302–18317 + 라이브 정합)
```
try Garage presigned → PUT     // s3_region="GA"
catch → AWS presigned → PUT    // s3_region="AWS"
emit upload [{gbn:"I", new_file_nm, new_file_size, org_file_nm, s3_file_size:null, s3_region}]
```
- `s3_region`="GA"(Garage 성공) / "AWS"(폴백) — 주문 페이로드에 업로드 출처 기록.
- 삭제: emit `[{gbn:"D"}]`.

### 1.3 활성 조건 [라이브 검증]
- product_option.option.`isUseGarage`="Y" (프로브 8상품 전부) + uploadType[_key]="pdf" → GarageUploader 렌더.
- S3Uploader(4월)는 폴백 전용으로 잔존(병존, 제거 아님).

---

## 2. 신규 가격필드 14종 — 라이브 의미·영향 [라이브 검증/정적]

### 2.1 ORD_INFO 신규 필드 (라이브 엔진 수용 확인, retCode 200)
| 필드 | 의미 | 라이브 근거 |
|------|------|------------|
| `ADD_CLR_YN` | 추가색상 Y/N (dosu별) | 엔진 수용. 영향=자재/도수 조건부(NCCDDFT RXSNO250선 무변화·deeper dosu서 발생) |
| `REAM_CNT` | 연(ream) 수 — `REAM_CNT/PRN_CNT` 비율(R0 L22611) | pdt_prn_cnt_info 행에 존재(NCCDDFT DFT=0). 엔진 수용 |
| `PACK_PRN_CNT` | 개별포장 수량(addOptionInfo 조건부, R0 L13984) | 무광코팅→개별포장 자동연동(R0 L12718) |
| `UNIT_PRN_CNT` | 단위 인쇄수량 | 수량래더(PDT_VER_SIZE 상품) |
| `MIN_ORD_PRN_CNT`/`ADD_ORD_PRN_CNT` | 최소주문·증분 (PRN_CNT=MIN+ADD·h) | **PDT_VER_SIZE형 상품 전용**(굿즈류). offset/book은 pdt_prn_cnt_info+base FIR_CNT/INC 사용 |
| `MAX_PRN_CNT` | 수량 상한(pdt_base_info[0]) | R0 L19733 |
| `PDT_SIZE_INFO` | BT*/GSSTPRT 사이즈정보 문자열 | size_info 행 필드 |
| `FLD_DFT_H/_V` | 접지 가로/세로 가이드 imgPath | R0 L24735/24739 |

### 2.2 수량 모델 2종 확정 [라이브 검증]
- **모델 A (PDT_VER_SIZE 래더)**: `PRN_CNT = MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h` (h=0..9), DFT_YN 첫행Y. (굿즈/사이즈선택형)
- **모델 B (pdt_prn_cnt_info 행)**: 서버가 PRN_CNT/DFT_PRN_CNT/REAM_CNT/UNIT_PRN_CNT/INC_CNT 행 제공 + base FIR_CNT/INC/INC_STEP/REAM_YN. (offset2023_item 명함/카드/책자)

### 2.3 메타모픽 가격영향 (NCCDDFT 라이브)
- qty 500→1000: 6,350,000→23,900,000 (**단조증가 ✓**).
- +FLD_DFT(2단접지 FO006): 6,350,000→14,850,000 (**후가공 추가 시 증가 ✓**, 접지 실가격 기여 입증).
- PRICE=0 미발생(전 변형 ≠0) — 오라클 sanity ✓.

---

## 3. 신규 후가공 옵션군 — 라이브 스키마 [라이브 검증]
NCCDDFT pdt_pcs_info: CUT_DFT/COT_DFT/**FLD_DFT**/**HOL_DFT**/MIS_DFT/OSI_DFT/**ROU_DFT**.
- FLD_DFT(접지): PCS_GRP_NM="접지", detail FO006=2단접지 등, NOTICE→접지가이드(get_fld_download).
- HOL_DFT(타공): 사이즈<40 자동 비활성(R0 L17378).
- ROU_DFT(귀돌이): 모서리 라운드, 최소선택 안내(R0 L12563).
- 캐스케이드: pdt_disable_pcs_info 25건(자재→후가공 detail 비활성).

---

## 4. 신규 옵션군 라벨 사전 (TRANSLATIONS 이중언어 KO+EN) [정적 분석]
R0 deob L12555–12762서 추출(신규):
- 접지: 가로방향접지=Horizontal Fold, 세로방향접지=Vertical Fold, 접지가이드다운로드=Folding Guide Download, 접지가이드불가/안내1/안내2.
- 타공/걸이: 타공형=Punching, 걸이형=Hanging.
- 글꼴: num-dft.글꼴=Font, num-dft.글꼴선택=Select Font.
- 귀돌이: 귀돌이최소선택안내, 사각라운드형.
- 자석: 자석거치대부착가능/불가.
- 포장: 무광코팅-개별포장-안내(무광코팅→개별포장 자동).

---

## 5. 갱신 대상 역공학 계약 파일 (R2 산출 → 다음 단계 적용)

본 R2가 도출한 갱신 내용. 기존 `01_reverse/*` 파일에 반영할 패치(원본 비파괴, 갱신본은 redo-260623/ 하위에 명시):

| 기존 파일 | 갱신 내용 | 근거 |
|-----------|----------|------|
| `s3-upload-flow.md` | **Garage 경로 추가**(s3.redprinting.net·region=garage·GK크레덴셜·폴백·s3_region GA/AWS·isUseGarage). S3와 병기 | §1 라이브 |
| `price-engine-reversed.md` | **신규 14필드** + 수량모델 2종 + 메타모픽 영향 | §2 라이브 |
| `option-schema-catalog.json` | 신규 후가공군(FLD_DFT/HOL_DFT/ROU_DFT 등 20)·item_gbn 7종·캐스케이드 disable | §3 라이브 |
| `editor-bridge-protocol.md` | SDK `sizing.type` 신규 파라미터(MINOR, 정적) | 1단계 diff |
| `gaps-resolved.md` | 6월 기준 재판정(R3서 종합) | R3 |

> 적용(기존 파일 직접 수정)은 R3 검증 통과 후 또는 hw-architect 인계 시. 본 단계는 갱신본을 redo-260623에 보존.

## 6. R2 미확정
- ADD_CLR_YN 가격 기여 정확값(자재/도수 deep 조합 미full-sweep).
- PACK_PRN_CNT 가격 영향(개별포장 자동연동 상품 미캡처).
- Garage vs AWS 선택의 서버 결정 로직(클라 폴백만 확인, 서버측 isUseGarage 결정 근거 미확인).
