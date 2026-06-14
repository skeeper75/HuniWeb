# PRF_BIND_SUM — S0 진입 스캔 (사전탐지표)

> 작성 2026-06-15 · round-18+ 전수 파이프라인 2번째 클래스 · `dbm-price-engine-verifier`.
> 입력: `full-class-pipeline-design.md` §2 진입 체크리스트 · `_class-map.md`(PRF_BIND_SUM=제본 합산형 4상품) · PRF_DGP_A D-패턴 정의 · round-16 `20_price-import/binding/binding-decomposition.md`(재발견 입력).
> 라이브 읽기전용 SELECT만. DB 미적재. 추정 0 — 라이브 실재·가격표 명시값만 권위.

---

## 0. 클래스 정체 (라이브 실측)

- 공식: `PRF_BIND_SUM` "제본 합산형(제본비 구성요소)" · use_yn=Y · note="책자 제본비. 수량×제본종류 표에서 제본비를 찾아 상위 공식에 더함."
- **유형 = 합산형**(제본비는 상품 원자합산 공식의 한 항. 단독 완제품가 아님).
- 바인딩 상품 4: PRD_000068 중철책자 · PRD_000069 무선책자 · PRD_000070 PUR책자 · PRD_000071 트윈링책자 (전부 PRD_TYPE.04·use_yn=Y).

## 1. S0 사전탐지표 (4종 D-패턴 라이브 스캔 결과)

| 패턴 | 스캔 시그니처 | 결과 | 판정 |
|---|---|---|---|
| **D-2** 옵션→comp 멤버십 부재 | ① component_prices.opt_cd 전건 NULL ② option_items.ref_dim_cd에 가격comp 참조타입(.08) 부재 ③ 제본 선택값이 comp_cd로 연결되나 | 🔴 **재발견(합산형)** — opt_cd 전건 NULL. 4상품 option_items의 ref_dim_cd = .01/.03/.04/.06만(.08 없음). 제본 선택은 **공정(.04 PROC_000018 중철·19 무선·21 트윈링)**으로 연결되나 가격 comp(COMP_BIND_*)와는 무관(PROC≠comp). | D-2 해당 → DEFERRED(횡단·AQ) |
| **D-1** 작업사이즈≠출력판형 | comp use_dims에 siz_cd 포함 & 단가행 siz=출력판형인가 | ✅ **N/A** — BIND comp use_dims=`["min_qty"]` (siz_cd 전건 NULL=와일드카드). 제본비는 사이즈 무관 권당 정액 차등. 출력판형 변환 자체가 없음. | D-1 무관 |
| **D-1b** prc_typ 단조성(총액형 의심) | prc_typ=.01 comp 중 min_qty↑시 unit_price 비감소 | ✅ **미해당** — 4 comp 전건 수량↑시 권당가 **단조 감소**(중철 3000→500·PUR 5000→1500). 진짜 단가형. design §2 "D-1b 의심 22 comp"에 BIND comp **미포함** 확인. | D-1b 무관 |
| **D-3** t_dsc 수량할인 미연결 | 상품 할인 바인딩 vs t_dsc 행 | ⚪ **무관(설계상)** — 책자4상품 t_prd_product_discount_tables 0행. t_dsc 테이블에 제본/책자용 테이블 자체 없음(아크릴/파우치/굿즈/문구만). 수량할인은 제본 단가행 권당가 차등에 **내재**(별도 t_dsc 불요). | D-3 무관 |

## 2. 추가 구조 결함 (BIND 고유 — design §2 4종 밖)

| ID | 결함 | 라이브 시그니처 | 비고 |
|---|---|---|---|
| **B-WIRE** 배선 단절 | formula_components(PRF_BIND_SUM) = **COMP_BIND_JUNGCHEOL 1행만**. 무선/PUR/트윈링 comp 미배선 | `select count(*) from t_prc_formula_components where frm_cd='PRF_BIND_SUM'` → **1** | 🔴 BLOCKING(무선/PUR/트윈링 가격 계산 불가). round-16 §5 단절1 **재발견**. |
| **B-FORMULA** 공식 설계 미스매치 | 책자4종 공유 1공식인데 제본방식은 상품별 1고정. JUNGCHEOL만 배선 → 무선책자도 중철 단가로 계산될 오류 가능 | 공식 1개 ↔ 상품 4개(제본 4종) | 🔴 round-16 §5.⚠️ **재발견**. 해법=상품별 공식 분리(A안) vs opt_cd 선택(B안)·컨펌 BIND-C1 |
| **B-OPT-070** PUR 옵션 전무 | PRD_000070 option_groups·option_items 0행 | 070 옵션 미적재 | 🟡 L2 미적재(가격 사슬과 별개·재계산엔 영향 없음·제본 고정 PUR) |

## 3. D-1b 22 comp 대조 (design §2 리스트 ∩ BIND)
- design §2 D-1b 의심 22 comp = 후가공(CREASE/PERF/VARIMG/VARTEXT/CORNER_ROUND)·명함박(NAMECARD_FOIL)·완칼도무송(CUT_FULL_DIECUT/PERF).
- **BIND comp(COMP_BIND_JUNGCHEOL/MUSEON/PUR/TWINRING) 4개는 그 리스트에 없음** → BIND는 D-1b 횡단 트랙 C-D1b-SCOPE와 무관. (단조감소 시그니처로 재확인 완료.)

## 4. S0 한 줄 요약 (GATE-A 검사범위 사전 좁히기)
> PRF_BIND_SUM(합산형 4상품) = **D-2 해당**(제본 선택→comp 멤버십 자리 .08 부재·PROC≠comp, DEFERRED 횡단) · D-1/D-1b/D-3 무관 · **BIND 고유 BLOCKING 2종: B-WIRE(공식에 중철 1개만 배선)·B-FORMULA(공식 설계 미스매치)** · B-OPT-070(PUR 옵션 미적재·재계산 무영향). → GATE-A는 ⓐ 제본비 구성요소 완전 배선 ⓑ 단가 단위(권당) ⓒ prc_typ 정확성을 검사. 단가행 값 자체는 D-1b 무관(단조감소).

## 부록 — 재현용 라이브 쿼리 결과
- formula_components(PRF_BIND_SUM) = 1행(COMP_BIND_JUNGCHEOL·disp_seq=1·addtn_yn=Y).
- BIND comp 11종 존재(책자4·하드커버3·캘린더4), 책자4 comp 각 단가행 8행(min_qty 1/4/10/30/50/70/100/1000).
- 4 comp use_dims=`["min_qty"]`·prc_typ_cd=PRICE_TYPE.01·siz/clr/mat/proc/opt 전건 NULL·apply_ymd 단일(2026-06-01)·동시매칭 0(min_qty 중복 없음).
- option_items ref_dim_cd 분포(4상품): .01×8·.03×88·.04×19·.06×12 (.08 가격comp 참조 0).
- 제본 선택 옵션값: 068→PROC_000018(중철)·069→PROC_000019(무선)·071→PROC_000021(트윈링)·070→옵션 0행.
