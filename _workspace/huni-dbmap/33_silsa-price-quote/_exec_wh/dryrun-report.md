# 신안(siz_width/siz_height 구간) — 롤백전용 라이브 DRY-RUN 리포트 (R1~R6)

> 실행 2026-06-17 · Railway `railway` read-only psql · `BEGIN … ROLLBACK`(COMMIT 0). 비밀값 비노출.
> 생성자(load-builder) 산출 — GO 판정은 dbm-validator(독립). 입력 = poster-sign-import.xlsx(가격표 verbatim) + pricing.py TIER 매칭(TIER_DIMS/TIER_UPPER·match_component).

---

## R1 — 영향행수 (PASS1·apply.sql 순서)

```
V1  INSERT 667   면적매트릭스 단가행(가격표 [가로×세로] verbatim → siz_width/siz_height)
V1b UPDATE 17    라이브 siz_cd 매트릭스 17행 → siz_width/siz_height 전환(값 불변)
V2  UPDATE 13    본체 13 면적 comp use_dims (siz_cd 포함) → ["siz_width","siz_height"]
V3  UPDATE 13    13 면적상품 nonspec_width_incr/height_incr 백필
```
- 합계 INSERT 667 · UPDATE 43(17+13+13). 단가행 = 가격표 verbatim(날조 0). 좌표 siz 채번 0.
- 가격표 셀 언피벗 행수 = **667(GAP 시트)** + **17(라이브 siz_cd 전환)** = 684 distinct (comp,w,h) 셀. null price 0·내부 dup 0(검증).

## R2 — 멱등 2-pass delta 0

```
PASS 1: INSERT 667 · UPDATE 17 · UPDATE 13 · UPDATE 13(×each)
PASS 2: INSERT 0   · UPDATE 0  · UPDATE 0  · UPDATE 0   ← 전건 0
```
- 2회 적용 시 2nd pass 전 DML delta = **0**(NOT EXISTS 자연키 가드·"전환 전 상태"만 매칭하는 UPDATE WHERE). 멱등 입증.

## R3 — FK 고아 0

```
orphan comp_cd                    = 0   (component_prices.comp_cd → price_components)
orphan siz_cd (after conversion)  = 0   (전환 후 잔여 siz_cd 행도 부모 실재)
13 matrix comps leftover siz_cd   = 0   (V1b 전환 후 매트릭스 comp의 siz_cd 행 0)
```
- comp_cd 13종·prd_cd 13 부모 라이브 선존재(검증). siz_width/height는 numeric(FK 없음)·좌표 채번 불요.

## R4 — ★엔진 매트릭스 룩업 골든 재현 (TIER '이하 상한'·가격표 known값 대조)

엔진 규칙(pricing.py `match_component`): 각 축 `eligible=[t for t in tiers if t>=order]; selected=min(eligible)`(주문 크기를 담는 가장 작은 구간). 2축 교차 = [가로][세로] 매트릭스.

| 케이스 | 주문 | 매칭 구간 | 단가 | 가격표 known | 판정 |
|--------|------|----------|------|------|:--:|
| **정확 G1** | ARTPRINT 600×600 | 600×600 | 12,000 | 12,000 | ✅ |
| **정확 G2** | ARTPRINT 600×1000 | 600×1000 | 20,000 | 20,000 | ✅ |
| **off-grid ceiling G3** | ARTPRINT 700×650 | **800×800**(다음 큰 구간) | 20,000 | tier 800×800 | ✅ (엔진 내장 ceiling) |
| **above-max G4** | ARTPRINT 6000×600 (W>3000) | eligible W 없음 | — | **ERR_ABOVE_MAX** | ✅ (상한 초과 정상 거부) |

- verbatim 교차검증: ARTPRINT 600×600=12,000 · 800×800=20,000 · BANNER_NORMAL 5000×1750=72,000 — 전부 가격표 셀 그대로(날조 0).
- off-grid(G3): A안의 위젯/엔진 런타임 ceiling이 **DB 차원(siz_width/height '이하 상한')으로 흡수** — 700×650이 격자에 없어도 800×800 구간 자동 선택.

## R5 — 동시매칭(ERR_AMBIGUOUS) 무관 확인

- 본체 면적 comp는 G-D2 W1 공식분리로 **공식당 본체 1 comp** → siz_width/height 2축 구간이 1셀 특정(combos=1). 후가공(proc_cd/dim_vals)은 사이즈 차원과 직교 → 본체와 동시매칭 0. (G-D2 `_exec_gd2` 검증과 정합·신안은 본체 use_dims만 siz_cd→siz_width/height로 교체.)

## R6 — COMMIT 0 / 라이브 무변경

- 전 DRY-RUN `BEGIN…ROLLBACK`. 다회 실행 후 라이브 재측정:
```
매트릭스 comp: siz_width 행 0 · siz_cd 행 5(샘플 3 comp 사전상태)   ← 신규 미적용
nonspec incr 채워진 상품 = 0                                       ← 미백필
ARTPRINT use_dims = ["siz_cd"]                                     ← 미전환
```
→ 라이브 사전상태 그대로. **COMMIT 0·DB 무변경 입증.**

---

## 종합

- R1~R6 전건 통과(생성자 측정). **가격표 셀 667 언피벗(verbatim·날조 0)·라이브 siz_cd 17 전환·use_dims 13·nonspec 13 · 2-pass delta 0 · FK 고아 0 · 골든 매트릭스 룩업(정확·off-grid ceiling·above-max) 재현 · COMMIT 0.**
- 좌표 siz 채번 0(U1 폐기) — 신안이 off-grid를 엔진 TIER로 내장.
- BLOCKED: 아크릴 동형(Q-PR-3·라이브 부분진화 재실측 선행·별 트랙). 고정가 15는 siz_cd 유지(본 실행본 미포함).
- 실 COMMIT은 인간 승인(`apply.sh --commit`). GO 판정은 dbm-validator 독립 게이트.
