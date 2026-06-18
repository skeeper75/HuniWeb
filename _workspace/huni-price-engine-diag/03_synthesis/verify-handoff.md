# 검증 트랙 인계 (huni-price-quote로)

> Phase 2 통합 (리더 종합) · 2026-06-18 · huni-price-engine-diag
> 본 하네스(이해·진단)가 좁혀준 의심점을 §13 검증 트랙(huni-price-quote)이 결론낼 수 있도록 인계.

## 1. 검증의 자(尺) 교정 [HARD]

직전 huni-price-quote 검증에서 검증자가 도수축을 오해(clr_cd로 찾아 0행)하고 엉뚱한 SIZ를 짚었다. 그 근원이 본 진단으로 규명됨:

- **설계 산출물(prcx01·pricing-erd)을 권위로 쓰지 마라 — STALE(8차원·clr_cd 시절).** 검증 기준 = 라이브 information_schema + pricing.py.
- **도수 = print_opt_cd(1431행)**, clr_cd 아님(0행 dead). 도수 관련 재계산은 print_opt_cd로.
- **현재 발화 경로 = FORMULA + 수량구간할인만.** 템플릿단가·직접단가·등급할인은 라이브 0행이라 검증 무의미(코드만 존재).

## 2. 좁혀진 검증 대상 (진단→검증 라우팅)

| 인계 항목 | 검증 트랙이 할 일 | 연결 |
|----------|------------------|------|
| **H-1 addtn_yn dead** | addtn_yn='N' 행 전수 조회 → 있으면 그 구성요소가 과대합산되는지 골든 재계산 | 직전 D-1/2/3 이중합산 근본 |
| **H-2 단가행 use_dims 정합(U-3)** | 구성요소별 use_dims 선언 ↔ 단가행 충전 차원 ↔ 권위축 3원 전수 대조 | hpq-price-chain-inspector 요구4 |
| **H-3 합가형 min_qty NULL(U-4)** | 합가형 구성요소 전수 min_qty NULL/0 점검(ValueError 위험) | engine-contract C3 |
| **H-4 proc_grp 토큰 비대칭(U-5)** | 36 comp가 "판별차원 없음" 오라벨 받는지 재현쿼리 | hpq 요구3 불필요분 |
| **H-5 도수 print_opt_cd 정합** | 엽서 도수 단/양면이 print_opt_cd로 가격 도달하는지 | 직전 EOP-1·N-1a |

## 3. 사용자/도메인 컨펌 선결 (검증 전 풀려야)

- **C-1 도수 = print_opt_cd 확정?** (clr_cd 완전 폐기 여부)
- **C-2 차감형(addtn_yn='N') 필요?** (필요시 개발자 백로그·엔진 수정)
- **C-3 수량구간 기준 = 출력매수 vs 주문수량?** (직전 N-1b 임포지션)

## 4. 개발자 백로그 후보 (코드=read-only oracle)

- **DEV-1 dim_vals 정식 DDL 추가** (현재 phantom-DDL, repo 재구축 시 누락 위험).
- **DEV-2 dsc_typ_cd DDL 위치 정정**(sql/01a:242 stale → master로).
- **DEV-3 proc_grp/opt_grp 토큰 처리 대칭화**(pricing.py:413/460).
- **DEV-4 설계 산출물 갱신**(prcx01·pricing-erd을 14차원·print_opt_cd·할인 순차곱 현행으로 — 또는 deprecated 표기).
- (조건부) **DEV-5 addtn_yn 엔진 반영** — C-2가 "차감 필요"면.

## 5. 결론 (본 하네스 범위)

본 하네스는 **결론을 내리지 않는다**(이해·진단까지). 위 H-1~H-5는 검증 트랙이, C-1~C-3은 사용자가, DEV-1~5는 개발자가 닫을 대상으로 정직히 분리했다. **장치 역할이 정의됐고(K-1~K-8), 모르는 것이 명시됐으므로(U-1~U-6), 이제 검증·적재가 오판 없이 진행할 토대가 섰다.**
