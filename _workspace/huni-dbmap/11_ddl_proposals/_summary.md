# DDL 제안 요약 — round-5 + round-6 (dbm-ddl-proposer)

> 권위: `docs/goal-2026-06-06-02.md` §5(제안 경계)·R4(제안 정합)·§6.6/6.9(직접 적용 금지·search-before-mint) ·
> `ddl-proposal-method.md`. **전 제안 = propose ≠ apply. 라이브 CREATE/ALTER 0. COMMIT 0.**
> 입력 GAP: `09_load/_assembled/blocked-and-gaps.md` + `_assembled_price/blocked-and-gaps.md` + round-6 silsa pilot M-1.
> search-before-mint = 라이브 read-only(`00_schema/_live-schema-dump-260606.txt`·ref-*.csv·06_extract) 기반.

---

## 0a. round-6 Phase-0 DECISION PACK (CPQ 옵션 레이어 L2 차단 해소 — 2026-06-07)

> CPQ 옵션 레이어 적재(L2)를 막는 GAP-PARAM(공정 파라미터 보존) + 5건 미해결 설계 결정. **propose only — 라이브 read-only 실측 포함, ALTER/COMMIT 0.**

| # | GAP/결정 | 판정 | 제안/권고(1줄) | 사다리 | 산출물 |
|---|----------|------|----------------|--------|--------|
| P0-A | GAP-PARAM(+COUNT) — 공정 파라미터 선택값(타공 구수·줄수·개수·박크기·조각수·구수) 보존처 부재 = ref_param_json 미구현 | **DDL-NEEDED** | `ALTER t_prd_product_option_items ADD ref_param_json jsonb NULL` (단 1줄) | **3(JSONB)** | `ref-param-json-proposal.{md,sql}` |
| P0-1 | 잉크색(만년스탬프)=도수 vs 자유옵션그릇 | DECISION | 권고 **B(자유옵션그릇)** 조건부(GAP-OPT 종속) | — | `10_configurator/design-decisions-pack.md §1` |
| P0-2 | 용량(머그 11온스)=비치수 size vs 별 사양축 | DECISION | 권고 **A(비치수 size 마스터 경유)** | — | `…pack.md §2` |
| P0-3 | 면지/바인더링(booklet)=자재 vs 공정/셋트 | **RESOLVED(라이브)** | **A 자재(.03) 확정** — 면지=USAGE.03·링=USAGE.07 라이브 실재 | 0(DDL 불요) | `…pack.md §3` |
| P0-4 | 보드종류(폼보드/포맥스)=자재 vs 가공 vs 형태 | DECISION | 권고 **A 자재(.03)** — 5상품 n_mat=0 실측 | — | `…pack.md §4` |
| P0-5 | 실내/실외 거치대=1 base+옵션 vs 2 SKU | DECISION | 권고 **B 2 template** — 라이브 add-on 패턴 정합 | 0(DDL 불요·데이터만) | `…pack.md §5` |

- **라이브 실측 확정(read-only 2026-06-07):** option_items 12컬럼·0행·`ref_param_json` 전 DB 부재 / prcs_dtl_opt(jsonb) 파라미터 *스키마* 실재(줄수·면·제본 다축) → schema↔value 비대칭이 GAP-PARAM 본질 / jsonb 라이브 컨벤션 3건(logic·constraint_json·prcs_dtl_opt)·GIN 0 / 면지=MAT_000001~004(.03 USAGE.03)·링=MAT_000012~023(.03 USAGE.07) / 보드 5상품(129·130·131·132·144) n_mat=0·보드 자재명/공정명 0건 / 우드거치대 PRD_000012=상품+TMPL-PRD_000012.
- **라이브↔설계 문서 모순:** attribute-entity-map §5.3·cpq-option-gaps가 `[CONFIRM]`으로 둔 면지/바인더링이 **라이브 실측=자재(.03) 확정** → 설계 문서 정정 권고(P0-3).
- **DDL-NEEDED 1건(P0-A)** = option_items 0행이라 백필 0·트리거 미참조·인덱스 불요(최소 ALTER).

---

## 0. round-6 추가 제안 (M-1 — 열재단 신규 공정)

| # | GAP | 판정 | 제안 엔티티(1줄) | 사다리 | 승격 행수 | 산출물 |
|---|-----|------|------------------|--------|-----------|--------|
| M-1 | 열재단(천 열봉합 재단) 마스터 공정 부재 — 파일럿이 PROC_000053 완칼(종이) 차용→BLOCKED | **DDL-NEEDED** (마스터 데이터 행) | `t_proc_processes` 1행(열재단) + `t_prd_product_processes` 1행(PRD_000138) | 1(데이터 행, 최저단) | OG-GAGONG "열재단" item **BLOCKED→INSERTABLE** | `heat-cut-process-proposal.{sql,md}` |

- **lead verdict = ① 실제 가공**(가격표 권위 3,000원≠0원 + 경쟁사 CUT_ZUN①/CUT_DFT② 코드분리 + 도메인 열칼 융착). 도메인 리서치의 ② 권고는 가격표 권위로 override.
- **backfill scope = PRD_000138 일반현수막 1개**(silsa-l1.csv 가공 col 전수: 메쉬현수막=재단만[별건]·PET/메쉬배너=타공만).
- **신규 테이블/컬럼/JSONB 불요** — 기존 2테이블 그대로 수용(사다리 최저단). 가격은 가격엔진(round-2)에만, 공정 행에 중복 저장 금지.

> ⚠ **proc_cd 채번 충돌 주의**: 본 요약 §1 row4(레이저커팅 NOT-DDL)와 M-1(열재단)이 **둘 다 placeholder `PROC_000084`를 적었다.** 두 공정은 같은 코드를 가질 수 없다. **적용 직전 라이브 `MAX(proc_cd)` 확인 후 후니가 서로 다른 채번을 배정**해야 한다(어느 placeholder도 "비어있음"을 단정하지 않음).

---

---

## 1. GAP × 판정 매트릭스

| # | GAP/BLOCKED 항목 | 판정 | 제안 엔티티(1줄) | 사다리 | 승격 행수 |
|---|------------------|------|------------------|--------|-----------|
| 1 | goods-pouch 비치수 size (47상품) `§5` | **DDL-NEEDED** | `t_siz_nonspec_sizes`(라벨 마스터) + `t_prd_product_nonspec_sizes`(연결) + `NONDIM_SIZE_KIND` 코드그룹 | 4(테이블)+1(코드) | **47상품**(≈96 ref) |
| 2 | 박(foil) 2단 룩업 (면적→등급→가격) 가격`§B-1` | **DDL-NEEDED** | `t_prc_foil_area_grades`(룩업1) + `t_prc_component_prices.grade_cd`(nullable 컬럼) + `FOIL_GRADE` 코드그룹 | 4(테이블)+2(컬럼)+1(코드) | 소형 ≈90셀+13룩업 / 대형 동형 (현 0행) |
| 3 | addon template 부재 (4행) `§2` | **NOT-DDL** | (없음 — t_prd_templates·FK 실재, 행만 부재) | — | 4행(template 등록 후) |
| 4 | 레이저커팅 proc_cd (14행) `§1` | **NOT-DDL** | (없음 — 코드행 `PROC_000084`) | 1(코드) | 14행 |
| 5 | sticker 066 원형 size (11행) `§3` | **NOT-DDL** | (없음 — 코드행 SIZ_000501~510, 치수 실재) | 1(코드) | 11행 |
| 6 | 가격 §A siz 등록 7군 (2,697행) `가격§A` | **NOT-DDL** | (없음 — 코드행/데이터, 면적 치수 실재) | 1(코드) | 2,697행 |
| 7 | sticker 058~062 형상 enum 축 | **DEFER** | (보류 — D-2 축 귀속 컨펌 선행, ⓐ/ⓑ면 NOT-DDL) | 미정 | 미정 |
| 8 | 책등(book-spine) param 슬롯 | **DEFER** | (보류 — `_deferred/`=round-5 GO 범위 밖 + prcs_dtl_opt jsonb 사다리3 우선) | 3(JSONB) 추정 | 미정 |
| 9 | 박 동판비 B01 | **NOT-DDL** | (없음 — 기존 6차원 ADEQUATE) | 0 | 동판비 셀(siz 등록 후) |

- **DDL-NEEDED 2건** → `ddl-proposal-goods-pouch-nondim-size.{sql,md}` · `ddl-proposal-foil-2step-lookup.{sql,md}`
- **NOT-DDL 4건 + DEFER 2건** → `ddl-proposal-not-needed-routing.md`

## 2. search-before-mint 결론 (DDL-NEEDED 2건)

| 제안 | 탐색한 기존 구조 | 무손실 실패 입증 |
|------|------------------|------------------|
| 비치수 size | t_siz_sizes / nonspec_*_min/max / 코드행 / CPQ option_items | 4개 전부 실패: 순수 라벨 siz 0건·nonspec=연속범위·옵션은 차원행 선존재 강제 |
| 박 2단 | component_prices 6차원 직접평면화(mat차용/면적직접) | 자재축 오용 + 룩업1 자리 없음 / 셀폭증 2.6배·압축의도 소실 (round-2 검증 GO) |

## 3. 충돌·중복 검사 (R4)

- `grade_cd` 컬럼 — 라이브 `t_prc_component_prices`에 **부재** 확인(신규) ✅
- 제안 3 테이블명(`t_siz_nonspec_sizes`·`t_prd_product_nonspec_sizes`·`t_prc_foil_area_grades`) — 라이브 dump **무충돌** ✅
- SIZ_000506 류 중복 mint **0**(addon=기존 templates 재사용 라우팅, sticker35mm=SIZ_000422 재사용) ✅

## 4. 인간 승인 적용 순서 (전 제안 + 코드행 선적재 통합)

> 모든 단계 = **후니 인간 승인** 후 라이브 적용. 본 트랙은 제안·DRY-RUN까지(§10).

### 상품마스터 트랙
1. (코드행) `PROC_000084 레이저커팅` 등록 → 아크릴 완칼 14행
2. (코드행) `SIZ_000501~510 원형10종` 등록 → sticker 066 size 11행
3. (데이터) `t_prd_templates` PRD_000003·008·015 template 등록 → addon 4행
4. (코드행) `NONDIM_SIZE_KIND` 코드그룹 → **(DDL #1)** `t_siz_nonspec_sizes`·`t_prd_product_nonspec_sizes` CREATE → 라벨 마스터·연결 47상품
   *(라벨→nsiz_cd 매핑 데이터 = 후니 결정 선행, 발명 금지)*

### 가격 트랙
5. (코드행/데이터) §A siz 7군 등록 → component_prices 2,697행 placeholder 치환·재조립
6. (코드행) `FOIL_GRADE` 코드그룹 → **(DDL #2)** `t_prc_foil_area_grades` CREATE + `t_prc_component_prices.grade_cd` ALTER → 박 가공비 룩업1·가격그리드
   *(면적입력 vs 등급선택 UI 결정 = 후니 선행)*

> 각 DDL은 적재(INSERT) **이전** 적용. DDL → 코드행 → 적재행 순. 롤백은 각 `.sql` 하단.

## 5. 검증자(dbm-validator) R4 인계 사항

- **R4 확인 요청:** 컨벤션 정합(naming/type/code) · 충돌·중복 0(§3) · 정규화 위반 0(각 .md §4) · 적용순서·영향 명시(각 .md §5) · search-before-mint(§2) 통과 여부.
- **NEVER:** 라이브 CREATE/ALTER, COMMIT. 제안은 인간 승인 게이트로.
- **재진입:** R4 FAIL 시 해당 제안만 수정·재산출(나머지 carry-forward). DEFER 2건(형상 enum·책등)은 상위 컨펌(D-2/D-PB-2) 또는 GO-범위 승격 시 재평가.
