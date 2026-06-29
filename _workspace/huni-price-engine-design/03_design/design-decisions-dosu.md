# design-decisions-dosu.md — 디지털인쇄 도수(흑백/칼라) 설계 결정 [갈래 A 확정·B 폐기]

> hpe-engine-designer 결정 로그. 짝: `engine-design-digital-dosu.md`·`golden-cases-dosu.md`·`dosu-load-draft.sql`.
> B안(proc_cd) 산출 보존: `_prev-dosu-Bplan/`.

---

## D-0. ★갈래 A 확정 · B안(proc_cd) 폐기 사유

| 항목 | 내용 |
|------|------|
| **확정** | 도수(흑백/칼라) = **clr_cd 차원**으로 일관 인코딩(흑백 CLR_000002·칼라 CLR_000005). evaluate_price가 clr_cd를 매칭 차원으로 보게(NON_QTY_DIMS에 clr_cd 추가·개발팀 C트랙). |
| **B안 폐기 사유** | 직전 B안(proc_cd로 도수 인코딩)은 "A안=clr_cd는 NON_QTY_DIMS에 없어 코드 수정 필요·directive 금지라 무효"라 판정했으나, **이 무효 판정이 오해**였다. "webadmin 코드 직접수정 금지"는 *우리가* 코드를 편집하지 말라는 뜻이지 엔진이 바뀌면 안 된다는 게 아니다. **엔진 변경을 개발팀 C트랙 명세로 산출**(우리=명세·개발팀=적용)하는 것은 허용된다. ∴ A안이 유효하고, 사용자가 A안을 확정. |
| **A안 채택 이점** | ① 도수가 의미축(clr_cd=도수)에 정확히 매핑(proc_cd=인쇄방식과 의미 분리·깨끗). ② 칼라/흑백 proc_cd 동일(PROC_000004 디지털인쇄)·도수만 clr_cd로 분기 = 도메인 정합(같은 디지털기·도수만 다름). ③ 향후 2도/3도(CLR_000003/4)도 clr_cd로 확장 가능(proc_cd 신설 불요). |
| **B안 대비 비용** | 엔진 코드 변경 1줄(C트랙·개발팀 적용 대기)·전역 영향분석 필요. but 후방호환 입증됨(§D-2). |
| 위상 | **권위 엑셀 절대**·라이브 엔진 계약 정합·DB 미적재. |

## D-1. 엔진 변경 명세 = pricing.py:42 NON_QTY_DIMS에 "clr_cd" 추가 (개발팀 C트랙)

- 우리=명세(engine-design §1)·개발팀=적용. **우리가 webadmin 코드 직접 편집 안 함[HARD]**.
- 한 줄(튜플 끝에 "clr_cd"). 리스크 4건(R-A1~A4) 개발팀 검토용 명세. 회귀 테스트 권장.

## D-2. ★전역 영향분석 결론 — 후방호환 ✅ · blast radius 격리 ✅

- **후방호환**: 전 8,753 단가행 clr_cd=NULL(실측). NULL 행은 `_row_matches`에서 와일드카드(통과)·`_combo_key`에서 모두 None(키 구조 불변). ∴ NON_QTY_DIMS에 clr_cd 추가해도 **기존 매칭 결과 불변**(디지털 칼라 행 채우기 전까지 동작 변화 0). 엔진 코드 라인 실측 근거(pricing.py:99 `if rv is None: continue`·:111 `_combo_key`).
- **격리**: 실제 도수 분기는 (a)단가행 clr_cd 채움+(b)comp use_dims에 clr_cd 등재+(c)selections.clr_cd 주입 — 셋 다 충족한 comp에서만. **COMP_PRINT_DIGITAL_S1만** 충족 → 디지털만 영향·비디지털 전 comp 무해(NULL 유지). use_dims 등재가 격리 스위치.
- **디지털만 채우기 안전**: 예. 단 칼라 채움=선택 강제(R-A3)라 도수 옵션 default=칼라와 동시 적용 필요(§D-5).

## D-3. 데이터 마이그레이션 규모 = 칼라 UPDATE 212 + 흑백 INSERT 212

- 칼라 212행 clr_cd NULL→CLR_000005 UPDATE(단가 불변·컬럼만). 흑백 212행 INSERT clr_cd=CLR_000002 verbatim(국4절 단53+양53·3절 단53+양53). use_dims UPDATE 1.
- ★**칼라 UPDATE + 흑백 INSERT 원자 적용**(§6.3 ambiguous 가드): 칼라 NULL(와일드카드)+흑백 명시 공존 시 흑백 선택→둘 다 cand→ERR_AMBIGUOUS. 둘 다 명시값으로 같은 트랜잭션에서.
- 단가 verbatim: 국4절 단면 qty1=3000·양면 qty1=4000·qty100 단면=200·3절 단면 qty1=3500(golden-cases-dosu·dosu-load-draft.sql 212행).

## D-4. 별색 처리 = 현행 유지 (권고·blast radius 최소화)

- 별색7종은 현재 proc_cd(PROC_000008~012)로 색 인코딩·별 의미축(추가색 인쇄≠도수). A안 범위는 디지털 흑백/칼라 도수. 별색을 clr_cd로 통합하면 의미 왜곡+별색 상품 회귀 위험. **현행 proc_cd 유지**. 별색 clr_cd 재정리는 후속(C-5).
- 두 축 공존: 도수=clr_cd(디지털)·별색=proc_cd. 엔진은 둘 다 NON_QTY_DIMS 차원으로 독립 매칭.

## D-5. 선택 배선 = 도수 택1 옵션그룹 → selections.clr_cd · default 칼라

- option_items.ref_dim_cd=clr_cd·ref_key1(칼라 CLR_000005 dflt / 흑백 CLR_000002). default=칼라(미선택 견적불가 가드 R-A3). 위젯 계약=clr_cd 키 1개 추가.
- ★주입 미연결 가능성(option_items ref_dim 0행·명함 G-7) → 시뮬레이터 게이트 선결(C-3). 미연결 동안 칼라 NULL 유지(와일드카드 무해·점진).

## D-6. evaluate_price 동작 = 정상 분기·원자성 가드·default 칼라

- 칼라/흑백 clr_cd 상이 → 도수 택1 시 combos 1개(ambiguous 없음). 칼라 채움 전엔 NULL 와일드카드와 흑백 명시 공존 위험(원자 적용 가드). default 칼라로 미선택 보존. 상세 engine-design §6.

---

## 컨펌큐 (인간 승인 / dbmap / 개발팀)

| ID | 내용 | 라우팅 | 우선 |
|----|------|--------|------|
| **C트랙** | pricing.py:42 NON_QTY_DIMS += "clr_cd"(1줄)·회귀 테스트 | **개발팀**(우리=명세) | High |
| **C-1** | 칼라 UPDATE 212 + 흑백 INSERT 212 원자 적용(ambiguous 가드) | dbmap·dbm-price-arbiter | High |
| **C-2** | 흑백=칼라 동형 53밴드·권위 56밴드 차이 | §26 무결성 | Med |
| **C-3** | 옵션→clr_cd 주입(option_items ref_dim) 라이브 작동·default 칼라 작동 | §15 quote-verify·시뮬레이터 게이트 | High |
| **C-4** | 흑백 판매 범위(전 디지털 ~15 vs 엽서만) | 실무진 | High |
| **C-5** | 별색 clr_cd 통합 여부(현행 proc_cd 유지 권고) | 후속 설계·도메인 | Low |
| **C-6** | C트랙 적용 후 회귀(vitest/가격 스위트) | 개발팀 | Med |
| **C-7** | codex 2차 교차(B안 세션서 미완) — A안으로 재실행 권장 | hpe-codex-validator | Med |

## search-before-mint 근거

- 신규 comp 0·proc 0·clr 0(CLR_000002/5 재사용·실재)·siz/POPT 0. **신규 코드 mint 0**.
- 신규 = 흑백 단가행 212(데이터)·칼라 clr_cd UPDATE 212·use_dims UPDATE 1·도수 옵션그룹(상품별).

## 안전 [HARD]

DB 미적재 — dosu-load-draft.sql은 BEGIN…ROLLBACK(COMMIT 금지). 실 적용은 인간 승인 후 dbmap(dbm-load-execution). pricing.py 변경은 우리가 적용 안 함(명세만→개발팀 C트랙). 단가 verbatim(날조 0)·라이브 읽기전용.
