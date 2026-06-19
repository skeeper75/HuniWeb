# Huni-Basedata-Dedup — HANDOFF (다음 세션 시작점)

> 하네스: 기초데이터 **표시명 중복** 검수·정리·적재 (Claude 생성 + codex cli 2차 교차검증).
> 트리거: CLAUDE.md §17 · 오케스트레이터 스킬 `huni-basedata-dedup-orchestrator`.
> 최종 갱신: 2026-06-19

---

## 다음 시작점 (바로 이것부터)

**자재 축(t_mat_materials) 파일럿** 을 동일 5단계 파이프라인으로 실행한다.
**★가격종속 신중** — 레지스트리 표시중복 raw 1건뿐이나 **component_prices.mat_cd 68코드 가격종속** + del_yn=N 192행(round-22④ 오염·논리삭제 多). 정리 시 가격사슬 영향 점검 필수·가격종속 코드는 BLOCKED 경로Y. 공정 교훈대로 **추출 단계에서 가격종속 직접 재확인**(레지스트리 수치 믿지 말 것).

실행 순서 (사이즈·공정·카테고리에서 검증된 5단계 — `hbd-*` 직접 호출):
1. `hbd-source-harvester` — 자재 추출. **★가격종속 직접 재확인**·round-22④ 오염(색/형상/사이즈/구수가 자재행 .08/.09/.10) 현황 반영.
2. `hbd-dedup-analyst` — 4축 검수. **★멤버별 1:1 가드**. 자재는 가격종속이라 진짜중복이어도 대부분 BLOCKED(component_prices CASCADE).
3. `hbd-codex-verifier` — codex 2차(gpt-5.5).
4. **사용자 승인**.
5. `hbd-load-executor` — 가격비종속·합의분만. 가격종속=BLOCKED.

확정 결과가 0건이면 "통과(NO-OP)" 보고 후 다음 축(도수→기초코드, 둘 다 표시중복 0=통과 예상)으로.

### ★공정·카테고리에서 얻은 교훈 (HARD — 자재 축에 적용)
- **레지스트리 수치(표시중복·가격종속)를 믿지 말 것**: 공정 가격종속 "N"이 거짓(Y 25코드)·카테고리 표시중복 "11"이 stale(실측 3). **추출 단계에서 라이브 직접 재실측**.
- **사용자 권위 정정 존중**: 카테고리 빈노드를 dedup이 "삭제"로 1차 판정했으나, 사용자가 MAP 시트 이미지로 "디자인캘린더=정당 하위분류·아래는 상품"을 입증 → 비동형 오모델(상품을 카테고리로 만듦) 진단으로 전환. **MAP 시트 = 절대 권위, round-24 해석도 틀릴 수 있음**(D-1 category-blind dedupe 오류).
- **junction PK 복합**: t_prd_product_categories PK=(prd_cd,cat_cd)·del_yn 컬럼 없음(물리)·다중분류 합법(같은 prd 여러 cat, main_cat_yn으로 주/보조).

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
| t_cat_categories | 카테고리 | 326(활성79) | 11→**3 실측** | N(확정) | HIGH | 🟢 DONE (rename1 + 디자인캘린더 동형교정 노드3·상품3 COMMIT) |
| t_mat_materials | 자재 | 340 | 1(raw·재확인) | **Y(68)** | MEDIUM | ⏸️ **다음** 가격종속 신중·경로Y |
| t_clr_color_counts | 도수 | 5 | 0 | N | LOW | ⏸️ 통과 예상 |
| t_cod_base_codes | 기초코드 | 85 | 0 | N | LOW | ⏸️ 통과 예상 |

권장 진행 순서: **~~공정~~ → ~~카테고리~~ → 자재(가격종속 신중) → 도수 → 기초코드**.
★레지스트리 수치를 믿지 말 것: 공정 가격종속 "N"이 거짓(Y 25)·카테고리 표시중복 "11"이 stale(실측 3). **추출 단계에서 라이브 직접 재실측 필수.**

EXCLUDE(기초데이터 아님·검수 제외): t_prc_price_components·t_prc_price_formulas·t_dsc_discount_tables·t_prd_products·t_prd_templates (가격사슬/트랜잭션·영향만 표기).

---

## 미해결 / 블로커

- **사이즈 D-2/D-3** (A3 SIZ_000174/315, A2 SIZ_000197/317): plain twins이나 **pd=Y → BLOCKED**. 라이브 직접 merge 금지·근본 교정=경로 Y(개발자 v03 재적재). 컨펌 큐.
- **사이즈 SIZ_000499** (316x467 전지/작업영역 306x457): 판형 모델링 의도 확인 필요(BLOCKED·영향 없음).
- **공정 BLOCKED 3건** (미싱 PROC_000086·오시 090·타공 092): 자식이 component_prices 단가행 보유(30/50/18행)인데 바인딩 0·부모↔자식 가격사슬 단절(option_items.ref_key1=부모, cp.proc_cd=자식). 논리삭제 시 가격 전손 → **보류 큐**. 근본 교정=부모↔자식 단가행 재배선 or 경로 Y. dbm-price-arbiter 심의 필요. del_yn='N' 보존 중.
- **★카테고리 junction main_cat_yn 무결성 결함** (컴펜 큐·이 하네스 범위 밖): PRD_000108·111 main='Y' 카테고리 0건(main 결손)·PRD_000110 main='Y'가 논리삭제 노드 CAT_000114(엽서캘린더 del='Y') 참조 + main 2건. round-24 v2 재배선 잔여 결함. → **round-24 dbm-category 후속 교정 트랙**으로 escalate. 디자인캘린더 동형 교정과 독립.
- **★round-24 D-1 정정 필요** (category-blind dedupe 오류·escalate): round-24 06_product-category-mapping D-1이 PRD_108→CAT_112와 →CAT_118을 "동일셀 중복"으로 junction 1행 통합했으나 PK=(prd_cd,cat_cd) 복합이라 합법 2행(다중분류). MAP 다중분류 의도 소실. 디자인캘린더는 이번에 복구했으나 **다른 상품군에도 동형 오류 가능** → round-24 트랙 재점검 권고.
- **자재 정리 진행 중**: max upd_dt 2026-06-19 (round-22④). 착수 시 **반드시 라이브 재실측**(stale 주의)·가격종속 점검.
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
- 카테고리 파일럿 산출물 `categories/`·`categories/_exec/`(104 rename + 디자인캘린더 동형교정 COMMIT 완료·백업 `bak_cat_dedup_round_pilot`·`bak_cat_designcal_nodes`·`bak_prdcat_designcal_links`·undo 2종 보유) — 재정리 금지.
- 카테고리 keep 3건(CAT_000105 하드커버책자 잎·112 탁상형캘린더·115 벽걸이캘린더) 정당구분 확정 — 재정리 금지.
- CAT_000118 디자인캘린더 = 정당 하위분류(MAP 권위·삭제 금지). PRD_108/110/111의 CAT_000118 귀속(main='N') 보존.
- D-2/D-3·SIZ_499·잔존 28 충돌그룹(정당구분 확정) — 재정리 금지.
- 가격종속(pd=Y) 코드 라이브 직접 merge — 금지(CASCADE).
