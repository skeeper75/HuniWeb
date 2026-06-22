# R0 — 정적 디옵 (AST 등가보존) 산출

> 재역공학 강화 2단계 R0. 최신 widget.js(6/22)를 Babel AST 등가보존 디옵(string-edit 0).
> 모든 위치는 `redo-260623/deob/widget.deob.js`(27,728 lines) 기준 file:line.
> 4월 deob와 신규/변경만 타겟. 라이브 미접속(정적). RedEditorSDK는 1단계 diff에서 MINOR 확정.

---

## 0. 디옵 방법 [정적 분석]
- 입력: `_latest/widget.js.20260622` (587,493 B on disk / 568,302 chars UTF-8).
- 도구: `@babel/parser` parse(sourceType:script, errorRecovery) → `@babel/generator` generate(compact:false). **AST 등가보존** — 토큰 재배치 없이 포맷만(rename 미적용, 환각 0).
- 출력: `deob/widget.deob.js` (933,573 B / 27,728 lines).
- 번들러: Vite/Rollup IIFE, Vue 3.5.21. webpack 마커 0.

---

## 1. Garage 업로더 서브시스템 [정적 분석] — 최우선 신규

### 1.1 컴포넌트 — `GarageUploader` (deob L18233–18368)
- props: `_key`(default), `allowedExt`(default `{types:["application/pdf"]}`).
- emits: `["upload"]`.
- 파일검증 `r/i`: PDF MIME 또는 `.pdf` 확장자, size < `Eb`(상한 상수).

### 1.2 업로드 플로우 — 핵심 발견: Garage→AWS 폴백 (L18302–18317)
```
try   { D = await m("/api/garage/presigned-url");  // 1차 Garage 시도
} catch{ D = await m("/api/aws/presigned-url"); N = true; }  // 실패 시 AWS 폴백
await l("I", { name:{new:D, original:h}, size:v.size }, N);  // N=isAwsFallback
```
- presigned 발급 `m(D)` (L18278–18301): `POST {is}{D}` body `{filename:h}` → 응답 `{filename:w, presignedURL:A}` → `PUT A` (Content-Type `v.type||"application/pdf"`, body=파일) → status≠200이면 throw → return `w`(새 파일명).
- `is` = API base(런타임 결정·R1에서 실측).

### 1.3 upload emit 페이로드 (L18264–18274) — 신규 계약
```
gbn: "I",
new_file_nm: <발급된 파일명>,
new_file_size: <size>,
org_file_nm: <원본명>,
s3_file_size: null,
s3_region: isAwsFallback ? "AWS" : "GA"   // ★ s3_region 판별자(GA=Garage)
```
삭제 emit: `gbn:"D"` (L18339, confirm "업로드파일삭제메시지").

### 1.4 useGarage 토글 결정 (L18866, L19122–19126, L22421)
- 템플릿: `uploadType[_key]==="pdf" && uploadConfig.useGarage` 일 때 GarageUploader 렌더(L18866), 아니면 기존 S3Uploader.
- `useGarage: l==="Y"` (L19126), `isUseGarage: l`(L19122) — 서버 config `useGarage` Y/N 플래그.
- **S3Uploader(4월)는 잔존** — Garage는 병존(superset). BLOCKER 아님.

---

## 2. 신규 API 엔드포인트 [정적 분석]
| 엔드포인트 | deob 위치 | 빌드 형태 | 용도 |
|-----------|----------|----------|------|
| `/api/garage/presigned-url` | L18307 | `${is}/api/garage/presigned-url` | Garage presigned 발급 |
| `/api/aws/presigned-url` | L18309 | (폴백) | 기존 S3(병존) |
| `get_basicKalSize` | L12444 | `${jn}/${t}/product/get_basicKalSize` | 칼선/기초 사이즈 조회 |
| `get_fld_download` | L12466 | `${jn}/${t}/product/get_fld_download` | 접지 가이드 PDF 다운로드 (L12477 "접지 가이드 다운로드 실패") |

(1단계서 `get_basic`로 식별한 것은 실제 `get_basicKalSize` 접두 일치였음 — 정정.)

---

## 3. 신규 후가공(postPcs) 컴포넌트 — +20개 (29→49), 제거 0 [정적 분석]

postPcs lazy-import 맵: deob L17078–17127. 4월 widget.js 대비 신규 20종(전부 additive·rename/제거 없음 → 계약 superset, BLOCKER 부재 입증):

`BAK_STK BND_LOC BTN_DFT CDL_DFT CPN_DFT CUT_DFT FLD_DFT HOL_DFT LAM_DFT MIS_DFT NUM_DFT OSI_DFT PRT_MAG PRT_SID RFL_HAP SUB_MTR_LW THO_BAK THO_CUT THO_DFT THO_GRA`

신규 도메인 매핑(라벨 L12555–12762, KO+EN 이중언어 확정):
| PCS 코드 | 컴포넌트 | 한글 라벨 | 의미 |
|---------|---------|----------|------|
| FLD_DFT | FLD_DFT.vue (L17088) | 가로방향접지/세로방향접지 | 접지(fold) — N접지 가이드 다운로드 연동 |
| HOL_DFT | HOL_DFT.vue (L17089) | 타공형 | 타공/펀칭 (L22806) |
| RIN_DFT | RIN_DFT (L26395) | 걸이형 | 걸이/ring (L22807) |
| NUM_DFT | NUM_DFT.vue (L17095) | 글꼴/글꼴선택 | 넘버링+폰트 선택 (L12673 num-dft.글꼴) |
| ROU_DFT | (기존) | 귀돌이/사각라운드형 | 모서리 라운드 (L12563 귀돌이최소선택안내) |
| PRT_MAG | PRT_MAG.vue | 자석거치대 | 자석 부착(L12761 부착가능/불가) |
| PAK_POL/PAK_ETC | (기존+신규) | 개별포장 | 무광코팅→개별포장 자동연동(L12718) |
| LAM_DFT | LAM_DFT.vue (L17093) | 라미네이팅 | 캐스케이드 허브(아래) |

### 3.1 후가공 캐스케이드 제약 (L14424–14434) [정적 분석]
```
FLD_DFT → [THO_GRA, LAM_DFT]        // 접지 선택 시 영향
THO_GRA → [FLD_DFT]
LAM_DFT → [MIS_DFT, OSI_DFT, COT_DFT, FOI_DFT, FLD_DFT, ROU_DFT, PRT_MAG]  // 라미네이팅=캐스케이드 허브
Kh(Set) = {FLD_DFT, HOL_DFT, MIS_DFT, OSI_DFT, THO_GRA, PRT_MAG}  // 특수처리군
```
- HOL_DFT 자동제어(L17378): 사이즈 폭/높이 `<40`이면 `HOL_DFT="N"` 강제(타공 불가).
- `delete p.HOL_DFT, delete p.RIN_CUT`(L16821): 조건부 옵션 제거 로직.

---

## 4. 신규 상품군(item_gbn) — +3 [정적 분석]
4월(book2025_item/vDigital_item/vSubMtrl_item) → 6월 신규 3종 추가:
| item_gbn | 컴포넌트 | 용도 |
|----------|---------|------|
| `acrylic2025_item` | AcrylicPrintData (L19882) | 아크릴 2025 |
| `clothes2025_item` | ApparelPrintType/Area/Color (L20632/20910/21476) | 의류 — printType.COD → PRINT_TYPE 필드(L13987) |
| `offset2023_item` | (오프셋 경로) | 오프셋 인쇄 |
| CalendarHangType (L22795) | — | 캘린더 걸이타입 |

---

## 5. 신규 가격 필드 14종 — ORD_INFO 빌더 위치 [정적 분석]

가격 요청 빌더: deob L13955–13999 (`{ORD_INFO, PCS_INFO, price_gbn, mb_cust_cod}`).
| 필드 | 위치 | 의미(소스 근거) |
|------|------|----------------|
| `ADD_CLR_YN` | L13982 | `T.dosuInfo?.ADD_CLR_YN` — 추가색상 Y/N |
| `PACK_PRN_CNT` | L13984 | `T.addOptionInfo.PACK_PRN_CNT`(조건부) — 개별포장 수량 |
| `MIN_ORD_PRN_CNT` | L15432 | 최소주문수량(수량래더 시작) |
| `ADD_ORD_PRN_CNT` | L15433 | 수량증분(`PRN_CNT=MIN+ADD*h`, h=0..9) |
| `UNIT_PRN_CNT` | L15442 | 단위인쇄수량 |
| `REAM_CNT` | L22611 | `REAM_CNT/PRN_CNT` 비율 계산(연/ream) |
| `MAX_PRN_CNT` | L19733 | `pdt_base_info[0].MAX_PRN_CNT` — 상한 |
| `PDT_SIZE_INFO` | L16212 | BT*/GSSTPRT 상품 사이즈정보 |
| `FLD_DFT_H/_V` | L24735/24739 | 접지 가로/세로 imgPath(+FLD_DFT_3W/3H L19002+) |
| `NCDFFLD` | L23993 | 명함 접지 제외상품군 |
| `RIN_CUT` | L16821 | 걸이 재단(조건부 삭제) |
| `HOL_DFT` | L17378 | 타공(사이즈 제약) |

### 5.1 수량 래더 생성기 (L15429–15445) [정적 분석]
```
PRN_CNT  = MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT * h   (h=0..9, 10단계)
MIN_PRN_CNT = minPrnCntOverride ?? MIN_ORD_PRN_CNT
INC_CNT  = ADD_ORD_PRN_CNT
UNIT_PRN_CNT = minPrnCntOverride ?? ADD_ORD_PRN_CNT
DFT_YN   = (h===0) ? "Y" : "N"   // 첫 단계가 기본
```
→ 신규 가격필드는 **수량 차원 확장**(접지/포장/연수)이 핵심. PCS_INFO 후가공 차원도 +20.

### 5.2 특수 상품 분기 (ORD_INFO, L13978–13991)
- `GSELGLV`: `PRN_CNT = prnCnt * 10`.
- `clothes2025_item`: `PRINT_TYPE = clothesSelectData.printType.COD`.
- `GSTRTAG`: `TMPL_IDX`(large=14/small=11).

---

## 6. RedEditorSDK sizing.type — widget 측 미참조 [정적 분석]
- 1단계 diff 확정: SDK 6.6.48에서 createProject/openProject에 `documentSizeInfo.type → extra.sizing.type` 추가(MINOR).
- widget.deob.js에서 `sizing`/`documentSizeInfo` grep 0건 → **widget은 이 옵션 미사용**(SDK 직접호출자/후니 자체 코드가 쓰는 파라미터). widget 재역공학엔 비차단.

---

## 7. R0 결론 + 미확정(R1/R2로 이월)
- 신규 표면 전부 file:line 고정 완료(Garage·14필드·20 postPcs·3 item_gbn·캐스케이드).
- **계약 superset 확정**(제거/rename 0) → 1단계 "BLOCKER 없음" 정적 입증.
- 미확정(런타임/라이브 필요):
  - `is`/`jn` API base 런타임 실값 (R1).
  - Garage presigned 실응답 shape·PUT 헤더 (R2 라이브).
  - 신규 14필드 실제 가격 영향(메타모픽) (R2).
  - 신규 옵션군 실제 product_info 스키마/캐스케이드 enable-disable (R1).
