# PRF_DGP_A — remediation-plan (arbiter 정립 + C-2 심의)

> 작성 2026-06-14 · round-18+ Phase 6. 입력 = [[mapping-integrity]]. DB 미적재(제안까지·실 적용 인간 승인).

## 1. 정립 대상 (D-2 옵션→comp 멤버십 매핑)

해소할 것: 옵션값(OPV_*) 선택 → 합산할 comp_cd 집합 결정. 클래스 PRF_DGP_A의 멤버십 매핑 부재 항목:
| 옵션그룹 | 옵션값 → comp_cd | 비고 |
|---|---|---|
| 인쇄(택1) | 단면→COMP_PRINT_DIGITAL_S1 / 양면→S2 | 단가는 siz×clr×면수 차원 |
| 코팅(택1, 옵션그룹 미적재시 추가) | 유광→COMP_COAT_GLOSSY / 무광→MATTE / 없음→∅ | 단가는 siz×coat_side |
| 모서리(택1) | 직각→COMP_PP_CORNER_RIGHT / 둥근→ROUND | 0원·차원없음 |
| 후가공(택N) | 오시→CREASE_nL / 미싱→PERF_nL / 가변텍스트→VARTEXT_nEA / 가변이미지→VARIMG_nEA | 수량변형(_nL/_nEA) 2차 |
| 종이(택1) | MAT_xxx → COMP_PAPER (mat 차원) | **이미 연결됨**(추가 불요) |

별색(COMP_PRINT_SPOT_*)은 엽서 016 옵션그룹에 미적재 → 클래스 내 별색 보유 상품(슬로건 등) 적재 시 동형 매핑.

## 2. C-2 심의 — 매핑 권위: option_items vs 차원 컬럼

### 가설 A — CPQ option_items 확장 (옵션값 → comp_cd 직접 참조) **[채택·확정 2026-06-14]**
- OPT_REF_DIM에 신규 코드 `.08 가격구성요소(PRICE_COMP)` 추가(base_code 1행) + option_items에 {opt_cd=OPV_xxx, ref_dim_cd=.08, ref_key1=comp_cd} 행 추가.
- 엔진: 선택 옵션값의 option_items 중 .08 참조를 활성 comp 집합에 합집합 → 그 comp만 차원매칭 단가 조회·합산.
- **장점**: ① 멤버십을 옵션 레이어가 표현 = 의미 정합(멤버십은 옵션 선택의 속성). ② polymorphic 구조의 자연 확장(이미 .01~.07 차원행 참조 중). ③ 옵션 레이어 이미 적재(엽서 4그룹·silsa)·admin 관리 가능. ④ comp 공유 보존(단가행 불변).
- **단점**: base_code 1행 추가(DDL 경량). 기존 option_items 의미가 "차원행"에서 "차원행 + 가격comp"로 확장(단 polymorphic 의도엔 부합).

### 가설 B — component_prices.opt_cd 차원 활성화
- 미사용 opt_cd 컬럼에 OPV_xxx 채워 단가행을 옵션값별로 식별.
- **치명 단점**: opt_cd(OPV_*)는 **상품 스코프**(prd_cd별 발번) → 공유 comp(디지털인쇄 212행 등)가 상품마다 분화·폭증. 그리고 **의미 왜곡** — 가격이 opt에 의존(차원)하는 게 아니라 comp **포함 여부**가 opt에 의존(멤버십). prcx01 §"차원 독립성: 의존하지 않는 차원은 NULL"과 충돌. EAV식 남용 위험.
- 채택 시 한정: 단가가 *실제로* 옵션에 의존하는 경우만(현 PRF_DGP_A엔 해당 comp 없음 → B 부적합).

### 가설 C — comp ↔ 공정(proc_cd) 매핑 경유
- COMP_PP_CORNER_RIGHT ↔ PROC_000027 등 comp-공정 매핑 신설 → 옵션(이미 공정 가리킴)→공정→comp 2-hop.
- **단점**: 신규 매핑 테이블/컬럼. 인쇄면·코팅 등 공정 아닌 옵션엔 부적합(부분해). comp 코드 의미를 공정에 종속.

### 권고 = **가설 A**
근거: D-2는 **멤버십 문제**(mapping-integrity §2-1). 멤버십의 자연한 소재지는 옵션 레이어(option_items)다. B는 멤버십을 단가차원으로 오인코딩(의미 왜곡·공유 comp 폭증), C는 부분해·간접. A는 의미 정합 + 기존 적재 자산 재사용 + DDL 최소(base_code 1행).

## 3. 트랙·산출 경로
1. **base_code 추가 + 트리거 보강** `OPT_REF_DIM.08 가격구성요소` — ddl-proposer. [[_remediation/ddl-opt-ref-dim-08]].
   - 테이블 구조 ALTER 0(base_code 1행 INSERT)이나 **무결성 트리거 `fn_chk_opt_item_ref()` 보강이 필수**(CRITICAL, 양 에이전트 독립 적발 F-3): 라이브 함수가 `CASE ref_dim_cd` 7종 후 `ELSE RAISE EXCEPTION '미지원 ref_dim_cd'` → base_code만 추가하면 .08 행 INSERT가 예외로 차단됨. `.08 → t_prc_price_components(comp_cd) 존재 확인` WHEN 분기를 추가한 `CREATE OR REPLACE FUNCTION` 동반(기존 .01~.07 본문 바이트 동일 보존). 적용순서 base_code → 함수.
   - 확정 코드: `cod_cd=OPT_REF_DIM.08·cod_nm=가격구성요소·disp_seq=8`(라이브 7종 동형, 충돌 0).
2. **멤버십 option_items 적재** — option-mapper(round-6 `dbm-cpq-option-mapping`). [[_remediation/membership-option-items]] + `load/option_items-membership.csv`(**12행**: 016 기본 8[인쇄2+모서리2+후가공4] + 코팅 4[017·026 유광/무광×2]). 종이는 0행(기존 .03 자재행이 COMP_PAPER mat 차원과 공유 = 멤버십 자동). 신규 행은 item_seq=2(기존 차원/공정 item_seq=1과 별개)·ref_dim_cd=.08·ref_key1=comp_cd. 차원-결정 단가 불변. 후가공 수량변형(_nL/_nEA)은 기본행만, 변형은 2차 트랙(F-4).
   - **[CONFIRM:016-COATING 해소 2026-06-14]**: 016 프리미엄엽서는 코팅 미실재(엑셀 컬럼29 전 행 공란·라이브 미적재 정합) → 코팅 그룹/멤버십 적재 불요(정직 결론). 코팅 실재 = **017 코팅엽서·026 종이슬로건 2상품뿐** → 유광→COMP_COAT_GLOSSY/무광→MATTE 4행 동형 추가. **coat_side(단/양면)는 멤버십 아닌 단가 차원**(COMP_COAT 단가행 coat_side_cnt 보유) → 멤버십 무영향, 파생방식만 `[CONFIRM:COAT-SIDE]`로 D-1/엔진 트랙 위임.
3. **D-1 작업사이즈→출력판형 변환표** — [[../../26_price-engine-verify/PRF_DGP_A/d1-plate-conversion]]. **[RESOLVED 2026-06-14]**: 변환 = `t_siz_sizes.note` 전지치수 룩업(작업사이즈→전지 316×467→SIZ_000499). 9상품 36 작업사이즈 전부 → **SIZ_000499 단일**, 단가행 실재. SIZ_000077(캘린더) 혼입은 siz 차원 고정으로 자동 배제(정상 공유구조). D-2+D-1 결합 재계산 C1(100매)=44,330·C2(500매)=141,650 → known 일치(보정 하드코딩 0).
   - 🔴 **D-1b 신규결함(돈-크리티컬)**: 후가공 13 comp(오시/미싱/가변/모서리둥근) `prc_typ_cd`가 **단가형(.01) 오적재**. 엔진이 단가×주문수량 해석 → 최대 주문수량배(100매=100배) 과대(C3 Δ990,000). → 후가공 포함 케이스 G-CALC BLOCKED였음.
   - **[D-1b 의미판별 확정 2026-06-14·가격표 권위]**: 가격표 `인쇄후가공` 시트 헤더에 **"합가" 명시**(A1 모서리·A15 오시·F15 미싱), 셀 값 = 수량구간별 **고정 총액**(장당가 아님). 판별 = **ⓒ 구간고정총액형**(수량 무관 1회 부과). ⓐ단가형·ⓑ명세식 합가형(÷×환산) 모두 기각(C4 250매 단조성 위반으로 입증). **라이브 값은 가격표와 전건 일치 = 메타데이터 오적재(값 손상 0, 데이터 안전).** 정정 후 재계산 C3=104,330·C4=105,825 가격표 정합.
   - **정정안 2택(C-D1b, webadmin Phase11·인간 승인 범위)**: ⓒ-1[권장] `.02(합가형)` 변경 + 엔진 합가규칙 "구간총액 그대로(÷× 없음)" 정의 + 11-CONTEXT §16 명세 "구간고정총액형" 보강 / ⓒ-2 신규 `PRICE_TYPE.03(구간고정총액형)` 코드 신설.
   - **[CONFIRM:COAT 해소]**: 코팅 시트 "합가" 없음·수량↑ 장당가↓=진짜 단가형, 라이브 전건 일치 → **코팅 정확(정정 불요)**.
   - 잔존: `[CONFIRM:C-D1b]`(ⓒ-1 vs ⓒ-2 정정방식·엔진 범위) · `[CONFIRM:016-DFLT]`경미(plate dflt_plt_yn).
4. **엔진 구현(evaluate_price)** — webadmin Phase11(우리 범위 밖·인간/개발).

## 4. 재검증 기준 (Phase 9 폐루프 — RESOLVED 판정)
A 적용(base_code + option_items) 후 G-DATA A-1 재실행 시:
- [ ] 각 옵션그룹 택1/택N 선택 시 활성 comp 집합이 **그 선택에 대응하는 comp만** 포함(무차별 합산 0).
- [ ] **계산기 보정 하드코딩(`compute_corrected`) 없이** option_items 매핑만으로 활성 comp 재현([HARD]).
- [ ] 재계산값 = 엑셀 known(가격표 round-2/16 적재 단가) 합산과 일치(D-1 출력판형 변환 적용 후).
- 충족 시 D-2 RESOLVED → G-CALC 진입 허용 → 벤치마크(PRF_BIND_SUM 우선).

## 5. 컨펌 (사용자/실무진)
- **C-2 [확정 2026-06-14]**: 매핑 권위 = **가설 A(option_items + OPT_REF_DIM.08) 채택** (사용자 비준). 후속 트랙 §3 ⓐ→ⓑ→ⓒ 진행, 실 DB 적용은 인간 승인. 가설 B(가격차원 오인코딩·공유 comp 폭증)·C(부분해·간접)는 기각.
