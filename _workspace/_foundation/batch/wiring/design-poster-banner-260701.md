# 포스터/사인/배너 6상품 옵션 배선 — 설계·근본원인·골든 (§27 배선 서브트랙)

- 대상: PRD_000118 아트프린트포스터·124 린넨패브릭포스터·129 폼보드·136 PET배너·140 무광시트커팅·143 미러아크릴스티커
- 입력 권위: 상품마스터 260610 실사시트(`silsa-l1.csv`) · 인쇄상품 가격표 260527(포스터/사인) · 라이브 t_prc_*/t_prd_*(읽기전용) · 엔진 `pricing.py evaluate_price`
- 산출일: 2026-07-02 · 생성측(생성≠검증) · **실 COMMIT 없음 — dryrun(BEGIN…ROLLBACK) 실행·검증까지.**
- 산출물: 이 문서 + `poster-banner-backup-260701.csv` + `poster-banner-fix-dryrun.sql` + `poster-banner-undo.sql`
- ★폼보드(PRD_000129)는 `design-foamboard-260701.md`의 §2.4 해법 **(a) 옵션모델 완성**을 사용자 승인 방향으로 실현. 기존 `foamboard-fix-dryrun.sql`(BLOCKED 판정)은 **이 파일로 대체(superseded)**.

---

## 0. 결론 (먼저)

| 상품 | 현재 실측 | 판정·조치 | 조치 후 골든 |
|---|---|---|---|
| **129 폼보드** | **전 사이즈 0원(파손)** | **FIX** — 보드칼라(화이트/블랙)×사이즈 완제품가 컴포넌트 신설+공식 가산+필수화/기본화 | 화이트A3 6000·A2 12000 / 블랙A3 8500·A2 14000 |
| **140 무광시트커팅** | **전 사이즈 0원(파손)** | **FIX** — base 사이즈 재키잉(구172/174/197→신258/315/198) | A4 6000·A3 11000·A2 32000 |
| **136 PET배너** | 거치대 미과금(선택해도 22000) | **FIX** — 거치대(실내/실외) mat_cd 컴포넌트 신설+배선 | 없음 22000·실내 32000·실외 45000 |
| 118 아트프린트 | 12000(base 동작) | **표시만** — 소재 sel_typ+기본선택. 코팅=무료(권위 priceV=0) | 12000(불변) |
| 124 린넨 | 17000·마감 +2000 동작 | **NO-OP** — 마감 이미 opt_cd 완전배선(실측 확인) | 불변 |
| 143 미러아크릴 | 11000(base 동작) | **표시만** — 칼라 sel_typ. 골드/실버 동일가(외형) | 11000(불변) |

**돈크리티컬 파손 2건(129·140) 근본원인 동일**: §17 basedata-dedup 이 사이즈코드를 재매핑(구코드 논리삭제→신 캐논코드)했는데, 그 상품의 base 완제품가 컴포넌트 단가행이 **구 사이즈코드에 고착**돼 상품이 제공하는 신 사이즈와 NO_MATCH → silent-zero.

---

## 1. 엔진 메커니즘 (설계 근거 — `pricing.py` 실측)

- **자재 옵션**(`ref_dim_cd=OPT_REF_DIM.03`): 선택 시 `selections["mat_cd"]` 주입 → `use_dims`에 `mat_cd`를 가진 컴포넌트가 그 값으로 행 매칭.
- **공정 옵션**(`OPT_REF_DIM.04`): `procs=[{proc_cd}]`(=`proc_sels`)로 전달 → `use_dims`에 `proc_cd`를 가진 컴포넌트가 **선택 공정마다 개별평가·가산**(`_evaluate_formula` L694). 무관 공정은 no-match 생략.
- **opt_cd 옵션**: `use_dims=["opt_cd",…]` 컴포넌트가 옵션값코드로 매칭(린넨 마감이 이 방식).
- **매칭 규칙**(`match_component`): 행의 각 non-NULL use_dim이 선택값과 일치해야 함. NULL=와일드카드. 미선택 차원은 빵꾸로 안 봄.
- **표시 전제**: `sel_typ_cd` 미설정 옵션그룹은 `sim-meta.opt_groups`에서 **빈 배열=미노출**(6상품 실측). → 노출하려면 sel_typ 필수.

---

## 2. 상품별 설계

### 2.1 폼보드 PRD_000129 (PRF_POSTER_FOAMBOARD) — 옵션모델(a) 완성
- 현재 파손: base `COMP_POSTER_FOAMBOARD_WHITE`(키 siz 174/197/293) ↔ 상품 사이즈 315/198 → NO_MATCH=0(실측).
- 권위값(260527, 라이브 backup verbatim): 화이트 A3=6000·A2=12000 / 블랙 A3=8500·A2=14000. (마스터 실사 화이트 A3=6000 우선=불변.)
- 설계: **신규 `COMP_POSTER_FOAMBOARD_BOARD` `use_dims=["mat_cd","siz_cd"]`** 4행. 보드칼라 옵션(화이트→MAT_398, 블랙→MAT_399)이 mat_cd 주입, 사이즈가 siz_cd 결정.
  - 기존 WHITE/BLACK(둘 다 siz_cd-only)는 색상 구분 불가 → 재사용 불가(신 키형상 필요). search-before-mint: 폼보드용 `[mat_cd,siz_cd]` 컴포넌트 부재 확인 → 신설 정당.
  - 공식: WHITE(seq1) **유지=no-match 0**(무해) + BOARD(seq2) 가산 → **순수 additive**(삭제 없음=안전 undo).
  - 옵션: OPT-000045 보드칼라 = `sel_typ=SEL_TYPE.01, mand_yn=Y, 1/1`, OPV-000092 화이트 `dflt_yn=Y` → **미선택 방지=화이트 6000 기본 보장**. 코팅(OPT-000044)은 완제품가 포함(무료) → 표시만.
- ★대안 비교: (i)신규 컴포넌트[채택·순수additive·undo단순] vs (ii)WHITE/BLACK use_dims 변형+재키잉[재사용이나 use_dims mutation+행삭제=undo복잡·위험]. 돈크리티컬·복구용이성 우선 → (i).

### 2.2 무광시트커팅 PRD_000140 (PRF_POSTER_SHEETCUT_MATTE) — base 재키잉
- 현재 파손: base 키 172(A4)/174(A3)/197(A2) ↔ 상품 258/315/198 → 0(실측). dedup 재매핑 잔재.
- 설계: base에 신 사이즈코드 3행 additive(258=6000·315=11000·198=32000, 값 verbatim). 구 행 무해(상품 미제공)→삭제 안 함.
- 색상(화이트/블랙)=외형(권위 "무광(화이트/블랙)"=동일가) → **가격 컴포넌트 불요**. 색상 OPT_000068 이미 sel_typ 有.

### 2.3 PET배너 PRD_000136 (PRF_POSTER_PET_BANNER) — 거치대 add-on
- base 22000=출력+코팅+4구타공 **포함가**(권위 note). → 코팅(무광기본/유광)·4구타공=완제품가 포함=무료. 표시만.
- 거치대(거치대없음 기본/실내 MAT_409/실외 MAT_410)=진짜 add-on.
  - search-before-mint: orphan `COMP_POSTEROPT_PET_BANNER_STAND_IN/OUT_S1/S2` 존재하나 `use_dims=[]`(상시매칭)=선택구분 불가·미배선 → **재사용 불가**. 신규 `COMP_POSTEROPT_PET_BANNER_STAND_SEL use_dims=["mat_cd"]` 2행, 공식 seq2 가산.
  - ★값 CONFIRM: 실내 상품마스터260610=10000 vs live orphan STAND_IN=7000 **불일치** → 260610 채택(HARD 상품마스터 권위). 실외 260610=23000 = STAND_OUT_S1=23000 **일치·확정**.

### 2.4 아트프린트 118 · 미러아크릴 143 — 표시만(가격영향 0)
- 118 소재(인화지 단일·base 포함)=sel_typ+기본선택. 코팅 priceV=0(권위)=무료(이미 sel_typ 有).
- 143 칼라(골드 MAT_377/실버 MAT_378 동일가·외형)=sel_typ만.

### 2.5 린넨 124 — NO-OP
- 마감 5종=`COMP_POSTEROPT_LINEN_FINISH`(`use_dims=["opt_cd","min_qty"]`) 5행이 옵션값코드로 이미 완전배선. C_missing의 "proc_cd 미배선"은 **오탐**(마감은 opt_cd로 과금·PROC_000080=생산태그). 실측: A3세로 17000 + 봉미싱 opt_cd → 19000 ✓.

---

## 3. 골든 (dryrun 트랜잭션 내 매칭 증명 완료 · COMMIT 후 시뮬레이터 기대치)

시뮬레이터 호출: `sim.simulate(prd, selections, qty=1, procs=…)`. 자재선택은 위젯이 mat_cd 주입 → 골든은 mat_cd 명시로 에뮬레이트.

| 케이스 | selections | 기대 final_price |
|---|---|---|
| 폼보드 화이트 A3 | `{siz_cd:SIZ_000315, mat_cd:MAT_000398}` | **6000** (불변) |
| 폼보드 화이트 A2 | `{SIZ_000198, MAT_000398}` | **12000** |
| 폼보드 블랙 A3 | `{SIZ_000315, MAT_000399}` | **8500** |
| 폼보드 블랙 A2 | `{SIZ_000198, MAT_000399}` | **14000** |
| 시트커팅 A4 | `{siz_cd:SIZ_000258}` | **6000** |
| 시트커팅 A3 | `{SIZ_000315}` | **11000** |
| 시트커팅 A2 | `{SIZ_000198}` | **32000** |
| PET 거치대없음 | `{siz_cd:SIZ_000321}` | **22000** |
| PET 실내거치대 | `{SIZ_000321, mat_cd:MAT_000409}` | **32000** (22000+10000) |
| PET 실외거치대 | `{SIZ_000321, mat_cd:MAT_000410}` | **45000** (22000+23000) |
| 아트프린트 A3 | `{SIZ_000315}` | 12000(불변) |
| 린넨 A3세로+봉미싱 | `{SIZ_000542, opt_cd:OPV_000027}` | 19000(불변) |
| 미러 290x90 골드 | `{SIZ_000324, mat_cd:MAT_000377}` | 11000(불변) |

dryrun 실행 결과: 13 INSERT/UPDATE 정상, 골든 매칭 SELECT 전건 일치, ROLLBACK 확인.

---

## 4. 컨펌큐 / 인간 승인 필요

1. **[돈크리티컬·CONFIRM] PET배너 실내거치대 단가** — 상품마스터260610=**10000** vs live orphan STAND_IN=**7000** 불일치. dryrun은 260610(10000) 채택. 실무진 확정 필요. (실외 23000은 양 소스 일치·확정.)
2. **[표시·확인] 폼보드 보드칼라 필수화** — 화이트 기본 pre-select 로 화이트 6000 불변 보장. 실무진이 "색상 미선택 허용(→어떤 기본가?)"을 원하면 재논의.
3. **[report·범위 밖] base 가격 불일치** — ① 아트프린트 base A3=12000(엔진) vs 실사권위 7000 ② 린넨 542(A3세로)=17000 vs 권위 9000 ③ 미러 base 324=11000 vs 실사마스터 15000. 모두 **기존 base 면적/사이즈 매트릭스** 값(실무진 신규옵션과 무관) → §26 무결성/별건 라우팅.
4. **[정리·선택] orphan 컴포넌트** — 폼보드 WHITE/BLACK(구 siz-only)·PET STAND_IN/OUT_S1/S2(use_dims=[])는 미배선 잔재. 파손 해소엔 불필요(무해)하나 후속 `use_yn=N`/`del_yn` 정리 권고.

**어느 것도 이번 COMMIT 없음.** dryrun만 실행(ROLLBACK 확인). COMMIT 은 인간 승인 + webadmin 실화면(제외0·PRICE≠0) 확인 후.
