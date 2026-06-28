# 갭 감사 — D6 책자 반제품/세트 구조 · D9 버그 B1~B5 (webadmin 코드 정적분석)

> 대상: `raw/webadmin/webadmin/catalog/{models.py, pricing.py, admin.py, views.py, price_views.py, cfg_utils.py, templates/}`
> 권위: `PRINCIPLES-call-analysis-260628.md` D6·D9 (통화 SOT).
> 방법: 코드 정적분석만(라이브 접속·DB 쓰기 0). 각 항목 file:line 근거 + 갭 판정. 추정은 "가설" 명시.
> 라우팅 약칭: §23=셋트 하네스 · §18=가격엔진 설계 · §27=가격 마스터 오케스트레이터 · **C트랙**=webadmin 코드수정(개발팀).

---

## A. D6 — 책자 반제품 / 세트 구조

데이터모델 결론 먼저: **셋트 구조의 그릇(스키마)은 코드上 거의 완비**되어 있다. 갭은 "데이터모델 부재"가 아니라 ① 일부 컬럼이 화면에서 제거됨(sub_prd_qty) ② 면지 1~4 동적노출·제본세부 옵션 구조가 미결(데이터/운영 결정) ③ 가격 구성원 수량(내지 총매수) 산출이 뷰 레이어 외부 의존이라는 점에 있다.

| 결정/항목 | 코드 근거(file:line) | 현재 동작 | 갭/근본원인 | 심각도 | 라우팅 |
|---|---|---|---|---|---|
| **셋트=완제품 prd_cd ← 반제품 sub_prd_cd** | models.py:464-482 `TPrdProductSets`(복합PK `prd_cd`+`sub_prd_cd`, FK 둘 다 `TPrdProducts`) | 셋트 완제품이 하위 반제품들을 구성원으로 보유. del_yn 논리삭제. | **갭 없음**. 표지/면지/내지를 각각 sub_prd_cd 행으로 표현 가능. D6의 "레더하드커버=표지+면지" 구성 표현 가능. | — | §23(설계·적재) |
| **내지 개수제약 min/max/증가단위** | models.py:469-471 `min_cnt`·`max_cnt`·`cnt_incr`(전부 nullable Integer) | 컬럼 실재. admin 인라인에서 입력 가능(admin.py:1020-1030 라벨/도움말). | **갭 없음(스키마)**. "내지 1~N·면지 1~1·표지 1~1"을 min/max로 표현 가능. ★단 라이브 데이터 적재 여부는 미확인(읽기전용 제약). | Low | §23 |
| **sub_prd_qty(하위상품수량) 화면 제거** | admin.py:1016-1020(폼 fields에서 제외), 1032-1036(clean에서 `sub_prd_qty = min_cnt or 1` 주입) | NOT NULL이라 clean이 `min_cnt or 1`로 강제 주입. 화면엔 미노출("용도 미확정"). | **갭(의미 모호)**. sub_prd_qty(개당 수량)와 min_cnt(구성 개수)가 의미 중첩. 가격 산출 시 어느 게 권위인지 미정. | Medium | §23(의미 확정)→C트랙(필요시 컬럼 정리) |
| **면지 하위 자재(화이트/블랙/그레이=종이)** | models.py:321-337 `TPrdProductMaterials`(prd_cd별 자재); views.py:544 materials 섹션 | 면지=별도 반제품(TPrdProducts) → 그 반제품의 materials 섹션에 자재 등록. | **갭 없음(경로 존재)**. D3 "면지=용도 아닌 소재 주의"와 정합 — 면지 반제품 아래 종이 자재 3종 등록 가능. 단 이는 **데이터 작업**(반제품 신설+자재 적재). | Low | §23/§7(dbmap 반제품·자재 적재) |
| **면지 시뮬엔 1~4 노출** | models.py:469-471(min/max), price_views.py:1311(qty_rule만 incr 처리) | min_cnt/max_cnt는 셋트 구성 개수일 뿐, **시뮬레이터가 셋트 구성원 개수를 1~4 드롭다운으로 렌더하는 로직은 미발견**. | **갭(UI 미구현 가설)**. evaluate_set_price는 `members` 배열을 호출자가 조립(pricing.py:849). 셋트 구성원 개수 선택 UI는 set_products.html에 없음(set_products.html=구성 등록만). | Medium | C트랙(시뮬/위젯 UI)·§23(데이터 선결) |
| **제본=완제품(셋트) 공정** | pricing.py:919-923(셋트 완제품 자기 공식=제본/조립, `set_eval = evaluate_price({prd_cd: set_prd_cd}, set_selections, copies, …)`) | 셋트 완제품의 자기 가격공식(=제본)을 부수(copies) 기준으로 1회 평가. | **갭 없음(설계 정합)**. D6 "제본=완제품 공정"이 코드에 그대로 구현. 제본종류(중철/무선…)는 set_selections/set_procs로 전달. | — | §18(제본 공식 설계)·§23 |
| **셋트가 계산 = Σ구성원공식 + 셋트제본공식** | pricing.py:813-818(주석), 883-923(구성원 evaluate_price 합산 → base_total += set_contrib) | 구성원별 `evaluate_price` 호출(할인 미적용)→합산, 셋트 완제품 공식 별도 합산, **할인은 합산 후 셋트 기준 1회**(934-945). | **갭 없음(하이브리드 모델 정확)**. 메모리 SOT의 "책자=셋트 하이브리드(구성원별 공식+셋트 제본)"와 일치. | — | §18/§23 |
| **구성원 수량(내지 총매수) 산출** | pricing.py:815-816(주석 "fn_calc_pansu는 DB 함수라 뷰 레이어 계산"), 820-841 `derive_inner_sheets`(총내지매수=부수×⌈페이지/(판걸이수×면수)⌉) | evaluate_set_price는 구성원 qty를 **호출자가 산출해 넘김**(members[].qty). derive_inner_sheets 헬퍼는 있으나 pansu(판걸이수)는 DB 함수 의존. | **갭(경계 의존)**. 내지 총매수 산출이 뷰 레이어+DB 함수(fn_calc_pansu)에 분산. 셋트 시뮬레이터 종단 호출부 미발견(읽기 범위 내). | Medium | C트랙(셋트 시뮬 호출부)·§23(검증) |
| **제본세부(방향·면지옵션·링컬러·D링)=공정 하나에 묶임** | models.py:534-550 `TProcProcesses.prcs_dtl_opt`(JSONField 공정상세옵션), price_views.py:79-95 `proc_detail_inputs` | 공정상세=`prcs_dtl_opt` JSONB(상위공정 상속). 한 공정 내부 재입력(줄수/면 등)을 동적 입력으로 처리. | **갭(미결=공정상세 vs 옵션)**. SOT D6 ★미결 그대로. prcs_dtl_opt로 "공정상세" 표현은 가능하나, 링컬러/D링을 공정상세로 둘지 옵션그룹으로 둘지 결정 안 됨. | Medium | §23/운영결정 → 결정 후 §18·C트랙 |

**D6 종합:** 그릇은 완비(특히 min/max/incr·하이브리드 가격). 실제 갭은 (1) **셋트 구성원 개수 선택 시뮬/위젯 UI 미구현(가설)**, (2) **sub_prd_qty↔min_cnt 의미 중첩**, (3) **제본세부 공정상세 vs 옵션 미결**, (4) 내지 총매수 산출 경계가 DB함수에 의존. 전부 데이터·설계·UI 영역이며 스키마 결함 아님.

---

## B. D9 — 버그 B1~B5 (회귀방지 대상)

### 핵심 분류 (코드결함 C트랙 vs 데이터결함 하네스)

| 버그 | 판정 | 한 줄 근거 |
|---|---|---|
| **B1** 자재 저장 500 | **코드결함(C트랙)** | 동시 삭제+수정 시 복합PK 충돌/논리삭제-재생성 경합 — views.py 행 루프 트랜잭션 처리 결함 |
| **B2** 두줄 소실 | **코드결함(C트랙, 프론트엔드)** | 시뮬레이터 공정상세 캐시가 인덱스 키잉 + detail-empty early-return — POST 충돌 아님 |
| **B3** Step 미적용 | **혼합 — Max무시=코드결함 확정 / Step1씩=데이터갭 의심** | `<input>`에 max 미바인딩(코드) + `step=incr||1` 폴백(incr NULL이면 데이터) |
| **B4** 인쇄/인쇄옵션 중복 | **데이터결함(하네스)** | 인쇄옵션=별도 테이블(print_options), 공정에 "인쇄" 중복 등록 + 디지털인쇄 공정 누락 = 데이터 정리 |
| **B5** 옵션·자재 중복노출(고리) | **데이터결함(하네스, D4 분류 미적용)** | 고리를 옵션과 자재 양쪽 등록 = 분류 미확정 데이터 |

---

### 상세 표

| 버그 | 코드 근거(file:line) | 현재 동작 | 갭/근본원인 | 심각도 | 라우팅 |
|---|---|---|---|---|---|
| **B1 자재 저장 500**(자재 2건 삭제+1건 변경 동시저장) | views.py:896 `section_edit`(materials); 938-1007 행 루프(단일 `transaction.atomic()` 941); 983-1003 이름변경(=키변경) 분기; cfg_utils.py:80-98 `logical_delete`; models.py:321-323(복합PK `prd_cd+mat_cd+usage_cd`) | row 인덱스 순서대로 각 행 처리: DELETE는 `_logical_delete`(del_yn='Y'), 키변경 행은 옛키 논리삭제→충돌행 revive 또는 `update_or_create`. 모두 한 트랜잭션. | **코드결함 가설(돈X·운영차단)**. ① 복합PK 모델에서 키변경(mat_cd/usage_cd 변경) 시 `update_or_create(prd_cd=prd, **nat, defaults=data)` — `nat`은 FK **인스턴스**(line 996 주석이 명시: new_nat=pk면 create에서 ValueError→500). ② **동시 삭제+수정**: 같은 usage_cd를 한 행은 삭제·다른 행은 그 키로 변경 시, 논리삭제(del_yn='Y')된 충돌행 revive 분기(991-994)와 update_or_create(1003)가 같은 자연키를 두 번 건드려 **복합PK UNIQUE 충돌** 또는 ManagedFalse+CompositePK의 update_or_create 라운드트립 실패 가능. ③ 개별수정은 정상(SOT) → 다중 행 동시 처리 시 행간 키 경합이 트리거. | **High**(저장 차단·운영) | **C트랙(개발팀)**. 회귀테스트=materials 2삭제+1키변경 동시 POST → 500 재현. |
| **B2 두줄 소실**(OC 두줄+미싱 추가 시 '두줄' 소실, 프리미엄엽서) | price_simulator.html:351-359 `syncProcDetails`(354 detail-empty early-return), 368·386(`proc-d-<i>-<key>` 인덱스 키잉), 422-428 POST 조립(`procs[]` 배열); views.py:1507 `_collect_proc_detail`(admin 저장경로·시뮬과 무관); price_views.py:1392 `o["detail"]=proc_detail_inputs` | 시뮬레이터: 공정 추가 시 syncProcDetails로 기존 detail 백업→renderProcs 재렌더. 상세입력 id=배열인덱스 i 기준. POST는 `[{proc_cd,detail}]` 배열. | **코드결함(프론트엔드 한정·가설)**. POST는 배열이라 필드명 충돌 없음. 소실 메커니즘=① 상세입력 id가 proc_cd 아닌 **배열인덱스 i 키잉**(368)→재렌더 인덱스 시프트 시 칸 어긋남, ② OC 공정의 `detail` 메타(proc_detail_inputs 결과)가 PROC_OPTS 항목에 비면 `syncProcDetails` 354행 early-return으로 **백업 자체가 skip**→미싱 추가 재렌더 시 빈값 복원. **백엔드 `_collect_proc_detail`(views.py:1507)은 admin 옵션 드릴다운 저장경로라 시뮬 소실과 무관**. | **High**(잘못된 견적·돈) | **C트랙(프론트)**. 검증=OC 하위공정의 `TProcProcesses.prcs_dtl_opt['inputs']`·상위공정 상속 채워졌는지 확인. |
| **B3 Step 미적용**(증가분 15인데 1씩·Min/Max 무시) | price_simulator.html:296-298(`<input type=number ... min="${qr.min??1}" step="${qr.incr\|\|1}">`, **max= 미바인딩**), 441-442(submit시 vmsg가 min/max/incr 검사); price_views.py:1311(`qty_rule={min,max,incr,dflt}` 정상 전달); models.py:517-520(컬럼 실재) | 위젯에 step·min은 바인딩, **max는 속성 없음**. 계산 버튼 누르면 vmsg가 위반 검출하나 입력단 클램프는 step만. | **혼합**. ★**Max 무시=프론트엔드 확정 결함**(298행에 `max=` 자체 없음). ★**Step 1씩=데이터갭 의심(가설 A)**: `step="${qr.incr\|\|1}"`가 incr를 읽도록 작성됨 → 라이브 `TPrdProducts.qty_incr`가 **NULL**이면 `\|\|1` 폴백으로 step=1. 즉 코드는 옳고 데이터 미적재가 표면 증상화. | **Medium** | **혼합**: Max미바인딩=**C트랙(프론트)**. Step=먼저 **하네스/§7**(해당상품 qty_incr 라이브 값 확인·NULL이면 적재) → 값 있는데도 1씩이면 C트랙. |
| **B4 인쇄/인쇄옵션 중복**(프리미엄엽서: 공정에 인쇄 + 단/양면 별도·디지털인쇄 누락) | models.py:420-439 `TPrdProductPrintOptions`(print_side 인쇄면+front/back 도수, **별도 테이블**); models.py:446-461 `TPrdProductProcesses`(공정); views.py:540-541(print_options 섹션)·546-547(processes 섹션) | 인쇄면(단/양면)+도수=`print_options` 테이블. 공정=`processes` 테이블. 두 테이블이 독립. | **데이터결함**. 인쇄(단/양면·도수)는 **print_options가 정본 위치**인데, 같은 "인쇄"가 공정(processes)에도 중복 등록되어 손님에게 이중 노출. + "디지털인쇄"가 공정으로 누락(SOT: 공정에 디지털인쇄 추가 보정). **스키마는 둘을 구분하므로 코드결함 아님 — 데이터 정리**. | **Medium** | **하네스(데이터)**: §7/§21 정합(프리미엄엽서 print_options vs processes 중복 제거·디지털인쇄 공정 추가). D2 인쇄종류 누락 보정과 연결. |
| **B5 옵션·자재 중복노출**(아크릴키링 고리 양쪽) | models.py:255-269 `TPrdProductAddons`/옵션 레이어 vs models.py:321-337 `TPrdProductMaterials`; SOT D3(부자재=자재 제외)·D4(고리=추가상품 우선) | 고리가 옵션(또는 addon)과 자재(materials) 양쪽에 등록되어 양쪽 노출. | **데이터결함(D4 분류 미적용)**. D3 "자재=메인 인쇄매체만·부자재(고리/볼체인)=추가상품/옵션" 미적용. 고리를 materials에서 빼고 추가상품(우선) 또는 옵션그룹으로 일원화 = 데이터 재분류. 코드결함 아님. | **Low~Medium** | **하네스(데이터)**: §7/§21·D4 분류 적용(고리=materials 제거→addon/옵션). 메모리 `addon-optcd-model-broken-live` 주의(addon 정식=템플릿). |

---

## C. 회귀방지 권고 (C트랙 전달용 — 개발팀)

- **B1**(High): `section_edit` materials 행 루프(views.py:938-1007)에서 **삭제를 먼저 전부 처리 → 그 다음 수정/생성**(2-pass)으로 분리하거나, 복합PK 키변경 시 `update_or_create`에 FK **인스턴스**(nat) 보장(line 996 주석대로). 회귀테스트=2삭제+1키변경 동시 POST.
- **B2**(High): 시뮬레이터 공정상세 캐시를 **인덱스 i → proc_cd 키잉**으로 변경(price_simulator.html:368), `syncProcDetails` 354행 early-return이 detail-empty 공정의 입력값을 버리지 않게.
- **B3**(Medium): price_simulator.html:298 `<input>`에 `max="${qr.max??''}"` 추가(Max 클램프). Step은 데이터 선확인.
- **B1·B2는 돈/운영 크리티컬** — B2는 잘못된 공정상세로 견적 오류(돈), B1은 저장 차단(운영).

## D. 미발견·미확인(정직 표기)
- 셋트 구성원 **개수 선택 시뮬/위젯 UI**(면지 1~4 드롭다운) 종단 렌더 코드: **미발견**(set_products.html=구성 등록 전용). 가설=미구현.
- evaluate_set_price **종단 호출부**(시뮬레이터가 셋트가를 호출하는 뷰): 읽은 범위(pricing.py·price_views.py 1300-1400)에서 **미발견**. 내지 총매수 산출(fn_calc_pansu)은 DB 함수 의존.
- B1의 정확한 500 스택: 라이브 재현 불가(읽기전용)이라 **가설**. update_or_create+복합PK+동시 키경합이 가장 유력.
- B3 Step: 해당 상품 `qty_incr` 라이브 값 **미확인**(읽기 범위 외) — NULL 여부가 데이터 vs 코드 확정 분기.
