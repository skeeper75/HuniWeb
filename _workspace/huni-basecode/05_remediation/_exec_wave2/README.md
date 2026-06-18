# `_exec_wave2/` — Wave 2 교정 실행본화 (전건 ESCALATE)

후니 기초코드 거버넌스 Wave 2(축이동: R8 인쇄면→print_side·R9 구수→bundle·R7 dtl_opt param)를
라이브 적재용으로 실행본화하려 했으나, **라이브 읽기전용 실측 결과 전건 라이브 직접(경로 X)
부적격**으로 판정 → 안전 실행본 0건·전건 경로 Y/선결 escalate.

## 왜 실행본이 없는가 (한 줄)

로드맵은 "그릇 실재 = 즉시 라이브 직접"으로 봤으나, 라이브에서 **대상 상품의 목적지 행이
전무**(print_options 0행·bundle_qtys 0행·option_items 0행)였다. 따라서 축이동 = 빈 목적지에
**무소스 신규 INSERT**이고, 그 INSERT가 소스에 없는 NOT NULL 값(R8 도수 front/back colrcnt·
R9 dflt_yn/2개1팩 해석·R7 AX-5 범위)을 요구한다 → 날조 금지(HARD) → 라이브 직접 부적격.

## 파일

| 파일 | 읽는 순서 |
|------|:--:|
| `_deferred.md` | **1** — 안전 판정·escalate 사유(필독) |
| `manifest-wave2.md` | 2 — 산출 요약·DRY-RUN 결과 |
| `_backlog-pathY.md` | 3 — 경로 Y 근본 교정 백로그 |
| `diagnose_wave2.sql` / `apply_wave2.sh` | 근거 재현(READ-ONLY) |

## 사용 (READ-ONLY 진단만)

```
./apply_wave2.sh diagnose     # 라이브 읽기전용 — escalate 근거 재현(쓰기 0)
./apply_wave2.sh commit       # STOP — 안전 실행본 없음(exit 1)
```

`.env.local`의 `RAILWAY_DB_*` 자격증명 사용(stdout 미노출). 쓰기 0·COMMIT 0.

## 다음 단계 (인간 결정)

1. **R8/R9** → 경로 Y(`dbm-axis-staged-load`): 개발자가 v03에서 인쇄면/구수를 올바른 칸으로
   재인코딩(R8 도수 권위 확정·R9 dflt/2개1팩 결정 선결) 후 재적재. R8 재적재 후 `dbm-price-arbiter` 골든 재현.
2. **R7** → AX-5 범위 컨펌 + option_items 선적재 후 `dbm-load-execution`/`dbm-cpq-option-mapping`.
3. 본 산출은 `hbg-validator` B1~B6 독립 게이트 대상(자기검증 금지).
