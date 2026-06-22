# 디지털인쇄 시트 — 독립 검증 게이트 (R1~R6) + divergence 판정

> **검증** 2026-06-18 · hrv-validator(huni-recipe-viz 하네스·생성≠검증) · **Claude 라이브 psql 독립 재실측** [HARD].
> 검증 대상(비신뢰·재실측) = codex 생성 `01_recipe/`·`02_viz/`·`03_audit/`. 권위 = 상품마스터 260610 + 가격표 260527 + 라이브 t_*(2026-06-18 읽기전용 SELECT).
> 모든 PASS/FAIL은 아래 재현 SQL의 라이브 실측 결과로만 판정. "그럴듯함" 통과 0.

---

## ★ 결론 먼저 (divergence 3건 판정 + 종합)

**divergence 3건 전부 codex(connection-auditor §0 reconcile)가 라이브 사실에 부합. 기존 Claude premium-postcard 검증(`verdict-claude.md`)이 핵심 사실에서 틀림.**

- **S2는 PRF_DGP_A에 미배선**(라이브 카운트 0). Claude 검증의 "F-2 S1+S2 이중배선"은 **라이브 부정**.
- **print_opt_cd = 면(단/양)**, 라이브 마스터 `t_prt_print_options.print_opt_nm`이 literal "단면/양면". Claude 검증의 "POPT_000001=흑백·POPT_000002=칼라" 라벨은 **날조**(도수 의미는 print_opt에 없음).
- **별색 경로는 proc_cd(530행·5종·clr_cd 전부 NULL)로 실재**. codex 합의.

**종합 = CONDITIONAL-GO** — codex 산출(레시피·viz·연결진단)은 라이브 충실하여 **GO**. 단 ① codex audit이 인용한 `_live-facts.md` 큐레이션에 결함 2건(CORNER 미배선 오기·S2 dead-wire 라우팅 표기 혼선) ② codex audit이 정정한 기존 premium-postcard 검증은 **실제로 틀렸으므로 그 verdict는 NO-GO(폐기·재작성 필요)**. 즉 본 하네스 산출 GO / 기존 §15 premium-postcard 결론 무효.

---

## R1~R6 게이트 표

| 게이트 | 판정 | 근거(라이브 재실측) |
|--------|------|------|
| **R1 레시피 권위충실** | **PASS** | 31상품 7항목·9 패밀리 사슬이 라이브 바인딩과 일치. 바인딩 카운트 라이브 재실측 정확(DGP_A=9·B=2·C=3·D=1·E=3·F=1·PHOTOCARD=2·NAMECARD=3·FOLD_SUM=1·ENV=1). 미바인딩 10상품 전부 frm_cd 부재 확인. 단가행 verbatim(S1 350/800 등 라이브 실재). **경미**: 레시피 "30상품" vs 실제 31행(썬캡)·PRD_000038 형압명함 식별 누락은 레시피 스스로 GAP 자인. 날조 0 |
| **R2 mermaid 정확성** | **PASS** | mermaid 종합 32노드·41엣지(`-->`36+`-.->`5)·missing 5 = manifest 정합. 노드(상품/공식/comp)·미바인딩 10·희소 단가행(PHOTOCARD 1·NAMECARD 2) 모두 라이브 실측 일치. 없는 연결 0(S2를 PRF_DGP_A에 안 그림 = 라이브 정합) |
| **R3 이미지↔mermaid 정합** | **PASS(부분·이미지 3/4)** | 3 PNG 전부 유효(1920×1080 등 RGB). :::missing 카운트 종합5/프리미엄4/투명3 = manifest·mmd 일치. 화이트인쇄엽서는 mermaid만 산출·이미지 미생성(directive "이미지 핵심만" 준수·mermaid 정확하므로 R2 기준 유효). 이미지 환각 추가 노드 없음(노드 인벤토리 대조). 시각 정밀 픽셀검사는 본 게이트 범위 밖(구조 카운트 정합으로 PASS) |
| **R4 연결진단 실재** | **PASS** | auditor 적발 결함 라이브 전수 재현: N-1 미바인딩 10(frm_cd 부재 확인)·N-2 FOLD_SUM 1-comp(COMP_FOLD_CARD_2H만)·N-3 NAMECARD 단가행 2행·mat 2종·min_qty 100단일·M-1 도수차원 부재(S1/S2 use_dims에 colrcnt 없음·POPT=면)·M-2 S2 del_yn=Y(B/C/F 잔존배선)·M-3 PRF_DGP_F=S2만(S1 미배선)·G-5 PHOTOCARD 1행 |
| **R5 codex 환각 적발** | **PASS(환각 0·기존검증 오류 적발)** | codex 주장 전부 라이브 입증됨(가설→사실 둔갑 0). 오히려 codex가 자기 시드(레시피)의 "S1=단면키·S2=양면키"·"S1+S2 이중배선"·"별색 clr_cd 경로없음" 3건을 라이브로 **반증·격하**(reconcile §0 R-1/2/3). 정직. **단 codex가 인용한 `_live-facts.md` L2에 CORNER 미배선 오기**(라이브엔 CORNER_RIGHT disp_seq3 배선)→M-4가 이를 상속 = Claude 큐레이션 결함(codex 책임 아님) |
| **R6 견적 완전성** | **CONDITIONAL** | 바인딩 21상품 중 dry walk-through 성립: 포토카드·봉투제작·ENV/PHOTOCARD 완제품가형 4건 = 완전(단가행 존재). DGP 계열은 **선택→공식→comp→단가행까지 사슬 도달하나** 도수축 소실(M-1)·imposition 부재(E-1)로 정확한 견적가 미보장. 미바인딩 10·FOLD_SUM 1 = 견적 완전 불가. 즉 **"가격 결과값은 나오나 권위와 어긋날 수 있음"이 정직하게 보드에 기록됨** → 레시피가 GAP 침묵 0(dodge 없음) |

---

## divergence 3건 판정 (라이브 psql 원천 — 유일 권위)

### 판정 1 — S2 배선 충돌 → **codex 맞음 / Claude 검증 틀림**

```sql
-- DECISIVE: PRF_DGP_A에 S2가 배선됐는가?
SELECT count(*) FROM t_prc_formula_components
 WHERE frm_cd='PRF_DGP_A' AND comp_cd='COMP_PRINT_DIGITAL_S2';
-- → 0  (S2 미배선)

-- PRF_DGP_A 전체 배선
SELECT comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components
 WHERE frm_cd='PRF_DGP_A' ORDER BY disp_seq NULLS FIRST;
-- → COMP_COAT_GLOSSY, COMP_COAT_MATTE, COMP_PRINT_DIGITAL_S1(disp 0),
--   COMP_PRINT_SPOT_WHITE_S1(1), COMP_PAPER(2), COMP_PP_CORNER_RIGHT(3),
--   COMP_PP_CREASE_1L(4), COMP_PP_PERF_1L(5), COMP_PP_VARTEXT_1EA(6), COMP_PP_VARIMG_1EA(7)
--   ★ COMP_PRINT_DIGITAL_S2 부재

-- S2 del_yn
SELECT comp_cd, del_yn FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_PRINT_DIGITAL_S1','COMP_PRINT_DIGITAL_S2');
-- → S1 del_yn=N · S2 del_yn=Y (논리삭제)

-- S2가 배선된 공식
SELECT frm_cd, count(*) FROM t_prc_formula_components
 WHERE comp_cd='COMP_PRINT_DIGITAL_S2' GROUP BY frm_cd;
-- → PRF_DGP_B(1), PRF_DGP_C(1), PRF_DGP_F(1)  ※ A/D/E는 없음
```

**판정**: codex의 "PRF_DGP_A에 S2 미배선·S2 del_yn=Y dead-wire(B/C/F 잔존)"이 **정확**. 기존 Claude `verdict-claude.md` §1 "COMP_PRINT_DIGITAL_S2가 PRF_DGP_A에 양면키로 배선·S1+S2 둘 다 발화(F-2 이중배선)"은 **라이브 부정**. Claude recompute의 BASELINE 26,250(=S1 350×25 + S2 700×25)은 **S2가 배선됐다는 거짓 전제**로 산출됨(recompute_fixed.py L93 "S1+S2 둘다 배선"·prior formula_comps.json이 frm_cd 없이 S1·S2 둘 다 포함). 실제 라이브 PRF_DGP_A 단면 qty25 인쇄비 = S1.POPT1 단독 = 350×25 = 8,750.

### 판정 2 — S1/S2 의미(print_opt=면 vs 도수) → **codex 맞음 / Claude 라벨 날조**

```sql
-- 라이브 print-option 마스터: print_opt_cd가 면인가 도수인가?
SELECT print_opt_cd, print_opt_nm, print_side, front_colrcnt_cd, back_colrcnt_cd
  FROM t_prt_print_options WHERE print_opt_cd IN ('POPT_000001','POPT_000002');
-- → POPT_000001 | 단면 | 단면 | CLR_000005 | CLR_000001
--   POPT_000002 | 양면 | 양면 | CLR_000005 | CLR_000005   ★ print_opt = 면(단/양)

-- 도수 코드 의미
SELECT clr_cd, clr_nm FROM t_clr_color_counts WHERE clr_cd IN ('CLR_000001','CLR_000005');
-- → CLR_000001 | 인쇄 안 함   ·   CLR_000005 | CMYK 4도

-- S1이 단/양 둘 다 운반하는가
SELECT count(DISTINCT print_opt_cd), string_agg(DISTINCT print_opt_cd,',')
  FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1';
-- → 2 | POPT_000001,POPT_000002  (S1 단일 comp가 단·양 둘 다)

-- 단가(SIZ_000499 국4절 316x467, min_qty 25)
-- S1: POPT1=350, POPT2=800   /   S2: POPT1=700, POPT2=1600
```

**판정**: print_opt_cd는 **면(단/양)**이며 라이브 마스터가 literal "단면/양면"으로 확정. 도수(흑백/칼라)는 print_opt에 **없고** front/back_colrcnt_cd로 별도 보유(PRD_000016 front=CLR_000005 CMYK 고정=칼라전용은 사실). codex의 "S1 단가행 n_print_opt=2·S1 단일 comp가 단/양 운반·면 소실 아님·실제 결함은 도수 소실"이 **정확**. Claude `verdict-claude.md` §1 표의 "S1 POPT_000001=흑백단면·POPT_000002=칼라단면, S2=양면"과 그 단가값(450/400/350/130, 900/850/800/310 등)은 **라이브 부재 = 날조**(실제 S1 POPT1=3000/2000/.../350, POPT2=4000/.../800 = 수량구간 단가·도수 무관). 따라서 Claude의 "F-1 도수/면 충돌"은 진단 자체는 도수축 부재를 가리켰으나 그 입증 표가 거짓 라벨이라 **부정확한 방식으로 옳은 결론**에 도달(M-1이 정확한 입증).

### 판정 3 — 별색 경로(SPOT proc_cd) → **codex 맞음**

```sql
SELECT count(*), count(DISTINCT proc_cd), string_agg(DISTINCT proc_cd,','),
       count(*) FILTER (WHERE clr_cd IS NULL)
  FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_SPOT_WHITE_S1';
-- → 530 | 5 | PROC_000008,000009,000010,000011,000012 | 530 (clr_cd 전부 NULL)
```

**판정**: codex의 "SPOT_WHITE_S1 proc_cd 5종이 별색 5종 운반(530행)·별색 경로 실재·clr_cd NULL"이 **정확**. 별색종류는 clr_cd가 아니라 proc_cd가 운반. 단 상품별 별색 proc 매칭(021/022 등 옵션/제약층)은 본 트랙 범위 밖([가설] 잔존)이라고 정직 표기함 = dodge 없음.

---

## 발견 결함 / dodge

| ID | 결함 | 위치 | 영향 | 라우팅 |
|----|------|------|------|------|
| **V-CRIT-1** | 기존 premium-postcard `verdict-claude.md`가 **틀림** — S2 PRF_DGP_A 배선 거짓 전제·POPT 흑백/칼라 라벨 날조·BASELINE 26,250 거짓 산출 | `huni-quote-verify/premium-postcard/02_verify/verdict-claude.md` | §15 하네스 프리미엄엽서 결론 무효 | 해당 verdict 폐기·재작성(생성≠검증 위반 사례) |
| V-2 | `_live-facts.md` L2 "COMP_PP_CORNER 미배선" 오기 — 라이브엔 CORNER_RIGHT disp_seq3 배선됨. codex M-4가 상속 | `03_audit/_live-facts.md` L26, `gap-defect-board.md` M-4 | M-4 "CORNER 미배선"은 부정확(CORNER_RIGHT는 배선됨·CORNER_ROUND 등 형제만 미배선) | 큐레이션 정정 |
| V-3 | 레시피 "30상품" 헤딩 vs 실제 31행·PRD_000038 형압명함 행 누락 | `recipe-디지털인쇄.md` §(2)·§(3) | 경미(레시피 스스로 GAP 자인) | 식별자 정합 보정 |
| V-4 | 화이트인쇄엽서 PNG 미생성(mermaid만) | `02_viz/` | R3 부분(mermaid 정확하므로 산출 유효) | 필요 시 codex 1장 추가 |

**dodge 0**: codex 산출은 미바인딩·FOLD_SUM 붕괴·도수 소실·희소 단가행을 전부 빨강 강조·보드 명기. GAP 침묵 없음. 오히려 자기 레시피 시드 3건을 라이브로 자진 반증(과장 제거).

---

## 종합 판정

- **본 하네스(huni-recipe-viz 디지털인쇄) 산출 = GO** (R1·R2·R3·R4·R5 PASS, R6 CONDITIONAL=정직한 미완 기록). codex 생성 레시피·시각화·연결진단은 라이브 충실·날조 0.
- **divergence = codex 3/3 승**. 기존 Claude premium-postcard 검증이 핵심 사실(S2 배선·POPT 의미)에서 틀렸음을 라이브 psql로 확정.
- **후속 필수**: ① `verdict-claude.md` 폐기·재작성(올바른 전제=PRF_DGP_A S1단독·POPT=면·도수축 부재) ② 진짜 가격 정답(단면 단가가 350이냐 800이냐 = 가격표 260527 권위)은 본 트랙 범위 밖 → dbm-price-arbiter/§13 위임 ③ `_live-facts.md` CORNER 오기 정정.
