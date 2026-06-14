# 스티커 Tier A 4상품 — BLOCKED & GAP (→ dbm-ddl-proposer)

> 작성 2026-06-14 · `dbm-option-mapper`. 발명 금지·플래그만. search-before-mint(코드행<컬럼<JSONB<테이블)는 dbm-ddl-proposer 소관.

## 1. BLOCKED (needs L1 pre-load) — 0건

스티커 4상품은 전 차원행(자재/공정/도수/사이즈)이 라이브 적재됨 → **BLOCKED 0**. (postcard/digitalprint 와 대비 — 차원행 선적재 의존 없음.)

## 2. GAP (라이브 컬럼/구조 부재 — DDL 제안 대상)

| GAP | 내용 | 영향 상품 | 라이브 권위 | 처리 후보 |
|---|---|---|---|---|
| **GAP-PARAM** | 조각수 N 보존처 부재(`ref_param_json` 미구현). 052 `*최대20/40조각`·055 `5~10조각`·자유형 칼선 형상 = 안내/파라미터이나 option_items 에 보존 컬럼 없음 | 052·055 | cpq-schema §4 🔴8 | option_items `ref_param_json` 컬럼 vs 별 테이블. **qty smear 금지** |
| **GAP-HIDDEN** | 인쇄=단면 단일(선택지 1개) — 자동적용·미표시(hidden-essential) 플래그 부재. 현재 mand=Y 단일로 UI 노출 | 052·053·055·066 | cascade-rules §5 | option_groups auto-apply hidden 플래그 |
| **GAP-066-DUMMY** | 066 죽은 stub `OPT-000004 원형`(del_yn=Y) + 고아 옵션 `OPV-000006 옵션1`(del_yn=N·삭제된 그룹 가리킴·item 0행) | 066 | 라이브 실측 2026-06-14 | 고아 OPV-000006 소프트삭제(`_cleanup_dummy.sql`·인간 승인) |

## 3. [CONFIRM] (라이브 미상/정책 — 리드 확정)

| # | 항목 | 현재 채택 | 대안 |
|---|---|---|---|
| C-S1 | 인쇄 단일 hidden 처리 | UI 노출(mand 단일) | 자동적용·미표시(GAP-HIDDEN) |
| C-S2 | 사이즈 옵션그룹 노출 | 미생성(UI 1차축) | OG-SIZE 명시 |
| C-S3 | 종이 opt_nm | mat_nm 라벨(유포스티커 등) | mat_nm 조인 vs opt_nm 별도 |
| C-S4 | 066 고아 OPV-000006 정리 | 인간 승인 후 소프트삭제 | 유지 |
| C-S5 | 053 화이트별색 분류 | 공정(.04 PROC_000008·별색) | 도수(.06 opt_id) |

## 4. 도메인 HARD 적용 결과 (참고)

- **코팅=자재(스티커 예외)**: 052/066 무광/유광코팅스티커=materials 행 흡수 → GAP 아님(정상). 별도 코팅 공정그룹 미생성.
- **조각수=설명성**: 옵션 미생성 → GAP-PARAM(보존 불요 판단·플래그만).
- **066 형상=사이즈 융합**: 37 size rows(원형/정사각/직사각×EA)가 형상 표현 → 커팅 옵션 미생성. 과분할금지 정합(GAP 아님).
</content>
