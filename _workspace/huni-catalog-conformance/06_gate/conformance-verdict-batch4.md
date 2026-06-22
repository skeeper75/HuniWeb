# conformance-verdict-batch4.md — 굿즈파우치 독립 검증 게이트 K1~K8 (생성≠검증)

> hcc-conformance-gate · 2026-06-23 · §21 배치4(goods-pouch 라이브 98 prd PRD_000183~280·del_yn=N).
> ★전 11시트 마지막 배치. 생성측(3 인스펙터·codex) 주장 비신뢰 — 게이트가 라이브 읽기전용 SELECT 직접 재실측.
> 재실측 도구: psql(`.env.local RAILWAY_DB_*`)·evaluate_price 계약 재계산·gstack(K6 PW stale→BLOCKED).
> 단가 verbatim 불변·DB 미적재·비밀값 비노출.

## 0. 종합 판정 = **CONDITIONAL GO** (K6 정직 BLOCKED·나머지 7게이트 PASS)

- **K1·K2·K3·K4·K5·K7·K8 = PASS** (게이트 직접 재실측이 인스펙터 셀/보드·codex reconcile를 전건 비준).
- **K6 = BLOCKED**(HUNI_ADMIN_PW stale·로그인 거부 5연속·추측 금지) → 정직 BLOCKED·사유 명시 → CONDITIONAL.
- 단일 FAIL 0. 굿즈파우치는 가격 전건 미바인딩(견적0)이 최대 결함이나 **검증 결론은 결함을 정확히 적발·재현**했으므로 게이트는 PASS.

## 1. K1~K8 판정표

| 게이트 | 판정 | 재실측 증거(직접 SQL·날조 0) |
|--------|------|------------------------------|
| **K1 커버리지 누락 0** | ✅ PASS | checklist batch4 = 1,274행(98 prd × 13축)·빈 필드 0(awk 전수)·distinct prd=98. cells 3종 합 = 784(basedata)+392(cpq)+98(price)=1,274 = checklist 정합. |
| **K2 기초데이터 정합** | ✅ PASS | 판형 122행/85 prd·**output_paper_typ_cd NOT NULL = 0**(전건 NULL→EXTRA 85 확정). 자재 76 prd(authority-spec §4 "78"은 카운트 오차·보드값 76 정답). sizes 11·bundle 1·processes 6·print_options 0 = 인스펙터 셀과 완전 일치. |
| **K3 CPQ 연결 무결성** | ✅ PASS | option_groups/options/items/addons/constraints **굿즈 범위 0행**. addons 전역 5행=전부 PRD_000016(아크릴)·굿즈 귀속 0. dead-link/orphan 발생 불가(행 자체 부재)→고아 0 비준. |
| **K4 가격엔진 정합** | ✅ PASS | **formula 0·product_prices 0**(바인딩 0/98 재현)·discount_tables 82(distinct prd 82). 할인타입 dist=GOODSA15·GOODSB11·FABRIC50·SQUISHY5+**ACR1(PRD_000203 오귀속)**=82. 5 dsc_tbl_cd 전건 FK 해소(t_dsc_discount_tables)·use_yn=Y·dsc_typ_cd=DSC_TYPE.01(정률). |
| **K5 종단 e2e 추적** | ✅ PASS | GC-GP2(틴거울 qty=100) 재현: pp 0·frm 0→**source=NONE→base 단절** 재현. 할인 DSC_GOODSB_QTY 라이브 verbatim=1~99:0/100~499:5/500~:10 → 골든 §0-3 **허용오차 0 일치**. base 적재 시 300,000×0.95=285,000 자동 성립. → e2e-golden-trace-batch4.md. |
| **K6 라이브 화면 대조** | ⚠ **BLOCKED** | gstack 로그인 시도 → "아래 오류들을 수정하기 바랍니다"·STILL_LOGIN(URL 미리다이렉트). **HUNI_ADMIN_PW stale**(memory 4연속+본 회차=5연속). 추측 로그인 금지 → 정직 BLOCKED. product-viewer 3원 대조 미수행. |
| **K7 codex reconcile 수렴** | ✅ PASS | reconcile 합의6·불일치0·신규발굴1·가설2 전건 라이브 재실측 해소: ① 자재 76 HYPOTHESIS→재측정(67/164 옵션값 행·일부 본체소재 공존=MISMATCH 유효·전수 100%는 아님) ② discount FK 무결성(codex 신규)→FK 전건 유효·use_yn=Y·미해결 0 ③ PRD_000203 ACR→확정 ④ 단가행 유일성→base 0이라 N/A·적재 명세 가드로 이월. |
| **K8 생성≠검증 독립성** | ✅ PASS | 게이트 자체 psql 재실측 14쿼리(인스펙터 인용 아님). plate NULL·discount dist·FK 해소·골든 할인 verbatim·base 단절 전부 자체 재현. 인스펙터 셀과 독립 수렴(주장 인용 PASS 아님). |

## 2. codex 게이트큐 해소 (K4·K8 라이브 재실측 결과)

| codex 큐 항목 | 게이트 재실측 결과 | 판정 |
|---------------|-------------------|------|
| **자재 76 전수 100% 오염?**(HYPOTHESIS) | 76 prd materials 164행 중 67행=옵션값(2구/3구/4구·단/양면·S/M/L·블랙M 등). **PRD_000230=`레더\|L\|M`**=본체소재(레더)+옵션값 공존 적발 | 100% 오염 **기각**·prd 단위 MISMATCH 유효(혼입 존재)·교정은 **행 단위**(본체소재 잔류·옵션값만 이관) |
| **판형 85 EXTRA**(C-GP-3) | output_paper_typ_cd NOT NULL=0/122 전건 NULL | EXTRA 85 **비준** |
| **discount FK/del-use/권위타입 무결성**(codex 신규발굴1) | 5 dsc_tbl_cd 전건 FK 해소·use_yn=Y·정률. 굿즈 정당 81(GOODSA/B/FABRIC/SQUISHY)+ACR1 오귀속 | FK 결함 0·**유일 결함=PRD_000203 ACR 오귀속**(미해결 0) |
| **PRD_000203 DSC_ACR_QTY 오귀속** | live=DSC_ACR_QTY 확정·굿즈=GOODSA/B/FABRIC/SQUISHY여야 | D-GP4-ACR-MISBIND **확정** |
| **단가행 유일성**(codex 가설2) | product_prices 0행·base 미적재 | 현 시점 N/A·적재 명세 가드로 이월(remediation §G-GP-6) |
| **바인딩 0/98 = 결함 vs 굿즈 의도** | formula 0+pp 0=source=NONE 재현 | DEFECT **비준**·NOPRICE 5는 NO_AUTHORITY 별개(인간 확정) |

## 3. 핵심 결함 확정 (재실측 비준)

| 결함 | 규모 | 클래스 | 돈영향 |
|------|------|--------|--------|
| **D-GP4-BIND** 가격 전건 미바인딩 | 93 prd(NOPRICE 5 제외) | A(GP-1)/B(GP-2) | **차단·견적 0원**(최대 결함) |
| **C-GP-3** 판형 85 EXTRA | 85 prd/122행 | A | 잔재(적재 시 차원환원 오류 위험) |
| **자재 76 MISMATCH** 옵션값 혼입 | 76 prd/67행 | A | 적재 시 silent 합산 위험(현 base 0=inert) |
| **묶음수 64·도수 98·사이즈 54 MISSING** | — | A/B | variant 환원 불가 |
| **CPQ 77 MISSING**(옵션그룹67·addon5·템플릿5) | 77셀 | B | variant 선택 UI 부재 |
| **D-GP4-ACR-MISBIND** PRD_000203 할인타입 오귀속 | 1 prd | A | 잠재 오청구(base 적재 시 아크릴 구간율) |
| **D-GP4-DSC-ORPHAN** 82 할인 고아 | 82 prd | (BIND 종속) | base 적재 시 자동 해소 |

- **NO_AUTHORITY 5**(투명부채·미니CD앨범·극세사타월·타이벡북커버·말랑증사홀더) = 결함 아님·권위 가격공란·인간 확정 큐(C-GP-2).

## 4. 데이터 관측 메모(게이트 발견·verdict 무영향)

- authority-spec-batch4 §4 = "materials 78". 게이트 재실측 = **76**(인스펙터 보드 정답). 카운트 오차이며 전건 MISMATCH/MISSING이라 판정 불변.
- cpq cells.csv "option_groups 138·items 480" = del_yn 미필터 raw. 게이트 del_yn=N 재측정 = 133·473. 굿즈 범위 0행이라 게이트 무영향.

## 5. 종합

**CONDITIONAL GO** — K6(gstack)만 자격증명 stale로 BLOCKED, 나머지 7게이트 직접 재실측 PASS. 결함은 정확히 적발·재현됐고 교정 명세로 라우팅(remediation-spec-batch4.md). 실 COMMIT/DDL은 인간 승인 후 dbmap 위임. 단가 verbatim 불변·DB 미적재.
