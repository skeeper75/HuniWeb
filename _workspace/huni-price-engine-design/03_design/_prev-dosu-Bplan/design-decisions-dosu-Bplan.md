# design-decisions-dosu.md — 디지털인쇄 도수(흑백/칼라) 설계 결정·근거·컨펌큐

> hpe-engine-designer 설계 결정 로그. 흡수 적용·search-before-mint 근거·trade-off·컨펌큐.
> 짝: `engine-design-digital-dosu.md`·`golden-cases-dosu.md`·`dosu-load-draft.sql`.

---

## D-1. ★도수 인코딩 = proc_cd (C안) · A안(clr_cd) 무효 · B안(별 comp) 비권고

| 결정 | 흑백 도수 = COMP_PRINT_DIGITAL_S1 + 신규 proc_cd(PROC_000150) 차원 |
|------|--------------------------------------------------------------------|
| 근거① | 엔진 `NON_QTY_DIMS`(pricing.py:42)에 **clr_cd 없음** → use_dims에 clr_cd 넣어도 `_row_matches`/`_combo_key`가 안 봄 → **A안은 webadmin 코드 수정 없이 작동 불가**(코드 수정=C트랙·directive 금지). 사용자 directive의 A안 전제(clr_cd 차원)가 엔진 실측으로 무효화됨. |
| 근거② | proc_cd는 NON_QTY_DIMS에 있음 → 즉시 매칭. 별색(COMP_PRINT_SPOT_WHITE_S1)이 **색=proc_cd·면=print_opt_cd** 패턴으로 실증(530행=5색×2면×53밴드) → 흑백=도수 종류도 같은 패턴. **별색 패턴 정합**(directive). |
| 근거③ | 기존 칼라 212행 무변경(이미 proc_cd=PROC_000004) → 돈크리티컬 부작용 0. 신규 comp 0(같은 comp)·신규 proc_cd 1개만. **search-before-mint 최소 mint.** |
| B안 비권고 | 별 comp 신설은 별색이 단일 comp 패턴인데 도수만 comp 쪼개기=불일치. 두 comp 공식 배선 시 도수 미선택→둘 다 매칭 silent 합산 위험. |
| 위상 | **권위 엑셀 절대**(흑백 단가 실재)·라이브 엔진 계약 정합·DB 미적재. |

★ 이 결정은 **directive A/B안을 넘어선 C안 권고**다. 사용자가 A안(clr_cd)을 제시했으나, 내 라이브 엔진 코드 실측(NON_QTY_DIMS에 clr_cd 부재)이 A안을 무효화했고, 별색 패턴이 C안(proc_cd)을 정답으로 가리킨다. 이는 "push back when warranted" — A안의 구체적 결함(엔진 무시)을 명시하고 작동하는 대안(C안)을 제시.

## D-2. 흑백 proc_cd 부모 = PROC_000001 직속 (칼라 형제) — 권고

- COMP_PRINT_DIGITAL_S1.use_dims에 `proc_grp:PROC_000001`. 단가행 proc_cd가 PROC_000001 **직속 자식**이면 확실히 proc_grp 매칭(칼라 PROC_000004가 직속 자식·검증됨).
- 흑백을 PROC_000004(디지털인쇄) **자식**으로 두면 PROC_000001의 손자 → proc_grp가 손자까지 포함하는지 미검증(price_views proc 트리 lookup 의존).
- **∴ 안전책 = upr_proc_cd=PROC_000001**(칼라와 동일 depth·형제). 의미상 "디지털인쇄 흑백 변형"이라 PROC_000004 자식이 더 자연스럽지만, **매칭 확실성 우선**으로 PROC_000001 직속 권고. → **컨펌큐 C-1**(라이브 시뮬레이터 실측으로 손자 매칭 여부 확정 후 최종 결정).

## D-3. 흑백 단가 = 칼라 동형 53밴드 verbatim (212행)

- 권위 흑백 수량밴드(국4절 단면)가 칼라 라이브 53밴드와 **1:1 동일**(실측: 1~10,15~50,60~10000,1000000). → 흑백도 칼라와 동일 53밴드 set으로 적재 = grid 정합(off-grid 견적 동작 동일).
- 권위 B01(국4절) 표시상 56행(15/20/25 일부 추가)이나 라이브 칼라는 53밴드 → **흑백만 56밴드로 늘리면 칼라와 grid 불일치**. 칼라 동형 53밴드 채택. → **컨펌큐 C-2**(칼라 53 vs 권위 56 차이는 §26 무결성 별 이슈).
- 단가는 verbatim(계산·배수 금지): 국4절 단면 qty1=3000·양면 qty1=4000·qty100 단면=200·qty1000 단면=70·3절 단면 qty1=3500 등(golden-cases-dosu 전수·dosu-load-draft.sql 212행).

## D-4. 기존 칼라 212행 보정 = 무변경 (A안 시 명시였으나 C안 불요)

- directive는 "기존 212 칼라행 clr_cd 보정(NULL→CLR_000005)"을 A안 시 포함하라 했으나, **C안에서는 칼라 행 무변경**. 이유: 칼라는 이미 proc_cd=PROC_000004로 도수 판별 충분·clr_cd는 엔진 비사용. 별색 칼라행도 clr_cd 빈 채 작동 → 보정 부작용만(불요). **돈크리티컬 행 무변경 우선.**
- (감사 일관성 차원에서 clr_cd 채우기는 선택적·별 정리 트랙·본 설계 범위 밖.)

## D-5. 옵션 노출 = 도수 별도 택1 옵션그룹 (proc_cd 환원)

- 손님 도수 선택값 → option_items.ref_dim_cd=proc_cd·ref_key1(칼라 PROC_000004 dflt / 흑백 PROC_000150) → selections.proc_cd 주입. 별색(색=proc_cd 옵션)과 동일 구조.
- 면(print_opt)·도수(proc_cd) 분리축(별색 패턴) — 면×도수 결합 4지선다(안②)는 과설계·비권고.
- ★주입 연결 미작동 가능성(option_items ref_dim 0행·명함 G-7 동일) → proc_sels 폴백. → **컨펌큐 C-3**(시뮬레이터 게이트 선결).

## D-6. evaluate_price 계약 정합 (자기검증 통과)

- C7(frm_typ 미참조)·P3-8(ambiguous: proc_cd 상이로 회피)·P3-DEF(판별차원 proc_cd 채움)·U-7(시트 차원경계 내)·search-before-mint(comp 0·proc 1)·도수 미선택 default(칼라 dflt 보존·회귀 0) 전부 통과. 상세 engine-design-digital-dosu §4.4.

---

## 컨펌큐 (인간 승인 / dbmap 위임 항목)

| ID | 내용 | 라우팅 | 우선 |
|----|------|--------|------|
| **C-1** | 흑백 proc_cd 부모 = PROC_000001 직속(권고·매칭 확실) vs PROC_000004 자식(의미 자연·손자 매칭 검증) | dbm-price-arbiter 심의 + 라이브 시뮬레이터 실측 | High |
| **C-2** | 흑백 = 칼라 동형 53밴드(권고) · 권위 56밴드 차이 | §26 무결성(별 이슈·본 설계는 53밴드) | Med |
| **C-3** | 옵션→proc_cd 자동주입(option_items ref_dim) 라이브 작동 여부 — 미연결 시 proc_sels 폴백 | §15 quote-verify / dbmap CPQ·시뮬레이터 게이트 | High |
| **C-4** | 흑백 판매 범위 = 전 디지털 상품(~15) vs 엽서만 — 도수 옵션그룹 추가 대상 | 실무진 컨펌 | High |
| **C-5** | 흑백 도수에서 별색 가산 동시 허용 여부(흑백 본문+별색 강조) | 도메인 컨펌 | Low |
| **C-6** | codex 2차 교차 미완(read-only 코드탐색 단계 종료) → Claude 단독 결론. 후속 세션서 codex 재실행 권장(환각 경계 아닌 미완) | hpe-codex-validator | Med |

## search-before-mint 근거 요약

- **신규 comp**: 0 (COMP_PRINT_DIGITAL_S1 재사용).
- **신규 proc_cd**: 1 (PROC_000150 흑백디지털·MAX+1·무손실 입증=칼라와 다른 도수를 같은 proc_cd로 담으면 _combo_key 충돌·구분 불가).
- **신규 clr_cd**: 0 (CLR_000002 재사용·감사용).
- **신규 print_opt_cd/siz_cd**: 0 (POPT_000001/002·SIZ_000499/077 재사용).
- **공식·바인딩**: 무변경 (PRF_DGP_A~F·use_dims 그대로).
- **단가행**: 212 INSERT (흑백 verbatim).
- **옵션그룹/아이템**: 흑백 판매 상품마다 도수 택1 그룹+2아이템(채번 dbmap 적재 시 MAX+1).

## 안전 [HARD]

DB 미적재 — dosu-load-draft.sql은 BEGIN…ROLLBACK 검증 전용(COMMIT 금지). 실 적용은 인간 승인 후 dbmap(dbm-load-execution·dbm-axis-staged-load) 위임. 단가 verbatim(날조 0)·webadmin 코드 직접수정 금지(A안 무효의 이유)·라이브 읽기전용.
