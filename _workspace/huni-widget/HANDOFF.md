# Huni-Widget 하네스 — 세션 핸드오프

**작성:** 2026-06-02 (갱신) | **마지막 커밋:** S2 비교 QA GO 직후

다음 세션이 이어받기 위한 인수인계 문서. 상세 결정은 auto-memory(`MEMORY.md`) 참조.

---

## 1. 한 줄 요약

후니 인쇄 자동견적 위젯을 **역공학 보강 → 구현**으로 만드는 하네스. 현재 **책자(S0)·디지털인쇄(S1)·스티커(S2) 구현+비교QA GO 완료**, 위젯 코어가 정규화 계약+어댑터로 "코드 0변경 상품 확대" 가설을 **S1·S2 연속 실증**(S2는 `src/widget/**` 0줄 변경을 git diff로 증명). 다음은 **S3 포스터/실사(신규 NC-1 dimension-matrix-input) + Figma 시각 재현**.

## 2. 현재 진척 (커밋 완료)

| 단계 | 상태 | 커밋 |
|------|------|------|
| Phase 1 역공학 보강 (미검증 3대 라이브 해소) | 🟢 | 8f6d801 |
| Phase 2 동작분석 + 베스트프랙티스 리서치 | 🟢 | 9e07479, 142340d |
| Phase 3 위젯 명세 (정규화 계약+어댑터 키스톤) | 🟢 | d1ebada |
| 가격 명세 정정 (Red→후니 정합 가정 제거) | 🟢 | 6af69cd |
| 후니 DB(29테이블) ↔ 계약 비교분석 + 보정 | 🟢 | 2d261b4, 5fef90c |
| Phase 4 Pass1 (기반 A + Shadow코어/store/14컴포넌트 B) | 🟢 | 137aa62 |
| Pass1 스모크 + 비교 검증 하네스 구축 | 🟢 | 16ab257, 2642202 |
| D1 수정 + Phase D(업로드·Edicus·origin보안) + React dedupe | 🟢 | 5421f99 |
| Phase D 점진 QA (비교 하네스, 종합 GO) | 🟢 | 5c6e43d |
| 전체 확대 전략 (7-stage 로드맵) | 🟢 | 3a62fba |
| **S1 디지털인쇄 확대 (위젯 코어 0변경)** | 🟢 | 3ba1c08 |
| **S1 비교 QA — GO (5항목 PASS, 회귀 라이브)** | 🟢 | 74a383b |
| **S2 스티커 캡처+fixture+코어0변경 실증 (29/29 무회귀)** | 🟢 | 19e0331 |
| **S2 비교 QA — GO (6/6 PASS, F4 PASS, INV-3 git diff 증명)** | 🟢 | (이번 커밋) |

## 3. 다음 할 일 (우선순위 순)

1. **[다음] S3 포스터/실사·사인·배너 확대** — 신규 componentType **NC-1 `dimension-matrix-input`**(2D 가로×세로 → SizeMatrix2D 단가) 첫 도입. ⚠ **실사/포스터 Red fixture 미보유 → widget_monitor 라이브 캡처 선행**(S1·S2 방식: :3001 프록시로 임의 productCode 구동, catalog.json엔 없음). S3는 위젯 가시 변경(첫 신규 leaf 컴포넌트) — dispatcher case 추가 + 계약 `ComponentType` union 1줄, 코어(store/cascade/shadow) 불변. QA 노트: `area-input` 디스패처 case는 이미 존재하나 S0~S2 미사용이라 S3에서 첫 실데이터 검증 대상.
2. **S4 아크릴** (NC-2 option-addon-picker, ACNTHAP fixture 보유), **S5 굿즈/파우치** (NC-3, GSTGMIC fixture 보유), **S6 캘린더** (순수 어댑터, ⚠ fixture 캡처 선행).
3. **후니 Figma 시각 충실 재현** (expert-frontend) — 14 componentType을 DESIGN.md+`docs/figma/huni_product_option.fig` 시안에 충실하게. 컴포넌트 단위 1회 = 전 stage 재사용. (사용자 Q2 선택, 확대와 병행/이후)

### S1·S2 잔존 Minor (비차단, 병행 보강 가능)
- S1-M1: 별색 5종 fixture 보강
- S2-M1: 가시 모양선택(VIEW_YN=Y) SKU fixture 미보유 / S2-M2: FixedUnit A4 datapoint fixture 미적재
- S2-F1: 기획 "타투/스티커팩" 동명 SKU가 Red ST 36종에 부재 → STPADPN(시트)로 FixedUnit 대표 대체. 후니 D-매핑 시 확인

상세 로드맵: `03_spec/expansion-strategy.md`, 메모리 `huni-widget-expansion-strategy`.

## 4. 핵심 결정/컨텍스트 (auto-memory 참조)

- **컨버전 전략** (`huni-widget-conversion-strategy`): 위젯은 정규화 계약에만 의존, Red 어댑터로 구현·검증 → 후니 어댑터 교체로 무손실 컨버전. **후니 DB 스키마 확보됨**(`docs/huni/table-spec_260602.html` 29테이블, 단 상품마스터만 작성·가격/제약/위젯테이블 미작성).
- **가격 전략** (`huni-widget-price-strategy`): 서버 권위 + 클라 캐싱. Red 역산은 분석용 유지하되 **후니 가격과 정합·이식 금지**(후니는 4가지 가격모델 자체 보유: PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount).
- **Shopby 제외** (`shopby-excluded-from-scope`): 장바구니/주문은 정규화 경계+백엔드 미정.
- **확대 전략** (`huni-widget-expansion-strategy`): 7-stage, 가격모델·옵션구조 단위, 위젯 코어 불변 5 불변식.
- **커밋 병행** (`commit-along-harness-work`): 작업 시 git 커밋 병행, `.env.local` IGNORED 검증.

## 5. 검증된 불변식 (깨면 안 됨)

1. 서버 권위 가격 (위젯은 가격 계산 안 함, opaque)
2. 정규화 계약 Red/후니 중립 (위젯 코드에 PCS_CD/MTRL_CD/ORD_INFO/price_gbn/Shopby 0건)
3. 위젯 코어 불변 (store/cascade/shadow/dispatcher/price-seam/editor-bridge) — 확대는 어댑터+데이터+신규 leaf만
4. Shadow DOM 격리 (호스트 CSS 누수 0) + shadcn Portal-in-Shadow
5. 14 componentType switch dispatcher 고정 (신규는 NC-1~3 dispatcher case 추가만)

## 6. 환경 재기동 (세션 종료 시 서버 내려감)

```bash
# 우리 위젯 dev (vite, dedupe 적용됨)
cd _workspace/huni-widget/04_build && npm run dev          # :5173

# Red 레퍼런스 테스트베드 (토큰 만료 시 node extract-cookies.cjs)
cd raw/widget_monitor/local && node server.js              # :3001

# 비교 검증 하네스
cd _workspace/huni-widget/05_qa/compare && node serve.js   # :4173 → /compare.html
```

게이트 재현: `cd _workspace/huni-widget/04_build && npx tsc --noEmit && npx vitest run && npx vite build`
(현재 기준: tsc 0 / vitest 24/24 / build 성공)

## 7. 미해결·주의사항

- **S1 가격값=0**: 비로그인 캡처라 PRICE=0 (응답 shape는 정확). 실 단가는 후니 BFF 또는 로그인 세션 재캡처 필요. 서버 권위라 위젯 무영향.
- **후니 DB 가격·제약·위젯 테이블 미작성**: 임계경로는 후니 데이터 작성(가격 B1/제약 B2/배송 B3)이지 위젯 설계 아님. 위젯은 Red fixture로 무차단 진행.
- **실사(S3)·캘린더(S6) Red fixture 미보유** → 해당 stage 진입 시 widget_monitor 캡처 선행.
- **실 S3 PUT·Edicus 토큰체인**은 stub(Phase D) — 후니 BFF 연동 시 라이브 보강.
- **번들 크기**: fixture가 prod 번들에 포함돼 증가 추세 — G단계(경량화)에서 fixture 분리.
- **상품마스터 무결성 결함**(PM-DUP 코드중복 등): 어댑터 키 round-trip으로 흡수, 위젯 무영향.

## 8. 입력 자산 (read-only)

- 역공학: `docs/reversing/`, 라이브 테스트베드 `raw/widget_monitor/local/`
- 후니 실데이터: `docs/huni/*.xlsx` (상품마스터·가격표), 분석본 `_workspace/print-quote/02_business/`
- 후니 DB: `docs/huni/table-spec_260602.html`
- 디자인: `_workspace/print-quote/04_design/DESIGN.md`, `docs/figma/huni_product_option.fig`
- 자격증명: `.env.local` (RP_*/Edicus/Neon, .gitignore 보호)

## 9. 재개 방법

1. 이 문서 + `MEMORY.md` + `03_spec/expansion-strategy.md` 읽기
2. 환경 재기동 (§6)
3. 다음 할 일 §3-1 (S1 비교 QA)부터 — `huni-widget-orchestrator` 스킬 또는 직접 hw-qa 위임
4. 작업 후 커밋 병행 (§4 커밋 병행 메모리)
