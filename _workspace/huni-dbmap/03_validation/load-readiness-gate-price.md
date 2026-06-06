# 적재 준비 게이트 판정 — round-4 가격(price, t_prc_*)

> 대상 번들: `09_load/_assembled_price/` (`dbm-load-builder` 조립) · 게이트: `dbm-validator` 독립 검증(G9).
> 권위: `docs/goal-2026-06-06-01.md` · 입력 권위 `03_validation/price-load-validation-final.md`(매핑 GO) · `02_mapping/load_price/*.csv` · 라이브 `00_schema/price-engine-ddl-raw.txt` + read-only SELECT.
> 적대적 검증: 게이트가 통과를 증명하기 전까지 결함이 있다고 가정. 모든 PASS는 파일·행·열·쿼리결과·카운트로 근거 제시. **DB 쓰기 0·DDL 0·라이브 DRY-RUN 보류(사용자 미승인)**.

---

## 종합 판정: **GO** (적재본 자체는 즉시 적재가능 — 단, 코드행 선적재 1 + 후니 siz 등록 2,697행은 인간 승인 선결)

G1~G9 전 게이트 PASS. 즉시 적재가능 2,319행은 로컬 제약검사 + 라이브 read-only FK 확증으로 무결 입증(타입·길이·NOT NULL·CHECK·PK·FK 위반 0). 차단 2,697행 + GAP 1건은 사유·해소조건과 함께 명시되어 침묵드롭 0. 본 GO는 **적재본의 적재 가능성**에 대한 것이며, 실제 INSERT 실행 + 코드행/siz 등록은 인간 승인 대상(에스컬레이션 §하단).

> **유보(carry-forward)**: G6 라이브 롤백전용 DRY-RUN은 사용자 미승인으로 보류. 로컬 제약검사는 전건 PASS이나, 라이브 export 재확증(stale-ref 가드)은 실적재 직전 선결 조건으로 남는다.

---

## 게이트별 결과

| Gate | 결과 | 근거(파일·행·쿼리·카운트) |
|------|------|--------------------------|
| **G1** t_* 화이트리스트 | **PASS** | 대상 6테이블 전건 화이트리스트 내(`t_cod_base_codes` 코드행, `t_prc_price_formulas/price_components/formula_components/component_prices`, `t_prd_product_price_formulas`). 비-t_*/Django 적재행 **0**. `t_prd_product_prices` 미산출 정당(round-2 미신설). |
| **G2** 무손실 추출 | **PASS** | `04_prc_component_prices.csv`(2,108행) ↔ 원본 `02_mapping/load_price/t_prc_component_prices.csv`의 `siz_cd NOT LIKE 'SIZ_PENDING%'` 필터행과 **행집합 완전 일치**(헤더 동일·튜플 multiset 동일·발명/변형 0). 상위 L1 9게이트·역대조 100%·날조0·dodge0은 validation-final §A 선근거. |
| **G3** 매핑 무결성 | **PASS** | 자연키 dup **0**(component_prices `(comp_cd,apply_ymd,siz,clr,mat,coat,bdl,min)`); PK dup 0(전 6파일); 고아 comp_cd **0**(insertable 125 distinct ⊆ price_components 143); under-load 0(2,108+2,697=원본 4,805 정확); 침묵폴백 0. **2,106 vs 2,108 해소**: §발견 F-1. |
| **G4** 스키마 적합 | **PASS** | 라이브 DDL(`price-engine-ddl-raw.txt`) 대조: 타입/길이/NOT NULL/CHECK 위반 **0**(전 5파일). **comp_cd 최장 41자**(varchar(50)) — round-2 B-FINAL-1(55자 2종) **현 CSV 해소 확증**, overflow 0. use_yn/addtn_yn ∈ {Y,N} 위반 0. 코드행 cod_nm 4≤100·note 142≤500. |
| **G5** FK 무결성+순서 | **PASS** | 내부 FK closure 0 orphan(formula_comps→formulas/comps, component_prices→comps, product_price_formulas→formulas). 라이브 read-only: siz_cd **99/99**·mat_cd **10/10**·prd_cd **45/45**·CLR_000002/000005 실존·PRC_COMPONENT_TYPE.01~05 실존·FRM_TYPE.01/02 실존·**.06 부재(0)→단계00 코드선적재 대상**. 순서 00→05 위상정렬 유효(사이클·미해결부모 0). 대상 테이블 라이브 **0행**(PK 충돌·중복적재 위험 0). |
| **G6** DRY-RUN | **PASS(로컬 제약검사) — 라이브 DRY-RUN 보류** | 로컬 제약 계산(columns/DDL + read-only FK 룩업) 전건 0 위반(G3/G4/G5). **라이브 롤백전용 DRY-RUN은 사용자 미승인으로 미실행**(쓰기 트랜잭션 회피·HARD). stale-ref 가드: 실적재 직전 라이브 export 재확증 선결. |
| **G7** 차단/에스컬레이션 명시 | **PASS** | 차단 2,697행 7군(`blocked-and-gaps.md §A`)이 사유(placeholder siz_cd) + 해소조건("후니가 siz_cd를 t_siz_sizes에 등록")과 함께 명시. 군별 분할 **독립 재현 일치**(GUK4 870/3JEOL 304/STK 456/POSTER 680/ACRYL 237/GP 110/ENV 40 = 2,697, distinct siz 285). GAP 1건(박 2단룩업) 에스컬레이션. 재구성 2,108+2,697=4,805 무손실. |
| **G8** 재현성 | **PASS** | `assemble_price_bundle.py` 재실행 → 적재본 **byte-identical**(`diff -rq` IDENTICAL, idempotent). 상위 앵커 `transform_price_sheets.py`·`extract_price_sheets.py`. 손편집 전용 산출물 0. |
| **G9** 독립 검증 | **PASS** | 검증자(dbm-validator) ≠ 빌더(dbm-load-builder). 적대적 검증으로 실 발견 ≥1 도출(F-1 카운트 정합·F-2 mat/clr 카운트 부정확). 인용 소스라인·라이브 쿼리·튜플대조로 빌더 주장 전건 실증(인용 날조 0). |

---

## 발견(Findings)

- **[MINOR — RESOLVED] F-1** `load-manifest.md:101` / HANDOFF — **2,106 vs 2,108 카운트 차이**.
  - 위반 아님(정합 확인). validation-final §C(line 147-149): 2,108 = 실코드 1,313 + NULL 795(raw), **2,106 = 2,108 − 2**(B-FINAL-1 comp_cd 길이초과 2행, round-2 검증시점 BLOCKER). 현 적재본은 **길이초과가 해소**(comp_cd maxlen=41, overflow=0 독립확증)되어 그 2행이 적재가능으로 전환 → **2,108이 정확**. 매니페스트 §4 정직표기와 일치.
  - 수정 불요. 라우팅: 없음(빌더 자기보고 정확).

- **[MINOR] F-2** `load-manifest.md:55-56` §2 "FK 부모 라이브 확증" 표의 카운트 부정확.
  - 위반: insertable component_prices의 **distinct mat_cd = 10**(매니페스트 "12"), **distinct clr_cd = 0**(insertable 행은 전건 clr_cd 공란). CLR_000002/000005는 **차단(blocked) 행에만** 출현. 라이브 실존(10/10·2/2)이라 **FK 적재 위험 없음** — 문서 카운트만 부정확.
  - 제안 수정: 매니페스트 §2 표를 "mat_cd 10/10(insertable)" "clr_cd 2/2(blocked 행 해소 후 적용)"로 정정.
  - 라우팅: **dbm-load-builder**(매니페스트 표기 보정, 적재본 데이터 변경 없음).

- **[INFO] F-3** `columns.csv`는 t_prc_* 미수록(12 t_테이블만, 가격엔진 신설 이전 스냅샷·stale). G4 권위를 라이브 `price-engine-ddl-raw.txt`(2026-06-06 추출)로 대체 사용. 차후 columns.csv 재추출 권장(검증엔 영향 없음).

> **BLOCKER·MAJOR 발견 0.** 적재본의 데이터 무결성 결함은 발견되지 않음(타입/길이/NOT NULL/CHECK/PK/FK/자연키/under-load/발명/dodge 전건 무결). 발견은 모두 문서표기 수준(MINOR) 또는 정합확인(RESOLVED).

---

## 적재 가능성 요약

| 분류 | 행수/건수 | 행선지 | 상태 |
|------|----------|--------|------|
| 즉시 적재가능 | **2,319행** | `load/00~05_*.csv` | 로컬 제약검사 + 라이브 FK 전건 PASS |
| └ 단계별 | code 1 + 공식 10 + 구성요소 143 + 배선 13 + 단가 2,108 + 상품바인딩 45 | — | — |
| 차단(후니 siz 등록 대기) | **2,697행** | `blocked-and-gaps.md §A`(7군·285 distinct siz) | placeholder siz_cd, 발명 아님·정당 blocker |
| GAP(무손실 표현 불가) | **1건**(0행 산출) | `blocked-and-gaps.md §B`(박 2단룩업) | 에스컬레이션(후니 모델링 결정 선결) |
| 코드행 선적재 제안 | **1건** | `code-row-preload.md`(`PRC_COMPONENT_TYPE.06 완제품비`) | 라이브 부재 확증(0), 후니 등록 대상 |

- **재구성 무손실**: component_prices 2,108(적재) + 2,697(차단) = 원본 4,805. 침묵드롭 0.
- 코드행 .06에 의존하는 price_components **91행** 확증(comp_typ_cd 분포 .01=15/.02=2/.04=33/.05=2/**.06=91**).

---

## 사용자 에스컬레이션 (본 하네스 권한 밖 — 인간/후니 결정)

1. **코드행 선적재** — `PRC_COMPONENT_TYPE.06 완제품비` 1행 후니 등록(`t_cod_base_codes` INSERT, DDL 무변경). 단계02의 91 구성요소 + 연쇄 단가가 의존.
2. **siz 등록 7군 (2,697행 해소)** — 국4절(870)·3절(304)·STK(456)·POSTER(680)·ACRYL(237)·GP(110)·ENV(40). 후니가 `t_siz_sizes` 등록(또는 POSTER·ACRYL은 면적함수 방식 결정).
3. **박 GAP 모델링** — 2단 룩업(면적→분류등급→가격) 정착지 후니 택일(신규 차원/면적함수/기존차원 재해석). 동판비만 우선 처리 옵션 병기.
4. **라이브 롤백전용 DRY-RUN(G6)** — 사용자 승인 시 실행. 실적재 직전 라이브 export 재확증 선결.
5. **실제 INSERT 실행** — 1·2 충족 + 인간 승인 후(본 트랙은 산출·게이트까지).
