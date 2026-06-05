# BLOCK-1 — 자재 IMPORT 컬럼 ↔ prd_cd 확정 해소 노트

> round-3 L2 정합검증 차단 전제 BLOCK-1 해소. 작성 2026-06-05.
> 권위: `00_schema/ref-products.csv`(prd_nm↔prd_cd) · `06_extract/seoljeong-import-map.csv`(IMPORT↔slot) · `04_audit/import-resolution.csv`(추정 매핑).
> 산출: `04_audit/import-resolution-resolved.csv`(prd_cd·slot·신뢰도 컬럼 추가). 라이브 SELECT **미수행**(추출본만으로 결정적 — prd_nm 매칭은 ref-products 스냅샷이 권위).

---

## 1. 매칭 결과 요약

import-resolution.csv 14행(IMPORT 컬럼)을 prd_cd 단위로 전건 확정. IMPORT 1컬럼이 복수상품/복수슬롯에 귀속되는 경우 분해.

| IMPORT 컬럼 | 확정 prd_cd | slot | 신뢰도 |
|-------------|-------------|------|--------|
| 소량전단지/접지리플렛 | PRD_000047, PRD_000048 | 종이 | 정확 |
| 트윈링내지 | PRD_000071 | 내지 | 표기차브리지 |
| 트윈링표지 | PRD_000071 | 표지 | 표기차브리지 |
| 무선내지 | PRD_000069 | 내지 | 표기차브리지 |
| 무선표지 | PRD_000069 | 표지 | 표기차브리지 |
| 중철내지 | PRD_000068 | 내지 | 표기차브리지 |
| 중철표지 | PRD_000068 | 표지 | 표기차브리지 |
| 2/3단·미니접지카드 | PRD_000027, PRD_000029, PRD_000028 | 종이 | 정확 |
| 벽걸이캘린더 | PRD_000111, PRD_000116 | 종이 | 중복해소필요 |
| 스탠다드엽서 | PRD_000018 | 종이 | 정확 |
| 프리미엄엽서 | PRD_000016 | 종이 | 정확 |
| 미니탁상형캘린더 | PRD_000109, PRD_000114 | 종이 | 중복해소필요 |
| 엽서캘린더 | PRD_000110, PRD_000115 | 종이 | 중복해소필요 |
| 탁상형캘린더 | PRD_000108, PRD_000113 | 종이 | 중복해소필요 |
| 프리미엄명함 | PRD_000031 | 종이 | 정확 |

## 2. 신뢰도 분포

- **정확(prd_nm 1:1 정확매치)**: 6컬럼 → 8개 prd_cd (소량전단지/접지리플렛 2, 접지카드 3, 스탠다드엽서·프리미엄엽서·프리미엄명함 각 1).
- **표기차브리지(반제품 표기 → 통합상품 귀속)**: 6컬럼 → 3개 prd_cd × 2슬롯. 트윈링(071)·무선(069)·중철(068) 책자는 IMPORT가 `-내지/-표지`로 분해 표기하나 ref-products엔 **통합상품 prd_nm만 존재**(반제품 prd_nm 부재). 따라서 통합 prd_cd에 내지/표지 slot으로 귀속. BLOCK-2 실측(sets 0행=정상 통합상품)과 정합 — 종이옵션 분기 구조.
- **중복해소필요(동명 2상품)**: 4컬럼 → 캘린더류. ref-products에 동명 2건(`editor_yn=N` 일반판 + `editor_yn=Y` 에디터판)이 쌍으로 존재(탁상형 108/113, 미니탁상형 109/114, 엽서 110/115, 벽걸이 111/116). IMPORT 종이세트는 1종이므로 **두 변형 공통 귀속**. 적재 시 `editor_yn` 분기로 양쪽 적재.

**미해소(LOW) 잔여: 0건.** 14행 전건 prd_cd 확정. 추정 단계 잔존 없음.

## 3. 6갭 확인 — IMPORT 상품컬럼 부재(역방향 실갭)

`seoljeong-import-map.csv`에서 `matched_paper_count=0`(IMPORT 종이컬럼 부재) = DB 상품은 있으나 IMPORT 실자재가 없는 실갭. **slot 기준 6갭** 확정:

| # | prd_cd | prd_nm | slot | 상태 |
|---|--------|--------|------|------|
| 1 | PRD_000070 | PUR책자 | 내지 | IMPORT 부재 |
| 2 | PRD_000070 | PUR책자 | 표지 | IMPORT 부재 |
| 3 | PRD_000072 | 하드커버책자 | 내지 | IMPORT 부재 |
| 4 | PRD_000077 | 레더 하드커버책자 | 내지 | IMPORT 부재 |
| 5 | PRD_000082 | 하드커버 링책자 | 내지 | IMPORT 부재 |
| 6 | PRD_000038 | 형압명함 | 종이 | IMPORT 부재 |

- 상품 기준 5종(PUR책자가 2슬롯), slot 기준 6갭.
- **하드커버류 내지 부재**는 BLOCK-2와 정합: 하드커버류는 표지/면지를 product_sets 반제품으로 분해 → 내지 종이는 반제품 쪽 관리, 통합상품 IMPORT 내지컬럼 불필요. 즉 정상 구조갭(설계 의도).
- **형압명함(038)**: digital-print row 146에서 종이컬럼 0. 명함 IMPORT 16종은 프리미엄명함(031)에만 매핑됨. 형압명함은 별도 IMPORT 종이축 부재 → 자재 적재 시 프리미엄명함 종이세트 차용 여부 L2에서 CONFIRM 필요(자동 MISSING 아님).
- **PUR책자(070)**: 무선/트윈링/중철과 동급 통합상품이나 IMPORT 종이컬럼만 부재. BLOCK-2 실측상 sets 0행(동급) → 종이옵션이 있어야 하나 IMPORT 원천에 PUR 종이세트 부재. **실갭(IMPORT 추출 누락 또는 미등록)** — L2에서 무선/중철 종이세트 차용 여부 CONFIRM 대상.

## 4. L2 정합검증 입력 조건 충족

- 자재 expected는 더 이상 "MISSING 후보(신뢰도 B)"가 아니라 **prd_cd 확정 기반 집합대조** 가능. 캘린더 중복(editor_yn 분기)·책자 통합귀속(slot)·6갭(IMPORT 부재) 규칙이 명시됨.
- 자재 MAJOR 정량화 가능: 6갭 중 4갭(하드커버 내지 3 + PUR 부분)은 **정상 구조갭**, 형압명함·PUR 종이는 **CONFIRM 대상**으로 분류.

## 부록 — 수행 로그
- 매칭 도구: ref-products.csv `grep`(prd_nm↔prd_cd), seoljeong-import-map.csv(IMPORT↔slot 권위), read-only. **라이브 SELECT 미수행** — prd_nm 매칭은 ref 스냅샷이 결정적 권위이며 모호 건 없음(중복은 editor_yn 분기로 결정적 해소, 반제품은 ref에 prd_nm 부재가 결정적).
- 신선도: ref-products.csv 2026-06-04 추출. 014~016 등 동명상품 editor_yn 값은 ref 스냅샷 기준.
