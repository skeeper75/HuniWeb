# NOT-DDL / DEFER 라우팅 — search-before-mint 결과 (round-5)

> goal-2026-06-06-02 §5(제안 금지: 기존 구조로 해결 가능한데 새로 만들면 search-before-mint 위반) ·
> §11(차단의 정직한 표기) 준수. round-4 GAP/BLOCKED 후보 중 **신규 엔티티가 필요 없음이 입증된**
> 항목과, **현 시점 제안이 정당하지 않은(DEFER)** 항목을 사유·라우팅과 함께 명시한다(침묵 누락 0).

---

## A. NOT-DDL — 기존 구조로 무손실 표현 가능 (DDL 제안 금지)

### A-1. addon template 부재 (4행) — **데이터/등록 GAP, 스키마 GAP 아님**
- **round-4 항목:** `_assembled/blocked-and-gaps.md §2` (PRD_000016·018·135·217의 addon 4행).
- **search-before-mint:** 라이브 `cpq-schema.md §1.2` — `t_prd_templates`(테이블)·`t_prd_product_addons.tmpl_cd → templates`(FK) **이미 구현·정합**. templates **11행 실재**(001·002·004·005·006·009·012·013·014·281·282). 차단 원인 = addon 대상 상품 **PRD_000003·008·015용 template 행이 미등록**(데이터 부재)일 뿐.
- **판정:** 테이블·FK·모델 전부 정상. **스키마는 충분, 행만 없음** → 신규 엔티티 불요.
- **라우팅:** 후니가 `t_prd_templates`에 `TMPL-PRD_000003`·`008`·`015` **행 등록**(또는 라이브 addon 모델 재확인 후 round-3 매핑 정정) → 4 addon 행 적재가능. **dbm-load-builder**(코드행/데이터 선적재 step)·**검증자/디자이너**(매핑 재확인) 담당.
- ❌ DDL 제안하면 R4 FAIL(이미 있는 t_prd_templates 중복 mint = SIZ_000506 재발).

### A-2. 레이저커팅 proc_cd 신설 (14행) — **코드행 선적재**
- **round-4 항목:** `_assembled/blocked-and-gaps.md §1` · `code-row-preload.md §1`.
- **search-before-mint:** `t_proc_processes`(테이블·컬럼·FK) 정상. 차단 원인 = `PROC_000084 레이저커팅` **코드값(행) 부재**.
- **판정:** enum 값 1개 추가 = 사다리 1단계(코드행). **스키마 변경 0.**
- **라우팅:** 후니가 `t_proc_processes`에 `PROC_000084` 등록(`code-row-preload.md §1` 권위) → 아크릴 완칼 14행 승격. **dbm-load-builder**(코드행 선적재 SQL 00_*.sql).

### A-3. sticker 066 합판도무송 원형 size (11행) — **코드행 선적재**
- **round-4 항목:** `_assembled/blocked-and-gaps.md §3` · `code-row-preload.md §2`.
- **search-before-mint:** `t_siz_sizes` 정상. 원형 10종은 **실치수(cut_width/height) 보유**(L1 추출, 발명 0) → 기존 치수 마스터가 무손실 수용. 원형35x35는 라이브 `SIZ_000422` 재사용(중복 mint 회피, round-4 보정 반영).
- **판정:** 치수 실재 → 사다리 1단계(코드행, SIZ_000501~510). **스키마 변경 0.**
- **라우팅:** 후니가 `t_siz_sizes`에 SIZ_000501~510 등록 → 066 원형 11행(신설 10 + 재사용 1) 승격. **dbm-load-builder**.
- ⚠ 비치수 size(§5)와 혼동 금지: sticker 066은 **치수 실재**(코드행), goods-pouch 47상품은 **치수 미확정**(DDL — `ddl-proposal-goods-pouch-nondim-size`).

### A-4. 가격 §A siz 등록 7군 (2,697행) — **코드행/데이터 선적재**
- **round-4 항목:** `_assembled_price/blocked-and-gaps.md §A`.
- **search-before-mint:** `t_siz_sizes`·`t_prc_component_prices` 정상. 차단 원인 = 국4절/3절/STK/POSTER/ACRYL/GP원형/ENV 규격이 라이브 미등록(placeholder `SIZ_PENDING_*`). round-2가 실코드 선탐색 후 부재만 placeholder(dodge 0).
- **판정:** 면적좌표 siz는 **실치수**(가로×세로) → 치수 마스터가 수용. 사다리 1단계(코드행, 다량). **스키마 변경 0.**
- **라우팅:** 후니가 7군 siz_cd 등록 → placeholder 치환 → 재조립(`assemble_price_bundle.py`). **dbm-load-builder**.
- > 단, POSTER/ACRYL 면적군은 후니가 "좌표 siz_cd 방식 vs 면적함수 방식" 선택 여지 있음(등록 규모 차이). 면적함수 채택 시에도 이는 **siz 등록 정책**이지 박류 같은 중간키 GAP은 아님(직접 면적→가격, 등급 단계 없음).

---

## B. DEFER — 현 시점 DDL 제안이 정당하지 않음 (제안 보류)

### B-1. sticker 058~062 형상 enum 축 귀속 — **DEFER (D-2 설계 컨펌 선행)**
- **round-4 항목:** `code-row-preload.md §3`("축 귀속 미확정 → 미제안") · `sticker/load-spec.md §R2(B)`.
- **search-before-mint:** 058~062 `커팅` 컬럼이 형상 enum 본체(원형 25~90mm 10종 등 + A4/A5 분기). 라이브: size=판형(A4/A5)만, process=스완 조각수만 → **형상 축 자체 부재**.
- **왜 DEFER인가:** 축 **귀속이 3안 미결**(ⓐ size 보조 vs ⓑ plate 메타 vs ⓒ 신규 축 테이블). 그중 ⓐ/ⓑ는 **기존 구조 재사용(DDL 불요)** 가능성이 남아 있다. 귀속 결정 전 신규 테이블을 미는 것은 "GAP에 묶이지 않은 추측 제안"(goal-02 §5 금지·`ddl-proposal-method.md §9` 안티패턴). **D-2 컨펌이 인간 설계 결정**이라 search가 아직 "불가 입증"에 도달하지 못함.
- **라우팅:** 후니 **D-2 축 귀속 컨펌** 선행 → ⓒ(신규 축)로 확정되면 그때 DDL 제안(코드그룹 + 형상 차원). ⓐ/ⓑ면 NOT-DDL. **dbm-validator/디자이너**(D-2 컨펌)·이후 재진입.

### B-2. 책등(book-spine) param 슬롯 — **DEFER (round-5 GO-번들 범위 밖 + 사다리 3 우선)**
- **위치:** `09_load/photobook/_deferred/gpb4_chaekdeung_param_spec.csv` — **`_deferred/`**(소스/설계 GAP). round-4 `blocked-and-gaps.md`(상품마스터·가격) **양쪽에 미포함**.
- **범위 판정:** goal-02 §4 "round-4가 GO하지 않은 매핑은 round-5 진입 불가". 책등 param은 GO 번들의 차단/GAP이 아니라 deferred → **round-5 DDL 제안 범위 밖**(현 시점 보류).
- **search-before-mint (참고):** 마스터 `t_proc_processes.prcs_dtl_opt jsonb`에 "책등(number,mm)" param **이미 존재**(`_live-schema-dump-260606.txt` line 311). 부족분은 **상품별 선택지**(하드 10/12/14/16 vs 소프트 4/6/8/10/12/14)를 담을 *상품 레벨* 슬롯. 후보 = 기존 JSONB 키 추가(사다리 3) 또는 CPQ option_items qty/ref. 즉 **신규 테이블이 아닐 가능성이 높음**.
- **연관:** `cpq-schema.md §5` 미해결 🔴 `ref_param_json` 부재(공정 파라미터 보존)와 동일 축의 문제. 책등 param은 그 일반 결정(ref_param_json 재제안 vs qty vs 별도 공정행)에 종속.
- **라우팅:** ① 책등이 round-5 GO 범위로 승격되거나 ② CPQ ref_param_json 결정이 내려질 때 재평가. 현재는 **DEFER**(deferred 권위 = `09_load/photobook/_deferred/` + D-PB-2 컨펌).

### B-3. 박 동판비(B01) — **NOT-DDL (기존 6차원 ADEQUATE)**
- 박 *가공비*(2단 GAP)와 구분. 동판비 B01 = 가로×세로→단가 2D 매트릭스 = 아크릴형 ADEQUATE.
- **판정:** 기존 `t_prc_component_prices`(siz_cd=면적좌표, min_qty)로 직접 평면화 가능. 등급축 불요 → DDL 불요.
- **라우팅:** GAP(박 가공비) 결정 후 동판비는 즉시 ADEQUATE 처리. **dbm-load-builder**(siz 등록 후).
