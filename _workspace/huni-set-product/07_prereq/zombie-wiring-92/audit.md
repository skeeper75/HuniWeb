# 좀비 배선 정리 교정 매니페스트 (W1-2) — audit

생성: §23 huni-set-product 07_prereq/zombie-wiring-92 · 라이브 Railway DB **읽기전용 SELECT 실측**(2026-06-24) · **DB 미적재**(분석·명세까지) · 실 COMMIT/UPDATE/DELETE는 인간 승인 후 dbm-load-execution
권위: del_yn 논리삭제 권위([[dbmap-del-yn-soft-delete-authority]]) + 상품마스터(260610) + webadmin 스키마(MAT_TYPE/USAGE 코드) + 직전 산출(material-master-audit·remediation-roadmap·material-remediation-spec)
원칙[HARD]: search-before-mint(신규 mint 0)·비파괴(물리 DELETE 0)·추측 금지(정본 미특정=BLOCKED-CONFIRM)·돈영향 표기

> **결론 한 줄**: 좀비 배선은 92건→**87건**(W1-1/W1-3 COMMIT 이후 5건 감소·MAT_000159·119 제외 등). 처분 = **REWIRE 2 / REVIVE 2 / BLOCKED-CONFIRM 83**. ★**87개 좀비 전부 component_prices 단가행 0건**(직접·차원키 양쪽) → **어떤 처분도 돈영향 0원**(청구 불변). 83건 BLOCKED는 대부분 "색/사이즈/형상 라벨 = 옵션값"으로 W2 옵션화 트랙 의존(자재 부활이 아니라 옵션화가 정답).

---

## 1. 방법

1. 검증 쿼리(프롬프트 제공)로 좀비 자재 전수 재집계 → **87건**(`t_mat_materials.del_yn='Y'` ∧ 활성 product_materials 배선 보유).
2. 좀비별 mat_typ_cd·upr_mat_cd·배선건수, 그리고 각 배선의 prd_cd·prd_nm·usage_cd·dflt_yn 전수 실측.
3. 돈영향 게이트: 각 좀비 mat_cd가 ① `t_prc_component_prices.mat_cd`로 직접 단가행을 갖는가 ② component의 `use_dims`에 mat_cd 차원으로 들어가 단가행에 차원값으로 존재하는가 — **양쪽 모두 0건 확정**.
4. 정본 매칭(search-before-mint): 같은 mat_typ_cd의 활성(del_yn='N') 자재 중 동일 의미축·동일명을 라이브로 대조. 단일 특정되면 REWIRE, 정본 부재이고 자재가 유효하면 REVIVE, 옵션값이거나 정본 모호면 BLOCKED-CONFIRM.

---

## 2. 실측 결과

### 2.1 좀비 92→87 재집계 (W1-1/W1-3 교집합 정리)
- W1-1(MAT_000159 모조120g·MAT_000119 리브스250g 부활): 두 자재가 del_yn=N이 되어 좀비 정의에서 이탈 → 92에서 2건 빠짐.
- W1-3(종이 root 부활 64→23): root는 product에 배선되지 않으므로 좀비 배선 카운트(=배선 보유 자재)에 직접 들지 않았으나, 자식 평량지 일부의 상태 변화로 합계가 추가 감소.
- 현재 검증 쿼리 = **87건**. 본 매니페스트는 이 87건을 처분 대상으로 한다(159·119는 이미 부활됐으므로 제외 정합).

### 2.2 유형별 분포
| mat_typ_cd | 의미 | 좀비 자재수 | 배선합 |
|---|---|---|---|
| MAT_TYPE.09 | 봉제부자재 | 62 | 106 |
| MAT_TYPE.01 | 디지털인쇄용지 | 5 | 14 |
| MAT_TYPE.08 | 실사소재 | 5 | 14 |
| MAT_TYPE.07 | 포장부자재 | 5 | 6 |
| MAT_TYPE.06 | 도장부자재 | 2 | 24 |
| MAT_TYPE.12 | 사입자재 | 2 | 3 |
| MAT_TYPE.02 | 링제본부자재 | 2 | 2 |
| MAT_TYPE.10 | 악세사리상품(추가상품) | 2 | 2 |
| MAT_TYPE.11 | 스티커용지 | 1 | 2 |
| MAT_TYPE.03 | 아크릴부자재 | 1 | 2 |

### 2.3 돈영향 게이트 (★결정적)
```sql
-- 직접 단가행: 0 rows
SELECT cp.mat_cd, count(*) FROM t_prc_component_prices cp
 JOIN t_mat_materials t ON t.mat_cd=cp.mat_cd
 WHERE t.del_yn='Y' AND EXISTS (SELECT 1 FROM t_prd_product_materials pm WHERE pm.mat_cd=t.mat_cd AND pm.del_yn='N')
 GROUP BY 1;  -- (0 rows)
```
87개 좀비 전부 component_prices 단가행 0. 일부 component(COMP_PAPER·COMP_STK_PRINT·COMP_ACRYL_CLEAR3T 등)는 use_dims에 mat_cd 차원을 갖지만, **좀비 mat_cd 값이 들어간 단가행이 0건**이라 가격 미도달. → **REVIVE/REWIRE/배선삭제 어느 처분도 evaluate_price 청구액 불변(0원).**

---

## 3. 케이스별 판정

### 3.1 REWIRE 2건 — 동일명·동일유형 활성 정본 존재
| mat_cd(좀비) | → canonical | 근거 | 돈영향 |
|---|---|---|---|
| MAT_000260 아트250+무광코팅 (7wire) | MAT_000250 아트250+무광코팅 | 동일명·동일유형(.01)·동일 usage(USAGE.02 표지). 260=다이어리/노트 7종 표지, 250=포토북 표지 | 0(양쪽 단가행0) |
| MAT_000270 워터북보틀 500ml (1wire) | MAT_000343 워터북보틀 500ml | 동일명·동일유형(.12 사입). 워터북보틀 본체. 정본 MAT_000269/343 활성 | 0(양쪽 단가행0) |

REWIRE 실행 형태(인간 승인 후): `UPDATE t_prd_product_materials SET mat_cd=<canonical> WHERE mat_cd=<좀비> AND del_yn='N'`. PK=(prd_cd,mat_cd,usage_cd)이므로 동일 (prd_cd,canonical,usage_cd) 행 존재 시 충돌 가드 필요(현재 충돌 없음 — 정본은 다른 상품에 배선).

### 3.2 REVIVE 2건 — 본질 소재·활성 정본 부재
| mat_cd | wire | 근거 | 돈영향 |
|---|---|---|---|
| MAT_000008 레더 (23wire) | 23 | 23개 레더상품(코스터/파우치/필통/백)의 본질 소재·dflt_yn=Y(유일). .06 도장부자재 정본 레더 stock 전부 삭제(006·173·174·175 모두 del_yn=Y) → REWIRE 불가 | 0(단가행0) |
| MAT_000261 무지내지 (4wire) | 4 | 4개 노트류 내지(USAGE.01)·dflt. 활성 무지내지 정본 부재(유일행이 좀비) | 0(단가행0) |

REVIVE 실행 형태: `UPDATE t_mat_materials SET del_yn='N', del_dt=NULL WHERE mat_cd=<좀비>` (W1-1 부활과 동형·멱등 WHERE 가드).

### 3.3 BLOCKED-CONFIRM 83건 — 옵션값 또는 정본 모호
세부 4군:

- **(A) 봉제부자재 색/사이즈/형상 라벨 (.09, 62건)**: M/L/XL·세로형/가로형·원형90mm·검정/빨강·양면/단면·2구/3구 등. **자재가 아니라 옵션값**. option_items에 0건 등록(옵션 경로 부재) + 전부 dflt_yn=Y로 product_materials에 박힘. → **W2 옵션화 트랙이 정답**(자재 REVIVE는 오염 재생산). 옵션화 후 product_materials 배선을 논리삭제.
- **(B) 실사소재 색 라벨 (.08, 5건)**: 화이트/블랙/홀로그램/골드/실버. (A)와 동일 성격(색=옵션값). 활성 .08 정본은 인화지/PVC 등 실소재로 색 아님. → W2 옵션화.
- **(C) 포토북/책자 표지타입·면지·마감 (.01/.02/.06, 5건)**: 하드커버/소프트커버/레더하드커버=표지타입(USAGE.06 옵션), 그레이=면지색, 투명커버 유광/무광=마감. material-remediation-spec P1/P2와 동일 — 표지종이 OK행 별존, 배선 논리삭제+옵션화 동반 필요.
- **(D) 현수막 추가물·추가상품·소재 정본모호 (.07/.10/.11/.03/.12, 11건)**: 양면테입/끈/큐방/각목/봉제사(현수막 추가물 dflt=N·RC-2 트랙 연계)·2개1세트/우드거치대(추가상품 묶음)·유포지(스티커용지 정본 모호)·투명아크릴(두께 미특정)·무광75mm(거울 사입 사이즈라벨). 정본 단일 특정 불가 또는 옵션/추가물 트랙 의존 → 추측 금지·CONFIRM.

---

## 4. 종합 분포

| 처분 | 건수 | 배선합 | 돈영향 | 즉시 실행 가능 |
|---|---|---|---|---|
| REWIRE | 2 | 8 | 0원 | 승인 후 가능(충돌 가드) |
| REVIVE | 2 | 27 | 0원 | 승인 후 가능(멱등) |
| BLOCKED-CONFIRM | 83 | 134 | 0원 | 아니오(옵션화/정본확인 선행) |
| **합계** | **87** | **169** | **0원** | |

> 본 87건 정리는 **셋트 가격 적재와 비충돌**: 좀비 단가행 0이므로 좀비 잔존이 가격을 오염시키지 않으며, 정리(REWIRE/REVIVE)도 청구를 바꾸지 않는다. 즉 W1-2는 데이터 위생(del_yn 권위 정합) 목적이지 돈 교정이 아니다.

---

## 5. 다음 단계 (라우팅)

- **REWIRE 2 + REVIVE 4건** → 인간 승인 후 **dbm-load-execution**(멱등 UPDATE·충돌 가드·DRY-RUN). 돈영향 0이라 dbm-price-arbiter 심의 불요.
- **(A)(B) 색/사이즈 라벨 67건** → **W2 옵션화 트랙**(t_prd_product_option_items 설계 → 배선 논리삭제). 본 자재 교정 범위 밖.
- **(C) 표지타입/면지/마감 5건** → 셋트 옵션 설계 트랙(USAGE.06 옵션화) + confirm-queue. material-remediation-spec P1/P2와 동일 항목 — 중복 처리 주의.
- **(D) 현수막 추가물 등 11건** → RC-2 추가물 트랙(각목/큐방 이미 별도 COMMIT 이력 → 중복/대체 확인) + 정본 확인 confirm-queue.

---

## 6. 🔴 승인/확인 필요 (confirm-queue)

| Q | 항목 | 질문 |
|---|---|---|
| Z-1 | REWIRE 2 | MAT_000260→250, MAT_000270→343 재배선 승인? (돈영향 0·동일명 정본) |
| Z-2 | REVIVE 2 | MAT_000008 레더, MAT_000261 무지내지 부활 승인? (본질 소재·정본 부재) |
| Z-3 | .09/.08 라벨 67 | 색/사이즈/형상 라벨을 자재 부활이 아니라 **옵션화(W2)**로 처리하는 방향 확정? (자재 REVIVE는 오염 재생산) |
| Z-4 | RC-2 중복 | 각목(338)·큐방(337)이 RC-2에서 이미 별도 처리됨 — 좀비 배선을 RC-2 신규 자재로 REWIRE할지, 좀비 REVIVE할지 |
| Z-5 | (D) 정본모호 | 투명아크릴192(두께 미특정)·유포지154(정본 모호)·무광75mm262(거울 사이즈라벨) 처리 방향 |
