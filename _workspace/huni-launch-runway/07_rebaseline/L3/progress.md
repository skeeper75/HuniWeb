# L3 — 기존 자산 수확·정규화 · progress

> 카드 t30 (L3) · 2026-09-02 · sync-huniweb 세션 · primary checkout (워크트리 미사용)
> 상태: **완료** · 커밋/푸시 없음 · L3/ 밖 쓰기 0

## 산출물

| 파일 | 크기 | 내용 |
|---|---|---|
| `L3/legacy-normalized.json` | 1,378,241 B | 716건 단일 스키마 (`legacy_id, 원천, 원본ID, 기능서술, 원판정, 원판정상세, 근거, 돈여부, 주문여부, 의존, raw`) |
| `L3/id-preservation-map.csv` | 82,385 B | 716행 (`legacy_id, 원천, 원본ID, id_unchanged, 기능서술`) |
| `L3/normalize.py` | 5,928 B | 결정론 정규화기 (재실행 가능) |
| `L3/verify.py` | 4,278 B | 완료조건 기계 검증기 (실패 시 exit 1) |

## 스키마 결정 (판정·병합 없음)

- `legacy_id` — **runway 는 원본 ID 그대로**(`F-003`·`P-###`·`X-###`). scope 는 `SCOPE-###`, ia 는 `IA-###`.
  runway 가 쓰는 `F/P/X-` 접두사와 신규 접두사가 겹치지 않아 재발급 0으로 유일성이 성립한다(검증 ③-4).
- `원판정` — 원천 값을 **문자 그대로** 이관. runway=`status_now`, scope=fit-gap `판정`, ia=`진행상태`.
  재판정·정규화·표준화 일절 없음(검증 ④).
- `돈여부`/`주문여부` — runway 는 `money_critical`/`order_critical` 그대로. **scope·ia 는 원천에 플래그가 없어 `null`**
  (`false` 로 채우면 "돈 안 걸림" 이라는 판정이 되므로 금지 조항 위반. 채우는 것은 L4의 일).
- `의존` — runway 는 `blocked_by`+`external_dep`+`precondition`, scope·ia 는 `선행조건` 텍스트.
- `raw` — 원본 레코드 전체를 필드 단위로 그대로 보존. 여기서 유실 0이 성립한다.
- scope 는 `ia-feature-canon.csv` 와 `fit-gap-matrix.csv` 를 `no` 로 1:1 조인(두 파일 `no` 집합 동일 — 스크립트에서 assert).
  두 파일을 합친 것은 **한 기능의 두 면(기획/판정)** 이지 두 항목의 병합이 아니다.

## 완료조건 충족 근거 (기계 검증)

재현: `python3 _workspace/huni-launch-runway/07_rebaseline/L3/verify.py` → exit 0

```
PASS ①-1 총건수 716 실제 716
PASS ①-2 원천별 410/162/144 410/162/144
PASS ①-3 원본 레코드 필드 유실 0 유실 0건 []
PASS ②-1 원본ID 유일 716/716
PASS ②-2 legacy_id 유일
PASS ②-3 보존맵 행수 일치 716
PASS ②-4 보존맵 ↔ json 왕복 일치
PASS ②-5 빈 legacy_id/원본ID 0
PASS ③-1 runway ID 집합 동일 누락 [] 신규 []
PASS ③-2 runway ID 순서까지 동일
PASS ③-3 runway legacy_id == 원본ID (재발급 0)
PASS ③-4 runway ID 와 신규 prefix 충돌 0
PASS ④ 원판정 무변경(재판정 0) []
PASS ④-2 병합 0 (1행=1원본)
PASS ⑤ runway 돈/주문 플래그 보존 돈 205 주문 129

RESULT: ALL PASS
```

### ① 716건 전량 수용 · 유실 0 — 수치 근거

| 원천 | 원본 건수 | 정규화 건수 | 필드 유실 |
|---|---|---|---|
| runway `01_scope/ledger.json` | 410 | 410 | 0 |
| scope `ia-feature-canon.csv` × `fit-gap-matrix.csv` (no 조인) | 162 | 162 | 0 |
| ia `260616 xlsx` `02_IA마스터` | 144 | 144 | 0 |
| **합계** | **716** | **716** | **0** |

"유실 0" 은 건수 일치만이 아니라 **필드 단위 항등**으로 측정했다 — `raw` 를 원본 레코드와
파이썬 객체 비교(`==`)해 716건 전부 일치(검증 ①-3). 원본 dict 키 하나라도 빠지면 FAIL 이 된다.
runway 205건 돈·129건 주문 플래그도 원본과 항등(검증 ⑤) — 원장 §1 실측치와 일치.

### ② 원본ID → legacy_id 역추적 100%

`원본ID` 716개 전부 유일, `legacy_id` 716개 전부 유일, 빈 값 0.
`id-preservation-map.csv` 716행이 json 의 (원본ID, legacy_id) 쌍 집합과 **왕복 일치**(검증 ②-4).
따라서 어느 방향으로도 1:1 역추적이 성립한다.

### ③ 대시보드 체크상태가 물린 runway 항목 ID 무변경

- runway 410 ID 가 원본과 **집합·순서 모두 동일**(③-1·③-2), `legacy_id == 원본ID`(③-3) — 재발급 0건.
- scope/ia 에 새로 부여한 `SCOPE-###`·`IA-###` 는 runway ID 집합과 교집합 0(③-4) — 덮어쓸 여지 없음.

## 미검증 (Gap) — 정직 고지

- **대시보드 파일 자체는 확인하지 못했다.** `_workspace/huni-launch-runway/06_dashboard/` 는 **빈 디렉터리**이고
  (`ls -la` 로 확인), 저장소 안에서 `localStorage` 를 쓰는 대시보드 HTML 은 찾지 못했다.
  즉 "localStorage 키가 정확히 이 ID 문자열이다" 는 **직접 관측하지 못했고**, 대신
  "runway ID 를 하나도 바꾸지 않았다" 는 불변성으로 대체 검증했다. 어떤 키를 쓰든 ID 가 그대로면 체크상태는 보존된다.
- `기능서술`·`근거` 문자열의 **원문 재대조 무작위 표본 검사는 하지 않았다.** L3 는 필드 이동만 하고
  가공하지 않으므로 `raw` 항등 검사(①-3)가 더 강한 보증이라고 판단했다. 표본 재대조가 필요하면 L4 게이트에서 수행.

## 잔여 위험

- scope·ia 의 `돈여부`/`주문여부` 가 `null` 이다. L4 가 이를 `false` 로 오독하면 돈 걸린 기능을 놓칠 수 있다 — **`null` = 미상**임을 L4에 전달 필요.
- runway `conflict` 7건은 `원판정상세.conflict`/`conflict_note` 에 양측 그대로 보존했다. L4 병합 시 지우지 말 것.
- scope 의 `phase` 는 canon(`1차(W1-3)`)과 fit-gap(`1차`) 표기가 달라 **둘 다 보존**(`phase_canon`/`phase_fitgap`). L4가 하나를 고를 것.

## 금지 조항 준수

- 상태 재판정 0 · 병합 0 (검증 ④·④-2) · runway ID 무변경 (검증 ③)
- 워크트리 미사용 · `07_rebaseline/L3/` 밖 쓰기 0 · 커밋/푸시 0 · `git add` 실행 0
