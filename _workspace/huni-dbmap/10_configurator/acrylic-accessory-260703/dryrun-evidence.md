# DRY-RUN 증거 — 아크릴 부속 갭 통합 교정 (롤백전용, COMMIT 없음)

> 2026-07-03 라이브 롤백전용 트랜잭션(`BEGIN … ROLLBACK`) + 로컬 read-only 제약검사.
> [HARD] 어떤 것도 persist 안 됨(롤백 확인). 실 COMMIT = 인간 승인 + webadmin 실화면 후.

## 1. 로컬 read-only 제약검사 (사전)

| 검사 | 결과 | 증거 |
|------|------|------|
| 옵션그룹 PK 충돌 (6쌍) | **0건** | `(147,OPT_000074)…(154,OPT-000014)` 라이브 미존재 |
| 옵션 PK 충돌 (9쌍) | **0건** | `(147,OPV_000465)…(154,OPV-000028)` 라이브 미존재 |
| sel_typ_cd FK | **valid** | SEL_TYPE.01(단일) 실재(t_cod_base_codes) |
| 부속 단가행 OPV 실재 | **전건 실재** | `component_prices.opt_cd`: OPV_000465(800)·466(600)·467(1000)·468(700)·469(2600)·470(3000)·471(700)·472(1700)·OPV-000028(500) |
| 전용공식 실재·use_yn | **전건 Y** | PRF_ACRYL_MAGNET/BADGE/CLIP/SMARTTOK/NAMETAG/HAIRBAND · PRF_CLR_ACRYL |
| option_items 트리거 리스크 | **없음** | 부속 옵션은 option_items 미생성(opt_cd 직결) → fn_chk_opt_item_ref 미발동 |
| 151 본체 격자정합 | **정합** | 자재 MAT_000043(활성)·사이즈 50×50/60×60/70×60 = CLEAR3T MAT_000043 격자(196행) 커버 |
| 146 MAT_000386 격자행 | **0행**(silent-0 원인) / MAT_000043 = 196행 | GB-3 근거 |

## 2. 라이브 롤백전용 DRY-RUN (전체 load 실행 → ROLLBACK)

`load.sql` 동일 연산을 단일 트랜잭션으로 실행, 트랜잭션 내부 검증 후 ROLLBACK.

```
BEGIN
UPDATE 1  -- GB-3 146 MAT_000043 재활성
UPDATE 1  -- GB-3 146 MAT_000386 은퇴
INSERT 0 6  -- GB-2 옵션그룹 6
INSERT 0 9  -- GB-2 옵션 9
UPDATE 1 ×6 -- GB-2 재바인딩 6
INSERT 0 1  -- GB-1 151 바인딩
```

트랜잭션 내부 검증(SELECT):

| 항목 | 기대 | 실측 |
|------|------|------|
| groups_inserted | 6 | **6** PASS |
| options_inserted | 9 | **9** PASS |
| rebinds (PRF_ACRYL_*) | 6 | **6** PASS |
| 151_bound | 1 | **1** PASS |
| 146_body_mat_043_active (del_yn='N') | 1 | **1** PASS |
| 146_mat_386_retired (del_yn='Y') | 1 | **1** PASS |

- **에러 0** — INSERT/UPDATE 전건 성공, 제약·FK·NOT NULL 위반 없음. 트리거 미발동(option_items 없음).

## 3. ROLLBACK 무영향 확인 (사후)

| 항목 | 기대 | 실측 |
|------|------|------|
| 146 MAT_000043 del_yn (원상) | Y(삭제 유지) | **Y** — persist 안 됨 |
| 151 바인딩 수 (원상) | 0 | **0** — persist 안 됨 |

→ **삽입성·멱등·롤백 무영향 실증. GO(적재 준비 완료), 단 인간 승인 대기.**

## 4. 미포함(escalate) — DRY-RUN 대상 아님
- 146 부속(고리·볼체인) 배선: [146-D1]·[146-D2] 결정 후 별도(design.md §3.4).

## 5. 커버리지 검증 유의 (COMMIT 후 필수)
DRY-RUN은 삽입성만 증명. **가격 반영**(부속비 실제 가산)은 webadmin 가격시뮬레이터로 검증해야 함:
- 147 마그넷: 자석부착 선택 → 본체 + 800×수량. 149/154 동일(단일 mand).
- 148/150/152: 옵션 택1별 부속가 반영(라벨 [CONFIRM-B] 확정 후).
- 151: 본체 PRICE≠0(부속 0).
- 146: 본체 PRICE≠0(자재 정상화). 부속 미반영(escalate 대기).
