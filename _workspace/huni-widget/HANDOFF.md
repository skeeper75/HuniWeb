# Huni-Widget 하네스 — 세션 핸드오프

**갱신:** 2026-06-04 (2차 팀 교차검증 + 보정 Wave1·W2-a 세션) | **마지막 커밋:** `2bcb480`
**HEAD 게이트:** `cd _workspace/huni-widget/04_build && npx tsc --noEmit && npx vitest run && npx vite build` → tsc 0 / **vitest 150** / build OK

다음 세션이 이어받기 위한 인수인계. 상세 결정은 auto-memory(`MEMORY.md`)·`07_parity/` 참조.

---

## 1. 한 줄 요약

후니 인쇄 자동견적 위젯을 **역공학 보강 → 구현 → 검증** 으로 만드는 하네스. S0~S6 상품 확대 완료 후, 이번 세션에 **검증 깊이를 3단계 격상**: ① Red 라이브 동등성 게이트 GO → ② **코드 레벨 구조 정합(S0~S3, 역공학 4모듈 권위 대조)** → ③ **에이전트 팀 교차검증(서브가 놓친 5갭 발견·보정)**. 코드 정합·보정 전부 hw-qa 독립 재검증 GO. **위젯은 Red와 책임·로직·분기 재현 동등**임이 코드 레벨로 입증·보정됨. 다음 단계는 **후니 컨버전**(어댑터 데이터소스 교체).

## 2. 이번 세션 성과 (커밋 완료)

| 작업 | 커밋 |
|------|------|
| 종합 동등성 게이트 GO (Red 라이브 4차원×4모델, F-1/F-2 봉인) | `5e98bed` |
| 코드 레벨 정합 S0~S1 (역공학 4모듈 전수지도 + 갭 전체지도) | `ab885be` |
| S3 MAJOR 라운드 (14항목 보정: 의류 apparel·ACC·color-chip·ROU·VIEW_YN·itemGroup·에디터) | `e3ff577`·`b48fa15`·`3a4afa6` |
| isReadyToOrder BFF 배선 누락 보충 | `87bfbc6` |
| **팀 교차검증 4결함 보정** (G-1 WRK/DIR_MTR ATTB·C-B 자재왕복 코팅·G-2 에디터 가격콜백·PRICE=0 진단) | `59fed43`·`26b65f1`·`41eb53d` |
| 하네스 진화 (오케스트레이터 v1.3.0 + hw-qa/hw-builder + worktree drift 정정) | `6ff1303` |
| **2차 팀 교차검증 + 보정 Wave1** (G-1 ATTB 권위 날조 정정: PDT_WRK echo 제거·mb_cust_cod 빈값 가드·날조 주석. 신규 G-5 의류 DIR_MTR 드롭·A-2 SUB_MTR 평면화·B-1 dead 발굴) | `3844eb6` |

**vitest 76 → 148.** 위젯 코어 INV-3 준수(구조결함 보정은 정당 완화, additive). 신규 leaf 2개(MultiCheckGroup·AccPanel). Agent Teams 팀 모델 opus 통일.

## 3. 다음 할 일 (우선순위 순) — 전부 컨버전 단계, day-1 무차단

> **이번 세션 완료:** 2차 팀 교차검증(3렌즈) + 보정 Wave1(커밋 3844eb6) + W2-a(커밋 2bcb480) + **라이브 qty-sweep 캡처(D-1 결판·G-5 확정·G-6 신규)**. 상세 [[crossverify-round2-findings]] §5.
> **상태 정리:**
> - ~~**W2-a**~~ ✅ 완료(커밋 2bcb480, hw-qa GO): SUB_MTR 엔트리-shape discriminator. 어댑터 전용 INV-3 코어 0줄.
> - ~~**D-1**~~ ✅ **RESOLVED**(라이브 qty-sweep): WRK_MTR/DIR_MTR ATTB={2,10} 건수(PRN_CNT) 따라 변함·PRICE 선형 → 우리 `ATTB=String(req.quantity)`=건수 echo가 Red와 **값 일치**. characterization 테스트 정당 입증. (커밋 대기)
> - **G-6** [신규, 잠복/컨버전 게이트]: 굿즈 수량 **필드축 스왑** — Red 는 건수를 PRN_CNT 에 싣고 ORD_CNT=1, 우리는 ORD_CNT 에 실음(`price.ts:34,37`). ATTB 값은 옳으나 실 HTTP 가격권위(PRN_CNT) 배선이 컨버전 시 정렬 필요. fixture 정적룩업이라 현재 미발현(G-INT-0).
> - **G-5** ✅ **CONFIRMED**(라이브): CLSTSHS clothes2025_price PRICE=19,900, PCS_INFO `[PDT_WRK,DIR_MTR]` → Red 는 DIR_MTR **유지**. 우리 apparel 배타삼항(red-adapter.ts:83-85)은 드롭=실 결함. 처방=additive 삼항(hidden-essential 중복가드). 컨버전 게이트.
> - **W2-b** [잔여]: INN_DFT 노트류(GSNTSPR/GSDRSKS) tmpl_price 가 우리측 요청 shape 결함(ORD_CNT/PRN_CNT 필드 부재 → SUM=0). scaling 0-응답 판정 불가. editor_sdk tmpl_price 노트 요청 필드 역공학 후 재캡처.
> - **G-INT-0**: 런타임 price 경로 fixture 정적룩업 → shape 결함 침묵. 실 HTTP BFF 배선(컨버전)까지 회귀가드 부재.
> **가격 권위(HARD 실증):** `result_sum.PRICE`가 단일 권위. per-PCS `result[].PRICE`는 번들 구성요소 0이 정상 → per-line 읽으면 거짓 PRICE=0(캡처가 실증·교정). mapPriceResponse가 result_sum 쓰는지 확인 권고.

1. **[최우선] 후니 컨버전** — `createHuniAdapter` 데이터소스 교체(현재 `bff/stub.ts:25` 주석만, 구현 0줄). 후니 옵션마스터 수령 시 어댑터를 Red→후니로 교체. 위젯 코어·정규화 계약 불변(무손실 컨버전). 메모리 [[huni-widget-conversion-strategy]].
2. **PRICE>0 재캡처** — 의류(CLSTSHS clothes2025_price)·ACC(ACPDSTD·GSSBMTL)·포스터(BNBNFBL/BNPTPET) 가격 미캡처. 현재 PRICE=0→ok:false+`priceUnavailableReason` 안전격리. **Red는 PRICE=0 불가 → 그 0은 우리측 캡처 공백**([[huni-widget-red-price-never-zero]]). 로그인 세션+등록규격으로 PRICE>0 받아 가격 동등성 마감.
3. **L-3 size-linked 반경(G-4) / 합성 ATTB(잠복)** — dormant(GSCDPOP fixture 부재). 컨버전 시 옵션마스터에 size-linked 반경 상품·합성ATTB 있으면 보정(어댑터 divSeq 전달 + cascade size→radius 재계산). `07_parity/crossverify-findings.md`.
4. **G-3 라인앵커 정정** — deob 재생성으로 어댑터 주석 라인참조 stale(추적성만). 정리 시.

## 4. 핵심 결정/컨텍스트 (auto-memory 참조)

- **코드 정합 완료** ([[huni-widget-code-parity-done]]): 역공학 소스코드 4모듈(deob_05/06/07/editor_sdk)이 권위. 캡처 표본 < 코드 권위(단편 금지). 산출 `07_parity/`.
- **PRICE=0 불가** ([[huni-widget-red-price-never-zero]], HARD): RedPrinting 위젯은 PRICE=0 절대 반환 안 함. 0=우리측 결함신호(세션/필드/규격). 격리 아닌 진단·수정 대상. 가격 동등성은 PRICE>0 실측으로만.
- **컨버전 전략** ([[huni-widget-conversion-strategy]]): 위젯은 정규화 계약만 의존, Red 어댑터로 구현·검증 → 후니 어댑터 교체로 무손실 컨버전. 후니 DB 스키마 확보됨(`docs/huni/table-spec_260602.html` 29테이블, 상품마스터만 작성·가격/제약 미작성).
- **가격 전략** ([[huni-widget-price-strategy]]): 서버 권위+클라 캐싱. Red 역산은 분석용, 후니 가격과 정합·이식 금지.
- **fixture가 shape 결함 은폐** ([[fixture-masks-serialization-shape]]): 어댑터/직렬화는 캡처와 field-for-field 대조 테스트 필수. fixture 미보유 시 침묵 폴백 금지→throw.
- **커밋 병행** ([[commit-along-harness-work]]): `.env.local` IGNORED 검증. `.claude` 하네스 정의는 tracked(huni-widget만). `*-key.*` 패턴 주의.

## 5. 검증된 불변식 (깨면 안 됨)

1. 서버 권위 가격(위젯 opaque) — **PRICE=0 받으면 결함**(Red 0 불가)
2. 정규화 계약 Red/후니 중립(위젯 코드에 PCS_CD/MTRL_CD/price_gbn/Shopby 0건)
3. 위젯 코어 불변(store/cascade/shadow/dispatcher/price-seam/editor-bridge) — 확대는 어댑터+데이터+신규leaf만. **버그·구조결함 보정은 정당 예외**(코어 최소·additive·git diff 명시)
4. Shadow DOM 격리 + shadcn Portal-in-Shadow (Tailwind 변수체인 함정: shadow/ring은 style 명시주입)
5. 신규 leaf 사전정당(현재 정확히 2개: MultiCheckGroup·AccPanel) + 신규 dispatcher case는 NC만
6. **독립 재검증 게이트**: builder 보정 → hw-qa 직접 재실행·field대조·왕복양방향 → GO. 자기보고 불충분

## 6. 환경 재기동 (세션 종료 시 서버 내려감)

```bash
# 우리 위젯 dev
cd _workspace/huni-widget/04_build && npm run dev          # :5173 (/?p=PRODUCTCODE, /explorer.html)
# Red 레퍼런스 테스트베드 (라이브 캡처 시 필수)
cd raw/widget_monitor/local && node extract-cookies.cjs    # 로그인 세션 갱신(RP_* in .env, 토큰~1h)
cd raw/widget_monitor/local && node server.js              # :3001 (/rp-api 쿠키+토큰 주입, fresh 재기동 필수=가격캡처)
```
> 가격캡처 노하우: `POST /rp-api/ko/product_price/get_ajax_price_vTmpl`, reqBody `dataJson.ORD_INFO[0]`에 ORD_CNT+PRN_CNT 둘 다 필수(누락=침묵0). 쿠키세션이 가격권위.

## 7. 미해결·주의

- **후니 어댑터 코드 0줄**(컨버전 미실증): 무손실 컨버전은 문서 검증(huni-db-mapping 90%)이지 코드 미실증. `createHuniAdapter` PoC가 다음 핵심.
- **의류/ACC/포스터 가격 미검증**: 옵션 SHAPE·분기만 검증, 가격 동등성 미검증(PRICE>0 재캡처 필요). 현재 안전격리(ok:false+진단).
- **L-3/G-4 size-linked 반경**: dead code, dormant. GSCDPOP류 상품 컨버전 시 발현.
- **합성 ATTB(잠복)**: COT/SCO×ATTB_CD 공존 fixture 0, 무발현. 컨버전 게이트.
- **후니 DB 가격·제약·위젯 테이블 미작성**: 임계경로는 후니 데이터 작성이지 위젯 설계 아님.

## 8. 입력 자산 (read-only)

- 역공학: `docs/reversing/red_reverse_engineer/03_deobfuscated/`(4모듈 deob_05/06/07/editor_sdk — 코드 정합 권위), `docs/reversing/*.html`(심층리포트), 라이브 테스트베드 `raw/widget_monitor/local/`
- 코드 정합 산출: `07_parity/`(red-code-map-05/06/07/08·structure-map·parity-matrix-P1/D1~D4·parity-gap-map·S2·wave-a/b/c-verification·crossverify-findings·crossverify-fix-verification·harness-improvements)
- 후니 실데이터/DB: `docs/huni/*.xlsx`, `docs/huni/table-spec_260602.html`
- 디자인: `_workspace/print-quote/04_design/DESIGN.md`, `docs/figma/huni_product_option.fig`, 디자인시스템 스킬 `huni-design-system`
- 자격증명: `.env.local`(RP_*/Edicus/Neon, gitignore 보호)
- 보유 fixture(04_build/fixtures): PRBKYPR/BCSP*/디지털·STCUXXX/STPADPN/STTHCIC·BNBNFBL/BNPTPET/PRPOXXX·ACNTHAP/AIPPCUT·GSTGMIC/GSPUFBC/GSBGRDY·HLCLSTD/HLCLWAL·BCFOXXX·CLSTSHS·ACPDSTD·GSSBMTL

## 9. 재개 방법

1. 이 문서 + `MEMORY.md` + `07_parity/parity-gap-map.md`·`crossverify-findings.md` 읽기
2. 게이트 재현으로 baseline(148 green) 확인
3. **다음 할 일 §3-1(후니 컨버전)** 또는 §3-2(PRICE>0 재캡처)부터 — `huni-widget-orchestrator` 스킬 사용(코드정합 검증축·실행지침이 v1.3.0에 인코딩됨)
4. 작업 후 커밋 병행(§4). 보정은 builder→hw-qa 독립 재검증 게이트 필수(§5-6). 다중 렌즈 분석/교차검증은 `TeamCreate` 팀(opus), 단일 독립검증·순차 보정은 서브
5. **하네스를 에이전트 팀 모드로 실행하려면 `TEAM-MODE-GUIDE.md` 참조** — 전제 확인·트리거·팀/서브 매핑·TeamCreate 절차·제약·실전 예시
