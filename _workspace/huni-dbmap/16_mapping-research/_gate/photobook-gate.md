# 포토북 — 매핑 확정 독립 게이트 (round-12 M1~M6)

> **검증자** `dbm-validator`. **작성** 2026-06-10 · **재게이트** 2026-06-10(D-PB-1 보정 후 M5만). 증거 동반 판정. DB 쓰기 0.

## 게이트 매트릭스 (재게이트 반영)

| # | 게이트 | 판정 | 핵심 증거 |
|---|--------|:----:|-----------|
| M1 | 커버리지 | **PASS** (carry-fwd) | L1 헤더 직접 카운트(38 의미컬럼+빈) |
| M2 | 권위 인용 실재 | **PASS** (carry-fwd) | 표본 7행 |
| M3 | 실무진 정합 | **PASS** (carry-fwd) | Q3/Q6/Q10/Q11/Q15 반영 |
| M4 | 오모델 부재 | **PASS** (carry-fwd) | OM 재발=CONFLICT-PB-2로 정직 적발 |
| M5 | 라이브 실측 | **PASS** (1차 FAIL→보정→재게이트) | 레더 3-way+PRD_000100 2건 보정 독립 재실측 일치 |
| M6 | 외부 갭 처분 | **PASS** (carry-fwd) | 5 갭 전부 처분+Sources |

**판정: GO** (D-PB-1 RESOLVED — M5 재게이트 PASS. M1~M4·M6은 1차 게이트 PASS carry-forward, 재검 불요)

---

## M1 커버리지 — PASS
`06_extract/photobook-l1.csv` 64 컬럼 = 파서메타 7 + **의미 38**(C1~C38, 내지/표지 블록) + 빈 컬럼 AM~BD 18 + cell_meta_json. mapping-final = C1~C38 전수 + AM~BD/범례 R15/R17 제외 사유 명기. 확정도 ✅19·🟡17·🔴0(컬럼)·CONFLICT 4 별도. **누락 0.**

## M2 권위 인용 실재 — PASS
표본(라이브 재실측):
- PRD_000100 processes=PROC_000020 PUR mand=N 재확인 ✓
- page_rule 1행·prices 0행·sets 7행 재확인 ✓(가격 미적재=적재대상 정직)
- USAGE.06 표지타입 실재 재확인 ✓(C18 귀속 보강 정확)
- MAT_000250 아트250+무광코팅=MAT_TYPE.01 종이 재확인 ✓·MAT_000251 그레이=.01 ✓
- 반제품 7행 sets / 사이즈 4 / print_options 2 → live-crosscheck 일관
- 레더 → §M5(부분실측). 날조 없으나 불완전.

## M3 실무진 정합 — PASS
- **Q3 ★**(반제품=제본 전체관점) → 표지 5 sub_prd(USAGE.06)+sets 반영 ✓
- **Q6**(1상품+에디터 템플릿) → PRD_000100 단일·editor_yn=Y 라이브 입증 ✓
- **Q10**(PUR만) → PROC_000020 연결·레이플랫 PROC_000025 코드존재·미연결 ✓
- **Q11**(표지 3종 유지) → research-gap G-5 무시 ✓
- **Q15**(기본24P+2P당) → C37/38 + page_incr=2 정합 ✓
- **Q9**(코팅=공정) → CONFLICT-PB-2로 정직 적발(§M4)

## M4 오모델 부재 — PASS
- size↔option 혼동 없음(C5 사이즈 이산 치수) · 색=siz 없음
- **OM 재발(복합표기 평면화)을 스스로 적발**: C26 `아트250+무광코팅`이 라이브에 단일 자재명(MAT_000250)으로 평면 적재됨 → CONFLICT-PB-2로 명시 + Q9 일관 위한 코팅 분리를 컨펌-Q2로 escalate. **침묵 평면화 안 함** ✓. 라이브 재실측으로 MAT_000250=.01 종이 확인(코팅 미분리 사실 정확).
- PUR mand=N→Y 보완 권고도 정직(CONFLICT-PB-4). 매핑 오모델 재발 0(적발·정직 처리).

## M5 라이브 실측 — PASS (1차 FAIL → 보정 → 재게이트)

### 재게이트(2026-06-10) — D-PB-1 보정본 독립 재실측 4기준
- **기준1 3-way 전수:** 레더 전수 재실측 = 006 .01종이 link1 · 008/173/174/175 .06가죽 link0(고아) · 186 .08실사 link6. 보정 `live-crosscheck.md §2.5`(L76) 표와 **수치 일치** ✓
- **기준2 PRD_000100 레더 2건:** `WHERE pm.prd_cd='PRD_000100' AND mat_nm~'레더'` 재실측 = MAT_000006(.01 종이 USAGE.02) + MAT_000186(.08 실사 USAGE.02) **2건 동시 연결** 확인. 보정 §2.5(L77)·§3 충돌건수(L99)·CONFLICT-PB-1(L117)·컨펌-Q1(L126) 전부 ".01+.08 2건" 반영 ✓
- **기준3 컨펌 3선택지·search-before-mint:** 컨펌-Q1(L126)=(가).06 가죽 고아행 재연결/(나).08 유지/(다).01 정리. "search-before-mint=신규 mint 불요·고아 .06 재연결" 명시 + "책자 D-BK-1과 통합 결정 가능" 병기 ✓
- **기준4 scope:** 보정이 레더 섹션(CONFLICT-PB-1·컨펌-Q1·live §1쿼리/§2.5/§3·C26 비고)에 국한, CONFLICT-PB-2(코팅 평면화)·PB-3(표지 작업사이즈)·PB-4(mand)·Q15 가격 등 무관 섹션 1차 게이트와 동일 유지 ✓

> **결론: M5 PASS 전환. D-PB-1 RESOLVED.** 보정이 3-way 실태·PRD_000100 2건 동시연결·3선택지·search-before-mint를 정확·전수·scope-한정으로 반영. (CONFLICT-PB-2 코팅 평면화는 별개 컨펌-Q2로 정직 유지 — D-PB-1 범위 외)

### 1차 게이트(FAIL) 기록 — D-PB-1 [MAJOR] (보존)
mapping-final CONFLICT-PB-1 + live-crosscheck §2.5 = "**MAT_000186 레더(화이트)=MAT_TYPE.08**, round-11 .06 가설과 불일치"로 단일 인용. **독립 재실측:**

```sql
SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd='PRD_000100' AND m.mat_nm ~ '레더';
-- PRD_000100 → MAT_000006 레더하드커버 MAT_TYPE.01 USAGE.02
-- PRD_000100 → MAT_000186 레더(화이트) MAT_TYPE.08 USAGE.02
```

**판정:**
- **포토북 PRD_000100은 레더 자재를 2개 연결**: MAT_000006(레더하드커버, **MAT_TYPE.01 종이**) + MAT_000186(레더(화이트), .08). live-crosscheck §2.5는 **MAT_000186(.08)만 언급하고 MAT_000006(.01) 링크를 누락**.
- 추가로 라이브 레더 전체는 MAT_TYPE.06 가죽 4행(MAT_000008/173~175, 고아·미연결)도 실재 — booklet D-BK-1과 동일 누락. CONFLICT-PB-1의 "Q4 가죽(.06) vs 라이브 .08" 양자택일 전제가 부정확(가죽 .06 레더 자재가 이미 존재하나 고아).
- **매핑 영향:** 컨펌-Q1(레더 .06 vs .08)의 전제 보강 필요. PRD_000100이 .01 종이 레더(MAT_000006)도 연결한다는 사실은 "레더하드커버 표지=종이로도 적재된 행 존재"를 의미 — 컨펌 시 함께 정리해야.
- **라우팅:** `dbm-domain-researcher`(포토북 시트) — CONFLICT-PB-1/컨펌-Q1 정정: "PRD_000100 레더링크=MAT_000006(.01)+MAT_000186(.08) 2건. 라이브 레더 전체=.01/.06(고아)/.08 혼재." 책자 D-BK-1과 통합 결정(컨펌-Q1이 이미 "책자 BK-4와 통합 결정 가능"이라 명시 — 통합 정정).

> 나머지 우변(PROC_000020·sets·page_rule·USAGE.06·MAT_000250=.01)은 독립 재실측 일치 — M5 FAIL은 레더 1항목 한정.

## M6 외부 갭 처분 — PASS
5 갭(G-1 CIP4 BindingIntent·G-2 레이플랫·G-3 내지 finish·G-4 가격모델·G-5 표지확장) 전부 처분(무시+사유) + Sources(CIP4 XJDF·Mixbook·Snapfish URL·round-11 재사용). 매핑수정/DDL 0. 정직.

---

## 발견 결함 요약
| ID | 심각도 | 게이트 | 상태 | 요지 |
|----|:------:|:------:|:----:|------|
| D-PB-1 | MAJOR | M5 | **RESOLVED** | 레더 CONFLICT-PB-1 부분실측(가죽 .06 누락)+PRD_000100 MAT_000006(.01) 링크 누락 → 3-way 전수+2건 동시연결+3선택지 보정 완료, 재게이트 독립 재실측 PASS |

> 매핑 우변 적재 가능. 보정으로 CONFLICT 서술 완전성 확보. (CONFLICT-PB-2 코팅 평면화는 별개 컨펌-Q2로 잔존 — D-PB-1과 무관, 인간 결정 대기)

**최종: GO** (D-PB-1 RESOLVED·재게이트 M5 PASS)
