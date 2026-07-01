# CODEBUG — 셋트 경로 표지 코팅 저평가 (coat_side_cnt 드롭)

**트랙:** C트랙(엔진/뷰 코드 결함 — 개발팀 수정 대상)
**심각도:** 🟠 MEDIUM — 돈 크리티컬(표지 코팅비 누락·저청구), 단 PRICE≠0은 유지(견적 자체는 나옴)
**대상 상품:** 소프트커버 책자 셋트 표지에 코팅 있는 것 — 068 중철·069 무선·070 PUR (표지 COMP_COAT_MATTE 보유). 하드커버(072/077/082)는 COVERBIND 통합이라 무영향.
**상태:** 데이터로 해결 불가 → `price_views.py` 뷰 수정 필요. 본 문서 = 개발팀 전달 명세(코드 미수정·DB 미적재).

청중: 개발팀. 모든 주장은 `파일:라인` 인용 또는 라이브 simulate 재현 수치로 뒷받침.

---

## 1. 한 줄 요약

셋트 가격 시뮬레이터(`price_simulate_set`)가 구성원(member) selections를 조립할 때 **`siz_cd·mat_cd·print_opt_cd` 세 개만 복사하고 `coat_side_cnt`를 버린다.** 표지 코팅 단가행(COMP_COAT_MATTE)은 `coat_side_cnt`를 판별차원으로 쓰므로, 셋트 경로에서 코팅이 **미매칭 → 표지 코팅비(100부 기준 50,000원)가 통째로 누락**된다. 같은 표지를 **단품** simulate로 계산하면 코팅이 정상 포함된다.

## 2. 코드 인용

`raw/webadmin/webadmin/catalog/price_views.py:1930-1933` (`price_simulate_set` 내 member selections 조립):
```python
sel = {}
for k in ("siz_cd", "mat_cd", "print_opt_cd"):   # ← coat_side_cnt 등 공정 상세차원 누락
    v = mb.get(k)
    if v not in (None, ""):
        sel[k] = v
```
- 단품 경로(`simulate`, price_views.py 상단)는 클라이언트 selections를 그대로 넘겨 `coat_side_cnt`가 살아있음.
- 셋트 경로만 위 화이트리스트(3키)로 필터 → 코팅/기타 공정 상세차원 소실.

## 3. 라이브 재현 (읽기전용 simulate)

068 중철책자-표지(PRD_000288)·plt=SIZ_000499·mat=MAT_000073·PROC_000015(무광)·100부:
- **단품** `simulate`(coat_side_cnt=1 포함) = **88,688** (인쇄 35,000 + **코팅 50,000** + 용지 3,688)
- **셋트** `simulate-set` 동일 표지 = **38,688** (코팅 50,000 **드롭**)
- 코팅 단가행 라이브 실재: COMP_COAT_MATTE·plt499·coat_side_cnt=1·PROC_000015·tier100 unit=500 → 500×100판 = 50,000.

결과: 068 게이트 골든 158,688(코팅 포함 전제)이 **실제 셋트 엔드포인트에서는 108,688로 저평가**. 069/070 동형.

## 4. 권고 수정 (개발팀)

member selections 화이트리스트에 공정 상세차원을 포함:
```python
for k in ("siz_cd", "mat_cd", "print_opt_cd", "coat_side_cnt", "clr_cd"):
    ...
```
또는 member payload의 `procs[].detail`(coat_side_cnt 등)을 selections로 승격. 회귀 게이트: 068 표지 셋트경로 = 88,688(단품과 일치)·068 전체 = 158,688 복원.

## 5. 미확인 (실무진/개발 확인 필요)

- 실주문 위젯이 **이 셋트 뷰(`price_simulate_set`)를 경유**하는가, 아니면 별도 주문 경로인가. 경유하면 실주문 저청구 확정 → 우선순위 HIGH. 미경유(시뮬 전용)면 골든 검증만 저해.

## 6. 경계

DB 데이터 결함 아님(단가행 정상 실재). webadmin 코드 직접수정 금지([HARD]·§6) → 개발팀 트랙. 데이터 dryrun으로 해결 불가.
