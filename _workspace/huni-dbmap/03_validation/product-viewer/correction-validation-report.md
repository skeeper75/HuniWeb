# SIZE_NAME_NOISE 정정 검증 보고서 (Phase 5)

대상: mapping-designer 산출 `02_mapping/correction/` (size-name-noise-spec.md + load CSV 2종).
방식: 4계면 교차검증 + 적재 가능성 사전 검증. **DB read-only 조회만 수행**(SELECT/information_schema). INSERT/UPDATE/DDL 없음.

> **핵심 반전(권위 재판정)**: 라이브 DB를 read-only 조회한 결과, `t_siz_sizes`의 work/cut 치수는 **이미 채워져 있다**(77/77 NOT NULL). 정정 명세·ref-sizes.csv가 전제한 "77 siz_cd 치수 전부 NULL"은 **라이브 DB 기준 거짓**이다. 권위순서(라이브 DB > 스키마 시트)에 따라 라이브 DB가 승. 치수 UPDATE 정정은 75행이 **이미 라이브와 동일**(중복·무의미)하고, 2행(cm)은 라이브가 옳고 CSV가 틀렸다(회귀 위험).

---

## §1. 경계면 교차검증 결과

검증 계면: 원본 어색명(HTML `const P.data[].siz`) ↔ 정정 spec 분리값 ↔ 정정 CSV ↔ DB 스키마/실데이터.

### 계면 A: 원본 HTML ↔ 정정 spec (건수·siz_nm·차원)
- HTML `const P.data` 전수 추출 결과 `SIZE_NAME_NOISE` 플래그 **81 findings / 고유 siz_cd 77개** — spec 수치와 **정확히 일치**. (근거: `/tmp/noise_src.json` 추출)
- siz_nm 문자열: CSV 77행 전부 HTML 원본 `nm`과 **문자 단위 일치**(nm mismatch 0건).
- 판정: **일치(PASS)**.

### 계면 B: 정정 spec ↔ 정정 CSV (분리값 정합)
- `t_siz_sizes_dims.csv` 77행의 work/cut 값이 spec §4 전수표의 W×H와 일치(work=cut 동일값 채움 규칙 준수).
- 3D depth(PP케이스 3건): depth 슬롯 없음 → W×H만 적재, `_note`에 depth 기록. spec과 일치.
- 판정: **일치(PASS)**.

### 계면 C: 정정 CSV ↔ 원본 HTML 파싱값 (field-for-field)
- HTML `data[].siz`는 이미 ww/wh/cw/ch 파싱값을 보유. CSV와 전수 대조: **75행 일치, 2행 불일치**.
  - 불일치 = SIZ_000399 `100x70cm(1인용)`: HTML=1000/700, CSV=100/70.
  - 불일치 = SIZ_000402 `100x150cm(2인용)`: HTML=1000/1500, CSV=100/150.
  - 즉 **원천 HTML은 cm→mm 환산(×10)을 이미 적용**했고, CSV는 "임의 환산 금지"로 원본 cm를 보존 → 두 산출이 cm 처리에서 상반.
- 판정: **부분 불일치(2건)** — cm 처리 방침 충돌.

### 계면 D: 정정 CSV ↔ DB 스키마/실데이터 (라이브 read-only)
- `t_siz_sizes` 컬럼 타입(information_schema): work_width/work_height/cut_width/cut_height = **numeric(8,2), nullable=YES**. (검증 포인트 #1 해소)
- 라이브 실데이터: 77 target siz_cd **전부 존재**, work/cut **전부 NOT NULL**(채워짐). 라이브값 vs CSV: **75행 동일, 2행 상이**(cm 2건, 라이브=1000/700·CSV=100/70).
  - 라이브 DB는 HTML과 동일하게 cm→mm 환산값(1000/700)을 이미 보유 → **라이브가 CSV보다 정확**.
- `t_prd_product_bundle_qtys`: 컬럼 = bdl_qty integer NN / bdl_unit_typ_cd vc50 nullable / dflt_yn char1 NN / disp_seq int nullable. 라이브 전체 4행, **9개 target prd_cd 행은 0**(미적재).
- 판정: **치수=라이브 선존(75 중복·2 회귀위험)**, **묶음수=라이브 비어있음(INSERT 적합)**.

---

## §2. 6 검증 포인트 판정

### 포인트 1 — t_siz_sizes 컬럼 타입 → **PASS**
라이브 조회: work/cut 4컬럼 = `numeric(8,2)`, nullable. 정수 mm 값(70, 350 등)은 numeric(8,2)에 무손실 저장(70→70.00). 최대 허용 999999.99 ≫ 최대 적재값(1500). 정수 적재 타입·길이 위반 없음.
근거: information_schema.columns(t_siz_sizes) 실조회.

### 포인트 2 — 묶음수 66 findings → 18행 dedup → **PASS (정보손실 없음)**
원본 HTML에서 prd_cd별 distinct bdl_qty를 추출한 결과 18개 조합으로 수렴, CSV 18행과 **정확히 일치**.
- PRD_000001(11 size 전부 50장)→[50] 1행, PRD_000002→[20,50], PRD_000003→[20,30,40,100], PRD_000066→[1,2,3,6,8], PRD_000198→[1,2] 등 전건 일치.
- (prd_cd, bdl_qty) PK 중복 0. dflt_yn 전건 'N', unit 코드 전건 유효.
근거: `/tmp/noise_src.json` distinct 집계 vs CSV 대조. **단, 사이즈→수량 연결 손실은 포인트 3 참조**(이건 dedup이 아니라 모델 한계).

### 포인트 3 — 도무송 사이즈-EA 종속(PRD_000066) → **CONDITIONAL (후니 모델링 결정 필요)**
정사각10x10=8EA, 25x25=3EA처럼 사이즈마다 EA 다름. `(prd_cd, bdl_qty)` PK 분리 시 "어느 사이즈가 몇 EA"인지 연결 끊김 — bundle_qtys 단독 표현 불가는 **사실**. 현 CSV는 distinct {1,2,3,6,8} 5행만 분리(연결 보류)했고 spec/huni-source-fix-request §D가 명시적으로 후니 결정 보류로 처리 → 분리 자체는 정합. 다만 사이즈-EA 종속은 옵션 캐스케이드 또는 `t_prd_products.constraint_json` 영역. **후니 확인 항목으로 정당하게 이연됨.**

### 포인트 4 — cm/단위미표기 보류 처리 → **FAIL (cm 2건) / PASS (단위미표기)**
- 단위미표기(13건 중 도장·라벨 등): mm 가정 + `_note` 확인필요 표기 — 라이브 DB도 동일 값 보유(13×13→13.00 등), 일치. 보류 처리 적절. PASS.
- **cm 2건(SIZ_000399/402)**: CSV는 원본 cm(100/70) 보존했으나 **라이브 DB와 원천 HTML은 둘 다 mm 환산값(1000/700)을 이미 보유**. CSV값(100/70)을 적재하면 라이브의 정확한 값을 **틀린 값으로 회귀**시킨다. "임의 환산 금지" 의도는 이해되나, 권위(라이브 DB·원천)가 이미 1000/700으로 확정 → CSV가 틀림. **FAIL — designer 정정 필요.**

### 포인트 5 — 3D depth 슬롯 부재 → **PASS (분리 정합) / 후니 확인 이연**
PP케이스 두께(20/15mm)가 work/cut 2축에 안 들어감은 사실. 라이브 DB도 W×H만 보유(42/57, depth 없음) — CSV·HTML·라이브 3자 일치. depth 누락은 스키마 한계이며 `_note` 기록 + 후니 확인 이연으로 정합. PASS.

### 포인트 6 — 모양 귀속 보류 → **PASS**
치수만 분리하고 모양(원형/사각/하트)은 적재 보류(_note). 라이브 DB도 치수만 보유(모양 컬럼 없음). 모양의 옵션 vs siz규격 귀속은 후니 결정 이연 — 치수 적재와 독립적이므로 정합. PASS.

---

## §3. 적재 가능성 사전 체크리스트

### t_siz_sizes_dims.csv (UPDATE 성격)
| 항목 | 결과 | 근거 |
|------|------|------|
| 타입/길이(numeric(8,2)) | PASS | 라이브 타입 확인, 최대 1500 ≪ 999999.99 |
| NOT NULL | N/A(nullable) | work/cut 전부 nullable |
| 대상 siz_cd 실존 | PASS | 77/77 라이브 존재 |
| UPDATE 전제(work/cut NULL) | **FAIL** | 라이브 77/77 **이미 NOT NULL**(전제 거짓) |
| 라이브값 vs CSV 일치 | 75 PASS / 2 FAIL | cm 2건 CSV가 틀림(회귀) |

→ 75행 = 라이브와 동일(적재해도 무변경·무의미). 2행 = 적재 시 라이브 정확값을 회귀(해로움).

### t_prd_product_bundle_qtys.csv (INSERT 성격)
| 항목 | 결과 | 근거 |
|------|------|------|
| 타입(bdl_qty int) | PASS | 정수값 18행 |
| NOT NULL(prd_cd, bdl_qty, dflt_yn) | PASS | 전건 채워짐, dflt_yn='N' |
| PK 유일성(prd_cd,bdl_qty) CSV 내 | PASS | 중복 0 |
| PK 충돌(라이브 기존행) | PASS | 9 target prd_cd 라이브 0행 |
| FK prd_cd→t_prd_products | PASS | 9 prd_cd 전부 실존 |
| FK bdl_unit_typ_cd→QTY_UNIT | PASS | .01/.02/.04 전부 실존 |
| dedup 무손실 | PASS | 포인트 2 |

→ **묶음수 CSV는 적재 가능(전 항목 PASS).**

---

## §4. 종합 판정 — **CONDITIONAL-GO**

근거 요약:
- **t_prd_product_bundle_qtys.csv (18행)**: 전 검증 통과. **GO**(후니 적재 권한만 필요).
- **t_siz_sizes_dims.csv (77행)**: 라이브 DB가 이미 치수를 보유. 75행은 적재 불필요(무변경), 2행(cm)은 적재 시 라이브 정확값을 회귀시킴 → **현 CSV로는 NO-GO**.

### designer에게 돌려보낼 수정사항
1. **[BLOCKER] cm 2건 회귀 수정** — SIZ_000399/402의 CSV work/cut를 라이브·원천과 정합하게 **1000/700, 1000/1500(mm 환산)**으로 정정하거나, 이 2행을 CSV에서 제외(라이브가 이미 정확). 현 100/70·100/150은 라이브 1000/700·1000/1500을 회귀시키는 오류.
2. **[MAJOR] 전제 정정** — spec §0/§20 "77 siz_cd work/cut 전부 NULL" 및 huni-source-fix-request §A "UPDATE(NULL→값)"은 **라이브 DB 기준 거짓**. 라이브는 이미 75행 동일·2행(cm) mm환산 보유. ref-sizes.csv(2026-06-04 17:13 추출)가 stale였음. t_siz_sizes_dims 정정의 성격을 "UPDATE NULL 채움"이 아니라 "**라이브 정합 확인 결과 75행 이미 반영·2행 회귀제거**"로 재기술 필요.
3. **[MINOR] 도무송 사이즈-EA(포인트 3)** — 묶음수 분리는 유지하되, 사이즈→EA 종속은 후니 모델링 이연임을 유지(현 처리 적절).

> 묶음수 라인은 단독으로 **GO**다. 치수 라인의 cm 2건만 차단 사유다 — 이 2건을 정정/제외하면 전체 GO.

---

## §5. 후니 확인 필요 항목

1. **cm 단위 확정(2건)**: 라이브·원천 HTML은 피크닉매트를 mm 환산(1000/700)으로 이미 등록. work/cut 단위가 mm임이 라이브로 확인됨(numeric(8,2)) → cm 보존 불가, mm 환산 확정. (designer CSV가 이 결정과 어긋남.)
2. **단위미표기 mm 타당성(13건)**: 만년스탬프 원형13×13, 레더라벨 15×30 등 mm 가정 — 라이브도 동일 값 보유하나 실제 mm 여부(도장 13mm 원형 타당성)는 후니 원천 확인 권장.
3. **3D depth 슬롯(3건)**: PP케이스 depth(20/15mm) 보존 방법(siz_nm 보존/옵션/별 컬럼) 후니 결정. 현재 work/cut 2축엔 미반영.
4. **'인용=세트(QTY_UNIT.04)' 해석(2건)**: 피크닉매트 1인용/2인용을 세트로 분리 — 의미 확인.
5. **모양 귀속(원형/사각/하트)**: 옵션값 vs siz 규격 귀속 결정.
6. **색상/자재 접두 mat_cd(5건)**: 화이트/블랙/레더 접두는 MAT_* 라운드에서 자재 variant 등록(본 정정 범위 밖).
7. **도무송 사이즈-EA 종속(PRD_000066)**: bundle_qtys 단독 표현 불가 → 옵션 캐스케이드/constraint_json 모델링 결정.

---

## 자기 검토 (철회·정정 기록)
- 초기 ref-sizes.csv만 보고 "치수 NULL" 전제를 수용할 뻔했으나, 라이브 read-only 조회(권위 우선)로 **이미 채워짐**을 확인 → 전제를 라이브 기준으로 정정. 검증 포인트 #1(타입)은 단순 PASS를 넘어 "치수 선존" 더 큰 발견으로 확장.
- cm 2건은 처음 "보류 적절(PASS)"로 볼 뻔했으나, 원천 HTML·라이브가 둘 다 mm 환산을 채택했음을 확인 → "CSV가 회귀(FAIL)"로 판정 전환. 출처(HTML data[].siz, 라이브 t_siz_sizes) 병기.

> read-only 조회 4회 수행(information_schema 1, t_siz_sizes 실데이터 3, bundle_qtys/QTY_UNIT 1). 비밀번호 비출력. 쓰기 0건.
