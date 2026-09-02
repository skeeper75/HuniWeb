# L2 progress — 현행 실측 인벤토리 + 연계 서비스 전수

- 카드: **t29 (L2)** · 분류 B(조사) · 선행 없음
- 세션: `run-huniweb` · 작성 2026-09-02
- 상태: **완료 (done)**

## 산출물

| 파일 | 내용 |
|---|---|
| `L2/as-is-inventory.csv` | 124행 (shopby 64 · webadmin 60) |
| `L2/service-dependency-map.md` | 연계 서비스 18종 서술 + 오픈 블로커 7건 |
| `L2/service-dependency.json` | 같은 18종 기계판독본 (JSON 파싱 검증 통과) |

## 완료조건 충족 근거

### ① 상태가 `done`/`partial`인 행은 전부 file:line 근거 보유 — 충족

기계 검증(스크립트, 이 세션에서 실행):

```
총 행: 124 {'done': 96, 'partial': 14, 'stub': 9, 'absent': 5}
done/partial 인데 file:line 없음: 없음
깨진 참조: 없음
총 참조 수: 122
```

검증 방법: CSV의 `근거 file:line` 필드에서 `(huni-skin-shopby|raw/webadmin)/<path>:<line>` 패턴을
정규식으로 추출 → 파일 실재 확인 → 줄 번호가 파일 길이 안인지 확인. **122건 전부 통과, 실패 0.**

### ② 연계 서비스 ≥ 12건, 각각 호출 지점 근거 — 충족 (18건)

| 등급 | 건수 | 서비스 |
|---|---|---|
| critical | 7 | D-01 Shopby shop API · D-02 Shopby server API · D-03 NCPPay(PG) · D-04 Printly 위젯 SDK/견적API · D-05 Printly 커머스 DB · D-06 Edicus 편집기 · D-11 Railway PostgreSQL |
| high | 3 | D-07 AWS S3 · D-08 Shopby 웹훅 · D-15 Redis |
| medium | 5 | D-09 Pie Canvas DB · D-10 Daum 우편번호 · D-16 NextAuth OAuth · D-17 본인인증 · D-18 세금계산서 |
| low | 3 | D-12 Anthropic · D-13 GitHub · D-14 Telegram |

18종 전부 `call_sites` 배열에 file:line을 갖는다(`service-dependency.json`).
D-17·D-18은 **호출 지점이 없다는 사실 자체**를 근거로 기록했다(grep 무결과 + 대체 코드 위치 명시).

### ③ 무작위 20행 재대조 불일치 0 — 충족

seed `20260902` 고정 표본 20행:
`WA-041, SB-036, WA-015, WA-058, WA-032, SB-047, WA-042, SB-003, WA-009, SB-012,
WA-043, WA-005, SB-046, WA-055, WA-016, WA-026, SB-058, WA-022, SB-061, SB-059`

각 행의 근거 file:line을 열어 해당 줄 내용을 출력해 대조 → **불일치 0**.
예: `WA-041` → `config/urls.py:274` = `path("api/w/v1/editor/resolve", wapi.api_editor_resolve, ...)` ✔

## 조사 중 교정한 판정 (문서≠코드 사례)

| 항목 | 최초 추정 | 코드 확인 후 | 근거 |
|---|---|---|---|
| SB-064 데모 백도어 로그인 | partial (env.example에 존재) | **absent** — 코드 미구현 | `.env.example:74-80`에 키만 있고 `src` 전역 `DEMO_AUTH` grep 0건 |
| SB-019 PDF 원고 업로드 | done (버튼 존재) | **stub** — 실동작은 장바구니 담기 | `configurator-actions.tsx:74-86` |
| SB-020 에디터 버튼 | done | **stub** — onClick 없음 | `configurator-actions.tsx:170-176` |
| SB-063 Prisma 데이터층 | done (스키마 23모델) | **absent** — 런타임 미사용 | `prisma/schema.prisma:165-637` 정의 · `src` import 0건 |
| SB-013 폴백 Configurator | done | **partial** — 가격 하드코딩 | `configurator.tsx:45-52` (a4=75000 등 상수) |

## 준수 사항

- 워크트리 미사용. primary checkout의 `07_rebaseline/L2/` **안에만** 썼다.
- 커밋·푸시 하지 않음. `git add` 실행 0회.
- 두 코드베이스 수정 0 · DB write 0 · 읽기전용.
- 문서·커밋 메시지를 판정 근거로 쓰지 않았다. 근거는 전부 코드 파일:줄.

## 미검증 / 잔여 위험 (다음 카드가 알아야 할 것)

- **런타임 미검증**: 이 조사는 정적 코드 판독이다. 서버를 띄워 실제 호출을 관찰하지 않았다.
  `done` 판정은 "코드 경로가 배선돼 있다"는 뜻이지 "운영에서 성공한다"는 뜻이 아니다.
- **외부 계약 상태 미확인**: 각 서비스의 실제 계약·키 발급 여부는 코드로 알 수 없다.
  `contract_required` 는 코드가 요구하는 자격증명 유무에서 도출한 것이다.
- **webadmin views.py(4773줄)·widget_api.py(4666줄) 전문 미독**: URL 라우팅 표와 함수명으로 기능을 식별했다.
  개별 뷰 내부의 미완 분기가 있을 수 있다.
- **raw/webadmin 과 라이브 배포본의 동일성 미확인**: 로컬 체크아웃 기준이다.
