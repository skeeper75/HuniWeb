# vessel-process-parameter (V-1, #9 공정파라미터) — GAP ❌ → 그릇 설계

> rpm-vessel-designer. RP `ProcessParameter`(줄수·mm·색·조각수·구수) 종속 슬롯을 후니가 표현할 최소 그릇.
> 권위 = 라이브 read-only 실측(2026-06-17) + `dbm-ddl-proposer/ref-param-json-proposal.{md,sql}`(재사용·영향분석만 갱신).
> design ≠ apply — 실 ALTER는 인간 승인.

## 0. 한 줄 평결
**기존 `ref-param-json-proposal` 그릇이 정답 — 단 영향분석을 라이브 469행 기준으로 갱신해 통합.** 신규 craft 0(dbm-ddl-proposer 제안 재사용). 사다리 = **3단계 JSONB 컬럼 1개**(`ALTER TABLE t_prd_product_option_items ADD COLUMN ref_param_json jsonb NULL`).

## 1. search-before-mint (라이브 실측 2026-06-17)
| 사다리 | 후보 | 라이브 근거 | 무손실? |
|:--:|---|---|:--:|
| 1 코드행 | base_codes 자식코드로 값 | 줄수 0~3·책등 mm·조각수=연속/가변 수치, enum 부적합. 인스턴스(어느 item이 어느 값) 연결 불가 | ❌ |
| 2 컬럼 | 기존 `qty integer` | 단일 정수 1칸. 다축(제본 방향+책등+고리형) 불가·enum("양면") 불가·qty=수량 의미 smear | ❌ |
| 2 컬럼 | 고정 컬럼 N개 | `prcs_dtl_opt`의 가변 스키마(공정별 키 개수·타입 상이) 못 맞춤·NULL 밭 | ❌ |
| **3 JSONB** | **`ref_param_json jsonb`** | `t_proc_processes.prcs_dtl_opt`(jsonb 스키마)와 shape 짝. `{"줄수":2}`·`{"방향":"좌철","책등":12,"고리형":true}` 무손실 | ✅ |
| 4 테이블 | `t_prd_product_option_item_params`(1:N) | 값이 항상 한 item 종속(독립 lifecycle 없음)·prcs_dtl_opt가 이미 jsonb 1칸 → 과설계 | △ 과설계 |

**라이브 비대칭(핵심 근거)** — 파라미터 *스키마(정의)*는 이미 라이브에 실재, *선택값(인스턴스)*만 없다:
```
PROC_000029 오시  {"inputs":[{"key":"줄수","max":3,"min":0,"type":"integer","unit":"줄"}]}
PROC_000017 제본  {"inputs":[{"key":"방향",...},{"key":"책등","type":"number","unit":"mm"},{"key":"고리형","type":"boolean"}...]}  ← 다축
PROC_000033 박    {"inputs":[{"key":"크기","type":"number","unit":"mm"}]}
PROC_000054 반칼  {"inputs":[{"key":"모양",...},{"key":"조각수","min":1,"type":"integer","unit":"개"}]}
```
사용자가 "줄수=2 / 책등=12mm / 조각수=4"를 고른 값을 적을 칸이 option_items에 없다 → 이것이 GAP-PARAM. `ref_param_json`이 prcs_dtl_opt의 schema↔value 쌍을 완성.

**jsonb 컨벤션 정합(라이브 실측):** jsonb 컬럼 라이브 7건(`constraints.logic`·`options.tags`·`templates.tags`·`sizes.tags`·`component_prices.dim_vals`·`price_components.use_dims`·`processes.prcs_dtl_opt`). GIN 인덱스 0건 → 외래 shape 아님, 8번째 동종 컬럼.

## 2. 그릇 설계 (컨벤션 정합 — 최소 ALTER)
```sql
ALTER TABLE t_prd_product_option_items
  ADD COLUMN ref_param_json jsonb NULL;
COMMENT ON COLUMN t_prd_product_option_items.ref_param_json IS
  '공정 파라미터 선택값(prcs_dtl_opt 스키마의 인스턴스). 키=prcs_dtl_opt.inputs[].key. NULL=파라미터 없는 옵션.';
```
- 컬럼명 `ref_param_json` = `ref_dim_cd`/`ref_key1/2`와 같은 `ref_*` 계열 자연 정합(설계 §3.1·cpq-schema §4 명명 그대로).
- NULL 허용 필수: 사이즈/자재/도수 단순 참조 item은 파라미터 없음(대다수). NOT NULL 금지.
- 인덱스 불요(라이브 jsonb 무인덱스 컨벤션·조회는 PK).
- 키 shape 예시(prcs_dtl_opt.inputs[].key 그대로): `{"줄수":2}`·`{"면":"양면"}`·`{"방향":"좌철","책등":12,"고리형":true}`·`{"조각수":4}`·`{"구수":6}`·`{"크기":25}`.

## 3. 정규화 증명
- **무손실:** 단일·다축·enum·정수·number+unit·boolean 전 유형을 jsonb 1칸. 타공 4/6/8을 공정 3행 복제(마스터 오염) 없이 PROC 1행 + `{"구수":N}`.
- **무중복:** prcs_dtl_opt=스키마(정의), ref_param_json=값(인스턴스). 같은 사실 이중저장 아님. qty(수량)와도 의미 무중복.
- **함수종속:** (prd_cd,opt_cd,item_seq) → ref_param_json 완전종속. 부분/이행 신설 0.
- **참조무결성:** 키 정합=prcs_dtl_opt 스키마 권위(앱 검증). jsonb는 FK 대상 아님.

## 4. 영향 분석 (★ 기존 제안 대비 라이브 469행 기준 갱신)
| 항목 | 기존 제안(option_items=0행 시점) | **본 갱신(라이브 469행, 2026-06-17 실측)** |
|---|---|---|
| 백필 | 0 | **0 (ADD COLUMN NULL은 기존 469행에 NULL 부여·재기록 없음)** |
| 잠금 | 즉시·무잠금 | **PG ADD COLUMN ... NULL = 메타데이터 변경, full rewrite 없음 → 여전히 즉시·무잠금** |
| 롤백 | `DROP COLUMN` 데이터 손실 0 | **DROP COLUMN 시 ref_param_json에 *이미 채운 값*은 소실. 469행 중 param 채운 행 존재 시 손실 발생 → 롤백 전 백업 권고**(0행 시점과 달라진 유일점) |
| 트리거 | `fn_chk_opt_item_ref` 미참조 | **동일** — 트리거는 ref_dim_cd/ref_key1/2만 검사. ref_param_json 미참조·로직 변경 불요 |
| FK/인덱스 | 0 | 0 |
| 적용 순서 | option_items 적재 이전 | **이미 469행 적재됨 → ALTER 후 기존 행에 param 백필(UPDATE)은 dbmap 적재 트랙**. 신규 param-필요 item INSERT는 ALTER 이후 |

- **닫는 GAP:** GAP-PARAM(High)+GAP-COUNT. 적용 후 후가공 줄수/개수·박 크기·타공 구수·조각수·구수 1~4구·코팅 면·제본 다축 옵션이 **선택값 보존하며** 적재 가능 승격.
- **WEAK/GAP→PASS:** #9 공정파라미터 GAP → PASS(축 표현력 확보).

## 5. DDL 참조
- **정밀 SQL = `_workspace/huni-dbmap/11_ddl_proposals/ref-param-json-proposal.sql`** (dbm-ddl-proposer 소유·재사용). 본 vessel은 그릇 판정 + **영향분석 §4를 라이브 469행으로 갱신**해 통합.

## 6. open decision (날조 금지)
1. **트리거 param 키 검증 강도:** 본 그릇은 컬럼만(앱이 prcs_dtl_opt 스키마로 키 검증). DB 트리거에 "param 키 유효성" 강제는 별도 결정(권장: 앱 검증·복잡도↑ 회피).
2. **키 표기:** 한글 키(`줄수`/`구수`) = prcs_dtl_opt 현행 권위. 영문 전환은 prcs_dtl_opt 동시 마이그 필요(유지 권장).
3. **기존 469행 param 백필 범위:** 어느 item이 param 보유인지 = dbmap CPQ 적재 트랙 결정(vessel 범위 밖).
4. 실 ALTER = 후니 인간 승인.
