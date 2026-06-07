# DRY-RUN 계획 — 실사/포스터사인 면적매트릭스 가격 적재 (price-211 Phase-1)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 성격 | **DRY-RUN 계획/SQL 까지만.** 실제 라이브 DRY-RUN 트랜잭션 실행·COMMIT·DDL적용·코드행등록은 **인간 승인** |
| 대상 SQL | `load.sql` (INSERTABLE 17행 한정) |
| 게이트 | R1 멱등 · R2 원자성 · R3 제약위반0 · R4 FK고아0 · R5 IDENTITY stale가드 · R6 COMMIT0 |

> [주의] 본 트랙은 검증(dbm-validator) 이전 **생성(generation)** 단계다. 아래 게이트는 설계자
> 자가점검이며, 독립 재검증은 별도 단계다. 아래 "설계자 사전점검(read-only)"은 허용된
> `BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK;` + 구문검증 DRY-RUN(`BEGIN; …; ROLLBACK;`)
> 로 이미 1회 수행했고 그 결과를 기록한다. **영구 변경 0.**

## 1. 적재 순서 (FK 위상정렬)

```
[단계 0] 부모 선존재 검증 (적재 아님)
   t_prc_price_components(comp_cd 13)  ← 라이브 선존재(round-2)
   t_siz_sizes(siz_cd 4: 320/321/323/403) ← 라이브 선존재
   t_prc_price_formulas(PRF_POSTER_FIXED) ← 라이브 선존재
   t_prd_products(13 prd_cd) ← 라이브 선존재
[단계 1] IDENTITY 시퀀스 재동기화 (setval, comp_price_id)
[단계 2] t_prc_component_prices INSERTABLE 17행 (ON CONFLICT DO NOTHING)
[단계 3] 멱등 자가점검 (정보용 SELECT)
```

상품바인딩(`t_prd_product_price_formulas`)·공식(`t_prc_price_formulas`)·구성요소
(`t_prc_price_components`)는 **라이브 선존재 → 신규 INSERT 없음**. 본 트랙은
`t_prc_component_prices` 단가 차원 행만 적재한다.

## 2. 설계자 사전점검 결과 (2026-06-07, read-only + 구문 DRY-RUN)

| 게이트 | 점검 | 결과 | 증거 |
|--------|------|------|------|
| 구문 | `BEGIN; load.sql; ROLLBACK;` psql 파싱 | **PASS** | `DO`/`setval`/`INSERT 0 17` 정상, 에러 0 |
| R1 멱등 | INSERTABLE 17행 ON CONFLICT | **PASS** | `INSERT 0 17` (전건 충돌, 0행 적재 — 멱등 no-op) |
| R5 IDENTITY | `setval(seq, MAX(comp_price_id))` | **PASS** | seq_last=4954 = MAX(comp_price_id)=4954 (이미 동기. 가드로 재확인) |
| 부모존재 | comp_cd 13 + siz 4 NOT EXISTS 검사 | **PASS** | 단계0 DO 블록 예외 미발생 |
| 라이브정합 | 17행 값 == 라이브 기존값 | **PASS** | 17/17 동일(예 ARTPRINT/SIZ_000321=21600.00, BANNER/SIZ_000323=8000.00) |
| R6 COMMIT0 | 트랜잭션 ROLLBACK | **PASS** | 영구 변경 0 (ROLLBACK 종결) |

> **멱등 INSERT 0 17 의 의미**: INSERTABLE 17행은 round-2 가 이미 적재한 4개 siz
> (320/321/323/403)에 해당하는 셀이며 값도 동일하다. 즉 본 트랙이 라이브에 추가하는
> 신규 가격행은 **0행**이다. 면적매트릭스 실데이터 본체(670행)는 siz 미등록으로
> **BLOCKED** 상태다(§3).

## 3. BLOCKED (인간 승인 후 별도 라운드)

| 산출 | 행수 | 차단 사유 | 해소 조건 |
|------|:--:|-----------|-----------|
| `load/t_siz_sizes_BLOCKED.csv` | 108 | 면적매트릭스 치수 108종이 t_siz_sizes 미등록 (search-before-mint: 라이브 검색 결과 부재) | 후니 siz 등록 인간승인 (제안코드 SIZ_000511~000618) |
| `load/t_prc_component_prices_BLOCKED.csv` | 670 | 위 108 siz 의존 (siz_cd FK 미충족) | siz 108 적재 후 동일 멱등 패턴으로 적재 |

BLOCKED 670행은 본 면적매트릭스의 **실데이터 본체**다. 차단을 침묵 드롭하지 않고
명시 분리한다(over-block/under-block 0). siz 발명 금지 — 제안코드는 "후니 등록 대기"
라벨이며 적재 SQL 미포함.

## 4. 인간 승인 시 실 적재 절차 (참고, 본 하네스 미실행)

```
1. (별도 승인) t_siz_sizes 108행 등록 → 확정 siz_cd 채번 (제안 SIZ_000511+ 또는 후니 정책)
2. load/t_prc_component_prices_BLOCKED.csv 의 제안 siz_cd → 확정 siz_cd 치환
3. apply.sh dryrun (롤백) 로 멱등 2-pass 재확인 (재실행 0행)
4. (인간 승인) apply.sh commit <runts> → 신규키 캡처(undo 대비) 후 COMMIT
```

본 하네스는 1~4 중 어느 것도 자동 실행하지 않는다. `load.sql`(INSERTABLE 17, no-op)
조차 COMMIT 하지 않는다.
