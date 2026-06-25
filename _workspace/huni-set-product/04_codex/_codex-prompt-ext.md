# 독립 교차검증 의뢰 — 후니프린팅 셋트상품 구성(남은 6셋트: 책자류5 + 떡메모지)

너는 인쇄 자동견적 DB의 **독립 2차 검증가**다. 아래 설계·권위·적재본을 읽고 **너 스스로** 결함/타당성을 판정하라.
(다른 검증가의 결론은 주지 않는다 — 독립 판정이 목적이다.) 라이브 DB에 접속하지 말고 **주어진 파일만** 근거로 하라.
모든 주장에 파일/행 근거를 달고, 확신 못하는 건 "확인 필요"로 분류하라.

## 배경 (도메인)
- 셋트 완제품 = 표지+내지/면지+제본/조립으로 만드는 부품조립형 상품. 구성원(sub_prd_cd)은 전부 반제품(PRD_TYPE.02)이어야 한다.
- 가격: `evaluate_set_price`(pricing.py:718) = Σ(구성원 evaluate_price) + 셋트 완제품 자기 공식 evaluate_price + 할인1회. `members`는 **호출자가 런타임에 전달하는 배열**(`for mb in members`).
- 라이브 t_prd_product_sets 스키마: PK=(prd_cd,sub_prd_cd), 컬럼=prd_cd,sub_prd_cd,sub_prd_qty,disp_seq,note,min_cnt,max_cnt,cnt_incr,del_yn,reg_dt,upd_dt 등. **semi_role_cd 컬럼은 라이브에 없다**(역할은 note로만).
- 대상 6셋트: PRD_000072(하드커버책자·표지1+면지3)·077(레더 하드커버책자·표지1+면지3)·082(하드커버 링책자·표지1+면지4)·088(레더 링바인더·표지1+면지4)·097(떡메모지·내지1)·100(포토북·내지1+표지5+면지1). 엽서북(094)은 별건(이미 처리됨, 이 검증 대상 아님).

## 검토할 입력 파일 (이 디렉토리 기준 — **반드시 -ext 접미사 파일**)
- `03_design/set-composition-design-ext.md` — 셋트 구성 설계 본문
- `03_design/apply-ext.sql` — 적재본 SQL(멱등 UPDATE/UPSERT)
- `03_design/t_prd_product_sets-ext.csv` · `03_design/t_prd_products-ext.csv` — 적재 데이터
- `03_design/blocked-board-ext.csv` — 보류 항목
- `01_authority/set-authority-spec.md` · `set-checklist.csv` · `product-type-board.csv` · `reuse-map.md` — 권위 기준

## 독립 판정할 6개 질문 (각각 PASS / FAIL / 확인필요 + 근거)

1. **구성원 유형**: 6셋트의 26개 sub_prd_cd가 전부 **반제품(PRD_TYPE.02)**인가? 완제품/기성/디자인 혼입이 0인가? 부모 6개를 prd_typ_cd 04(디자인)→01(완제품)로 교정하는 것이 타당한가?
2. **★택1 함정**: 하드커버/링책자/포토북의 동일 역할(면지·표지) 다중 구성원이 **평면 합산(always-add) 오염**인가, **택1 카탈로그**(손님이 1색만 선택)인가? 설계는 "현행 유지(member 공식0·차원0이라 동시 합산해도 contribution=0=합산오염0)"라 판정하고 행을 보존했다. 이 판정이 타당한가? 가격공식 신설 시 평면 합산이 과대청구로 전환될 위험(GUARD-1)을 정확히 식별했나?
3. **가격 가능성**: 6셋트 부모·구성원 가격공식이 전부 0이라 evaluate_set_price base_total=0 → **PRICE=0 견적불가**가 맞는가? 이를 "comp는 있는데 미바인딩(=오청구)"이 아니라 "셋트공식·구성요소 진성 부재(견적자체불가)"로 구분한 것이 타당한가? 이중합산은?
4. **무결성**: 복합PK 중복 0? FK 고아 0? disp_seq 단조증가? 유형 UPDATE 멱등(`IS DISTINCT FROM`)? 셋트 UPSERT 멱등성(`ON CONFLICT DO UPDATE`에서 항상 upd_dt=now())?
5. **개수규칙 미충전**: 6셋트 전부 min/max/incr를 NULL 유지한 판정(하드커버/링책자=내지 member 행 자체가 없음[내지=MES별도설정]·페이지 가변은 부모상품 옵션이지 셋트 member 범위 아님·떡메=권위 페이지 공란·포토북=CONFIRM-3 권위 미특정)이 타당한가? 권위에 페이지 가변범위(하드24~300/+2·링8~100/+2)가 명시돼 있는데 NULL 유지가 옳은가?
6. **false-positive / 누락**: 정당한 구조(다중 면지=택1)를 결함으로 오판하지 않았나? 반대로 진짜 오염(예: 떡메 묶음수, 포토북 표지5종, apply.sql과 본문/csv 불일치, disp_seq/note 모순)을 놓치지 않았나?

## 추가로 네가 독립 발굴할 것
- 설계가 **놓친** 결함(가격 silent 합산, 차원 미충전, disp_seq/note 모순, 멱등성 깨짐, apply-ext.sql과 본문/csv 불일치 등).
- 설계가 **과하게 막은**(false-positive) 정상 구조.
- apply-ext.sql과 set-composition-design-ext.md / csv 사이의 **불일치**(특히 본문은 "UPDATE·신규 mint 0"인데 SQL은 INSERT … ON CONFLICT인 점, 떡메/포토북 행 개수, disp_seq 매핑).

각 질문마다 결론(PASS/FAIL/확인필요)·근거(파일:행)·이유를 간결히. 마지막에 "종합: 이 6셋트 적재본을 적용해도 되는가"를 한 문단으로.
