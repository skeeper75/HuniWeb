# 세션 여정 트래킹 — 위젯 설계 → 가격 연결 진단 → 판형(판걸이수) (2026-07-01)

> 이 문서는 "왜 판형 작업까지 왔는가"의 **전체 맥락 사슬**과 **다음 세션 이어가기**를 담는다.
> 비전문가도 읽을 수 있게 정리. 세부 산출물은 각 단계의 문서/메모리를 참조.

---

## 0. 한 줄

**"고객이 상품을 골라 주문할 수 있는 위젯"을 설계하려다 → 위젯이 쓸 가격이 제대로 계산되는지 점검하는 과정에서 → 가격이 빠지는(silent-0) 진짜 원인을 찾는 진단기를 만들었고 → 그중 "썬캡"의 원인이 "판형(큰 종이에 몇 개 앉나=판걸이수)" 계산 문제로 귀결됐다.** 지금은 그 판형 작업을 이어갈 지점.

---

## 1. 여정 단계별 트래킹 (시작 → 지금)

| # | 무엇을 하려 했나 | 무엇을 했나 / 알게 됐나 | 결과물 |
|---|---|---|---|
| 1 | **위젯 설계 요청** (`/harness:harness`) — 레드프린팅 역공학 + 라이브DB + webadmin으로 후니 위젯 설계, 모든 구성요소·옵션·가격·제약·DB엔티티 고려 | §6 Huni-Widget 하네스가 이미 있음 → **새로 안 만들고 확장** | §6 컨버전 트랙(③')·`hw-db-cartographer`·`huni-widget-db-cartography` 스킬 |
| 2 | **DB 스키마 기반 위젯 엔티티 설계** (`table-spec_260619.html` 사용·추가 스키마 오늘날짜) | 라이브 DB→정규화 계약 매핑 + 추가 스키마 5컬럼(2026-07-01) + 디지털인쇄 파일럿 | `03_spec/db-cartography/`·`added-schema-260701.{sql,md}`·`table-spec_260701.html` |
| 3 | **11개 상품군 위젯 폼** (`docs/design/11가지상품옵션/`) 분석·주문가능화 접근 | Figma 폼 = 외형만 완성(옵션 하드코딩·가격 가짜·제약 JSX). 5 복잡도 클래스로 분류·종단 명세 | `widget-forms/`(클래스별 spec + SYNTHESIS) |
| 4 | **전 11 상품군 동형 전파** | 3-tier: 즉시 주문가능 4 / PARTIAL(CPQ 미적재) 5 / **BLOCKED(가격공식 없음) 2 = calendar·design-calendar**. ★(B)위젯계약변경=0·병목=(C)DB | `widget-forms/SYNTHESIS.md §5-bis` |
| 5 | **TIER-0 calendar 가격공식 설계**(§18) | PRF_CAL_* 5공식 설계·조건부 GO·★base proc(PROC_000004) 미바인딩 발견 | §18 `03_design/*calendar*`·[[calendar-price-formula-design-260701]] |
| 6 | **캘린더가공 가격이 구성요소에 적용됐나 확인** | 우드거치대/타공 미적재·트윈링제본 proc 매핑 오류 발견 → "가격 연결이 제대로 됐나"의 일반 질문으로 확장 | §26 `calendar-finishing-price-verification-260701.md` |
| 7 | **"상품→공식→구성요소" 연결 전수 진단법** | 정적 스캐너 `contribution_scan.py`(§27 F층) → silent-0 후보 적발 | `_foundation/batch/contribution_scan.py`·`CONNECTION-DIAGNOSIS-DESIGN-260701.md` |
| 8 | **교정 시도 → 실패 → 재규명**(§14) | CLASS-1 재키 COMMIT→simulate 실패→UNDO. §14: proc 부모/자식·detail·위젯 해소 때문에 **정적 스캔이 과적발**임을 규명 | [[contribution-scan-silent-zero-260701]]·§14 `finishing-proc-pricing-path-260701.md` |
| 9 | **올바른 진단기 = 뷰어 재현 simulate** | `contribution_sim_scan.py`(F층 v2)로 전 상품 재진단 → **진짜 silent-0 = 5상품**(인쇄/용지 미발현) | `contribution_sim_scan.py`·[[silent-zero-final-simscan-260701]] |
| 10 | **진짜 5상품 교정** | 책자 표지 3개(288/290/292) base proc 추가 **라이브 COMMIT**(검증 통과). 051·020 보류 | `wiring/bookcover-baseproc-*.sql` |
| 11 | **051 썬캡 판형 진단**(§26·현재) | 썬캡 견적불가 = **판걸이수(큰 종이에 1개=판수1)를 기하계산이 0으로 냄**. 권위=판걸이수 시트(330×540·판수1). **어떤 기하함수도 재현 불가→lookup 필수**=개발팀 | DEV 보고서 §8·§8.1 |

→ **11번(판형)이 지금 이어갈 지점.**

---

## 2. 판형(판걸이수) 작업 — 다음 시작점 (여기서 이어가기)

### 지금까지 확정된 것
- **문제**: 디지털인쇄 가격 = (주문수량 ÷ 큰 종이 1장에 앉는 개수[판걸이수]) × 단가. 이 "판걸이수"를 엔진 함수 `fn_calc_pansu`가 **순수 기하(면적÷면적)**로 계산해 실무값과 어긋남(±7~80%). 썬캡은 아예 0(견적불가).
- **권위 = 판걸이수 시트** (`_workspace/huni-dbmap/06_extract/pangeori-l1.csv`, 125 판걸이수 행). 예: 썬캡 = 작업 320×404 · 판형(3절) 330×540 · **판걸이수 1** · 여백 좌우6/상13/하16.
- **★결정적 증거**(이번 세션): 권위값(330×540·320×404)으로 기하 계산해도 **0**(아이템 320 > 인쇄영역 318, 2mm 초과). 실무 판걸이수는 **1**. → **기하로는 절대 재현 불가, 실무진 판걸이수 표(lookup)만 정답.**
- **라이브 데이터 오류**: 썬캡 아이템=`SIZ_000195`(313×400) → 정답 `SIZ_000056`(320×404·실재) / 판형=국4절 오적재 → 정답 3절 330×540(미등록).

### 다음 액션 (순서)
1. **★권위 단일화 선결** — 판걸이수 시트(A·사이즈/자재무관) vs 상품마스터 판수 컬럼(B·상품/자재별)이 **충돌**(73×98 A18/B15·투명 A12/B8 등). 어느 게 production-truth인지 **예전사이트(goods.asp)·실무진**으로 tiebreaker 확정. (DEV 보고서 §3.) 썬캡은 충돌 없음(시트 단독).
2. **`t_siz_pansu` lookup 적재본 준비** — pangeori-l1.csv(125행) → 저장소 테이블 명세(키=사이즈/상품·값=판걸이수·판형·여백). 개발팀 전달용.
3. **`fn_calc_pansu` 수정 명세 확정** — lookup 우선 + 기하 폴백. 라이브 함수 교체는 개발팀 배포·인간 승인(DEV 보고서 §1~§7 + §8/§8.1).
4. **3절 라인 데이터 적재**(§7·dbmap) — 판형 330×540 전지 + 아이보리 3절 용지/인쇄 단가행 등록(현재 국4절뿐). 썬캡/와이드캘린더112/와이드리플렛049/지그재그엽서030 공통.
5. **썬캡 데이터 교정**(§26) — 아이템 `SIZ_000195`→`SIZ_000056` 정정 + 판형 3절 연결. (단, 이것만으론 여전히 0 → lookup 필수.)
6. 완료 후 **`contribution_sim_scan.py` 재진단**으로 썬캡 PRICE≠0 확인.

### 권위·도구 위치 (바로 열기)
- 판걸이수 권위: `_workspace/huni-dbmap/06_extract/pangeori-l1.csv`
- DEV 수정요청서: `_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md`(§8·§8.1)
- 판형 감사: `_workspace/huni-price-table-integrity/_batch/platesize-authority-audit-260701.md`
- 진단기: `_foundation/batch/contribution_sim_scan.py`(뷰어 재현·진짜 F층)·`contribution_scan.py`(정적·후보)
- §26 상세 핸드오프: `_workspace/huni-price-table-integrity/HANDOFF.md`

---

## 3. 이번 세션 다른 트랙의 미해결 (판형과 별개·나중에)

- **위젯 주문가능화**(§6): TIER-1 5상품군 CPQ 옵션 적재(goods·arrylic·print·sticker·stationery)·TIER-0 design-calendar. `widget-forms/SYNTHESIS.md`.
- **020 화이트인쇄엽서**: "디지털인쇄비 0"이 거짓결함인지(화이트인쇄=자재/용지4색 가격) 미확인. 화이트인쇄 트랙.
- **silent-0 REVIEW 후보**: contribution_sim_scan REVIEW 102건 대부분 선택형 옵션(정상). 신규 actionable 없음.

## 4. 건드리지 말 것 (확정·relitigate 금지)
- **책자 표지 3개(288/290/292) base proc COMMIT** — 검증 통과·되돌리지 말 것.
- **오시/미싱·박/라미·명함변형 = 거짓결함** — 위젯이 처리(부모/자식 proc·detail). 데이터 교정 불요.
- **§6 컨버전 트랙·hw-db-cartographer·db-cartography 산출** — 이번 세션 신설.
- **진단 원칙[HARD]**: 골든·F층 게이트는 **sim_meta 뷰어 selection 재현 simulate**로만(정적 proc-coverage는 후보 생성기·과적발).
