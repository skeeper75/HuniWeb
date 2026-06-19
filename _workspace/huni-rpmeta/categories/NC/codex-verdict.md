# codex 독립 판정 — NC ([옵셋] 명함·카드·쿠폰·포토카드)

> 후니 RP-Meta 하네스 Phase 6.5 산출물 (rpm-codex-validator).
> codex(OpenAI **gpt-5.5**)를 독립 second-opinion으로 호출해 NC 결론(인쇄방식 #18 distinct 승격/부결·갭 판정)을 **우리 verdict 비노출** 상태에서 재판정.
> ★[HARD] codex 주장 = **가설**(환각 경계). 전부 `unverified` — 라이브/권위 검증 전 채택 금지. 외부 의견 ≠ 사실.

## codex 가용성·호출
- codex-cli 0.140.0 · 모델 **gpt-5.5** · `--sandbox read-only`(주문/POST/쓰기 0).
- 호출: `cat prompt.txt | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check --output-last-message verdict.md -` (foreground·EXIT 0·36,852 tokens).
  - 1차 foreground 호출은 `/tmp`가 trusted-directory 아님 + stdin 모드로 EXIT 1 → `--skip-git-repo-check` + stdin 파이프로 재시도 성공.
- 입력 = NC reverse 증거(옵셋 토큰·이산 tier·exp_prn 매트릭스·자재풀·접지 SKU·후가공 그룹)의 차이표 + **17축 frame(★#12 인쇄방식/생산레시피가 이미 존재함을 frame 일부로 명시)** + 승격 양방향 기준. **★우리 mgate-verdict(GO/NO-GO·"#18 부결" 라벨)·"인쇄방식=#12" 결론은 프롬프트에 비노출** — codex가 "인쇄방식이 새 축인가 기존 축인가"를 스스로 판단.
- 원본 = `/tmp/rpm-nc-codex/verdict.md`.

---

## codex 독립 판정 원문 (verbatim · 전부 `unverified`)

### Q1 — 신규 distinct 축 도입 여부 → **ABSORBED** `[unverified]`
NC 옵셋은 진짜 18번째 축을 도입하지 **않는다**. 승격 기준 양방향 모두 불충족:
1. **새 전용 라이브 스키마 슬롯 미관측.** NC는 디지털 BC와 동일 base-data 슬롯(자재·사이즈·도수·수량·공정·가격선택자)을 사용.
2. **KB 결함 부재.** 모든 옵셋 고유 동작이 기존 축에 귀속처가 있음 — 인쇄방식/생산레시피 #12·수량모델 #10·가격모델 #11·자재 #1·제약 #5·사이즈 #13·공정 #2.
가장 강한 근거: 옵셋은 *기존 슬롯 안의 값·채움(population)·fill 의미*를 바꿀 뿐 스키마 shape를 바꾸지 않는다.

### Q2 — 옵셋 4요소 분류 (각각 새 축인가 기존 축의 값/표현력인가) `[unverified]`
- **`offset2023_price` 가격엔진**: 기존 **#11 가격모델**의 값/라우트. 새 축 아님.
- **자재×부수 이산 tier**: 기존 **#10 수량모델** + **#5 제약** + (가능성) **#11 가격모델** 참여. 새 축 아님.
- **RXWMO220 / 옵셋 자재풀**: 기존 **#1 자재**, **#12 인쇄방식** 또는 **#5 호환제약**으로 제약됨. 새 축 아님.
- **`offset2023_item` / `item_gbn` 토큰**: 기존 **#12 인쇄방식/생산레시피** enum 또는 레시피 선택자. 새 축 아님.

### Q3 — 날조·오버피팅·비합리적 갭 징후 `[unverified]`
**증거상 날조 신호 없음. 비합리적 갭 판정 없음.** "흡수" 결론이 신뢰 가능한 이유 = 라이브 API 스키마가 *자라지 않았고*, 관측된 차이(옵셋의 다른 MOQ/tier·자재 적격성·가격 룩업 메커니즘)는 **정상 인쇄도메인 변이**로 별도 관리 차원이 아닌 production-recipe 귀결. 단 1가지 caution: **#12를 영원히 단일 primitive 토큰으로 평면화하지 말 것** — 옵셋 base + 디지털 overprint 같은 복합 recipe는 #12 내부에 더 풍부한 표현이 필요. **이건 표현력 작업이지 새 축이 아니다.**

### Q4 — 이산 부수 tier = vessel-gap인가 data-gap인가 → **data-gap** `[unverified]`
자재 게이팅 이산 부수 tier는 개념적으로 새 축/테이블이 필요 없다. 기존 축이 담을 수 있음:
- **#10 수량모델**: 연속 increment 대신 이산 tier.
- **#5 제약**: 허용 부수가 자재에 종속.
- **#11 가격모델**: 자재×부수 tier 룩업.
`pdt_exp_prn_cnt_info`가 옵셋에서 populated인 것 = 옵셋 고유 수량/제약 매트릭스의 증거이지 *누락된 관리축의 증거가 아니다*. 그릇은 이미 존재 — NC 데이터를 올바른 cardinality로 적재·모델링하면 됨.

---

## 요약
- **codex 독립 판정 = 인쇄방식 #18 ABSORBED(부결)** — 새 축 0건. 4요소 전부 기존 축(#11/#10/#1/#12/#5)의 값/표현력으로 분류.
- 이산 부수 tier = **data-gap**(그릇 실재·미적재). vessel-gap 아님.
- 날조/오버피팅/비합리 갭 = **징후 없음**.
- 유일 caution = #12 복합 recipe 표현력(단일 토큰 평면화 경계) — **새 축 아님·표현력 작업**(NC reverse N-1 가격엔진 선택자·deepcheck NC-DC-17 variable-data offset과 동일 nuance).

**산출 시각**: 2026-06-19 · codex gpt-5.5 read-only · last-message `/tmp/rpm-nc-codex/verdict.md` · 전부 `unverified`.
