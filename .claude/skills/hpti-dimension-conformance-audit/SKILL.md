---
name: hpti-dimension-conformance-audit
description: 후니 가격구성요소(component)의 use_dims 선언 ↔ component_prices 충전 차원 ↔ 상품 옵션 선택수단 3자 정합을 전 상품 전수 적대적으로 진단해 "돈 새는 차원 누락"을 적발하는 §26 방법론. 결정론 스크립트 dim_conformance.py(토큰0·union 분담 흡수·신뢰도 태깅)로 (상품×component×차원) 격자를 조인 → MISSING(손님 선택가능한데 단가행 0=저청구/견적불가)·UNDECLARED(단가행은 차원 구분하는데 use_dims 미선언=silent 가산)를 산출. 봉투제작처럼 사이즈에 못 넣는 종류를 옵션그룹으로 두고 polymorphic ref_dim 환원하는 패턴도 정합 판정. 라이브 읽기전용·DB 미적재(교정은 인간 승인 후 dbmap). 트리거: 차원 정합 진단, 차원 누락 진단, use_dims 정합, 돈 새는 차원, 옵션 차원 단가행 정합, 가격구성요소 차원 누락, 봉투제작 차원, dim conformance, 차원정합 다시, 특정 상품만 차원진단. component use_dims↔충전 정합(파일럿)은 hpq-price-chain, 권위격자 셀 무결성은 hpti-load-integrity-audit, CPQ 옵션→차원 해소는 hcc-cpq-link가 담당.
---

# 차원 정합 적대적 진단 (3자 조인) — §26

가격구성요소가 손님 선택을 단가로 환원하지 못해 **돈이 새는** 차원 누락을 전수 적발한다. 핵심은 3개 면을 **한 격자(상품×component×차원)에서 조인**하는 것이다. 기존 스킬은 각 면을 따로 봐서 조인이 사람 머릿속에서만 일어났다.

## 3개 면(face)

| 면 | 출처 | 의미 |
|---|---|---|
| **A use_dims** | `t_prc_price_components.use_dims` (JSON) | component가 선언한 차원 (`proc_grp:*` 게이트 토큰은 차원 아님→제외) |
| **B 충전** | `t_prc_component_prices` 컬럼 DISTINCT | 단가행에 실제 채워진 차원값 집합 |
| **C 선택수단** | 상품 테이블 + 옵션 환원 | 손님이 그 차원을 고를 수단 |

Face C 소스: `t_prd_product_sizes`(siz_cd)·`_plate_sizes`(siz_cd컬럼→plt_siz_cd)·`_materials`(mat_cd)·`_processes`(proc_cd)·`_print_options`(print_opt_cd)·`_bundle_qtys`(bdl_qty) + `t_prd_product_option_items`의 polymorphic 환원.

**polymorphic ref_dim 매핑** (옵션이 어느 차원으로 환원되나): `OPT_REF_DIM.01`=siz_cd · `.02`=plt_siz_cd · `.03`=mat_cd · `.04`=proc_cd · `.05`=bdl_qty · `.06`=도수 · `.07`=셋트. 봉투제작(티켓/소/자켓/대봉투)이 `.01`로 사이즈에 환원되는 게 정상 패턴 — 사이즈에 직접 못 넣는 종류를 옵션그룹 차원으로 처리.

## 판정 (verdict)

- **MISSING** = `avail(C) − union_filled(B)` ≠ ∅ — 손님이 고를 수 있는데 어느 component에도 단가행 없음 → **견적누락/저청구**. 돈샘 🔴
- **UNDECLARED** = component_prices에 차원 D로 단가행 구분(B 충전)하는데 그 component use_dims에 D 미선언(A 누락) + 상품이 D 선택수단 보유 → 엔진이 차원 못 봐 **silent 가산/무시**. 돈샘 🔴
- SURPLUS(단가행 있는데 선택불가)는 죽은단가로 돈샘 아님 → 본 진단 제외.

## 핵심 알고리즘 — union 분담 흡수 [HARD]

한 상품-공식에서 **같은 차원 D를 use_dims에 쓰는 모든 component의 충전값을 UNION**한 뒤 avail과 비교한다.

이유: 한 상품의 여러 component가 차원값을 **분담**한다 — 등급 분할(프리미엄명함 MGA/MGB가 자재를 나눠 담당), 역할 분담(별색 comp는 별색 공정만, 박 comp는 박 공정만). component 단위로 avail 전체와 비교하면 "다른 component가 담당하는 값"이 전부 false MISSING으로 잡힌다(실측 221건 중 180건이 false). union하면 진짜 "어느 component에도 없는" 값만 남는다(41건). **이 가드 없이는 진단이 노이즈에 묻힌다.**

## 신뢰도 태깅

- **HIGH**: mat_cd·siz_cd·plt_siz_cd·bdl_qty — 보통 1 component 전담, 누락=진짜. 즉시 교정 큐.
- **REVIEW**: proc_cd·opt_cd·print_opt_cd — union 후에도 분담 잔여 가능, 수동 검토.
- UNDECLARED는 방향이 반대(충전됐는데 미선언)라 항상 HIGH.

## 실행

```bash
set -a; . .env.local; set +a
python3 _workspace/huni-price-table-integrity/_batch/scripts/dim_conformance.py            # 전수
python3 _workspace/huni-price-table-integrity/_batch/scripts/dim_conformance.py PRD_000050 # 단일(봉투제작)
```

출력 TSV: `prd_cd · frm · comp(들) · dim · verdict · conf · cnt · detail`. HIGH MISSING/UNDECLARED부터 본다.

## 검증된 골든

- 봉투제작 PRD_000050: `mat_cd MISSING HIGH MAT_000169`(레자크줄무늬 단가행 0) — 자재 3종 노출인데 단가 2종.
- 명함032 PRF_NAMECARD_COAT: `print_opt_cd UNDECLARED`(메모리 "032 코팅 저청구"와 독립 일치 = 도구 신뢰성 입증).

## 경계

- 교정(단가행 적재·use_dims 수정)은 **인간 승인 후 dbmap 위임** — 본 트랙은 진단·교정명세까지. 라이브 읽기전용 SELECT만.
- false-positive 의심은 삭제 말고 REVIEW로 출처 병기. 신규 차원 컬럼/공식은 CHECK_DIMS·REFDIM에 추가.
- 검증은 `hpti-integrity-gate`가 독립 재판정(생성≠검증).
