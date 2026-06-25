# 072 하드커버책자 PRF_HC_MUSEON_SUM 가격공식 종단 설계 (load-ready) — 6비목 규명 완료

생성: hsp-set-designer · 2026-06-25 라이브 읽기전용 재실측(SELECT only) · 권위=set-price-authority §1.1 + 면지/표지전용지 도출 2건 · 단가 verbatim·**날조 0** · **DB 미적재**(COMMIT/INSERT/DDL 없음·실 적재 별도 인간 승인) · search-before-mint 전수

> 본 설계는 `price-pilot-hc072-design.md`(초기 6비목·용지비/박 BLOCKED) + `lining-price-derivation-method.md`(면지=무료) + `cover-paper-calc-derivation.md`(표지전용지="계산식"=seq9 공통 용지비산식·아트150 46.65 COMP_PAPER 재사용) 3건을 **종합·갱신**한다.
>
> ★**본 세션의 결정적 라이브 재실측 적발(직전 설계 정정)**:
> 1. **COMP_BIND_HC_MUSEON `del_yn='Y'`(논리삭제)** — 직전 설계가 정명으로 배선했으나 라이브에서 삭제됨. 동일 PROC_000023 단가(byte-동일) 보유한 **활성(del_yn='N') comp = COMP_BIND_SSABARI**(통합 흔적).
> 2. **COMP_PRINT_DIGITAL_S2 `del_yn='Y'`(논리삭제)** — 직전 apply.sql이 내지인쇄를 S2로 배선했으나 S2는 삭제 comp. 활성 인쇄 comp는 **COMP_PRINT_DIGITAL_S1 단 1개**(del_yn='N').
> 3. (frm_cd, comp_cd) **복합PK** — 한 공식에 같은 comp 2회 불가(라이브 전 공식 0건 위반·PK 강제). 표지인쇄·내지인쇄를 둘 다 S1로 set 공식에 넣을 수 없음 → **내지인쇄 비목이 진성 BLOCKED**(2번째 활성 인쇄 comp 부재).

---

## ★0. 결론 요약 (한눈에)

| 항목 | 결론 |
|---|---|
| **PRF 구조** | `PRF_HC_MUSEON_SUM`(원자합산형·세트 부모 072 자기 공식) ← formula_components Σ. 라이브 PRF_HC% 0행 → 신규 mint 정당. |
| **6비목 배선** | (5)제본·(3)표지인쇄·(4)표지코팅·(2)용지비 = **4비목 READY 배선**(전부 활성 comp·verbatim 단가 라이브 실재). (1)내지인쇄 = **BLOCKED**(2번째 활성 인쇄 comp 부재·S2 삭제·PK 충돌). (6)후가공박 = **N/A**(072 박 공정 미등록·권위+라이브 2중 확정). |
| **코팅 이중계상 처리** | 🟢 **이중계상 0 입증**. 표지코팅 = COMP_COAT_MATTE 비목 **1회만** 계상. 용지비 COMP_PAPER 단가(아트150 46.65)는 **순수 무코팅 절가**(코팅 미포함). MAT_000246 "+무광코팅" 라벨은 자재명일 뿐 단가에 코팅 미합산(아트150 절가 그대로). 072 process에 무광(PROC_000015) 공정 별도 등록 확인 → 코팅은 코팅비 비목 경로. |
| **골든 PRICE** | A5·단면·100p·50권·무광단면 → READY 4비목 부분합산 = 제본 450,000 + 표지인쇄 + 표지코팅 + 표지용지비 = **PRICE ≠ 0**(제본비 단독 450,000 입증). 이중합산 0·코팅 1회. **단 내지인쇄 BLOCKED분 누락 = 완제가 미달**(돈 크리티컬·과소청구) → 내지인쇄 해소 전 바인딩 보류. |
| **신규 mint 목록** | `PRF_HC_MUSEON_SUM`(price_formulas 1행) + formula_components 4배선(READY분). **신규 price_components 0·신규 component_prices 0**(전 comp·단가행 재사용). |
| **바인딩 가능 여부** | 🔴 **바인딩 보류**(내지인쇄 BLOCKED). 6비목 중 내지인쇄 누락 상태로 072→PRF 바인딩 시 내지비 전액 과소청구(돈 크리티컬). 내지인쇄 comp 해소(dbmap) 후 바인딩. |
| **잔여 CFM** | CFM-HC-BIND-DELYN(제본 comp 삭제·SSABARI 대체)·BLK-HC-INNERPRINT(2번째 인쇄 comp)·CFM-COVER-MAT(자재코드)·CFM-COVER-A4PLT(3절절가)·CFM-COVER-COAT(해소)·CFM-COVER-SONJI(손지). |

---

## 1. 가격 모델 (set-price-authority §1.1 · calc-formula seq63~70)

```
판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비   (6비목 Σ)
 (1) 내지인쇄비 = [총내지매수행][도수열] × 총내지매수      ← 총내지매수=부수×(페이지/판걸이)·앱 이중수량
 (2) 용지비    = [크기별 기준단가] × [출력매수] + 5장(손지율)  ← seq9 공통 용지비산식(표지+내지 종이)
 (3) 표지인쇄비 = 출력매수 × 수량행단가                  ← 출력매수=앱 판수계산
 (4) 표지코팅비 = 출력매수 × 수량행단가
 (5) 제본비   = [수량행][제본종류열]                      ← 부당 × 부수
 (6) 후가공박 = [면적별동판비] + [면적별 A~E군 합가]       ← 072 N/A(박 공정 미등록)
```

- 세트 부모 072(PRD_TYPE.01) 자기 공식 **PRF_HC_MUSEON_SUM**에 비목 comp Σ 배선.
- 구성원 073(표지)·074/075/076(면지 택1색·전부 PRD_TYPE.02 반제품) — **가격 비기여**(BOM 구성·바인딩 0행 실측). 가격은 set 공식 comp Σ로만(이중계상 가드 §6).
- evaluate_set_price 종단(pricing.py:718): 구성원 4종 evaluate_price → contribution 0(바인딩 0) + set 공식 Σ = 판매가(094 엽서북/097 떡메 동형 "셋트 단독형" — 전 비목이 set 공식에 internalize).

---

## 2. PRF_HC_MUSEON_SUM 정의 + formula_components 배선 (라이브 재실측 기반)

### 2.1 PRF 공식 정의 (신규 mint — 라이브 PRF_HC% 0행 확정)

| frm_cd | frm_nm | use_yn | note |
|---|---|---|---|
| **PRF_HC_MUSEON_SUM** | 하드커버무선책자 원자합산형(제본+표지인쇄+표지코팅+용지비 ※내지인쇄 BLOCKED·후가공 N/A) | Y | calc-formula seq64·set-authority §1.1·hsp 2026-06-25 |

- search-before-mint: `t_prc_price_formulas` PRF_HC% **0행**(라이브 실측 2026-06-25) → 신규 mint 정당. 멱등 PK=frm_cd·ON CONFLICT DO NOTHING.
- ★공유 `PRF_BIND_SUM` 미채택: PRF_BIND_SUM은 A갈래(068~071 단일 prd)이고 현재 삭제 comp COMP_BIND_JUNGCHEOL 1개만 배선(§18 W1 stale). comp 집합 상이 → 072 전용 PRF 분리(§18 booklet §4.2 후보②·AD-BK2).

### 2.2 formula_components 배선 (READY 4비목 + BLOCKED 1 + N/A 1)

evaluate_price 계약(pricing.py:551~596)이 그대로 먹는 형태. 각 comp use_dims는 **라이브 실측값**.

| disp_seq | comp_cd | 비목 | addtn_yn | comp del_yn | prc_typ(comp) | use_dims(라이브 실측) | 판별차원(silent 합산 가드) | 상태 |
|---|---|---|---|---|---|---|---|---|
| 1 | **COMP_BIND_SSABARI** ※ | (5)제본비 | Y | **N(활성)** | PRICE_TYPE.01 단가형 | `["proc_cd","min_qty","proc_grp:PROC_000017"]` | proc_cd=PROC_000023 주입(셋트 고정) | 🟢 READY(★HC_MUSEON 삭제·SSABARI 대체·CFM-HC-BIND-DELYN) |
| 2 | **COMP_PRINT_DIGITAL_S1** | (3)표지인쇄비 | Y | N(활성) | .01 단가형 | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` | proc_cd=PROC_000004(디지털)+plt_siz_cd(표지판형)+print_opt_cd 주입 | 🟢 READY |
| 3 | **COMP_COAT_MATTE** | (4)표지코팅비 | Y | N(활성) | .01 단가형 | `["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]` | proc_cd=PROC_000015(무광)+plt_siz_cd+coat_side_cnt 주입 | 🟢 READY(072=무광 단면 실사용) |
| 4 | **COMP_PAPER** | (2)용지비 | Y | N(활성) | .01 단가형 | `["plt_siz_cd","mat_cd"]` | mat_cd(표지/내지 종이)+plt_siz_cd 주입 | 🟢 READY(표지=아트150 46.65·CFM-COVER-MAT/A4PLT) |
| — | ~~COMP_PRINT_DIGITAL_S2~~ | (1)내지인쇄비 | — | **Y(삭제)** | — | — | — | 🔴 **BLOCKED**(S2 삭제·S1 PK충돌·2번째 활성 인쇄 comp 부재) |
| — | (후가공박 comp 없음) | (6)후가공박 | — | — | — | — | — | ⚪ **N/A**(072 박 공정 미등록·권위+라이브 2중) |

※ **disp_seq 표기**: 배선은 4행(seq 1~4). 내지인쇄(BLOCKED)·후가공박(N/A)은 **미배선**(formula_components 행 미생성). 내지인쇄 해소 시 seq 5로 추가.

### 2.3 ★COMP_BIND_HC_MUSEON 삭제 → COMP_BIND_SSABARI 대체 (CFM-HC-BIND-DELYN) [돈 크리티컬]

- **라이브 실측**: COMP_BIND_HC_MUSEON `del_yn='Y'`(논리삭제). 동일 PROC_000023 단가행 6개(1=30000·4=20000·10=14000·50=9000·100=7000·1000=6000)를 **byte-동일**하게 보유한 활성 comp = **COMP_BIND_SSABARI**(`del_yn='N'`). "싸바리(둘러싸기)바인더"=하드커버 양장의 공정 동의어. 통합 흔적(둘 중 하나를 정명으로 통합 후 다른 쪽 논리삭제).
- **엔진 영향(검증 사실)**: pricing.py·models.py에 `del_yn` 참조 **0건**(§18 W1 validator 2026-06-20 검증) → 엔진은 del_yn='Y' comp도 평가에 포함(삭제 무시). 즉 HC_MUSEON으로 배선해도 단가 자체는 산출됨. **그러나** 신규 공식이 삭제 comp를 참조하면 ① admin/BOM 필터에서 사라짐(논리삭제 권위=del_yn·메모리) ② 향후 정리에서 단가행 소실 위험 → **활성 comp(SSABARI) 배선이 load-ready 정답**.
- ★**단가 동일성 검증 완료**(2026-06-25 SELECT): COMP_BIND_SSABARI/PROC_000023 6행 = COMP_BIND_HC_MUSEON/PROC_000023 6행 **완전 일치**(가격표 B02 하드커버무선 verbatim). 단가 변동 0.
- → 본 설계 **seq1 = COMP_BIND_SSABARI**(활성·동일 단가). 단, 명칭이 "싸바리바인더"라 의미 혼동 가능 → **CFM-HC-BIND-DELYN**(실무진: HC_MUSEON을 활성화 복원할지 vs SSABARI를 정명으로 쓸지 — 단가 영향 0·코드 선택만). 보수안=활성 SSABARI 배선(돈 정합 우선).

### 2.4 ★내지인쇄(1) 진성 BLOCKED — 2번째 활성 인쇄 comp 부재 [돈 크리티컬·직전 설계 정정]

- **직전 apply.sql 결함**: 내지인쇄를 `COMP_PRINT_DIGITAL_S2`로 배선했으나 **S2는 del_yn='Y'(삭제)**. 활성 인쇄 comp는 S1 단 1개.
- **PK 충돌**: formula_components PK=(frm_cd, comp_cd). 표지인쇄(seq2)가 이미 S1을 점유 → **같은 공식에 S1 2회 불가**(라이브 전 공식 동일 comp 중복 0건·PK 강제 확인).
- **동시매칭 위험**(설사 PK를 피해도): 한 공식·한 selections로 표지인쇄(표지 plt_siz)와 내지인쇄(내지 plt_siz·×총내지매수)는 **차원·수량이 상이**해 단일 formula_component로 동시 표현 불가(pricing.py는 formula_component별 1회 평가·selections 1세트).
- **결론**: 내지인쇄는 set 공식에 4번째 인쇄항으로 넣을 수 없다 → **진성 BLOCKED**. 해소 경로 2안(set-designer 범위 밖·dbmap 위임):
  - **(A·권장) 내지 전용 활성 인쇄 comp 신설** `COMP_PRINT_BOOK_INNER`(S1 단가행 verbatim 복제·날조 0) → set 공식 seq5로 배선. comp/단가행 mint=dbmap 트랙.
  - **(B) COMP_PRINT_DIGITAL_S2 활성화 복원**(del_yn Y→N) → set 공식 seq5로 배선. 단 S2 의미(양면 전용?) 재확인 필요.
- ★**돈 크리티컬**: 내지인쇄비 = [총내지매수행][도수열] × 총내지매수(=부수×페이지/판걸이). 100p·50권이면 총내지매수 ≈ 313 → 내지인쇄비가 **표지인쇄비의 수백 배**(권당 페이지 다수). **이 비목 누락 = 책자 가격의 최대 항목 미청구**(파국적 과소청구). → 바인딩 절대 보류(§6.1).

### 2.5 ★proc_cd / plt_siz_cd 주입 선결 (silent 다중매칭 가드) [HARD]

- **제본(seq1)**: COMP_BIND_SSABARI 단가행 proc_cd=PROC_000023 1종(SSABARI는 하드커버무선만 보유·실측). `selections.proc_cd=PROC_000023` 주입 → 1행 매칭. (HC_MUSEON은 다 proc 보유했으나 SSABARI는 단일 proc → 다중매칭 위험 낮음.)
- **표지인쇄(seq2)**: proc_cd=PROC_000004(디지털)·plt_siz_cd=출력판형(A5→SIZ_000499 국4절·A4→SIZ_000475 3절)·print_opt_cd=도수(POPT_000001 단면) 주입. 완제사이즈→출력판형 환원은 앱(임포지션). 미주입 시 다중 판형·도수 행 매칭.
- **표지코팅(seq3)**: proc_cd=PROC_000015(무광)·plt_siz_cd·coat_side_cnt=1(단면) 주입. 미주입 시 무광/유광·단/양면 다중매칭.
- **용지비(seq4)**: plt_siz_cd(국4절/3절)·mat_cd(표지=아트150 또는 MAT_000246·내지=택1 종이) 주입. use_dims에 min_qty 없음(절가 1행) → 출력매수 곱은 앱(중간계산=앱·DB=절가 룩업).
- ★결론: 4비목 selections 주입 차원 = {proc_cd, plt_siz_cd, print_opt_cd, coat_side_cnt, mat_cd}. CPQ 옵션→차원 자동주입이 정합 선결(W7).

---

## 3. ★코팅 이중계상 처리 (CFM-COVER-COAT 결판) [돈 크리티컬]

**질문**: 표지 전용지(MAT_000246) 자재명 "하드커버전용지+무광코팅"에 코팅이 포함 → 용지비(COMP_PAPER)와 표지코팅비(COMP_COAT_MATTE) **이중계상** 위험?

**라이브 실측 + 권위 3원 대조 결론 = 이중계상 0 (코팅 1회만 계상)**:

| 증거 | 실측/권위 | 판정 |
|---|---|---|
| **E1 용지비 단가 출처** | COMP_PAPER 단가 = 아트150(MAT_000078) 국4절 **46.65**(라이브 verbatim). 이는 **아트지150g 순수 용지 절가**(가격표 출력소재 row9·코팅 무관 종이비). MAT_000246 단가행은 라이브 **0행** → 적재 시 아트150 절가(46.65) 복제 권장(코팅 미포함 순수 용지단가). | 용지비 = 순수 종이 절가(코팅 0) |
| **E2 표지코팅비 비목 독립** | calc-formula seq68 "(4)표지코팅비 = 출력매수 × 수량행단가"(참조=코팅 시트) — 6비목에 코팅이 **독립 비목**으로 명시. | 코팅 = 별 비목(seq68) |
| **E3 코팅 공정 별도 등록** | 072 process 실측 = {PROC_000014 유광·**PROC_000015 무광**·PROC_000023 하드커버무선·PROC_000076 수축포장}. 무광코팅 공정이 **상품에 등록**(코팅비 비목 경로 존재). | 코팅 = COMP_COAT_MATTE/PROC_000015 경로 |
| **E4 코팅 단가행 실재** | COMP_COAT_MATTE/PROC_000015/SIZ_000499/단면 단가행 라이브 실재(1=2000·2=1500·…). | 코팅비 verbatim 청구 가능 |

**설계 규칙(이중계상 가드)**:
1. **표지코팅 = COMP_COAT_MATTE 비목(seq3)에서 1회만** 계상 (proc_cd=PROC_000015·coat_side_cnt=1).
2. **용지비(COMP_PAPER seq4) 단가 = 순수 아트150 절가 46.65** (코팅 미포함). MAT_000246 적재 시 46.65 복제·note="순수 용지단가·코팅 미포함(코팅은 표지코팅비 비목)".
3. comp_cd 상이(COMP_PAPER ≠ COMP_COAT_MATTE) → 두 비목 단가행 중복 0·동시매칭 0(use_dims 차원 상이) → **이중합산 0 입증**.

★잔여 1줄 확인(CFM-COVER-COAT) = "용지비 46.65가 코팅 전/후 가격인지" 권위 1줄 부재이나, **아트150 국4절 절가(46.65)는 가격표 출력소재 row9 순수 용지비와 byte-일치**(코팅비는 별 시트) → **코팅 전(순수 용지) 확정**. 실무진 확인은 적재 직전 형식 컨펌(돈 영향=현 설계로 이미 이중계상 0).

---

## 4. 용지비(2) 비목 모델링 (표지·내지·면지 경계)

COMP_PAPER use_dims=`["plt_siz_cd","mat_cd"]`·PRICE_TYPE.01(단가형·절가). **한 comp의 다른 차원행**(mat_cd로 표지/내지 구분):

| 용지 | mat_cd | plt_siz_cd | unit_price | 단가행 상태 | 처리 |
|---|---|---|---|---|---|
| **표지** 아트150/전용지 | MAT_000078(아트150) **또는** MAT_000246(전용지) | SIZ_000499(국4절·A5)/SIZ_000475(3절·A4) | **46.65**(국4절·verbatim) | MAT_000078 国4절 1행 실재 / MAT_000246 0행 | CFM-COVER-MAT(코드 택1·단가 동일)·CFM-COVER-A4PLT(3절 절가 부재) |
| **내지** *별도설정(택1 종이) | 사용자 택1(백색모조/아트/스노우…) | 국4절 | 종이별 절가(MAT_000072~151) | **56행 기적재**(택1 종이 단가행 실재) | 🟢 READY(선택 자재 기존 단가행 매칭) |
| **면지** 화이트/블랙/그레이 | MAT_000001/002/003 | — | — | 단가행 부재(무지) | 🟢 **무료**(공식 면지비목 없음·기여 0·formula_components 미포함) |

- **표지·내지 = 같은 COMP_PAPER comp**의 다른 mat_cd 차원행. set 공식엔 COMP_PAPER 1배선(seq4)이고, selections.mat_cd가 표지/내지를 구분. ★단, 표지용지·내지용지가 **둘 다 같은 평가에서 합산**되려면 표지인쇄·내지인쇄와 동일 문제(한 comp·한 selections·1회 평가) → 본 설계의 seq4 COMP_PAPER는 **표지 용지비**를 담당(plt_siz=표지판형·mat=아트150). **내지 용지비는 내지인쇄와 함께 BLOCKED 묶음**(2번째 용지 평가 슬롯 필요·내지인쇄 해소안 A의 COMP_PRINT_BOOK_INNER와 함께 COMP_PAPER 내지차원도 별 슬롯 검토 — dbmap).
- **면지 = 무료**(lining-derivation 3중 정합): 권위 6비목에 면지비목 없음 + 면지 무지3색(인쇄면지 없음) + sets 074/075/076 무지. → formula_components 미포함(기여 0). 074/075/076 = 무료 CPQ 색옵션(sub_prd_qty=1·택1).

★**용지비 모델링 결론**: 표지 용지비 = COMP_PAPER seq4(READY). **내지 용지비는 내지인쇄와 함께 2번째 평가 슬롯 BLOCKED**(돈 크리티컬·내지 종이값 누락도 과소청구). 면지=무료(미포함).

---

## 5. search-before-mint 전수 (재사용 vs 신규 mint)

| 비목 | comp | 라이브 실재 입증(2026-06-25 SELECT) | 판정 |
|---|---|---|---|
| (5)제본 | COMP_BIND_SSABARI | del_yn=N·PROC_000023 6행(30000/20000/14000/9000/7000/6000)=B02 verbatim | **재사용**(신규 0·HC_MUSEON 삭제 대체) |
| (3)표지인쇄 | COMP_PRINT_DIGITAL_S1 | del_yn=N·212행·plt_siz[SIZ_000077,SIZ_000499]·proc=PROC_000004·도수 POPT_000001/2 | **재사용**(신규 0) |
| (4)표지코팅 | COMP_COAT_MATTE | del_yn=N·92행·PROC_000015 무광·SIZ_000499 단면 실재 | **재사용**(신규 0·072=무광 단면) |
| (2)용지비(표지) | COMP_PAPER | del_yn=N·56행·MAT_000078 国4절=46.65 verbatim | **재사용**(신규 0·표지=아트150 절가) |
| (1)내지인쇄 | — | S2 삭제(del_yn=Y)·S1 PK점유 | 🔴 **신규 mint 필요**(COMP_PRINT_BOOK_INNER·dbmap) BLOCKED |
| (2)용지비(내지) | COMP_PAPER 내지차원 | 56행 기적재이나 2번째 평가슬롯 필요 | 🔴 BLOCKED(내지인쇄와 묶음) |
| (6)후가공박 | — | 072 박 공정 미등록·comp 0행 | ⚪ N/A(미적용) |

### 5.1 신규 mint 목록 (set-designer 범위)

| mint 항목 | 테이블 | 사유 | 라우팅 |
|---|---|---|---|
| **PRF_HC_MUSEON_SUM** | t_prc_price_formulas (1행) | A갈래 PRF_BIND_SUM과 comp 집합 상이·공유 불가 | 본 설계(READY)·apply.sql |
| **formula_components 4배선** | t_prc_formula_components (4행) | 신규 PRF의 READY 비목 배선(제본·표지인쇄·표지코팅·표지용지비) | 본 설계(READY)·apply.sql |
| ~~신규 price_components~~ | — | **0건**(전 comp 재사용) | — |
| ~~신규 component_prices~~ | — | **0건**(전 단가행 재사용) | — |
| (BLOCKED·dbmap) COMP_PRINT_BOOK_INNER + 단가행 | t_prc_price_components/component_prices | 내지인쇄 2번째 활성 인쇄 comp | dbmap(S1 단가행 verbatim 복제·날조 0) |
| (BLOCKED·dbmap) MAT_000246 단가행 | t_prc_component_prices | 표지 전용지 자재코드 청구 시(택1·CFM-COVER-MAT) | dbmap(아트150 46.65 복제) |

→ **set-designer 신규 mint = PRF 1행 + formula_components 4행. 단가행 mint 0**(search-before-mint 통과).

---

## 6. 바인딩 + 이중계상 점검

### 6.1 셋트 바인딩 (t_prd_product_price_formulas) — 🔴 보류

| prd_cd | frm_cd | apply_bgn_ymd | note | 실행 여부 |
|---|---|---|---|---|
| PRD_000072 | PRF_HC_MUSEON_SUM | 2026-06-01 | 하드커버책자 원자합산형 | 🔴 **보류**(내지인쇄+내지용지비 BLOCKED) |

- 실 PK=(prd_cd, apply_bgn_ymd). 072 현재 바인딩 **0행**(실측) → 충돌 0·멱등 가능.
- ★**바인딩 절대 보류 [HARD]**: 내지인쇄비(=책자 최대 비목·총내지매수 곱)·내지 용지비가 BLOCKED인 상태로 바인딩하면 책자 가격의 **가장 큰 항목이 통째로 누락**(파국적 과소청구). 표지/제본만 청구되는 broken 가격. → **내지인쇄 comp 해소(dbmap·COMP_PRINT_BOOK_INNER) 후 seq5 배선 + 바인딩**.
- apply.sql에 바인딩 INSERT는 **주석 처리**(미실행). 6비목 READY 후 주석 해제.

### 6.2 구성원 가격공식 유무·이중계상 (실측)

- 구성원 073/074/075/076 가격공식 바인딩 **0행**(2026-06-25 실측) → 구성원 contribution 0.
- 면지 074/075/076 = 화이트/블랙/그레이 **택1 색**(각 sub_prd_qty=1·disp_seq 2/3/4) → "면지 3개 합산" 금지(택1). 무료.
- **이중계상 0**: 가격은 PRF_HC_MUSEON_SUM comp Σ로만. 세트 sub_prd 자체는 BOM 구성(가격 비기여). 비목별 comp 상이(제본/인쇄/코팅/용지) → comp간 중복 0. 코팅 1회(§3). proc_cd/plt_siz_cd/coat_side_cnt 정확매칭 → 각 비목 1행.

---

## 7. 골든 종단 재현 (대표 케이스·evaluate_set_price 손계산·PRICE≠0)

> ★내지인쇄·내지용지비 BLOCKED → **완전 6비목 합산 불가**. 아래는 **READY 4비목(제본+표지인쇄+표지코팅+표지용지비)만의 부분 골든**(PRICE≠0·이중합산0·코팅1회 입증). 내지 해소 후 완전 골든 재계산.

### 골든 케이스 정의

| 항목 | 값 | 근거 |
|---|---|---|
| 셋트 | PRD_000072 하드커버책자 | sets 4구성원 |
| 완제사이즈 | A5(SIZ_000170) → 표지 출력판형=국4절(SIZ_000499) | 판걸이수 row64 A5 표지 390x268→국4절 |
| 도수 | 단면(POPT_000001) | booklet 표지인쇄=단면 |
| 페이지 | 100p(page_rule 24~300/2 내) | booklet |
| 제본 | 하드커버무선(PROC_000023) | booklet |
| 부수(copies) | 50권 | — |
| 코팅 | 무광 단면(PROC_000015·coat_side_cnt=1) | booklet 표지코팅=무광(단면)·072 process PROC_000015 |
| 표지 출력매수 | 1대(표지 판걸이 1) × 50권 = **50매**(+손지 5장은 앱·생략) | 판걸이수 row64 |

### 부분 골든 손계산 (READY 4비목·pricing.py:718·verbatim 단가)

```
evaluate_set_price(PRD_000072, members=[073,074,075,076(택1무료)],
  set_selections={proc_cd:PROC_000023, plt_siz_cd:SIZ_000499, print_opt_cd:POPT_000001,
                  coat_side_cnt:1, mat_cd:MAT_000078(아트150)},
  copies=50, set_procs=[{proc_cd:PROC_000023},{proc_cd:PROC_000004},{proc_cd:PROC_000015}])

[A] 구성원 073/074/075/076 evaluate_price → 가격공식 0행 → contribution 0 (실측)

[B] set_eval = evaluate_price(PRD_000072, set_selections, 50) → PRF_HC_MUSEON_SUM
    _evaluate_formula → formula_components Σ (verbatim 라이브 단가):

    seq1 제본비 COMP_BIND_SSABARI: proc_cd=PROC_000023·min_qty tier(50권→50행)= 9,000
         component_subtotal(.01 단가형 = 단가 × comp_qty=copies 50)
         = 9,000 × 50 = 450,000   ← ★제본비(부당 9,000 × 50권)

    seq2 표지인쇄 COMP_PRINT_DIGITAL_S1: proc=PROC_000004·plt_siz=SIZ_000499·POPT_000001
         comp_qty = plate_qty(50, pansu=표지판걸이1) = ⌈50/1⌉ = 50 (출력매수)
         min_qty tier(50→앞단 tier; 라이브 SIZ_000499/POPT_000001: …8=700·후속 tier 점감)
         단가 ≈ 표지인쇄 출력매수 50 tier 단가 × 50    ← verbatim tier × 출력매수 (>0)

    seq3 표지코팅 COMP_COAT_MATTE: PROC_000015·SIZ_000499·coat_side_cnt1
         comp_qty = plate_qty(50,1)=50
         min_qty tier(50→SIZ_000499 단면: 1=2000·2=1500·5=1200·10=1000·20=800·30=800…)
         단가(50권 tier ≈ 800 이하) × 50    ← verbatim × 출력매수 (>0)

    seq4 표지용지비 COMP_PAPER: plt_siz=SIZ_000499·mat=MAT_000078(아트150)
         use_dims=[plt_siz_cd,mat_cd]·min_qty 없음 → 절가 1행 = 46.65
         component_subtotal: 절가 46.65 × comp_qty(출력매수 50 + 손지5=앱)
         ≈ 46.65 × 50 = 2,332.5    ← ★순수 용지비(코팅 미포함·이중계상 0)

    (미배선) seq5 내지인쇄: 🔴 BLOCKED → 합산 제외(included=False)
    (미배선) seq6 후가공박: ⚪ N/A → 미배선

    included_sum = 제본 450,000 + 표지인쇄 + 표지코팅 + 표지용지비 2,332.5  (≥ 452,332.5)

[C] base_total = 0(구성원) + included_sum ≥ 450,000   ✅ PRICE ≠ 0

[D] 할인: 072 t_prd_product_discount_tables = 0행(2026-06-25 실측·CFM-HC-DSC 해소=할인 없음)
[E] final = base_total (할인 없음) ≥ 452,332원   ✅
```

**부분 골든 = 제본 450,000 + 표지인쇄 + 표지코팅 + 표지용지비 2,332.5 ≥ 452,332원.**
- ✅ **PRICE ≠ 0**(제본비 단독 450,000 입증).
- ✅ **이중합산 0**(comp 4종 상이·코팅 1회·proc_cd/plt_siz/coat_side 정확매칭·구성원 0).
- ✅ **코팅 1회 계상**(COMP_COAT_MATTE seq3만·용지비 COMP_PAPER는 순수 절가 46.65 코팅 0).
- 🔴 **내지인쇄+내지용지비 누락 = 완제가 미달**(책자 최대 비목·총내지매수≈313 곱) → 바인딩 보류(§6.1).

---

## 8. 077/082 전파 노트

| 셋트 | 072 대비 차이 | 전파 |
|---|---|---|
| **PRD_000077 레더 HC책자** | 표지=레더 정액 소재비(가격표 row99=4000/row100=7000·"계산식" 아님)·면지 079/080/081·제본 동일(PROC_000023) | PRF 동형(제본·표지인쇄·표지코팅 공유). **표지 용지비만 정액 모델**(COMP_PAPER 절가 부적합 → 표지전용 정액 comp 검토·dbmap)·077 표지자재 오등록(078=몽블랑130g) CONFIRM-077-MAT. 내지인쇄 BLOCKED 동일 |
| **PRD_000082 HC링책자** | 제본=하드커버트윈링(COMP_BIND_HC_TWINRING·del_yn=Y→대체 검토)·**면지인쇄+면지코팅 2비목 추가(8비목·표지/면지 ×2)**·인쇄면지 087 | 별 **PRF_HC_TWINRING_SUM**(8비목)·×2=formula_components 계수(단가 verbatim·날조금지)·면지인쇄도 동일 2번째 인쇄 comp BLOCKED 문제 가중(표지+면지+내지 3 인쇄 슬롯) |

- 072가 READY 검증되면 077=단가원천만 레더로(표지 정액 comp별 트랙)·082=면지 2비목+×2 확장. **내지인쇄 2번째 인쇄 comp BLOCKED은 3셋트 공통 선결**(082는 면지인쇄까지 3슬롯).

---

## 9. CONFIRM / BLOCKED 라우팅

| ID | 항목 | 상태 | 라우팅 | 사유 |
|---|---|---|---|---|
| **BLK-HC-INNERPRINT** | 내지인쇄(1) 2번째 활성 인쇄 comp 부재 | 🔴 BLOCKED | dbmap(COMP_PRINT_BOOK_INNER mint·S1 단가 복제 / or S2 활성화) | S2 del_yn=Y·S1 PK점유·돈 크리티컬(최대 비목) |
| **BLK-HC-INNERPAPER** | 내지 용지비 2번째 평가슬롯 | 🔴 BLOCKED | dbmap(내지인쇄와 묶음) | 한 comp·한 selections·1회 평가 제약 |
| **CFM-HC-BIND-DELYN** | 제본 comp HC_MUSEON 삭제·SSABARI 대체 | 🟡 CONFIRM(보수안=SSABARI) | 실무진(HC_MUSEON 복원 vs SSABARI 정명) | 단가 영향 0·코드 선택만 |
| **CFM-COVER-MAT** | 표지 자재코드(MAT_000078 vs MAT_000246) | 🟡 CONFIRM(보수안=아트150 직접) | 적재 시 1코드 택1 | 단가 동일 46.65·돈 영향 0 |
| **CFM-COVER-A4PLT** | A4 표지 3절(SIZ_000475) 절가 부재 | 🟡 CONFIRM | dbmap(3절 아트150 절가 적재 or 국4절 환산) | A5만 국4절 실재·A4 정확청구 |
| **CFM-COVER-COAT** | 용지비 46.65 코팅 전/후 | 🟢 해소(코팅 전 순수 용지) | (적재 직전 형식 컨펌) | 아트150 row9 byte일치·코팅 별 시트 |
| **CFM-COVER-SONJI** | 손지율 +5장 표지 적용 | 🟡 CONFIRM(앱 임포지션) | 인간 | 출력매수 ±5장(소액) |
| **CFM-HC-DSC** | 072 수량할인 | 🟢 해소(할인 0행 실측) | — | discount_tables 0행 |
| ~~CFM-HC-FOIL~~ | 072 후가공박 적용 | 🟢 해소(N/A) | — | 박 공정 미등록(권위+라이브) |
| **CFM-HC-INJECT** | proc_cd/plt_siz/print_opt/coat_side/mat CPQ 주입 | 🟡 CONFIRM | W7 CPQ option→차원 | 미주입 시 silent 합산/0원 |

---

## 10. 적재 경계 (DB 미적재)

- 본 산출 = PRF 정의 + formula_components(READY 4비목) 배선 설계 + verbatim 단가 재사용 입증 + 부분 골든 + 코팅 이중계상 0 입증 + BLOCKED 분리. **실 INSERT/COMMIT·신규 mint은 게이트 GO + 인간 승인 후 hsp-load-executor / dbmap 위임**.
- ★**바인딩(t_prd_product_price_formulas) = 내지인쇄+내지용지비 해소 후 실행**(현재 apply.sql 주석 처리·과소청구 가드).
- load CSV/apply.sql = **PRF 1행 + formula_components 4행(READY)** 까지. 내지인쇄·후가공박 미포함·바인딩 주석.

---

## 11. 출처 (날조 0)

- 권위: set-price-authority.md §1.1(calc-formula seq63~70)·`24_master-extract-260610/calc-formula-draft-l1.csv` seq64(6비목)·seq9(용지비 공통산식).
- 도출: `lining-price-derivation-method.md`(면지 무료 3중 정합)·`cover-paper-calc-derivation.md`(표지전용지=seq9 산식·아트150 46.65 COMP_PAPER 재사용).
- §18: `engine-design-booklet.md` §2.2(W1 del_yn 검증)·§3.2(표지/내지 COMP_PAPER+S1 재사용)·§4(A/B 갈래·PRF_HC_MUSEON_SUM).
- 라이브 실측(2026-06-25 읽기전용 SELECT): PRF_HC% 0행·072 바인딩 0행·sets 4구성원(073/074/075/076 전부 PRD_TYPE.02)·구성원 바인딩 0행·**COMP_BIND_HC_MUSEON del_yn=Y·COMP_BIND_SSABARI del_yn=N(PROC_000023 6행 byte동일)**·**COMP_PRINT_DIGITAL_S1 del_yn=N(212행)·S2 del_yn=Y(삭제)**·COMP_COAT_MATTE del_yn=N(92행·SIZ_000499 단면 실재)·COMP_PAPER del_yn=N(56행·MAT_000078 国4절=46.65·MAT_000246 0행)·072 process={014유광·015무광·023하드커버무선·076수축포장·박 없음}·072 discount_tables 0행·fn_calc_pansu 실재·formula_components PK=(frm_cd,comp_cd)·동일 comp 중복 0건.
- 엔진 계약: `pricing.py:718`(evaluate_set_price)·:551~596(_evaluate_formula·del_yn 미필터)·:259(_component_rows)·:340(evaluate_price).
