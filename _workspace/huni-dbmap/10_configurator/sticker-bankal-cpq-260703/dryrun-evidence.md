# DRY-RUN 증거 — 반칼 스티커 4상품 CPQ 옵션 레이어 (round6-sticker-bankal-cpq-260703)

라이브 Railway DB에서 **롤백전용** 트랜잭션으로 실측. COMMIT 없음(전부 ROLLBACK). 읽기 외 영속 변경 0.

## 사전 read-only 차원행 확인 (트리거 `fn_chk_opt_item_ref` 의 EXISTS 검사와 동일)

- 자재(OPT_REF_DIM.03): 4상품 각 5종 활성(del_yn='N'), usage_cd 전부 `USAGE.07`.
  - 059/060/061: MAT_000153(유포)·MAT_000084(비코팅)·MAT_000242(미색)·MAT_000155(무광코팅)·MAT_000156(유광코팅)
  - 062: MAT_000584(유포)·MAT_000611(아트)·MAT_000609(미색)·MAT_000585(무광코팅)·MAT_000586(유광코팅)
- 도수(OPT_REF_DIM.06): 4상품 각 `opt_id=1`(단면) 활성 존재.
- 공정(OPT_REF_DIM.04): 059/060/061 `PROC_000055`(스티커완칼) 활성 · 062 `PROC_000122`(반칼커팅) 활성.
- 트리거는 del_yn 필터 없이 EXISTS 만 검사(함수 원문 확인). 그래도 본 설계는 **활성행만** 참조.

## DRY-RUN #1 — 적재 + 카운트 검증 + ROLLBACK

`load.sql`(COMMIT 제거) 을 `BEGIN … ROLLBACK` 안에서 실행. 결과:

```
BEGIN
UPDATE 1      -- 062 은퇴 option_items (OPV-000087 1건)
UPDATE 6      -- 062 은퇴 options (OPV-000082~087)
UPDATE 2      -- 062 은퇴 option_groups (OPT-000040/041)
INSERT 0 12   -- option_groups (059/060/061/062 × 3)
INSERT 0 28   -- options (× 7)
INSERT 0 28   -- option_items (× 7)  ← 전건 트리거 통과 = 모든 ref 차원행 정합
groups  PRD_000059  3
groups  PRD_000060  3
groups  PRD_000061  3
groups  PRD_000062  3
options PRD_000059  7
options PRD_000060  7
options PRD_000061  7
options PRD_000062  7
items   PRD_000059  7
items   PRD_000060  7
items   PRD_000061  7
items   PRD_000062  7
062-retired-grp  2
ROLLBACK
```

- **핵심**: `INSERT 0 28` (option_items) 성공 = BEFORE INSERT 트리거 `fn_chk_opt_item_ref` 가 28개 참조를 전부 수용. 잘못된 키 슬롯/부재 차원행 0.
- EXIT=0, 마지막 `ROLLBACK` — 영속 변경 없음.

## DRY-RUN #2 — 멱등성 (동일 트랜잭션 2회 실행) + ROLLBACK

```
UPDATE 1 / UPDATE 6 / UPDATE 2     -- 1차 은퇴
INSERT 0 12 / INSERT 0 28 / INSERT 0 28   -- 1차 신규
UPDATE 0 / UPDATE 0 / UPDATE 0     -- 2차 은퇴 = 이미 del_yn='Y' → 0
INSERT 0 0 / INSERT 0 0 / INSERT 0 0   -- 2차 신규 = ON CONFLICT DO NOTHING → 0
ROLLBACK
```

- 2차 실행 전건 0 → **멱등**. 재실행 안전.

## 판정

| 항목 | 결과 |
|------|------|
| 트리거 정합(28 items) | PASS |
| 멱등성(ON CONFLICT) | PASS |
| 신규 자재/공정 mint | 0 (기존 mat_cd/proc_cd 재사용) |
| 코팅 자재 손님선택 커버 | PASS (무광/유광코팅이 4상품 종이 그룹에 포함) |
| 영속 변경 | 0 (전부 ROLLBACK) |

실 COMMIT = 인간 승인 + webadmin 실화면(제외 0·PRICE≠0·자재 드롭다운 노출) 확인 후 별도.
