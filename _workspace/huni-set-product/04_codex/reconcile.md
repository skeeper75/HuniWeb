# reconcile — Claude(설계/게이트) ↔ codex 독립 판정 (04_codex)

생성: hsp-codex-verifier · codex 판정=`codex-findings.md` · 설계 본문=`03_design/set-composition-design.md`·`apply.sql`·`blocked-board.csv`.
**원칙**: 합의=고신뢰(게이트 confirm). 불일치/codex 신규=조사 큐(게이트가 라이브 최종 판정). 나는 판정하지 않고 **reconcile 큐**만 만든다.
**경계[HARD]**: codex 주장은 라이브/권위 확인 전엔 가설. 아래 "라우팅"은 게이트가 닫을 항목이지 확정 결함이 아니다.

---

## 1. 6질문 합의/불일치 매트릭스

설계 본문이 명시한 입장과 codex 독립 판정을 대조(Claude 게이트 판정은 미수행 — 본 reconcile는 설계 산출물 vs codex).

| 질문 | 설계 본문 입장 | codex 판정 | 합의? | 비고 |
|---|---|---|---|---|
| 1. 구성원 유형 | 95·96 = PRD_TYPE.02 반제품 유지(불변)·혼입 0 | PASS | **합의** | 고신뢰. 게이트는 라이브 prd_typ_cd만 재실측. |
| 2. 가격 가능성 | §3 "가격 사슬 = GO"(PRICE≠0)·30P는 §3.5 BLOCKED 분리 | **FAIL**("전체"FAIL·"20P한정"PASS) | **부분 불일치(표현)** | ★실질 동의(둘 다 30P 부재 인정)·차이는 §0/§3 "GO" 라벨 vs codex "FAIL". → **R-1**. |
| 3. 무결성 | PK 복합·UPDATE 멱등(`IS DISTINCT FROM`)·개수규칙 충전 | **확인필요** | **부분 불일치** | codex가 ① UPSERT upd_dt 무가드 ② sub_prd_qty vs min/max 의미혼동 2건 제기. → **R-2·R-3**. |
| 4. 권위 정합 | 몽블랑240·스노우300·20~30/+10 권위 row61 정합·naming 유입 0 | PASS | **합의** | 고신뢰. |
| 5. false-positive | 엽서북 정상구조(택1 함정 없음)·30P는 실 갭 | PASS | **합의** | 고신뢰. codex도 30P BLOCKED를 정당한 갭으로 인정(over-block 아님). |
| 6. 면지 정규화 | 엽서북 N/A·면지 4종 확장 phase 분리·재배선 스펙 | PASS(소재 확정만 확인필요) | **합의** | 고신뢰. 실 재배선 대상 소재 확정은 dbmap/basecode 트랙(이미 BLOCKED 분리). |

**합의 항목(고신뢰·게이트 가벼운 confirm)**: Q1 구성원 유형 · Q4 권위 정합 · Q5 false-positive · Q6 면지 N/A 분리.
**불일치/조사 항목**: Q2(표현) · Q3(2건) + codex 추가발굴 F-1~F-4.

---

## 2. 확인 필요 후보 (조사 큐 · 게이트 최종 판정)

codex 가설을 게이트가 닫을 항목으로 정리. 중복 제거(F-1=R-1, F-4=R-2에 흡수).

### R-1 [Q2·F-1·F-2] "가격 사슬 GO" 라벨 ↔ 30P 견적불가의 표현 충돌 — 우선순위 High
- **codex 주장(가설)**: §0/§3 "가격 사슬 = GO"가 30P 견적불가(BLOCKED)를 가린다. "엽서북 견적 완결"로 읽으면 NO-GO. page 차원이 use_dims에 없음("페이지별 단가" 문구가 실 차원과 불일치).
- **사실 대조(파일 근거)**: 설계 §3.5(`design:103`)와 `blocked-board.csv:2`가 30P 부재를 **이미 명시적으로 BLOCKED 분리**했다 → codex와 실질 동의. 차이는 §0 요약(`design:15` "가격 사슬 GO")·§3.2 "사이즈/면/페이지/수량별 단가"(`design:71`) **라벨/문구**. 실제 use_dims=`[siz_cd, min_qty, print_opt_cd]`(`design:79-80`)로 page는 comp 단위(20P/30P)로만 구분 — codex 지적 정확.
- **라우팅**: set-designer 문구 정정 — §0 "가격 사슬 GO" → **"20P 한정 GO·30P BLOCKED"**, §3.2 "페이지별 단가" → "comp(20P/30P)로 페이지 구분, page는 use_dims 차원 아님"으로 명확화. **데이터/SQL 변경 없음**(이미 적재본엔 30P 미포함). 게이트가 K-표현/정직성 항목으로 확인.

### R-2 [Q3·F-4] 셋트 UPSERT 멱등성 가드 비대칭 — 우선순위 Medium
- **codex 주장(가설)**: 유형 UPDATE는 `IS DISTINCT FROM` 가드로 진짜 멱등인데, 셋트 INSERT…ON CONFLICT DO UPDATE는 값 변경 여부 가드 없이 항상 `upd_dt=now()` → 재실행 시 물리 변경행/타임스탬프 계속 발생(`apply.sql:30-38·45-53`).
- **사실 대조**: 정확. SQL상 ON CONFLICT 분기에 `WHERE` 가드 없음. **단** 결과 데이터값은 동일하게 수렴(멱등성=결과 동일성 충족·DML 부작용만 타임스탬프). 위험도 낮음(데이터 오염 아님).
- **라우팅**: 게이트가 "멱등성 정의" 판정 — 결과값 멱등(OK)으로 볼지, DML no-op 멱등까지 요구할지 결정. 후자면 set-designer가 ON CONFLICT에 `WHERE` 변경감지 가드 추가(선택). load-executor의 DRY-RUN 2회 실행으로 실증 권고.

### R-3 [Q3] sub_prd_qty=1 vs min_cnt=20/max_cnt=30 의미 — 우선순위 Medium (★false-positive 가능성)
- **codex 주장(가설)**: `sub_prd_qty=1`과 `min_cnt20/max_cnt30`이 상충(base=sub_prd_qty로 보면 min20≤base≤max30 위반).
- **사실 대조**: ★codex가 **두 컬럼의 의미를 혼동**했을 가능성(codex의 false-positive). 설계 §1(`design:39-40`)·권위 §2.3(`set-authority-spec.md:58-62`)에 따르면 `sub_prd_qty`(셋트당 구성원 1개 기준수량)와 `min/max/cnt_incr`(내지 **페이지 가변범위** 20~30/+10)는 **서로 다른 축**이다 — base=sub_prd_qty가 아님. evaluate_set_price의 `derive_inner_sheets`가 페이지 가변(min/max)을 별도 입력으로 받음(`design:40`). 따라서 충돌 아님.
- **라우팅**: 게이트가 라이브 스키마 컬럼 의미(models.py L464-483·pricing.py derive_inner_sheets)로 확인 — **codex 가설 기각 후보**(false-positive). 단, 게이트가 직접 재실측해 확정(생성자 주장 비신뢰 원칙 동일 적용).

### R-4 [F-3] 본문 "신규 mint 0/UPDATE" ↔ SQL `INSERT … ON CONFLICT` 표현 — 우선순위 Low
- **codex 주장(가설)**: 본문/CSV는 "기존 행 UPDATE·신규 mint 0"인데 SQL은 행 부재 시 INSERT 가능(`apply.sql:26-30`).
- **사실 대조**: apply.sql 주석(`apply.sql:22` "행이 없을 경우에도 안전하게 생성되도록 INSERT 형태")이 의도를 명시 — 라이브 2행 실재(`design:24-29`)라 실행 시엔 항상 UPDATE 분기. 표현상 차이일 뿐 결함 아님. **단** "신규 mint 0" 주장과 INSERT-capable SQL의 어법 충돌은 사소.
- **라우팅**: 정보성. 게이트가 라이브 2행 실재 재확인하면 닫힘. set-designer 보정 불요(주석으로 이미 설명).

---

## 3. 게이트 라우팅 큐 (S 게이트 입력)

| ID | 사안 | 합의/불일치 | 게이트 작업 | 우선순위 |
|---|---|---|---|---|
| R-1 | "가격 사슬 GO" 라벨 정정(20P한정·page 차원 문구) | 실질 합의(표현차) | 정직성/표현 항목·문구 정정 라우팅(데이터 불변) | High |
| R-2 | 셋트 UPSERT upd_dt 멱등 가드 비대칭 | codex 신규(정확) | 멱등성 정의 판정·DRY-RUN 2회 실증 | Medium |
| R-3 | sub_prd_qty vs min/max 의미 충돌 | codex 가설(★false-positive 후보) | 라이브 스키마/pricing 의미로 기각 여부 재실측 | Medium |
| R-4 | "mint 0/UPDATE" ↔ INSERT…ON CONFLICT 어법 | codex 신규(사소) | 라이브 2행 실재 확인 후 닫음 | Low |
| (합의) | Q1·Q4·Q5·Q6 | 합의(고신뢰) | 가벼운 confirm(라이브 prd_typ_cd·권위값 재실측) | — |

**핵심 수렴점**: codex와 설계는 **30P 가격 갭에서 실질 동의**(둘 다 BLOCKED). 진짜 미합의는 ① §0의 "GO" 라벨이 견적완결로 오독될 위험(R-1·표현) ② UPSERT 멱등 가드(R-2) 2건뿐. **셋트 행 보정(95·96 UPSERT·유형 04→01) 자체는 codex도 "조건부 적용 가능"으로 인정** — 데이터 적재 차원 합의.

**false-positive 적발**: R-3(codex가 sub_prd_qty↔min/max 두 축을 혼동) — 게이트가 라이브로 기각할 후보. 역방향으로, 설계가 정상구조를 과하게 막은 false-positive는 codex도 0건 보고(Q5 PASS·30P BLOCKED는 정당).

**미합의분 라우팅**: R-1·R-2는 set-designer 보정(문구/가드), R-3·R-4는 게이트 재실측으로 닫음. 전부 라이브 읽기전용·DB 미적재 원칙 유지.
