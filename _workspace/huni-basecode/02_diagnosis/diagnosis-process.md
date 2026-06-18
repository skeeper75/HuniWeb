# 진단 보드 — ⑤ 공정 (`t_proc_processes`) 🟢→🟡

> **하네스** hbg Phase 2 진단가 · 2차 회차. **작성** 2026-06-18. 라이브 읽기전용 SELECT(2026-06-18).
> **기준선:** `01_authority/axis-authority-process.md`. **결론: family 구조 정상·열재단 PROC_000084 실재(C-PROC-1 해소). 결함은 param 선택값 미적재(data-gap)이지 마스터 오염·그릇 부재 아님.**
> **[B4 정정]** param 선택값 슬롯 = **기존 `t_prd_product_option_items.dtl_opt` 실재**(라이브 6행 사용) → ref_param_json 신설 철회·vessel-gap→data-gap 격하.

---

## 0. 라이브 실측 (C-PROC-1 해소)

```
SELECT count(*), max(proc_cd) FROM t_proc_processes;   -- 102, PROC_000102
SELECT ... WHERE proc_cd='PROC_000084';                -- 열재단 실재 (del_yn=N use_yn=Y)
```

| 지표 | 라이브 | 정답 사전 인용 | 판정 |
|------|--------|----------------|------|
| 행수 | **102** (MAX PROC_000102) | 83(intent §0)/84(01 §0) | **진화 +18** — round-22 ⑤·round-23 신규 공정 적재 |
| PROC_000084 열재단 | **실재** (del_yn='N'·use_yn='Y'·upr 없음=family head) | 스냅샷 B에만(C-PROC-1) | ✅ **C-PROC-1 해소: 열재단 라이브 실재 확정**. 83 vs 84 논쟁 종결(이미 102) |

### family head 전수 (정답 사전 §1과 1:1)
| family | head | 자식 | 정답 일치 |
|--------|------|------|:--:|
| 인쇄 | PROC_000001 | 003 옵셋·004 디지털·005 실크·006 실사 | ✅ |
| 별색 | PROC_000007 (clr_cd 컬럼 없음=공정) | 008 화이트·009 클리어·010 핑크·011 금색·012 은색 | ✅ |
| 박 | PROC_000033 | — | ✅ |
| 제본 | PROC_000017 | …025 레이플랫(활성) | ✅(025 AX-6 잔존) |
| 완칼/반칼/스티커완칼 | 053·054·055 | — | ✅ |

### 신규 행 085~102 = per-product 공정 인스턴스 (정상 진화)
PROC_000086 미싱(upr PROC_000030)·088 봉제(upr 080)·089 부착(upr 081)·092 타공(upr 079)·095 에폭시(upr 083)·096 열재단(upr **PROC_000084**)·097 UV(upr 002)·098~102 캘린더/싸바리 제본(upr 017). **전건 upr_proc_cd로 family head 참조** = self-ref 위상 건전. round-22 ⑤ 봉제/부착·round-23 신규 공정 적재 흔적.

---

## 1. 4-way 대조

| 항목 | ①권위 | ②라이브 | ③역공학(rpmeta) | ④경쟁사 |
|------|-------|---------|-----------------|---------|
| self-ref family | 인쇄/별색/박/제본 부모→자식(§1) | **family head·자식 전건 정합**(upr_proc_cd 건전) | process-recipe-tree §1·§3 = 라이브와 동형 | (제외) CIP4 Process+Parameter 흡수·능가 |
| 별색=공정(clr_cd=NULL) | PROC_000007 family·도수 아님(HARD) | **별색 008~012 공정 family·도수칸 혼입 0**(③도수 진단과 정합) | vessel-print-method-recipe | RP `PRT_WHT`·CIP4 Spot 분리 동형 |
| 공정 param 선택값 [→§2 PR-1 B4 정정] | prcs_dtl_opt=스키마·선택값=**기존 `t_prd_product_option_items.dtl_opt`**(라이브 6행 실사용) | prcs_dtl_opt 스키마 실재(UV 변형·오시·반칼) + **dtl_opt 인스턴스 슬롯 실재**(`{"유형":"봉미싱(7cm)"}`·미적재 지배) | V-1이 dtl_opt 미관측 → vessel-gap 오판(B4 data-gap 격하) | GAP-PROC-1 — 후니 dtl_opt 슬롯 **실재**(빈칸 아님·data-gap) |
| 열재단 PROC_000084 | 순수공정(자재 없음)·스냅샷 차 | **실재 확정** | — | — |

### prcs_dtl_opt 스키마 라이브 실측 (param 모델 건전)
- PROC_000002 UV: `{"변형": enum["일반","배면양면","풀빼다","투명테두리","단면"]}`
- PROC_000029 오시: `{"줄수": integer 0~3}`
- PROC_000053 완칼: `{"모양": string}` / PROC_000054 반칼: `{"모양","조각수": min 1}`
→ **param=1공정행+스키마**(OM-7 비대화 회피 정답 모델이 라이브에 살아있음). 구수마다 별 proc 신설 = **없음**(✅).

---

## 2. 결함 전수 보드

| # | 현재값 | 정답 | 원인유형 | 결함종류 | 라우팅 | 컨펌 |
|---|--------|------|----------|----------|--------|------|
| — | family·별색 분리·열재단·param 스키마 | — | — | — | **마스터 오염 0**(🟢) | — |
| PR-1 [B4 정정] | 공정 param **선택값**: 기존 `t_prd_product_option_items.dtl_opt` jsonb에 저장(라이브 6행 실사용·`{"유형":"봉미싱(7cm)","폭":7.0}`) | **dtl_opt 재사용**(UV 변형 `{"변형":"풀빼다"}`도 동형 jsonb·담을 수 있음) | **ⓒ data-gap**(그릇 실재·UV 변형 미적재) ← [정정 ⓑ→ⓒ] | 누락(미적재) | **미적재 채움**(dtl_opt 이관). **신규 mint 0**(ref_param_json 신설 철회) | AX-5(이관 범위) |
| PR-2 | PROC_000025 레이플랫 del_yn='N'·use_yn='Y'(활성) | 정답 사전 §1=미운영 마스터(Q10·AX-6 가설) | 가설 충돌(권위=미운영 vs 라이브=활성) | 판정불가 | **판정불가**(아래 §3) | **AX-6**(미운영 마스터인지 라이브 활성이 정상인지) |

> **★print_side UV 오적재(63행)는 본 공정 마스터의 결함이 아니라 인쇄옵션 축 결함**(`diagnosis-printoption.md` PO-1). 단 교정 목적지(UV 변형 param)가 공정 PROC_000002 인스턴스이므로 **두 축이 PR-1에서 합류** — 변형 선택값을 적을 슬롯은 **신설 컬럼이 아니라 기존 `t_prd_product_option_items.dtl_opt`**(B4 정정·라이브 6행 실사용 입증).

---

## 3. 판정불가 + 추가관측 (정직 분류)

| ID | 막힌 진단 | 필요한 추가 관측 |
|----|-----------|------------------|
| **PR-2 레이플랫 PROC_000025** | 권위 사전은 "미운영 마스터(Q10)"라 했으나 라이브 del_yn='N'·use_yn='Y' 활성. 미운영인데 SEED로 남은 정상 잔존인지, 실제 운영 공정인지 판정 불가 | 레이플랫 사용 상품(t_prd_product_processes에 PROC_000025 연결 상품) 실측 + 실무진 운영 여부 컨펌(AX-6). 연결 0이면 미운영 SEED(어긋남 아님)·연결>0이면 운영(정상) |

---

## 4. ★공정 축 그릇 빈칸 (모델 부재 vs 미적재 구분) [HARD]

| 빈칸 | 판정 | 정답 |
|------|------|------|
| 공정 param **선택값** 슬롯(PR-1) | **ⓒ data-gap**(그릇 실재·미적재) ← [B4 정정: vessel-gap 오판 철회]. 라이브 `t_prd_product_option_items.dtl_opt` 실재(6행 사용·`{"유형":"봉미싱(7cm)"}`) | **dtl_opt 재사용**(신규 mint 0). print_side UV값 목적지 = dtl_opt. **rpmeta V-1 vessel-gap 판정이 dtl_opt를 못 본 오류** — search-before-mint로 격하 |
| 캐스케이드 제약(자재/사이즈→공정 disable) | **빈칸 후보**(GAP-PROC-2) | t_prd_product_constraints(JSONLogic) 거의 미적재. 공정 모델 자체는 RP `disable_pcs`·WP `rst_awkjob`·JDF 흡수·능가 — 도입은 공정 축 확장 시 |

> **자재→공정 누수 교차 확인:** 1차 자재 진단 §5(자재명 코팅 흡수→④→⑤ 분해)는 라이브 미실측분으로 남음. 본 회차에서 박/코팅/UV가 공정 마스터에 정상 family로 존재함은 확인(PROC_000014~016 코팅·033 박·002 UV) → **공정 마스터로의 누수는 없고, 반대로 자재칸에 공정명이 새어있을 가능성**(1차 자재 §5)이 잔여. 다음 회차 자재 §5 전수 시 본 공정 family를 목적지 기준선으로 사용.

---

## 5. dbmap 인용 (재진단 금지)

- **round-22 ⑤공정 🟡** = 에폭시 PRD_000169 라이브 COMMIT·봉제↔부착6 경로Y·신규mint3 BLOCKED — 라이브에 봉제(088)/부착(089)/에폭시(095) 적재 확인(재진단 아님·현재 상태 인용).
- **round-23** 별색 dedup(형제 9 comp use_yn=N·정본 WHITE_S1)·디지털 가격엔진 공정사슬·캘린더 제본(098~102) — 라이브 신규 행으로 반영 확인.
- **C-PROC-1** 83 vs 84 = **라이브 102로 종결**(열재단 PROC_000084 실재).

---

## del_yn / use_yn 권위 적용

- 공정 마스터 102행 전건 del_yn='N'·use_yn='Y'(소프트삭제 0). 신규 정리 라우팅 0.
- PR-2 레이플랫은 del_yn='N'(활성) — 미운영 확정 시 del_yn='Y' 소프트삭제 후보지만 AX-6 컨펌 전 보류([[dbmap-del-yn-soft-delete-authority]]).
