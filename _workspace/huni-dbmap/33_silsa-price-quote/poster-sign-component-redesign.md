# 포스터/사인 가격구성요소 재설계 — siz_width/siz_height 구간 모델 (round-23)

> **작성** 2026-06-17 · round-23. **정리·설계까지 — 적재/COMMIT 안 함.** 입력 = `silsa-quote-design.md`(A안·U1/U2)·`gd2-wiring-design.md`(G-D2/U6)·`dimension-basecode-verification.md` + **pricing.py·sql/32 코드 직접 확인** + 라이브 read-only psql.
>
> **사용자 새 방향:** 좌표 siz_cd 채번(A안·106) 대신 **가로:세로 구간 매트릭스**(`siz_width`/`siz_height` '이하' 상한 구간)로 포스터/사인·아크릴 가격 연결. webadmin sql/32·pricing.py TIER 모델 신설.

---

## 0. 핵심 5줄

1. **신안(siz_width/siz_height 구간) GO — 엔진이 [가로][세로] 매트릭스를 정확히 표현(코드 입증).** pricing.py `match_component`(라인 119): siz_width·siz_height 각 축 독립 '이하 상한' 구간 룩업(주문값 ≤ 임계 중 **최소 임계**=값 담는 가장 작은 구간). 2축 동시 = 면적매트릭스. **off-grid = 다음 큰 구간 자동(ceiling 엔진 내장)** → A안의 런타임 ceiling이 DB 차원으로 흡수. NULL 상한=∞ catch-all.
2. **A안→신안 전환 권고(채번 0).** A안 = 좌표 siz 106 채번 + 687 단가행. 신안 = **siz 채번 0** + 687 단가행(siz_width/siz_height 직접 수치). siz 마스터 비대 회피·실무진 입력 단순(가로/세로 수치 입력)·off-grid 엔진 처리. 라이브 컬럼 실재(numeric(8,2)·자연키 14컬럼 포함)·단가행 0(백필 대기).
3. **포스터/사인 구성요소 구성:** 본체 13 면적 comp use_dims=`["siz_width","siz_height","min_qty"]`(siz_cd 제거)·687 구간 단가행(가로 임계 18종×세로 7종 블록별). 고정가 15 = 규격 siz_cd 유지(A시리즈 구간 아님). 후가공/별색 = G-D2 그대로(proc_cd/dim_vals). off-grid = t_prd_products.nonspec_*(증가단위).
4. **아크릴 동형 GO.** 아크릴(31_acrylic-price-link)도 가로:세로 면적매트릭스 → 같은 siz_width/siz_height 구간 모델로 통일 가능. 좌표 siz(아크릴 196 distinct·105 NONE) 채번 불요화. 동형 일반화 = 모든 면적매트릭스 상품군(실사·현수막·아크릴) 단일 차원 모델.
5. **U1 폐기·U2 재구성·G-D2 무영향(본체 use_dims만 변경).** U1(좌표 siz 106 채번) 불요 → 폐기. U2(면적단가) = siz_cd 행 → siz_width/siz_height 행 재구성(687 동일). G-D2 W1~W6 공식분리·후가공 배선은 유효(본체 comp use_dims가 siz_cd→siz_width/height로 바뀔 뿐).

---

## 1. A안(좌표 siz_cd 채번) vs 신안(siz_width/siz_height 구간) 비교·전환 판정

### 1.1 엔진 TIER 매칭이 매트릭스를 표현하는가 (코드 검증·pricing.py)

| 코드 요소 | 라인 | 동작 | 매트릭스 표현 |
|-----------|------|------|--------------|
| `TIER_DIMS=("siz_width","siz_height","min_qty")` | 45 | 3 구간 차원 | 가로·세로·수량 |
| `TIER_UPPER=("siz_width","siz_height")` | 46 | '이하' 상한 방향 | 사이즈는 상한 구간 |
| `match_component` 사이즈 룩업 | 150-152 | `eligible=[t for t in tiers if t>=cmp_val]; selected=min(eligible)` | **주문 가로 ≤ 임계 중 최소 = 값 담는 가장 작은 구간**(off-grid=다음 큰 구간 자동) |
| `_tier_val` NULL | 99-101 | 상한차원 NULL=∞ catch-all | 최대 구간 상한없음 가능 |
| `ERR_ABOVE_MAX` | 154 | 최대 구간 초과 | 상한 초과 명시 |
| 2축 독립 | 144 for dim | 가로·세로 각자 구간 선택 후 조합 행 | **[가로][세로] 매트릭스 = 2축 구간 교차** |

→ **신안이 면적매트릭스를 정확·완전 표현.** 게다가 **off-grid ceiling이 엔진 내장**(A안은 위젯/엔진 별도 런타임 ceiling 필요했음·메모리 [[dbmap-compute-in-app-db-stores-lookup]]). 신안이 더 우월.

### 1.2 비교표

| 축 | **A안 (좌표 siz_cd 채번)** | **신안 (siz_width/siz_height 구간)** |
|----|---------------------------|--------------------------------------|
| siz 신규 채번 | 106(SIZ_000518~623) | **0** |
| 단가행 | 687(siz_cd FK) | 687(siz_width/height 수치) |
| off-grid | 위젯/엔진 런타임 ceiling(DB 미저장) | **엔진 내장**('이하 최소 임계'·다음 큰 구간 자동) |
| siz 마스터 영향 | 비대(106 좌표행) | 무영향(siz_cd 미사용) |
| 실무진 입력 | 좌표 siz 선택(106 항목) | **가로/세로 수치 입력**(직접·직관) |
| 라이브 정합 | siz_cd FK(기존) | siz_width/height numeric(신규·라이브 실재) |
| 자연키 | siz_cd 포함 | siz_width/siz_height 포함(라이브 인덱스 실측) |
| 비규격 연속 사이즈 | 좌표 격자만(불연속) | **연속값 구간 매칭 가능**(직접입력형 정합) |
| 정규화 | 좌표=규격(siz의 본질) | 사이즈=구간 임계(가격 룩업축) |

### 1.3 판정 — **신안 GO(전환 권고)**

- **근거:** ① 엔진 TIER가 매트릭스 정확 표현(코드) ② 채번 0 ③ off-grid 엔진 내장 ④ 직접입력형(실사=자유 가로/세로) 정합 — 좌표 격자보다 **연속 사이즈 구간**이 실사 본질에 맞음 ⑤ 라이브 컬럼·자연키 실재.
- **단 고정가 15(폼보드/액자/족자/배너/시트커팅/미니)는 규격 siz_cd 유지** — A시리즈·명시규격은 구간 아닌 이산 규격(siz_cd, round-2 §6.5 전건 라이브 실존). 신안은 **면적매트릭스 13 + 아크릴 전용**.

---

## 2. 포스터/사인 가격구성요소 구성 정리 (신안)

### 2.1 본체 면적매트릭스 13 comp (siz_width/siz_height 구간)

```
B01 매트릭스 셀 (가로 g, 세로 s) = 단가 p
  → component_prices row:
     comp_cd=COMP_POSTER_<MAT>, siz_width=g, siz_height=s, min_qty=NULL,
     unit_price=p, (siz_cd/clr/mat/proc/opt/print_opt/plt = NULL), apply_ymd
  use_dims = ["siz_width","siz_height"]  (수량무관 매트릭스)
```

| 블록 | comp_cd | 가로 임계(W) | 세로 임계(H) | 단가행 |
|------|---------|:--:|:--:|:--:|
| B01~B11 포스터 11 | COMP_POSTER_<MAT> | 13종(600~3000) | 3~4종(600~1200) | 39~52 |
| B21 일반현수막 | COMP_POSTER_BANNER_NORMAL | 16종(~5000) | 5종(~1750) | 80 |
| B22 메쉬현수막 | COMP_POSTER_BANNER_MESH | 16종 | 3종 | 48 |
| **합계** | 13 comp | W 18 distinct | H 7 distinct | **687** |

- **'이하 상한' 임계:** 각 가로/세로 값이 그 구간의 **상한**(주문값 ≤ 임계 최소 구간). 예: 가로 임계 {600,800,1000…}, 주문 700 → 800 구간(800 이하 최소 임계 ≥700). **시트의 매트릭스 키값이 곧 구간 상한.**
- **최대 구간 NULL:** 가장 큰 구간(예 3000·5000)을 NULL(∞)로 둘지 명시값으로 둘지 컨펌(Q-PR-1). 명시값이면 초과 시 ERR_ABOVE_MAX.

### 2.2 고정가 15 (규격 siz_cd 유지·구간 아님)

- 폼보드/포맥스/액자/족자/배너/시트커팅/아크릴스티커/미니류 = A시리즈·명시규격(290x90 등) → **siz_cd 이산 규격**(round-2 §6.5 전건 라이브 실존·신규 0). siz_width/height 미사용. 일부(미니류) min_qty 수량구간.

### 2.3 후가공 add-on (G-D2 그대로)

- 오시 CREASE_1L(proc_cd+dim_vals.줄수)·미싱 PERF(proc 전환 후)·귀돌이(proc_cd)·가변(proc_cd+dim_vals.개수)·별색(proc_cd+print_opt_cd). **siz_width/height 무관**(후가공은 사이즈 차원 아님). G-D2 W4 배선 유효.

### 2.4 off-grid 처리 (e0ef85f·nonspec_*)

- **입력 검증/스냅 = `t_prd_products.nonspec_*`**(nonspec_yn·width/height_min/max/**incr**). 비규격 가로/세로 입력 시 증가단위(incr)로 스냅·min/max 범위 제한.
- **가격 룩업 = 엔진 TIER '이하 상한'**(다음 큰 구간). 즉 off-grid 사이즈는 nonspec_incr로 입력 정규화 → siz_width/height 구간 매칭. **A안의 런타임 ceiling 로직 불요**(엔진+nonspec이 흡수).

---

## 3. 아크릴 동형 적용

| 항목 | 아크릴(31_acrylic-price-link) | 신안 동형 |
|------|------------------------------|----------|
| 구조 | 가로:세로 면적매트릭스(투명3T/1.5T/미러3T) | ✅ siz_width/siz_height 구간 동일 |
| 좌표 siz | 196 distinct(105 NONE 채번 대기) | **채번 0**(siz_width/height 수치) |
| comp | COMP_ACRYL_CLEAR3T 등(use_dims siz_cd) | use_dims siz_cd→siz_width/height 전환 |
| off-grid | ceiling(권위 HARD·런타임) | 엔진 TIER 내장 |

→ **동형 GO.** 아크릴도 좌표 채번 불요화. **면적매트릭스 일반화 = 실사·현수막·아크릴 단일 차원 모델**(siz_width/siz_height 구간). 단 아크릴은 라이브 일부 부분진화(메모리 [[dbmap-acrylic-price-chain-link]]) → 전환 전 재실측 필요(컨펌 Q-PR-3).

---

## 4. U1/U2/G-D2 영향·갱신 방향

| 단위(이전) | 영향 | 갱신 |
|-----------|------|------|
| **U1 좌표 siz 106 채번**(silsa-quote §5) | **폐기** | siz_cd 신규 불요(siz_width/height 직접). SIZ_000518~623 채번 취소 |
| **U2 면적 단가행**(siz_cd 언피벗) | **재구성** | siz_cd 행 → siz_width/siz_height 행(687 동일·값 불변). EXACT/REVERSED 6 재사용도 불요 |
| **G-D2 W1 공식분리(U6)** | 유효 | 본체 comp use_dims만 ["siz_cd"]→["siz_width","siz_height"]. 공식분리 동기(동시매칭) 동일 |
| **G-D2 W2 본체 배선** | 유효 | 변경 없음 |
| **G-D2 W4 후가공 배선** | 유효 | 후가공 사이즈 무관·그대로 |
| **dimension-basecode §1 siz_cd 판정** | 갱신 | 면적 사이즈축 = siz_cd→siz_width/siz_height 구간 |

> **net 효과:** 신안 전환으로 적재 단위 **감소**(siz 채번 단위 제거)·단가행 수 동일(687)·G-D2 배선 무손상. 실무진은 가로/세로 수치 입력으로 더 단순.

---

## 5. BLOCKED / 컨펌 정직 분류

| ID | 항목 | 상태 | 권고/필요 |
|----|------|------|----------|
| Q-PR-1 | 최대 구간 NULL(∞ catch-all) vs 명시값(초과 거부) | 컨펌 | 시트 최대값 명시 + 초과는 nonspec_max로 제한 |
| Q-PR-2 | sql/32 코멘트 "사이즈가로(이상)" vs pricing.py '이하 상한' 불일치 | 🟡 | 코드(이하 상한)가 동작 권위·코멘트 라벨 정정은 webadmin(read-only·백로그) |
| Q-PR-3 | 아크릴 전환 전 라이브 부분진화 재실측 | BLOCKED | PRF_CLR_ACRYL·CLEAR3T 현황 재확인 후 동형 적용 |
| Q-PR-4 | 고정가 15 = siz_cd 유지 확정(구간 아님) | 컨펌 | 규격 이산이라 siz_cd(권고) |
| Q-PR-5 | 타이벡 하드/소프트·고정가 색변형 = 신안 무관(별 comp/mat) | 컨펌 | 사이즈축과 직교 |
| Q-PR-6 | 단가행 siz_width/height 백필 = 시트 매트릭스 키값 그대로 임계 | 컨펌 | 시트 행/열 헤더값=구간 상한 |

### 5.1 load-builder 인계 단위 (갱신·신안)

| 단위 | 테이블 | 조치 | 행수 | 멱등키 |
|------|--------|------|:--:|--------|
| **V1 면적 단가행(신안)** | component_prices | 687 셀 → (comp_cd, siz_width, siz_height, unit_price) | 687 | 자연키(siz_width/height 포함) |
| **V2 본체 use_dims 전환** | price_components | 13 면적 comp use_dims ["siz_cd"]→["siz_width","siz_height"] | 13 UPDATE | comp_cd |
| **V3 off-grid nonspec** | t_prd_products | 실사 상품 nonspec_yn=Y·width/height min/max/incr | ~13 | prd_cd |
| **(U1 폐기)** | — | 좌표 siz 채번 취소 | 0 | — |
| **G-D2 W1~W6** | (gd2 설계) | 본체 use_dims 신안 반영 후 그대로 | — | — |

- **DRY-RUN(R1~R6):** ① 멱등 delta 0 ② 동시매칭 0(공식 본체 1 comp) ③ 골든: 인화지 600×1800 = siz_width=600·siz_height=1800 구간 매칭 단가 ④ off-grid 700×1900 = 800×2000 구간(이하 최소) ⑤ 최대초과 ERR_ABOVE_MAX ⑥ 채번 0.

---

## 6. read-only 준수

- 라이브 SELECT(siz_width/height 컬럼·자연키 14컬럼·단가행 0·nonspec_*) + pricing.py(TIER_DIMS·match_component 사이즈 룩업·_tier_val)·sql/32·git e0ef85f 직접 확인. INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 정리·설계까지 — load-builder V1~V3+G-D2 멱등 SQL·DRY-RUN·GO는 dbm-validator·실 COMMIT 인간 승인. webadmin 코드 수정 0(read-only oracle).
