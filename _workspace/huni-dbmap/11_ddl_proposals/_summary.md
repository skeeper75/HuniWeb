# DDL 제안 요약 — round-5 (dbm-ddl-proposer)

> 권위: `docs/goal-2026-06-06-02.md` §5(제안 경계)·R4(제안 정합)·§6.6/6.9(직접 적용 금지·search-before-mint) ·
> `ddl-proposal-method.md`. **전 제안 = propose ≠ apply. 라이브 CREATE/ALTER 0. COMMIT 0.**
> 입력 GAP: `09_load/_assembled/blocked-and-gaps.md` + `_assembled_price/blocked-and-gaps.md`.
> search-before-mint = 라이브 read-only(`00_schema/_live-schema-dump-260606.txt`·ref-*.csv·06_extract) 기반.

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
