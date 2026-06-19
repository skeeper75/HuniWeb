# Huni-Basedata-Dedup — HANDOFF (다음 세션 시작점)

> 하네스: 기초데이터 **표시명 중복** 검수·정리·적재 (Claude 생성 + codex cli 2차 교차검증).
> 트리거: CLAUDE.md §17 · 오케스트레이터 스킬 `huni-basedata-dedup-orchestrator`.
> 최종 갱신: 2026-06-19

---

## 다음 시작점 (바로 이것부터)

**카테고리 축(t_cat_categories) 파일럿** 을 사이즈·공정과 동일 5단계 파이프라인으로 실행한다 (표시중복 11그룹·가격 비종속 = HIGH).
**★착수 전 반드시 라이브 재실측** — round-22⑥/round-24 정리가 진행 중이라 max upd_dt가 최근(2026-06-19)이라 진단 stale 위험. 정리 잔재(고아노드·논리삭제 240노드) 반영해 표시중복 sniff 재산출 후 시작.

실행 순서 (사이즈·공정에서 검증된 5단계 — `hbd-*` 직접 호출):
1. `hbd-source-harvester` — 카테고리 추출(SOT MAP 시트 + 라이브 `t_cat_categories` + `00_schema/columns.csv`). **★가격종속 직접 재확인**(공정에서 레지스트리 "N"이 거짓이었음 — component_prices/formula_components 참조 sniff 필수).
2. `hbd-dedup-analyst` — 4축 검수. canonical=(의미축+정규 표시명+계층/부모). **★멤버별 1:1 가드**(부모 cat_cd·계층 깊이·main_cat_yn 컬럼별 byte 대조). 같은 표시명이라도 다른 부모/계층 = 정당구분(false-positive 가드).
3. `hbd-codex-verifier` — codex 2차(gpt-5.5). 양방향 검토.
4. **사용자 승인**.
5. `hbd-load-executor` — 백업→DRY-RUN(2-pass)→COMMIT→V1~V5→undo. 가격비종속·합의분만.

확정 결과가 0건이면 "통과(NO-OP)" 보고 후 다음 축(자재→도수→기초코드)으로.

### ★공정에서 얻은 교훈 (HARD — 다음 축에 적용)
- **레지스트리 "가격종속 N"을 믿지 말 것**: 공정은 레지스트리가 N이라 했으나 실측 component_prices.proc_cd 1,919행/25코드 = Y였다. 추출 단계에서 가격종속을 **직접 재확인**.
- **thin-mirror 자식 패턴**: 같은 시각 일괄 INSERT·dtl_opt/authority 공란·참조0 자식 = 부모의 빈 미러(진짜중복·논리삭제 안전). 단 자식이 단가행을 가리키면(오적재) BLOCKED — 부모↔자식 가격사슬 단절은 삭제 시 가격 전손.
- **엔진 fallback 부재**: pricing.py는 `sel["proc_cd"]` 정확일치 조회·부모→자식 fallback 없음(`:404,466`). 같은 표시명 형제가 서로 다른 단가행을 가지면 삭제 금지.

---

## 축 진행 상태 (권위 레지스트리 = `_registry/basedata-axes.md`)

| 축 (t_*) | 의미 | 행수 | 표시중복 sniff | 가격종속 | 우선순위 | 상태 |
|---|---|---|---|---|---|---|
| t_siz_sizes | 사이즈 | 520 | 1 | Y(84) | — | 🟢 DONE (파일럿 GO·D-1 적재) |
| t_proc_processes | 공정 | 102 | 13 | **Y(25)** ★정정 | HIGH | 🟢 DONE (파일럿 GO·9건 논리삭제 COMMIT) |
| t_cat_categories | 카테고리 | 326 | 11 | N(재확인 필요) | HIGH | ⏸️ **다음** (round-24 정리 중→재실측 후) |
| t_mat_materials | 자재 | 340 | 1 | **Y(68)** | MEDIUM | ⏸️ 가격종속 신중·경로Y |
| t_clr_color_counts | 도수 | 5 | 0 | N | LOW | ⏸️ 통과 예상 |
| t_cod_base_codes | 기초코드 | 85 | 0 | N | LOW | ⏸️ 통과 예상 |

권장 진행 순서: **~~공정~~ → 카테고리(재실측 후) → 자재(가격종속 신중) → 도수 → 기초코드**.
★공정 가격종속 = 레지스트리 "N"이 **거짓**이었음(실측 component_prices.proc_cd 25코드 Y). 잔여 축도 가격종속 직접 재확인 필수.

EXCLUDE(기초데이터 아님·검수 제외): t_prc_price_components·t_prc_price_formulas·t_dsc_discount_tables·t_prd_products·t_prd_templates (가격사슬/트랜잭션·영향만 표기).

---

## 미해결 / 블로커

- **사이즈 D-2/D-3** (A3 SIZ_000174/315, A2 SIZ_000197/317): plain twins이나 **pd=Y → BLOCKED**. 라이브 직접 merge 금지·근본 교정=경로 Y(개발자 v03 재적재). 컨펌 큐.
- **사이즈 SIZ_000499** (316x467 전지/작업영역 306x457): 판형 모델링 의도 확인 필요(BLOCKED·영향 없음).
- **공정 BLOCKED 3건** (미싱 PROC_000086·오시 090·타공 092): 자식이 component_prices 단가행 보유(30/50/18행)인데 바인딩 0·부모↔자식 가격사슬 단절(option_items.ref_key1=부모, cp.proc_cd=자식). 논리삭제 시 가격 전손 → **보류 큐**. 근본 교정=부모↔자식 단가행 재배선 or 경로 Y. dbm-price-arbiter 심의 필요. del_yn='N' 보존 중.
- **카테고리·자재 정리 진행 중**: max upd_dt 2026-06-19 (round-22⑥/round-24). 두 축 착수 시 **반드시 라이브 재실측**(stale 주의).
- **별개 발견(이 하네스 외)**: `.gitignore` 화이트리스트에 `huni-recipe-viz`(§16) agents·`hrv-*` skills 누락 → 그 하네스가 git 미추적일 수 있음. 사용자 확인 후 추가.

## 이번 세션 결정 (재론 금지)

- 하네스 형태 = **6축 범용 신규 경량** (축마다 만들지 않음). huni-basecode(§12 정확성 거버넌스)·huni-dbmap(§7 전체 매핑)과 경계 분리.
- 중복 정의 = **화면 표시명 중복**(키 고유하나 화면 중복) + 표시↔실제 불일치. 4축 검수.
- 적재 안전경계 = 가격비종속 + 미적재 신규만 실행. 가격종속(component_prices 참조)=BLOCKED 경로Y.
- 기초데이터 축 = **DB 실측으로 6축 확정**(추정과 일치). EXCLUDE 5 명시.
- 실행 모델 = Claude 생성 + codex 2차(독립·환각경계). codex가 사이즈에서 Claude의 false-negative를 실제로 적발 → 교차검증 필수 입증.

## 건드리지 말 것 (확정·보존)

- 사이즈 파일럿 산출물 `sizes/`·`sizes/_exec/`(D-1 라이브 COMMIT 완료·undo 보유).
- 공정 파일럿 산출물 `processes/`·`processes/_exec/`(9건 논리삭제 COMMIT 완료·백업 `bak_proc_dedup_round_pilot`·undo 보유) — 재정리 금지.
- 공정 keep 5건(핑크 010/036·UV 002/016·가변 085/031/032) 정당구분 확정 — 재정리 금지.
- D-2/D-3·SIZ_499·잔존 28 충돌그룹(정당구분 확정) — 재정리 금지.
- 가격종속(pd=Y) 코드 라이브 직접 merge — 금지(CASCADE).
