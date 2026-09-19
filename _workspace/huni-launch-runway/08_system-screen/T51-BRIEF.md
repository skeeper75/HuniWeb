# t51 인계 메모 — 리드(lane-1)가 S1~S3 판정에서 넘기는 것 (260919)

카드 본문(`moai todo` t51)과 `CONTRACT.md`(보충 1 개정·2·3 명확화·4 포함)가 정본이다. 이 메모는 거기 없는 **리드 판정 결과와 승계 의무**만 적는다.

## 1. 입력 — 세 브랜치(전부 미푸시 · 워크트리가 유일본)

| 카드 | 브랜치 | 커밋 | 행 | 검산기 | 부속 |
|---|---|---|---|---|---|
| t48 | `WT-shopby-mall-screens` | `11c8cab8` | 271 (shopby 94 · huni-mall 177) | `t48/verify_screens.py` exit 0 | `shopby-decisions.md` 20 · `huni-mall-decisions.md` 31 · `out-of-scope.csv` 89 |
| t49 | `WT-admin-widget-screens` | `d03fd7d0` | 342 (webadmin 147 · widget 133 · pagebuilder 62) | `t49/_assemble.py` errors=0 | `pagebuilder-decisions.md` 3 |
| t50 | `WT-mes-edicus-screens` | `6a1ef73e` | 134 (mes 88 · edicus 23 · pitstop 23) | `t50/merge_screens.py` 위반 0 | `pitstop-decisions.md` 7 · `edicus-decisions.md` 2 · `unmeasured-candidates.csv` 5 |

합계 747행. 세 카드 모두 리드가 행수·분포·필수열·검산기 재실행을 직접 확인해 PASS 했다. t51 워크트리는 origin/main 에서 새로 만들고 세 브랜치를 그 안에서 병합한다(로컬 main 은 origin 보다 30커밋 뒤 — 쓰지 말 것). 메인 체크아웃의 미트래킹 파일 `CONTRACT.md`·`pitstop-clues-CRT.md`·`T51-BRIEF.md` 는 절대경로로 읽어 t51 커밋에 함께 담는다.

## 2. 통합 시 반드시 할 검산

1. `scope` 열 파생: evidence 가 `[오픈분모밖] ` 로 시작하면 out(t48 0 · t49 2 · t50 62 = 64행). **작업량·일정 집계는 in 만.** out 행은 「사내 선례」 뷰로 따로 보인다.
2. 레인 간 integrate 중복 병합: evidence 첫 `path:line` 을 키로 합치고, 합친 행은 `system`·`counterpart` **양쪽 드릴다운에 모두** 보인다. counterpart 표기는 계약 용어(`huni-mall` 등)로 통일됐는지 확인.
3. t48 `out-of-scope.csv` 89행(webadmin 64 · mes 19 · 그 외 6)의 라우팅 대상이 실제로 t49·t50 원장에 있는지 교차 검산 — 카드 사이로 빠진 행을 찾는다. 빠진 건은 지어내지 말고 「미수록」 목록으로 보고.
4. 결정·관리 안건 63건(`*-decisions.md`)은 원장 행이 아니다 → 「관리 요소(RACI·리스크·의존)」 절의 입력. 순서 의존 표시(edicus: STD-MYP-031 → STD-OPT-053)를 보존.
5. NEW 행(t48 6 · t49 103 · t50 74)은 9/17 원장보다 이 원장의 단위가 잘다는 뜻이다. 735행에 억지 매핑하지 말고 NEW 그대로 두되, 일정표는 735행 쪽 선행·하한을 쓴다.

## 3. 문서에 그대로 실어야 할 주석(승계 의무)

- **status=완료 의 뜻**: 세 카드 모두 「코드(및 매뉴얼 원고)에서 구현 실재 확인」이다. 라이브 실화면·실주문 확인은 0 이다. 「오픈 시나리오에서 동작한다」로 읽히지 않게 범례에 적는다.
- t50: MES 메뉴는 런타임에 DB `MenuInfo` 에서 읽어 라이브 등록 여부 미확인 · 화면 한글명은 designer.cs 캡션 추론값.
- t50 분모 판정 62행은 레인 제안이다. `[힌트대비 판정근거]` 7건을 숨기지 말고 노출한다.
- `unmeasured-candidates.csv` 는 문구 일치로 뽑은 **후보**이지 확정 결함이 아니다. 확정 정정은 STD-MFG-060·061 두 건.
- `pitstop-clues-CRT.md` 는 타 고객(열림PnP) 코드다. 후니 status 근거로 쓰지 않는다. 줄번호는 리드 표본 7건 중 1건이 5줄 어긋났다.

## 4. 문서의 핵심 발견(리드가 근거를 직접 확인한 것 / 레인 보고)

| # | 발견 | 확인 |
|---|---|---|
| F1 | **샵바이↔MES 구현 0** — MES 저장소 `shopby` grep 0건 · 스펙 yaml paths 11개뿐. MES `docs/design/README.md` 가 구현된 것처럼 읽힘 | 리드 직접 |
| F2 | **webadmin→샵바이 쓰기 연동 거의 없음** — 실재 3건(상품동기화·웹훅 수신·클레임 저장). 주문·송장·회원·적립금 전용 호출 함수 없음(`shopby_client.py:137` 범용 request 만) | 리드 직접 |
| F3 | **PitStop 23행 전부 미착수 · 작업량 추정 불가** — 결정 사슬: 연동방식(STD-ART-034) → 범위 산정(STD-ART-035) → 일정 상정(STD-ART-033). 결정 주체 다수 미정/대표 | 행수 리드 직접 · 사슬 레인 보고 |
| F4 | **PitStop→MES 인계는 사내·타사 선례 모두 없음**(완전 신규). 샵바이→MES 는 카페24·우커머스·성원 선례 있음 → 두 이음매 위험도가 다르다 | 타사분 리드 직접 · 사내분 레인 보고 |
| F5 | **pagebuilder 62행 중 완료 0** · 설계 폴더 02~05 파일 0 · 파트너사 코드 변경 필요 9건(편집기 HTTP 500 등) | 완료 0·폴더 0 리드 직접 · 9건 레인 보고 |
| F6 | 분모 안 integrate 의 **owner_side=미정 11건**(t50) — 담당·일정 산정 불가 구간 | 리드 직접 |
| F7 | 웹훅 메아리 필터(STD-MFG-030) 미구현 — 저장만 하고 자기 변경 여부를 가리지 않음 | 리드 직접(`shopby_hook.py:112-121`) |
| F8 | 9/17 원장이 MES 코드를 읽지 않아 「MES 소스 없음」이 후속 조사에 계속 상속됨 · 가이드북 실체는 pagebuilder 가 아니라 webadmin | 레인 보고 |

일정표 규칙: 날짜 추정 금지. 선행·순서·원장 하한만. F3 은 「며칠」을 쓰지 않고 「결정 선행 필요」로 적는다.

## 5. 「지니 결정 필요」 절에 넣을 것

1. 위젯빌더 운영 도구 NEW 71행을 런웨이에 올릴 것인가(build+완료라 남은 일 집계에는 안 잡힘).
2. webadmin 고객 마스터 `t_cus_customers` 가 신규몰에서 실제로 쓰이는가 — 실무진 확인 1건.
3. PitStop 결정 사슬 7건의 결정 주체·순서.
4. 미확인 행 해소용 화면 캡처 허용 여부(t48 셀러어드민 24 · t49 pagebuilder 편집기 17 · t50 MES 메뉴).
5. `pc-req-f3-link-1n` — C7 결론이 ⓐ면 안건만 남으므로 decisions 로 이동.

## 6. 산출·완료 신호

HTML + xlsx · `moai-domain-html-report` 경유 · 검증기 포함 · 구성은 카드 본문대로(프로세스 구조도 · 그룹→화면 드릴다운 · 구현/연동 분리 뷰 · 일정표 · 관리 요소). 한국어 문어체, 번역투 금지(`moai-domain-humanize` 최종 패스).
완료 신호 = `t51/verdict.md`(통합 행수 · scope 분포 · 중복 병합 수 · 미수록 수 · 검증기 명령과 출력). DB write 0 · 라이브 접속 0.
