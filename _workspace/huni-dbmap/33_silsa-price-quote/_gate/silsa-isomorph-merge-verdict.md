# 실사(포스터/사인) 동형 가격구성요소 결합 — 독립 검증 게이트 (R1~R6)

> **검증** 2026-06-18 · dbm-validator. **생성자(arbiter·load-builder) 주장 비신뢰·라이브 read-only 직접 재실측.**
> **대상:** `silsa-isomorph-merge-design.md` + `_exec_isomorph/apply.sql` (UPDATE 19·INSERT 0·DELETE 0).
> **방법:** 라이브 `db railway` SELECT + 단일 트랜잭션 `BEGIN…(apply+assert)…ROLLBACK` (COMMIT 0·DDL 0·비밀값 미출력).

## 종합 판정: **GO** (R1~R6 전건 PASS)

라이브 직접 재측정 결과, 동형 결합 2그룹은 byte-identical이 진위이며, 결합 후 단가행 보존·배선 무결·멱등·골든 가격 불변이 모두 입증됨. 단독 5개의 결합 금지도 정당. **실 COMMIT은 인간 승인 대기**(이 게이트는 적재 가능성 증명, 실 적용 아님).

---

## R1 — 동형성 진위 (최우선·돈 크리티컬): **PASS**

라이브 `t_prc_component_prices` 전컬럼(siz_width·siz_height·unit_price·min_qty·siz_cd·clr_cd·mat_cd·proc_cd·opt_cd·print_opt_cd·dim_vals·bdl_qty·coat_side_cnt·plt_siz_cd·apply_ymd) 정렬 md5 + 셀단위 FULL diff 직접 재계산:

| 클러스터 | 라이브 md5(재측정) | comp 수 | 행수 | comp |
|---------|------|:--:|:--:|------|
| 그룹 A | `6ee1c164761570d6f140fc361d988d4d` | 4 | 52 | CANVAS_FABRIC, LEATHER_ARTPRINT, MESH_PRINT, TYVEK_PRINT |
| 그룹 B | `83898dc4234818c78bbd7d7a265ef18b` | 4 | 52 | ADH_WATERPROOF_PVC, ARTFABRIC_GRAPHIC, ARTPRINT_PHOTO, WATERPROOF_PET |
| 단독 5 | 5개 전부 고유 md5 | 1씩 | 79/52/52/46/39 | BANNER_NORMAL·ADH_CLEAR_PVC·LINEN_FABRIC·BANNER_MESH·ARTPAPER_MATTE |

- **셀단위 diff (정본↔레거시 6 pair):** canon_only=0, legacy_only=0 전건 → byte-identical 입증. 배선 재지정해도 모든 좌표 동일 단가.
- **단독 분리 정당성:** LINEN(32,400)·ADH_CLEAR(59,400) 600×1800 단가가 그룹과 상이, EXCEPT diff 52행 전부 다름 → 결합 금지 정당.
- **md5 값이 설계(21f95956/768633ec)와 다름:** 직렬화 컬럼 순서/구분자 차이일 뿐. **클러스터 구조(그룹 내 4 동일·단독 5 고유)는 설계와 완전 일치** → 결합 판단의 근거는 동일.

### ⚠ dodge-hunt 발견 (게이트 통과·정보성, NO-GO 아님)
1. **use_dims 범위 "13개" 주장 부정확 → 실측 15개.** `use_dims=["siz_width","siz_height"]` comp는 라이브에 **15개**(COMP_ACRYL_COROTTO·COMP_ACRYL_MIRROR3T 포함). 설계 §1은 "정확히 13개"라 단정. 다만 추가 2개는 아크릴(COMP_ACRYL_*)로 `COMP_POSTER_%` 범위 밖 → 결합 대상에 자연 미포함. **결과적 안전하나 설계 문구는 "POSTER 한정 13개"로 정정해야 정확.**
2. **ARTPAPER_MATTE(단독)가 그룹 B와 26 공유좌표에서 단가 동일.** 600×1800=21,600으로 ARTPRINT_PHOTO와 우연 일치. 그러나 전체 매트릭스 diff: matte_only=13·artprint_only=26·shared=26(공유 좌표 단가 mismatch 0). **좌표 범위가 달라**(MATTE는 작은 사이즈만 39행) 결합 시 26 좌표 손실/오류 → 단독 유지가 옳음. 설계의 단독 분류 정당, **하지만 "한 좌표 단가 같다고 결합 안 됨"의 반례로 더 위험했던 케이스**(행수만 보면 안 됨을 재확인).

---

## R2 — 단가행 보존: **PASS**

DRY-RUN 트랜잭션 내 apply 후 측정:
- 13 comp 단가행 합 = **684** (before 684 = 불변, INSERT/DELETE 0).
- 레거시 6 comp 단가행 각 **52행 물리 보존**(use_yn=N만, 행 삭제 0).
- apply.sql에 `t_prc_component_prices` 대상 구문 0건(read-only 확인).

---

## R3 — 배선 무결성: **PASS**

apply 후:
- 레거시 6 PRF(LEATHER_AP·MESH·TYVEK→CANVAS_FABRIC / ADH_WP·ARTFABRIC·WATERPROOF→ARTPRINT_PHOTO) disp_seq=1 본체가 정본 가리킴 (6/6).
- 고아 배선(disp_seq=1이 use_yn=N comp 가리킴) = **0**.
- 중복 배선(PRF별 disp_seq=1 >1) = **0**.
- FIXED 배선 보존: `PRF_POSTER_FIXED` disp_seq=1 = COMP_POSTER_ARTPRINT_PHOTO **무변경**.
- 동시매칭: 정본 comp 단가표 좌표 UNIQUE(좌표별 1행), 셀 diff 0으로 간접 입증.

---

## R4 — 멱등성: **PASS**

동일 트랜잭션 2-pass:
- PASS 1 = **UPDATE 19** (formula_components 6 · use_yn 6 · comp_nm/note 7).
- PASS 2 = **UPDATE 0** 전건 → 무변경 가드(`IS DISTINCT FROM`·`NOT EXISTS`) 실재. 재실행 안전.

---

## R5 — 골든 가격 불변: **PASS**

배선 재지정 전후 골든 단가 직접 비교 + 전좌표 검증:
- **600×1800 BEFORE/AFTER 동일:** 그룹 A 4 PRF=37,800 / 그룹 B 4 PRF=21,600 (comp_cd만 정본 교체, 단가 불변).
- **전좌표 불변(한 좌표 아님):** 레거시 6↔정본 매트릭스 price_mismatch_coords=0 · legacy_coords_missing_in_canon=0 전건. 모든 좌표에서 정본 단가 = 레거시 단가 → 6 상품(PRD_000126/128/127/121/123/120) 견적 변동 0.

---

## R6 — 라이브 DRY-RUN·생성검증 독립: **PASS**

- **독립 재측정:** 생성자의 dryrun.sql 재실행이 아니라, 검증자가 직접 `BEGIN…apply…assert…ROLLBACK` 구성·실행. COMMIT 0·ROLLBACK 확인.
- **comp_nm 코드 노출 정비:** 현 라이브 comp_nm은 `포스터 완제품가(포함항목 통가격) [COMP_POSTER_...]`로 코드 노출. apply가 한글 소재명으로 정비(코드 노출 0·결합내역·골든값·정본/레거시 명시) → 사용자 형식 충족.
- **한글명 정확성 (라이브 frm_nm·prd_nm 대조 전건 일치):**
  - 정본/레거시 8명: 캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트 / 아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터 = 라이브 frm_nm·prd_nm 일치.
  - **정정 4건 검증:** 설계 약식명(아트지무광/메쉬배너/투명점착PVC/일반배너) → apply는 라이브 정식명(아트페이퍼포스터·메쉬현수막·접착투명포스터·일반현수막)으로 정정. 라이브 frm_nm과 **정확히 일치** → 정정 타당.

---

## 결함 / 라우팅

| 심각도 | 항목 | 라우팅 |
|--------|------|--------|
| MINOR(정보) | 설계 §1 "use_dims=13개" → 라이브 15개(아크릴 2 포함). 결합 대상엔 무영향(POSTER 범위 밖). | dbm-price-arbiter: 문구 "POSTER 한정 13개"로 정정 |
| 무해(확인) | ARTPAPER_MATTE가 그룹B와 26 공유좌표 단가 동일하나 범위 상이 → 단독 유지 정당 | — (판단 옳음) |

**기술적 BLOCKER·MAJOR·가격 오류 = 0.** 단일 결함도 없이 R1~R6 전건 PASS.

## 라이브 안전 확인
- 모든 측정 read-only SELECT + 롤백전용 트랜잭션. 실 COMMIT/UPDATE/DDL/영구쓰기 **0**. 비밀값 미출력.
- 실 적용(COMMIT)·DDL·코드행은 인간 승인 대기.
