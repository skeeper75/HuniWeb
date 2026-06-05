# Huni-DBMap CPQ 컨피규레이터 설계 — 핸드오프

작성: 2026-06-06 · 다음 세션이 이 문서만 읽고 이어가도록 정리. 식별자/코드/테이블/컬럼은 영어, 설명 한국어.
> 이 트랙은 round-2(가격매핑)/round-3(적재설계)와 **별개**다. 가격·적재 핸드오프는 `../HANDOFF.md`·`../HANDOFF-audit.md`.

## 0. 한 줄 현황 + 다음 시작점

현 스키마(상품별 차원 나열: size/material/process/print_option/…)를 **상품 컨피규레이터(CPQ)** 로 확장하는 설계 트랙. **설계안 정본화 완료 + 실상품 2종(일반현수막·프리미엄엽서) 종단 인스턴스화·독립 적대검증 완료(둘 다 CONDITIONAL-GO)**. DB·DDL 미적용(설계·검증 문서까지만).

> **[다음 시작점]** 본 §0 + §4(미해결) 읽고, §6 다음 후보 중 택1. 설계 정본 = `cpq-design.md`. 검증된 예시 = `banner-walkthrough.md`·`postcard-walkthrough.md`(각 validation 동반).

## 1. 이 트랙이 뭔가 (목적)

- **목표:** 현 "상품별 차원 나열" 스키마를 CPQ 모델로 확장 — ① **옵션/옵션그룹**(복합 옵션·택1/택N) ② **차원 간 제약**(JSONLogic) ③ **구성형 추가상품 템플릿**(= SKU). 이후 GSD 새 Phase로 등록 → DDL 마이그레이션 + 관리자 UI 반영.
- **시스템 경계(HARD):** 이 시스템 = 상품·옵션 마스터 + 컨피규레이터 정의(+검증). 주문/결제 = POD, 생산 = MES. **설계 제1원칙: 화면 최종 선택은 반드시 자재·공정으로 환원(resolve)되어 MES 주문 payload에 실린다.** 범위 밖: 주문 인스턴스 테이블·가격 계산 엔진·재고/BOM 차감 실행.
- **방법:** 설계안 → 실상품에 종단 인스턴스화(7테이블 실제 행) → dbm-validator 적대검증 → 설계 보정. 상품마다 설계의 다른 측면을 행사시켜 일반화를 점진 입증.

## 2. 산출물 5종 (`10_configurator/`)

| 파일 | 역할 |
|------|------|
| `cpq-design.md` | **설계 정본** — 시스템 경계·3축·결정로그·7 신규/변경 테이블·polymorphic 트리거·OPT_REF_DIM·미해결. (대화에만 있던 설계안을 파일화) |
| `banner-walkthrough.md` | 일반현수막(PRD_000138) 종단 인스턴스화 + 자체검증 |
| `banner-walkthrough-validation.md` | 위 독립 적대검증 (CONDITIONAL-GO) |
| `postcard-walkthrough.md` | 프리미엄엽서(PRD_000016)+봉투결합 인스턴스화 + 자체검증 |
| `postcard-walkthrough-validation.md` | 위 독립 적대검증 (CONDITIONAL-GO) |

## 3. 이번 세션 결정 (재론 금지)

- **② 옵션 모델 = Model 1(하이브리드)** — 기존 차원 테이블 유지 + 범용 옵션 레이어 추가, 공정 택일그룹을 일반 옵션그룹으로 흡수.
- **옵션 구성요소 참조 = polymorphic** (`ref_dim_cd` + 키슬롯) — 참조 차원이 8종(size/material/process/bundle-qty/color-count/plate/set/addon)이라 typed FK 비현실 → polymorphic + 검증 트리거. **DB FK 불가 → 트리거로 "그 상품 등록 차원만 참조" 강제.**
- **`ref_param_json` 신규 컬럼** — 공정 파라미터(타공 구수·후가공 줄수) 보존 필수. 없으면 공정 마스터 복제 오염.
- **① 추가상품 = 구성 템플릿**(`t_prd_templates`+`t_prd_template_selections`, = SKU). `t_prd_product_addons.addon_prd_cd → tmpl_cd`. 결합상품은 자기 prd_cd/siz_cd/qty로 **별도 주문상세(ADDON) 라인** → MES 독립 생산.
- **③ 제약 = JSONLogic** rule 행 → 활성 rule 컴파일 → `t_prd_products.constraint_json`(컴파일 캐시). POD(json-logic-js)·백엔드(json-logic-py) 동일 평가.
- **color-count 키슬롯 = `opt_id`** (clr_cd 아님) — 단/양면은 print_option opt_id로 식별. (검증 MISMATCH-1 정정 반영됨.)

## 4. 미해결 / 블로커 (다음 세션이 풀 것)

**잔존 미실증 GAP (설계 일반화의 빈 칸):**
- **GAP-A [MAJOR]** 진짜 max-N(전체 옵션수 > max_sel_cnt) 미실증 — 엽서 후가공은 max=전체4라 상한 무의미. **박색상 16종 중 N종** 또는 **별색 5종 중 N종** 같은 케이스 필요.
- **GAP-2 [MAJOR]** `t_prd_product_process_excl_groups` 마이그레이션 미실증 — 배너·엽서 둘 다 excl_grp 0행. **제본 택일(엽서북 GRP-BOOK류)** 등 excl_grp 실재 상품 필요.
- **GAP-5 [정책 미정]** 미적재 차원 vs EXISTS 트리거 충돌 — 종이=별도설정(material 0행)·후가공 PROC_000029~032(0행)·열재단 053(0행) 옵션은 참조 차원 부재 → 트리거 위반. **정책 택1: ①차원 선적재 의무 ②"센티넬"은 EXISTS 면제(material_cd=NULL+MES 수기지정).**
- **GAP-B/C [MINOR]** ★사이즈선택(본체연동 동적 봉투) template 미지원 · note 문자열→siz_cd 마이그레이션 결정규칙 미정.

**설계 미해결(`cpq-design.md` §6):**
- 물리 테이블/컬럼명 최종 확정(opt/grp/item/tmpl/rule — Dictionary 대조).
- 복합 옵션 항목 결합 의미(`item_combine_typ`: AND동반 / 하위종속) 명문화 — 박/형압 계층(박색상⊂박, 형압=별트리).
- excl_groups 흡수 vs 병존 최종 결정.
- template 깊이 한계(옵션 풍부 상품 add-on 시 selections 폭발) — "base 옵션 상속" 메커니즘 별도 설계.

## 5. 건드리지 말 것 (확정·검증 완료)

- 검증 완료된 5문서의 **사실 인용**(prd_cd/siz_cd/proc_cd/CLR/JSONLogic) — INVENTED 0·MISMATCH 1(정정 완료). 재검증 불요.
- 설정된 6개 핵심 결정(§3) — 재론 금지.
- **DB·DDL 미적용 원칙** — 본 트랙은 설계·검증 문서까지. 실제 DDL 마이그레이션·적재는 별도 승인.

## 6. 다음 시작점 후보 (사용자 택1)

1. **잔존 GAP 메우는 케이스 추가 검증** — 핑크별색엽서(PRD_000021, 별색5종)로 GAP-A(진짜 max-N) + 별색 multi-select 실증 / 엽서북(GRP-BOOK)으로 GAP-2(excl-group 마이그) 실증.
2. **GSD 새 Phase 등록** — 설계안을 GSD Phase로 올려 DDL 마이그레이션 + 관리자 UI 플랜.
3. **물리명 확정 + DDL 초안** — Dictionary/naming-guide 대조 → 7 신규/변경 테이블 DDL(트리거·인덱스 포함).
