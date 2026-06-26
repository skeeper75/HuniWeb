# 디지털 흑백/칼라 축 오적재 + S2 미배선 교정 설계 (A2 C1 · codex CONFIRMED)

권위 = 인쇄상품 가격표 260527 디지털인쇄비 + 원본 백업 `raw/webadmin/sql/_backup_digital_clr_rows_20260617.json`(clr_cd 이력).
라이브 = 읽기전용 실측·DB 미적재. 실 COMMIT은 인간 승인. 산출: 이 문서 + `digital-clr-fix.sql` + `digital-clr-dryrun.sql`(둘 다 라이브에서 ROLLBACK 검증 완료).

---

## 1. 디지털 인쇄 가격 모델 정확 규명 (실측 기반)

### 1.1 원본 모델 (백업 = 진실): 면(comp) × 색(clr_cd)
백업 424행(`clr_cd IS NOT NULL`)이 원본 4단가를 명확히 표현:

| comp_cd | 의미 | clr_cd | 색 | 국4절 q1 | 3절 q1 |
|---|---|---|---|---|---|
| COMP_PRINT_DIGITAL_S1 | **단면** | CLR_000002 | 흑백(1도) | 3000 | 3500 |
| COMP_PRINT_DIGITAL_S1 | **단면** | CLR_000005 | 칼라(CMYK) | **4000** | **4500** |
| COMP_PRINT_DIGITAL_S2 | **양면** | CLR_000002 | 흑백(1도) | 4000 | 5000 |
| COMP_PRINT_DIGITAL_S2 | **양면** | CLR_000005 | 칼라(CMYK) | **6000** | **7000** |

즉 **S1=단면 / S2=양면 (면축)** × **clr_cd 흑백/칼라 (색축)** = 4단가. 가격표 260527 (국4절=B01, 3절=B02 블록)과 verbatim 일치.

### 1.2 마이그레이션이 모델을 붕괴 (근본원인)
`sql/28_price_dim_print_option.sql`이 `clr_cd → print_opt_cd` 차원전환을 하면서:
- (step1) `DELETE … WHERE clr_cd IS NOT NULL`로 424행 전량 삭제(백업 후).
- (step2) use_dims 토큰 `clr_cd → print_opt_cd` 치환.
- **그러나 print_opt_cd 는 '면(단면/양면)' 개념이지 '색' 개념이 아니다.** 색축을 면축에 욱여넣으며 재입력이 어긋남.

재입력 결과 **S1 하나에 212행만** 들어가고(S2는 어떤 공식에도 미배선 = 死), print_opt_cd로 분기:

| 현재 S1 print_opt | 라벨 의미 | 실제 보유 단가(국4절 q1) | = 백업의 무엇 | 결함 |
|---|---|---|---|---|
| POPT_000001 (단면) | 단면 | 3000 (흑백단면) | S1/CLR_000002 | **흑백단면** 값(칼라단면 4000 이어야) |
| POPT_000002 (양면) | 양면 | 4000 (q2=2800…) | S1/CLR_000005 **칼라단면** | note만 '양면', 값은 **칼라단면**(칼라양면 6000 이어야) |

→ S1/POPT_000001 = 흑백단면, S1/POPT_000002 = 칼라'단면'(양면 라벨만). 칼라양면(6000)·흑백양면(4000)은 **재입력 자체가 누락**. S2(212행)는 정확하나 미배선이라 도달불가.

### 1.3 엔진 매칭 규명 (`pricing.py`)
- `use_dims(COMP_PRINT_DIGITAL_S1/S2)` = `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]`.
  - `clr_cd` **부재** → step2가 치환해서 색은 더 이상 매칭축 아님.
  - `proc_grp:PROC_000001` = `:` 포함 → non_qty 에서 제외되는 메타힌트(매칭 무관).
- 매칭축 = `print_opt_cd` × `plt_siz_cd`(SIZ_000499 국4절 / SIZ_000077 3절) × `proc_cd`(PROC_000004) × `min_qty`(수량구간). 행의 `clr_cd`/`siz_cd` = NULL(매칭 무관).
- `_row_matches`: 행 차원 NULL = 와일드카드. `_combo_key`/`ERR_AMBIGUOUS` = NON_QTY_DIMS 동시매칭 가드(같은 comp 내).

---

## 2. 상품별 흑백/칼라 선택 유무 판정 (라이브 실측)

PRF_DGP_A~F에 바인딩된 **디지털 상품 19종 전부 `front_colrcnt_cd = CLR_000005`(CMYK 4도) — 칼라 전용. 흑백 옵션 0건.**
- 상품이 쓰는 print_opt = POPT_000001(단면, f=CLR_000005/b=CLR_000001) · POPT_000002(양면, f=b=CLR_000005). 즉 **사용자는 단면/양면만 택일**, 색은 항상 칼라.
- PRF_DGP_A 색상엽서 10종(프리미엄/코팅/스탠다드/투명/화이트인쇄/핑크별색/금은별색 엽서·종이슬로건·쿠폰/상품권 2종) 포함 전 디지털 상품이 동일.

**판정: 흑백 단가행은 어떤 디지털 상품도 선택할 수 없는 死데이터.** 정확히 필요한 것은 **칼라 단면·칼라 양면** 두 band 뿐.

---

## 3. 교정 구조 설계 + 이중합산 방지

### 3.1 대안 비교 (deliberation)

| 대안 | 구조 | 트레이드오프 | 판정 |
|---|---|---|---|
| **ⓐ comp-internal print_opt 분기 (권고)** | S1 한 comp 유지. 흑백 106 + 오라벨 106 행을 **칼라단면(POPT_000001) + 칼라양면(POPT_000002)** verbatim으로 치환. clr_cd=NULL. S2 死 유지. | 공식 바인딩 불변(S2 추가배선 불요)·구조 최소변경·이중합산 원천 불가(단일 comp). 흑백은 死이나 디지털이 칼라전용이라 무해. | ★ **GO**. 단가 verbatim·매칭축 그대로. |
| ⓑ S1=단면 / S2=양면 2-comp 복원 + clr_cd 재도입 | 면축=comp, 색축=clr_cd 매칭축 복원. S2를 6공식에 추가배선. use_dims에 clr_cd 추가. | (1) S1·S2 둘 다 배선 → 면 선택과 무관히 **둘 다 매칭=이중합산**(brief가 경고한 함정). 면을 어떻게 한쪽만 켜는가 = print_opt_cd로 또 분기해야 → 결국 ⓐ로 회귀. (2) clr_cd를 NON_QTY_DIMS/use_dims에 넣으면 흑백·칼라 둘 다 적재 시 동일 combo 내 2행 → tier 단계서 `ERR_DUPLICATE`. (3) 코드(pricing.py NON_QTY_DIMS) 수정 필요 = webadmin 코드변경(금지). | ✗ 이중합산·코드변경·과설계. |
| ⓒ 흑백/칼라 옵션그룹(CPQ) 신설 + ref_dim | 색을 CPQ 옵션으로 올려 차원 환원. | 디지털이 칼라전용이라 선택지가 없음(옵션 1개)=무의미. 미래 흑백상품 생기면 그때 ⓑ/ⓒ 재검토. | 보류(현 시점 불요). |

**권고 = ⓐ.** 근거: ① 디지털=칼라전용이라 색축이 사실상 상수 → 면축(print_opt_cd) 하나로 4단가 중 칼라 2개만 표현하면 충분. ② 단일 comp(S1)라 `_combo_key` 동시매칭=구조적으로 불가 → 이중합산 0. ③ 단가 verbatim·코드 무변경·바인딩 무변경 = 교정 최소.

### 3.2 이중합산 방지 메커니즘
- **S2를 건드리지 않음** + S2는 6공식 어디에도 미배선(`t_prc_formula_components`에 COMP_PRINT_DIGITAL_S2 = 0행, 실측). → 평가 시 S2는 로드조차 안 됨. 이중합산원 부재.
- S1 내부는 `print_opt_cd`로 단면/양면 배타. 같은 (comp,plt,popt,proc,min_qty) 중복 0(DRY-RUN GUARD로 실증). → `ERR_AMBIGUOUS`/`ERR_DUPLICATE` 미발생.

---

## 4. 교정 적재본 + 실증

### 4.1 적재본 (`digital-clr-fix.sql`)
- BEGIN → `DELETE … WHERE comp_cd='COMP_PRINT_DIGITAL_S1'`(212행) → 칼라 verbatim 212행 INSERT(단면 band→POPT_000001, 양면 band→POPT_000002, clr_cd/siz_cd=NULL) → 트랜잭션 내 DO-block 검증(국4절 단면=4000·양면=6000 아니면 EXCEPTION) → COMMIT.
- 멱등: 자연키 기준 전치환. `ux_t_prc_comp_prices_nat_key`와 정합.
- 단가 = 백업 CLR_000005 verbatim(106 단면 + 106 양면 = 212). **신규 mint·날조 0.**

### 4.2 라이브 실증 (DRY-RUN ROLLBACK, 무변경)
`digital-clr-dryrun.sql` 라이브 실행 결과 (그리고 `match_component` 권위 알고리즘 직접 시뮬도 동일):

```
BEFORE  국4절 단면 POPT_000001 = 3000 (흑백단면)   ← 결함
        국4절 양면 POPT_000002 = 4000 (칼라단면 오라벨)
AFTER   국4절 단면 = 4000 (칼라단면 ✓)   3절 단면 = 4500 ✓
        국4절 양면 = 6000 (칼라양면 ✓)   3절 양면 = 7000 ✓
GUARD   duplicate combos = 0 · S2 rows=212/bindings=0(死 보존) · S1 rows=212
```

엔진 알고리즘(`match_component`) 직접 검증: 전 수량구간(1·2·3·5·10·100)·양 plate·양 면 = `error: NONE`. 이중합산·모호매칭 없음.

---

## 5. 영향 분석

- **대상**: COMP_PRINT_DIGITAL_S1 1개 comp, 212 단가행. PRF_DGP_A~F 6공식이 이 comp를 공유 → **디지털 19상품 전부**가 동시 교정됨(색상엽서 10 + 디지털 9).
- **금액 효과(매당, 국4절 기준)**: 단면 3000→4000(+1,000), 양면 4000→6000(+2,000). 3절: 단면 4500, 양면 7000. 수량구간 전체 verbatim 갱신.
- **위험**: S1 공유 comp이므로 흑백 선택 상품이 만약 존재하면 칼라값 과청구 위험 — 그러나 실측상 흑백 선택 디지털 상품 0건이라 무해. (미래 흑백상품 등록 시 ⓑ/ⓒ 재설계 트리거.)
- **불변**: 공식 바인딩·use_dims·S2·pricing.py 코드 무변경. 다른 comp 무영향.

## 6. 미해소 / 컨펌

- **S2(死 212행) 처리**: 본 교정은 보존(이중합산 무관). 별도 정리(use_yn=N 또는 백업 후 삭제)는 후속 cleanup 트랙 — 가격 영향 0이라 본 교정 범위 밖. (컨펌: 死comp 잔존 허용 여부 = 실무진 결정, 가격 정합엔 무영향.)
- **흑백 band 영구손실 여부**: 현재 디지털 칼라전용이라 미적재. 향후 흑백 제공 시 백업에서 복원 가능(`_backup_digital_clr_rows_20260617.json` CLR_000002 보존).
- 실 COMMIT = 인간 승인 후 dbmap 적재 트랙(`dbm-load-execution`) 위임.
