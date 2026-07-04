# 프린틀리 전반부 종단 파일럿 (Stage 2 재료)

> 작성: 2026-07-04 · PART 1(온톨로지 설계) + PART 2 브릿지 위에서, 전반부를 **자동으로 도는 데모**로 굳힌 것.
> 시스템 로드맵 크리티컬 패스(Stage 2 질의 시뮬레이터)의 최소 실현체(P1 파일럿).

## 무엇인가

라이브 길찾기(사람이 손으로)를 **프로그램이 자동으로** 하는 것: **업종 → (추천 층 순회) → 홍보물 후보 → 실엔진 견적**.

| 구성 | 파일 | 역할 |
|---|---|---|
| 추천 층(선언 데이터) | `recommendation-layer.json` | 업종→기능→홍보물 references 엣지(dominance/fit). **원칙 1: 로직 아님 데이터**. 순회만 실행기 |
| 종단 실행기 | `run_front_half.py` | 층 순회 + **evaluate_price(엔진) 실견적** + 근거 경로(node_id) + 되묻기 게이트 |

## 실행

```bash
raw/.venv/bin/python _workspace/printly/pilot/run_front_half.py <업종> [수량] [기능]
# 예: … 미용실 100      (단골관리 지배·되묻기 불필요)
#     … 카페 300        (오픈+단골 둘 다 지배 → 되묻기 게이트 발동)
```
- 라이브 읽기전용(그래프 SELECT + 견적 호출). `.env.local` RAILWAY_DB_*로 DATABASE_URL 자동 조립·비밀값 미출력.
- webadmin venv(`raw/.venv`·django 5.2) 필요.

## 무엇을 증명하나

- ✅ **설계(Step 2 관계·Step 3 제약)가 자동으로 실동** — 업종→기능→홍보물이 데이터 순회로 돌고, 견적이 실엔진 값(source=FORMULA).
- ✅ **되묻기 게이트** — 카페처럼 지배 목적이 복수면 "먼저 되물어 좁힘"을 발동(에이전트 절차·Step 2 §5).
- ✅ **근거 경로 병기** — 매 추천에 `업종 → 기능 → product(prd_cd)` node_id 경로(원칙 4·지어내기 차단).
- ✅ **시스템 Stage 2 재료** — 이 파일럿이 크리티컬 패스의 최소 실현. NL 파싱·순위 엔진을 얹으면 로드맵 Stage 2/3.

## ★실행이 드러낸 것 (정직 기록·생성≠검증)

| 발견 | 내용 | 판정 |
|---|---|---|
| **프리미엄명함·펄명함 견적 0원** | `PRD_000031`·`PRD_000034`가 source=FORMULA인데 final_price=0 | 🔴 **실 결함**(미배선/단가 갭). 로드맵 G-DATA "프리미엄명함 견적0" 기존 갭과 **일치** — 파일럿이 진단 도구로도 작동 |
| 만년스탬프 90만원(100개)·270만원(300개) | 개당 9,000원 고정가 | 제약 아님·**되묻기 사안**(수량 현실성). Step 3 경계표 실증 |
| 스탠다드명함 3,500(100)→10,500(300) | 정상 견적 | ✅ 엔진 정상 |

- **[HARD] 0원은 숨기지 않는다**(0=결함 신호). 파일럿이 전반부 추천을 돌리다 **실 데이터 갭을 자동 적발** — 추천 데모 + 커버리지 진단 이중 효과.

## 경계 · 다음

- 순위 = **dominance/fit 결정론 placeholder**. 최종 순위 = 엔진 몫(recommendation_function 보류·D-REC). LLM 순위 금지(원칙 3).
- 입력 = 업종 키(카페/미용실/음식점). **NL 파싱은 후속**(현재는 업종 직접 지정).
- 추천 층 = candidate badge(N≥3 승격 전). 기능→홍보물 매핑 근거 = `research/industry-classification.md`.
- **다음 후보**: ① 프리미엄명함 견적0 결함 후속(가격 하네스) ② intent 원자 분해 정밀화 ③ NL 파싱 진입 ④ 순위 엔진 착수.

## 근거
- 추천 층 스키마 = `03_step2-relations.md`(H1/H2 references·dominance/fit) · 제약 경계 = `04_step3-constraints.md`
- 엔진 = `raw/webadmin/webadmin/catalog/pricing.py evaluate_price` · 시스템 = `_foundation/SYSTEM-IMPLEMENTATION-ROADMAP-260704.md`(Stage 2 크리티컬)
- product prd_cd = 라이브 t_prd_products 실측(2026-07-04)
