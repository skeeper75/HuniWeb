# WIRE 통합 배선 — Phase A 인벤토리·분류 (round-21 시스템 결함 일괄 배선)

> 작성 2026-06-15 · `dbm-load-builder` · 권위 입력 = round-21 6사이클 GO 제안본 4종(NAMECARD-WIRE·D-1b·SILSA-WIRE·PHOTOCARD-BULK-WIRE) + `_3cycle-synthesis.md` §3-1(시스템 결론).
> 라이브 `t_prc_*`/`t_prd_*` 2026-06-15 읽기전용 SELECT = **stale 방지 실측 오라클**(권위는 제안본·GO). 실 COMMIT 0.
> **돈-크리티컬**: 배선은 `t_prc_formula_components` INSERT + 신규 공식(`t_prc_price_formulas`) + 바인딩(`t_prd_product_price_formulas` frm_cd UPDATE) + MATGROUP 단가행 verbatim 복제. **`t_prc_component_prices.unit_price` 절대 불변**(복제는 기존 값 그대로·신값 0). 보정 하드코딩 0.

---

## 0. 시스템 결함 한 줄 (왜 통합 배선인가)

6사이클·6 상품군에서 **단가행 값 결함 0**(가격표 엑셀 verbatim 정합)인데 게이트 차단 사유가 전부 **"가격 공식사슬 배선(WIRE) 누락"** 으로 수렴 = 결함은 per-product가 아니라 **시스템(구조)**. 진원 = round-2 가격엔진 파일럿이 단가행만 적재하고 공식↔구성요소 배선을 상품별로 안 함. → 개별 상품군 순회보다 **공식사슬 배선 일괄 트랙**이 ROI 높음(synthesis §3-1).

---

## 1. WIRE 결함 분류 (3 유형 × 4 제안본)

| WIRE | 결함 유형 | 라이브 실측(2026-06-15) | 본 트랙 처리 | 인스코프 |
|------|-----------|------------------------|--------------|:--:|
| **NAMECARD-WIRE** | ② 공식분리 신설 | FIXED만 존재·PREMIUM/COAT 부재·14 comp 실재·031/032/033 FIXED 바인딩 | 공식 2 신설 + 배선 + 바인딩 교체 + 031 박 배선 | **① 인스코프** |
| **NAMECARD-MATGROUP** | 단가행 복제(verbatim) | STD 단가행 074/082만·081/091/092 부재 | 074→081/091·082→092 복제(값 불변) | **① 인스코프** |
| **PHOTOCARD-BULK-WIRE** | ① 순수 배선 | SET/CLEAR_SET 배선됨·BULK 50구간 실재 미배선 | BULK 1행 배선(모드분기는 엔진) | **① 인스코프** |
| **SILSA-WIRE(대표)** | ② 공식분리 신설 | FIXED 단일 공식·ARTPRINT_PHOTO 1 comp만 배선·30 소재 comp 실재·28상품 FIXED 바인딩 | 대표 BANNER_NORMAL 공식분리 + 배선 + 138 바인딩 교체 | **② 인스코프(대표 1건)** |
| SILSA-WIRE(전파 26소재) | ② 공식분리 신설(대량) | 26 소재 comp 단가행 실재·전건 FIXED 단일 바인딩 | round-16 import.xlsx 그릇(Q-PS-2 합산귀속 컨펌) | **범위밖(별트랙)** |
| SILSA-GRID-BLOCKED | 좌표 siz 미채번(667) | 격자 87% 미적재 | round-16 4b_GAP_BLOCKED·siz 채번 | **범위밖** |
| SILSA-CPQ-PARTIAL | CPQ 17상품 미적재 | 사이즈 그룹만 | round-6 option-mapper | **범위밖** |
| D-1b prc_typ 메타 | (배선 아님·메타) | `23_remediation-apply/d1b-prctyp/` 이미 빌드 | **중복 빌드 금지·기존 참조**·순서 의존만 점검 | **참조만** |
| 스티커 STK-AXIS | ③ CPQ축↔단가축 불일치 | CPQ 소재축≠단가행 소재축 | 본 배선 트랙 아님 | **범위밖(플래그)** |
| 아크릴 이중전무 | ③ CPQ 0/0/0 + 공식 부재 | CPQ·공식 둘 다 신설 | round-6 + round-2/16 신설 | **범위밖(플래그)** |

---

## 2. 분류 집계

| 분류 | 건수 | 항목 |
|------|:--:|------|
| **① 순수 배선** (공식·comp·단가행 다 있고 formula_components만 누락) | **1** | PHOTOCARD-BULK-WIRE |
| **② 공식분리 신설** (공식이 variant를 못 나눔·신규 PRF_* 필요) | **2** | NAMECARD-WIRE(PREMIUM/COAT), SILSA-WIRE(대표 BANNER_NORMAL) |
| 부수: 단가행 verbatim 복제(MATGROUP) | (1) | NAMECARD-MATGROUP — ②에 동반 |
| 부수: 박 배선(031 FOIL → PREMIUM add-on) | (1) | NAMECARD-WIRE에 동반 |
| **③ 범위밖** (CPQ축·이중전무·전파 대량·격자 채번) | **4** | 스티커 STK-AXIS, 아크릴 이중전무, SILSA 전파 26소재, SILSA-GRID/CPQ |
| D-1b(메타·중복 금지) | 참조 | 기존 `d1b-prctyp/` |

**인스코프 = 순수배선 1 + 공식분리 2 (+ MATGROUP 복제 1 + 031 박 배선 1).** 범위밖 4 분리.

---

## 3. SILSA 인스코프 경계 (왜 대표 1건만)

silsa-rep-5layer §5 폐루프 RESOLVED 기준 = "27상품 미도달 해소". 그러나:
- **30 소재 전건 공식분리**(30 공식 + 28 바인딩 교체)는 round-16 `poster-sign-import.xlsx` 그릇 빌드 의존(옵션 add-on 합산 귀속 Q-PS-2·격자 BLOCKED·좌표방향 Q-SL-PS-4 미해소 컨펌 다수).
- 본 통합 배선본은 **대표 일반현수막(138) BANNER_NORMAL 1소재** 를 명함 NAMECARD-WIRE 동형 패턴으로 종단 실행본화 → 패턴 입증.
- **나머지 26 소재 = 동형 자동전파 큐**(같은 `PRF_POSTER_<MAT>` 패턴·단가행 골든 실재) — round-16 별트랙.
- ⚠ **SILSA 완전 RESOLVED 아님**: 대표 138만 도달. 27상품 도달은 전파 COMMIT 후. 본 트랙은 대표 종단 + 전파 플래그.

---

## 4. 멱등 충돌키 (라이브 PK 실측 확정)

| 테이블 | PK/UNIQUE (라이브 실측) | 멱등 전략 |
|--------|------------------------|-----------|
| `t_prc_price_formulas` | PK `frm_cd` | `ON CONFLICT (frm_cd) DO NOTHING` |
| `t_prc_formula_components` | PK `(frm_cd, comp_cd)` | `ON CONFLICT (frm_cd, comp_cd) DO NOTHING` (disp_seq PK 아님·안전) |
| `t_prd_product_price_formulas` | PK `(prd_cd, apply_bgn_ymd)` | 바인딩 교체 = `UPDATE frm_cd WHERE prd_cd AND frm_cd=구공식` (frm_cd PK 아님·FK ON UPDATE CASCADE) — 멱등 가드 `frm_cd=구값` |
| `t_prc_component_prices` | PK `comp_price_id`(IDENTITY BY DEFAULT)·자연키 UNIQUE **없음** | MATGROUP 복제 = **변형 C `INSERT … WHERE NOT EXISTS`**(comp_cd+mat_cd+min_qty+comp 매칭)·comp_price_id **omit**(IDENTITY 자동) |

> ★ component_prices 자연키 UNIQUE 부재 → `ON CONFLICT` 불가 → NOT EXISTS 가드 필수(NULLS DISTINCT 함정 회피·[[dbmap-live-load-transition-260615]]). 복제는 기존 행 컬럼 verbatim(unit_price 불변).

---

## 5. D-1b 순서 의존 (중복 금지·동시배포)

- D-1b(`d1b-prctyp/`)는 후가공 13 comp의 `prc_typ_cd` `.01`→`.03` 메타 UPDATE. **본 배선 트랙은 D-1b comp를 건드리지 않음**(배선만·메타 무관).
- **순서 의존**: 명함 박(COMP_NAMECARD_FOIL_*)은 D-1b 그룹②(`.06/.05`) 후보 — 본 트랙은 그 박 comp를 **배선만**(메타 안 건드림·중복 0).
- **동시배포 [HARD]**: 신규 공식(.03 미관여)·배선과 **엔진 `.03` 해석 규칙(webadmin Phase11)** 은 분리 배포 금지. 배선만 적용하고 엔진이 합산형/고정가형 룩업을 모르면 미정의 동작. → 실 COMMIT은 엔진 동시배포 선결(인간 승인 큐).

---

## 6. 한 줄 현황

WIRE 결함 = **순수배선 1(PHOTOCARD) + 공식분리 2(NAMECARD·SILSA 대표) + MATGROUP 복제 1 + 031 박 배선 1**. 범위밖 4(스티커 STK-AXIS·아크릴 이중전무·SILSA 전파 26·SILSA 격자/CPQ). D-1b 참조만(중복 금지). 단가행 불변·라이브 PK 실측 충돌키 확정. 다음 = Phase B 통합 배선 실행본 빌드.
