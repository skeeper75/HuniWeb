# HANDOFF — 위젯 배선 전면 진단 (SPEC-WIDGET-WIRING-001 · 칸반 t1)

작성: 2026-08-22 · sync 세션 `sync-huniweb`
상태: **completed** — plan → run → review → run 교정 → sync 전 컬럼 경유 완료(3-phase close).

---

## 1. 재시작 지점 (다음 세션는 여기서 시작)

- SPEC 산출물·코드·워크스페이스 전부 메인 저장소 커밋에 반영됨(이 HANDOFF를 포함한 sync 커밋 — 해시는 progress.md §E.4 `sync_commit_sha`). **PR 없음·push 없음**(운영자 지시 — 커밋까지만).
- 후속 작업은 새 카드로: 백로그 **t2~t5**(§4). 이 SPEC은 진단기 — 교정 실행은 별개 카드 소관.
- 재검증이 필요하면: 스냅샷 `snap_20260821_2319` 기준으로 `bin/` 스크립트 재실행.
  AC8 결정론(2회 실행 `diff -rq` 바이트 동일) 이미 확인됨.
- 원본 센서 직접 실행: `raw/.venv/bin/python tools/<sensor>`(**raw/.venv**가 django 포함 venv —
  `raw/webadmin/.venv`는 django 부재. 크래시가 exit 1로 묵음 통과했던 사고 원인, progress.md §E.2 M2 시행착오 참조).

## 2. 확정 수치 (review 260822 교정 후 최종 — 404 기준)

| 지표 | 값 |
|---|---|
| 결함(어댑터 widget-defects) | **404건** · 치명 333 |
| 엣지 분포 | E4 347 · W4 40 · W2 12 · E1 2 · C1 2 · E3 1 |
| verdict 266상품 | **BROKEN 62** · WARN 90 · NOT_EVALUATED 51 · OK 63 |
| worklist 925행 | review 577 · needs_authority 328 · needs_design 20 · **auto_data 0** |
| 스냅샷 | `snap_20260821_2319` (52테이블 · 분모 266 = 완제품 211·셋트구성원 40·기성 15) |
| 주 산출 | `out/wiring-explorer.html` (574KB · 자족형 · NOT_EVALUATED 범례/필터 포함) |

(교정 전 461건이었음 — 교정 내역은 §5와 `out/REVIEW-260822.md`.)

## 3. 핵심 발견 — 코드 재키(re-key) 드리프트가 E4 결함의 근본원인

ZERO_FINAL 297조합/55상품의 대다수가 하나의 패턴이다:
**상품의 활성 등록값은 신규 코드로 갱신됐는데, 가격 그리드(단가행)는 구 코드로만 적재돼 있다.**

| 상품 | 상품 활성 등록값 | 단가 그리드 값 | 판정 |
|---|---|---|---|
| PRD_000146 아크릴키링 | `MAT_000386` 아크릴(투명) 3mm | `MAT_000042/043`(상품에선 del_yn=Y) | 신·구 코드 분리 |
| PRD_000155 아크릴볼펜 | `SIZ_000216`(30x30)·`SIZ_000218`(40x40) | `SIZ_000330`(30x30)·`SIZ_000333`(40x40) | **같은 물리치수, 코드 2벌** |
| PRD_000100 포토북 | `SIZ_000270`(203x203) 외 3종 | `SIZ_000007/172/269/274`(3종 del_yn=Y) | 사이즈 재키+미적재 |

ANCHOR_DELETED 28건도 동일한 재키 패턴(예: `MAT_000118` → `MAT_000353`)이다.

> [HARD] **교정 방향은 "가격 그리드를 신 코드로 재적재(또는 코드 통합)"이지 "과등록 값 삭제"가 아니다.**
> 2026-07 대리키 오판 삭제 → 0원 견적 사고 전례(`raw/webadmin/tools/verify_zero_quote.py:5-9` 파일 첫머리에 기록).
> `del_yn` 복구도 금지 — 구코드 자재가 화면에 부활해 중복 노출+잘못된 단가가 된다(review §4-1 실측).
> 신·구 코드 대응표를 먼저 만들고 판단한다. 이 때문에 auto_data는 **0건**(전부 판단 작업 = review/needs_authority 라우팅).

## 4. 백로그 후속 카드 연계 (t2~t5)

| 카드 | 내용 | 근거 |
|---|---|---|
| **t2** | 트윈링책자(PRD_000071) 연결공정 `PROC_000021`인데 `COMP_BIND_TWINRING` 단가행 32건 전부 `proc_cd=PROC_000019`(무선제본) — 정상 선택해도 매칭 불가 가능성 | REVIEW-260822 §3.1 |
| **t3** | 책자 5상품(중철·무선·PUR·트윈링·하드커버링) `mand_proc_yn` 전건 NULL → 가격센서 공정축 미스윕(ZERO_FINAL 90건 미판정). 위젯 공정 필수선택 여부 확인 + 필수공정 등록 판단 | REVIEW-260822 §3.1 |
| **t4** | 진단 커버리지 보강 — TRUNCATED 13건(미검사 2,184조합, 합판도무송 1,110 중 32만 검사) 전수화 · AC5 `edges_evaluated` 합집합 증거무효 수정 · 책자 공식 인쇄비·용지비 부재(E2 누락 후보) 판정 | REVIEW-260822 §3.2·§4-4 |
| **t5** | 아티팩트 표시결함 — wiring-health `use_dims` JSON 파싱오류(쉼표 분해) · `code_of` 한글 첫토큰이 코드로 · ZERO_FINAL `dim`/`value` null로 근거추적 단절 | REVIEW-260822 §4-8 |

## 5. review 260822 교정 요약 (461 → 404)

1. **E1 NO_FORMULA 59건 중 57건 오탐 확정** — 직접단가 보유 상품은 엔진 1순위 소스 `PRODUCT_PRICE`로 정상 판매(굿즈류). 원본 센서 정책(정보성)으로 강등, 진짜 결함 2건(형압명함 PRD_000038·폰스트랩 PRD_000220)만 잔존.
2. **auto_data 29건 → review 재분류** — ANCHOR_DELETED의 del_yn 복구는 판단이 필요한 재배선이지 결정론 교정이 아님(§3).
3. **NOT_EVALUATED verdict 도입(51건)** — 두 가격 센서는 완제품(PRD_TYPE.01)만 분모로 봄. 셋트구성원·기성 중 결함 0 검출분을 OK로 두면 무검사가 통과로 위장됨.
4. **TRUNCATED 13건은 결함이 아니라 조합절단 고지** — 분류는 유지하되 라우팅 review, "0원 없음"의 근거가 아님을 명시.

상세: `out/REVIEW-260822.md`(review 세션 `review-huniweb` · 읽기전용 검증).

## 6. 산출물 안내

- `out/wiring-explorer.html` — 266상품 탐색 아티팩트(계층 드릴다운·단절 강조·버딕트/엣지 필터·evidence 패널)
- `out/wiring-health/*.json`(266) + `out/wiring-health-index.json` — 상품별 배선 헬스
- `out/sim-meta/*.json`(266) — `_build_sim_meta(customer=True)` 덤프(위젯·관리자 시뮬레이터 공유 빌더)
- `out/defects/widget-defects.jsonl`(404) · `out/defects/price-defects.jsonl`(553 · hdx price 승계)
- `out/worklist.csv`(925) · `out/REPORT-260821.md`(AC 대조표 포함 교정판) · `out/REVIEW-260822.md`
- 코드: `hdx/diagnose/widget_wiring_dx.py`(신규 어댑터) · `bin/` 스크립트 3종(신규) ·
  `hdx/diagnose_remediate.py`(widget 스코프 등록 최소 수정)

## 7. [HARD] 다음 세션도 유지할 제약

- `raw/webadmin/**` — **별도(nested) git 저장소** · 읽기 전용. 센서 5종·`price_views.py`·`widget_api.py` 수정 금지.
- 라이브 DB **write 0** — SELECT/COPY만(AC6). 실 COMMIT·webadmin 반영은 전부 인간 승인 게이트.
- 판정 로직 무-mint — 원본 센서 상수·판정 verbatim 승계(spec.md §1.1 R3).
- 가격 레이어 553건(price-defects)은 hdx §26 트랙 소관 — 위젯 트랙과 분리해서 다룬다.
