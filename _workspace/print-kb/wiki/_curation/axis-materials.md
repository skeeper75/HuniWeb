# Axis Pack — materials (자재 t_mat_materials / t_prd_product_materials)

> freshness 권위: impact-diagnosis I-6(dep_proc_cd 삭제). round-13 핵심 결함축 ②(MAT_TYPE.07~10 자재 오염)·B(레더 .08/.01→.06).

## 정답 소스

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| 자재 마스터 행/연결 라이브 실측 | `00_schema/ref-materials.csv`·`ref-product-materials.csv` + 라이브 psql | A | PARTIAL(06-04 스냅샷·round-13 오적재 미반영) |
| 자재 정규화 설계(5축 보유·1축 GAP·과분할 금지) | `10_configurator/wowpress-option-model.md`·`huni-goods-option-mapping.md` + 메모리 dbmap-material-option-normalization | C/D | FRESH |
| family별 자재 BOM | `15_domain-spec/<family>/product-bom.md`·`column-dictionary.md` | C(round-11) | FRESH |
| 자재=parent+usage_cd 구조 | `15_domain-spec/digital-print/domain-research-notes.md` + 메모리 round-11 | C | FRESH |
| 별도설정 자재 권위(종이×상품 ●매트릭스) | `06_extract/import-paper-l1.csv`·`import-paper-matrix-long.csv` | B | FRESH |
| 자재유형 코드(MAT_TYPE) | `00_schema/ref-base-codes.csv`·`code-values.md` | A/C | PARTIAL-STALE(I-8 코드 정정) |
| 결함현황(자재 오적재) | `17_correctness/<family>/correction-manifest.md` + `_crosscut/crosscut-synthesis.md` 패턴축② | C(round-13) | FRESH |

## 보조 소스

- `07_domain/entity-semantic-model.md` — 가죽/UV/제본 자재 표준(S2 검증). FRESH.
- 메모리 dbmap-option-material-process-bundle — 옵션=자재+공정 BUNDLE(아일렛=금속링 자재+타공 공정). FRESH.

## stale 함정

1. **`_loadspec/loadspec.md` L96 자재→코팅 게이팅(dep_proc_cd) — STALE(I-6).** dep_proc_cd 컬럼 삭제. 자재→공정 게이팅은 제약/공정 경로로 대체. 대체경로 미확정(GAP).
2. **라이브 자재값 직접 인용 금지(round-13 ② 오염).** MAT_TYPE.07~10에 색/형상/사이즈/구수가 자재로 오적재(~120행). MAT_000186 레더 1행이 6상품 횡단오염(photobook). 라이브값 인용 시 해당 family correction-manifest 대조 → MIS-LOADED는 "라이브 오적재(교정 대기)" 표기.
3. **레더 3-way 혼재(round-12 booklet/photobook).** .01종이/.06가죽/.08실사 혼재 → 정답=.06(가죽). `16_*/photobook/mapping-final.md` + round-13 photobook F-PB.

## 미해결 GAP

- 본체색=재질행 합성 vs 자재 분리: 굿즈파우치는 정답(합성)이나 다른 family 색=자재 오염(②). BATCH-2 컨펌. [GAP-MAT-1]
- SHAPE/COUNT/OPT 3축 = ddl-proposer 신설 필요(WowPress 1축 GAP). [GAP-MAT-2]
- dep_proc_cd 삭제 후 자재→공정 게이팅 대체경로 미확정(I-6). [GAP-MAT-3]
- usage 슬롯 미분화(USAGE.07 공통·내지/표지·본체/부속 코드 부재·crosscut 추가-G). [GAP-MAT-4]
