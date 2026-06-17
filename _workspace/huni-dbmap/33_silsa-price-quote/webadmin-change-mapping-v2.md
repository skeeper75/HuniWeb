# webadmin 변경 추적 v2 — 사이즈 가로/세로 구간 단가차원 + U1/A안 대체 판정 — round-23 Track A

> **작성** 2026-06-17 · round-23 Track A (dbm-schema-change-tracking / round-14 모드) · v1(`webadmin-change-mapping.md`) 후속.
> **베이스라인 → HEAD:** v1 분석 시점 `b85e376`(11차원) → HEAD `ae3b0a3`(2026-06-17 21:06). 신규 = sql/30·32·33 + pricing.py TIER 모델 + 시뮬레이터 전용 페이지.
> **권위·안전:** webadmin = read-only oracle(수정 0). DB 쓰기 0. 라이브 read-only psql 실측(2026-06-17). "컬럼 존재 ≠ 적용 완료"(DDL/백필 분리).

---

## 0. 핵심 5줄 (결론 먼저)

1. **가로/세로 구간 단가차원 = DDL만 적용, 백필 0 (구조 선언·데이터 미적용).** `t_prc_component_prices.siz_width`/`siz_height` numeric(8,2) 실재 + 자연키 인덱스 **14차원**(…bdl_qty, **siz_width, siz_height**, min_qty + dim_vals)으로 갱신됨. 그러나 **siz_width=0행·siz_height=0행 / 4,068행** → "컬럼 존재 ≠ 적용 완료". 어느 단가행도 아직 가로/세로 구간으로 매핑 안 됨.
2. **구간 매칭 = '이하' 상한(upper-bound), min_qty와 방향 반대.** pricing.py `TIER_DIMS=(siz_width, siz_height, min_qty)`·`TIER_UPPER=(siz_width, siz_height)`. 사이즈축 = **주문값 ≤ 임계 중 최소 임계**(가장 작은 구간, 넘으면 다음 구간·전부 초과 시 `ERR_ABOVE_MAX`). min_qty = **주문값 ≥ 임계 중 최대 임계**(수량 하한). DB 코멘트도 '이하'로 정정됨(sql/33).
3. **비규격 증가단위(sql/30): `t_prd_products.nonspec_width_incr`/`nonspec_height_incr` numeric(8,2) — DDL만, 백필 0.** 비규격 가로/세로 min/max는 있는데 증가단위(off-grid step)가 누락이라 신설. 비규격 상품 = **nonspec_yn='Y' 25개**(가로/세로 min/max 보유). incr 컬럼은 아직 NULL.
4. **★U1/A안 대체 후보 발견 — 그러나 미실행.** nonspec 25상품 = **정확히 silsa/포스터사인 면적매트릭스 상품군**(아트프린트포스터·방수포스터…일반현수막·메쉬현수막 + 아크릴 14). 즉 webadmin이 **좌표 siz_cd 채번 없이 가로/세로 연속값을 구간 단가로 직접 받는 모델**을 신설. **하지만 poster comp는 여전히 siz_cd(86행)·siz_width=0** → 모델만 선언, 포스터 가격엔 미배선.
5. **시뮬레이터 = 전용 페이지로 격상(Phase 1).** 가격뷰어 ⑤ 패널 제거 → `/admin/price-simulator/` 독립 화면(상품목록+조건입력+구성요소별 리포트). sim-meta가 규격 드롭다운 + **비규격 가로/세로 min/max/incr** 반환. 엔진(evaluate_price)은 기존 재사용 — 가로/세로 구간 계산 경로 코드 완비. Phase 2(옵션→차원 변환) 예정.

---

## 1. 신규 차원 3-way 정합표

| # | 변경 | git 선언(커밋·파일:라인) | 라이브 적용(DDL / 백필) | 우리 산출 영향 | 심각도 |
|---|------|--------------------------|--------------------------|----------------|--------|
| V1 | **사이즈가로/세로 단가차원** `siz_width`·`siz_height` | `98aa2de`·`b16447f` · sql/32:7-14 (ADD COLUMN numeric(8,2) + 자연키 14차원 재생성) | ✅ DDL 적용(컬럼·인덱스 14차원 실측) · ⚠️ **백필 0행**(sw=0·sh=0 / 4,068) | **U1(좌표 siz 106 채번) 대체 후보** — 좌표 대신 연속 가로/세로 구간. 단 미배선 | MAJOR |
| V2 | **구간 방향 '이상'→'이하' 정정** | `2b6be90` · sql/33:5-6 (COMMENT 정정) + pricing.py `TIER_UPPER` | ✅ 라이브 코멘트 '사이즈가로(이하)'·'세로(이하)' 실측 | 면적매트릭스 단가 의미 = "이 크기 이하면 이 단가" 상한 구간 | MAJOR |
| V3 | **비규격 증가단위** `nonspec_width_incr`·`nonspec_height_incr` | `e0ef85f` · sql/30:6-9 (ADD COLUMN numeric(8,2), products) | ✅ DDL · ⚠️ **백필 0행**(min은 25상품 보유) | off-grid 증가분 계산 입력 — 우리 ceiling/런타임 보간 모델과 정합 | MAJOR |
| V4 | **시뮬레이터 전용 페이지(Phase 1)** | `a04e709`·`ae3b0a3` · price_views.py(price_simulator·price_sim_products)·urls.py:38-41·price_simulator.html | 코드 적용(URL `/admin/price-simulator/`·sim-meta 비규격 min/max/incr 반환). 가격뷰어 ⑤ 패널 제거 실측 | 견적 시뮬 경로 = 독립 화면. evaluate_price 무변경(재사용) | MAJOR(긍정) |
| V5 | **테이블 명세서 재생성** | `f2cbded` · gen_table_spec.py 산출 | 문서(table-spec) — 신규 차원 반영 | 우리가 table-spec 참조 시 14차원 최신본 사용 가능 | MINOR |

---

## 2. siz_width/siz_height 구간 매칭 의미·방향·증가단위 명세 (코드 근거)

### 2.1 티어(구간) 차원 분리 — pricing.py:37-46
```
NON_QTY_DIMS = (siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)  # 정확값 매칭
TIER_DIMS    = (siz_width, siz_height, min_qty)   # 구간(티어) — 정확매칭 아님, NON_QTY_DIMS와 배타
TIER_UPPER   = (siz_width, siz_height)            # '이하' 상한 방향. 그 외(min_qty)=‘이상’ 하한
```

### 2.2 방향 (pricing.py:141-162) — 사이즈축과 수량축이 반대
| 축 | 방향 | 적용 규칙 | NULL 의미 | 초과/미달 에러 |
|----|------|-----------|-----------|----------------|
| `siz_width`/`siz_height` | **이하(상한)** | 임계값 중 **주문값 이상인 최소 임계** 선택(= 주문 크기를 담는 가장 작은 구간; 넘으면 다음 구간) | `Infinity`(상한 무제한) | 전 임계 < 주문값 → `ERR_ABOVE_MAX`("above_max_size", 상한 초과·다음 구간 미정의) |
| `min_qty` | **이상(하한)** | 임계값 중 **주문값 이하인 최대 임계** 선택(높은 수량구간) | `0`(하한 0) | 최소 임계 > 주문값 → `ERR_BELOW_MIN`("최소 주문수량 미달") |

즉 **사이즈 = "이 크기까지 이 단가"(상한 구간), 수량 = "이 개수 이상 이 단가"(하한 구간)** — 한 단가행이 가로구간·세로구간·수량구간을 동시에 좁혀 1셀을 특정.

### 2.3 비규격 증가단위 (sql/30·V3) — off-grid step
- `nonspec_width_min/max`(주문 가능 범위) + 신설 `nonspec_width_incr`(증가단위). 예: 폭 200~1200mm, 증가단위 10mm → 주문 입력은 10 step.
- 역할 = **주문 입력 UI 검증·정규화**(연속이 아니라 step 그리드). 단가는 여전히 siz_width '이하' 구간으로 매칭. **off-grid ceiling 철학과 정합**([[dbmap-compute-in-app-db-stores-lookup]]): 앱이 입력 step·구간 선택, DB는 구간별 단가 룩업만.

---

## 3. U1(좌표 siz 106 채번)·A안 대체 여부 판정

### 3.1 라이브 실측 대조
| 항목 | 우리 round-23 결정(silsa-quote-design) | webadmin 신모델 | 라이브 상태 |
|------|----------------------------------------|-----------------|-------------|
| 사이즈 표현 | **A안: 좌표 siz_cd**(가로×세로 1조합=1 siz_cd, 106 채번) | **siz_width/siz_height 연속 구간** (좌표 코드 불요) | siz_width 백필 **0행** |
| 면적매트릭스 매칭 | component_prices.siz_cd FK 정확매칭 | siz_width≤·siz_height≤ 구간 티어매칭 | poster comp **siz_cd 86행·siz_width 0행** |
| 비규격 범위 | (좌표 격자 106) | nonspec_width/height min/max/incr | nonspec **25상품 = silsa/포스터 전군** min/max 보유 |

### 3.2 판정: **대체 후보로 실재하나 아직 미실행 — U1 보류·재검토 필요(자동 폐기 금지)**

- **webadmin은 명백히 좌표 siz를 대체하는 방향으로 움직였다.** ① 가로/세로 구간 단가차원 신설(좌표 코드 불요) ② nonspec 25상품 = 정확히 우리 silsa/포스터 면적매트릭스 상품군에 가로/세로 min/max 부여 ③ 증가단위로 off-grid step까지. **이것이 정착되면 좌표 siz_cd 106개 채번(U1)은 불필요해진다** — 가로/세로 수치를 단가행에 직접 구간으로 넣으면 됨.
- **그러나 라이브 미실행:** siz_width/siz_height 단가행 0건, poster comp 여전히 siz_cd 86행, incr 백필 0. **선언만, 미적용.** 따라서 U1을 **지금 폐기하면 안 됨**(아직 신모델로 적재된 게 없어 가격 공백).
- **권고(결정은 인간):** **U1(좌표 siz 채번) 보류 + silsa 단가 적재 모델을 siz_width/siz_height 구간으로 재설계 검토.** 근거 = ① webadmin이 좌표 모델을 떠났음(향후 좌표 siz 채번은 webadmin 방향과 역행) ② 가로/세로 구간이 면적매트릭스의 [가로]×[세로] 헤더와 1:1 자연 대응(좌표 코드 중간단계 제거 = 더 정규화) ③ off-grid를 incr로 표준 처리. **단 webadmin이 백필을 안 한 상태라, 우리가 먼저 siz_width/height 구간으로 silsa 단가를 적재하면 webadmin 신모델의 첫 실데이터가 됨**(개발자 협업·재적재 가드 확인 필요).
- **A안(siz_cd) 자체는 여전히 라이브 유효 선례**(현 poster 86행이 siz_cd)지만, **신모델 방향과 충돌** → silsa-quote-design §1(A안 확정)은 **MAJOR stale 후보**. 재판정 = "좌표 siz_cd(현행·미래 역행) vs siz_width/height 구간(webadmin 미래·미실행)".

---

## 4. 시뮬레이터 / evaluate_price 영향

| 항목 | 상태 | 근거 |
|------|------|------|
| 시뮬레이터 위치 | 가격뷰어 ⑤ → **전용 페이지 `/admin/price-simulator/`** | urls.py:38-41·a04e709·price_viewer.html:227 패널 제거 |
| 비규격 입력 | sim-meta가 규격 드롭다운 + 비규격 가로/세로 min/max/incr 반환 | a04e709 커밋·price_sim_meta 확장 |
| 엔진 가로/세로 계산 | ✅ **코드 완비**(TIER 매칭·ERR_ABOVE_MAX) — evaluate_price 무변경 재사용 | pricing.py:141-174 |
| 실 계산 가능 | ⚠️ **데이터 0** — siz_width 단가행 0건이라 가로/세로 구간 매칭은 코드만 작동, 매칭될 행 없음 | 백필 0행 |
| Phase 2 | 예정(옵션그룹/추가템플릿→차원 변환·후가공 드릴다운→dim_vals) | a04e709 커밋 본문 |

**판정: 엔진은 가로/세로 구간을 계산할 준비 완료(코드). 막힌 건 데이터 — siz_width/height 단가행이 0이라 실 견적엔 아직 기여 못 함.** silsa 단가를 가로/세로 구간으로 적재하면 즉시 견적 산출 가능.

---

## 5. stale 영향 + 게이트 인계

### 5.1 v1 대비 추가 stale
| 우리 산출 | 추가 stale | 갱신 방향 | 심각도 |
|-----------|-----------|-----------|--------|
| `silsa-quote-design.md` §1 (A안 좌표 siz 확정·U1 106 채번) | webadmin이 좌표 모델 이탈 → siz_width/height 구간 신설 | A안 확정을 "재검토 — siz_width/height 구간 대안 출현(미실행)"으로·U1 보류 | MAJOR |
| `00_schema/price-engine-ddl.md` (v1서 11차원 갱신 권고) | 자연키 **14차원**(siz_width/height 추가)·티어 차원 개념(이하/이상 방향) | 14차원 + TIER_DIMS/TIER_UPPER 방향 명세 추가 | MAJOR |
| `silsa-dimension-analysis.md` (면적매트릭스 siz_cd 좌표 분해) | 가로/세로 구간 대안 미반영 | 두 모델 병기(좌표 vs 구간)·라이브 미실행 명기 | MAJOR |

### 5.2 게이트 인계 (dbm-validator W1~W6)
- W1 베이스라인: `b85e376`(v1·11차원) → HEAD `ae3b0a3`. sql/30·32·33 미존재 시점 교차검증.
- W2 변경분류: sql/30·32·33 + commit 98aa2de/2b6be90/b16447f/e0ef85f/a04e709/ae3b0a3/f2cbded 전부 §1 분류(해시 실재).
- W3·W5 DDL/백필 분리: siz_width/height·nonspec_incr 전부 **DDL 적용·백필 0** 정직 표기(컬럼 존재≠적용).
- W4 영향: U1/A안·price-engine-ddl·silsa 산출 전수.
- W6 갱신 라우팅: §3 권고가 HEAD 스키마(14차원·nonspec 25상품 min/max)와 정합·기존 poster siz_cd 86행 무손상(폐기 아닌 보류).

**산출 한정:** 추적·영향·대체판정까지. U1 폐기/신모델 재설계·DB 적재·webadmin 수정은 별도(인간 승인).
