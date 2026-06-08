# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-08(최신). 권위 = 본 문서 + 메모리 `dbmap-option-material-process-bundle`·`dbmap-l2-requires-l1-price-table`·`dbmap-live-admin-product-viewer`·`dbmap-cpq-option-layer-mapping`·`dbmap-silsa-price-via-poster-sign`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ 초기) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-6 일반현수막(PRD_000138) 적재본 v2 — CPQ 옵션 "자재+공정 BUNDLE" 재정합 + 독립검증 GO.** 사용자 모델("한 옵션=자재 의미+공정 의미, DB엔 구분 등록, option_items가 묶음") 확정으로, v1이 가공/추가 옵션을 공정(.04)만으로 매핑한 **반쪽 매핑 결함**을 자재(.03)+공정(.04) BUNDLE로 교정. 적재본 `09_load/_exec_silsa_banner/`(v2) INSERTABLE 58·BLOCKED 186, R1~R6 PASS·생성검증분리로 F-3 적발·정정. **DB 미적재(실 COMMIT·자재 mint·siz 등록·열재단 PROC·자재 링크·DDL=인간 승인).**

## 이번 세션 핵심 결정·발견 (재논의 금지)
- **[HARD·사용자] 옵션 = 자재+공정 BUNDLE** — 한 옵션이 자재 의미와 공정 의미를 동시에 가짐(예: 아일렛=금속링 자재이나 박는 것=타공 공정). DB는 자재(t_mat_materials)·공정(t_proc_processes)을 각각 별도 등록하고, `option_items`(polymorphic 다중 seq) + `template`이 둘을 묶어 주문접수+생산작업지시(자재 BOM+공정) 모두 성립. → 메모리 `dbmap-option-material-process-bundle`.
- **v1 반쪽 매핑 결함 교정** — v1은 끈=부착공정(.04)·각목=셋트(.07) 등 **공정만** 매핑해 생산 BOM에서 자재(끈/각목/양면테입) 누락. 근본원인=라이브 부착공정 enum에 "끈/테입"이 있다고 끈=공정으로 추론(엑셀 명시값 "추가옵션=자재"를 무시한 over-reach). **라이브 enum 추론 < 엑셀 명시값.**
- **사용자 도메인 결정 3건(HARD)** — ① 타공(4/6/8)=구멍만(bare-hole), 아일렛 안 끼움 → process-only(자재 없음) ② 봉미싱 실=자재로 등록(mint) + 봉제공정 BUNDLE ③ 각목=신규 자재(.03) mint(우드봉 MAT_000225 차용 배제, 셋트.07 폐기).
- **v2 적재 형태** — INSERTABLE 58(가격 36 + CPQ 옵션 22[groups 2·options 11·item 공정seq 9]). BLOCKED 186(siz 77·area 77·자재 mint 4[큐방·각목×2·봉제사]·자재 링크 6[끈/양면테입 즉시+mint분]·자재 seq item 8·열재단 1). 끈 MAT_000070·양면테입 MAT_000069=master 실재(BLOCKED-LINK, 링크만). R-GAKMOK constraint var=mat_cd(셋트→자재 정정).
- **검증 GO(독립)** — `03_validation/silsa-banner-v2-load-gate.md`: R1~R6 전건 PASS(검증자 라이브 자가 재현)·search-before-mint 정직(발명 0·중복 mint 0)·BLOCKED 정직(over/under-block 0)·BUNDLE 무결성. F-3(00 마커 v1 stale "각목 sub_prd_cd") 적발→정정 완료(gen_load_sql.py+00.sql, 각목=material).
- **굿즈/파우치 시트 = 옵션 정의 권위** — 옵션을 선택/가공/추가상품 3종으로 분류. `huni-goods-option-mapping.md` 패턴(옵션→자재/공정/차원 재배선).

## 다음 시작점 (정확한 다음 행동 — 택1)
1. **[실 적재 — 인간 승인] 일반현수막 적재** — GO 적재본 `09_load/_exec_silsa_banner/`(v2). 주 트랜잭션 58 INSERTABLE은 즉시 COMMIT 가능(인간 승인). BLOCKED 활성화 선행: ① siz 77규격 등록(SIZ_000538~618) ② 자재 mint 4(큐방·각목×2·봉제사, MAT_TYPE.07, mat_cd 후니 채번) ③ 자재 링크(끈 070·양면테입 069 즉시+mint분) ④ 열재단 PROC_000084 신설 ⑤ 각목 2규격 모델(D-2)·R-GAKMOK 폼빌더·큐방 enum 확장. `apply.sh commit`(인간 승인).
2. **[권장·확장] 다른 상품군에 "자재+공정 BUNDLE" + "L1 가격표 대조" 적용** — silsa에서 확립한 방법으로 아크릴/포스터사인 잔여·책자(excl_group 마이그 GAP-2)·캘린더로 확장. 각 상품군 옵션을 자재/공정으로 분해(엑셀 명시값 권위·도메인 [CONFIRM]).
3. **[GAP 닫기] dbm-ddl-proposer** — `ref-param-json-proposal`(타공 구수·각목 규격 보존)·각목 2규격 모델·큐방 enum 확장. search-before-mint 제안서.

## 미해결 / 블로커
- **일반현수막 적재 선행(인간 승인)** — siz 77 등록·자재 mint 4·자재 링크·열재단 PROC_000084·실 COMMIT. 전부 인간 승인.
- **설계 결정 2건** — D-2 각목 2규격(별 mat_cd 2개 vs 단일+param)·R-GAKMOK 폼빌더 배열-멤버십 입력 미검증(F-1, 적재 시점 라이브 admin 직접 확인)·큐방 부착 enum 확장.
- **F-2(MINOR)** — `_blocked/apply_blocked_options.sql` 로더 래퍼 부재(README ROLLBACK 외부주입 안내라 안전, 권고만).
- **이전 트랙 잔존**(CHANGELOG): 디지털인쇄 잔존 차단(3절/투명/박/048/019·030·049 plate교정)·excl_group 마이그(GAP-2)·미해결 설계결정(잉크색·머그용량·면지/바인더링·보드종류)·기존 PRF_POSTER_FIXED 바인딩 정리(D-WIRE 2공식 공존).

## 건드리지 말 것 (확정·검증 완료)
- `10_configurator/silsa-option-layer-v2.md` — v2 자재+공정 BUNDLE 재정합(v1 §3 supersede). 사용자 도메인 결정 3건 반영.
- `09_load/_exec_silsa_banner/`(v2) — 적재 실행본. 검증 GO. F-3 정정 완료.
- `03_validation/silsa-banner-v2-load-gate.md` — 독립검증 GO(R1~R6 PASS).
- `10_configurator/silsa-price-table-gap.md`·`live-admin-groundtruth.md` — 가격표 B26·라이브 admin ground-truth(이전 세션).
- `02_mapping/silsa-price-engine/`·`silsa-poster-area-matrix/` — A 가격엔진 GO.
- 이전 GO·라이브 COMMIT분(디지털인쇄 308행·상품마스터·가격 등 CHANGELOG 보존).
