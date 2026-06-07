# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-07(최신). 권위 = 본 문서 + 메모리 `dbmap-cpq-option-layer-mapping`·`dbmap-cpq-configurator-design`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄 가격엔진) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-6 (CPQ 옵션 레이어 L2 매핑) 트랙 신설 + 실사 시트 전체 커버리지 확인 완료.** 라이브 CPQ 옵션 레이어(`t_prd_product_option_groups/options/option_items·templates·constraints`, 거의 비어있음)에 상품마스터/가격표의 **옵션성 속성을 어느 엔티티로 매핑할지**를 설계·검증. 핵심 = **매핑 2층위**(L1 차원/가격 적재 ≠ L2 옵션구조: 이미 적재된 차원행을 polymorphic `ref_dim_cd`로 **참조**해 선택옵션으로 묶음). 산출 = 마스터 지도(13시트 속성→4엔티티) + 엽서·현수막 파일럿(GO) + M-1 해소(열재단=실제 가공) + **실사 29상품 전체 커버리지(PARTIAL-YES)**. DB 미적재(설계·검증 문서까지·실 적재는 인간 승인).

## 다음 시작점 (정확한 다음 행동 — 택1)
1. **[권장·커버리지 확장] 아크릴/포스터사인 시트 커버리지** — 실사 시트를 완료했으니 마스터 지도 패밀리③의 나머지(아크릴 25상품)와 패밀리별 커버리지를 같은 방식(`silsa-coverage-map` 패턴)으로 확장. 또는 패밀리②(책자·캘린더)로 가서 **excl_group 마이그 실증(GAP-2)** — 두 파일럿 모두 미행사한 칸(라이브 GRP-BOOK 제본·GRP-CAL 캘린더 택일그룹을 option_group으로 변환).
2. **[GAP 닫기] dbm-ddl-proposer로 신규 SCHEMA gap 제안** — `cpq-option-gaps.md`의 8+1건 중 우선순위: **GAP-PARAM**(ref_param_json, 공정 파라미터 보존 — 타공 구수·봉제 폭·코팅 면·족자 모양, 복합옵션·실사 전반에서 재행사된 High) → **GAP-BOARD**(보드종류=자재vs가공vs형태, 신규·설계 결정 선행) → GAP-HIDDEN/OPT/COMPOSITE. heat-cut-process-proposal과 같은 search-before-mint 제안서 산출.
3. **[설계 결정 해소]** 미해결 design decision: ①잉크색=도수 vs 자유옵션그릇 ②용량(머그)=비치수 size vs 규격 ③면지/바인더링=자재 vs 공정/셋트 ④**보드종류(GAP-BOARD)** ⑤실내/실외 거치대=1 base vs 2 SKU. 사용자/도메인 확정 필요.
4. **[실 적재 — 인간 승인]** CPQ 옵션 레이어 GO 파일럿(엽서·현수막)의 INSERTABLE 행 실제 적재 + 차원행 선적재(부착081 124/139·별색122·각목셋트·열재단 공정 등). dbm-load-builder로 멱등 적재본 조립 후 인간 승인.

## 미해결 / 블로커
- **CPQ 적재 = 인간 승인 대기** — 모든 옵션 레이어 INSERT·차원행 선적재·코드행·DDL은 인간 승인(설계·검증 문서까지만 산출).
- **차원행 선적재(DATA gap, 다수)** — 부착 PROC_081은 **138 파일럿에만 적재**(124·139는 선적재 필요)·별색 PROC_008(122)·각목 셋트(138)·보드 자재(129·130·131·132·144)·addon 링크(135·136·137)·nonspec 범위. 선적재로 해소되나 인간 승인.
- **열재단 공정 신설(M-1)** — PROC_000084 `[CONFIRM-CHANNEL]` 채번=라이브 MAX 확인 후 후니 배정. `11_ddl_proposals/heat-cut-process-proposal` 제안서까지.
- **신규 SCHEMA gap GAP-BOARD** — 폼보드/포맥스 보드종류 엔티티 미확정(설계 결정 선행).
- **각목 셋트** — 각목 완제상품 자체 미등록 + sets 0행 → 복합옵션 seq2 BLOCKED. 상품 등록 선행.
- **실외용배너거치대** — base 상품 미등록(GAP-DATA).
- 설계 결정 5건(위 다음 시작점 §3).

## 이번 세션 결정 (재론 금지)
- **매핑은 2층위** — L1 원천적재(차원·가격, round-1~5)≠L2 옵션구조(CPQ 레이어). L2는 새 데이터 적재가 아니라 차원행 polymorphic 참조. **L2≠L1 혼동(차원 데이터를 option_items에 재적재)이 1차 실패모드**.
- **트리거 dispatch 정합(HARD)** — 도수=`opt_id`(NOT clr_cd)·자재=`mat_cd+usage_cd`·공정=`proc_cd`. 라이브 `fn_chk_opt_item_ref` 정확히 일치. 권위=`00_schema/cpq-schema.md §2`.
- **흡수/분할 입도(WowPress)** — 본체색=재질 합성·형상=규격 융합·인쇄면/잉크도수=도수·**별색=공정**·**코팅=공정**(PROC_014/015). 과분할 금지.
- **코팅·별색 = 공정 `.04`** — 신규 축이나 라이브 마스터에 공정으로 명시·차원행 적재됨(자재 합성 후보 기각, 모호 아님). 검증 PASS.
- **M-1 열재단 = ① 실제 가공**(3,000원, 가격표 권위) — ②기본마감 센티넬 아님. 도메인 일반론(비즈하우스 0원)만 보면 오판 → **가격표 명시값=권위**가 정정. 완칼 PROC_053 차용 폐기→신규 PROC_000084.
- **필수성 ≠ process link** — 옵션 필수성(택1·필수)은 CPQ `option_group.mand_yn`, process link는 후보 제공(mand_proc_yn=N).
- **적재 CSV = 라이브 컬럼만**(F-1 교훈, note 등 비라이브 컬럼 금지) · **BLOCKED 행은 별도 `*_BLOCKED.csv` 분리**(round-5 패턴).
- **복합옵션 차원행 COVERED는 상품별 재룩업 필수**(커버리지 over-claim 교훈) — 파일럿 1상품의 COVERED를 widening 시 이월 금지. L2 load-bearing = "그 prd_cd에 그 차원행이 실재하는가".
- **생성-검증 분리(R6)** — designer(option-mapper)≠gate(validator). 매 파일럿 validator가 실결함 적발(F-1 note·열재단 M-1·커버리지 over-claim).

## 건드리지 말 것 (확정 산출 · 검증 완료)
- **마스터 지도** `10_configurator/attribute-entity-map.md`(13시트 속성→4엔티티, 사용자 "각 속성 어디에 매핑" 직접 해소) — 재설계 금지.
- **GAP 레지스터** `10_configurator/cpq-option-gaps.md`(8+1건, GAP-BOARD 신규 포함) — ddl-proposer 입력.
- **검증 GO 파일럿**: 엽서 `postcard-option-layer.md`+`load/*`(검증 `cpq-option-validation.md` GO) · 현수막 `silsa-option-layer.md`+`load_silsa/*`(검증 `cpq-option-validation-silsa.md` GO).
- **M-1 결정 산출**: `m1-yeoljaedan-decision.md`(① verdict·3증거선) · 리서치 2종(`m1-yeoljaedan-{domain,competitor}-research.md`) · 공정 제안 `11_ddl_proposals/heat-cut-process-proposal.{md,sql}`.
- **실사 커버리지**: `silsa-coverage-map.md`(PARTIAL-YES) + 검증 `silsa-coverage-validation.md`(over-claim 정정 반영).
- **하네스 정의(신규·다음 세션부터 직접 사용 가능)**: 에이전트 `dbm-option-mapper` · 스킬 `dbm-cpq-option-mapping` · `dbm-validator`(CPQ 인지)·`huni-dbmap-orchestrator`(round-6). 커밋 7547703·6e0c8fc·9ea4d53·ac56535.
- [이전 트랙] 라이브 적재된 3트랙(디지털147·ENV40·GP121, undo.sh 안전망)·디지털인쇄 가격엔진·국4절 plate·round-1 할인. 재적재 금지.

## 하네스 운영 메모 (다음 세션 주의)
- **신규 에이전트 `dbm-option-mapper`는 이제 subagent_type으로 직접 spawn 가능**(이번 세션은 general-purpose 주입으로 가동했으나 레지스트리에 로드됨). dbm-validator도 CPQ 옵션 검증 인지.
- **트리거**: "CPQ 옵션 매핑"·"옵션 레이어 매핑"·"속성 엔티티 매핑 지도"·"상품군 옵션 파일럿"·"round-6"·"커버리지 분석" → `huni-dbmap-orchestrator` round-6 또는 `dbm-cpq-option-mapping` 스킬.
- **빌더/검증 에이전트 spawn 시 "자가커밋 금지"·"NO DB writes" 명시**. 실 COMMIT·siz채번·코드행등록·DDL적용은 인간 승인.
- **에이전트 반환이 빈약**(opus 4.x literal) — 산출물을 항상 Bash/Read로 직접 검증(행수·트리거 정합·XML 누출·BLOCKED 정직). 매 파일럿이 그렇게 실결함 적발.
- **권위 순서**: Excel/가격표 명시값 > 추출 스냅샷(ref-*.csv stale — 존재/등록 판정은 라이브 권위) > 설계 문서. 라이브 스키마+트리거 > 설계. `cpq-schema.md §4`(design↔live).
