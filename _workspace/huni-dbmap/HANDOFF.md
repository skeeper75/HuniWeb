# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-07(최신). 권위 goal=`docs/goal-2026-06-06-02.md`. 본 문서 + 아래 메모리를 읽으면 재발견 0으로 재개. 이전 round-2/4/5 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**판형=출력용지규격 도메인 규명 완료 + 국4절 32상품 plate 출력용지규격(SIZ_000499) 실제 적재 완료**(라이브 COMMIT·검증 전건 통과·커밋 c722c24). **핵심 발견: 디지털인쇄 원자합산형 가격엔진 "미설계"**(round-2가 단순형 10공식만 완성, 원자합산형 누락 → 디지털인쇄 ~28상품 가격조회 사슬 끊김). 이전 round-5 미적재(GP원형/ENV/박/자재정규화)는 잔존.

## 다음 시작점 (정확한 다음 행동)
1. **[최우선·큰 트랙] 디지털인쇄 원자합산형 가격엔진 설계+적재** — 권위=계산공식집초안(`06_extract/calc-formula-draft-l1.csv`: **판매가 = 인쇄비 + 코팅비 + 용지비 + 접지비 + 후가공비 + 후가공_박 + 추가상품**, 국4절/3절 기준). 필요: ① `PRF_DGP_*` 원자합산형 공식 신설(상품군별) ② `formula_components`: 공식⊃인쇄비(COMP_PRINT_DIGITAL)·코팅(COMP_COAT)·별색(COMP_PRINT_SPOT)·커팅(COMP_CUT)·**용지비(COMP_PAPER 신설)**·접지(FOLD)·박 ③ `product_price_formulas`: 디지털인쇄 ~28상품 바인딩 ④ **용지비 component+단가**(IMPORT 종이 120종별 국4절가/3절가, 종이=mat_cd). dbm-price-formula 트랙. 메모리 `dbmap-digitalprint-atomic-formula-unbuilt`.
2. **3절·투명 6상품 plate+가격 정합** — plate 설계 완료(`08_remediation/plate-load-from-master-design.md`: 신규 siz `330x660`·`315x467`, 6상품 PRD_000019/025/030/039/049/112). **G-1**: plate만 옮기면 가격조회 깸 → 가격엔진(1번)과 **동시 적용**. 신규 siz 채번 인간 승인.
3. **[기존 잔여] round-5 미적재**: GP원형(빌드 GO·`09_load/_migrate_gp_circle/`)·ENV봉투(적재본 `_exec_env/`·검증 GO)·박(CONDITIONAL-GO·BLOCKER-1)·자재정규화(설계 완료·`10_configurator/huni-goods-option-mapping.md`).

## 미해결 / 블로커
- **디지털인쇄 가격엔진 미설계(최우선)**: 28상품 가격조회 불가. 단가(component_prices 3,292)만 적재·공식 사슬(formula→formula_components→product_price_formulas) 없음.
- **3절·투명 6상품**: plate+가격 동시(G-1). 신규 siz 채번 인간 승인.
- **용지비 미적재**: IMPORT 종이 120종별(국4절가/3절가). COMP_PAPER 신설 필요.
- **출력용지규격 9종 중 스티커(330x470)/띤또레또(464x320)/타투(210x297)**: 디지털인쇄 외 별 계열.
- **인간 승인**: 신규 siz 채번·output_paper_typ_cd 정정의도(H-5)·PRD_000016 dflt_plt_yn='N'→'Y'(H-3)·공란상품3(오리지널박명함/봉투제작/썬캡).
- [기존] GP/ENV/박/자재정규화 인간 승인(이전 핸드오프).

## 이번 세션 결정 (재론 금지)
- **plate=출력용지규격**. 권위=**상품마스터 `파일사양_출력용지규격` 컬럼**(라이브 plate=작업사이즈는 잘못 기재). impos_yn=Y가 판형 사용 표시.
- 출력용지규격 **9종**·**종이 종속**(한 상품도 종이 선택 시 다종)·**전지(원지: 국전939×636)≠출력용지규격(인쇄단위)**. 3자(상품마스터·출력소재IMPORT·판걸이수) 일관(316x467 국4절·330x660 3절·315x467 투명).
- 국4절 32상품 plate→`SIZ_000499` 적재(작업사이즈 중복행 DELETE 101·INSERT 31·ORPHAN siz soft-delete 53). 가격 무변경.
- **미적재 핵심 = 디지털인쇄 원자합산형 가격엔진 "미설계"**(미적재 아님). round-2가 단순형(FIXED) 10공식만 완성·원자합산형(SUM, 디지털인쇄) 누락.

## 건드리지 말 것 (확정 산출)
- **국4절 plate 적재분**(라이브 반영·커밋 c722c24·검증 통과). 재적재 금지.
- `09_load/_migrate_plate_load_guk4/backup_state_20260607_092507.sql`(undo 자료).
- 폐기 이력: `08_remediation/plate-size-remodel-design.md`(공존)·`plate-size-correction-design.md`(316 단일)·`04_audit/plate-size-live-diagnosis.md`(프리미엄엽서 오등록 오판) — 권위 오판, 인용 금지.
- [기존] `09_load/_exec*`·`_migrate_*` GO 적재본.

## 핵심 산출물 (이번 세션)
- 3자 관계: `08_remediation/output-paper-3way-reconciliation.md`
- plate 적재 설계: `08_remediation/plate-load-from-master-design.md` + 게이트 `03_validation/plate-load-from-master-gate.md`(CONDITIONAL-GO·G-1 MAJOR)
- 국4절 실행본(적재완료): `09_load/_migrate_plate_load_guk4/` + DRY-RUN 게이트 `03_validation/plate-load-guk4-dryrun-gate.md`(GO)
- 메모리: `dbmap-platesize-is-output-paper`·`dbmap-digitalprint-atomic-formula-unbuilt`·`dbmap-schema-deep-analysis-first`
- 커밋: c722c24(산출물) + 본 핸드오프 커밋

## 하네스 운영 메모 (다음 세션 주의)
- **가격 정합 검증 시 단가(component_prices)만 보지 말 것** — 공식 사슬(formula→formula_components→product_price_formulas) 전체를 봐야 가격조회 가능 여부 판정. 단가 적재 ≠ 가격조회 가능(이번 세션 핵심 교훈).
- **스키마는 표면 행대조 금지** — 컬럼 전체 의미·note·플래그(impos_yn/use_yn)·FK 관계를 라이브로 먼저 규명 후 도메인 매핑(메모리 `dbmap-schema-deep-analysis-first`).
- 빌더/검증 에이전트 spawn 시 "자가커밋 금지" 명시. 실제 COMMIT·siz채번은 인간 승인.
