# reconcile — 사이즈 축 Phase 3 (Claude 1차 PASS(NO-OP) vs codex 2차)

생성: 2026-06-19 / hbd-codex-verifier / 모델 병행: Claude(라이브/index.csv 실측) + codex gpt-5.5(독립 2nd opinion)

## 판정: **DIVERGENCE (NO-OP 불승인) — 1 진짜중복 + 2 가드부재 후보 발굴**

codex 가용(exit 0)·환각 0건(인용 8 siz_cd 전부 index.csv 실재·일치). codex가 Claude의
PASS(NO-OP)를 적대 검토해 **Claude 1차가 놓친 false-negative**를 1건 확정(SIZ_000104/105)
+ 가드 정당성이 약한 후보 2건(A3·A2 plain active twins) 발굴.

## 행별 합의표

| 검사 항목 | Claude 1차 | codex 2차 | 합의 여부 | 비고 |
|---|---|---|---|---|
| inch×mm 이중라벨 6건 = 정합(오적재 아님) | 정합 | sound(308 확인·5건 미검) | **합의** | 고신뢰. 단 미검 5건 라이브 권고 |
| SIZ_000499 = 의도적 판형 모델링 | 정합 | intentional plate(더 강함) | **합의** | 고신뢰·BLOCKED(pd=Y) |
| del_yn='Y' twin = 재처리 대상 아님 | out of scope | out of scope | **합의** | 고신뢰 |
| 형상/입수/반칼 분리 그룹 = 정당 | keep | (반증 안 함) | **합의** | round-23 [HARD] 정당 |
| **SIZ_000104 vs 000105** | "29 그룹 전부 정당"에 흡수(미명시) | **TRUE duplicate (false-negative)** | **불일치 ★** | 둘 다 byte-identical·pd=N·plate0·가드 0 |
| **A3 174 vs 315 (둘 다 active)** | mapping.csv `A-규격_명명변형` keep | 가드 증거 부재·path Y 후보 | **불일치(약)** | 둘 다 pd=Y → live BLOCKED·근본=path Y |
| **A2 197 vs 317 (둘 다 active)** | 동상(keep) | 가드 증거 부재(hypothesis) | **불일치(약)** | 둘 다 pd=Y → live BLOCKED·근본=path Y |

## divergence 상세 (dedup-analyst 재판정 라우팅)

### D-1 [HIGH] SIZ_000104 / SIZ_000105 — 진짜 중복 (근거 실재 ✅)
- 증거(index.csv): 둘 다 `display='165x115mm(10장)'`·cut/work 165x115·**pd=N**·prd_sizes=1·plate=0.
  shape/pack/half-cut/plate 구분축 전무. 입수도 둘 다 `(10장)`로 동일.
- Claude 리포트는 이 쌍을 어디에도 명시하지 않고 "29 내부값 충돌그룹 전부 정당"에 일괄 흡수.
  실제로는 가드 플래그가 0인 진짜 중복 → **PASS(NO-OP)의 반례**.
- pd=N이라 **CASCADE-blocked 아님** → 라이브 안전 정리 가능(둘 중 1 코드로 통합·prd_sizes 재배선).
- **라우팅: dedup-analyst 재판정 — merge 후보로 등급화**(105→104 흡수 또는 역, prd binding 1건씩 재배선·환각 0 확인됨이나 라이브 prd_sizes 참조 실측 후 실행).

### D-2 [LOW] A3 plain active twins (SIZ_000174 'A3(297x420mm)' vs SIZ_000315 'A3')
- 둘 다 active·**pd=Y**·동일 내부값 297x420·plate=0. `SIZ_000052 'A3 (297X420)'`만 plate19(판형 가드).
- 174/315 사이엔 plate/impos 가드가 없음 → mapping.csv의 "판형 semantic_axis 분리" 정당화가 이 쌍엔 약함.
- 단 둘 다 **pd=Y → 라이브 merge BLOCKED**(component_prices CASCADE) → 근본 교정은 **경로 Y(개발자 재적재)** 뿐.
- **라우팅: dedup-analyst — pd=Y BLOCKED path-Y 후보로 컨펌 큐 등재**(실행 영향 없음·문서 정합).

### D-3 [LOW] A2 plain active twins (SIZ_000197 'A2(420x594mm)' vs SIZ_000317 'A2')
- D-2와 동형. 둘 다 active·pd=Y·420x594·plate0. 가드는 SIZ_000198(plate18)에만.
- **라우팅: D-2와 동일 — path-Y 컨펌 큐.**

## 최종 권고

- **NO-OP 불승인.** 사이즈 축은 "정리 0건"이 아니라 최소 **1 라이브 안전 정리 후보(D-1)**가 있다.
- **즉시 적재 금지** — divergence 해소(dedup-analyst 재판정) 전 적재 보류(스킬 §4).
- **D-1(104/105)**: pd=N·CASCADE 무관·가드 0 = 가장 강한 라이브 안전 merge 후보. 실행 전 라이브 `t_prd_product_sizes` 참조 실측(prd_sizes=1×2건 재배선 대상 확인)만 추가.
- **D-2/D-3(A3/A2)**: pd=Y라 라이브 BLOCKED. 근본=경로 Y. 컨펌 큐 등재로 충분(실행 영향 0).
- 합의 항목(inch 이중라벨·SIZ_000499·del_yn·형상/입수/반칼)은 **고신뢰 확정** — 재검토 불요.
- 교훈: 1차 리포트의 "29 그룹 전부 정당" 요약이 멤버 단위 가드 실재성 확인 없이 일괄 keep → byte-identical 진짜중복(104/105)을 가렸다. 충돌그룹은 멤버별 가드 플래그 실재를 1:1 대조해야 함.
