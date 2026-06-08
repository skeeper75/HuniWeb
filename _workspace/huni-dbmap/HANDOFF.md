# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-08(최신). 권위 = 본 문서 + `docs/goal-2026-06-08-01.md`(round-7) + 메모리 `dbmap-coverage-matrix-roundup`·`dbmap-live-admin-product-viewer`·`dbmap-l2-requires-l1-price-table`·`dbmap-option-material-process-bundle`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ·round-6 현수막) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-7 입체 커버리지 검증 실행 완료 — 독립 평가 GO(C1~C8 전건 PASS).** 전 상품군(11시트) × 라이브 t_* 엔티티 **209셀 매트릭스** 구축 + admin 3원대조 + 관계무결성 + 갭보드 산출, `evaluator-active`(fresh context)가 행수 10셀·R1/R4/R7·admin 3종을 독립 재측정해 전건 일치 확증. 사용자가 요구한 "전체 입체 조망"의 DoD(goal §7) 충족. **DB 미적재 — 검증/조망 전용, 발견 미적재의 실 적재는 인간 승인.**

## 이번 세션 핵심 결정·발견 (재논의 금지)
- **[실행] round-7 매트릭스 GO** — `12_coverage/`에 209셀(✅51·🟡44·❌49·◆17·➖48) 매트릭스. admin 자격증명을 `.env.local` `HUNI_ADMIN_URL/ID/PW`(admin/retail00534!!)에 저장 → gstack browse 로그인 성공, 대표상품 3종(PRD_000016 엽서·PRD_000111 캘린더·PRD_000193 머그컵) admin=DB 100% 일치.
- **[횡단 발견] CPQ 옵션 레이어 전면 미적재** — `t_prd_product_option_items` 전역 **0행**(R7 FAIL). round-6 설계 GO분(일반현수막·OPP봉투)이 option_groups/options만 껍데기 적재(items 0) = 실 COMMIT 미완. ~28갭 → dbm-option-mapper.
- **[횡단 발견] 가격 사슬 6 상품군 미적재** — 포토북·캘린더·디자인캘린더·아크릴·굿즈파우치·상품악세사리 공식 부재(단절 아닌 부재, 적재분 사슬은 R4 PASS). → dbm-price-formula.
- **[횡단 발견] DB-ONLY 17셀** — 엑셀 master 미요구·DB 행 존재(판걸이수 plate·구간할인 외부권위 적재 vs 과적재). 상품악세사리 옵션 잔재(OPP봉투 items 0) 포함 = 검토 대상. 추측 0 원칙으로 required=Y 자동전환 안 함.
- **[평가자 실결함 D-1·Medium] ✅LOADED = 행-존재만 검증** — SKILL §5 "변형 커버리지"(엑셀 요구 변형 전부 적재) 미구현. 캘린더 공정 LOADED지만 5상품 중 4상품이 1행만 보유. NO-GO 아님(범례가 LOADED를 정직 정의)·차기 보정 권고.
- **[권위 확정] admin = DB 100% 일치 → DB psql 실측을 상태 권위로 신뢰**(C3·C4 입증). 추출본 단독 판정 0.

## 다음 시작점 (정확한 다음 행동 — 택1, 모두 인간 승인 적재)
1. **[최상위 갭] CPQ 옵션 레이어 실 적재 준비** — round-6 GO 설계분(일반현수막 v2 `09_load/_exec_silsa_banner/`)의 option_items 0행을 채우는 실 적재. "CPQ 옵션 매핑"/"옵션 레이어 적재" 트리거 → dbm-option-mapper. 실 COMMIT = 인간 승인.
2. **[도메인 결정] DOMAIN-UNDECIDED 2건** — 굿즈파우치 사이즈 87 미적재·상품악세사리 사이즈 8 미적재: "기성품 사이즈 = 차원행(t_prd_product_sizes)인가 텍스트 표기인가". 머그컵 admin size 0 확증. 이 결정이 사이즈 차원 적재 방향을 가름.
3. **[가격 사슬] 미적재 6 상품군 공식 적재** — 포토북·캘린더·아크릴 등 가격 공식+component_prices. "가격 매핑"/"round-2" 트리거 → dbm-price-formula.
4. **[D-1 보정] LOADED 변형 커버리지 부차 판정** — `build_matrix.py state_of()`에 evidence_columns 대비 적재 변형 수 검사 추가, 또는 범례 캐비엇 명시. → dbm-mapping-designer/coverage 재실행.
5. **[이월·인간 승인] round-6 일반현수막 실 적재** — siz 77 등록·자재 mint 4·열재단 PROC_000084·실 COMMIT. 상세 = CHANGELOG 2026-06-08 행.

## 미해결 / 블로커
- **round-7은 조망/검증 전용 — 발견된 미적재는 갭보드 라우팅까지만.** 실제 적재·DDL·COMMIT 전부 인간 승인(기존 DB 미적재 원칙 유지).
- **DB-ONLY 17셀 권위 미판별** — 외부권위(판걸이수·구간할인) 정당 적재 vs 과적재 구분이 미완. 상품악세사리 OPP봉투 옵션 잔재(items 0)는 "의도된 옵션 vs 파일럿 테스트 잔재" 검토 필요.
- **이전 트랙 잔존**(CHANGELOG): 디지털인쇄 잔존 차단(3절/투명/박/048/019·030·049 plate교정)·excl_group 마이그(GAP-2)·미해결 설계결정(잉크색·머그용량·면지/바인더링·보드종류·각목 2규격).

## 건드리지 말 것 (확정·검증 완료)
- `_workspace/huni-dbmap/12_coverage/` — round-7 매트릭스 산출물(GO 판정). 매트릭스·갭보드·관계무결성·admin 캡처·재현 스크립트.
- `_workspace/huni-dbmap/03_validation/coverage-matrix-gate.md` — 독립 평가 게이트(C1~C8 GO). 이번 세션 작성.
- `docs/goal-2026-06-08-01.md`·`.claude/agents/huni-dbmap/dbm-coverage-auditor.md`·`.claude/skills/dbm-coverage-matrix/SKILL.md` — round-7 권위·에이전트·스킬.
- `.env.local` `HUNI_ADMIN_*` — admin 자격증명(chmod 600·gitignored). 검증됨.
- 이전 GO·라이브 COMMIT분(디지털인쇄 308행·상품마스터·가격·round-6 현수막 적재본 등 CHANGELOG 보존).
