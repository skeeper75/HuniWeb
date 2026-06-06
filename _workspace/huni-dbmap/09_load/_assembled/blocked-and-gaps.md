# 차단·GAP 목록 — round-4 (각 항목 = 사유 + 정확한 해소 조건)

> **권위:** GOAL §7(차단의 정직한 표기·침묵 truncation 금지) · §10(인간 승인 체크포인트) · 대시보드 §4·§6.
> **원칙(HARD):** 차단을 "원천 부재"로 침묵 처리하지 않는다. 차단행은 즉시적재 파일에 절대 섞지 않는다(재포장 금지).
> **분류:** ① 차단(후니 등록 대기) ② GAP(무손실 표현 불가=에스컬레이션) ③ conditional(라이브 재확인) ④ deferred(출시/소스부재).

---

## 1. 차단 — 아크릴 완칼 → 레이저커팅 의존 (14행)

- **대상:** `t_prd_product_processes` PRD_000146·147·148·149·150·151·152·154·155·157·158·160·162·163 (각 1행, proc_cd=레이저커팅).
- **사유(K-2):** round-3는 완칼에 `PROC_000053`(종이/스티커 완칼) 차용. K-2 결정=레이저커팅 proc_cd 신설·053 차용 중단. 신규 `PROC_000084`(레이저커팅) 라이브 부재.
- **해소 조건:** 후니가 `t_proc_processes`에 레이저커팅 proc_cd 등록(`code-row-preload.md §1`) → 14행 active 승격.
- **소스:** `blocked/relation-rows-blocked.csv` (kind=`FK-blocked(레이저커팅 신설)`).
- **유의:** over-reach 완칼 161·168·169는 본 14행에 **불포함**(product-level 근거 부재로 `_deferred` 보류, D-AC-8). 161의 UV행은 즉시적재(완칼만 보류).

## 2. 차단 — addon template 부재 (4행)

- **대상:** `t_prd_product_addons` (tmpl_cd 변환 후 template 미존재).

| prd_cd | addon 상품 | tmpl_cd(필요) | 시트 | L1 근거 |
|--------|-----------|--------------|------|---------|
| PRD_000016 | 트레싱지봉투(PRD_000003) | TMPL-PRD_000003 | digital-print | 프리미엄엽서 추가상품=트레싱지봉투 |
| PRD_000018 | 트레싱지봉투(PRD_000003) | TMPL-PRD_000003 | digital-print | 스탠다드엽서 추가상품=트레싱지봉투 |
| PRD_000135 | 천정고리(PRD_000008) | TMPL-PRD_000008 | silsa | 족자포스터 추가=천정형고리 포함 |
| PRD_000217 | 만년스탬프잉크(PRD_000015) | TMPL-PRD_000015 | goods-pouch | 만년스탬프 추가상품=검정 5cc |

- **사유(조립 중 적발):** 라이브 `t_prd_product_addons`는 `addon_prd_cd` 컬럼 부재·`tmpl_cd → t_prd_templates` FK 모델. addon 대상 상품(PRD_000003·008·015)은 라이브 `t_prd_templates`에 template 미등록. **[보정 MINOR — 전제 정정]** 라이브 template은 **11개 존재**(001·002·004·005·006·009·012·013·014·281·282, read-only SELECT 2026-06-06). 그 중 **003·008·015가 부재**라 본 4행 차단(outcome 정당). 종전 "005·012만 존재" 문구는 사실오류 → 정정.
- **해소 조건:** 후니가 해당 상품용 template(`TMPL-PRD_000003`·`008`·`015`)을 `t_prd_templates`에 등록 → addon 행 적재 가능. (또는 라이브 addon 모델을 재확인해 round-3 매핑 정정 — 검증자/디자이너 라우팅 대상.)
- **소스:** `blocked/relation-rows-blocked.csv` (kind=`FK-blocked(template 부재)`).
- **에스컬레이션:** 이 4행은 round-3 설계가 라이브 addon=tmpl_cd 모델을 미반영한 결과. 검증자 재확인 필요(§맨아래).

## 3. 차단 — sticker 066 원형 size link (11행, 코드선적재 의존)

- **대상:** `t_prd_product_sizes` PRD_000066 원형 10~60mm 11행.
- **사유:** 마스터 `t_siz_sizes`에 합판도무송 원형 siz_cd 부재(10종 무매치). **[보정 MAJOR]** 단 원형35x35는 라이브 `SIZ_000422` **실재**(siz_nm 전수 매칭) → 신설 불요·재사용. 나머지 10종만 siz_cd FK 충족 불가.
- **해소 조건:** 후니가 `code-row-preload.md §2`의 **신설 10 siz_cd(SIZ_000501~510)** 등록 → link 11행 적재(신설 10 + 라이브 SIZ_000422 재사용 1). 원형35mm는 코드 등록 없이 즉시 link 가능.
- **소스:** round-3 `sticker/_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv` (치수·EA 실값, siz_cd=`(MINT_NEEDED)`) + `_assembled/load/00_siz_sticker_circle.csv`(`_mint`=NEW/REUSE 구분).

## 4. 차단 — 디자인캘린더 5 신규상품 (18 연결행 + products 5)

- **대상:** `t_prd_products` 5신규(PRD_NEW_DCAL_1~5) + 연결 `t_prd_product_{sizes 5·materials 5·processes 2·print_options 5·page_rules 5·addons 2}`.
- **사유(Q-DC-0):** 디자인탁상형/미니탁상형/엽서/벽걸이/와이드벽걸이 캘린더 = calendar(108~112)와 **다른 별도 상품**(후니 (N,Y) 패턴=포토북[디자인명]). 라이브 부재 → 신규 `t_prd_products` INSERT 필요. **placeholder prd_cd(PRD_NEW_DCAL_*)** — 실번호는 후니 부여(라이브 max PRD_000282 이후).
- **해소 조건:** 후니가 5상품 prd_cd 실번호 부여 + 출시 승인 → placeholder를 실번호로 치환 후 18 연결행 적재. (addon PRD_000005·012는 template 실재 → prd_cd 치환만으로 적재 가능.)
- **소스:** `blocked/design-calendar-newprod/*.csv` (7파일, 전 컬럼 보존·`_src_*` provenance).
- **잔여 컨펌:** Q-DC-1(디자인엽서 멤버 확정·L1 디자인보유● 비표시) · Q-DC-2(트윈링 택일그룹 헤더 신설) · Q-DC-3(캘린더봉투 사이즈변형 addon note vs 별도옵션).

## 5. GAP — goods-pouch 비치수 size (47상품, 무손실 표현 불가 → 에스컬레이션)

- **대상:** `t_prd_product_sizes` goods-pouch active 47상품. (reference 125행 = `goods-pouch/load/t_prd_product_sizes_BLOCKED.reference.csv`).
- **사유(D-1, BLOCKER 본질):** L1 `사이즈(필수)` 칸이 WxH 치수가 아닌 **형상/규격/용량 라벨**(원형90mm·11온스·350ml·M/L/XL·정사각M 등). 대응 마스터 `t_siz_sizes.siz_cd` 부재(전수 무매치). WxH 치수 보유 8상품은 이미 적재됨.
- **왜 GAP인가:** 비치수 라벨을 ⓐ마스터 siz_cd 신설(사각손거울식 짝 적재) vs ⓑ`t_prd_products.nonspec_*` 인코딩 — **모델링 미정**. 우리측 추정 발명 불가(비치수→치수 둔갑 위험). sticker 066(치수 실재)과 달리 **치수 자체가 미확정**이라 코드선적재도 불가.
- **해소 조건:** 후니가 비치수 사이즈 마스터 모델링 정책 확정(siz_cd 신설 vs nonspec 인코딩) → 그 후 47상품 size 적재 또는 nonspec 인코딩. **라이브 재실행으로도 해소 안 되는 구조적 GAP.**
- **에스컬레이션:** GOAL §10.3(GAP 모델링 결정=인간 승인). 억지 평면화 금지.

## 6. GAP — (박 2단룩업) 해당 없음

- round-4 상품마스터 11시트에 박류 미포함. 박(소/대) 2단룩업 GAP은 round-2 가격트랙 이슈(`price-load-validation-final.md`)로 본 번들 범위 밖. 명시적으로 "해당 없음"으로 표기(침묵 누락 아님).

## 7. conditional 보류 — 라이브 재확인 (9행, 즉시적재 파일에서 제외)

| 시트 | 대상 | 행수 | 상태 / 적재 직전 액션 |
|------|------|------|----------------------|
| digital-print | `t_prd_product_processes` 016 (PROC 29~32) | 4 | **DROP 확정** — 라이브 SELECT(2026-06-05) 016=27~32 실재. active 승격 금지(중복PK). 폐기 대상(이력 보존). |
| calendar | `t_prd_product_materials` 108~111 (MAT_000107) | 4 | PK충돌 — 라이브 기적재 확인. 적재 직전 라이브 SELECT로 부재 시 active 승격, 실재 시 폐기. |
| acrylic | `t_prd_product_processes` 151 (PROC_000081 부착) | 1 | PK충돌 — 맥세이프 부착 기적재. 적재 직전 라이브 재확인. |

- **소스:** 각 시트 `*conditional.csv`. **즉시적재 `load/*.csv`에 미포함**(재포장 금지).

## 8. deferred — 출시/소스부재 (적재 대상 아님, 기록만)

| 시트 | 항목 | 행수 | 사유 |
|------|------|------|------|
| **booklet** | 내지자재(070 PUR·072·077·082·088) | 6 | **K-1: IMPORT 컬럼 부재 → 실무 자재정보 필요**(소스 부재, 발명 금지). 후니 입력 시 해소. |
| acrylic | processes(use_yn=N 6상품 ×2 + over-reach 161·168·169) | 15 | 비활성 미출시(C-1) + product-level 완칼 근거 부재(D-AC-8). |
| acrylic | materials | 4 | 비활성/소스. |
| silsa | board/액자 자재 | 7 | MAT master 부재(MAT_TYPE.08 미포함, D-SL-1). |
| silsa | addon flag(배너거치대·큐방·각목·끈 등) | 9 | master 미존재 flag. |
| 기타 | 시트별 bundle/page deferred | - | 각 `09_load/<sheet>/_deferred/` 권위. |

- **deferred는 차단과 구분:** 비활성=미출시(출시 시점 처리)·소스부재=발명 금지(실무정보 입력 시 처리). 둘 다 **누락 아님**(C-1).

---

## 9. 인간 에스컬레이션 요약 (사용자 판단 필요)

| # | 항목 | 유형 | 요청 |
|---|------|------|------|
| 1 | 레이저커팅 proc_cd | 코드선적재 | 등록 승인(또는 053 차용 유지 결정) → 아크릴 완칼 14행 |
| 2 | sticker 원형 신설 10 siz_cd | 코드선적재 | 등록 승인 → 066 원형 size 11행(신설 10 + 라이브 SIZ_000422 재사용 1) |
| 3 | addon template 부재 4행 | 결함/모델 | PRD_000003·008·015 template 등록, **또는 라이브 addon 모델 재확인**(round-3 매핑 정정) |
| 4 | 디자인캘린더 5신규상품 | 신규등록 | prd_cd 실번호 부여 + 출시 승인(Q-DC-0~3) → 18 연결행 |
| 5 | goods-pouch 비치수 size 47상품 | GAP 모델링 | siz_cd 신설 vs nonspec 인코딩 정책 확정(D-1) |
| 6 | booklet 내지자재 6행 | 소스부재 | 5상품(070·072·077·082·088) 내지종이 실무 자재정보(K-1) |
