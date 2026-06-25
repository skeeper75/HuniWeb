# 독립 교차검증 의뢰 — 후니프린팅 셋트상품 구성(엽서북 PRD_000094)

너는 인쇄 자동견적 DB의 **독립 2차 검증가**다. 아래 설계·권위·적재본을 읽고 **너 스스로** 결함/타당성을 판정하라.
(다른 검증가의 결론은 주지 않는다 — 독립 판정이 목적이다.) 라이브 DB에 접속하지 말고 **주어진 파일만** 근거로 하라.
모든 주장에 파일/행 근거를 달고, 확신 못하는 건 "확인 필요"로 분류하라.

## 배경 (도메인)
- 엽서북 = 표지(스노우300)+내지(몽블랑240)+떡제본으로 만드는 **완제품 셋트**. 셋트 부모 prd_cd=PRD_000094.
- 구성원: PRD_000095(내지)·PRD_000096(표지). 둘 다 반제품(PRD_TYPE.02)이어야 한다.
- 가격: `evaluate_set_price` = Σ(구성원 evaluate_price) + 셋트 완제품 자기 공식 evaluate_price + 할인1회.
- 셋트 완제품(94)은 자기 가격공식 **PRF_PCB_FIXED**(엽서북 사이즈/면/페이지/수량별 고정단가)를 가진다.
- 구성원(95·96)은 가격공식·사이즈·공정이 전부 0(없음).
- 라이브 t_prd_product_sets 스키마: PK=(prd_cd,sub_prd_cd), 컬럼=prd_cd,sub_prd_cd,sub_prd_qty,disp_seq,note,min_cnt,max_cnt,cnt_incr,del_yn,reg_dt,upd_dt 등. **semi_role_cd 컬럼은 라이브에 없다**(역할은 note로만).

## 검토할 입력 파일 (이 디렉토리 기준)
- `03_design/set-composition-design.md` — 셋트 구성 설계 본문
- `03_design/apply.sql` — 적재본 SQL(멱등 UPDATE/UPSERT)
- `03_design/t_prd_product_sets.csv` · `03_design/t_prd_products.csv` — 적재 데이터
- `03_design/blocked-board.csv` — 보류 항목
- `01_authority/set-authority-spec.md` · `set-checklist.csv` · `product-type-board.csv` · `reuse-map.md` — 권위 기준

## 독립 판정할 6개 질문 (각각 PASS / FAIL / 확인필요 + 근거)

1. **구성원 유형**: sub_prd_cd(95 내지·96 표지)가 전부 **반제품(PRD_TYPE.02)**인가? 완제품/기성/디자인 혼입이 0인가?
2. **가격 가능성**: 엽서북이 PRF_PCB_FIXED로 evaluate_set_price가 **PRICE≠0**으로 계산되나? 이중합산(같은 비용이 구성원에도 셋트공식에도 들어가 두 번 더해지는 것)이 0인가? 30P 같은 단가 누락은?
3. **무결성**: 복합PK (94,95)/(94,96) 중복 0? FK 고아 0? 개수규칙(내지 min20≤base≤max30·incr10) 정합? 유형 UPDATE(04→01) 멱등한가(apply.sql의 `IS DISTINCT FROM` 가드)?
4. **권위 정합**: 적재 구성·수량이 상품마스터 권위(booklet-l1 row61: 내지 몽블랑240·페이지20~30/+10, 표지 스노우300)와 일치하나? 경쟁사 naming/codes 유입이 0인가?
5. **false-positive**: 정당한 셋트 구조(엽서북=표지1·내지1, 구성원가 0이라 셋트공식 단독견적)를 결함으로 오판하지 않았나? 설계가 정상 구조를 결함으로 잘못 막은 곳은?
6. **면지 정규화 스펙 타당성**: 설계 §4가 "면지 자재 4종(MAT_000001~004 화이트/블랙/그레이/인쇄면지)이 출력소재가 아닌 용도성인데 자재 마스터에 오등록"이라 판정하고, 엽서북엔 N/A(영향0)·확장 phase로 분리한 것이 타당한가? 재배선 스펙(논리삭제+출력소재 귀속+용도축 분리)이 합리적인가?

## 추가로 네가 독립 발굴할 것
- 설계가 **놓친** 결함(가격 silent 합산, 차원 미충전, disp_seq/note 모순, 멱등성 깨짐, 적재본 SQL과 본문 불일치 등).
- 설계가 **과하게 막은**(false-positive) 정상 구조.
- apply.sql과 set-composition-design.md / csv 사이의 **불일치**.

각 질문마다 결론(PASS/FAIL/확인필요)·근거(파일:행)·이유를 간결히. 마지막에 "종합: 이 엽서북 셋트 적재본을 적용해도 되는가"를 한 문단으로.
