# Huni-Basedata-Dedup — HANDOFF (다음 세션 시작점)

> 하네스: 기초데이터 **표시명 중복** 검수·정리·적재 (Claude 생성 + codex cli 2차 교차검증).
> 트리거: CLAUDE.md §17 · 오케스트레이터 스킬 `huni-basedata-dedup-orchestrator`.
> 최종 갱신: 2026-06-19

---

## 다음 시작점 (바로 이것부터)

**공정 축(t_proc_processes) 파일럿** 을 사이즈와 동일 파이프라인으로 실행한다 (표시중복 13그룹·가격 비종속 = 다음 1순위·안전).

실행 순서 (사이즈에서 검증된 5단계 — 신규 에이전트는 이번 세션 끝에 등록됨 → 다음 세션은 `hbd-*` 직접 호출 가능):
1. `hbd-source-harvester` — 공정 추출. 입력: 두 SOT 엑셀의 공정 + 라이브 `t_proc_processes` + `00_schema/columns.csv`. 산출: `_workspace/huni-basedata-dedup/processes/{index,authority,live}.csv`·`harvest-manifest.md`. **착수 전 라이브 재실측**(max upd_dt 2026-06-19 — round-22/23 정리 잔재).
2. `hbd-dedup-analyst` — 4축 검수(권위추출+표시실제정합·표시중복·내부값중복·의미구분보존). canonical=(의미축+정규 표시명+파라미터). 산출: `mapping.csv`·`dedup-report.md`·`apply-plan.md`. **★사이즈 교훈: "N그룹 전부 정당"으로 일괄흡수 금지 — 멤버별 가드 1:1 대조**(그래야 byte-identical 진짜중복을 안 가림).
3. `hbd-codex-verifier` — codex 2차(`codex-review.sh` 재사용·gpt-5.5). false-negative(진짜중복 놓침)·false-positive 양방향 검토. 산출: `reconcile.md`.
4. **사용자 승인** (AskUserQuestion) — 적재 매핑 요약 + BLOCKED + divergence 처리안.
5. `hbd-load-executor` — 백업→DRY-RUN(2-pass 멱등)→COMMIT→사후검증(V1~V5)→undo. 가격비종속·합의분만.

확정 결과가 0건이면 "통과(NO-OP)" 보고 후 다음 축으로.

---

## 축 진행 상태 (권위 레지스트리 = `_registry/basedata-axes.md`)

| 축 (t_*) | 의미 | 행수 | 표시중복 sniff | 가격종속 | 우선순위 | 상태 |
|---|---|---|---|---|---|---|
| t_siz_sizes | 사이즈 | 520 | 1 | Y(84) | — | 🟢 DONE (파일럿 GO·D-1 적재) |
| t_proc_processes | 공정 | 102 | **13** | N | HIGH | ⏸️ **다음** |
| t_cat_categories | 카테고리 | 326 | 11 | N | HIGH | ⏸️ 단 round-24 정리 중→재실측 후 |
| t_mat_materials | 자재 | 340 | 1 | **Y(68)** | MEDIUM | ⏸️ 가격종속 신중·경로Y |
| t_clr_color_counts | 도수 | 5 | 0 | N | LOW | ⏸️ 통과 예상 |
| t_cod_base_codes | 기초코드 | 85 | 0 | N | LOW | ⏸️ 통과 예상 |

권장 진행 순서: **공정 → 카테고리(재실측 후) → 자재(가격종속 신중) → 도수 → 기초코드**.

EXCLUDE(기초데이터 아님·검수 제외): t_prc_price_components·t_prc_price_formulas·t_dsc_discount_tables·t_prd_products·t_prd_templates (가격사슬/트랜잭션·영향만 표기).

---

## 미해결 / 블로커

- **사이즈 D-2/D-3** (A3 SIZ_000174/315, A2 SIZ_000197/317): plain twins이나 **pd=Y → BLOCKED**. 라이브 직접 merge 금지·근본 교정=경로 Y(개발자 v03 재적재). 컨펌 큐.
- **사이즈 SIZ_000499** (316x467 전지/작업영역 306x457): 판형 모델링 의도 확인 필요(BLOCKED·영향 없음).
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
- D-2/D-3·SIZ_499·잔존 28 충돌그룹(정당구분 확정) — 재정리 금지.
- 가격종속(pd=Y) 코드 라이브 직접 merge — 금지(CASCADE).
