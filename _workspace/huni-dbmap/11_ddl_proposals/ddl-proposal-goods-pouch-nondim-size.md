# 제안: goods-pouch 비치수(non-dimensional) size 마스터

- **닫는 GAP:** `09_load/_assembled/blocked-and-gaps.md §5` (D-1, BLOCKER 본질) · 승격 행수: **goods-pouch active 47상품** (reference 96행 / distinct prd_cd 54 중 active=47)
- **판정:** DDL-NEEDED · **사다리 단계:** 4단계(신규 테이블) + 1단계(코드그룹)
- **권위:** goal-2026-06-06-02 §5(제안 경계)·R4 · `ddl-proposal-method.md` §6(비치수 size)·§4(사다리)
- **적용:** propose ≠ apply — **인간 승인 필요**(라이브 CREATE 금지)

---

## 1. GAP 본질 (round-4가 왜 GAP으로 남겼는가)

L1 `사이즈(필수)` 칸이 WxH 재단치수가 아니라 **이질적 이산 라벨**이다. 라이브 reference
(`09_load/goods-pouch/load/t_prd_product_sizes_BLOCKED.reference.csv`, 96 BLOCKED 행)에서
라벨 유형을 전수 집계하면:

| 유형 | 예시 | 비고 |
|------|------|------|
| 형상 | 원형 90mm·사각 90mm·하트·꽃·별·마카롱 | 형상축 + 단일치수 또는 무치수 |
| 용량 | 11온스·350ml·500ml | **선형치수 자체 없음** |
| 사이즈클래스 | S·M·L·XL·직사각M·정사각M·블랙M | 막연 등급(상품별 의미 상이) |
| 인쇄면/방향 | 단면·양면·가로형·세로형·전면만 인쇄 | 치수 아님 |
| 구성수 | 1구·2구·3구·4구·2개1팩 | 개수 |
| 기타 | 미니틴케이스·CD 커버 세트(미조립)·A4용/A5용 | 명목 라벨 |

→ 공통 치수축이 없는 **상품별 열거형 선택지**. 치수 마스터로는 표현 불가.

## 2. search-before-mint (HARD — 기존 구조 전수 탐색)

| 후보 구조 | 라이브 근거(read-only) | 무손실 가능? |
|-----------|----------------------|-------------|
| **t_siz_sizes** (siz_cd 재사용/신설) | `ref-sizes.csv` 497행 전수: **work·cut 치수가 모두 NULL인 순수 라벨 행 0건.** '정사각15x15mm'(SIZ_000213)·'원형35x35'(SIZ_000422)조차 W×H 실치수 보유. | ❌ 라벨을 siz로 담으려면 치수 발명 필요 = round-4가 명시 거부한 "비치수→치수 둔갑" |
| **t_prd_products.nonspec_*_min/max** | `_assembled/update-set/t_prd_products_nonspec_update.csv`: 라이브 사용처(아크릴 20~100, 현수막 500~1750) 전부 **연속 W×H 범위**. | ❌ 이산 열거 라벨을 min/max 쌍에 강제하면 형상/용량 의미 소실 + "상품당 단일 비규격 범위" 가정과 충돌(상품당 라벨 N개) |
| **t_cod_base_codes 자식 코드만** | enum 1~N 값이면 코드행으로 끝(사다리 1). | △ 라벨 *분류축*(형상/용량…)은 코드로 가능하나, **상품↔라벨 N:M 연결**과 라벨별 참고치수/용량을 코드행만으로는 못 담음 |
| **t_prd_product_option_items** (CPQ) | `cpq-schema.md §2` 트리거 `fn_chk_opt_item_ref`: ref_key가 가리키는 **차원 행(siz_cd 등) 선존재 강제**. | ❌ 라벨에 대응할 차원 행이 없으므로 옵션 항목도 라벨을 직접 못 담음(t_siz_sizes 벽과 동일) |

→ 4개 기존 구조 모두 무손실 실패가 **입증**됨. 신규 마스터가 최소 무손실 해법.

## 3. 설계 (컨벤션 정합)

3개 산출물(사다리 위→아래):
1. **코드그룹 `NONDIM_SIZE_KIND`** (사다리 1, 코드행) — 라벨 분류축(형상/용량/사이즈클래스/인쇄면/구성수/기타). 라이브 코드그룹 패턴(부모 1 + 자식 N) 추종. ※ 코드행이라 DDL 아님 — code-row 선적재로 다룸.
2. **`t_siz_nonspec_sizes`** (사다리 4, 신규 마스터) — 라벨 원문(`nsiz_nm`) + 분류(`kind_cd`) + 선택적 참고치수/용량. PK `nsiz_cd`(NSIZ_NNNNNN), `use_yn`/`del_yn`/`reg_dt`/`upd_dt` 라이브 관용 그대로.
3. **`t_prd_product_nonspec_sizes`** (사다리 4, 연결) — `t_prd_product_sizes`(siz_cd→t_siz_sizes)와 **동형 평행 연결**, PK (prd_cd, nsiz_cd).

**컨벤션 정합 근거:** 테이블명 `t_<dom>_<plural>` · PK `<dom>_cd VARCHAR(50)` · `use_yn CHAR(1) CHECK` · `del_yn`/`del_dt` 소프트삭제(전 도메인 관용, `_live-schema-dump-260606.txt`) · FK `<parent>_cd` 참조. 길이는 라이브 siz_cd(varchar50)·siz_nm(varchar50→라벨이 길 수 있어 100) 기준.

> **왜 t_siz_sizes에 `spec_yn` 컬럼 추가(사다리 2)가 아니라 신규 테이블인가:** t_siz_sizes는 재단/작업 치수·터잡기(impos)·여백을 가진 **치수 마스터**다. 비치수 라벨은 그 컬럼이 전부 무의미 NULL이 되어 의미축이 달라짐(치수 둔갑 위험 잔존). 별도 마스터가 정규화·관리 양쪽에서 정당. 단 후니가 "한 테이블 통합 + spec_yn 플래그"를 선호하면 사다리 2단계 대안도 가능(아래 §6).

## 4. 정규화 증명

- **무손실:** 라벨 원문(nsiz_nm) 보존 + 분류(kind_cd) + 참고치수/용량(있을 때만) → GAP 데이터 전 표현. round-4가 GAP으로 남긴 "치수 발명 없이 라벨 보관" 정확히 해소.
- **무중복:** t_siz_sizes(치수)와 의미 중복 0(비치수 전용). 같은 사실 이중 저장 없음.
- **함수종속 정합:** nsiz_cd → (nsiz_nm, kind_cd, 치수/용량) 완전종속. 연결표는 (prd_cd, nsiz_cd) → (dflt_yn, disp_seq) 완전종속. 부분/이행종속 신설 0.
- **참조무결성:** kind_cd→t_cod_base_codes, prd_cd→t_prd_products, nsiz_cd→t_siz_nonspec_sizes 전 FK 부모 실재.

## 5. 영향 분석

- **기존 행:** 신규 테이블 2개 — 기존 t_siz_sizes·t_prd_product_sizes·t_prd_products 행 **무영향**(ALTER 0).
- **FK:** 신규 FK 3종, 부모 전부 선존재 → 고아 0.
- **적용 순서:** 코드행(NONDIM_SIZE_KIND) → DDL(CREATE x2) → 라벨 마스터 행 → 연결행 47상품. round-5 `apply.sql`의 size-load(step NN) **이전**.
- **백필:** NOT NULL 신규 컬럼은 전부 신규 테이블 내부라 백필 불요.
- **롤백:** `DROP TABLE` x2(.sql 하단). 코드행은 선적재 롤백으로 별도.
- **닫히는 GAP:** 적용 + 후니 라벨 확정 후 goods-pouch **47상품** 비치수 size가 적재가능으로 승격.

## 6. 잔존 인간 결정 (자율 진행 금지)

1. **라벨→nsiz_cd 매핑 데이터 자체** = 후니 결정. 원천 라벨이 권위(추정 발명 금지). round-4 D-1이 명시한 모델링 정책 결정 지점.
2. **모델 형태 택일:** ⓐ 본 제안(전용 마스터, 정규화 우위) vs ⓑ t_siz_sizes + `spec_yn` 통합(사다리 2, 테이블 수 절약·치수 둔갑 위험). 본 제안은 ⓐ를 권장하되 ⓑ도 명시.
3. 적용은 후니가 라이브에 수행 — 제안과 적용 분리(propose ≠ apply).
