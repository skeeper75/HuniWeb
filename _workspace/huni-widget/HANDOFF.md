# Huni-Widget 하네스 — 세션 핸드오프

**작성:** 2026-06-03 (S4 GO 갱신) | **마지막 커밋:** `23b775e` (S4 아크릴 + hashRequest 핫픽스)

다음 세션이 이어받기 위한 인수인계 문서. 상세 결정은 auto-memory(`MEMORY.md`) 참조.

---

## 1. 한 줄 요약

후니 인쇄 자동견적 위젯을 **역공학 보강 → 구현**으로 만드는 하네스. 현재 **책자(S0)·디지털인쇄(S1)·스티커(S2)·포스터/실사(S3 NC-1)·아크릴(S4) 구현+비교QA GO 완료**. 두 핵심 가설 실증: ① "코드 0변경 상품 확대"(S1·S2·**S4**, `src/widget/**` 0줄 git diff 증명) ② **"신규 componentType도 코어 재작성 0"**(S3 NC-1 = 첫 코어 터치였으나 store `dimsFromSelection` if-분기 1개 + numeric slot만, cascade/shadow/editor-bridge/price-seam 0줄 — git show 7968401 증명). **S4 핵심 성과: NC-2(option-addon-picker)는 신규 불요 — finish-button 흡수 확정(디자인 시스템 v5.0.0에 가격델타 전용 컴포넌트 부재), 위젯/어댑터 0줄. 사이즈도 NC-1 재사용 아님(vTmpl_price+0×0 sentinel 부재 → option-button).** 또한 S4 검증 중 **hashRequest 캐시 키 버그(전 상품 가격 재산정 차단) 발견·핫픽스**(price.ts hashRequest → 재귀 키정렬 stableSerialize). **다음은 S5 굿즈/파우치(NC-3 image-option-selector 조건부) + Figma 시각 재현.**

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
| **S2 비교 QA — GO (6/6 PASS, F4 PASS, INV-3 git diff 증명)** | 🟢 | b6c01f4 |
| **S3 포스터/실사 캡처 + NC-1 명세** | 🟢 | d2a10c6 |
| **S3 NC-1 구현 (첫 코어 터치, store 분기1개+numeric slot, 39 green)** | 🟢 | 7968401 |
| **S3/NC-1 비교 QA — GO (8/8 PASS, 결함해소 3중 증명, INV-3 git show)** | 🟢 | 7b2dc9a |
| **S4 아크릴 검증 (위젯/어댑터 0변경, finish-button 흡수, NC-2 신규 불요 확정) + hashRequest 핫픽스 + S4 비교 QA GO (54 green)** | 🟢 | 23b775e |

## 3. 다음 할 일 (우선순위 순)

> **직전 완료(23b775e):** S4 아크릴 — NC-2 신규 불요(finish-button 흡수 확정), 위젯/어댑터 0줄. hashRequest 캐시 버그 핫픽스 동반. 명세 `03_spec/s4-acryl-spec.md`·QA `05_qa/s4-qa.md`.

1. **[다음·최우선] S5 굿즈/파우치/문구 확대** — 가격모델 **TieredDiscount 본진**(파우치/문구/굿즈/말랑 수량구간 %할인, 말랑 2개부터 즉시할인·최대50%). 일부 포장재=FixedUnit. **GSTGMIC fixture 보유**(검증자산).
   - 신규 componentType 후보 **NC-3 `image-option-selector`(64×64)** — 색상/타입 셀렉터 다수일 때. ⚠ **image-chip variant 우선·미확정**. S4 전례(NC-2가 디자인 시스템 근거로 흡수 판명)대로 **hw-architect가 디자인 시스템(huni-design-system v5.0.0) 조회 → 신규 vs variant 확정** 후 진행.
   - 패턴: S4와 동일 파이프라인 — hw-architect(판정·명세 `03_spec/s5-*.md`) → hw-builder(검증/흡수 실증, 0변경 목표) → hw-qa(비교 QA GO).
2. **S6 캘린더** — 순수 어댑터(책자 PriceTable3D 변형). ⚠ **Red fixture 미보유 → widget_monitor 라이브 캡처 선행**(임계경로).
3. **후니 Figma 시각 충실 재현** (expert-frontend) — 14(+NC-1) componentType을 DESIGN.md+`docs/figma/huni_product_option.fig` 시안에 충실하게. 컴포넌트 단위 1회 = 전 stage 재사용. (확대와 병행/이후)

### S4 아크릴 후속 보강 포인트 (s4-acryl-spec.md §7 / s4-qa.md)
- **S4-M1**: 비로그인 PRICE=0 → SizeMatrix2D+TieredDiscount+부자재단가 3중 합성 실가 미확보. 로그인 캡처로 옵션변동→가격변동 직접 증거 필요(INV-1상 위젯 무관, 후니 비교 시 필요).
- **S4-M2**: 타 아크릴 SKU(스탠드/코롯토/키링)가 가로×세로 **자유입력**이면 그 SKU는 NC-1 자동 발동 → SKU별 fixture 캡처로 `price_gbn`·sentinel 확인. ACNTHAP(명찰)=프리셋만이라 NC-1 무관.
- **skinInfo view_yn=N**: 아크릴 도수/용지 화면 숨김이 현 어댑터에 미반영(노출됨). 가격 무해(값 1개 자명), 시각 정합은 후니 단계 보정. 위젯 코어 불변 원칙상 본 stage 미수정.
- **hidden essential(BON_PAP/LAS_DFT) 단가**: 숨김 필수옵션이 `selectedFinishes`에 echo됨(QA S4-O1 확인 — 정합 안전). 로그인 Red 캡처로 finalPrice 반영 직접 증거 보강 가능.

### S3 NC-1 후속 보강 포인트 (s3-qa.md / NC1-impl-note.md)
- PRICE>0 실가 비교(로그인 캡처로 cutW/cutH 변동→PRICE 변동 직접 증거) — 후니 비교검증 임계경로
- 작업사이즈 `work=cut+CUT_MRG(4mm)` 공식의 real_price 상품 공통성(BNBNFBL/BNPTPET만 캡처)
- MAX_CUT 검증 위치(leaf clampAxis vs canOrder) UX 정합 / defaultSelections DFT_YN=Y 우선정렬 후니 정책 정합

### S1·S2 잔존 Minor (비차단, 병행 보강 가능)
- S1-M1: 별색 5종 fixture 보강
- S2-M1: 가시 모양선택(VIEW_YN=Y) SKU fixture 미보유 / S2-M2: FixedUnit A4 datapoint fixture 미적재
- S2-F1: 기획 "타투/스티커팩" 동명 SKU가 Red ST 36종에 부재 → STPADPN(시트)로 FixedUnit 대표 대체. 후니 D-매핑 시 확인

상세 로드맵: `03_spec/expansion-strategy.md`, 메모리 `huni-widget-expansion-strategy`.

## 4. 핵심 결정/컨텍스트 (auto-memory 참조)

- **컨버전 전략** (`huni-widget-conversion-strategy`): 위젯은 정규화 계약에만 의존, Red 어댑터로 구현·검증 → 후니 어댑터 교체로 무손실 컨버전. **후니 DB 스키마 확보됨**(`docs/huni/table-spec_260602.html` 29테이블, 단 상품마스터만 작성·가격/제약/위젯테이블 미작성).
- **가격 전략** (`huni-widget-price-strategy`): 서버 권위 + 클라 캐싱. Red 역산은 분석용 유지하되 **후니 가격과 정합·이식 금지**(후니는 4가지 가격모델 자체 보유: PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount).
- **Shopby 제외** (`shopby-excluded-from-scope`): 장바구니/주문은 정규화 경계+백엔드 미정.
- **확대 전략** (`huni-widget-expansion-strategy`): 7-stage, 가격모델·옵션구조 단위, 위젯 코어 불변 5 불변식. **NC-2/NC-3 "변형 우선" 디폴트가 S4에서 실증됨**(디자인 시스템에 가격델타 전용 컴포넌트 부재 → finish-button 흡수).
- **커밋 병행** (`commit-along-harness-work`): 작업 시 git 커밋 병행, `.env.local` IGNORED 검증. ⚠ 루트 `.gitignore`에 `*-key.*` 보안 패턴 존재 — 테스트 파일명에 `-key` 포함 금지(예: price-cache-key→price-cache로 변경한 전례).

## 5. 검증된 불변식 (깨면 안 됨)

1. 서버 권위 가격 (위젯은 가격 계산 안 함, opaque)
2. 정규화 계약 Red/후니 중립 (위젯 코드에 PCS_CD/MTRL_CD/ORD_INFO/price_gbn/Shopby 0건)
3. 위젯 코어 불변 (store/cascade/shadow/dispatcher/price-seam/editor-bridge) — 확대는 어댑터+데이터+신규 leaf만. **S4는 store 분기조차 0(NC-1보다 강한 실증).** 단 **버그 수정은 정당한 예외**(hashRequest 핫픽스 = price.ts 캐시 키만 수정, 가격 로직 무변경).
4. Shadow DOM 격리 (호스트 CSS 누수 0) + shadcn Portal-in-Shadow
5. 14 componentType switch dispatcher 고정 (신규는 NC-1~3 dispatcher case 추가만. 현재 NC-1만 추가, NC-2 흡수로 불요)

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
**현재 기준: tsc EXIT 0 / vitest 54 passed (9 files) / vite build 성공 (widget.js 707KB)**

## 7. 미해결·주의사항

- **비로그인 PRICE=0** (S1·S3·S4 공통): 비로그인 캡처라 PRICE=0 (응답 shape는 정확). 실 단가는 후니 BFF 또는 로그인 세션 재캡처 필요. 서버 권위라 위젯 무영향.
- **후니 DB 가격·제약·위젯 테이블 미작성**: 임계경로는 후니 데이터 작성(가격 B1/제약 B2/배송 B3)이지 위젯 설계 아님. 위젯은 Red fixture로 무차단 진행.
- **캘린더(S6) Red fixture 미보유** → S6 진입 시 widget_monitor 캡처 선행. (S3 포스터/실사는 BNBNFBL/BNPTPET 캡처 완료, 아크릴은 ACNTHAP 보유.)
- **타 아크릴 SKU 자유입력 미검증**(S4-M2): 명찰 외 아크릴이 자유입력이면 NC-1 자동 발동 — fixture 캡처로 확인.
- **실 S3 PUT·Edicus 토큰체인**은 stub(Phase D) — 후니 BFF 연동 시 라이브 보강.
- **번들 크기**: fixture가 prod 번들에 포함돼 증가 추세 — G단계(경량화)에서 fixture 분리.
- **상품마스터 무결성 결함**(PM-DUP 코드중복 등): 어댑터 키 round-trip으로 흡수, 위젯 무영향.
- **[해소됨] hashRequest 캐시 키 버그**: replacer 배열이 중첩 키 누락 → 옵션 변경 시 가격 재산정 차단이던 전 상품 결함. 23b775e에서 재귀 키정렬 `stableSerialize`로 핫픽스(재현 테스트 `test/price-cache.test.ts` 9케이스 회귀 보호).

## 8. 입력 자산 (read-only)

- 역공학: `docs/reversing/`, 라이브 테스트베드 `raw/widget_monitor/local/`
- 후니 실데이터: `docs/huni/*.xlsx` (상품마스터·가격표), 분석본 `_workspace/print-quote/02_business/`
- 후니 DB: `docs/huni/table-spec_260602.html`
- 디자인: `_workspace/print-quote/04_design/DESIGN.md`, `docs/figma/huni_product_option.fig`, 디자인 시스템 스킬 `huni-design-system` (v5.0.0, 14 componentType 카탈로그)
- 자격증명: `.env.local` (RP_*/Edicus/Neon, .gitignore 보호)
- 보유 fixture: PRBKYPR(S0)·BCSP*/디지털(S1)·STCUXXX/STPADPN/STTHCIC(S2)·BNBNFBL/BNPTPET/PRPOXXX(S3)·**ACNTHAP(S4)**·GSTGMIC(S5 예정)

## 9. 재개 방법

1. 이 문서 + `MEMORY.md` + `03_spec/expansion-strategy.md` 읽기
2. 환경 재기동 (§6) + 게이트 재현으로 baseline(54 green) 확인
3. **다음 할 일 §3-1 (S5 굿즈/파우치)부터** — `huni-widget-orchestrator` 스킬 사용. S4 전례대로 hw-architect(NC-3 신규 vs variant 판정+명세) → hw-builder(흡수/구현 검증) → hw-qa(비교 QA) 순.
4. 작업 후 커밋 병행 (§4 커밋 병행 메모리, `.env.local` IGNORED + `*-key.*` 패턴 주의)
