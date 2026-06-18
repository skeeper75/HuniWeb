# Size Dedup Report — 사이즈 중복·축 혼동·비규격 정합 (요구 7)

> **Phase 2 — hpq-price-chain-inspector** · 2026-06-18 · 라이브 읽기전용 실측.
> 검사: ① t_siz_sizes 동의어 중복(동일 규격·작업사이즈 siz_cd 중복) ② siz_cd 이산축 ↔ siz_width/siz_height 구간축 혼동 ③ 비규격(nonspec) 속성 정합. [[dbmap-area-matrix-wh-dimension]] 정합.
> 파일럿 3상품군 중심 + 전역 동의어 스캔.

---

## 1. 동의어 중복 (전역 스캔)

| siz_nm | 중복 siz_cd | cut_w/h | impos | del_yn | 판정 |
|--------|-------------|---------|:--:|:--:|------|
| 165x115mm(10장) | **SIZ_000104 · SIZ_000105** | 둘 다 165.00/115.00 | 둘 다 N | 둘 다 N | ⚠️ 진짜 동의어 중복 (이름·규격·impos·del 완전 동일) |

- **증상:** del_yn='N'(활성) 사이즈 중 이름·cut_width·cut_height·impos_yn이 전부 동일한 siz_cd가 2개 등록. 어느 한쪽이 가격행에 참조되면 다른 쪽은 고아, 둘 다 참조되면 가격 분기 혼선.
- **권위:** 동일 규격·작업사이즈는 단일 siz_cd. 둘 중 하나는 use_yn=N 또는 del 처리 대상.
- **재현 SQL:**
  ```sql
  SELECT siz_nm, string_agg(siz_cd,',') FROM t_siz_sizes WHERE del_yn='N'
  GROUP BY siz_nm HAVING count(*)>1;  -- 165x115mm(10장): SIZ_000104,SIZ_000105
  ```
- **파일럿 영향:** **없음** — SIZ_000104/105는 엽서·현수막·아크릴 어느 comp(component_prices)에서도 siz_cd/plt_siz_cd로 참조되지 않음(가격사슬 밖).
  ```sql
  SELECT DISTINCT comp_cd FROM t_prc_component_prices
  WHERE siz_cd IN ('SIZ_000104','SIZ_000105') OR plt_siz_cd IN ('SIZ_000104','SIZ_000105');  -- 0행
  ```
- **심각도:** 🟡 Med(파일럿 외) — 라우팅 dbmap 사이즈축 정리([[dbmap-axis-staged-load-round22]] ②사이즈). CONFIRM: 어느 상품이 어느 코드를 쓰는지 확인 후 잉여 코드 use_yn=N.

> 전역 동의어 중복은 이 1건뿐(del_yn='N' 기준). 라이브 사이즈축은 대체로 정리됨(round-22 ② 사이즈 가역0 종단과 정합).

---

## 2. 이산축(siz_cd) ↔ 구간축(siz_width/siz_height) 혼동

각 comp가 한 사이즈 의미를 **하나의 축으로만** 표현하는지(이산 siz_cd 또는 구간 sw/sh) 검사. 같은 comp가 두 축을 섞으면 혼동.

| comp_cd | 사이즈 표현축 | 권위 의도 | 판정 |
|---------|-------------|----------|:--:|
| COMP_PAPER (엽서) | siz_cd(이산) | 사이즈 옵션명 이산 | ✅ |
| COMP_COAT_MATTE (엽서) | siz_cd(이산) | 사이즈 이산 | ✅ |
| COMP_PRINT_DIGITAL_S1 (엽서) | **plt_siz_cd**(이산, 출력판형) | 국4절 판형 | ✅ (판형=plt, 작업사이즈와 별 축) |
| COMP_PRINT_DIGITAL_S2 (엽서) | **siz_cd**(이산) | 3절 판형 | ✅ (단, S1=plt/S2=siz 같은 값 이중키 → D-5 CONFIRM, 본 보드 §3 참조) |
| COMP_POSTER_BANNER_NORMAL (현수막) | siz_width+siz_height(구간) | 가로(열)×세로(행) 면적매트릭스 | ✅ |
| COMP_ACRYL_CLEAR3T (아크릴) | siz_width+siz_height(구간) + mat_cd | 가로×세로 면적+두께 | ✅ |

- **혼동 comp 0건:** 한 comp가 siz_cd와 siz_width/height를 **동시** 사용하는 경우 없음.
  ```sql
  SELECT comp_cd FROM t_prc_price_components
  WHERE use_dims::text LIKE '%siz_cd%' AND (use_dims::text LIKE '%siz_width%' OR use_dims::text LIKE '%siz_height%');  -- 0행
  ```
- **상품 단위 축 분리 정합:** 엽서(이산 siz_cd/plt_siz_cd) vs 현수막·아크릴(구간 sw/sh) — 상품군별 단일 축. 같은 상품이 두 축으로 가격되는 혼동 없음. [[dbmap-area-matrix-wh-dimension]] 신안(면적=siz_width/height 구간, 고정/규격가=siz_cd 이산) 정합.

### 2.1 ⚠️ D-5 재기록 (이산축 이중키 — 사이즈 관점)

- DIGITAL_S1은 SIZ_000077/SIZ_000499를 `plt_siz_cd`로, DIGITAL_S2는 **같은 두 값**을 `siz_cd`로 사용. 이는 "축 혼동"이 아니라 국4절(S1·plt 경로)/3절(S2·siz 경로) **판형 분기**(authority-gap 3절vs국4절). 단가 다름(국4절 3500 / 3절 5000) → 정당한 분기. 단 selections 이중 제공 시 이중합산(D-5 CONFIRM, defect-board §2 참조).
- **사이즈 등록 메모:** SIZ_000077(300x625)·SIZ_000499(316x467) 모두 impos_yn=Y = 출력판형(전지/임포지션) 사이즈. 작업사이즈가 아니라 판형이므로 plt_siz_cd 용도 정당([[dbmap-platesize-is-output-paper]] 정합).

---

## 3. 비규격(nonspec) 속성 정합

- **t_siz_sizes에 nonspec_* 컬럼 부재** — 실제 컬럼: siz_cd, siz_nm, work_width/height, cut_width/height, margin_*, impos_yn, use_yn, note, del_yn, tags. 비규격 가로/세로 증가단위는 **t_prc_component_prices의 nonspec_* 가 아니라** 면적매트릭스 구간(siz_width/siz_height '이하' 상한 + off-grid ceiling)로 흡수됨([[dbmap-area-matrix-wh-dimension]]: nonspec_* 증가단위는 신모델 DDL 제안분, 라이브 미적재).
- **아크릴 nonspec 증가단위:** authority-gap(권위 공란) — `아크릴`/마스터에 incr 미명시. 가격축 아님(입력 step 검증용). 라이브 comp에 nonspec 차원 미사용 → 정합(불일치 없음).
- **현수막 면적 off-grid:** COMP_POSTER_BANNER_NORMAL 폭 17구간(900~5000)·높이 5구간(900~1750) sparse 그리드. 비규격 주문값은 엔진 '이하 상한 ceiling'(P3-4) 또는 최대초과 ERR_ABOVE_MAX(P3-5)로 처리 — nonspec 별 속성 불요. 권위 §2.3 off-grid ceiling 정합.

---

## 4. 요약

| 검사축 | 결과 | 결함 |
|--------|------|:--:|
| 동의어 중복(전역) | 1건(SIZ_000104/105·파일럿 외) | 🟡 §1 (CONFIRM) |
| 이산↔구간 축 혼동(comp 단위) | 0건 | ✅ |
| 상품 단위 두 축 가격 | 0건(상품군별 단일 축) | ✅ |
| 판형 이산 이중키(S1/S2) | 판형 분기 정당, 이중합산 위험만 | ⚠️ D-5(CONFIRM) |
| nonspec 속성 정합 | 라이브 미사용·권위 공란과 정합 | ✅ |

> **결론:** 파일럿 3상품군의 사이즈축은 깨끗하다 — 이산/구간 혼동 0, 상품 단위 단일 축. 전역 동의어 중복 1건(SIZ_000104/105)은 파일럿 가격사슬 밖이라 견적 영향 없으나 사이즈축 위생상 정리 후보(CONFIRM). 면적매트릭스(현수막·아크릴)는 siz_width/siz_height 구간축으로 [[dbmap-area-matrix-wh-dimension]] 신안과 완전 정합.
