# commit-log.md — §21 포토카드 과대청구(V3) 교정 라이브 COMMIT 기록

> §21 카탈로그 정합 · 2026-06-23 · **인간 승인 완료(momentum) → 라이브 운영 DB 실 COMMIT**.
> 대상: PRD_000024(포토카드)·PRD_000025(투명포토카드) · 공식 PRF_PHOTOCARD_FIXED.
> 프로토콜: dbm-load-execution 안전 시퀀스(백업→채번 재실측→DRY-RUN→COMMIT→사후검증→undo 보유).
> 선례: `_overcharge_foldcard_260623`(접지카드 V2)와 동일 안전 프로토콜.

---

## 0. 실행 결과 한 줄

024(일반)·025(투명)가 같은 PRF_PHOTOCARD_FIXED에 바인딩되고 판별축 전무 → 일반(6,000)+투명(8,500)
**둘 다 매칭 silent 합산(14,500 과대)**이던 결함을, **상품별 공식 분리**(PRF_PHOTOCARD_NORMAL/CLEAR 신설
+ 바인딩 재배선 + 고아 FIXED use_yn=N)로 해소 → **024=6,000·025=8,500**. **단가값 0변경(verbatim)** ·
COMMIT 성공 · 멱등 확인 · undo 보유.

---

## 1. 안전 시퀀스 단계별 결과

| 단계 | 내용 | 결과 |
|------|------|------|
| 0. 물리 백업 | 변경 대상 현재값 timestamped SELECT 스냅샷 | `backup-20260623_013932.sql` (공식·바인딩·FC·단가행 기준선 캡처) |
| 1. 채번/SBM 재실측 | PRF_PHOTOCARD_NORMAL/CLEAR 충돌·동명 frm_nm 재확인(stale 방지) | **신규 2개 미실재·동명 0·충돌 0**. 024/025 각 1행·2026-06-01 |
| 2. Phase A (FK 선행) | 신규 공식 2 멱등 INSERT | **INSERT 2건** (ON CONFLICT (frm_cd) DO NOTHING) |
| 2. Phase B | FC 배선(NORMAL←SET·CLEAR←CLEAR_SET) | **INSERT 2건** (comp 재사용·신규 0) |
| 3. Phase C/D | 바인딩 재배선 2 + 고아 FIXED use_yn=N | **UPDATE 3건** (단가행 SET 0) |
| 4. DRY-RUN 재확인 | ROLLBACK·멱등·FK·verbatim·가격 | 14,500→6,000/8,500·verbatim PASS·멱등 2회 0행·FK 고아 0 |
| 5. ★COMMIT | apply.sql COMMIT 모드 | **COMMIT 성공 (exit 0)**·G-1/G-2 트랜잭션 내 PASS |
| 6. 사후검증 | 별도 연결 영속 확인 | 전 항목 PASS (§ post-verify.md PV-1~6) |
| 7. undo 보유 | 되돌리기 스크립트 | `undo.sql` (DRY-RUN 검증·미실행) |

## 2. 채번/search-before-mint 재실측 (stale guard)

```
PRF_PHOTOCARD_* 실재 → PRF_PHOTOCARD_FIXED 1건만 (NORMAL/CLEAR 미실재)
동명 frm_nm('일반/투명포토카드 세트 고정가') → 0행 (멱등 INSERT 안전)
024/025 바인딩 → 둘 다 PRF_PHOTOCARD_FIXED·apply_bgn_ymd=2026-06-01·각 1행
두 comp(SET/CLEAR_SET) → PRF_PHOTOCARD_FIXED 에만 배선(공유충돌 0·클래스 A)
```

## 3. Phase A/B — 신규 공식 2개 + FC 배선 (멱등)

| frm_cd | frm_nm | use_yn | FC 배선(자기 comp 1개만) |
|--------|--------|:--:|------|
| PRF_PHOTOCARD_NORMAL | 일반포토카드 세트 고정가 | Y | COMP_PHOTOCARD_SET (6,000) |
| PRF_PHOTOCARD_CLEAR | 투명포토카드 세트 고정가 | Y | COMP_PHOTOCARD_CLEAR_SET (8,500) |

- comp/단가행 **기존 재사용**(신규 단가행 0·단가값 verbatim).

## 4. Phase C/D — 바인딩 재배선 + 고아 처리 (verbatim 불변)

| 대상 | before | after |
|------|--------|-------|
| BIND PRD_000024 | PRF_PHOTOCARD_FIXED | **PRF_PHOTOCARD_NORMAL** |
| BIND PRD_000025 | PRF_PHOTOCARD_FIXED | **PRF_PHOTOCARD_CLEAR** |
| FRM PRF_PHOTOCARD_FIXED | use_yn=Y | **use_yn=N** (고아 비활성·FC 배선 보존) |

- ★`t_prc_price_formulas`에 **del_yn 컬럼 부재** → 논리비활성은 **use_yn='N'**으로 수행([[dbmap-del-yn-soft-delete-authority]]와 달리 이 테이블은 use_yn만 존재).
- BIND는 frm_cd만 UPDATE(PK prd_cd+apply_bgn_ymd 불변) → apply_ymd 분기 이중계상 함정 회피.
- **unit_price SET 구문 0개** · 단가행 SET=6,000·CLEAR_SET=8,500 불변.

## 5. COMMIT 명령 출력 (요약)

```
BEGIN → INSERT 0 1 ×2(FRM) / INSERT 0 1 ×2(FC) → UPDATE 1 ×3(BIND2+FIXED1)
NOTICE: VERBATIM GUARD PASSED → NOTICE: FK/WIRE/BIND GUARD PASSED → COMMIT  (exit 0)
```

## 6. 가격 영향 (사후검증 실측)

| 상품 | 교정 전 (silent 합산) | 교정 후 (정답) | 과대 해소 |
|------|:--:|:--:|:--:|
| 024 포토카드 | 14,500 | **6,000** | −8,500/세트 |
| 025 투명포토카드 | 14,500 | **8,500** | −6,000/세트 |

## 7. 되돌리지 말 것 (메모리용)

- t_prc_price_formulas **PRF_PHOTOCARD_NORMAL·PRF_PHOTOCARD_CLEAR** 신규 행(use_yn=Y) 보존.
- **PRF_PHOTOCARD_FIXED use_yn=N**(고아 비활성) 보존 — 되돌리지 말 것(되살리면 silent 합산 재발).
- BIND **024→NORMAL·025→CLEAR** 재배선 보존.
- FC 배선 **NORMAL←COMP_PHOTOCARD_SET·CLEAR←COMP_PHOTOCARD_CLEAR_SET** 보존(comp/단가행 재사용·verbatim).
- 이 교정으로 PRD_000024/025 포토카드 silent 합산 14,500 과대청구 해소(택일=6,000/8,500).
- 되돌릴 경우만 `undo.sql`(위상 역순: BIND→FIXED 원복 → 신규공식 use_yn=N).
- ★t_prc_price_formulas는 del_yn 컬럼 없음 — 논리삭제=use_yn='N'.
