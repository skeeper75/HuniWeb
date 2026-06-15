# ready 클래스 전체 가격사슬 GAP 스캔 (round-20)

> 실행 2026-06-15 · 집계 SQL 1회(라이브 read-only). ready 58상품 14 가격클래스.
> 측정 = 클래스별 배선 comp 수 · 단가행 없는 comp 수 · 총 단가행 수.

## 스캔 결과

| 가격공식 | 상품 | 배선comp | 단가없는comp | 총 단가행 | 판정 |
|----------|---:|---:|---:|---:|------|
| PRF_DGP_A | 9 | 29 | 0 | 1410 | ✅ 완비(GAP 0 실증) |
| PRF_DGP_D | 1 | 20 | 0 | 903 | ✅ 완비 |
| PRF_DGP_E | 3 | 10 | 0 | 879 | ✅ 완비 |
| PRF_DGP_C | 3 | 5 | 0 | 551 | ✅ 완비 |
| PRF_DGP_B | 2 | 4 | 0 | 516 | ✅ 완비 |
| PRF_GANGPAN_FIXED | 1 | 1 | 0 | 370 | ✅ 완비(합판) |
| PRF_STK_FIXED | 3 | 1 | 0 | 258 | ✅ 완비(스티커) |
| PRF_PCB_FIXED | 1 | 2 | 0 | 234 | ✅ 완비(엽서북) |
| PRF_FOLD_SUM | 1 | 1 | 0 | 48 | 🟡 적음 |
| PRF_ENV_MAKING | 1 | 1 | 0 | 40 | 🟡 적음(봉투) |
| PRF_BIND_SUM | 4 | 1 | 0 | 8 | 🔴 빈약(제본 4상품·8행) |
| PRF_NAMECARD_FIXED | 3 | 2 | 0 | 4 | 🔴 빈약(명함 STD만·23 comp 미배선) |
| PRF_PHOTOCARD_FIXED | 2 | 2 | 0 | 2 | 🔴 빈약 |
| **PRF_POSTER_FIXED** | **28** | **1** | 0 | **1** | 🔴 **최대 GAP(28상품·단가행 1)** |

## 해석 — 양분된 그림

**comp-레벨 GAP = 0** (전 클래스: 배선된 comp는 단가행 보유). 즉 "배선 단절+단가 없음" 결함은 없음. 그러나 **단가행 총량이 클래스별로 극단적**:

### ✅ 완비 군 (단가행 풍부) — 배치 GAP 적음
DGP_A~E 합산형(여러 comp·수백~천 행)·STK/GANGPAN/PCB 고정가(comp 1~2이나 단가행 수백). PRF_DGP_A가 실증했듯 **배치로 채울 단가행 GAP 거의 0** — 가격 데이터 건강.

### 🔴 GAP 군 (단가행 빈약) — 배치/교정 대상
- **PRF_POSTER_FIXED — 28상품인데 comp 1·단가행 1행.** 면적매트릭스(포스터사인)는 siz별 수십~수백 행이어야 하는데 1행 = **면적 단가행 사실상 미적재**(round-2 "포스터 28 면적-좌표 오모델"·round-18 "포스터 가격 미구성"과 정합). **최대 매출직결 GAP.** 단 단순 단가행 GAP이 아니라 **면적매트릭스 구조 적재**(round-16 import + siz 면적 차원) 필요.
- **PRF_NAMECARD_FIXED — comp 2(STD S1/S2)·단가행 4.** round-19 발견대로 명함종 23 comp(PREMIUM/COAT/FOIL 등) **미배선**(WIRE). 단가행이 아니라 **배선 GAP** → round-19 WIRE 큐(`_price-queue-closeout`).
- **PHOTOCARD 2행·BIND_SUM 8행** — 부분 빈약(정밀 점검 필요).
- ENV/FOLD 🟡 — 단건·적음.

## 결론 — 배치 우선순위

1. **배치할 단가행 GAP은 "완비 군"엔 거의 없다**(DGP_A 실증·전 완비 클래스 동일 예상). ready를 더 점검해도 GAP 0 반복 가능.
2. **진짜 GAP은 🔴 빈약 군**: POSTER(면적매트릭스 미적재·최대)·NAMECARD(배선 GAP)·PHOTOCARD/BIND.
3. **단, 빈약 군은 단순 동형 배치(종이비처럼)가 아님**: POSTER=면적매트릭스 구조 적재(round-16)·NAMECARD=배선(round-19 WIRE)·각자 다른 트랙. 배치 하네스의 "단가행 동형 일괄"이 바로 먹는 건 적고, 구조 적재/배선/교정이 선행.
4. **pending 189**(가격공식 NONE)가 여전히 최대 미반영분 — 가격공식 구성(round-16/2)이 본류.

> 도메인 관점: 빈약 군이 결함이 아니라 **각자 다른 가격산정방식**(포스터=면적매트릭스·명함=고정가 명함종별·제본=합산)이 아직 단가행/배선까지 완성 안 된 것. 실무진이 가격표에 정리한 방식을 DB 구조로 옮기는 작업이 남은 것([[dbmap-print-domain-recipe-philosophy]]).
