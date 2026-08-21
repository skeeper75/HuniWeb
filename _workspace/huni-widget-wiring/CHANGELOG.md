# Changelog — huni-widget-wiring

## 0.1.0 — 2026-08-22

SPEC-WIDGET-WIRING-001 위젯 배선 전면 진단 1차 완결(plan → run → review → run 교정 → sync · 칸반 t1).
스냅샷 `snap_20260821_2319` · 분모 라이브 활성 266상품(완제품 211 · 셋트구성원 40 · 기성 15).

### 진단 파이프라인 (신규 코드 5개 — AC3 무-mint 준수)

- `hdx/diagnose/widget_wiring_dx.py` — 원본 센서 5종 어댑터(판정 verbatim 이식·크래시 명시 FAIL 포함)
- `bin/harvest_sim_meta.py` — 266상품 sim-meta 하베스터(`_build_sim_meta(customer=True)` 덤프)
- `bin/build_wiring_health.py` — 상품별 배선 헬스 조립(NOT_EVALUATED verdict 포함 · 교정3)
- `bin/build_artifact.py` — 자족형 HTML 아티팩트 빌더
- `hdx/diagnose_remediate.py` — widget 스코프 등록 + JSONL 덤프(최소 수정 · 기존 스코프 무변경)

### 산출 (review 260822 교정 반영 확정값)

- 어댑터 결함 **404건**(치명 333) — 엣지 E4 347 · W4 40 · W2 12 · E1 2 · C1 2 · E3 1
- verdict 266상품 — **BROKEN 62** · WARN 90 · NOT_EVALUATED 51 · OK 63
- worklist **925행** — review 577 · needs_authority 328 · needs_design 20 · auto_data 0
- 주 산출 `out/wiring-explorer.html`(574KB 자족형) — 전역 NO-GO(0원 주문 가능 조합 존재)

### review 260822 교정 (461 → 404)

1. E1 NO_FORMULA 59 중 **57건 오탐 확정**(직접단가 보유 = 엔진 1순위 PRODUCT_PRICE) — 정보성 강등, 진짜 결함 2건만 잔존
2. auto_data 29건 → **review 재분류**(재키 판단 필요 — del_yn 복구·값 삭제 금지, 2026-07 사고 재현 방지)
3. **NOT_EVALUATED verdict 도입 51건**(가격 센서가 완제품만 분모로 봄 — 무검사 OK 오판 방지)
4. TRUNCATED 13건은 조합절단 고지(결함 아님)로 명시 · 라우팅 review

### 핵심 발견

코드 **재키(re-key) 드리프트**가 E4(ZERO_FINAL 297)의 근본원인 — 상품은 신규 코드, 가격 그리드는 구 코드.
교정 방향은 그리드 신규 코드 재적재(또는 코드 통합)이며 **값 삭제 금지**. 상세: `HANDOFF.md` §3.
후속: 백로그 t2~t5.
