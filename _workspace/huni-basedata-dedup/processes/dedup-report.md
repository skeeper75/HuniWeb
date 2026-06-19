# 공정 축(t_proc_processes) 4축 검수·정리 리포트 — Phase 2

생성: 2026-06-19 / 검수가: hbd-dedup-analyst / 방법론: hbd-dedup-analysis
입력: Phase 1 캐시(live.csv 102 · authority.csv 206 · index.csv 102 · _prd_bind · _price_dep)
라이브 재실측: t_proc_processes·t_prd_product_processes·t_prc_component_prices·t_prc_formula_components·t_prc_price_components·t_prd_product_option_items (read-only SELECT, 2026-06-19)

## canonical 정의

`canonical = (semantic_axis, normalized_proc_nm, 부모공정 upr_proc_cd, dtl_opt 파라미터)`
- 공정에는 proc_typ_cd 컬럼이 없다 → 의미축 핵심 = **upr_proc_cd(부모공정)**. 표시명(proc_nm)이 같아도 부모가 다르면 다른 공정(핑크·UV 사례).
- 권위 = master 260610 process-expected crosswalk(authority.csv) — 공정명당 단일 proc_cd를 product에 매핑. 자식(086~097)·016은 crosswalk에 **전무**.

## 판정 요약 — **NO-OP 아님 (정리 9 + BLOCKED 5)**

| 분류 | 건수 | 그룹 |
|---|:---:|---|
| **진짜중복(safe merge·pd=N·참조0)** | **9** | 087·088·089·091·093·094·095·096(thin mirror 8) + 097(UV 빈 자식) |
| **정당구분(false-positive 가드·keep)** | **2** | 핑크 010/036 · UV 002/016 |
| **★오적재(price-chain 단절·BLOCKED)** | **3** | 미싱 030/086 · 오시 029/090 · 타공 079/092 |
| **현황만(논리삭제)** | **1** | 025 레이플랫제본(del_yn=Y) |
| 신규적재(new-load) | 0 | — |

## 13 표시중복 그룹 — 멤버별 1:1 가드 대조 (★사이즈 교훈 반영)

라이브 실측 참조 카운트(Q2): `prd_proc(상품바인딩)·comp(component_prices)·opt(option_items ref_key)·child(자식공정)·authority(crosswalk)`

| 그룹 | 정본(rich) | 멤버(thin) | 멤버 prd/comp/opt/child/auth | 판정 |
|---|---|---|---|---|
| 반칼 | 054 (dtl·prd4·auth✓) | 087 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 봉제 | 080 (dtl·prd5·comp5·opt15) | 088 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 부착 | 081 (dtl·prd10·opt5) | 089 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 완칼 | 053 (dtl·prd3·auth✓) | 091 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 족자제작 | 082 (dtl·prd1·opt2) | 093 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 스티커완칼 | 055 (dtl·prd7) | 094 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 에폭시 | 083 (prd1·auth✓) | 095 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| 열재단 | 084 (prd2·권위note) | 096 | 0/0/0/0/✗ | ②③ **진짜중복 merge** |
| UV(자식) | 002 (dtl·prd14) | 097 | 0/0/0/0/✗ | ②③ **진짜중복 merge** (097=002의 빈 미러) |
| **UV(코팅)** | 002 root | 016 (upr=013 코팅) | 0/0/0/0/✗ | ④ **정당구분 keep** — 부모 상이(독립UV vs 코팅옵션) |
| **핑크** | 010 (upr=007 별색·comp212) | 036 (upr=033 박·comp0) | — | ④ **정당구분 keep** — 별색잉크≠박, 부모/의미축 완전 상이 |
| **미싱** | 030 (dtl·prd4·opt7) | 086 | 0/**30**/0/0/✗ | ★ **오적재 BLOCKED** — comp 30행이 자식 키·옵션은 부모 키 |
| **오시** | 029 (dtl·prd4·opt7) | 090 | 0/**50**/0/0/✗ | ★ **오적재 BLOCKED** — comp 50행이 자식 키·옵션은 부모 키 |
| **타공** | 079 (dtl·prd6·opt8) | 092 | 0/**18**/0/0/✗ | ★ **오적재 BLOCKED** — comp 18행이 자식 키·옵션은 부모 키 |

## ① 권위추출 + 표시↔실제 정합 (오적재 검출)

**3건 오적재 적발 — 가격사슬(price-chain) 단절.** 미싱/오시/타공 자식(086/090/092)은 표면상
thin mirror(빈 자식·바인딩0·authority 부재)지만, **component_prices가 자식 proc_cd를 키로**
실가격(미싱 COMP_PP_PERF_1L 5000~109000·오시 COMP_PP_CREASE 1/2/3L·타공 COMP_CUT_PERF_1H6)을 보유한다.

동시에 라이브 실측:
- option_items.ref_key1 = **부모** (PROC_000029/030/079) — 7/7/8건
- price_components.use_dims = `proc_grp:PROC_000029/030/079` (부모 그룹)
- component_prices.proc_cd = **자식** (PROC_000086/090/092)

→ 엔진 흐름이 단절: 사용자가 오시 선택 → option이 029(부모)로 해소 → 엔진이 component_prices를
WHERE proc_cd=029 조회 → **0행**(가격은 090 자식 밑). 즉 표시명(오시)↔내부 가격키(090) 불일치 =
**오적재**. 자식 단순 논리삭제 시 미싱/오시/타공 가격 98행(30+50+18) 전손. 단독 가역 교정 불가
→ **BLOCKED**(price_dependent=Y), 가격축 재배선(자식 comp의 proc_cd를 부모로 교정하거나 option을
자식으로 재배선)으로 escalate. 경로 Y(개발자 v03 재적재) 또는 dbm-price-arbiter 심의.

## ② 표시 중복 / ③ 내부값 중복 — 9 진짜중복

087·088·089·091·093·094·095·096 + 097 = thin mirror 9개. 전부 2026-06-17 00:54:46~49 일괄 INSERT·
prcs_dtl_opt 공란·note 공란·disp_seq=1·upr_proc_cd가 **같은 이름의 부모**를 가리킴·전 참조 0·
authority crosswalk 부재 = 부모의 빈 거울(내부값=빈데이터, 표시명=부모와 동일). 정본=부모(rich),
멤버=자식 논리삭제(del_yn=Y). 외부참조 0 → 무손실·CASCADE 무관.

## ④ 의미구분 보존 (false-positive 가드) — 2 정당구분

- **핑크 010/036 [1순위 가드]**: 010=별색인쇄(PROC_000007) 밑 분홍 잉크(comp_prices 212행),
  036=박(PROC_000033) 밑 분홍 박(comp 0). 부모/의미축 완전 상이 → 분홍 별색잉크 ≠ 분홍 박.
  표시명만 같다고 통합하면 가격사슬 212행 파손 + 의미왜곡. **통합 절대 금지.**
- **UV 002/016**: 002=독립 UV 공정(root·변형 enum·prd14), 016=코팅(PROC_000013) 밑 UV코팅 옵션.
  부모 상이 → 독립 UV ≠ 코팅의 UV타입. **정당구분 keep.** (016은 참조 0이나 코팅 옵션축 보존·컨펌큐.)
  ※ UV 097만 002의 빈 미러라 별개로 merge 대상.

## BLOCKED 큐 (가격종속·경로 Y/가격축 escalate)

| 코드쌍 | comp_prices(자식) | 원인 | 안전 교정 경로 |
|---|---|---|---|
| 미싱 030/086 | 30행 (COMP_PP_PERF_1L) | option→부모·price→자식 단절 | 가격축 재배선·경로 Y·dbm-price-arbiter |
| 오시 029/090 | 50행 (COMP_PP_CREASE) | 동상 | 동상 |
| 타공 079/092 | 18행 (COMP_CUT_PERF_1H6) | 동상 | 동상 |

## 컨펌 큐 (인간 승인 대상)

1. **safe merge 9건**(087·088·089·091·093·094·095·096·097 → 각 부모): apply-plan.md 명세.
   pd=N·외부참조 0 실증분. 승인 후 hbd-load-execution 위임.
2. **오적재 미싱/오시/타공 3건**: BLOCKED. 자식 086/090/092는 **논리삭제 금지**(가격행 전손).
   가격사슬 재배선(option↔price proc_cd 정렬)을 dbm-price-arbiter/경로 Y로 escalate. 본 dedup 비대상.
3. **UV 016**: 코팅 옵션축 보존 keep(참조0이나 통합 시 코팅의 UV타입 소멸). 확인.
4. **핑크 010/036·UV 002/016**: 정당구분 — 통합 금지 재확인 불요(④ 가드 확정).

## D2/D3 게이트 자기판정

- **D2(중복판정 정확성)**: ②③ 진짜중복 9건 = 멤버별 1:1 라이브 카운트로 빈 미러 확정(참조 0).
  ④ false-positive 2건 = 부모/comp 차이로 정당구분 확정 → 진짜중복으로 오승격 0. **PASS.**
  ★사이즈 교훈 반영: "11쌍 전부 진짜중복" 일괄흡수 회피 → 086/090/092는 comp_prices 보유로
  진짜중복에서 분리(오적재 BLOCKED)·016은 코팅축으로 keep. 멤버별 대조가 false-positive·오적재 가림 방지.
- **D3(정리 무손실)**: safe merge 9건 = 논리삭제(del_yn=Y)만·물리삭제 0·정본 무변경·외부참조 0(단가행/
  바인딩 보존). BLOCKED 3건은 가격행 보유로 정리 제외. **PASS.**

## 날조 0 / 추측 0 선언

모든 판정 카운트는 라이브 SELECT 실측(Q1~Q2 + comp_prices/use_dims/option_items 추적). authority
부재는 grep 실측. 추론·추정 0.
