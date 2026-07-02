# 엽서북(PRD_000094) 시뮬레이터 0원 — 근본원인 진단 (round1 Diagnose · 2026-07-02)

라이브 읽기전용 SELECT + `raw/webadmin/webadmin/catalog/price_views.py`·`pricing.py`·`templates/catalog/price_simulator.html` 코드 대조. 저장/수정/삭제 없음.

## 0. 실측 요약 (라이브 DB)

| 테이블 | PRD_000094(셋트) | PRD_000095(내지) | PRD_000096(표지) |
|---|---|---|---|
| t_prd_product_sets | 095(min20/max30/incr10)·096 2행 del_yn=N | — | — |
| t_prd_product_sizes | 3행(SIZ_000003 dflt·000004·000124) | **0행** | **0행** |
| t_prd_product_materials | MAT_000109(USAGE.01 내지)·MAT_000092(USAGE.02 표지) | **0행** | **0행** |
| t_prd_product_print_options | POPT_000001(단면 dflt)·POPT_000002(양면) | **0행** | **0행** |
| t_prd_product_plate_sizes | 6행 **전부 del_yn=Y**(SIZ_000114/115/262~265) | SIZ_000499 del_yn=N 1행 | 0행 |
| t_prd_product_price_formulas | PRF_PCB_FIXED(2026-06-01) | **0행** | **0행** |
| 옵션그룹/옵션/아이템 | 9그룹·15옵션·13아이템 전부 use_yn=Y·del_yn=N (OPV_000491/492 페이지수는 item 0행 — 무해) | 0 | 0 |

- 부모공식 배선: PRF_PCB_FIXED → COMP_PCB_{S1,S2}_{20P,30P} 4구성요소, use_dims=`["siz_cd","min_qty","print_opt_cd","opt_cd","opt_grp:OPT_000082"]`, 전부 use_yn=Y·del_yn=N.
- 단가행: COMP_PCB_* 완비(3사이즈×수량밴드 2~100+×단/양면×20P/30P). 골든 comp_price_id=3597 = SIZ_000003·min_qty100·POPT_000001·OPV_000491·unit **4,500** → ×100부=450,000 (verbatim, **완제품가 단가형** — 밴드 11,000→4,500 구조가 책 1권 전체가임을 뒷받침).
- 판걸이수: `fn_calc_pansu('SIZ_000499', SIZ_000003/000004/000124)` = **9 / 6 / 9** (전부 >0 — 판형만 잡히면 파생수량 계산 가능).
- 동작 셋트 정합 패턴(072/077): 구성원(284/285 내지)에 sizes 3·materials(USAGE)·print_opts 2·plate SIZ_000499 **자기 prd_cd로 등록** + **셋트 부모(072/077)에도 판형 live 행 존재**(SIZ_000250/252 del_yn=N).

## 1. 코드 경로 (파일:라인)

- `price_views.py:1685 _set_members_meta` — 구성원 sizes/materials/print_opts를 **구성원 자신의 prd_cd**로 조회(1698/1712/1746-1749). 095/096=0행 → `set_members[].sizes/materials/print_opts=[]` (드롭다운 빈 상태).
- `price_views.py:1722` — `plate_options`는 **셋트 완제품(set_prd_cd) 기준**으로만 조회(docstring 명시). 094 판형 전부 del_yn=Y → `plate_options=[]`. 구성원 095의 live 판형(SIZ_000499)은 이 경로에서 **읽지 않음**.
- `price_views.py:1955` — derived(내지) 판형 자동선택도 `_select_default_plate(prd_cd=셋트부모, …)` → 094에 live 판형 0 → `no_plates` → pansu=None → `derive_inner_sheets` 실패 → 유효수량<1 → `pricing.py:896-903` 합산 제외(경고 "유효수량 산출 실패").
- `price_simulator.html:722`(및 635) — 셋트 조건 setSel 조립에서 **`siz_cd`를 명시적으로 skip**: `if(d.name==="proc_cd"||d.name==="siz_cd") continue;` → 부모차원 사이즈 수집 UI 자체가 없음.
- `pricing.py:920 evaluate_set_price` — 셋트공식은 **전달된 set_selections만** 사용, 구성원 selections를 셋트공식으로 병합/복사하는 로직 없음 → siz_cd 영구 미전달 → COMP_PCB_* 4개 전부 미매칭 → 셋트공식 0원.
- `price_views.py:1474-1480` — `opt_groups = []` **하드코딩(2026-06-28 설계결정)**: 옵션그룹은 시뮬레이터 비노출, 가격작용 경로는 opt_cd 원시 드롭다운(frm_opt_grps=OPT_000082 한정)뿐 — 실제로 20P/30P는 정상 렌더·전달됨.
- `price_views.py:1930` — member selections 복사 화이트리스트 `("siz_cd","mat_cd","print_opt_cd")` = 기지 C트랙(coat_side_cnt 드롭) — 재발굴 아님, 해당 표기만.

## 2. 결함별 근본원인·트랙

### R1-D1 — 구성원 사이즈/용지/도수 드롭다운 빈 상태 → **DATA**
- 근본원인: `t_prd_product_sizes/materials/print_options`에 095·096 행 0건(부모 094에만 등록). 코드는 구성원 prd_cd에서 정직하게 읽음 — BOM 역할 재배치([[set-product-bom-role-reassignment-260701]]) 미적용 상태. 072/077 동작 셋트는 구성원 자기 행 보유.
- 교정 명세(**복사 추가 — 부모 행 삭제/이동 금지**: 094 option_items(OPV_000411~419)가 ref_dim으로 부모 prd_cd 행을 참조, `fn_chk_opt_item_ref` 트리거 위반 방지):
  - INSERT `t_prd_product_sizes`: (PRD_000095, SIZ_000003, dflt Y)·(095, SIZ_000004, N)·(095, SIZ_000124, N) + PRD_000096 동일 3행.
  - INSERT `t_prd_product_materials`: (PRD_000095, MAT_000109 몽블랑240, usage USAGE.01 내지, dflt Y)·(PRD_000096, MAT_000092 스노우300, usage USAGE.02 표지, dflt Y).
  - INSERT `t_prd_product_print_options`: 095·096 각각 POPT_000001(단면·dflt Y)/POPT_000002(양면) 2행(opt_id 채번=MAX+1 컨벤션·print_side 부모행 미러).
  - 권위 근거: 상품마스터 260610 엽서북(내지 몽블랑240·표지 스노우300·단면/양면·3사이즈) = 라이브 부모 094 등록분과 일치, 072/077 동작 패턴 동형. COMMIT 전 webadmin 실화면 확인 [HARD].

### R1-D2 — 내지 판형 후보 0 → 판걸이수 NaN → 내지 합산 제외 → **DATA**
- 근본원인: 시뮬레이터 판형 경로(1722·1955)는 **셋트 부모 prd_cd만** 읽는데 094의 판형 6행이 전부 del_yn=Y(판형 정리 트랙에서 완제품사이즈 오적재분 논리삭제). 구성원 095의 live 판형 SIZ_000499는 이 경로 밖.
- 교정 명세: INSERT(또는 기존 행 없으므로 신규) `t_prd_product_plate_sizes` (prd_cd='PRD_000094', siz_cd='SIZ_000499', dflt_plt_yn='Y', item_siz_cd 공통(''/NULL), del_yn='N').
  - 권위 근거: 구성원 095에 이미 SIZ_000499(316x467) live 등록·072/077 동작 셋트도 부모에 live 판형 보유·`fn_calc_pansu(SIZ_000499, 3사이즈)=9/6/9`로 파생수량 성립. (참고: 판형=내지 종이 출력소재 유효 — 셋트 부모 행은 시뮬 경로상 그릇 역할.)
  - 부수 메모(선택·코드): "부모가 아니라 구성원 판형을 읽어야 하는가"는 설계 논점이나, 부모 등록 정합(072/077 패턴)으로 데이터만으로 해소 가능 — C트랙 승격 불요.

### R1-D3 — 셋트공식 siz_cd 미전달 → 셋트공식 0원 → **CODE_CTRACK** (최종가 0의 결정 축)
- 근본원인(이중): ① 프론트 `price_simulator.html:722/635`가 셋트 조건에서 `siz_cd`를 명시 skip(부모 prod_dims에 사이즈 3옵션이 있어도 UI 미생성) ② 백엔드 `pricing.py:920`/`price_views.py:1987`이 구성원 선택을 셋트공식 selections로 병합하지 않음. 결과: COMP_PCB_*(use_dims에 siz_cd) 4개 전부 미매칭. simulate 단일 API에 siz_cd 직접 주입 시 450,000 정상 = 데이터 무결 입증.
- 데이터 우회 불가: 옵션그룹 maps.dims 주입경로(template:733)는 sim_meta `opt_groups=[]` 하드코딩으로 차단·단가행에서 siz_cd 차원 제거는 권위 위반(날조) — 순수 코드 결함.
- 위임 명세(개발팀·webadmin 직접수정 금지): 택1 — (a) `price_views.py price_simulate_set`(:1987 부근)에서 부모 현재공식 use_dims에 siz_cd가 있고 set_selections에 없으면 **내지(SEMI_ROLE.01) member의 siz_cd를 set_selections로 복사**(엽서북 완제품 사이즈=내지 사이즈), (b) `price_simulator.html:722/635`의 siz_cd skip 해제로 셋트 조건에 부모 사이즈 드롭다운 렌더. 기지 C트랙(:1930 coat_side_cnt 화이트리스트)과 **별건**(그건 member→member 복사, 이건 셋트공식 차원 수집).
- ※ D1/D2 데이터 교정만으로는 화면 최종가 여전히 0(구성원 095/096 공식 無=기여 0 정상 + 셋트공식 siz_cd 미전달) — 화면 0원 해소는 이 C트랙 착지가 필수.

### R1-D4 — CPQ 옵션그룹 9종 시뮬레이터 미렌더 → **결함 아님(설계 결정)** · CODE_CTRACK(조치 불요)
- 근본원인: `price_views.py:1474-1480` 의도적 `opt_groups=[]`(2026-06-28 결정 [[option-tmpl-proc-detail]]): 옵션 하위차원 매핑(OPT_REF_DIM)은 가격계산에 쓰지 않고(외부전송 저장용), 가격작용 정상경로=구성요소의 opt_cd 차원(frm_opt_grps 한정 원시 드롭다운) — OPT_000082 20P/30P가 실제로 렌더·전달·매칭됨(주입 450,000). DB의 9그룹·15옵션은 전부 건강(use_yn=Y·del_yn=N).
- 조치: 없음(relitigate 금지). 시뮬레이터 UI에 옵션그룹 노출을 원하면 개발팀 설계변경 사안.

### R1-D5 — 표지(096) 가격 소스 없음(0원) → **정보성·AUTHORITY_TBD(확인만·기본 조치 불요)**
- 근본원인: 096 공식 바인딩 0·직접단가 0. 그러나 부모 PRF_PCB_FIXED 단가행 구조(권당 11,000→4,500 밴드·시트 완제품가 verbatim)는 **표지·내지 포함 완제품가**로 판독 — 표지 기여 0원은 이중합산 방지상 올바른 상태(기지 S1/S2 이중합산 구조결함과 정합). "가격데이터 적재 대기" 문구는 코스메틱.
- 확인 항목(실무진·선택): 상품마스터 260610 엽서북 가격이 표지 포함 완제품가인지 1줄 확인. 포함(예상)이면 종결 — 096에 공식/단가 신설 금지(이중합산 유발).

## 3. 종합 — 0원의 인과 사슬

```
[DATA] 095/096 dim 행 0건 ──→ 구성원 드롭다운 빈 상태(R1-D1)
[DATA] 094 판형 live 0행  ──→ plate_options=[]·pansu NaN → 내지 제외(R1-D2)
[CODE] siz_cd skip + 무병합 ──→ 셋트공식 COMP_PCB_* 미매칭 0원(R1-D3) ← 결정 축
[설계]  opt_groups=[] 하드코딩 ──→ R1-D4 결함 아님
[설계]  부모공식=완제품가       ──→ R1-D5 표지 0원 정상(정보성)
⇒ Σ구성원 0 + 셋트공식 0 = 최종 0원. 엔진·단가행 무결(주입 450,000).
```

- dataFixable: **예** (D1·D2). 단, 화면 450,000 수렴은 D3 C트랙 착지 후.
- 실 COMMIT은 인간 승인 + §7 위임 + webadmin 실화면 확인 [HARD].

---

# Round 2 Diagnose (2026-07-02 · R1 데이터 교정 반영 후 재진단)

Probe round2 결과(final=0·결함 R2-D1/D2/D3)의 근본원인 규명. 라이브 읽기전용 SELECT + 코드 대조. round1 대비 변화: **R1-D1/D2 데이터 교정은 라이브 반영 확인** — 구성원 095/096에 sizes 3·materials 1·print_opts 2 존재, 판형 자동추천 SIZ_000499(판걸이 9) 정상, 구성원 드롭다운·파생수량 전부 렌더(Probe optionGroups 전 mapped). **남은 병목은 R1-D3 코드 결함 하나.**

## R2-0. 데이터 레이어 재실측 — 결함 0 (전 층 건강)

| 레이어 | 실측 (2026-07-02) | 판정 |
|---|---|---|
| t_prd_product_sets | 094←095(min20/max30/incr10)·094←096, del_yn=N | 정상 |
| 공식 바인딩 | 094→PRF_PCB_FIXED(use_yn=Y). 095/096=0행(all-in 설계 정합) | 정상 |
| formula_components | PRF_PCB_FIXED→COMP_PCB_{S1,S2}_{20P,30P} 4행 | 정상 |
| price_components | 4 comp use_dims=[siz_cd,min_qty,print_opt_cd,opt_cd,opt_grp:OPT_000082]·use_yn=Y·del_yn=N | 정상 |
| component_prices | 12(comp×siz×popt×opt)조합 × 39수량밴드 = **468행**, 사이즈 3종(003/004/124) 전부 충전. S1_20P·003·min_qty100=4,500 → ×100부=450,000 (B실증 일치·verbatim) | 정상 |
| CPQ 옵션 | 9그룹·15옵션·13아이템 use_yn=Y·del_yn=N·ref_dim 고아 0. OPV_000491/492 item 0행=무해(opt_cd 자체가 가격차원) | 정상 |
| 구성원 dim | 095: sizes3·mat1·popt2·plate1(SIZ_000499) / 096: sizes3·mat1·popt2. semi_role 095=.01내지·096=.02표지. page_rule 094=20~30/+10 | 정상 (R1-D1/D2 해소 확인) |

⇒ **final=0은 데이터 원인이 아니다.** A/B 실증(set_selections+siz_cd → 450,000)과 전수 실측으로 확정.

## R2-D1 — 최종가 0원: set_selections siz_cd 미전파 → **CODE_CTRACK (기지 R1-D3 미조치 재확인·이번 라운드 유일 병목)**

- 근본원인 3지점 연쇄(round1 §R1-D3와 동일·재검증):
  1. `price_simulator.html:635` `others=dims.filter(d=>d.name!=="proc_cd"&&d.name!=="siz_cd")` — 셋트 조건 UI에서 siz_cd 콤보 미렌더(sim-meta prod_dims에는 siz_cd 3옵션 존재).
  2. `price_simulator.html:722` setSel 조립 `if(d.name==="proc_cd"||d.name==="siz_cd") continue;` — **siz_cd가 서버로 갈 경로 자체 부재** → set_selections={print_opt_cd,opt_cd}.
  3. `price_views.py:1929-1933` member 화이트리스트 복사는 member.selections에만·`:1987-1991` set_selections는 body 그대로 → `pricing.py:920` 셋트공식 evaluate_price에 siz_cd 부재 → PRF_PCB_FIXED 4 comp 전부 미매칭 → set_contrib=0 → "셋트공식 선택값에 매칭되는 구성요소가 없습니다"(경고4).
- 설계 가정 균열: 셋트 조건 UI는 "셋트공식=제본/조립(공정)" 전제로 siz_cd를 걸렀으나 엽서북 부모공식은 **all-in 완제품가형**(siz_cd 필수 차원). 내지/표지 사이즈 콤보(member 레벨)에 정보는 이미 있음 — 승격만 부재.
- DATA 우회 불가: use_dims에서 siz_cd 제거 시 같은 (min_qty,popt,opt)에 3행 충돌(003=4,500 vs 004=5,100)·권위 위반. 단가 collapse=날조 금지.
- 위임 명세(개발팀·택1, b 권장): (a) `price_simulator.html:635/722` siz_cd 제외를 "부모공식 use_dims에 siz_cd 포함 시 노출/전송"으로 조건화 (b) `price_views.py:1987` 직후 부모 현재공식 use_dims가 siz_cd 요구 & set_selections에 없으면 **내지(SEMI_ROLE.01) member.selections.siz_cd 백필**. 검수 기대값: UI 동일 입력(copies=100·SIZ_000003·POPT_000001·OPV_000491) → final=450,000.

## R2-D2 — 구성원 095/096 "공식無" 경고 → **데이터 결함 아님 · 표출만 CODE_CTRACK(저순위)**

- 095/096 공식 0행 = **all-in 부모공식 설계와 정합**. COMP_PCB_* 단가에 내지인쇄+표지+제본+코팅 포함 — 구성원 공식 신설 시 **이중합산**(기지 S1/S2 이중합산 계열). 데이터 교정 금지.
- 표출 경로: `price_views.py:1752 has_formula` → 템플릿 :685 공식無 배지·`pricing.py:904→910` "가격 소스 없음" 경고 승격.
- 위임 명세(저순위): 부모 all-in 공식 존재 셋트에서 구성원 has_formula=False 경고를 정보성("가격은 셋트공식에 포함")으로 강등 — sim_meta에 parent-formula 플래그 동봉+템플릿 분기.

## R2-D3 — 옵션그룹 9종 시뮬레이터 노출 0 → **by-design(2026-06-28 결정·relitigate 금지) · 조치 NO-OP**

- `price_views.py:1474-1480` `opt_groups=[]` 하드코딩(의도 결정). 가격작용 유일 경로=comp use_dims의 opt_cd+opt_grp 범위 → `:1396-1404` frm_opt_grps(OPT_000082) 한정 opt_cd 드롭다운이 20P/30P 정상 렌더·매칭(실증 450,000). **가격 관점 노출 완전.**
- 표지코팅(무광 1)·제본(떡제본 1)·셋트구성은 단일 dflt=Y + all-in 단가 포함 → 미노출이 금액 왜곡 0. 손님 선택 UI=위젯 CPQ(§6) 소관(데이터는 건강 적재됨). coat_side_cnt 드롭=기지 C트랙(price_views.py:1930) 연접 표기만 — 엽서북은 코팅 별도과금 아님이라 금액 영향 0.

## R2 종합

```
[데이터] 468 단가행·배선·CPQ·구성원 dim 전 층 건강 (R1-D1/D2 해소 확인)
[CODE]  set_selections siz_cd 미전파(R2-D1 = R1-D3) ← 화면 0원의 유일 결정 축
[설계]  구성원 공식無(R2-D2)·opt_groups=[](R2-D3) = 정합/의도 — 조치 불요(표출 개선만 저순위)
```

- **dataFixable(round2): 아니오** — 3건 모두 데이터 교정으로 해소 불가/불요. R1-D3 코드 착지 시 즉시 450,000 수렴 예상.
- 읽기전용 준수: SELECT만 수행·쓰기 0건.
