# 진단 요약 인덱스 — 4축 (사이즈·도수·인쇄옵션·공정)

> **하네스** hbg Phase 2 진단가. **작성** 2026-06-18 · **갱신** 2026-06-18(Phase 2 전수 진단 완료).
> **지위:** 4축 **전수 진단 완료** → 각 축 전수 보드 = `diagnosis-{size,color,printoption,process}.md`. 본 문서는 그 **요약 인덱스**(4-way·상태·라우팅 윤곽 + 컨펌 해소 결과). 1순위(자재·카테고리)는 `diagnosis-material.md`·`diagnosis-category.md`.
> **라이브 실측:** 2026-06-18 읽기전용 SELECT(행수·SEED·오염·param·FK 참조 전수). dbmap round-13·round-22·round-23 진단은 인용.

---

## ★ 컨펌 해소 결과 (D.2 — 라이브 직접 실측)

| ID | 충돌/모호 | 라이브 실측 해소 |
|----|-----------|------------------|
| **C-PROC-1** | t_proc_processes 83 vs 84(열재단) | **102행·MAX PROC_000102**(이미 진화). **PROC_000084 열재단 실재**(del_yn='N'·family head). 83/84 논쟁 종결 |
| **C-SIZ-2** | t_siz_sizes 500 vs 510 + round-23 구간차원 | **520행**. siz_width/siz_height는 siz 마스터엔 **없음** → `t_prc_component_prices`에 922행(round-23 구간차원 **라이브 COMMIT 확정**·좌표 채번 폐기) |
| **C-PO-3** | print_options 166 vs 172 | **166행**(권위 일치·ref-csv 172는 del 전 stale) |
| **C-CLR** (즉시 어긋남 게이트) | 5행 SEED·별색 혼입 시 즉시 어긋남 | **5행 정확·별색 혼입 0·colrcnt 혼입 0** → 게이트 통과(🟢) |

## ★ 4축 상태 한눈 + 핵심 결함

| 축 | t_* | 라이브 | 상태 | 핵심 결함 | 전수 보드 |
|----|-----|:--:|:--:|-----------|-----------|
| ② 사이즈 | t_siz_sizes | 520 | 🟡 | 색오염 2행(가격0참조·교정가능)·nonspec 25/275 채움(data-gap)·형상+EA 30행 판정불가 | `diagnosis-size.md` |
| ③ 도수 | t_clr_color_counts | 5 | 🟢 | **결함 0**(SEED 정확·혼입 0) | `diagnosis-color.md` |
| 인쇄옵션 | t_prd_product_print_options | 166 | 🔴 | **print_side에 UV 변형 enum 63행 오적재**(round-13 CONFIRMED). [B2] **14 UV 실연결·7 공정연결 전무** | `diagnosis-printoption.md` |
| ⑤ 공정 | t_proc_processes | 102 | 🟢→🟡 | 마스터 오염 0(family·별색·열재단 정상)·param 선택값 = **기존 `option_items.dtl_opt` 재사용**(B4·신규 mint 0) | `diagnosis-process.md` |

> **★Phase 2 1줄 요약:** 도수·공정 마스터 = 건전(오염 0). 실 결함 2건 = **인쇄옵션 print_side UV 오적재 63행(🔴)** + 사이즈 색오염 2행(가격 안전).
> **★검증자 보완(B2·B4·라이브 재실측):** [B4] UV 변형 목적지 = **기존 `t_prd_product_option_items.dtl_opt` jsonb 재사용**(라이브 6행 실사용·`{"유형":"봉미싱(7cm)"}` 동형 입증) → ref_param_json 신규 mint **철회(0)**·rpmeta V-1 vessel-gap→**data-gap** 격하. [B2] UV 21상품 = **14 실연결 + 7 공정연결 전무**(PO-1a 즉시·PO-1b 연결선행 BLOCKED).

---

## 0. 4축 라이브 행수 실측 (2026-06-18)

| 축 | t_* | 라이브 행수(실측) | 정답 사전 인용 | 진화 |
|----|-----|-----------------|----------------|------|
| ② 사이즈 | `t_siz_sizes` | **520** (impos_yn=Y 15 · del_yn=Y 65) | 500/510 | +10 진화(신규 siz 적재·round-23 스티커/아크릴 채번 반영) |
| ③ 도수 | `t_clr_color_counts` | **5** (SEED 고정) | 5 | 불변(폐쇄 도메인) |
| 인쇄옵션 | `t_prd_product_print_options` | **166** (print_side 5종) | 166 | 불변 |
| ⑤ 공정 | `t_proc_processes` | **102** (root 22 · MAX PROC_000102) | 83/84 | +18 진화(round-22 ⑤ 봉제/부착·round-23 신규 공정 적재) |

---

## ② 사이즈 — `t_siz_sizes` (🟡 size↔option 경계)

| 4-way | 내용 |
|-------|------|
| ①권위 | 물리 치수만(작업/재단 이중축). 색·형상·수량·출력판형 인코딩 금지(OM-1) |
| ②라이브 | 520행(impos_yn=Y 15·del 65). round-23 스티커 SIZ_000518/519·아크릴 siz_width/height 차원 적재 반영 |
| ③역공학 | rpmeta vessel-quantity-size-pricing(이산 면적매트릭스 셀) · #17 형상축(vessel-shape-axis V-12 SHAPE)은 별축 |
| ④경쟁사 | GAP-MAT-1 WowPress nonspec_*(비규격 min/max) — 후니 컬럼 실재하나 NULL(**data-gap**) |

**결함 상태(인용):**
- **size↔option 경계**(AX-2·OM-2): 굿즈파우치 폰기종/등급·사이즈등급이 size로 적재됐으나 option이어야 할 수 있음. **★기계적 size 삭제 금지**(가격사슬 파손·round-10/round-22 ② 인용). round-22 ②=라이브 가역 0(component_prices 116siz 2,601행 CASCADE·전부 가격종속·CORRECT 반증).
- **자재 .09 유입 대기:** 본 진단 자재 보드의 .09 shape 18 + size 11 = **29행이 ② siz로 축이동 예정**(재배선 선행).
- **nonspec NULL**(GAP-MAT-1): 비규격 컬럼 그릇 실재·미채움(data-gap·자재 아님).

**라우팅 윤곽:** 대부분 CORRECT(유지). 자재→② 축이동 29행 수신. nonspec data-gap 채움(②축 확장 시). **컨펌:** AX-2(size→option 사슬 보존)·AX-3(실사 비규격 좌표 vs 면적함수).

---

## ③ 도수 — `t_clr_color_counts` (🟢 양호)

| 4-way | 내용 |
|-------|------|
| ①권위 | 잉크 채널수 0~4. **5행 폐쇄 SEED**(신규 발급 없음) |
| ②라이브 | **5행 정확히 일치 실측:** CLR_000001 인쇄 안 함(0)·002 1도흑백(1)·003 2도(2)·004 3도(3)·005 CMYK 4도(4) |
| ③역공학 | 별색=공정(PROC_000007 family·clr_cd=NULL) — 도수와 분리 정상 |
| ④경쟁사 | 갭 없음(채널수=물리 상한·표준 흡수) |

**결함 상태(인용):** 🟢 **정상.** 별색 분리 정상(round-22 ③ 인용·라이브 SEED 무변형 실측 확인). **자재 .10 잉크색 8행 유입 목적지**(AX-1) — 단 잉크색이 도수인지는 컨펌(도수=CMYK 채널 vs 별색공정 vs 자유옵션).

**라우팅 윤곽:** 신규/교정 0(SEED 폐쇄). 자재 잉크색 수신 여부 = AX-1 컨펌. **결함 없음.**

---

## (인쇄옵션) — `t_prd_product_print_options` (별색/UV 라우팅 축)

| 4-way | 내용 |
|-------|------|
| ①권위 | 인쇄면 도수(단/양면·앞뒷면 color count). opt_id PK·OPT_REF_DIM.06(도수=opt_id NOT clr_cd) |
| ②라이브 | **166행·print_side 5종 실측** |
| ③역공학 | UV=PROC_000002 param(OM-5)·별색=PROC_000007 — print_side에 금지 |
| ④경쟁사 | (도수 축에 흡수) |

**결함 상태(전수 진단 — `diagnosis-printoption.md`):** 🔴
- **PO-1 print_side에 UV 변형 enum 63행 오적재**(라이브 실측): print_side ∈ {단면 62·양면 41·**풀빼다 21·배면양면 21·투명테두리 21**}. 후자 63행 = `PROC_000002`(UV) prcs_dtl_opt 변형 enum값. round-13 "UV 전역 오적재" **CONFIRMED 잔존**.
- 대상 21상품 = **아크릴 굿즈**. [B2 정정] **14만 UV(PROC_000002) 실연결·7 공정연결 전무**(명찰골드153·지비츠156·코스터159·코롯토164·포카코롯토165·카라비너166·지비츠★171). front_colrcnt=CLR_000005(도수 정확)·**colrcnt 별색 혼입 0**(✅).
- ★교정 무비용 아님(14상품 가격사슬 묶임). [B4 정정] 변형 목적지 = **기존 `option_items.dtl_opt` 재사용**(라이브 실재·신규 mint 0).

**라우팅 윤곽 [B2·B4 정정]:** 교정(변형→dtl_opt 이관 + print_side 정규화). **PO-1a 14 실연결=즉시**(그릇=dtl_opt 실재) / **PO-1b 7 무연결=PROC_000002 링크 선행**(정체 BLOCKED). ~~ref_param_json 신설~~ 철회. **컨펌:** B-PO-1(14 한정 화이트 underbase 일괄결정).

---

## ⑤ 공정 — `t_proc_processes` (🟡 누락 지배)

| 4-way | 내용 |
|-------|------|
| ①권위 | 공정+인쇄방식(self-ref PROC_000001)+별색(PROC_000007)+prcs_dtl_opt JSON param |
| ②라이브 | **102행·MAX PROC_000102 실측**(정답사전 84→102 진화·round-22 ⑤·round-23 신규 공정 적재). family head 전건 정합(인쇄001·별색007·박033·제본017·완칼053/반칼054/스티커완칼055·열재단084). 신규 085~102 = per-product 인스턴스(전건 upr_proc_cd로 head 참조·위상 건전) |
| ③역공학 | vessel-process-parameter(param 저장)·vessel-print-method-recipe(인쇄방식 레시피) |
| ④경쟁사 | GAP-MAT-4 RP/WP 캐스케이드 제약(자재/사이즈→공정 disable) — 후니 constraints 거의 미적재(**빈칸 후보**) |

**결함 상태(전수 진단 — `diagnosis-process.md`):**
- **마스터 오염 0**(🟢): family head·별색 분리(008~012 clr_cd 없음)·열재단(084)·prcs_dtl_opt 스키마(UV 변형·오시 줄수·반칼 조각수) 전건 건전. param 비대화(구수별 별 proc) 없음.
- **누락→대부분 적재됨**: 봉제(088)·부착(089)·에폭시(095)·미싱(086)·캘린더 제본(098~102) 라이브 신규 적재 확인(round-22 ⑤·round-23). MAX 102로 진화 = 누락 지배 → 해소 진행.
- **실 결함 = PR-1 data-gap** [B4 정정]: 공정 param **선택값** 저장처 = **기존 `t_prd_product_option_items.dtl_opt`**(라이브 6행 실사용·`{"유형":"봉미싱(7cm)"}`). prcs_dtl_opt=스키마. **ⓒ data-gap**(그릇 실재·UV 변형 미적재) ← vessel-gap 오판 철회. PO-1 UV값 목적지 = dtl_opt(PO-1↔PR-1 합류).
- **판정불가 PR-2**: 레이플랫 PROC_000025 권위=미운영(Q10) vs 라이브 del_yn='N'·use_yn='Y' 활성 → AX-6 컨펌.

**라우팅 윤곽 [B4 정정]:** ~~신규등록 ref_param_json 컬럼~~ **철회(mint 0)** → dtl_opt 이관(data-gap 채움). 캐스케이드 제약 빈칸(GAP-PROC-2·constraints). 마스터 신규 공정 등록·교정·축이동 = **0**(이미 적재·건전). **컨펌:** AX-5(이관 범위)·AX-6(레이플랫). 자재명 코팅(공정) 흡수 자재 §5는 다음 회차.

---

## 후속 회차 주의 (전 축)

1. **추정 0** — 권위 침묵분은 가설+컨펌ID 분리.
2. **라이브 행수 진화** — ⑤공정 84→102·②사이즈 510→520. 후속 진단 착수 시 **라이브 재실측 필수**(stale 위험).
3. **자재 축이동 수신** — ②(29행)·print_side(14행)·⑤(코팅)·③(잉크색 AX-1)이 자재 보드 라우팅의 목적지. 이 4축 진단 시 수신분 정합 필요.
4. **삼중 바인딩 인용**(`schema-design-intent-map §3`).
