# basedata-coverage-note.md — 검사 커버리지·BLOCKED 정직 명시

> Phase 2 hcc-basedata-inspector · 디지털인쇄 36상품 × 8축 = 288셀

## 커버리지: 288/288 셀 전부 채움 (빈 셀 0)

| 축 | MATCH | N/A | MISSING | MISMATCH | EXTRA | CONFIRM | 합 |
|----|-------|-----|---------|----------|-------|---------|----|
| 사이즈코드 | 33 | 0 | 3 | 0 | 0 | 0 | 36 |
| 도수 | 32 | 4 | 0 | 0 | 0 | 0 | 36 |
| 인쇄옵션 | 8 | 11 | 11 | 6 | 0 | 0 | 36 |
| 판형 | 30 | 0 | 0 | 2 | 1 | 3 | 36 |
| 자재 | 35 | 0 | 1 | 0 | 0 | 0 | 36 |
| 공정 | 20 | 14 | 1 | 1 | 0 | 0 | 36 |
| 묶음수 | 0 | 25 | 10 | 0 | 1 | 0 | 36 |
| 페이지룰 | 0 | 31 | 5 | 0 | 0 | 0 | 36 |
| **합** | 158 | 85 | 31 | 9 | 2 | 3 | **288** |

## BLOCKED: 0건
- 라이브 접속(`.env.local RAILWAY_DB_*` 읽기전용) 정상, 36상품 1:1 매칭(미매칭 0), 권위 캐시(`24_master-extract-260610/digital-print-l1.csv`) 재사용. 접근 불가·자격증명 부재 셀 없음.

## 데이터 출처
- 권위값: `24_master-extract-260610/digital-print-l1.csv`(재파싱 금지·캐시 재사용) → `_live/authority-values.json`.
- 라이브 실측: psql 읽기전용 SELECT, `_live/{sizes,print-options,plate-sizes,materials,processes,bundles,page-rules}.tsv` → `_live/all-live.json`.
- 판정 엔진 산출: `_live/verdicts.json`.

## 검사 가정·한계 (게이트 재실측 시 주의)
1. **인쇄옵션 vs 공정 테이블 공유**: 라이브는 코팅·접지·별색·박·모서리·가변을 모두 `t_prd_product_processes` 한 테이블에 적재. 인스펙터는 권위 컬럼(별색/코팅/커팅/접지=축3, 후가공/박/형압=축6)으로 분리 판정. proc_nm 키워드 매핑(유광/무광=코팅, *접지=접지, 화이트/클리어/핑크/금색/은색=별색, 금유광/동박 등=박)에 의존 — 게이트는 upr_proc_cd family로 재확인 권장.
2. **별색 미적재 판정**: 별색 family(PROC_000007 upr) product_processes 링크 0 + option_items ref_dim 0 실측 확인. clr_cd=NULL 공정행으로 등록돼야 하나 부재.
3. **자재 표기 정규화**: 권위 약어("아트300","백모조220")↔라이브 정식명("아트지 300g","백색모조지 220g")은 한글토큰+두께 매칭으로 동일 처리(g단위·"지" 접미 무시). 의미구분(투명/반투명) 미분리는 결함 유지(PRD_000019/25/39 라이브 mat_nm="PET"로 단일화 의심 → 게이트 재확인 권장).
4. **페이지룰**: 권위 `판수` 컬럼값(15/12/8/6/4 등)이 낱장 상품에도 존재하나 domain-lens §9상 낱장은 잡음 → 체크리스트 needed(접지카드류 5건만 Y) 우선. 라이브 page_rules 36상품 전부 0행 → needed=Y 5건은 MISSING.
5. **판형 needed 충돌**: authority-spec §4(비판형 needed=N) vs 체크리스트(판형 전부 needed=Y) — 037/050/051을 CONFIRM 처리(결함 아님·needed 재판정 사안).