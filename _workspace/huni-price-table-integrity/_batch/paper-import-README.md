# 출력소재(IMPORT) 용지 절가 → COMP_PAPER 적재본

권위 = 인쇄상품 가격표 **출력소재(IMPORT)** 시트 (`06_extract/import-paper-l1.csv`).
목적 = 용지 절가(가격 국4절/3절)를 라이브 `t_prc_component_prices` `COMP_PAPER` 단가행에
**빠짐없이·verbatim·멱등** 적재. **DB 미적재 — 인간 승인 전 COMMIT 금지.**

## 산출물
| 파일 | 내용 |
|---|---|
| `paper-import-load.sql` | BEGIN…COMMIT. mat mint 0 + COMP_PAPER 절가 20행 멱등 INSERT |
| `paper-import-load-dryrun.sql` | 동일 + ROLLBACK (적재 가능성·멱등 실증·DB 미반영) |
| `paper-import-mapping.csv` | 권위 용지(120) → mat_cd → 절가(국4절/3절) → 적재여부/매핑미상 |
| `scripts/paper_import_match.py` | 결정론 매처(search-before-mint·live-bound 우선·재실행 가능) |
| `scripts/paper_import_sql.py` | 매칭 결과 → verbatim UPSERT SQL |

## 매칭 원칙 (search-before-mint)
1. **live-bound 우선** — 라이브 COMP_PAPER note/mat_nm 으로 이미 그 종이를 쓰는 mat_cd 확인.
   이름만 같은 **중복의미 신규코드(MAT_000347+ -260g)로 새 행 만들지 않음**(prior 배치의 오류 교정).
2. **t_mat_materials 이름 매칭** → 정확/공백무시/평량접미제거(자재 1개일 때만).
3. **3절 종이** = 전용 `(3절)` 자재(MAT_000083/093/110~112) + `plt_siz_cd=SIZ_000077`(300x625).
   라이브 3절 선례 0 → confirm 플래그(사람이 plt_siz_cd·자재 확인 후 COMMIT).
4. **mint** = 전건 기존 자재 매칭으로 **0건**. 기초마스터 코드 삭제·이름변경 금지(추가만).

## 결과 집계
- 권위 용지(절가 보유) **79** / 비-용지(절가 없음·skip) 41 = 120행.
- mat_cd **재사용 79 / 신규 mint 0**.
- 라이브 **기적재(미터치) 57** (국4절).
- **신규 INSERT 20행** = 국4절 15 + 3절 5 (전부 verbatim).
- **매핑미상(사람 확인) 2** = 레더하드커버 A4(7000)·A5(4000) → 매칭 자재 **del_yn=Y**(논리삭제)라
  적재 보류(죽은 데이터 방지). 활성 대체 자재 확인 필요.

## verbatim·정밀
- 절가 = 권위 값 그대로. 단, `unit_price`=`numeric(12,2)` → 7자리 값(예 272.9466667)은
  DB가 272.95 로 저장(컬럼 정밀도·반올림 내가 한 것 아님). 기적재 60행 동일 패턴(36.875→36.88).

## DRY-RUN 실증 (롤백 전용)
```
before=60 → pass1=80(+20) → pass2=80(+0 멱등) → rollback=60(DB 미변경)
```
NOT EXISTS NULL-safe 가드 사용(ON CONFLICT NULLS DISTINCT 함정 회피). 2-pass 멱등 확인.

## 위상·안전
권위=엑셀(절대)·라이브=감사대상. 라이브 읽기전용 SELECT + 롤백전용 dry-run만 수행.
실 COMMIT 은 **인간 승인 후 dbmap 트랙**. webadmin 코드 미변경.
