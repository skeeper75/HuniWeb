# round-17 개선안 A 적용 로그 — note 쉬운 한국어 반영 (라이브 COMMIT)

> 적용 2026-06-13 · 사용자 승인("핸드오프 개선안 쉬운 용어로 실제 반영", 범위 = note 16건). 비파괴·멱등.

## 무엇을 했나
- `t_prc_price_formulas` 16공식의 `note`(비고)를 내부 행번호("계산공식집초안 행N")·영문약어(comp/mat) 섞인 문장 → **비전문가가 바로 읽는 쉬운 한국어**로 교체.
- frm_nm(공식명)은 이미 한국어 양호 → 변경 안 함. B(떡메 바인딩)·C(frm_typ_cd DDL)는 컨펌(Q-1/Q-2) 미해소라 **이번 범위 밖**.

## 절차 (안전)
1. 백업: 적용 전 라이브 note 16건을 `rollback-note.sql`로 추출(현재값 복원 UPDATE문).
2. DRY-RUN: `apply-note.sql`을 BEGIN…ROLLBACK으로 감싸 16행 영향·제약위반 0 확인.
3. 적용: `psql -f apply-note.sql` → `BEGIN` … `UPDATE 1`×16 … `COMMIT` (exit 0).
4. 검증: 라이브 재조회 = 개선안 값 일치. 내부행번호 잔존 0·영문약어 잔존 0·빈 note 0.

## 멱등·롤백
- 멱등: 같은 값 재실행해도 note 불변(upd_dt만 갱신).
- 롤백: `psql -f rollback-note.sql` 실행 시 적용 전 원문으로 복원.

## 파일
- `apply-note.sql` — 적용본(실행 완료).
- `rollback-note.sql` — 적용 전 백업(복원용).

## 미적용(컨펌 대기 — 인간/도메인 결정)
- B-1 떡메모지 바인딩 INSERT (Q-1 상품 정체·적용시작일).
- B-2 212 NONE 상품 가격공식 신규 (round-16 시트별 적재 트랙).
- C frm_typ_cd 백필 (DDL·dbm-ddl-proposer·Q-2).
