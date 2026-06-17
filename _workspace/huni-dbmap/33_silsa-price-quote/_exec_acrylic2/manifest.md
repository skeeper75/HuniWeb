# 아크릴 마무리 실행본 — 적재 매니페스트 (round-23·_exec_acrylic2)

> arbiter `acrylic-blocked-resolution.md`(A5 가드·코롯토 B2~B4·BLOCKED) 실행본. 단일 트랜잭션·FK 위상순·롤백전용 DRY-RUN. **실 COMMIT·바인딩·미러·카라비너·.02 시맨틱은 인간 승인/컨펌/채번 후.**

## 산출물

| 파일 | 단위 | 테이블 | 조치 | 행수 | 멱등키 |
|------|------|--------|------|:--:|--------|
| `A5_fix_min_qty.sql` | A5 | t_prc_component_prices | .02+siz_width+min_qty NULL → min_qty=1(전수) | UPDATE 81 | min_qty IS NULL |
| `B2_korotto_comp.sql` | B2 | t_prc_price_components | COMP_ACRYL_COROTTO 신설(.01·use_dims WH) | INSERT 1 | comp_cd PK NOT EXISTS |
| `B3_korotto_unitprices.sql` | B3 | t_prc_component_prices | 코롯토 21 verbatim(siz_width/height·채번 0) | INSERT 21 | 자연키(comp,apply_ymd,siz_width,siz_height) NOT EXISTS |
| `B4_korotto_formula.sql` | B4 | price_formulas / formula_components | PRF_COROTTO_ACRYL + 배선(disp_seq=1·addtn_yn=N) | INSERT 2 | frm_cd PK / (frm_cd,comp_cd) NOT EXISTS |
| `apply.sql` | — | — | 단일 트랜잭션 \i 조립·끝 ROLLBACK | — | — |
| `apply.sh` | — | — | psql 로더(기본 DRY-RUN·`--commit` 인간 승인·백업 선행) | — | — |
| `undo.sql`·`undo.sh` | — | — | 원복(B4→B3→B2 DELETE·A5 min_qty→NULL)·기본 DRY-RUN | — | — |
| `acrylic2-blocked.BLOCKED.sql` | BLOCKED | — | 차단 항목(apply.sql 미포함) | — | — |
| `gen_load_sql.py`·`korotto21.json` | — | — | 결정적 생성기 + provenance | — | — |

## 적재 순서 (FK·단일 트랜잭션)

`A5(보정·독립) → B2(comp 부모) → B3(단가행) → B4(공식+배선)`. B2가 B3/B4 전(FK comp 부모)·B4 formula가 formula_components 전. A5는 기존 데이터 보정(독립).

## ★핵심 제약 준수

- **A5 골든 불변** — .02 min_qty=1 보정(÷1=×1). .01 단가형 제외(MIRROR3T .01 안전).
- **코롯토 채번 0** — siz_cd 17 siz_nm WxH 파싱(W앞) + GAP 4 GxS. t_siz_sizes 미접촉.
- **코롯토 .01 단가형** — min_qty=1 명시(CLEAR3T .02 min_qty 함정 회피).
- **단가 verbatim**(B3 가격표 B06)·**search-before-mint**(코롯토 comp/공식 라이브 부재 확인)·멱등·단일 트랜잭션·백업+undo·COMMIT 0.

## BLOCKED (이번 미적재·`acrylic2-blocked.BLOCKED.sql`)

| ID | 항목 | 사유 |
|----|------|------|
| Q-ACR-9 | 미러 공식·바인딩 | 미러3T 본체 상품 0개·CPQ 소재옵션 선결·추측 금지 |
| Q-ACR-CARA-OPT | 카라비너 comp/단가행/공식 | 형상 4 opt_cd(OPV) 채번 선행·PRD_000166 비활성 |
| Q-ACR-CO1 | 코롯토 바인딩(B5) | 코롯토 4상품(164/168/226/165) 정체 컨펌 후·comp/단가행/공식은 GO |
| Q-ACR-7b | CLEAR3T .02→.01 시맨틱 | 가격 무영향·개발자 컨펌 LOW |

## undo

`apply.sh dryrun` 이 `backup_a5_minqty_pre.csv`(81)·코롯토 신설 전 부재 스냅샷 저장. `undo.sh`(기본 DRY-RUN·`--commit` 인간 승인): round-trip diff 0 실증(과삭제 0·신설분만 삭제·A5 min_qty 원복).

## 다음 (인간 승인 큐)

1. dbm-validator R1~R6 + 이전 _exec_acrylic G1~G9 carry-forward 독립 게이트.
2. 라이브 실 COMMIT(`apply.sh --commit`) — A5는 견적 불가 결함 해소라 우선(엔진 동시배포 무관·이미 적재된 단가행 보정).
3. BLOCKED 4건: 미러 본체 식별·카라비너 opt_cd 채번·코롯토 바인딩 정체 컨펌·.02 시맨틱 개발자 컨펌.
