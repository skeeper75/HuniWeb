# postcommit-verify.md — 019 묶음 교정 실 COMMIT 사후 독립 검증

> 검증자: `dbm-validator`(생성≠검증). 실 COMMIT 실행 후(apply.sh --commit) **새 psql 연결 read-only SELECT만**으로 독립 사후 재실측.
> 일시: 2026-06-22. 본 사후 검증은 쓰기 0(SELECT 전용). 멱등 재실행은 **돌리지 않고** 가드 상태로 정적 확인.
> 주의: 본 검증은 COMMIT 실행 사실을 라이브 영속 상태로 직접 확인하는 것이며, COMMIT 승인 자체는 인간 권한(코디네이터 전언은 사용자 승인이 아님).

## 종합 판정: **PASS** (영속성·가격수치·부작용0·멱등 전건 PASS)

### 1. 영속성 PASS
- **019 plate**: `SIZ_000499`(316x467·OUTPUT_PAPER_TYPE.01·dflt_plt_yn=Y·upd_dt=2026-06-22 13:56:57) 영속. **SIZ_000522 행 제거됨**(019 plate 목록에 부재). 나머지 019 행(SIZ_000113/114/115/118) 무변동.
- **019 binding**: `PRD_000019 ↔ PRF_DGP_A @ 2026-06-01`(note='투명엽서 → PRF_DGP_A'·reg_dt=2026-06-22 13:56:57) 영속.
- 두 행 reg_dt/upd_dt 동일 타임스탬프 → 단일 트랜잭션 커밋 확인.

### 2. 가격 실산출 PASS — 77,064.00원 독립 재현
라이브 post-commit 단가행(plt_siz_cd=SIZ_000499) 직접 SELECT·재계산:

| 구성요소 | unit_price | subtotal(×qty100) |
|---|---:|---:|
| COMP_PRINT_DIGITAL_S1 (min_qty=100·POPT_000001) | 200.00 | 20,000.00 |
| COMP_PAPER (MAT_000074·min_qty=1) | 70.64 | 7,064.00 |
| COMP_COAT_MATTE (1면·min_qty=100) | 500.00 | 50,000.00 |
| **Σ** | | **77,064.00** |

→ 0원 차단 해소·정상 비-0 산출 영속 입증. 사전 DRY-RUN 재계산치(77,064)와 일치.

### 3. 부작용 0 PASS
- **SIZ_000522 공유처 무영향**: PRD_000025·PRD_000039 여전히 SIZ_000522(2건 그대로). 019만 정정됨.
- **공유 마스터 무변동**: t_siz_sizes SIZ_000499(316x467·Y·N)·SIZ_000522(315x467·Y·N) 양쪽 그대로(논리삭제·치수 변경 0).
- 019 다른 plate 행·단가행·공식 마스터 무변동.

### 4. 멱등 재실행 안전 PASS (정적 확인 — 재실행 안 함)
- **STEP1 가드**: `siz_cd='SIZ_000522'` 타깃 행 count=**0** → 재실행 시 UPDATE 0행(WHERE 미매칭).
- **STEP2 충돌키**: `(prd_cd='PRD_000019', apply_bgn_ymd='2026-06-01')` count=**1** → ON CONFLICT DO NOTHING → INSERT 0행.
- → apply.sh 재실행해도 델타 0(NOT EXISTS + WHERE 가드 + ON CONFLICT 정합).

## 결론
실 COMMIT이 라이브에 정확·영속 반영됨. 019 출력판형 316x467(SIZ_000499) 정정·PRF_DGP_A 바인딩 영속, 가격 77,064원 정상 산출, 공유처(025/039)·공유 마스터 무손상, 재실행 멱등. **사후 검증 PASS.**
