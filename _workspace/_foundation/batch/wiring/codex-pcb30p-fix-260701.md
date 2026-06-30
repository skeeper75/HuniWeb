# codex 독립 2차 교차검증 — 엽서북30p PRD_000094 배선 **보정본** · Phase 5.5

- 산출일 2026-07-01 · 검증자=hpe-codex-validator(Claude) · 외부모델=Codex **gpt-5.5**(읽기전용 샌드박스·high effort·session 019f19bd)
- 입력(codex 전달): `design-pcb30p-fix-260701.md` + `design-pcb30p-fix-dryrun.sql` + `design-namecard-dryrun.sql`/`.md`(충돌 교차대조용·COMMIT됨) + 엔진 매칭 의미(NULL=wildcard·전 comp 합산) + `live-snapshot/latest/*.csv`. **★Claude 게이트 판정·이전 codex ISSUE 결론은 비전달**(독립성·echo 방지). codex에 "보정이 닫혔다" 단정 미주입 — "닫혔는지 독립 판정하라"만.
- codex 가용성: **AVAILABLE**(preflight `AVAILABLE model=gpt-5.5`). Claude 단독 폴백 불필요. codex가 SQL·설계문서·스냅샷 CSV를 실독하고 라인 인용 → 환각 아닌 파일근거 판정.
- ★[HARD] **codex 주장 = 가설.** 라이브 엔진코드·권위 실재 확인 전엔 사실 아님. 단 SQL/CSV에서 즉시 확인 가능분은 `파일확인` 태그.

---

## 0. 결론 먼저

| 직전 2이슈 | codex 독립 판정 | Claude 독립 실측 | reconcile |
|---|---|---|---|
| **ISSUE-1 (D3) 채번 충돌** (OPT_000080 명함 vs 엽서북) | **CLOSED** (현재 CSV 기준) — OPT_000082/OPV_491/492 라이브·명함과 무충돌 | **합의 CLOSED** — 스냅샷 MAX 위 코드라 무충돌 | **합의·고신뢰** |
| **ISSUE-2 (D1) opt_cd 선택수단 경로** (option_items/ref_dim 무효) | **CLOSED** (설계/SQL/스냅샷) — `t_prd_product_options` 직접경로·무효 ref_dim 잔재 0. 단 실제 `price_views.py` 직독은 **UNVERIFIABLE**(이 workdir에 엔진 원본 없음) | **합의 CLOSED**(자료기준)·엔진소스 UNVERIFIABLE | **합의·엔진소스만 잔여검증** |

**양 모델(Claude·codex) 독립 수렴**: 보정이 직전 NO-GO 3결함(D1/D2/D3)을 자료·SQL·스냅샷 수준에서 닫음. disjoint·골든은 고신뢰 확정. **잔여 = 가설 2건(엔진/위젯 런타임 검증 공백 + 문서 stale 문구)**, 둘 다 돈크리티컬 아님·실 COMMIT 전 해소 가능.

---

## 1. codex 2nd opinion 원문 요지 (질문별)

> codex 총평: "selection path는 설계/SQL 기준 **CLOSED**, 실제 price_views.py 직접 확인은 **UNVERIFIABLE**. numbering은 현재 CSV 기준 **CLOSED**. 새 이슈는 치명 배선결함이 아니라 stale baseline 문구 + 20P default 주입 검증공백."

| Q | codex 판정 | 핵심 근거(codex 인용) |
|---|---|---|
| Q1 선택수단 opt_cd 환원·무효 ref_dim 잔재 | **CLOSED**(엔진소스 UNVERIFIABLE) | SQL이 `option_groups`+`options` 직접경로로 교체(`design-pcb30p-fix-dryrun.sql:20-40`)·`ref_dim_cd='opt_cd'` INSERT 없음. 라이브 094 option_items=`OPT_REF_DIM.01/.03/.04/.06/.07`뿐·`opt_cd` 잔재 0(`t_prd_product_option_items.csv`). gate 하니스가 opt_cd를 non-qty dim으로 매칭(`remediation/_gate_harness.py`) |
| Q2 채번 충돌·baseline 정확성 | **CLOSED·단 baseline 문구 stale** | namecard037 점유=`OPT_000080`,`OPV_000487/488`(CSV). `OPT_000081/082`·`OPV_489..492`는 스냅샷 부재 → 082/491/492 무충돌. **그러나 설계의 "MAX=OPT_000079/OPV_000486" 주장은 현재 스냅샷 기준 거짓**(실 MAX=080/488). 결론 불변 |
| Q3 20p 회귀·중간창 | **UNVERIFIABLE·SQL ordering hole 없음** | 단일 BEGIN…ROLLBACK·선택수단 INSERT→행 UPDATE 순서라 중간 PRICE=0 창 없음. 단 "미선택 시 20P가 실제 selections['opt_cd']로 들어감"은 client/widget 계약(설계도 엔진 default 자동주입 안 함 명시 `:77`) → **파일만으로 확정 불가** |
| Q4 (print_opt×page) disjoint | **CLOSED** | 4 body 판별축 `(print_opt_cd,opt_cd)` 완전분리. POPT1+OPV491→S1_20P, POPT2+OPV491→S2_20P, POPT1+OPV492→S1_30P, POPT2+OPV492→S2_30P. 30P 2 comp 배선 추가(`:63-70`). silent double-sum 없음 |
| Q5 골든 산술 | **CLOSED** | CSV verbatim: S1_30P SIZ_000003 qty2 unit 11500→23,000 / S1_20P 11000→22,000. 4 comp 각 117행·사이즈 3종·tier 39 전부 커버 |
| Q6 환각·모순 | **OPEN(문서품질)** | 치명결함 아님. stale 단정 2건(MAX 079/486·명함 081/489/490 점유 과장) + "20p 회귀 0"은 widget default 주입 확인 전 조건부 가설 |

---

## 2. Claude 독립 실측 (codex echo 아님 — 같은 스냅샷 별도 측정)

같은 `snap_20260701_0305`에서 Claude가 codex와 **독립으로** 측정한 값(수렴 확인):

- `MAX(opt_grp_cd)=OPT_000080`(명함 박종류·COMMIT됨), `OPT_000081/082` 부재 → **082 무충돌**. `OPT_000081`도 사실 free(설계가 안 씀·무해 갭).
- `MAX(opt_cd)=OPV_000488`(명함 487 일반박/488 홀로만), `OPV_000489/490/491/492` 부재 → **491/492 무충돌**. 명함은 **487/488만** 점유(489/490 미점유).
- PRD_000094 option_items = `OPT_REF_DIM.01/.03/.04/.06/.07`만 · `opt_cd` 리터럴 0건 → **무효 ref_dim 잔재 0**(직전 dryrun 미COMMIT이라 라이브 오염 없음).
- 현재 PRF_PCB_FIXED 배선 = S1_20P(seq1)·S2_20P(seq2)만 → 30P 고아 확인(저청구 실재). 30P comp `print_opt` 컬럼 **공란**(20P는 POPT_000001/002 충전) → 설계의 "30P=opt_cd+print_opt 둘 다 채움" 정당.
- 골든 verbatim: S1_30P/SIZ_000003/qty2=11,500 / S2_30P=12,500 / S1_20P=11,000 → 23,000·25,000·22,000 모두 재현. 4 comp 각 117행.

→ **Claude와 codex가 독립으로 동일 결론**(stale baseline까지 양측 독립 발견) = echo 아님·고신뢰.

---

## 3. reconcile 매트릭스 (codex ↔ Claude)

| # | 항목 | codex | Claude 실측 | 합의/이견 | 해소·소유자 |
|---|---|---|---|---|---|
| R-1 | ISSUE-1 채번 충돌 닫힘 | CLOSED | CLOSED | **합의·고신뢰** | 확정. 실COMMIT 시점 MAX 재확인만(§9 컨펌큐1·dbm-axis-staged-load) |
| R-2 | ISSUE-2 선택수단 경로 닫힘(자료) | CLOSED | CLOSED | **합의·고신뢰** | 확정. `option_items/ref_dim='opt_cd'` 잔재 0 |
| R-3 | disjoint 2×2 | CLOSED | CLOSED | **합의·고신뢰** | 확정·silent-sum 0 |
| R-4 | 골든 23,000/22,000(+25,000 등) | CLOSED | CLOSED(verbatim) | **합의·고신뢰** | 확정·날조 0 |
| R-5 | **엔진소스 opt_cd 환원 실재**(price_views `_opt_cd_options`가 094 product_options 읽는지) | **UNVERIFIABLE**(엔진 원본 workdir 밖) | 동의·미확인 | **합의(잔여)** | 가설 → hpe-validator 라이브 또는 §7 COMMIT 시 `price_views.py:726/762` 094 실독. 명함 E4 PASS 패리티 논거 있으나 094 재확인 필요 |
| R-6 | **20P default 런타임 주입**(위젯이 mand dflt 사전선택→selections['opt_cd']=491) | UNVERIFIABLE(client 계약) | 동의·미확인 | **합의(잔여)** | 가설 → 위젯/시뮬 계약 확인. 자료설계는 타당하나 런타임 미입증 |
| R-7 | **설계 stale baseline 문구**(MAX 079/486·명함 081/489/490 점유) | OPEN(문서품질) | **독립 동일 발견** | **합의(신규·LOW)** | 문서 교정 권고: 실 MAX=080/488·명함 점유=080+487/488. 결론 불변·코드 여전히 안전 |

---

## 4. 새 이슈 (가설 — 검증 전 사실 아님)

- **N1 [LOW·문서품질·파일확인] 설계 baseline 문구 stale.** `design-pcb30p-fix-260701.md §0/§9`·`-dryrun.sql:7-8`이 "MAX(opt_grp)=OPT_000079·MAX(opt_cd)=OPV_000486·명함 080/081+487-490 점유"라 적었으나, 현재 스냅샷 실측 = MAX `OPT_000080`/`OPV_000488`·명함 점유 `080+487/488`뿐(`081/489/490`은 후보·미COMMIT). **codex·Claude 독립 동일 발견.** 결론(082/491/492 안전)은 불변이나, 근거 문구가 부정확 → 실COMMIT 전 문구 교정 권고(다음 배치 혼선 방지). 채번은 §9 컨펌큐1이 이미 "COMMIT 시점 재확인" 명시.
- **N2 [MED·검증공백·가설] 런타임 opt_cd 환원 + 20P default 주입 미입증.** 엔진(`price_views.py _opt_cd_options`)이 094 `t_prd_product_options`에서 페이지 opt_cd를 읽어 selections['opt_cd']로 공급하는지, 위젯이 mand dflt(20P)를 사전선택하는지 = 이 workdir 파일로 확정 불가(엔진 원본 부재). 명함037 E4 PASS·ACRYL_BADGE 동일경로 패리티가 논거지만 **094 한정 재확인 필요**. 돈크리티컬: 미입증 시 20P 회귀(22,000 깨짐) 또는 30P 미환원(견적0) 가능 → **실COMMIT 게이트 전 hpe-validator 라이브 PRICE≠0 실호출 필수**.

---

## 5. 직전 ISSUE 대비 닫힘 판정

- **ISSUE-1 (OPT_000080 채번 충돌)** → **CLOSED**(양 모델 합의·파일확인). OPT_000082+OPV_491/492로 회피·라이브 무충돌. 잔여=문구 stale(N1·무해).
- **ISSUE-2 (opt_cd 선택수단 경로)** → **자료기준 CLOSED**(양 모델 합의). `t_prd_product_options` 직접경로=명함 패턴 정합·무효 ref_dim 잔재 0. 잔여=엔진소스 런타임 환원 UNVERIFIABLE(R-5·N2·가설).

---

## 6. 최종

- codex 가용 = **GO**(gpt-5.5·읽기전용·파일실독). Claude 단독 폴백 불필요.
- 직전 2이슈(채번·선택수단경로) = **양 모델 독립 합의로 CLOSED**(자료·SQL·스냅샷 수준). disjoint·골든은 고신뢰 확정(verbatim 재현·날조 0).
- 새 이슈 2건(가설): **N1 stale baseline 문구**(LOW·codex·Claude 독립 동일발견·문구 교정 권고) · **N2 런타임 opt_cd환원+20P default 주입 미입증**(MED·돈크리티컬·실COMMIT 게이트 전 라이브 PRICE≠0 실호출로 해소).
- 동의/이견: **자동 flip 신호 0**. codex가 설계를 약화시킬 외부반론 없음·BLOCKED 뒤집기 없음. 합의가 압도적이고 잔여는 "더 검증하라"(엔진 런타임)뿐.
- reconcile 필요분: R-5(엔진소스 094 실독)·R-6(위젯 dflt 주입 계약) = hpe-validator 라이브 패스 또는 §7 COMMIT 게이트로 이관. R-1~R-4는 고신뢰 확정·추가조사 불요.
- ★codex 주장은 라이브 엔진코드·권위 검증 전 사실 아님. 단 채번 무충돌·무효 ref_dim 잔재 0·골든 verbatim·disjoint는 스냅샷/SQL에서 즉시 확인됨(라이브 불요).
- 산출: `_workspace/_foundation/batch/wiring/codex-pcb30p-fix-260701.md`.
