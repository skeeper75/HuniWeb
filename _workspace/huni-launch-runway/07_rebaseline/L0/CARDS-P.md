# P 카드 — 미판정 판정 · 답신·시나리오 보강 · L6 산출 (2026-09-02 · D-34)

> 선행 완료: O1·O2·O3 — lead 검산 `L0/LEAD-VERDICT-O.md`. 합침본 `L5/unified-ledger-assigned.csv`(504행 · 담당 채움 · `done_criteria` 비움).
> 세 카드는 **병렬**이다. L6 는 **생성기**를 만든다 — P1 이 원장을 갱신하면 lead 가 생성기를 다시 돌린다.

## ★ 지니 확인 사실 (09-02 15시 · 전 카드 전제)

- **PG**: 후니는 **이미 이니시스 기존 가맹점**(독립몰 운영 중). shopby 몰용 **상점ID(MID) 1개 추가 발급**만 남았다. 문서 근거(`L0/N1/payment-approval-flow.md` :17·:40·:257-262): MID 심사 **3~5영업일** **+ 원천사 심사 3~5영업일(직렬 · P1 정정)** · 계좌이체 최초 +3(판매상품 변경 시 카드 재심사 +7~10영업일) · 카카오페이 2주 · PAYCO/L.pay 10~12영업일 · 네이버페이 3~4주. → **「3~4주」는 간편결제에만 해당.** O2 의 G5 「불가」는 「승인 예정일 부재」 전제였으므로 **재판정 대상**(P1).
- **셀러어드민**: 계정 보호 상태 → **보류**. A 17건은 「미확인」 유지. 시나리오 기대값은 양분기 유지.
- **범위 축소**: 지니 미결정. A(간편결제 후순위)는 문서상 자연스러운 순서이고, B(생산 수동)·C(이관 연기)는 **PM 결정 대기**로 표기.

## 전 카드 공통 [HARD]

- **초안을 존중하지 마라.** 근거가 다르면 뒤집고 근거를 남겨라.
- 1차 참조 순서: 매뉴얼 2종 → SDK 가이드 → 실화면 → 코드. 라이브 **읽기전용**. 셀러어드민 **접속 금지**(보류 중).
- 등급 기본 「작업 항목」 · 「차단」은 외부 의존만. 0행=미실행. 모르면 「미확인」. 시간 추정 금지.
- 쉬운 말(코드명은 괄호 보조). 자기 `L5/<P?>/` 또는 `L6/` 안에만 쓴다. 커밋·푸시·`git add -A` 금지. `progress.md` 완료조건 대조표 후 멈춘다.

---

## P1 — 미판정 143행 판정 + `done_criteria` 504행 + 차단 등급 열 + 가능성 재판정 (`run-huniweb`)

**재료**: `L5/unified-ledger-assigned.csv` · `L5/O2/done-criteria-templates.md` · `L5/O2/feasibility-verdict.md` · `L5/O2/critical-path.md` · `L2/as-is-inventory.csv` · `L0/M3/production-feature-canon.csv`+`auto-vs-human.md`+`process-route.md` · `raw/webadmin/docs/order-to-mes-process.md` · `L0/N3/ARCHITECTURE-v2.md` §10 · price-setup `STATUS-260902.md` · `L0/N1/payment-approval-flow.md`

**할 일**
1. **미판정 143행 상태 판정** — 4분류(done/partial/todo/new). `done` 은 **L2 file:line 또는 코드 실측 file:line 필수**(웹어드민 코드 grep 허용 — 단 「코드 경로 존재」= done, 「운영 성공」 아님을 비고에). 판정 못 하면 「미판정+사유」로 남긴다(추정 금지). 생산·공정 127행은 `auto-vs-human.md` 의 사람 경로면 **10/6 범위에서 「수동 대체」 표기**.
2. **`done_criteria` 504행 전건** — O2 템플릿(상태별 뼈대 5종 × 대분류 확인처)으로 채우되, 돈·주문 플래그 행은 강화 규칙 적용. 「검토한다/정리한다」 0.
3. **오픈차단 등급 열 신설**(`오픈차단여부`: 차단(외부)/작업 항목/오픈 무관/미판정) — O2 §5-1 지적대로 원장 행에는 이 축이 없었다. 외부 의존이 걸린 행(구DB 이관 `STD-MEM-020`·`STD-MYP-009`, PG, NHN, EDICUS, 배송사)만 「차단」 후보. `STD-SYS-009` 는 done 유지 + 비고 「구현 완료·**미검증** — 검증은 STD-PAY-013/STD-FIN-008/X-NHN-REVIEW-01」(lead 결정).
4. **가능성 재판정** — 위 ★ PG 사실 전제(MID 추가 3~5영업일)로 `feasibility-verdict.md` 를 **v2** 로 새로 쓴다(초안 보존). 기본 결제수단(카드·계좌이체·가상계좌)이 G4(9/30) 전 승인되려면 실무진 MID 신청이 **늦어도 언제**여야 하는지 영업일 역산(연휴 반영). 카드 재심사(+7~10영업일) 발생 조건을 「미확인」으로 표시. 축소 시나리오 B·C 는 PM 대기.
5. **부하 최종** — 담당×상태 재집계(미판정 0 목표 · 남으면 건수 명시).

**산출** `L5/P1/`: `unified-ledger-v2.csv`+`.json`(504행 · 상태·done_criteria·오픈차단여부 채움) · `judged-143.md`(행별 근거) · `feasibility-verdict-v2.md` · `load-final.md` · `build_v2.py` · `progress.md`

**완료조건** ① 미판정 잔여 건수 명시(0 이 아니면 전건 사유) ② `done_criteria` 빈칸 0 · 금지어 0(기계) ③ done 전건 file:line ④ 오픈차단여부 빈칸 0 ⑤ 가능성 v2 에 MID 신청 마감일(영업일 역산) 명시 ⑥ **역방향**: O2 판정 중 뒤집은 것 목록

---

## P2 — NHN 답신 초안 + 문의서 통합 + 시나리오 보강 (`plan-huniweb`)

**재료**: `_workspace/huni-shopby/HANDOFF.md:12,14`(NHN 역질문 2건) · `L5/O3/close-pack/B-nhn-inquiry.md` · `L5/O3/xp-track.csv`(`X-NHN-REPLY-01`·`X-NHN-REVIEW-01`·`X-SETTLE-AUTH-01`·`X-SHOPBY-SPEC-FIX-01`·`X-SHOPBY-ORDERSHEET-01`) · `L5/O1/scenario-matrix.csv`+`test-scenarios.md` · `L5/O2/gates.md` · `L0/N1/shopby-order-state-machine.md`

**할 일**
1. **NHN 답신 초안** — 역질문 2건에 대한 후니 답(사실만·미확인은 미확인). 지니가 그대로 보낼 수 있는 문장. 답신에 **B 문의서 12건 + 명세 오기 5건 + 주문서 실계약 미명문화**를 한 통으로 묶은 「통합 문의서 v2」.
2. **시나리오 보강** — 송장 변경 3칸(배송중·배송완료·구매확정) P1 추가 · G4 몰림 23건을 **9/30~10/02 구간**으로 재배치(날짜별) · PG 사실 갱신(기본 수단 승인 시 실행 가능 시나리오 재표시).
3. **셀러어드민 대체 근거** — 접속 보류이므로 A 17건 각각에 「문서로 대신 닫히는가」 표시(닫히면 근거, 아니면 「접속 필수」).

**산출** `L5/P2/`: `nhn-reply-draft.md` · `nhn-inquiry-v2.md` · `scenario-matrix-v2.csv` · `test-scenarios-v2.md` · `selleradmin-doc-fallback.md` · `progress.md`

**완료조건** ① 답신이 역질문 2건 전부에 답함(미확인 명시) ② 통합 문의서에 O3 B 12건+2건 누락 0 ③ 시나리오 v2 P0 13단계 유지 · 송장 3건 추가 · G4 구간 날짜 빈칸 0 ④ A 17건 전건 「문서 대체/접속 필수」 표시 ⑤ **역방향**: O1 v1 대비 삭제한 시나리오 목록(0이면 명시)

---

## L6 — 엑셀 5시트 생성기 + 인터랙티브 아티팩트 생성기 + LEDGER.md (`sync-huniweb`)

**재료**: `L5/unified-ledger-assigned.csv`(현재 원장 · P1 이 v2 로 갱신 예정 — **생성기는 파일 경로만 바꾸면 되게**) · `docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx`(양식 SOT · 5시트 `00_읽는법/01_역할정의/02_IA마스터(11열)/03_페이즈일정/04_진행현황`) · `L5/O2/gates.md`·`dep-graph.json` · `L5/O1/scenario-matrix.csv` · `L5/O3/xp-track.csv`·`close-pack/` · `STRATEGY-D34.md` · 후니 디자인시스템 스킬 `huni-design-system` · 메모리 규칙: 아티팩트=글 아닌 도식·표 · mermaid `<pre>` 안 `<br/>` 이스케이프

**할 일**
1. **`L6/build_xlsx.py`** — 원장 CSV → 260616 양식 5시트 xlsx(`docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx`). `02_IA마스터` 11열에 원장 열 매핑표를 문서화 · 신규발견(`new`)은 `비고` · `03_페이즈일정` 은 G0~G5 · `04_진행현황` 은 담당×상태 집계. 원본 260616 은 수정하지 않는다.
2. **`L6/build_artifact.py`** — 원장·게이트·시나리오·X·P·의존 JSON 을 **단일 HTML**(`L6/runway-dashboard.html`)로. 후니 DS 토큰 · 라이트/다크(`prefers-color-scheme` + 토글) · 담당 필터(PM/인쇄/쇼핑) · 게이트 탭(G0~G5) · 상태 필터 · localStorage 체크박스(**키 = `legacy_id` 있으면 그것, 없으면 `std_id`**) · mermaid 의존 다이어그램(임계경로) · 시나리오 뷰(P0/P1/P2) · X·P 트랙 탭 · 닫기팩 링크. 외부 CDN 은 cdnjs/jsdelivr 만. 3문장 이상 문단 금지(도식·표).
3. **`LEDGER.md`** — 원장 요약(담당×상태 표 · 차단 · 게이트 · 읽는 법) + JSON 경로.
4. 생성기를 **현재 원장으로 1회 실행**해 산출 3종을 만든다. P1 갱신본이 오면 lead 가 재실행한다 — README 에 재실행 명령 1줄.

**산출** `L6/`: `build_xlsx.py` · `build_artifact.py` · `runway-dashboard.html` · `README.md` · `07_rebaseline/LEDGER.md` · `docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx` · `progress.md`

**완료조건** ① xlsx 5시트 전부 존재·시트명·열 구조 260616 과 일치(openpyxl 기계 대조) ② 아티팩트 항목 수 = 원장 행 수(504) ③ 라이트/다크 양쪽 렌더 캡처 2장 ④ 체크박스 새로고침 후 유지(캡처) ⑤ mermaid `<br/>` 이스케이프 검증 통과 ⑥ 원장에 없는 항목 창작 0(기계) ⑦ 재실행 명령 1줄로 재생성 확인

---

## 다음 (P 종료 후)
lead: P1 v2 원장으로 L6 생성기 재실행 → 아티팩트 발행 → 지니 보고(가능성 v2 · MID 신청 마감일 · PM 결정 대기 목록). 그 뒤는 **게이트 운영 모드**(주 1회 원장 갱신 + 게이트 이탈 조건 체크).

---

## Q0 — `huni_token` 라벨 등록 여부 API 읽기 확인 (`plan-huniweb` · 지니 승인 09-02 15:5x)

**질문**: 샵바이 상품에 텍스트 옵션 라벨 `huni_token`(현행 담기 구현이 쓰는 이름)이 등록돼 있는가. 없으면 장바구니 담기가 **조용히 실패**한다(N3 U-2).
**재료**: `.env.local` 의 `SHOPBY_*`(server API 키 — 값을 어떤 파일에도 적지 않는다) · `docs/shopby/shopby-api/` OpenAPI(`GET /products/{productNo}/options` 또는 동등 shop-api) · `L0/M2/` 계약(`huni_item` vs `huni_token` 드리프트) · `huni-skin-shopby/src/lib/api/widget-order.ts`.
**할 일**: ① 읽기 전용 GET 만 — 쓰기·주문·담기 0. ② 게시 위젯 보유 상품에서 표본 ≥10(셋트 1 이상 포함) 조회 → 텍스트 옵션 라벨 목록 기록. ③ 「`huni_token` 있음 / `huni_item` 있음 / 둘 다 없음」 3분류 + 전 상품 전수 가능하면 전수(226). ④ 실패 모드(라벨 없을 때 담기가 어떻게 실패하는지)는 코드 근거로만(호출 금지).
**산출** `L5/Q0/`: `huni-token-label-check.md` · `label-check.csv` · `progress.md`
**완료조건** ① 표본 ≥10 · 셋트 포함 ② 3분류 빈칸 0 ③ 요청 메서드 전건 GET(로그) ④ 키 값 파일 내 0(grep) ⑤ 라벨 부재 시 영향 행(`STD-ORD-*`) 지목

---

## L6b — 생성기 보강: `오픈차단여부` 열 반영 (`sync-huniweb`)

**배경**: lead 가 `L5/P1/unified-ledger-v2.csv`(16열 · `오픈차단여부` 신설 · `done_criteria` 전건)로 두 생성기를 재실행함 — 완료 기준은 실렸으나 `오픈차단여부` 는 생성기에 매핑이 없어 xlsx `우선순위` 504행 미판정 · 대시보드에 차단 축 없음.
**할 일**: ① `build_xlsx.py` — `02_IA마스터` `우선순위` ← `오픈차단여부`(차단(외부)/작업 항목/오픈 무관/미판정 그대로 · 지어내지 않기) · `04_진행현황` 에 차단 등급 집계 1표 추가. ② `build_artifact.py` — 원장 항목에 `block` 키 추가 · 원장 탭 필터 「차단 등급」 + KPI 「차단(외부) N」 · 차단 8행 강조. ③ 두 생성기를 v2 원장으로 재실행 · 검산(항목 504 · 우선순위 빈칸 0 · 캡처 라이트/다크 2장 갱신). ④ `progress.md` 갱신(L6b 절).
**[HARD]** 원장 밖 창작 0 · 260616 원본 무수정 · 커밋 0 · `L6/` 와 xlsx 만 쓰기.
**완료조건** ① xlsx 우선순위 빈칸 0(=오픈차단여부 값) ② 대시보드 `block` 키 504행 ③ 재실행 exit 0 ④ 캡처 2장 ⑤ 기존 ①~⑦ 회귀 없음(기계)
