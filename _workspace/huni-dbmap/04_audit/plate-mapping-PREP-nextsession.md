# 판형사이즈 매핑 — 다음 세션 준비 (PREP·작업 미실행)

> 작성 2026-06-22 · 하네스 = **§7 Huni-DBMap (`huni-dbmap-orchestrator`)** · 이번 세션은 **준비만**(사용자 지시: 작업은 다음 세션) · 라이브 읽기전용·DB 미적재.

## 0. 사용자가 정의한 목표 (이해 확정)

각 상품(군)에 필요한 판형사이즈를 가진 **엑셀 데이터를 분석 → 현재 라이브DB 판형정보와 일치하는지 먼저 정합 검증**한다. 핵심 = 소재별 판형 적용 여부 구분.

- **종이·스티커** = 판형(전지) 보유 → 출력용지규격(전지)으로 매핑 대상.
- **아크릴·실사 등** = 판형 개념 **N/A**(전지 모름) → 가격은 **가격표 가격테이블의 "출력사이즈"** 차원에 따라 변동(면적/완제품 모델). 판형 매핑 **제외**.
- 판형 판정 권위 = **라이브DB 사이즈정보 엔티티의 "판형여부" 속성**.

## 1. 라이브 스키마 grounding (이번 세션 실측 확인)

- **"사이즈정보 엔티티의 판형여부 속성" = `t_siz_sizes.impos_yn`**(character(1)·조판/임포지션 여부). 전지 = `impos_yn='Y'` & work 치수가 전지치수인 행(예 `SIZ_000499` work 316x467 국전계열·`SIZ_000498` work 317x440). 출처 `00_schema/_live-schema-dump-260606.txt`·`08_remediation/plate-size-correction-design.md`.
- **상품↔판형 매핑 = `t_prd_product_plate_sizes`**(prd_cd × siz_cd · `output_paper_typ_cd` FK→t_cod_base_codes 국전/46계열 · `dflt_plt_yn` 기본판형 · del_yn). 509행/494활성. FK: prd_cd→t_prd_products·siz_cd→t_siz_sizes.
- 가격축(아크릴·실사) = `t_prc_component_prices` use_dims `siz_width`/`siz_height` 면적매트릭스(§18 종단 정합) — 판형 아님.

## 2. ★이미 완료된 선행 작업 (재발견·재론 금지)

이 매핑은 round-3 정합 검증 + 2026-06-07 확정 모델로 **상당 부분 이미 설계됨**. 다음 세션은 이 위에 이어가야 한다(처음부터 다시 X).

- **권위 확정 모델**: `08_remediation/plate-size-correction-design.md`(2026-06-07·"라이브 전수 규명 완료·재론 금지"). 이미 확정한 것:
  - 판형 = 출력용지규격(전지)이어야 진짜 판형사이즈. 현 라이브는 작업사이즈(cut+bleed) 중복행을 잘못 참조하는 상품 다수.
  - 전지 종류 라이브 전수 = 316x467(`SIZ_000499`·48제품) + 미지정(6~7제품·🔴 UNRESOLVED) + **전지 부재 154제품**(굿즈/실사/**아크릴 본체**/파우치/책자/포스터/포맥스 = 면적·완제품 모델·**전지 비적용=교정 제외**). ← **사용자의 "아크릴·실사=판형 N/A"와 정확히 일치**.
  - plate 494행 A~F 분류·제품별 전지 확정표(`08_remediation/csv/plate-correction-per-product.csv`)·행별 교정 매핑(`csv/plate-correction-row-mapping.csv`)·작업사이즈 중복행 219 처리표(`csv/worksize-duplicate-disposition.csv`).
  - 신규 전지 siz 제안 0(316x467=SIZ_000499 라이브 선존재·search-before-mint 통과). 가격(component_prices siz_cd=SIZ_000499 870행)과 동일 전지 권위 공유 → 정합.
  - 부속 설계: `plate-load-from-master-design.md`·`plate-price-unify-design.md`·`plate-size-remodel-design.md`(공존판=폐기).
- **round-3 정합 검증**: `04_audit/plate-size-parity.md`(엑셀 출력용지규격=전지 vs DB=작업사이즈 의미축 불일치 발견·4분류)·`plate-size-mismatches.csv`.
- **현황 진단(폐기·인용금지)**: `plate-size-live-diagnosis.md`(프리미엄엽서 오등록 오판 → 확정 모델로 대체됨).
- **추출 자산**: `00_schema/ref-product-plate-sizes.csv`(509행)·`00_schema/live-plate-sizes-full.csv`(494행 전수)·`04_audit/excel-plate-size.csv`(54상품 출력용지규격 값보유·전지 316x467 등).
- **적재 스크립트**: `09_load/_migrate_plate_load_guk4`(국4절 32상품 plate 적재 완료·커밋 c722c24).
- 메모리: [[dbmap-platesize-is-output-paper]]·[[dbmap-output-plate-mapping]].

## 3. ★다음 세션이 새로 더할 것 (사용자 신규 프레이밍)

기존 모델은 디지털인쇄(전지 316x467) 중심. 사용자 요청의 신규 각도:
1. **엑셀 각 상품(군)별 "필요 판형사이즈" 전수 분석** → 라이브 `t_prd_product_plate_sizes`/`t_siz_sizes.impos_yn` 현황과 **소재구분 반영 정합 검증**(종이·스티커=판형 대조 / 아크릴·실사 등=판형 N/A 확인·가격표 출력사이즈 차원으로 회수).
2. **상품군 단위 커버리지**(11 상품군 × 판형 적용/비적용 매트릭스) — 기존은 제품행 단위. 종이·스티커 외 전지 종류(스티커팩·반칼전지 등 부재 5종)·미지정 6~7제품(🔴 UNRESOLVED) 결판.
3. 검증 결과 = 정합/불일치 보드 → (불일치 시) 기존 확정 모델 교정안과 대조·차이만 보강. **DB 미적재**(실 적재 인간 승인 후).

## 4. 다음 세션 시작점 (라우팅)

`huni-dbmap-orchestrator` 호출 → 다음 순서:
1. `dbm-schema-extract` — `t_siz_sizes`(impos_yn)·`t_prd_product_plate_sizes` 라이브 현황 재실측(추출본 stale 회피). + 기존 `08_remediation` 확정 모델 로드.
2. `dbm-excel-parse` / `dbm-excel-analyst` — 상품마스터 "출력용지규격" 컬럼 + 가격표 "판걸이수"·"출력소재" 시트 전수 추출(상품군별 필요 판형).
3. `dbm-correctness-audit` 또는 `dbm-mapping` — 소재구분 반영 엑셀↔라이브 정합 검증(종이·스티커=판형 / 아크릴·실사=N/A→가격표 출력사이즈 회수)·상품군 커버리지 매트릭스·불일치 보드.
4. 불일치분 = 기존 확정 모델(`plate-size-correction-design.md`) 교정안과 대조 → 차이만 라우팅(실 적재는 인간 승인 후 `dbm-load-execution`).

## 5. 안전·권위 [HARD]

- 권위 = 상품마스터 출력용지규격 컬럼 + 인쇄상품 가격표(절대). 라이브 = 교정 대상(현황). v03/STALE·`plate-size-live-diagnosis.md` 인용 금지.
- 라이브 `.env.local RAILWAY_DB_*` 읽기전용 SELECT만. **DB 미적재**(실 INSERT/UPDATE/DDL은 인간 승인 후 dbmap 적재 트랙 위임). 비밀값 비노출.
- 신규 siz 채번 금지 우선(search-before-mint·전지는 라이브 plate_sizes/impos_yn=Y 재사용). 아크릴·실사 판형 신설 금지(가격축=가격표 출력사이즈).
