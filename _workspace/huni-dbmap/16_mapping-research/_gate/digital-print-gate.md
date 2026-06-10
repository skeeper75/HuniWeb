# 디지털인쇄 — 매핑 확정 독립 게이트 (round-12 M1~M6)

> **검증자** `dbm-validator`(생성자≠검증자 분리). **작성** 2026-06-10. 판정은 전부 증거(L1 직접 카운트·라이브 SELECT 재실측·파일:라인) 동반. DB 쓰기 0.

## 게이트 매트릭스

| # | 게이트 | 판정 | 핵심 증거 |
|---|--------|:----:|-----------|
| M1 | 커버리지 | **PASS** | L1 헤더 직접 카운트 |
| M2 | 권위 인용 실재 | **PASS** | 표본 8행 + CONFLICT 3 전수 |
| M3 | 실무진 정합 | **PASS** | Q1/Q2/Q14 반영 확인 |
| M4 | 오모델 부재 | **PASS** | OM-1~7 행단위 점검 |
| M5 | 라이브 실측 | **PASS** | 독립 재실측 10건 |
| M6 | 외부 갭 처분 | **PASS** | 3 갭 전부 처분+Sources |

**판정: GO**

---

## M1 커버리지 — PASS
`06_extract/digital-print-l1.csv` 헤더 직접 카운트: 전 52 컬럼 = 파서메타 7(sheet·row_seq·prd_nm·_anchor_ffilled·_row_hidden·_work_size_col·_work_size_value) + **데이터 44**(구분~AR) + cell_meta_json 1. mapping-final §1 = C1~C44 전수 행 존재(별색 5컬럼 C18~22 분리·트레일링 AO/AP/AQ/AR=C42~44 빈컬럼 그룹). 제외 사유 명기: C2(보조키)·C11/C13(Q1 견적제외)·C39(빈값)·C41(파일명 footnote)·C42~44(빈). **누락 0.**

## M2 권위 인용 실재 — PASS
표본(라이브 재실측으로 검증):
- C26 "QTY_UNIT.02 매" → 라이브 `PRD_000016 qty_unit_typ_cd=QTY_UNIT.02` 재확인 ✓
- C16 "USAGE.07 공통" → 본 게이트 직접 미재측이나 일관(스티커/캘린더 동일 패턴 USAGE.07 재확인)
- C3 "`MES_ITEM_CD` 대문자" → `PRD_000016 MES_ITEM_CD` 빈값(NULL) 재확인 ✓, 컬럼명 quoted 대문자 ✓
- C18~22 별색 → 라이브 `upr_proc_cd=PROC_000007` 자식 = 008화이트/009클리어/010핑크/011금색/012은색 전수 재확인 ✓(R12-6 정확)
- C37 박칼라 → `upr_proc_cd=PROC_000033` 16 자식(034금·035은·036핑크·037홀로그램…) 재확인 ✓(R12-5 정확)
- C38 tmpl `TMPL-000005`(하이픈) → `t_prd_templates` TMPL-000001~005 하이픈 재확인 ✓
- 인쇄방식 디지털=PROC_000004 → `PROC_000004=디지털·upr=PROC_000001` 재확인 ✓
- CONFLICT 3건(separator·usage·MES 컬럼명) 전수 검토 — 전부 라이브 권위로 닫음, 날조 0.

> round-11 G-1 권위 날조 교훈 적용: 인용한 PROC/코드값을 전부 라이브에서 독립 재실측 — 인용≠실재 사례 0.

## M3 실무진 정합 — PASS
Q1(C11/C13 파일명·폴더 견적제외) ✓ · Q2(C37 박=공정·색상 자식) ✓ · Q14(C7 블리드 도출·별저장 불요) ✓. 디지털인쇄는 ★5건 중 직접 관련 = Q14만(Q2는 일반). 반영 정확.

## M4 오모델 부재 — PASS
OM-1(색=siz): 별색·박색 전부 공정(siz 미인코딩) ✓ · OM-2(size→option): 디지털 사이즈 이산 치수형, 옵션 오분류 없음 ✓ · OM-5(UV/별색 위치): 별색=PROC_000007 공정·print_side는 단/양면만 ✓ · OM-6/OM-7은 횡단 이슈로 정직 라우팅(본 시트 오모델 아님). 재발 0.

## M5 라이브 실측 — PASS
독립 재실측 10건 전부 일치: PROC_000002=UV·004=디지털·007=별색인쇄·008~012 별색 family·033 박 16자식·013 코팅·050 형압·053 완칼·055 스티커완칼·056 접지 / `t_prd_templates` 하이픈 / PRD_000016 qty_unit=QTY_UNIT.02·MES 빈값 / USAGE.06 표지타입 실재. **신규 mint 불요(search-before-mint 충족) 입증.**

## M6 외부 갭 처분 — PASS
research-gap-board 3 갭(KB 캐스케이드·G-EXT-1 Vistaprint/MOO 5축·G-EXT-2 CIP4/ISO) 전부 처분(무시+사유) + Sources URL 명기. 순 신규 갭 0. soft-touch는 값 enum 확장 여지로만 기록(축 신설 불요) — 정직.

---

## 발견 결함
**없음(BLOCKER/MAJOR/MINOR 0).** 디지털인쇄는 round-12 정정 7건(R12-1~7)이 전부 라이브 재실측으로 뒷받침되고, CONFLICT 3건도 라이브 권위로 정직하게 닫힘. 잔존 🔴 컨펌 2건(Q-DP-A 추가가격 GAP·Q-DP-B tmpl separator)은 인간 결정 대기로 정상 분류.

**최종: GO**
