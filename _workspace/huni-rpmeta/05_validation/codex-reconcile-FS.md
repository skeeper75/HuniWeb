# codex 교차검증 reconcile — FS(패브릭) 카테고리 (Phase 6.5 신규 레인 첫 실증)

> rpm-codex-validator. **결론 검증 전용 레인**(deepcheck=누락 발굴과 다름) — rpm-validator의 *판정(결론)이 옳은가*를 codex(gpt-5.5)로 독립 재판정 후 reconcile.
> 베이스라인 = `05_validation/mgate-verdict-FS.md`(M1~M6 GO·타일링/A-1 부결·distinct 0) — **읽되 codex에 비노출**(독립성 HARD).
> codex 원문 = `categories/FS/codex-verdict.md`(각 주장 `unverified`).
> 원칙: 합의=고신뢰 확정·불일치=조사 신호·라이브 우선·codex 인용 신뢰 금지·자동 flip 금지.

---

## reconcile 매트릭스 (codex 독립 판정 ↔ validator 판정 per item)

| 항목 | validator 판정(베이스라인) | codex 독립 판정(unverified) | reconcile | 신뢰도 |
|---|:---:|:---:|:---:|:---:|
| **distinct 전체** | distinct 0(17축 무손실 흡수) | **ABSORBED**(신규 관리축 없음) | **합의** | 고신뢰 확정 |
| **타일링 TILL_WH_GBN** | 부결(#18 아님·①충족 ②불충족·공정 배치 흡수) | **ABSORBED**(공정파라미터#9 흡수·축 분리 과잉) | **합의** | 고신뢰 확정 |
| **A-1 패널 구성** | 부결(①UNOBSERVED + ②결함없음) | **ABSORBED/근거부족**(패널 슬롯 미관측·단일 full-print) | **합의** | 고신뢰 확정 |
| **gap PASS 과신 경계** | FS-7 가격모델 WEAK·FS-8 infoCall unobserved 정직 표기 | "PCS enum/단가 미관측은 WEAK/GAP로 낮춰야" | **합의(부분 강화)** | 고신뢰 |
| **fabrication 경계** | 날조 0(M1)·unobserved를 fact 위장 없음 | "패널별 독립 디자인 지원" 결론은 fabrication·"미관측까지만" | **합의** | 고신뢰 |

## 합의 분석 (전건 합의 — 불일치 0)

- **승격/부결 핵심 두 후보(타일링·패널) 모두 codex가 독립적으로 ABSORBED 판정** = 우리 부결과 일치. 두 모델이 서로의 결론을 모르는 상태에서 같은 증거로 같은 판정에 도달 → **distinct 0 비준의 고신뢰 확정.**
- **타일링 흡수처 일치:** codex가 우리 판정을 보지 않고도 "공정파라미터(#9 print-placement/imposition)"를 흡수처로 독립 지목 — validator가 `prcs_dtl_opt` jsonb(오시/미싱 줄수·코팅 면 enum)로 라이브 재실측한 흡수처와 **동일 축**. 우연 일치가 아니라 증거가 그 방향을 가리킴.
- **패널 부결 근거 일치:** codex가 "단일 full-print 업로드, 패널 슬롯 미관측, 쿠션 SID_D=도수 토글(양면 디자인 아님)"을 독립 지적 — validator M3 A-1 부결의 ①UNOBSERVED·"쿠션 양면은 도수#6 토글이지 면별 디자인 아님"과 **글자 단위로 일치.**
- **codex 자체 환각/오버피팅 경계 발동:** codex가 오히려 "패널을 NEW-AXIS로 했다면 과적합", "타일링을 별도 축으로 세웠다면 분리 과잉"이라며 *승격 쪽이 오류*라고 경고 — 우리 부결 방향과 같은 방향의 견제. codex가 거짓 NEW-AXIS를 만들어내지 않음.

## 불일치 / divergence

**없음(0건).** codex가 validator와 다른 판정(NEW-AXIS)을 낸 항목이 0. 조사 신호·라이브 재실측·owner 라우팅 불요.

- 잠재 후속 트리거(divergence 아님): codex가 제시한 패널 NEW-AXIS 성립 5조건(panel_cd·패널별 업로드/자재/가격/제약)은 **현재 전부 미관측** — 향후 FS infoCall 라이브 보강(node monitor) 또는 패널형 신상품 등장 시 재실측하면 판정 갱신 트리거. 현 시점 베이스라인 변동 없음.

## codex 가용성 노트

- **gpt-5.5 AVAILABLE.** foreground `codex exec -m gpt-5.5 --sandbox read-only --output-last-message` EXIT=0·verdict 2,878 bytes. **"Claude 단독" 폴백 불요.**
- **★preflight 백그라운드 행(hang) 우회 기록:** 공용 codex-review.sh가 preflight를 백그라운드로 호출 시 hang(exit 144 실증)이라, **preflight를 거치지 않고 foreground에서 codex exec 직접 호출**로 회피(gpt-5.5 가용 직전 확인됨). 1차 시도는 `timeout` 래퍼가 zsh에 미설치(EXIT=127)라 래퍼 제거 후 성공.

## 신규 레인(Phase 6.5) 작동 입증

- **첫 실증 성공:** 증거 전용 프롬프트(우리 판정 비노출·workdir 격리)로 codex 독립 판정 수집 → reconcile 매트릭스 산출 완료.
- **독립성 보존 확인:** codex가 우리 mgate-verdict를 보지 못한 상태(workdir `categories/FS/`·05_validation 접근 불가)에서 우리 부결을 echo가 아닌 **독립 도출** — 두 모델 합의가 의미 있는 신호임을 입증.
- **레인 정체성 충족:** deepcheck(누락 발굴)와 달리 "우리 승격/부결·GO/NO-GO가 옳은가"라는 결론 검증에 집중 — codex가 verdict + 근거 + checkable 조건을 반환(discovery로 드리프트하지 않음).
