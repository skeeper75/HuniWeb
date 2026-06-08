# 제안: `t_prd_product_option_items.ref_param_json` 컬럼 (GAP-PARAM 해소)

- **닫는 GAP:** `cpq-option-gaps.md` GAP-PARAM(🔴 High) + GAP-COUNT(통합) — 공정 파라미터(타공 구수 N·오시/미싱 줄수·가변 개수·박 크기·조각수 N·구수 1~4구)의 **선택값** 보존처 부재
- **판정:** **DDL-NEEDED** · **사다리 단계:** 3단계(컬럼 추가 — JSONB) — 코드행/단순 컬럼으로는 무손실 불가 입증됨(§2)
- **권위:** `cpq-schema.md §4 🔴8`(ref_param_json 미구현 라이브 정합) · `attribute-entity-map.md §4`(GAP-PARAM) · `cpq-option-gaps.md`(파일럿 실측 확정) · 라이브 read-only 실측(2026-06-07, 본 문서 §1)
- **적용:** propose ≠ apply — **인간 승인 필요**(라이브 ALTER 금지)

---

## 0. 한 줄 평결

**ref_param_json 컬럼은 필요하다(NEEDED).** 최소형 = `ALTER TABLE t_prd_product_option_items ADD COLUMN ref_param_json jsonb NULL` 단 1줄. 라이브 option_items가 **0행**이라 백필 0·무영향, 라이브에 jsonb 컨벤션 선례 3건 존재, 인덱스 불요. `qty integer` 한 칸으로는 다축 파라미터(줄수+개수, 방향+책등+고리형)를 무손실 표현 불가함이 라이브 실측으로 입증됨.

---

## 1. 라이브 실측 (read-only, 2026-06-07 — 추정 아님)

`BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK;`로 확인:

### 1.1 option_items 현재 컬럼 (12개) — 값 보존 슬롯은 `qty` 단 하나
```
prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1(NN), ref_key2,
qty integer NULL,                 ← 유일한 수치 파라미터 칸
use_yn, del_yn, del_dt, reg_dt, upd_dt
```
- `information_schema.columns` 전수: **`ref_param_json` 컬럼은 라이브 전체 어디에도 없음**(0행 매치). cpq-schema §4 🔴8의 "미구현" = **실측 확정**.
- `t_prd_product_option_items` **행 수 = 0** → ALTER 시 백필 0.

### 1.2 파라미터 *스키마*는 이미 라이브에 있다 — *선택값*만 없다 (핵심 비대칭)
`t_proc_processes.prcs_dtl_opt jsonb`에 공정별 파라미터 **정의(스키마)**가 실재:

| proc_cd | proc_nm | prcs_dtl_opt (정의) |
|---------|---------|---------------------|
| PROC_000029 | 오시 | `{"inputs":[{"key":"줄수","max":3,"min":0,"type":"integer","unit":"줄"}]}` |
| PROC_000030 | 미싱 | `{"inputs":[{"key":"줄수","max":3,"min":0,"type":"integer","unit":"줄"}]}` |
| PROC_000031 | 가변텍스트 | `{"inputs":[{"key":"개수","max":3,"min":0,"type":"integer","unit":"개"}]}` |
| PROC_000014/015/016 | 유광/무광/UV | `{"inputs":[{"key":"면","type":"enum","values":["단면","양면"]}]}` |
| PROC_000017 | 제본 | `{"inputs":[{"key":"방향",…},{"key":"책등","type":"number","unit":"mm"},{"key":"고리형","type":"boolean"}…]}` (다축) |
| PROC_000002 | UV | `{"inputs":[{"key":"변형","type":"enum","values":["일반","배면양면",…]}]}` |

→ **정의는 있는데(prcs_dtl_opt), 사용자가 "줄수=2 / 면=양면 / 책등=12mm"를 골랐을 때 그 선택값을 적을 곳이 option_items에 없다.** 이것이 GAP-PARAM의 본질. `ref_param_json`은 prcs_dtl_opt의 **schema↔value 쌍**(정의↔인스턴스)을 완성한다.

### 1.3 jsonb는 라이브 확립 컨벤션 (신규 패턴 아님)
```
t_prd_product_constraints.logic         jsonb   (JSONLogic 룰)
t_prd_products.constraint_json          jsonb   (compile 캐시)
t_proc_processes.prcs_dtl_opt           jsonb   (파라미터 스키마)
```
→ jsonb 컬럼 추가는 **외래 shape가 아니라 라이브 4번째 동종 컬럼**. GIN 인덱스는 셋 다 **없음** → ref_param_json도 인덱스 불요(컨벤션 정합).

---

## 2. search-before-mint (HARD — 사다리 코드행<컬럼<JSONB<테이블)

| 사다리 | 후보 | 라이브 근거 | 무손실 가능? |
|:--:|------|-------------|:--:|
| 1 코드행 | `t_cod_base_codes` 자식코드로 파라미터값 | 줄수 0~3·개수 0~3·책등 mm 등은 **연속/가변 수치**라 enum 코드 부적합. 더욱이 코드행은 "어떤 option_item이 어떤 값인지" 인스턴스 연결을 못 담음 | ❌ |
| 2 단순 컬럼 | 기존 `qty integer` 재사용 | qty는 단일 정수 1칸. **단일 파라미터(줄수만, 개수만)는 가능하나** ① 의미 오용(qty=수량 의미인데 줄수 smear) ② 다축 불가(제본 방향+책등+고리형, 코팅 면+변형) ③ enum 값("양면","일반") 불가 | ❌ (단일 정수만·smear 위험) |
| 2 단순 컬럼 | 신규 정수 컬럼 N개(`param_n1`,`param_n2`…) | 공정별 키 개수·타입 상이(정수/enum/boolean/number+unit). 고정 컬럼 N개로는 prcs_dtl_opt의 가변 스키마를 못 맞춤 → 컬럼 폭발·NULL 밭 | ❌ (가변 스키마 부적합) |
| **3 JSONB** | **`ref_param_json jsonb`** | prcs_dtl_opt(jsonb 스키마)와 **shape 짝**. `{"줄수":2}`·`{"면":"양면"}`·`{"방향":"좌철","책등":12,"고리형":true}` 무손실 표현. 라이브 jsonb 컨벤션 정합 | ✅ |
| 4 테이블 | `t_prd_product_option_item_params`(item_seq별 N행) | option_item당 파라미터 0~3개라 1:N 테이블도 가능하나, ① 값 묶음이 항상 한 item에 종속(독립 라이프사이클 없음) ② prcs_dtl_opt가 이미 jsonb 한 칸에 스키마를 담음 → 평행 jsonb가 정규화·관리 양쪽 우위. 테이블은 over-modeling | △ 가능하나 과설계 |

**결론:** 사다리 1·2 무손실 실패 입증, 4는 과설계. **3단계(JSONB 컬럼)가 최소 무손실 해법** — prcs_dtl_opt와의 schema↔value 대칭이 결정적 근거.

---

## 3. 설계 (컨벤션 정합) — 최소 ALTER

```sql
ALTER TABLE t_prd_product_option_items
  ADD COLUMN ref_param_json jsonb NULL;
COMMENT ON COLUMN t_prd_product_option_items.ref_param_json IS
  '공정 파라미터 선택값(prcs_dtl_opt 스키마의 인스턴스). 키=prcs_dtl_opt.inputs[].key. NULL=파라미터 없는 옵션.';
```

- **NULL 허용:** 파라미터 없는 옵션(사이즈/자재/도수 단순 참조)은 NULL — 대다수 option_item이 NULL이므로 NOT NULL 금지(백필·의미 양쪽).
- **인덱스:** 불요(라이브 jsonb 3건 모두 무인덱스. 옵션 항목 조회는 PK(prd_cd,opt_cd,item_seq)로, jsonb는 환원/표시용 페이로드).
- **컨벤션:** 컬럼명 `ref_param_json`은 설계 §3.1·cpq-schema §4가 명명한 이름 그대로 — `ref_dim_cd`/`ref_key1`/`ref_key2`와 같은 `ref_*` 접두 계열로 자연 정합. jsonb 타입은 라이브 관용.

### 3.1 키/값 shape 예시 (파라미터 유형별)
prcs_dtl_opt의 `inputs[].key`를 키로 사용(스키마↔값 1:1 매핑):

| 파라미터 유형 | option_item이 가리키는 공정 | ref_param_json 값 | 비고 |
|---------------|----------------------------|-------------------|------|
| 타공 구수 N | PROC(타공) | `{"구수": 6}` | 4/6/8 — 공정 1행 재사용(마스터 비대화 방지) |
| 오시/미싱 줄수 | PROC_000029/030 | `{"줄수": 2}` | prcs_dtl_opt min0 max3 정합 |
| 가변 텍스트/이미지 개수 | PROC_000031/032 | `{"개수": 3}` | min0 max3 |
| 코팅 면 (단/양면) | PROC_000014/015/016 | `{"면": "양면"}` | enum 값 그대로 |
| 박 크기 | PROC(박) | `{"크기": 25}` | mm — 박등급은 앱 계산(DB는 크기만) |
| 조각수 N | PROC(조각/도무송) | `{"조각수": 4}` | 아크릴/스티커 |
| 구수 1~4구 (굿즈) | PROC(개수형) | `{"구수": 2}` | GAP-COUNT — 동일 메커니즘 통합 |
| 제본 다축 | PROC_000017 | `{"방향":"좌철","책등":12,"고리형":true}` | **다축 — qty 1칸 절대 불가** |

> [HARD] 키는 prcs_dtl_opt.inputs[].key와 **반드시 일치**(앱이 schema로 검증). qty 칸에 구수/줄수 smear 금지(qty는 수량 의미 보존).

---

## 4. 정규화 증명

- **무손실:** 단일·다축·enum·정수·number+unit·boolean 전 파라미터 유형을 jsonb 한 칸에 표현 → GAP-PARAM이 명시한 "공정 1행 재사용 + 선택값 보존" 정확 해소. 타공 4/6/8을 공정 3행 복제(마스터 오염) 없이 1행+`{"구수":N}`로.
- **무중복:** prcs_dtl_opt는 **스키마(정의)**, ref_param_json은 **값(인스턴스)** — 같은 사실 이중 저장 아님(정의 vs 선택). qty(수량)와도 의미 무중복.
- **함수종속:** (prd_cd, opt_cd, item_seq) → ref_param_json 완전종속. 부분/이행종속 신설 0.
- **참조무결성:** 키 정합은 prcs_dtl_opt 스키마가 권위(앱 검증). DB FK 대상 아님(jsonb 페이로드).

---

## 5. 영향 분석

- **기존 행:** option_items **0행** → ALTER ADD COLUMN(NULL) = **즉시·무잠금·백필 0**. 무영향.
- **트리거 `fn_chk_opt_item_ref` 상호작용:** 트리거는 `ref_dim_cd`/`ref_key1`/`ref_key2`만 검사(차원행 EXISTS). **ref_param_json은 트리거 미참조** → 트리거 로직 변경 불요·기존 검증 무영향. 단 향후 "param 키가 prcs_dtl_opt에 존재하는지" 검증을 트리거에 **추가하고 싶다면** 별도 제안(현 제안 범위 밖, 앱 레벨 검증 권장).
- **FK:** 신규 FK 0(jsonb는 FK 대상 아님) → 고아 0.
- **인덱스:** 추가 0(라이브 jsonb 컨벤션 정합).
- **적용 순서:** ALTER → 이후 CPQ option_items 적재(엽서 파일럿 4 insertable + GAP-PARAM 행). round-6 option-layer 적재 **이전**.
- **롤백:** `ALTER TABLE t_prd_product_option_items DROP COLUMN ref_param_json;` (option_items 0행이라 데이터 손실 0).
- **닫히는 GAP:** GAP-PARAM(High) + GAP-COUNT — 적용 후 후가공 4종·박/형압·타공 구수·조각수·구수 1~4구·코팅 면·제본 다축 옵션이 **선택값 보존하며** 적재 가능으로 승격. 엽서 파일럿 BLOCKED 5행 중 후가공 줄수/개수 관련분이 PARAM 측면에서 해소(단 GAP-DEFER 차원 선적재는 별도).

---

## 6. 잔존 인간 결정 (자율 진행 금지)

1. **컬럼 vs 트리거 검증 강도:** 본 제안은 컬럼만(앱이 prcs_dtl_opt 스키마로 키 검증). DB 트리거에 "param 키 유효성" 강제 추가는 별도 결정(권장: 앱 검증 — jsonb 검증을 트리거에 넣으면 복잡도↑).
2. **키 표기 규약:** 한글 키(`구수`/`줄수`/`면`)는 prcs_dtl_opt 현행과 일치. 영문 전환은 prcs_dtl_opt 동시 마이그레이션 필요(현재는 한글이 라이브 권위 — 유지 권장).
3. 적용은 후니가 라이브에 ALTER 수행 — 제안과 적용 분리(propose ≠ apply).
