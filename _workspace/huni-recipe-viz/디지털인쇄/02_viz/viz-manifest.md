# 디지털인쇄 시각화 매니페스트 (정합 검증용)

> **작성** 2026-06-18 · hrv-component-visualizer (2단계 mermaid→codex-imgage)
> **목적** hrv-validator R3 대조용 — mermaid(진실 소스)의 노드/엣지/강조를 이미지가 왜곡·누락 없이 반영했는지 검증 가능화.
> **입력** `01_recipe/recipe-디지털인쇄.md`(394줄·9 패밀리·31상품) + `recipe-gap-board.md`(G-1~G-6).
> **codex 가용성** AVAILABLE (gpt-5.5, codex-cli 0.140.0) — codex-preflight 실측.
> **mermaid 문법 검증** mmdc 미설치 → 자동 렌더 검증 불가, 수동 구조 검토만. 노드/엣지/클래스 일관성 확인.

---

## 1. mermaid ↔ 이미지 파일 쌍

| # | mermaid (진실 소스) | 이미지 (codex 렌더) | 레벨 | 핵심 강조 |
|---|------|------|------|------|
| 1 | `mermaid-종합.mmd` | `viz-종합.png` | 시트 종합 | G-1 미바인딩 밴드·G-4 패밀리 결함 콜아웃·희소 단가행 |
| 2 | `mermaid-프리미엄엽서.mmd` | `viz-프리미엄엽서.png` | 대표(PRF_DGP_A) | G-4 F-1/F-2/F-3 3대 결함 |
| 3 | `mermaid-화이트인쇄엽서.mmd` | (이미지 미생성 — 핵심 3장 우선) | 대표(별색+G-3) | G-3 자유형커팅 silent 누락 |
| 4 | `mermaid-투명엽서-미바인딩.mmd` | `viz-투명엽서-미바인딩.png` | 대표(G-1) | frm_cd 부재 → 견적 완전 불가 |

> 화이트인쇄엽서는 mermaid(진실 소스)는 산출했으나 이미지는 핵심 3장(종합·DGP대표·미바인딩대표)에 우선순위를 둬 미생성.
> directive "이미지는 핵심만" 준수. 필요 시 codex 1장 추가 생성으로 보완 가능.

---

## 2. 노드/엣지 인벤토리 (R3 대조 기준)

> 노드 집계 = `ID["..."]` 선언 distinct (subgraph 컨테이너 제외, `&` fan-out 소스 포함).
> 화살표 집계 = `-->` + `-.->` 토큰 수(한 줄 `A --> B & C`는 토큰 1로 계수 → 시각 엣지는 더 많을 수 있음).

| mermaid | distinct 노드 | 화살표 토큰 | :::missing 강조 | subgraph |
|---------|:--:|:--:|:--:|:--:|
| mermaid-종합.mmd | 32 | 41 | 5 | 4 (PRODUCTS·FORMULAS·COMPS + 인라인) |
| mermaid-프리미엄엽서.mmd | 22 | 16 | 4 | 3 (OPT·COMP·PRICE) |
| mermaid-화이트인쇄엽서.mmd | 15 | 12 | 3 | 2 (OPT·COMP) |
| mermaid-투명엽서-미바인딩.mmd | 10 | 8 | 3 | 1 (OPT) |

### 2.1 종합도 핵심 노드 (출처 추적)
- 상품: 21 바인딩 / 포토카드2 / 명함4 / 봉투제작 / **미바인딩10**(019·030·034·035·036·037·038·039·040·049) ← gap-board G-1
- 공식: PRF_DGP_A~F·PRF_PHOTOCARD_FIXED·PRF_NAMECARD_FIXED(정상) + PRF_ENV_MAKING·PRF_FOLD_SUM(분홍점선=comp불명 G-2) ← recipe §(1)
- 구성요소: DIGITAL_S1/S2(212행)·PAPER(56행)=정상 / PHOTOCARD_SET(1행)·NAMECARD_STD(2행)=희소 ← gap-board G-5
- 결함 콜아웃: G-4 F-1/F-2/F-3 ← gap-board G-4

---

## 3. 강조(누락) 목록 — "이게 빠져서 견적 결과값이 안 나온다"

| ID | 종류 | mermaid 표현 | 견적 영향 | 출처 |
|----|------|------|------|------|
| G-1 | 미바인딩 10상품 | 빨강 노드 + 점선엣지 "frm_cd 부재" | 가격 0·견적 완전 불가 | gap-board G-1 |
| G-2 | 공식 comp 불명 | 분홍 점선 PRF_ENV_MAKING·PRF_FOLD_SUM | 사슬 미확정 | gap-board G-2 |
| G-3 | 옵션-comp 단절 | 점선 "silent 누락"(화이트인쇄엽서 자유형커팅) | 옵션 선택해도 가격 미반영 | gap-board G-3 |
| G-4 F-1 | print_opt_cd 도수↔면 충돌 | 빨강 콜아웃 → print_opt | 단가 오매칭 | gap-board G-4 |
| G-4 F-2 | S1+S2 이중배선 | 빨강 콜아웃 → 두 DIGITAL comp | 인쇄비 이중합산 | gap-board G-4 |
| G-4 F-3 | 출력매수 환산 엔진부재 | 빨강 콜아웃 → 수량 | 호출측 환산 안하면 오산 | gap-board G-4 |
| G-5 | 단가행 희소 | 빨강 노드 PHOTOCARD_SET 1행·NAMECARD_STD 2행 | 변형조합 견적불가 의심 | gap-board G-5 |

**총 강조 누락 = 7유형** (미바인딩 10상품 + 공식 2 + 옵션단절 6+ + 패밀리결함 3 + 희소 2).

---

## 4. 정합 검증 체크리스트 (hrv-validator R3)

- [ ] 각 이미지가 대응 mermaid의 missing 강조를 빨강/점선으로 반영했는가
- [ ] 이미지에 mermaid에 없는 노드/엣지가 환각 추가되지 않았는가
- [ ] 미바인딩 10상품 코드(019·030·034·035·036·037·038·039·040·049)가 이미지에 정확히 표기됐는가
- [ ] 단가행 수치(212/56/1/2)가 이미지에서 왜곡되지 않았는가
- [ ] G-4 결함 3종(F-1/F-2/F-3)이 이미지 콜아웃에 모두 존재하는가
- [ ] 이미지 파일이 0바이트/손상 아닌 유효 PNG인가 (`file *.png`)
