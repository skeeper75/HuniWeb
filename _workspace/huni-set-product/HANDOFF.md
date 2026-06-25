# Huni-Set-Product (§23) — HANDOFF

최종 갱신: 2026-06-25 · 셋트 가격 적재 착수 세션 마감. 상세 누적 서술 → `CHANGELOG.md`.

---

## 다음 시작점 (fresh 세션이 바로 할 일)

**셋트 가격 적재 책자 트랙 = 072 하드커버책자 "내지 반제품 구성원 승격"부터.**

072(및 077/082)는 **셋트 하이브리드 모델**(구성원별 공식 + 셋트 제본)이 정석으로 확정됐다. 마지막 구조 선결:

1. **내지 반제품 구성원 승격** (dbmap 구조변경·인간 승인): 현재 072의 내지는 sets 구성원이 아니라 본체 072에 통합 → evaluate_set_price가 총내지매수(페이지 곱) 미반영 → 내지인쇄 ~20배 과소청구. 해법 = 내지 반제품을 t_prd_product_sets에 sub_prd로 추가 + 뷰 레이어 `derive_inner_sheets`(총내지매수=부수×⌈페이지/판걸이⌉) 경로 연결.
2. 그 후 민팅(설계는 `06_load/hc072-set-hybrid-design.md`·`price-pilot-hc072-hybrid/` 준비됨):
   - **PRF_HC_INNER**(내지 반제품): 내지인쇄(S2 양면) + 내지용지. ※내지 종이 자재 072 등록 정정 선결(CFM-INNER-PAPER).
   - **PRF_HC_COVER**(표지073): 표지인쇄(S1) + 표지코팅(MATTE) + 표지용지(아트150 46.65). ※표지 자재 매핑 정정(MAT_000246 vs MAT_000078)·표지 펼침 siz 신설(CFM-COVER-SPREAD-SIZ).
   - **PRF_HC_BODY**(072 셋트 본체): 제본만(COMP_BIND_SSABARI·내지 빼고 재설계).
   - **S2 부활**: COMP_PRINT_DIGITAL_S2 del_yn Y→N(`price-pilot-hc072-hybrid/s2_revive.sql`·부작용0 검증됨).
   - 표지 qty 뷰 조립 계약 명문화(CFM-COVER-QTY).
3. 게이트(evaluate_set_price 골든·표지 출력매수 정합)+codex 재검증 → 인간 승인 → COMMIT.
4. 077(표지 레더 정액)·082(면지 유료·트윈링 제본)·100(base24+per2p) 동형 전파. 088=권위 "보류중"(진성 미정·실무진).

권위/설계/검증 다 갖춰짐 — 남은 건 **dbmap 구조변경(내지 승격·자재 등록)·인간 승인**.

---

## 미해결 / 블로커

### 셋트 가격 (책자)
- **CFM-INNER-TOTSHEET** [돈 크리티컬]: 내지 본체 통합 → 총내지매수 미반영 ~20배 과소. → 내지 구성원 승격(dbmap).
- **R-3 표지 자재**: 46.65=MAT_000078(아트150) 단독·MAT_000246(072 등록 전용지) 단가행 0. 자재 매핑 정정.
- **CFM-INNER-PAPER**: 072에 내지 종이 자재 미등록 → 내지용지 0원.
- **CFM-COVER-SPREAD-SIZ**: 표지 펼침 siz(390×268/532×355) 라이브 미등록 → 신설.
- **CFM-COVER-A4PLT**: A4 표지 3절 절가행 부재(가격표 verbatim 89.54 존재·적재만).
- **CFM-COVER-QTY**: 표지 qty 뷰 조립 계약(manual qty 비우면 copies) 명문화 필요.
- 088 권위 "보류중"(제본방식 미정)·094 30P 미바인딩 과소청구(RM-1·§18/dbmap).

### 자재 정합 잔여 (W2 보류분)
- 머그컵 PET 옵션화(codex 분류 불명 HOLD·실무진 컨펌)·BLOCKED-needs-L1 ~36(siz/print_options 차원 선적재 dbm-axis-staged-load)·CONFIRM ~30(소재효과축 홀로그램/골드/실버/글리터=실무진·구수 ref_param_json DDL·복합축·링/D링).
- 돈변동 2(투명아크릴192 두께·유포지154→153 REWIRE)·31 NO_ROOT·비종이 root 4 CONFIRM.

---

## 이번 세션 결정 (relitigate 금지)

1. **자재 논리삭제 결함 3종 종결**(좀비 배선 13건 COMMIT=REWIRE 2+REVIVE 11·좀비 92→74)·rev2 전체 재검토가 숨은 REVIVE 9건(옵션 참조 무결성) 적발·codex 81/83 합의.
2. **W2 색/면지 옵션화 1차 COMMIT**(9그룹/29옵션·면지색·색상·잉크색·돈0).
3. **셋트 가격 적재 착수**: 097 떡메모지 바인딩 COMMIT(고정가형·round-16 적재 PRF_TTEOKME_FIXED 재사용·골든 60,000/19,200·codex+게이트 GO).
4. **★책자 가격 = 셋트 하이브리드 모델**(구성원별 공식+셋트 제본)이 정석. 단일 번들 공식(PRF_HC_MUSEON_SUM) 폐기. 코드 실측 근거(evaluate_set_price·뷰 레이어 fn_calc_pansu 구성원별). 표지 pansu/S1 PK 충돌 = 단일번들 인공문제.
5. **S1=단면·S2=양면**. 내지 양면=S2 부활(S1 복제 mint은 ~50% 과소청구 함정).
6. **제본 comp**: COMP_BIND_HC_MUSEON del_yn=Y → COMP_BIND_SSABARI(byte-동일) 사용.
7. **생성≠검증·codex 독립 2차·라이브 읽기전용·돈영향 0 COMMIT만·webadmin 코드 직접수정 금지** 원칙 일관 유지.

---

## 건드리지 말 것 (확정 COMMIT·되돌리지 말 것)

- 좀비 배선 13건 COMMIT(`07_prereq/zombie-wiring-92/_exec/` apply·zr1-apply)·백업 `bak_*_zombiewire_20260625_053924`·`bak_t_mat_materials_zr1revive_20260625_055716`.
- W2 9그룹/29옵션 COMMIT(`07_prereq/w2-optionize/_exec/w2-apply.sql`·OPT_000064~072·OPV_000434~462)·백업 `bak_*_w2opt_20260624215218`.
- 097 가격 바인딩 COMMIT(`06_load/price-pilot-tteokme/`·PRD_000097→PRF_TTEOKME_FIXED)·백업 `bak_*_tteokme_20260625_153807`.
- W1 종이 계층·좀비 가격행(직전 세션·`07_prereq/remediation`·`zombie-price`).
- git 커밋 26902ef(워크스페이스 전체 추적 시작).

각 COMMIT은 멱등·undo.sql 보유·돈영향 0.

---

## 자격증명/안전

- 라이브 Railway DB: `.env.local` `RAILWAY_DB_*`(읽기전용 SELECT·`db railway`·비표준 포트). 파괴적 쓰기는 인간 승인 COMMIT만(백업→DRY-RUN→COMMIT→사후검증→undo).
- webadmin 코드(pricing.py 등) 직접수정 금지 — 가격 정합은 데이터/구조(dbmap) + §18/§6 위임.
- `.env.local` IGNORED 검증 후 커밋. 비밀값 `_workspace`/stdout 비노출.
