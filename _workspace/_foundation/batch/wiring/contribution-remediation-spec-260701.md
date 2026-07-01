# silent-0 확정 26건 교정 명세 (§18 설계정정 → §7 적재·인간 승인) — 2026-07-01

> 출처: `contribution_scan.py`(F층) 확정 결함. **UNCOVERED-HIGH 8 + MISMATCH-HIGH 10 = 18건/14상품.**
> [HARD] 명세까지 — 실 COMMIT/UPDATE는 인간 승인 후 §7 dbmap. 단가값 무변경(배선/proc 교정만).
> 근거: 라이브 스냅샷(snap_20260701) grep 실측. 유령 proc 090=0상품·029=4상품 재확인.
>
> ★스캐너 4라운드 수렴(71→18): 오탐 3종을 데이터 근거로 제거 — ① 별색인쇄비("인쇄" 키워드 오등급)
> ② 박/라미/UV(면적 siz_width·옵션 opt_cd 차원으로 가격·proc-coverage 무관) ③ **완제품가(.06) baked**
> (제본·타공이 통가격에 포함·CLASS-3/4 전건). 확정 18 = CLASS-1(8)+CLASS-2(10)만.

## 확정 수정 클래스 2종 (CLASS-1·2)

> ⚠⚠ **2026-07-01 적재 시도 결과 — CLASS-1 재키 BLOCKED·UNDO 완료(라이브 무변경).**
> CLASS-1 재키(090→029)를 COMMIT→simulate 검증했으나 **오시비 여전히 0**(자식 090 선택해도 미매칭) → 즉시 UNDO(원상복구 확인). 근본원인 재규명: 오시/미싱 proc는 **계층**(부모 PROC_000029=메뉴 / 자식 PROC_000090=가격·upr_proc_cd=029). 상품은 부모(029) 바인딩·단가행은 자식(090)·`proc_grp:PROC_000029` 게이트는 엔진 매칭에서 미사용(pricing.py:675 ":" 토큰 제외). **단가행 재키로 안 풀림 — 엔진의 후가공 proc 매칭 경로(proc_grp 게이트·부모/자식 해소·proc detail)가 미해소.** PRF_DGP_A 10비목 중 simulate 기여=인쇄·용지 2개뿐(오시·미싱·별색·코팅·귀돌이·가변 8개 전부 미발현). **→ §14(가격엔진 이해·진단)으로 후가공 proc 가격경로 매핑 선행 필수. CLASS-1은 데이터 교정 아님.** contribution_scan(F층)의 후보 적발은 유효하나 교정은 엔진 이해 후.

### CLASS-1 — [BLOCKED·재분류] 오시/미싱 후가공 proc 가격경로 (단순 재키 아님) · 8건
**결함**: 상품은 오시/미싱을 PROC_000029/030으로 손님에게 제공(product_processes), 가격 단가행은
유령 proc(090/086)로 적재 → 매칭 실패 → 무료(과소청구). 유령 proc는 어떤 상품도 미바인딩(안전).

| comp | 현재 단가행 proc(유령) | 교정 proc(상품 바인딩) | 영향 상품 |
|------|----------------------|------------------------|-----------|
| COMP_PP_CREASE_1L (오시비) | PROC_000090 | **PROC_000029** | PRD_000016·018·041·042 |
| COMP_PP_PERF_1L (미싱비) | PROC_000086 | **PROC_000030** | PRD_000016·018·041·042 |

**수정**: `t_prc_component_prices` 해당 comp 행의 `proc_cd` 를 유령→상품 proc 로 UPDATE(값·기타차원 불변).
**DRY-RUN SQL**(검토용·실행 인간 승인):
```sql
-- 오시: 유령 PROC_000090 → 상품 바인딩 PROC_000029 (COMP_PP_CREASE_1L)
UPDATE t_prc_component_prices SET proc_cd='PROC_000029'
 WHERE comp_cd='COMP_PP_CREASE_1L' AND proc_cd='PROC_000090';
-- 미싱: 유령 PROC_000086 → 상품 바인딩 PROC_000030 (COMP_PP_PERF_1L)
UPDATE t_prc_component_prices SET proc_cd='PROC_000030'
 WHERE comp_cd='COMP_PP_PERF_1L' AND proc_cd='PROC_000086';
```
**사전조건**: COMP_PP_CREASE_1L/PERF_1L 가 영향 상품 공식(PRF_DGP_A 등)에 이미 배선됨(확인). 재키만으로 매칭 성립.
**검증**: 재키 후 contribution_scan 재실행 → 해당 4상품 오시/미싱 UNCOVERED 소멸 + PRICE 재계산 오시/미싱비>0.

### CLASS-2 — base 인쇄공정 주입(돈크리티컬) · 10건
**결함**: COMP_PRINT_DIGITAL_S1(디지털인쇄비) 단가행 proc=PROC_000004(CMYK base)인데 아래 상품
product_processes에 PROC_000004 미바인딩 → 인쇄비 silent 0. [[digital-print-base-proc-missing-260701]] 동형.

| 상품 | 공식 |
|------|------|
| PRD_000020 | PRF_DGP_A |
| PRD_000051 | PRF_DGP_F |
| PRD_000285·286·287·289·291 | PRF_DGP_INNER (책자 내지 member) |
| PRD_000288·290·292 | PRF_BOOK_COVER (책자 표지 member) |

**수정(택1·§18+개발 결정)**:
- (A·데이터) 각 상품 `t_prd_product_processes` 에 PROC_000004 필수공정(mand_proc_yn=Y) 추가 — §7 적재로 해결, 코드 무변경. 기존 16상품 교정과 동형 일관.
- (B·엔진) 디지털 공식(COMP_PRINT_DIGITAL_S1 보유)의 base proc 를 엔진이 자동주입 — 1회 코드 수정이나 개발 C트랙·회귀범위 큼.
**권고**: (A) — §7 적재 일관·즉시·검증 용이. 책자 member(285~292) 포함 = C5 책자 가격 동시 해소.

## 오탐 재분류 — 완제품가(.06) baked (구 CLASS-3·4, 교정 불요)
구 CLASS-3(제본 6: 177/178/173/174/179/181)·CLASS-4(타공 2: 136/137)는 **전건 완제품가(PRC_COMPONENT_TYPE.06)
상품**으로 확인됨 — 제본·타공이 통가격(완제품가)에 **포함**돼 별도 비목 불요. proc 바인딩은 선택/생산
신호일 뿐. 라이브 실측: 177 COMP_STN_SPRINGNOTE·181 COMP_STN_JUNGCHEOL·136 COMP_POSTER_PET_BANNER·
179 COMP_TTEOKME 등 전부 .06 완제품가. **silent-0 아님 → 교정 대상 제외.** (스캐너 완제품가 가드로 자동 강등.)

## 적재 순서·검증(§7 인간 승인 후)
1. CLASS-1 재키(저위험·dryrun→COMMIT) → contribution_scan 재실행, 4상품 오시/미싱 UNCOVERED 소멸·비목>0.
2. CLASS-2 base proc 추가(A안) → 인쇄비>0 + 책자 member(285~292) 가격 성립.
각 단계 후 `contribution_scan.py --round N` 으로 수렴 추적. 종료=UNCOVERED/MISMATCH-HIGH 0.

## 메타(재발 방지)
- §18/§13 골든 재계산은 상품 실제 product_processes 로 selection 구성(손 proc 금지).
- §27 배선 종료척도에 F층(contribution HIGH 0) 포함.
- REVIEW 159(박/라미/UV)은 면적·옵션 가격 → engine-confirm 후 별도(본 26 확정분과 분리).
