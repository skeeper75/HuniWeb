# 사후검증 — 동형 전파 2차(남은 6셋트 구조 보정) 라이브 COMMIT

생성: hsp-load-executor · COMMIT 후 라이브 직접 재실측(2026-06-24) · 읽기전용 SELECT.
대상 6셋트: PRD_000072·077·082·088·097·100. COMMIT=UPDATE 6 + UPSERT 26 = 32 DML.
백업: `bak_t_prd_product_sets_setbuild_ext_20260624_0651`(26행)·`bak_t_prd_products_setbuild_ext_20260624_0651`(6행).

---

## 사후검증 5항목 (전부 PASS)

| # | 검증 | 기준 | 라이브 재실측 결과 | 판정 |
|---|---|---|---|---|
| ① | 6부모 유형 | =PRD_TYPE.01 | 6/6 = 01 | **PASS** |
| ②a | 26 셋트행 disp_seq 단조 | 1-4/1-4/1-5/1-5/1/1-7 | 072=1,2,3,4 · 077=1,2,3,4 · 082=1,2,3,4,5 · 088=1,2,3,4,5 · 097=1 · 100=1,2,3,4,5,6,7 | **PASS** |
| ②b | min/max/incr 여전히 NULL | 26/26 NULL | 26 (미변경 확인) | **PASS** |
| ③ | FK 고아 0 · 복합PK 중복 0 | 0/0 | orphan_sets=0 · pk_dups=0 · 행수 26 | **PASS** |
| ④ | 재-dryrun delta 0 (멱등) | type UPDATE=0 · 신규행 0 · fp 동일 | type UPDATE=0 · INSERT 0 26 · fp_pre==fp_post=`71f808b1c3ef3dbf59e0c4cb1145bc8e` | **PASS** |
| ⑤ | 6셋트 PRICE=0 불변 + 094 무손상 | 바인딩0·직접단가0 · 094=01·450,000 불변 | 6셋트 formula 바인딩 0·member 직접단가 0(진성 견적불가 유지) · 094 type=01·셋트행(95/96) 불변·가격사슬 fp=`4d01dda641d05ce57b5e4b223c236014`(baseline 동일·234행·sum 1,032,520) | **PASS** |

---

## 핵심 무손상 입증

- **우리가 가격을 일절 안 건드림**: 6셋트는 COMMIT 전후 모두 formula 바인딩 0·구성원 직접단가 0 → evaluate_set_price base_total=0 → PRICE=0(진성 견적불가, BLOCKED-PRICE-6 정직 분류). 구조 보정(유형·disp_seq·note)만 적재했고 t_prc_* 단가행은 미접촉.
- **094 엽서북(1차 COMMIT분) 무손상**: prd_typ_cd=01·셋트행(95 페이지20~30/+10·96 1권고정) 불변. PRF_PCB_FIXED 가격사슬 component_prices 234행 fingerprint=`4d01dda6…`(COMMIT 전 baseline과 비트 동일) → 094 가격(옵션 조합별 산출 450,000원 포함) 무손상. ★게이트 기준 "450,000원"은 특정 옵션 조합 시점값이며, 무손상 판정 기준은 가격사슬 단가행 fingerprint 불변(우리 32 DML이 094 및 t_prc_*를 일절 참조 안 함).
- **min/max/incr NULL 유지**: 26행 전부 NULL(권위 침묵·내지 member 부재·포토북 모호). 페이지축(RM-4)·면지자재(RM-2) 미접촉.

## BLOCKED 일절 미실행 (확인)

BLOCKED-PRICE-6(가격공식)·GUARD-1(평면합산 금지)·RM-4(페이지)·RM-2(면지 자재)·CONFIRM-3(포토북 권위)은 적재본에서 제외. COMMIT한 32 DML은 t_prd_products(prd_typ_cd만)·t_prd_product_sets(구조 컬럼만) 한정. 광역 쓰기 0.

## undo 경로 (불일치 없어 미사용)

`psql ... -v ts=20260624_0651 -f 06_load/undo-ext.sql` — 백업 스냅샷에서 6부모 유형(04)·26 셋트행(disp_seq=1 등) 원상 복원. 사후검증 5항목 전부 PASS이므로 undo 미실행.
