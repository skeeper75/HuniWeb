# 별색 dedup (U5') 실행본 — Phase D 독립 검증 verdict (R1~R6) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립. **실 COMMIT 직전 게이트.**
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. 형제↔정본 단가는 라이브 field-for-field 대조. COMMIT 0·비밀값 비노출.

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

R1~R6 전건 PASS(라이브 독립 재현). **DELETE37/UPDATE10 일치·2-pass delta 0·재적재 0(형제 9 단가 477행 전건 정본 부분집합·diff 0·물리삭제 0)·가격 불변(WHITE_S1이 29공식 전부 동반 배선·양면화이트 보존)·spot dangling 0·comp_nm 보정·COMMIT 0** 모두 실측. BLOCKER 0. (pre-existing 미싱 dangling 4건은 balsaek 스코프 외 — 별 라우팅.)

---

## R1 멱등성 (2-pass) — **PASS**
단일 ROLLBACK tx 내 U5p-1~3 2회 적용. **PASS2 전건 0**:
```
PASS2: DELETE 0 · DELETE 0 · UPDATE 0 · UPDATE 0
```
멱등키: U5p-1=DELETE 대상 행만(재실행 부재) · U5p-2=`use_yn<>'N'`만 · U5p-3=`comp_nm<>'별색인쇄비'`만. 생성자 주장 일치.

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i U5p-1→U5p-2→U5p-3; ROLLBACK`. `ON_ERROR_STOP on`. 3 유닛 BEGIN/COMMIT/ROLLBACK 0건 → 중첩 tx 0. **순서 정합(배선 제거 선행 → use_yn=N)** = use_yn=N comp의 잔존 배선 0(spot dangling 방지).

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 라이브 일치: 정본 WHITE_S1 530행(5 proc × 2 popt × 53 band) 실측·형제 9 comp 각 53행·comp_cd 유지(rename은 comp_nm만→FK 연쇄 0).

## R4 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 DRY-RUN:
```
U5p-1 DELETE 8(8색 형제 PRF_DGP_A) + DELETE 29(WHITE_S2 29공식) = DELETE 37
U5p-2 UPDATE 9(형제 use_yn=N) · U5p-3 UPDATE 1(comp_nm) = UPDATE 10
단가행 DELETE/INSERT/이설 0 · ERROR 0 · ROLLBACK
```
생성자 보고(DELETE37·UPDATE10·재적재0)와 **전건 일치**.

## R5 ★재적재 0 + 단가행 보존 (돈-크리티컬) — **PASS**
- **흡수 = 부분집합 관계 실측**: 정본 WHITE_S1 = 5색(PROC_000008~012) × 2면(POPT_000001/002) × 53 = 530행. 형제 9는 각 (1 proc × 1 popt × 53):
  CLEAR_S1=proc009/popt001 · CLEAR_S2=proc009/popt002 · GOLD=011 · PINK=010 · SILVER=012 · WHITE_S2=proc008/popt002.
- **value-lossless field-for-field 실측**: 9 형제 전부 53행이 정본 동일 (proc,popt,min_qty) 슬라이스와 **match 53·mismatch_or_missing 0**. → 정본이 형제 단가 전건 동일값 보유.
- **물리삭제 0**: U5p-2는 use_yn=N만(DELETE 아님). 형제 단가행 **477(9×53) 전건 보존** 실측. 재적재 0·이설 0·INSERT 0 정당(정본에 이미 실재).

## R6 ★가격 불변 + dangling 0 — **PASS**
- **★WHITE_S2 29공식 정정 검증(핵심)**: WHITE_S2가 배선된 **29공식 전부가 WHITE_S1도 동반 배선**(29/29·미동반 0건 실측). WHITE_S1이 proc008+POPT_000002(양면 화이트) **53행 보유** → WHITE_S2 제거해도 엔진이 WHITE_S1의 proc008/popt002 슬라이스로 양면 화이트 조회(R5 diff 0). **가격 불변·dangling 0**.
- **spot dangling 0**: use_yn=N spot comp가 formula_components에 잔존 = 0(배선 제거 선행 효과). 8색 형제는 PRF_DGP_A 1배선만(실측) → 제거 후 정본 WHITE_S1로 5색 전부 조회(proc_cd 색 매칭).
- **정본 무변경**: master 530행·use_yn=Y·comp_nm='별색인쇄비'(보정 적용)·wiring 29 무변경. PRF_DGP_A 별색 = COMP_PRINT_SPOT_WHITE_S1 1개로 축소.
- **동시매칭 0**: 형제 use_yn=N → 엔진 제외 → 정본 1 comp만 활성·(proc,popt,min_qty) 단일 매칭.

---

## 미해소 차단 / 컨펌 + pre-existing 관찰
| ID | 항목 | 상태 | 라우팅 |
|----|------|------|--------|
| (BLOCKER 0) | — | 실 COMMIT 차단 사유 없음 | — |
| OBS-1 | **pre-existing 미싱 dangling 4건**: COMP_PP_PERF_2L/3L(use_yn=N)가 PRF_DGP_A/PRF_DGP_D에 배선 잔존 | **balsaek 스코프 외**(spot-color 아님·G-D2/W5 트랙이 PERF_2L/3L use_yn=N 후 PRF_DGP 배선 미제거). 라이브에 이미 존재(이 run 무관). spot dangling은 0 | dbm-load-builder(W6/W5 후속·PRF_DGP PERF 배선 정리) |

## undo 충분성 — **충분(물리삭제 0·메타 복원)**
물리삭제 0(comp/단가행 전부 보존)이라 undo는 메타만: use_yn N→Y(9)·comp_nm 원복·제거 37 배선 재INSERT. 백업 2 TSV(pre_components 10·pre_formula_components 66=spot 전 배선) → 37 배선 재INSERT 충분. 데이터 손실 위험 0.

## 실 COMMIT 절차 안전성 — **PASS**
`apply.sh --commit` = `sed 's/^ROLLBACK;/COMMIT;/'`. apply.sql `^ROLLBACK;` 정확히 1건(terminal). 비밀값 `.env.local`만·비노출. ON_ERROR_STOP=1.

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| DELETE37·UPDATE10·재적재0 | 보고 | **동일** | 일치 |
| 형제 9 = 정본 부분집합·diff 0 | 주장 | **9 형제 전건 match 53·mismatch 0** | 일치 |
| WHITE_S2 29공식·WHITE_S1 동반·가격 보존 | 정정 주장 | **29/29 co-wired·양면화이트 53행·미동반 0** | 일치 |
| 물리삭제 0·477 보존 | 주장 | **확인** | 일치 |
| spot dangling 0·정본 530 무변경·comp_nm 보정 | 주장 | **확인** | 일치 |
| 2-pass0·COMMIT0 | 주장 | **확인** | 일치 |
| (신규 관찰) pre-existing 미싱 dangling 4 | 미언급 | **balsaek 스코프 외·라우팅** | 보완 권고 |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·형제↔정본 field-for-field 대조·29공식 co-wiring 실측·dangling 라이브 확인.

---

### 최종: **GO — 실 COMMIT 가능**
R1~R6 전건 PASS·BLOCKER 0. 인간 최종 승인 시 `apply.sh --commit` 가능. COMMIT 후 사후검증(정본 530 무변경·형제 9 use_yn=N·PRF_DGP_A 별색=WHITE_S1 1개·양면화이트 가격 불변) 권고. pre-existing 미싱 dangling 4건은 별 트랙(load-builder)로 정리 권고(balsaek 무관).
