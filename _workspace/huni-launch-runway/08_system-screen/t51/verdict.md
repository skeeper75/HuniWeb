# t51 verdict — 오픈일정 S4 통합 문서 (260919)

카드 t51 · 브랜치 `WT-launch-schedule-doc` · 입력 = t48(`11c8cab8`) + t49(`d03fd7d0`) + t50(`6a1ef73e`) 3-way 병합.
DB write 0 · 라이브 접속 0 · 날짜 추정 0 · 세 레인 워크트리 보존(삭제 0).

## 1. 통합 행수

| 항목 | 값 | 비고 |
|---|---|---|
| 원시 합 | 747 | t48 271 · t49 342 · t50 134 |
| 통합 원장 `merged.csv` | **747** | 레인 간 실제 중복 병합 **0쌍** (§3 참조) |
| scope=in(오픈 분모) | 683 | 작업량·일정 집계는 이것만 |
| scope=out(사내 선례) | 64 | t49 2 · t50 62 · t48 0 |
| 분모 안 남은 일(status≠완료) | 340 | 진행 64 · 미착수 231 · 미확인 45 |
| plan_row_id=NEW | 183 | t48 6 · t49 103 · t50 74 |
| 결정·관리 안건(원장 밖) | 63 | shopby 20 · huni-mall 31 · pagebuilder 3 · pitstop 7 · edicus 2 |

### scope 분포 (파생 = evidence 의 `[오픈분모밖] ` 접두 · 보충 1 개정)

| 카드 | in | out |
|---|---|---|
| t48 | 271 | 0 |
| t49 | 340 | 2 |
| t50 | 72 | 62 |

### work_type (분모 안 / 남은 일)

| work_type | in | 남은 일 |
|---|---|---|
| build | 329 | 60 |
| integrate | 219 | 154 |
| config | 99 | 93 |
| provided | 30 | 27 |
| manual | 6 | 6 |

남은 일의 최빈은 `integrate` 154행이고, 그중 **owner_side 미정 11건**은 담당·일정 산정 불가 구간이다(리드 F6 확인).

## 2. 시스템별 (분모 안 / 완료 / 남은 일 / 분모 밖)

| 시스템 | in | 완료 | 남은 일 | 미확인 | out |
|---|---|---|---|---|---|
| huni-mall | 177 | 31 | 146 | 2 | 0 |
| shopby | 94 | 9 | 85 | 22 | 0 |
| pagebuilder | 60 | 0 | 60 | 15 | 2 |
| pitstop | 23 | 0 | 23 | 0 | 0 |
| mes | 29 | 18 | 11 | 0 | 59 |
| edicus | 20 | 11 | 9 | 2 | 3 |
| widget | 133 | 128 | 5 | 3 | 0 |
| webadmin | 147 | 146 | 1 | 1 | 0 |

(분모 밖 64 = mes 59 · edicus 3 · pagebuilder 2. 카드별로는 t50 62 · t49 2.)

webadmin 의 남은 일이 1행뿐인 것은 「할 일이 없다」가 아니다 — webadmin 몫은 §4 미수록 83건 쪽에 있다.

## 3. 중복 병합 — 0쌍 (계약 보충 3 명확화의 키 설계 정정)

인계 메모는 「evidence 첫 `path:line` 을 키로 합치라」였고 그대로 구현했더니 **2쌍이 합쳐졌으나, 검증기 V5 가 오병합으로 적발**했다.
한 줄에 서로 다른 기능이 걸리기 때문이다.

| dup_key | 합쳐졌던 두 행 | 실제 관계 |
|---|---|---|
| `raw/webadmin/webadmin/config/urls.py:249` | t48:205 구매가능 검증(huni-mall→shopby) / t49:225 서버 권위 가격 계산(widget→webadmin) | 같은 라우트 줄, **다른 기능** |
| `raw/webadmin/webadmin/catalog/shopby_sync.py:118` | t48:35 상품 동기화(shopby) / t49:159 이미지 동기화(webadmin→shopby) | 같은 줄, **다른 기능** |

→ 병합 키를 **(`path:line` + 이음매 `{system, counterpart}` 무순 쌍)** 으로 강화했다. 그 결과 레인 간 실제 중복은 **0쌍**이고 747행이 그대로 보존된다.
같은 줄에 서로 다른 이음매가 걸린 자리는 3곳으로 `stats.json:same_path_different_edge` 에 남겼다(`urls.py:249` · `urls.py:281` · `shopby_sync.py:118`).

**리드 확인 요청**: 계약 보충 3의 t51 병합 키 문구를 위와 같이 정정할 것을 건의한다.

## 4. 미수록 83건 — 카드 사이로 빠진 행 (핵심 발견)

t48 `out-of-scope.csv` 89건의 라우팅 대상을 t49·t50 원장에 교차검산한 결과:

- 받는 원장에 **실재 6건** (STD-ADC-014→t49 · STD-FIN-007 · STD-SYS-031 · STD-MFG-110 · STD-MFG-111 · STD-MFG-116→t50)
- **미수록 83건** — 어느 화면 원장에도 없음

키워드 재확인(두 원장 동시): 공지 0 · 쿠폰 0 · 미수금 0 · 감사로그 0 건.

| 넘긴 곳 | 건수 |
|---|---|
| webadmin | 62 |
| mes | 16 |
| 기타(토스·외부·widget·webadmin·edicus) | 5 |

| 담당 | 건수 |
|---|---|
| 김동학 | 40 |
| 최숙진 | 14 |
| 서희항 | 13 |
| 미정 | 7 |
| 신우진 | 6 |
| 외부 3인 | 3 |

**지어내지 않았다** — 83건은 「없는 것으로 확인」이다. 다만 *정말 불필요한 일인지, 조사에서 빠진 일인지*는 t51 범위에서 판정하지 않았다.
판정에는 webadmin 을 다시 훑는 조사 1건이 필요하다(후속 카드 제안).

## 5. 일정 — 날짜 추정 0

원장 735행 중 작업량 하한이 적힌 것은 **28행(data_role=top 척추)뿐**이고 합은 **368.5일**이다.
이것은 달력 날짜가 아니라 작업량 하한이며 동시 진행분·대기 시간이 빠져 있다. 하한 `0` = 원장 미산정(일 없음 아님).

- 통합 원장 in 행 중 원장 연결 555 · NEW 128 · 원장에 없는 id **0종**
- 외부 의존(대기 행): EXT-MES 33 · EXT-PG 26 · EXT-PITSTOP 24 · EXT-NHN 12 · EXT-ALIMTALK 8 · EXT-EDICUS 3 · EXT-IDENTITY 3 · EXT-OLDDB 2 · 기타 3
- PitStop 은 「며칠」로 적지 않고 **결정 선행**으로 표기(STD-ART-034 → 035 → 033).

## 6. 승계 의무 — 문서에 실린 것 (검증기 V9 가 6/6 확인)

1. **status=완료의 뜻** = 코드·매뉴얼 원고에서 구현 실재 확인. 라이브 실화면·실주문 확인 **0건**. 「오픈 시나리오에서 동작한다」로 읽히지 않게 범례·서두 양쪽에 명시.
2. MES 메뉴는 런타임 DB `MenuInfo` 조회 → 라이브 등록 미확인 · 화면 한글명은 `designer.cs` 캡션 추론값.
3. t50 분모 판정 62행은 레인 제안 · `[힌트대비 판정근거]` 7건 비은폐.
4. `unmeasured-candidates.csv` 는 후보이지 확정 결함 아님 · 확정 정정은 STD-MFG-060·061 2건.
5. `pitstop-clues-CRT.md` 는 타 고객(열림PnP) 코드 · 후니 status 근거로 쓰지 않음 · 표본 7건 중 1건 줄번호 5줄 어긋남.
6. NEW 183행은 단위가 잘다는 뜻 · 735행 억지 매핑 없음 · 일정은 735행 선행·하한 사용.

리드 F1~F8 은 문서 §6-1 에 확인 경로(리드 직접 / 레인 보고)와 함께 그대로 실었다.
지니 결정 필요 5건은 §8 에 실었다.

## 7. 산출물

| 파일 | 내용 |
|---|---|
| `reports/launch-schedule-20260919.html` | 통합 문서(310KB) — 프로세스 구조도(mermaid+noscript) · 시스템별 현황(인라인 SVG) · 구현/연동 분리 뷰 · **그룹→화면 드릴다운**(필터·검색) · 일정표 · 관리 요소 · 미수록 · 한계 |
| `reports/launch-schedule-20260919.md` | 린 마크다운 트윈(17KB · 에이전트 컨텍스트용) |
| `reports/launch-screens-20260919.xlsx` | 8시트 — 읽는법 / 원장 747행 / 시스템요약 / 구분요약 / 일정 28행 / 외부의존 / 미수록 83행 / 결정안건 |
| `merged.csv` | 통합 원장 747행(+scope·card·dup_key·merged_from 파생열) |
| `stats.json` · `schedule.json` · `merge-log.json` · `verify-result.json` | 집계·일정·병합로그·게이트 결과 |
| `assemble.py` · `schedule.py` · `render.py` · `build_xlsx.py` · `verify.py` | 결정론 파이프라인 |

문서의 모든 수치는 스크립트 계산값이다. LLM 숫자 전사 0.

### 계약 이탈 1건 (고지)

`moai-domain-html-report` 의 basic 티어 크기 예산은 120KB 인데 산출은 **310KB** 다.
초과분은 전부 드릴다운용 747행 원장 데이터이며(근거 문자열은 150자로 절단해 18KB 절감), 예산을 맞추려면 드릴다운을 버려야 해 **문서 요구(그룹→화면 드릴다운)를 우선**했다.
외부 JS 라이브러리 0 · 인라인 바닐라 JS + mermaid CDN(basic 티어 허용 · `<noscript>` 폴백 동반) · 디자인 토큰 8종 준수.

## 8. 검증기 — 실행 명령과 출력

```
$ cd _workspace/huni-launch-runway/08_system-screen/t51
$ python3 assemble.py && python3 schedule.py && python3 render.py && python3 build_xlsx.py
$ python3 verify.py; echo "EXIT=$?"
```

```
[PASS] V1 행 보존 — 원천 747 = 통합 747 + 병합흡수 0 (stats.raw_total=747)
[PASS] V2 허용값·근거 필수 — 위반 0
[PASS] V3 scope 파생 — 접두 보유 원천 64행 · 통합 out 64행 · 파생 불일치 0
[PASS] V4 integrate 필수열 — counterpart 누락 0 · direction 누락 0 · owner_side 미정 11건(결함 아님 · 미결로 보고)
[PASS] V4b owner_side 미정 집계 일치 — 양쪽 11건
[PASS] V5 병합 무손실(양쪽 드릴다운 보존) — 유령 uid 0 · 상대 시스템 소실 0
[PASS] V6 일정 = 원장 복사(추정 0) — 척추 28행 · 원장과 어긋난 값 0
[PASS] V7 미수록 독립 재판정 — 라우팅 89 · 검증기 미수록 83 · 보고 83
[PASS] V8 산출물·핵심 수치 실재 — 누락 파일 없음 · 문서에 없는 수치 없음 · HTML 317,761B
[PASS] V9 승계 의무 주석 — 실린 주석 6/6
[PASS] V10 verdict 표 = 계산값 — 일치

게이트 11종 · PASS 11 · FAIL 0
EXIT=0
```

검증기는 조립기 결과를 믿지 않는다 — 세 레인 `screens.csv` 와 9/17 원장을 다시 읽어 스스로 센 뒤 산출물과 대조한다.
게이트가 실제로 두 건을 잡았다:

- **V5** — 조립기의 오병합 2건 적발(§3). 병합 키를 고치고 재실행해 PASS.
- **V10** — 이 verdict 의 손으로 쓴 표에 수정 전 실행값이 섞인 것을 적발(work_type 2행 · 시스템 8행 전부).
  계산값으로 바로잡고, 이후 같은 전사 오류가 재발하지 않도록 **verdict 표를 계산값과 문자열 대조하는 게이트를 추가**했다.

부가 검사: 임베드 JSON 파싱 OK(747행·16열) · 인라인 JS 파싱 OK(node) · 태그 균형 div 47/47 · table 10/10.

## 9. 판정

**GO** — 게이트 10/10 PASS. 카드 t51 요구 5개 절(프로세스 구조도 · 그룹→화면 드릴다운 · 구현/연동 분리 뷰 · 일정표 · 관리 요소) 모두 산출.

### 리드 회신이 필요한 것

1. 계약 보충 3의 t51 병합 키 문구 정정(§3) — `path:line` 단독 → `path:line` + 이음매.
2. 미수록 83건의 처리(§4) — webadmin 재조사 카드를 열 것인가, 아니면 불필요로 판정할 것인가.
3. HTML 크기 예산 이탈(§7) 승인 여부.
