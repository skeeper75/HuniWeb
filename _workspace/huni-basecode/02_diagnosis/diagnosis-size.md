# 진단 보드 — ② 사이즈 (`t_siz_sizes`) 🟡

> **하네스** hbg Phase 2 진단가 · 2차 회차. **작성** 2026-06-18. 라이브 읽기전용 SELECT(2026-06-18).
> **기준선:** `01_authority/axis-authority-size.md`. **결론: 색 오염 잔존 2행(가격 0참조·교정 가능) + round-23 구간차원 모델 라이브 확정 + nonspec data-gap. 면적/형상 좌표는 대부분 컨펌(기계적 삭제 금지).**

---

## 0. 라이브 실측 (C-SIZ-2 해소)

```
SELECT count(*) FROM t_siz_sizes;                                 -- 520
information_schema: t_siz_sizes 에 siz_width/siz_height 컬럼?     -- 없음 (work_width/cut_width만)
information_schema: t_prc_component_prices 에 siz_width/height?   -- 있음
SELECT count(*) FILTER (WHERE siz_width IS NOT NULL) ... t_prc_component_prices;  -- 922 / 7293
SELECT impos_yn, count(*) ...;  -- N 505 / Y 15
SELECT del_yn, count(*) ...;    -- N 455 / Y 65
```

| 지표 | 라이브 | 정답 사전 인용 | 판정 |
|------|--------|----------------|------|
| 행수 | **520** | 500(intent §0)/510(01 §2) | +10~20 진화(round-23 스티커 SIZ_000518/519·반칼 520 채번 반영) |
| siz_width/siz_height 위치 | **`t_prc_component_prices`만**(siz 마스터엔 없음) | round-23 신안(AX-3 후속) | ✅ **구간차원 모델 라이브 확정** — 좌표 siz 채번 폐기·width/height는 가격 comp 차원 |
| siz_width 채움 | 922행 / cp 총 7293 | — | round-23 면적매트릭스 COMMIT 반영(이전 0) |
| impos_yn=Y | **15** | 79(01 §0) | 진화(round-23 신규 siz는 impos=N·완성행만 Y) |
| del_yn=Y | **65** | — | 소프트삭제 65행(폐기 siz) |

> **C-SIZ-2 해소:** 행수 권위=라이브 520. round-23 신안([[dbmap-area-matrix-wh-dimension]]) **라이브 COMMIT 확정** — `siz_width/siz_height`는 사이즈 마스터가 아니라 `t_prc_component_prices`의 가격 구간 차원(use_dims). AX-3 후속 가설이 라이브로 입증됨. 진단 기준=현재 라이브 모델.

---

## 1. 4-way 대조

| 항목 | ①권위 | ②라이브 | ③역공학(rpmeta) | ④경쟁사 |
|------|-------|---------|-----------------|---------|
| 사이즈축 = 물리치수만 | work/cut 이중축. 색·형상·수량·출력판형 인코딩 금지(OM-1·§2) | 색 인코딩 2행 잔존·형상+EA 30행·면적은 cp 구간차원으로 이동 | vessel-quantity-size-pricing: 이산 면적매트릭스 셀 / vessel-shape-axis V-12: 형상=별축(SHAPE) | GAP-SIZ-1 WowPress nonspec_*·GAP-SIZ-2(V-12) RP Shape enum |
| nonspec 비규격 | nonspec_* 범위=입력UX·가격=면적매트릭스(AX-3) | **nonspec_* 컬럼 실재·25/275만 채움**(nonspec_yn 구동) | OM-3 입력UX≠가격격자 | GAP-SIZ-1 **data-gap**(그릇 있음·미채움) |
| 형상↔칼틀 | 칼틀 물리존재→siz 1:1(Q7)·규격형→공정 param(§2.1) | 정사각/원형/하트 30행(EA 수량 동반) | V-12 형상 전용 슬롯 3-레벨 0건 → vessel-gap | GAP-SIZ-2 RP shape_info enum |

---

## 2. 결함 전수 보드

| # | 현재값 | 정답 | 원인유형 | 결함종류 | 라우팅 | 컨펌 |
|---|--------|------|----------|----------|--------|------|
| SZ-1 | SIZ_000104 "화이트165x115mm(10장)"·SIZ_000105 "블랙…" (del_yn='N') | siz=165x115만. 색=④자재 본체색/옵션·수량(10장)=bundle | ⓐ v03(카드봉투 OM-1 대표 위반) + ⓓ 코드도메인(색·수량이 siz_nm에) | 오염 | **축이동**(색→옵션/자재·수량→bundle) + siz 정규화. **가격 cp 0참조=무비용** | — (1차 material §2 카드봉투와 동일 케이스·가격 안전) |
| SZ-2 | 정사각/원형/하트 + EA 30행(예 SIZ_000212 "정사각10x10mm(8EA)") | 칼틀 물리존재(합판도무송/아크릴 형상)면 siz_cd 1:1 정당 / EA(판걸이/조각수)는 siz_nm에 부수보존만(앱 계산) | (대부분 정당) — 칼틀형 siz는 §2.1 분기상 siz 유지 | (대부분 정상) | **판정불가/정상 혼재** — 칼틀존재 여부 상품별 미실측 | **판정불가**(아래 §3) |
| SZ-3 | nonspec_* 25/275 채움 | 비규격 상품(실사/현수막)은 nonspec_* 범위 채워야(입력UX) | ⓒ data-gap(그릇 있음·미적재) | 누락 | **신규 채움**(사이즈 축 확장 시·자재 아님) | GAP-SIZ-1(설계가/확장 트랙) |
| SZ-4(인용) | 굿즈파우치 폰기종/사이즈등급 size 적재(AX-2) | 치수형=size 유지·옵션형=CPQ option | ⓐ v03 | (round-22 ② CORRECT 반증·가역0) | **기계적 삭제 금지** — round-22 ② 종단(가역0·가격종속) | AX-2(인용·재진단 금지) |

---

## 3. 판정불가 + 추가관측 (정직 분류)

| ID | 막힌 진단 | 필요한 추가 관측 |
|----|-----------|------------------|
| **SZ-2 형상+EA siz 30행** | 정사각/원형/하트 siz가 **칼틀 물리존재(정당 siz 1:1)** 인지 **규격형(공정 param이어야)** 인지 구별 불가. EA(8EA/6EA)가 판걸이수(앱계산·부수보존 정당)인지 조각수 오염인지도 상품별 칼틀 매칭 필요 | 상품별 t_prd_product_sizes 연결 + 합판도무송/아크릴 칼틀 여부(Q7 분기) 실측. round-3 G-AC·합판도무송 칼틀 1:1 인용 가능 — 다음 회차 전수 |

---

## 4. ★FK 위상 / 가격사슬 안전 [HARD]

| 사실(라이브 실측) | 함의 |
|-------------------|------|
| **색 오염 siz(SIZ_000104/105) component_prices 참조 = 0** | **SZ-1 교정 무비용** — 색→옵션 축이동·siz 정규화가 가격행 파손 없음 |
| `t_prc_component_prices.siz_cd` = **ON DELETE CASCADE** FK | 가격 묶인 siz(round-22 ② 116siz 2,601행)는 **삭제 시 가격 전손** → 기계적 삭제 절대 금지(AX-2·round-22 ② 인용) |
| round-23 siz_width/height = cp 구간차원(922행) | 면적매트릭스 가격은 좌표 siz 채번이 아니라 **comp use_dims** — siz 마스터 행수 증가 없이 가격 표현(좌표 채번 폐기 확정) |

---

## 5. dbmap 인용 (재진단 금지)

- **round-22 ②사이즈** = 라이브 가역 0(component_prices 116siz 2,601행 CASCADE·전부 가격종속·size↔option 경계/판형혼동 0건 CORRECT 반증) — **종단 완료** 인용.
- **round-23** siz_width/height 구간차원 라이브 COMMIT([[dbmap-area-matrix-wh-dimension]]) — 라이브 재확인 종결(siz 마스터엔 width/height 없음·cp에 922행).
- **round-13** 실사 size 매트릭스 CORRECT 반증 인용 — 좌표 siz 재모델 불요.

---

## del_yn / use_yn 권위 적용

- del_yn='Y' 65행 = 이미 소프트삭제된 폐기 siz(조회 차단). 신규 정리 라우팅 0(이미 처리).
- **SZ-1 색오염 2행 = del_yn='N' 활성** → 교정 시 색/수량 축이동 후 siz 정규화. 만약 중복 siz면 del_yn='Y' 소프트삭제([[dbmap-del-yn-soft-delete-authority]]). 단 165x115 치수 자체는 정당 siz로 보존.
