# Axis Pack — processes (공정 t_proc_processes / t_prd_product_processes)

> freshness 권위: impact-diagnosis I-6(dep_proc_cd 삭제). round-13 결함축 A(코팅 Q9 정책 분산).

## 정답 소스

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| 공정 마스터 행/연결 라이브 실측 | `00_schema/ref-processes.csv`·`ref-product-processes.csv`·`ref-product-process-excl-groups.csv` + 라이브 psql | A | PARTIAL(06-04 스냅샷) |
| 공정 레시피 트리(인쇄방식별 택일) | `07_domain/process-recipe-tree.md` | C | FRESH |
| 공정 도메인(17 Case 흐름) | `07_domain/pdf-domain-knowledge.md`(← 공정관리 PDF) | B | FRESH |
| family별 공정 BOM | `15_domain-spec/<family>/product-bom.md`·`column-dictionary.md` | C(round-11) | FRESH |
| 실무진 확정(박/코팅=공정·미싱제본 신규 등 Q1~Q15) | `15_domain-spec/<family>/domain-research-notes.md` + 메모리 round-11 | B | FRESH |
| 별색≠도수(C18~22→t_proc_processes)·UV=PROC_000002 | `15_domain-spec/digital-print/domain-research-notes.md`·`acrylic/` + round-13 acrylic | C(round-11/13) | FRESH |
| 결함현황(공정 오적재/누락) | `17_correctness/<family>/correction-manifest.md` + `_crosscut/crosscut-synthesis.md` | C(round-13) | FRESH |

## 보조 소스

- 메모리 dbmap-process-select-group-domain — 공정택일그룹=인쇄방식별 레시피. FRESH.
- 메모리 dbmap-option-material-process-bundle — 순수공정(열재단·타공 bare-hole)은 자재 없음. FRESH.

## stale 함정

1. **`17_correctness/digital-print/extraction-plan.md` L56 oracle dep_proc_cd — STALE(I-6).** 자재→공정 게이팅 oracle 컬럼 삭제. round-13 oracle 재생성 필요(진단 Top 3).
2. **코팅 정책 분산(round-13 추가-A·Q9).** 코팅이 일부 family=공정(50상품)·일부=자재(16+8상품). 책자=공정 vs 스티커/포토북=자재. BATCH-3 컨펌(통일 미결). 위키는 family별 현재 분류 + "통일 미결" 양면 표기.
3. **아크릴 print_side에 UV 오적재(round-13 acrylic·F-AC-G2).** 20상품 print_side에 UV변형 오적재 → 정답 PROC_000002. 라이브값 인용 시 correction-manifest 대조.
4. **별색 008~012 vs PROC_000007 정리물 내부 불일치(round-12 교훈).** 정리물 내부 불일치 주의 — 별색=공정·clr_cd=NULL.

## 미해결 GAP

- 코팅=공정 통일 여부 미결(BATCH-3). [GAP-PROC-1]
- 미싱제본·보드마운팅·삼각대거치 등 신규 공정 신설 미결(BATCH-13). [GAP-PROC-2]
- 박(있음) 부모 PROC_000033 미연결 vs 박색 8자식 옵션풀(digital-print C-06 AMBIGUOUS). [GAP-PROC-3]
- dep_proc_cd 삭제 후 자재→공정 게이팅 대체경로(I-6). [GAP-PROC-4]
