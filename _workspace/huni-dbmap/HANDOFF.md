# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-07(최신). 권위 goal=`docs/goal-2026-06-06-02.md`. 본 문서 + 아래 메모리를 읽으면 재발견 0으로 재개. 이전 round-2/4/5·plate 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**디지털인쇄 원자합산형 가격엔진 설계 완료**(미설계분 닫음·검증 GO). round-2가 단순형(FIXED) 10공식만 완성하고 누락했던 디지털인쇄 SUM 공식 6종(PRF_DGP_A~F)을 설계·적재CSV·독립검증(V1~V6 전건 PASS·D-1~D-5 적발/해소)으로 산출. **국4절 LOADABLE 147행 GO**(공식6·COMP_PAPER 1·배선72·용지비49·바인딩19). DB 미적재(인간 승인 대기). 이전 plate(국4절 32상품 적재됨·c722c24)·round-5 미적재(GP원형/ENV/박/자재정규화)는 잔존.

## 다음 시작점 (정확한 다음 행동)
1. **[권고·인간승인 후] 디지털인쇄 가격엔진 국4절 147행 적재 실행본화(round-5 load-execution)** — 입력=`02_mapping/digital-print-engine/` GO 적재본(공식6·COMP_PAPER 1·배선72·용지비49·바인딩19). dbm-load-execution 스킬로 멱등 UPSERT SQL+로더+FK위상정렬+라이브 롤백 DRY-RUN(R1~R6). 적재순서: ①formulas+COMP_PAPER ②formula_components+component_prices ③product_price_formulas. 실 COMMIT은 인간 승인.
2. **[차단해소 큰 트랙] 3절·투명 plate 교정 + 디지털 가격 차단분** — 019 투명엽서·030 지그재그엽서·049 와이드접지리플렛은 **plate=작업사이즈(국4절 plate 교정 미적용분)**라 디지털 인쇄비 커버 0 → 가격 lookup 깸(BLOCKED). 국4절 plate 교정(c722c24)을 3절(330×660)·투명(315×467)로 확장 = HANDOFF 이전 #2와 동일 트랙. 신규 siz 채번(인간 승인) + 3절/투명 인쇄비·용지비 단가 정합 후 BLOCKED 바인딩 3 + 용지비 9 + 049 복귀.
3. **[잔여 인간승인/컨펌]** ①컨펌① 공식단위 배선(옵션 후보 전부 배선 — 런타임 옵션 게이팅 전제) ②048 접지리플렛 재바인딩(기존 PRF_FOLD_SUM→PRF_DGP_E, DELETE+INSERT 마이그레이션) ③박(대형) foil 슬롯 6행(foil 트랙 BLOCKER-1 해소 의존) ④use_yn=N 5상품(021/022/023/028/051) 노출/적재 시점.
4. **[기존 잔여] round-5 미적재**: GP원형(빌드 GO·`09_load/_migrate_gp_circle/`)·ENV봉투(`_exec_env/`)·박(CONDITIONAL-GO)·자재정규화(설계 완료).

## 미해결 / 블로커
- **국4절 147행 실 COMMIT**: 인간 승인 대기(설계+CSV+GO까지 산출, INSERT는 별도 승인).
- **3절/투명/049 가격 차단**: plate=작업사이즈 미교정이 근인. plate 교정 트랙과 동시 해소(신규 siz 채번 인간 승인).
- **박(대형) 단가**: foil 트랙(`02_mapping/price-foil-matrix-mapping.md`, CONDITIONAL-GO·BLOCKER-1) 의존. DGP-A·E에 슬롯만 예약(6행 차단).
- **048 재바인딩**: PK=(prd_cd,frm_cd)라 단순 INSERT 불가 → DELETE PRF_FOLD_SUM + INSERT PRF_DGP_E 마이그레이션(인간 승인).
- [기존] GP/ENV/박/자재정규화 인간 승인.

## 이번 세션 결정 (재론 금지)
- **디지털인쇄 = 원자합산형(FRM_TYPE.01), fit-gap ADEQUATE** — 신규 테이블/FRM_TYPE.03 불요. 6공식 전부 기존 6테이블 + COMP_PAPER 1종 신규로 흡수. 면적매트릭스형(G-3)은 디지털 무관.
- **용지비 = COMP_PAPER 단일 component**(PRC_COMPONENT_TYPE.03) + mat_cd(종이)×siz_cd(출력용지규격) 차원. 종이별 분리 component(120종) 과분할 금지. unit_price=import-paper 절가 verbatim·수량무관(min_qty=NULL).
- **곱셈계수(×출력매수·÷판걸이수·+손지율 5장)·판걸이수=앱 런타임. DB=[수량행단가] lookup만**. addtn_yn=합산 플래그뿐(곱셈 아님). 메모리 `dbmap-compute-in-app-db-stores-lookup` 정합.
- **별색=공정(G-1)**: COMP_PRINT_SPOT_*=PRC_COMPONENT_TYPE.01 인쇄비·clr_cd=NULL. 도수 매핑 금지(FK 위반).
- **PRC_COMPONENT_TYPE 라이브 6종**(.06 완제품비 포함 — 권위문서 stale 정정). COMP_CUT_FULL_DIECUT=.06 완제품비(.04 아님).
- **종이 mat_cd 차단 0건**: 디지털인쇄용지 58종 전부 라이브 t_mat 선존재(당초 우려 해소).
- **plate=작업사이즈 미교정 상품(019/030/049)은 가격 LOADABLE 불가** — 디지털 인쇄비가 출력용지규격 siz(SIZ_000077/499) 전용이라 작업사이즈 plate는 커버 0.

## 건드리지 말 것 (확정 산출)
- **디지털인쇄 가격엔진 GO 적재본**: `02_mapping/digital-print-engine/` (LOADABLE 147행·검증 GO). 재설계 금지·재적재 시 권위.
- 검증 게이트: `03_validation/digital-print-engine-gate.md` (V1~V6 + V2연장 전건 PASS·D-1~D-5 해소이력). §0/§7/§8이 권위.
- **국4절 plate 적재분**(라이브 반영·c722c24·검증 통과). `09_load/_migrate_plate_load_guk4/backup_state_20260607_092507.sql`(undo).
- 폐기 이력(인용 금지): `08_remediation/plate-size-remodel-design.md`·`plate-size-correction-design.md`·`04_audit/plate-size-live-diagnosis.md`.
- [기존] `09_load/_exec*`·`_migrate_*` GO 적재본.

## 핵심 산출물 (이번 세션)
- 설계: `02_mapping/digital-print-engine/digital-print-price-engine-design.md` (fit-gap ADEQUATE·6공식·용지비 차원모델·차단 정직표기·보정이력 D-1~D-5)
- 적재CSV(GO): `t_prc_price_formulas_DGP`(6)·`t_prc_price_components_PAPER`(1)·`t_prc_formula_components_DGP`(72)·`t_prc_component_prices_PAPER`(49)·`t_prd_product_price_formulas_DGP`(19) + provenance + BLOCKED(siz 용지비9·foil 6·바인딩3)
- 검증: `03_validation/digital-print-engine-gate.md` (GO)
- 권위문서 정정: `00_schema/price-engine-ddl.md`·`price-engine-fk-refs.md` (PRC_COMPONENT_TYPE 6종+.06 완제품비, D-3)
- 메모리: `dbmap-digitalprint-atomic-formula-unbuilt`(설계 완료로 갱신)
- 커밋: 본 핸드오프 커밋

## 하네스 운영 메모 (다음 세션 주의)
- **가격 정합 = 단가 아닌 공식 사슬 전체**(formula→formula_components→product_price_formulas). 단가 적재 ≠ 가격조회 가능(round-2 핵심 교훈, 이번에 사슬 연결로 해소).
- **plate=작업사이즈 미교정 = 가격 LOADABLE 차단 신호**. 디지털 인쇄비는 출력용지규격 siz 전용. 새 디지털 상품 가격조회 가능화하려면 plate 교정 선행.
- 스키마 표면 행대조 금지 — 컬럼/note/플래그/FK를 라이브로 먼저 규명(메모리 `dbmap-schema-deep-analysis-first`).
- 빌더/검증 에이전트 spawn 시 "자가커밋 금지" 명시. 실 COMMIT·siz채번·코드행등록·DDL적용은 인간 승인. 생성·검증 분리(R6)로 D-5까지 적발됨.
