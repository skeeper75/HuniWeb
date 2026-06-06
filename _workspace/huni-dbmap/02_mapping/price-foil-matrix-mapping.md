# 박(foil) 가격 매핑 — 면적매트릭스형 (등급 폐기·면적 환원)

> **트랙**: round-2 가격 — 후가공_박(소형+대형). **장기 미해결 박 GAP 종결.**
> **권위 입력**: `06_extract/price-foil-small-l1.csv`·`price-foil-large-l1.csv`(+meta) — 엑셀 명시값.
> **스키마 권위**: `00_schema/price-engine-ddl.md`(라이브 pg18.4 DDL) · dbm-price-formula skill 규칙①~⑩.
> **HARD**: DB 쓰기·COMMIT·DDL 0. 설계 + 적재 CSV만. 자가검증(recompute) 미실시(검증=dbm-validator 독립).
> **산출**: 본 문서 + `02_mapping/load_price/_foil/*.csv` (생성기 `scripts/gen_foil_load.py`, 재현성).

---

## 0. KEY DIRECTIVE — 등급 소멸 (사용자 결정, 본 설계의 축)

후니(프로젝트 오너) 결정: **박등급 A~E는 본질 가격 차원이 아니라 "엑셀 한계상 실무자가
만든 편의 표현"이다.** 따라서:

- 등급 글자(A~E)를 **DB 어느 컬럼에도 싣지 않는다** (mat_cd 차용 금지, 신규 등급컬럼 금지).
- 가격표 구조 + 라이브 `t_prc_*` 엔티티/속성을 이해한 뒤, 박을 **본질 차원(면적·박종·수량)**으로
  환원하고 **등급은 조인 키로만 소멸**시킨다.

이를 위해 박 시트의 2단 룩업을 **1단 조인**으로 평면화한다:

```
  B02 (면적→등급)  ⋈  B03 (등급×수량→가격)   on  grade
  ──────────────────────────────────────────────────────
  결과: (가로, 세로, 수량) → 가격     [등급은 결과에 미포함]
```

이 조인이 사용자가 요청한 **핵심 동작**이다. 등급은 `(가로,세로)→등급`과 `등급→가격`을
잇는 **중간 키**일 뿐이며, 적재 결과에는 면적좌표(siz_cd)·박종(comp_cd)·수량(min_qty)만 남는다.

---

## 1. 박 시트 구조 (L1 검증)

소형/대형 각각 논리블록 3종(+동판):

| 블록 | 의미 | 구조 | 처리 |
|------|------|------|------|
| **B01 동판비** | 1회성 셋업(아연판) | 소형=단일셀(80x40→5000) / 대형=가로×세로 8×8 매트릭스 | 자체 ADEQUATE 구성요소(`COMP_FOIL_DIE_*`). 수량무관(min_qty NULL) |
| **B02 면적→등급** | `[가로][세로]` 2D 매트릭스, **셀값=등급 A~E** | 소형 axes {10,20,40,60,80}mm(가로 3행×세로 5열, 14좌표) / 대형 {30,50,…,170}mm(8×8, 64좌표) | **엑셀 한계물.** 조인 키로만 사용 → 소멸 |
| **B03 등급×수량→가격** | `[수량][등급A~E]` → 가격 | 소형 18수량밴드 / 대형 13밴드 | B02와 등급 조인 → `(면적,수량)→가격`. siz_cd·min_qty로 적재 |

박종 (동일가 그룹):

| 구분 | 박종 (동일 단가 공유) | comp_cd |
|------|----------------------|---------|
| 소형 일반박 | 금유광·은유광·먹유광·청박·적박·동박·펄박 (7종) | `COMP_FOIL_SMALL_GENERAL` (1 shared) |
| 소형 특수박 | 백박·홀로그램박·트윙클박 (3종) | `COMP_FOIL_SMALL_SPECIAL` (1 shared) |
| 대형 일반박 | 금유광·금무광·은유광·은무광·동박·청박 (6종) | `COMP_FOIL_LARGE_GENERAL` (1 shared) |
| 대형 특수박 | 먹유광·백박·홀로그램·트윙클·적박·녹박 (6종) | `COMP_FOIL_LARGE_SPECIAL` (1 shared) |

> 동일가 박종은 단가표를 **공유**하므로 박종마다 행을 복제하지 않고 **1 comp**로 흡수한다.
> 실제 박종 enum은 comp note에 기록(완전성 추적). 박종 선택 자체는 상품옵션
> (`t_prd_product_processes`, `PROC_000033 박`+자식)에서 표현 — 본 단가 매핑은 가격만 담당.

---

## 2. 박 = 면적매트릭스형 (엔진 배선)

박은 실사/현수막/아크릴과 **같은 면적매트릭스형**이다. 라이브 면적매트릭스(`PRF_POSTER_FIXED`)가
쓰는 **`FRM_TYPE.02 단순형`을 재사용**한다(전용 면적형 FRM_TYPE 신설 불요 — G-3 모델링 결정).

### source→target 컬럼 매핑 (`t_prc_component_prices`, 6차원 엔진)

| 본질 차원 | DB 컬럼 | 값 | 근거 |
|-----------|---------|----|----|
| 박종 | `comp_cd` | `COMP_FOIL_{SMALL/LARGE}_{GENERAL/SPECIAL}` / `COMP_FOIL_DIE_{SMALL/LARGE}` | 박=공정(규칙①), 동일가→1 comp. 카탈로그=`t_prc_price_components`, comp_typ=**`.05 박형압비`** |
| **면적좌표** | `siz_cd` | 가로×세로 좌표 siz (search-before-mint, §3) | 박 스탬프 면적 envelope. 등급의 본질 환원처 |
| 수량 | `min_qty` | B03 수량밴드 (동판=NULL) | 수량구간 하한·상향개방(C-3). 동판=수량무관 |
| 가격 | `unit_price` | B02⋈B03 조인가 (동판=동판단가) | numeric(12,2). 엑셀 명시값 verbatim |
| 도수 | `clr_cd` | **NULL(공란)** | 규칙①: 박은 clr 아님(FK 위반 방지) |
| 자재 | `mat_cd` | **NULL** | 박종 동일가→comp 흡수, 자재 무관 |
| 코팅면수 | `coat_side_cnt` | **NULL** | 코팅 무관 |
| 묶음 | `bdl_qty` | **NULL** | 묶음 무관 |
| 시계열 | `apply_ymd` | `2026-06-01` | 규칙⑦ 단일 go-live(yyyy-MM-dd) |

> **등급 소멸 확증**: 적재 컬럼 어디에도 A~E 없음 (grade-leakage check = **0**, §5).

### 공식 + 배선

- **`t_prc_price_formulas`**: `PRF_FOIL_AREA` (frm_typ_cd=`FRM_TYPE.02`).
- **`t_prc_formula_components`**: 6 구성요소(가공비 4 + 동판비 2) 배선, `addtn_yn='Y'`
  (합산: 박가공비 + 동판셋업비). disp_seq 10~60.
- **off-grid ceiling = 앱 런타임**: 정확한 가로×세로가 매트릭스에 없으면 **한 단계 큰 크기 가격**을
  앱(위젯/엔진)이 적용한다. **DB는 매트릭스 셀(좌표 단가)만 저장**한다(보간/올림 미저장 — 사용자
  아키텍처 원칙, memory `dbmap-compute-in-app-db-stores-lookup`).

---

## 3. siz 매핑 — search-before-mint

79 distinct 좌표(가로×세로)를 라이브 `t_siz_sizes`(500행)와 양방향 대조:

| 결과 | 종수 | 비고 |
|------|:----:|------|
| **EXACT 재사용** | 21 좌표 (20 distinct siz) | cut/work 치수 WxH 정확매칭 |
| **REVERSED 재사용** | 5 좌표 (5 distinct siz, 4는 EXACT siz 별칭) | HxW 역방향. 박 면적=방향무관(스탬프 envelope)이라 정당 — **FLAG-1** |
| **MINT 신규** | 53 좌표 → `SIZ_000722 ~ SIZ_000774` | 라이브 부재 확증. 면적직접입력형(margin0, impos_yn=N) |
| **합계 distinct siz** | **74** | 26 재사용 + 53 신규 (REVERSED 별칭 수렴 반영) |

- **신규 siz 번호 조율 (HARD)**: `09_load/_migrate_areamatrix/MIGRATION.md §10` 준수.
  면적매트릭스가 `SIZ_000511~721` 점유 → 박은 **`SIZ_000722`부터** 발급(충돌 0).
  후속 트랙은 `SIZ_000775` 이후.
- **53 신규 siz 등록 = 후니 master-data 결정** → **FLAG-2**(준비만, COMMIT=인간 승인).
  `siz_nm='WxH'`(라이브 컨벤션 일관), 치수=박 좌표 데이터에서만(발명 0).

---

## 4. 적재 순서 (FK 위상정렬)

```
[0] (검증만, 선존재) t_cod_base_codes(PRC_COMPONENT_TYPE.05, FRM_TYPE.02 — 라이브 확증 존재)
                    t_prd_products
[1] t_siz_sizes (신규 53 좌표 — FK 부모, component_prices보다 선행)   ← FLAG-2 승인 대상
[1] t_prc_price_formulas (PRF_FOIL_AREA)          ┐ 병렬
    t_prc_price_components (COMP_FOIL_* 6)         ┘
[2] t_prc_formula_components (6 배선)              ┐ 병렬 (frm/comp 선존재)
    t_prc_component_prices (2143 단가, siz/comp 선존재)
[3] t_prd_product_price_formulas (바인딩)          ← FLAG-3: 대상 미확정(빈 CSV)
```

> `.05 박형압비`·`FRM_TYPE.02`는 라이브 선존재(코드행 INSERT 불요 — 검증으로 확인).
> `.06 완제품비`도 이미 라이브 등록됨(과거 schema-fitgap의 "신설 필요"는 stale).

---

## 5. G7 무손실 — 전수 회계 (loss accounting)

| source 가격셀(등급압축형, L1 권위) | 수 |
|------------------------------------|:--:|
| B03 소형 일반(수량18×등급5) | 90 |
| B05 소형 특수(18×5) | 90 |
| B03 대형 일반(수량13×등급5) | 65 |
| B05 대형 특수(13×5) | 65 |
| B01 소형 동판(단일셀) | 1 |
| B01 대형 동판(8×8) | 64 |
| **합계 source price cells** | **375** |

| 등급소멸 조인 후(면적전개형) → `component_prices` | 수 |
|---------------------------------------------------|:--:|
| 소형 일반 14좌표×18수량 | 252 |
| 소형 특수 14×18 | 252 |
| 대형 일반 64×13 | 832 |
| 대형 특수 64×13 | 832 |
| 동판(소형1+대형64) | 65 |
| **raw 합계** | **2233** |
| − REVERSED 동일가 collapse(자연키8 충돌, 전건 SAME-PRICE, 무손실) | −90 |
| **적재 component_prices 행** | **2143** |

- **조인 완전성**: unmatched join = **0** (모든 등급셀이 가격에 매칭, 누락 수량 0).
- **REVERSED collapse**: `(가로W,세로H)`와 `(가로H,세로W)`가 동일 siz_cd로 수렴 시 자연키8 중복.
  박 면적가는 면적만으로 결정(방향무관) → **전건 가격 동일**(price conflict=0 사전 assert).
  무손실 collapse(첫 행 유지 + note `[+REVERSED흡수동일가]`). 가격충돌 1건이라도 있으면 STOP(발생 0).
- **grade-leakage check**: A~E가 적재 컬럼(comp_cd/siz/clr/mat/coat/bdl/min_qty/unit_price)에
  출현 **0** (등급은 조인 키로만 소멸).
- **자연키8 중복(C-2)**: dedup 후 **0**.

### worked examples (설계 자가추적 — recompute 검증은 validator 별도)

| # | 입력 | B02 등급 | B03/동판 가격 | 적재행 |
|---|------|----------|---------------|--------|
| EX1 | 소형일반 10×80 q200 | C | (200,C)=16400 | siz=10x80 q200 → **16400** ✓ |
| EX2 | 대형일반 170×170 q10000 | E | (10000,E)=2000000 | → **2000000** ✓ |
| EX3 | 대형동판 50×130 | — | 15000 | min_qty=NULL → **15000** ✓ |
| EX4 | 소형특수 40×40 q500 | D | (500,D)=44900 | → **44900** ✓ |

---

## 6. 제안 코드 (price-code-proposals 보강 대상)

| 종류 | 코드 | 유형 | 비고 |
|------|------|------|------|
| formula | `PRF_FOIL_AREA` | FRM_TYPE.02 | 박 면적매트릭스 공식(실사/아크릴 패턴 재사용) |
| comp | `COMP_FOIL_SMALL_GENERAL` | .05 박형압비 | 소형 일반 7종 동일가 |
| comp | `COMP_FOIL_SMALL_SPECIAL` | .05 | 소형 특수 3종 |
| comp | `COMP_FOIL_LARGE_GENERAL` | .05 | 대형 일반 6종 |
| comp | `COMP_FOIL_LARGE_SPECIAL` | .05 | 대형 특수 6종 |
| comp | `COMP_FOIL_DIE_SMALL` | .05 | 소형 동판 셋업 |
| comp | `COMP_FOIL_DIE_LARGE` | .05 | 대형 동판 셋업 |
| siz | `SIZ_000722~774` (53) | 좌표 siz | MINT(라이브 부재). FLAG-2 |

> 기존 `COMP_NAMECARD_FOIL_*`(명함 임베드 박)과 **별개** — 본 트랙은 standalone 후가공_박 add-on.

---

## 7. FLAG — 결정/확인 필요 (침묵 처리 금지)

| # | 항목 | 내용 | 권고 |
|---|------|------|------|
| **FLAG-1** | REVERSED siz 재사용 5종 | 박 면적은 방향무관이라 HxW siz 재사용 정당(전건 SAME-PRICE). 단 가로/세로 의미축을 엄밀 보존하려면 후니 재검토 여지(areamatrix AM-1과 동일 성격). | 면적 동일성으로 채택. 의미축 엄밀화 원하면 5종 별도 mint로 전환 가능 |
| **FLAG-2** | 신규 53 좌표 siz 등록 | `SIZ_000722~774` = 후니 master-data 신규 좌표 추가 결정. 준비만(COMMIT=인간 승인). | areamatrix 211좌표 등록과 동일 절차. 치수=박 데이터 verbatim(발명 0) |
| **FLAG-3** | **공식 바인딩 대상 미확정** | 라이브에 **standalone "후가공_박" product 부재**. 유일 박관련 product=`PRD_000037 오리지널박명함`은 명함 임베드 박(`COMP_NAMECARD_FOIL_*`로 별도 처리)이라 `PRF_FOIL_AREA` 바인딩 부적합. 후가공_박은 **add-on 가공 서비스**(독립 상품 아님)일 가능성. | `t_prd_product_price_formulas.csv` **빈 채로 산출**(발명 금지). 박을 add-on으로 거는 product(들)을 후니가 지정해야 바인딩 완성. CPQ add-on 템플릿(`t_prd_*` 옵션) 연계 후보 |
| FLAG-4 | comp_typ 단정 | 박 동판비를 `.05 박형압비`로 귀속(명함 `COMP_NAMECARD_FOIL_SETUP`=.05 선례 따름). 동판=셋업이지 가공압이 아니라는 이견 시 후니 확인. | .05 채택(박 계열 일관) |

---

## 8. 적재 가능성 진술 (검증 아님)

본 매핑은 **적재 준비 완료** 상태이다: 6 엔진 CSV + 53 siz mint CSV, 등급 0누출, 조인 완전(unmatched 0),
자연키 중복 0, 가격충돌 0, comp_price_id 라이브 부재 블록(9.1M) 충돌 0, FK 부모(.05/FRM_TYPE.02) 라이브
선존재 확인. **단 FLAG-2(siz 등록)·FLAG-3(바인딩 대상)은 인간 결정 전 적재 차단.**
무손실·정합 여부의 독립 재계산 검증은 **dbm-validator** 책임(본 설계는 자가검증하지 않음, R6/G9 독립성).
