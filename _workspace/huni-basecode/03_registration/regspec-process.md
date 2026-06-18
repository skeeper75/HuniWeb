# 등록 명세 — ⑤ 공정 (`t_proc_processes`) 🟡

> **하네스** hbg Phase 3 설계가 · 2차 회차. **작성** 2026-06-18.
> **입력:** `02_diagnosis/diagnosis-process.md`(🟡 마스터 건전·그릇 빈칸) · `01_authority/axis-authority-process.md`.
> **재사용:** dbmap `00_schema/code-identifier-strategy.md` · `heat-cut-process-proposal.sql`(공정 코드행 기제안). **[B4 정정] rpmeta V-1 `ref_param_json` 신설 제안·`ref-param-json-proposal.sql` = 철회**(기존 dtl_opt 실재로 불요).
> **[HARD] 명세 ≠ 적용.** 실 COMMIT = dbmap `dbm-load-execution` 인간 승인 후. **DDL/신규 컬럼 0.**

---

## 0. 한 줄 평결 [B4 정정]

**공정 마스터(102행) 오염 0 — 실 조치 = 기존 `t_prd_product_option_items.dtl_opt` jsonb 재사용(공정 param 선택값 미적재 채움·신규 그릇 mint 0).** family 구조·별색 분리·param 스키마 전부 건전. **★[B4] 검증자 NO-GO 정정:** rpmeta V-1이 `dtl_opt`를 못 봐 신규 `ref_param_json` 신설을 제안했으나 — **`dtl_opt` jsonb가 이미 라이브 실재(6행 공정 param 실사용·`{"폭":7.0,"유형":"봉미싱(7cm)"}`)** → 신규 mint **철회(0)**. vessel-gap → **data-gap 격하**(그릇 실재·UV 변형 미적재). 신규 공정 코드행 mint도 **0**(열재단 PROC_000084 라이브 실재). **4축 신규 mint = 0**(nonspec data-gap만 잔존).

---

## 1. ★ PR-1 — 기존 dtl_opt 재사용 (data-gap·신규 mint 0) [B4 정정]

### 1.1 등록 명세 단위

| 명세 단위 | 내용 |
|-----------|------|
| **대상 t_* + 컬럼** | `t_prd_product_option_items.dtl_opt`(**기존 jsonb 컬럼·라이브 실재**). 신규 컬럼 ADD **없음**(B4). 공정 param 선택값은 어느 item이 어느 값인지 인스턴스 종속 → 이미 이 컬럼이 담음(라이브 6행). |
| **올바른 의미** | 공정 파라미터 *선택값*(prcs_dtl_opt 스키마의 인스턴스). 키 = `prcs_dtl_opt.inputs[].key`. 미채움=파라미터 없는 옵션(대다수). 라이브 shape 실값 `{"폭":7.0,"유형":"봉미싱(7cm)"}`·`{"유형":"오버로크"}`. 목표 추가 shape `{"변형":"풀빼다"}`·`{"줄수":2}`·`{"조각수":4}`·`{"구수":6}`. |
| **권위 근거** | `diagnosis-process.md §6.1`(dtl_opt jsonb 라이브 재실측·6행 실사용·B4 적발) · `diagnosis-printoption.md §6.1`(information_schema jsonb 전수·dtl_opt 실재) · round-22 ⑤ 봉제 param(린넨 PRD_000124 dtl_opt). |
| **★search-before-mint (dtl_opt 재사용 검증 — 누락 정정)** | **사다리 0단(기존 컬럼 재사용·B4 추가 단계):** `t_prd_product_option_items.dtl_opt` jsonb 라이브 실재·공정 param 선택값 6행 실사용(`{"유형":"봉미싱(7cm)"}` ↔ 목표 `{"변형":"풀빼다"}` 동형 키-값 패턴) → **신규 컬럼 mint 불요**. 1단(코드행)·2단(qty 컬럼)은 *기존 jsonb 컬럼이 이미 충족하므로 검토조차 불요*. **★rpmeta V-1이 dtl_opt를 누락한 오류 → 재사용 검증 단계 명시로 정정.** |
| **★dtl_opt ↔ prcs_dtl_opt 역할 구분 [HARD]** | `t_proc_processes.prcs_dtl_opt` = **스키마(정의)** `{"inputs":[{"key":"변형","values":[...]}]}`. `t_prd_product_option_items.dtl_opt` = **값(인스턴스)** `{"변형":"풀빼다"}`. 같은 사실 이중저장 아님(정의 vs 선택값) — **이 슬롯이 이미 라이브에 살아있음**(신설 불요). |
| **FK 위상 [B5]** | ALTER 0(기존 컬럼). 적용 순서: ① **해당 공정 옵션 `option_items` 행 선적재**(현재 UV 변형 미적재·option_items 0행·B5) → ② dtl_opt에 param 선택값 UPDATE/INSERT(dbmap 적재 트랙) → ③ (인쇄옵션 PO-1: print_side 정규화는 그 다음). |
| **적재경로** | **product-viewer `pvEdit(prd_cd, options/<grp>/<opt>)` option_items 드릴다운 3계층**에서 운영자가 param 선택값 입력. dtl_opt는 라이브 실사용 컬럼 — **단 UV 변형 입력 폼 노출 여부 admin 미확인 → (해당 폼) 적재경로 미상**(정직 표기). DDL/신규 위젯 불요. |
| **영향분석** | **ALTER 0·백필 0·잠금 0**(기존 컬럼·신규 INSERT/UPDATE만). 트리거 `fn_chk_opt_item_ref`는 ref_dim_cd/ref_key1/2 검사(dtl_opt 미참조). 롤백 = dtl_opt UPDATE 원복(컬럼 DROP 없음·구조 무변경). **신규 컬럼 신설 시의 DROP COLUMN 위험 자체가 소멸**(B4 이득). |
| **컨펌** | **AX-5**(이관 범위 — 어느 item에 어느 param 적재). **DDL/신규 그릇 인간 승인 불요**(기존 컬럼·dbmap 적재 트랙 위임). |

### 1.2 신규 그릇 철회 (B4·재craft 0)

- **rpmeta V-1 `ref_param_json` 신설 제안 = 철회.** dbmap `ref-param-json-proposal.sql`(ALTER ADD COLUMN)도 **적용 불요**(dtl_opt가 동일 역할 이미 수행). 진단가 `diagnosis-process.md §6.1` 판정 (a) "dtl_opt 재사용 가능 → 신규 mint 0" 채택.
- **vessel-gap → data-gap 격하:** option_items.dtl_opt 477행 중 6행만 채움 = 그릇 있음·미적재(data-gap). UV 변형값도 이 그릇에 적재(채움) — 신규 컬럼 0.

---

## 2. ★ PR-1 ↔ 인쇄옵션 PO-1 합류 (목적지 그릇 = 기존 dtl_opt) [B4]

| 사실 | 함의 |
|------|------|
| 인쇄옵션 print_side UV 오적재 63행(풀빼다/배면양면/투명테두리)의 교정 목적지 = PROC_000002(UV) `prcs_dtl_opt` `{"변형":enum[...]}` param의 *선택값* | 변형 선택값을 적을 슬롯 = **기존 `t_prd_product_option_items.dtl_opt`**(신설 불요·B4). |
| **★[HARD·B5] 교정 선후:** PO-1(인쇄옵션 UV 축이동)은 **해당 아크릴 상품 option_items 행 선적재가 선결**(현재 0행) | 신규 컬럼 ALTER 아님 — dtl_opt는 기존 실재. 진짜 선결은 *option_items 행 적재 + (UV 무연결 7상품) PROC_000002 링크 적재*. → `regspec-printoption.md §1` FK 위상 의존. |
| 두 축(공정 param + 인쇄옵션 UV)이 dtl_opt에서 합류 | 한 기존 jsonb 슬롯이 줄수/조각수/구수/변형 전부 수용(마스터 복제 0·신설 0). |

---

## 3. PR-2 — 레이플랫 PROC_000025 (판정불가·컨펌 큐)

| 명세 단위 | 내용 |
|-----------|------|
| **현재값** | PROC_000025 레이플랫 del_yn='N'·use_yn='Y'(활성). 권위 사전 = "미운영 마스터(Q10·AX-6 가설)". |
| **라우팅** | **판정불가** — 미운영 SEED 잔존(정상)인지 실제 운영 공정인지 상품 연결 미실측. |
| **명세(조건부)** | (a) t_prd_product_processes에 PROC_000025 연결 상품 **0건**이면 → 미운영 SEED(어긋남 아님·정상 잔존)·소프트삭제 후보(del_yn='Y') 단 AX-6 컨펌 전 **보류**. (b) 연결 >0이면 → 운영 공정(정상·변경 0). |
| **컨펌** | **AX-6**(아래 §6 컨펌 큐). 실측+실무진 운영 여부 확정 전 등록/삭제 0. |

---

## 4. 신규 공정 코드행 (search-before-mint — mint 0 재확인)

| 후보 | 라이브 실태 | 판정 |
|------|------------|------|
| 열재단 | PROC_000084 **라이브 실재**(del_yn='N'·use_yn='Y'·family head) | **재제안 금지** — heat-cut-process-proposal은 이미 라이브 반영(C-PROC-1 해소·102행). 신규 mint 0. |
| 미싱/봉제/부착/에폭시/캘린더 제본 | PROC_000086 미싱·088 봉제·089 부착·095 에폭시·098~102 제본 **라이브 실재**(round-22 ⑤·round-23 적재) | **재제안 금지** — 신규 행 085~102 전건 upr_proc_cd로 family head 참조(self-ref 건전). |
| 코팅 분해 수신(자재명 흡수) | `아트250+무광코팅`→자재+무광 PROC_000015(코팅 family 실재) | **신규 공정 mint 0** — 코팅 family(PROC_000014~016) 라이브 실재. 자재명 정정+기존 공정 link만(`regspec-material.md §5`·자재 회차 처리). |
| 봉제↔부착 오연결 6 / 신규 mint 3 | round-22 ⑤ BLOCKED 잔존 | **재제안 금지** — dbmap round-22 ⑤ 트랙 위임(경로 Y·신규 mint 3은 ddl-proposer BLOCKED 인용). |

> **신규 공정 코드행 = 0.** 공정 마스터는 누락 인스턴스(param 슬롯)가 결함이지 코드행 부족 아님. heat-cut/미싱/봉제/에폭시 전부 라이브 실재(재발견·재제안 금지).

---

## 5. GAP-PROC-2 캐스케이드 제약 (기존 그릇·공정 축 확장 시)

| 명세 단위 | 내용 |
|-----------|------|
| **빈칸** | 자재/사이즈 → 공정 disable 캐스케이드(예: 특정 소재에 특정 가공 불가) 거의 미적재. |
| **목적지 t_*** | `t_prd_product_constraints`(JSONLogic `logic` jsonb — **기존 그릇**·신규 0). |
| **search-before-mint** | 신규 그릇 0 — constraints.logic JSONLogic이 이미 RP `disable_pcs`·WP `rst_awkjob`·CIP4 흡수·능가. 도입은 공정 축 확장 시(1순위 scope 밖·data-gap). |
| **라우팅** | data-gap(그릇 있음·미적재) — dbmap CPQ constraints 트랙 위임. 본 회차 등록 0. |

---

## 6. ★ 컨펌 큐 (escalate — 평이한 한국어 질문)

| ID | 막힌 결정 | 평이한 한국어 질문 |
|----|-----------|--------------------|
| **AX-5** [B4 정정] | 공정 파라미터(줄수·조각수·구수·UV 변형) 선택값을 **기존 dtl_opt 칸에 채우는 범위**(어느 옵션 항목에 어느 값) — 신규 칸 신설 아님 | "오시 2줄, 반칼 4조각, 아크릴 풀빼다 같은 '공정 세부 선택값'을 담는 칸은 이미 있습니다(봉제 옵션에서 쓰는 중). 다만 대부분 비어 있어요. 어느 상품·옵션부터 이 값을 채울지만 정하면 됩니다(새 칸 만들 필요 없음)." |
| **AX-6** | 레이플랫(PROC_000025)이 실제 운영 공정인지 안 쓰는 잔존 코드인지 | "제본 중 '레이플랫'이 지금 살아있는데(활성), 실제로 주문에서 쓰는 가공인가요, 아니면 예전에 만들어두고 안 쓰는 항목인가요? 안 쓰면 숨기고(소프트삭제), 쓰면 그대로 둡니다." |

> **escalate [B4]:** AX-5 = **이관 범위 결정만**(신규 컬럼 ALTER 철회·DDL 인간 승인 불요·dbmap 적재 트랙). AX-6는 상품 연결 실측 + 실무진 확인 전 등록/삭제 0(보류).

---

## 7. 등록 명세 건수 집계

| 라우팅 | 건수 | 신규 mint | 즉시/컨펌 |
|--------|:--:|:--:|------|
| **PR-1 dtl_opt 재사용(param 선택값 미적재 채움)** [B4] | data-gap 채움 | **0**(기존 컬럼·신설 철회) | **AX-5 이관 범위·DDL 불요** |
| 신규 공정 코드행 | **0** | 0 | (열재단/미싱/봉제/에폭시 라이브 실재·재제안 금지) |
| 캐스케이드 제약(GAP-PROC-2) | 0(본 회차) | 0(constraints.logic 기존 그릇) | data-gap·dbmap 위임 |
| 레이플랫 PROC_000025(PR-2) | 0(판정불가) | 0 | **AX-6 컨펌·보류** |
| 마스터 교정/소프트삭제 | **0** | 0 | 마스터 오염 0(🟢) |

> **★공정 축 신규 mint = 0**(B4·ref_param_json 컬럼 신설 철회). 실 조치 = 기존 dtl_opt에 param 선택값 채움(data-gap)·신규 공정 코드행/교정/소프트삭제 0. dtl_opt가 인쇄옵션 PO-1의 목적지(기존 그릇·선결은 option_items 행 적재).

---

## 8. dbmap 인용 (재제안 금지)

- **round-22 ⑤공정 🟡** = 에폭시 PRD_000169 COMMIT·봉제↔부착6 경로Y·신규 mint 3 BLOCKED — 라이브 봉제(088)/부착(089)/에폭시(095) 적재 확인.
- **round-23** 별색 dedup·디지털 가격엔진 공정사슬·캘린더 제본(098~102) — 라이브 신규 행 반영 확인.
- **C-PROC-1** 열재단 PROC_000084 = 라이브 102행으로 종결(83 vs 84 논쟁 끝).

---

## 9. hbg-validator 통지

- **공정 축 = 기존 dtl_opt 재사용(param 선택값 채움·신규 mint 0)이 실 조치.** [B4 정정] 검증 포인트: ① **★신규 컬럼 신설 철회**(dtl_opt 라이브 실재·6행 실사용·vessel-gap→data-gap 격하) ② **search-before-mint 0단(dtl_opt 재사용 검증) 명시**(V-1 누락 정정) ③ dtl_opt↔prcs_dtl_opt 역할 구분(값 vs 정의) ④ 인쇄옵션 PO-1 목적지=기존 dtl_opt·선결=option_items 행 적재(B5) ⑤ 신규 공정 mint 0(열재단/미싱/봉제/에폭시 라이브 실재) ⑥ 영향분석(ALTER 0·백필 0·DROP 위험 소멸) ⑦ 적재경로 미상 정직(UV 변형 입력 폼 admin 미확인).
- **escalate:** AX-5(이관 범위·DDL 불요·dbmap 적재 트랙)·AX-6(레이플랫 운영 여부). 평이한 한국어 질문 §6.
