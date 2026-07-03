# 088 레더 링바인더 — 면지(면지) 통합 재설계 명세

> §23 Huni-Set-Product · hsp-set-designer · 2026-07-03 · **DB 미적재(설계·적재본까지)**
> 파일럿 072/077 완주(COMMIT·S1~S8 GO) → 088 동형 전파. 라이브 읽기전용 실측(`.env.local RAILWAY_DB_*`) + 실엔진 골든 재현.
> 근거 계열 명세: `../redesign-spec.md`(072 파일럿)·`../077/apply-077.sql`(077 동형).

---

## 0. 결론 요약 (TL;DR)

- **면지 통합은 가격 무손상(라이브 실엔진 실증).** 면지 멤버 090~093은 가격공식 0건 → evaluate_set_price 기여 **정확히 0**. 4→1 통합·자재 부여·색 택1 전부 골든 불변.
- **088 현행 라이브 골든(COVERBIND 모델) = 34,100 / 159,100 / 796,900** (1/10/100부, 실엔진 재현·§4). 면지 통합 후 **동일**.
- **★★088-redesign-260702(표지 9,000/부·member 089·싸바리)는 라이브 실측 결과 미적재(COMMIT 미실행) 확정.** 본 면지 통합은 그 재설계와 **완전 직교**(겹치는 행 0) → 어느 순서로도 충돌 없음(§2).
- 적재본 `apply-088.sql`(8스텝) + `undo-088.sql`. 전부 멱등·기존 참조(**신규 mint 0·물리 DELETE 0**). DRY-RUN 2회 통과(트리거 OK·롤백).

---

## 1. 현재 구조 (라이브 실측 · 2026-07-03)

### 1.1 셋트 멤버 (t_prd_product_sets · del_yn=N)
| disp_seq | sub_prd_cd | prd_nm | 역할 | 유형 | 공식 |
|---|---|---|---|---|---|
| 1 | PRD_000089 | 레더 링바인더-표지(레더(화이트)) | SEMI_ROLE.02 표지 | .02 반제품 | **0건**(현행) |
| 2 | PRD_000090 | 레더 링바인더-면지(화이트면지) | SEMI_ROLE.03 면지 | .02 | 0건 |
| 3 | PRD_000091 | 레더 링바인더-면지(블랙면지) | .03 | .02 | 0건 |
| 4 | PRD_000092 | 레더 링바인더-면지(그레이면지) | .03 | .02 | 0건 |
| 5 | PRD_000093 | 레더 링바인더-면지(인쇄면지) | .03 | .02 | 0건 |

- **내지 멤버 없음** = 빈 바인더 확정(상품시트 내지 전칸 빈칸·072/077과 다름).
- 면지 090~093 = **완전 빈 껍데기**(materials/opt_groups/formulas 전부 0 실측).
- 멤버 6개(088~093) 전부 라이브 실재·.02 반제품 → **search-before-mint 통과, mint 0**.

### 1.2 부모 088 자재 / 옵션
| 축 | 내용 | 처분 |
|---|---|---|
| USAGE.03 (면지자재) | MAT_382(화·dflt)/383(블)/384(그)/**385(인쇄)** | → 면지멤버 090 이관 후 부모 **은퇴** |
| **USAGE.07 (D링자재)** | MAT_248/249/**247** | **★불가침 — 미터치**(표지/바인딩 자재) |
| OPT_067 (면지색) | OPV_444화→MAT_382 / 445블→383 / 446그→384 / **447인쇄→385** (ref_dim OPT_REF_DIM.03·USAGE.03) | → 면지멤버 090 이관 후 부모 **은퇴** |

### 1.3 부모 088 가격 (현행 = COVERBIND 임시 모델)
- 부모공식 `PRF_LEATHER_RINGBINDER_SET` → `COMP_HC_MUSEON_COVERBIND` (prc_typ=PRICE_TYPE.01 단가형·use_dims=`["min_qty"]`).
- COVERBIND 밴드: 1부34,100/4부22,425/10부15,910/50부10,170/100부7,969/1000부6,368.4 (권당·part).
- 088 할인테이블 0건. → 골든 = COVERBIND 밴드단가 × 부수.

---

## 2. ★★088-redesign-260702 조율 판정 [HARD·최우선]

### 2.1 COMMIT 여부 = **미적재(pending)** 확정 (라이브 실측 2026-07-03)
| 재설계 조각 | 라이브 실측 | 판정 |
|---|---|---|
| COMP_LEATHER_RINGBINDER_COVER (표지 소재+인쇄비 comp) | **부재**(0건) | 미적재 |
| 9,000 단가행 | **부재** | 미적재 |
| PRF_LEATHER_RINGBINDER_COVER (표지 공식) | **부재** | 미적재 |
| 089 공식 바인딩 | **0건** | 미적재 |
| 부모 PRF_LEATHER_RINGBINDER_SET 배선 | **여전히 COMP_HC_MUSEON_COVERBIND**(SSABARI 아님) | 미적재(재설계 미반영) |
| 088 product_processes (PROC_000098) | **0건** | 미적재 |

→ **결론: 088-redesign(9,000+싸바리)는 아직 COMMIT되지 않았고, 라이브는 임시 COVERBIND 모델 그대로.** 메모리 기록("적재 승인 대기·COMMIT 미실행")과 일치.

### 2.2 직교성 판정 = **완전 직교(겹치는 행 0)**
| 테이블 | 면지 통합(본 건) | 088-redesign(pending) | 충돌 |
|---|---|---|---|
| t_prd_products | 090 rename·091~093 use_yn=N | 088 use_yn=Y(멤버 미터치) | 없음(다른 행) |
| t_prd_product_sets | 091~093 del_yn=Y | — | 없음 |
| t_prd_product_materials | 090 USAGE.03 추가·088 USAGE.03 은퇴 | — | 없음 |
| t_prd_product_option_* | 090 OPT_067 추가·088 OPT_067 은퇴 | — | 없음 |
| t_prc_price_components/formulas/component_prices | — | 표지 comp/공식/9,000 mint | 없음 |
| t_prc_formula_components | — | 부모 배선 COVERBIND→SSABARI | 없음 |
| t_prd_product_price_formulas | — | 089 바인딩 | 없음 |
| t_prd_product_processes | — | 088 PROC_000098 | 없음 |

- **면지 통합이 건드리는 멤버 = 090/091/092/093** · **088-redesign이 건드리는 멤버 = 089**. 겹치지 않음.
- 부모 레벨도 서로 다른 테이블/컬럼(면지=옵션·자재 은퇴 / 재설계=공식배선·proc). **겹치는 행 0**.
- **★USAGE.07 D링·표지 089·SSABARI/COVERBIND 배선·9,000 mint는 본 건이 일절 미터치** → 088-redesign이 언제 COMMIT되든 무손상.

### 2.3 골든 중립성 = 두 표지모델 모두에서 불변
- 면지 멤버(090~093)는 **공식 0건 → 두 모델 어디서도 기여 0**.
- 표지 원가는 **부모 COVERBIND(현행)** 또는 **member 089+부모 SSABARI(재설계)** 중 하나 — **둘 다 면지 통합이 미터치**.
- ∴ 면지 통합 적용 후 골든:
  - COVERBIND 현행 위: **34,100 / 159,100 / 796,900**(불변)
  - 088-redesign COMMIT 후: **39,000 / 290,000 / 1,800,000**(재설계 골든 불변)

### 2.4 선후 순서 판정 = **순서 무관(FREE) · 병렬 안전**
- 겹치는 행 0 + 골든 중립 → **면지 통합은 088-redesign COMMIT 전/후/동시 어느 순서로도 안전**.
- 임의 병합 금지(directive) 준수: **본 apply-088.sql은 면지 통합분만** 담고, 088-redesign 재설계분(9,000·SSABARI·proc)은 **별도 파일(`../../088-redesign-260702/apply.sql`) 소관으로 분리 유지**. 두 파일을 합치지 않는다.
- **권고**: 두 건 모두 게이트 GO·승인 대기 상태이므로, load-executor 적재 시 **한 승인 세션에서 두 apply를 순차 실행**(순서 무관)하거나 각각 독립 실행. 보류 불필요(충돌 없음).

---

## 3. 목표 모델 [HARD · 사용자 directive · 072/077 동형]

088 = **표지(089) + 면지(1개=090)**. 면지색(화/블/그/인쇄)은 **090 내부에서 택1**. 내지 없음.

1. **면지 멤버 1개 통합** — 090을 "레더 링바인더-면지"로 리네이밍. 091/092/093은 셋트에서 은퇴(`t_prd_product_sets.del_yn=Y` + `t_prd_products.use_yn=N`).
2. **면지자재 4종을 090에 이관** — MAT_382/383/384/385(USAGE.03). 시뮬레이터/위젯 구성원 UI가 **구성원 자재 드롭다운(용지 select)**을 렌더 → 자재 4종 = 화/블/그/인쇄 택1. 기본자재(dflt_yn=Y)=화이트(MAT_382).
3. **면지색 옵션그룹도 090에 이관** — OPT_067 + OPV_444~447 + 아이템(CPQ/주문 계층·동일코드 재사용·PK=prd_cd 스코프). **★fn_chk_opt_item_ref 트리거**: OPT_REF_DIM.03 아이템은 참조 자재(MAT_382~385 USAGE.03)가 **같은 prd_cd(090)에 실재**해야 함 → 반드시 [자재 이관] 후 [옵션 이관] 순서.
4. **부모 088 면지색 옵션·면지자재 은퇴** — 이관 후 OPT_067(items→options→group) + USAGE.03 자재(382~385) 논리삭제(del_yn=Y). 셋트공식 use_dims에 mat_cd 없음(§4) → 가격 무영향. **★USAGE.07 D링 자재 미변경.**

---

## 4. 가격 정합·무손상 (라이브 실엔진 실증)

`evaluate_set_price`(pricing.py:854) = Σ 구성원 evaluate_price + 부모공식(copies) + 할인. 면지 멤버는 **공식 없음 → 기여 0**(자재 유무 무관).

- 부모공식 자재 종속성 실측: `PRF_LEATHER_RINGBINDER_SET` use_dims=`["min_qty"]` — **자재 미종속** → 부모 면지자재 은퇴가 부모공식 가격에 무영향.
- **이중합산 0** — 면지비는 어디에도 이중 계상 안 됨(면지=제본비 포함 도메인·멤버 기여 0). 골든 불변이 이를 증명.
- **삼각확인(면지 기여 0)**:
  1. 멤버 089~093 가격공식 바인딩 = 0건(실측) → member evaluate_price 진입 자체 0.
  2. 부모공식 use_dims=["min_qty"] = 자재 미참조 → 면지자재 은퇴 무영향.
  3. 실엔진 골든 재현(§ golden-reproduce-088.md) 재설계 전=후 동일 34,100/159,100/796,900.

---

## 5. 적재 항목 (apply-088.sql 매핑) — 8스텝

| # | 테이블 | 작업 | 대상 | 멱등 키 |
|---|---|---|---|---|
| 1 | t_prd_products | UPDATE(rename) | 090 → "레더 링바인더-면지" | prd_cd(조건부) |
| 2 | t_prd_product_materials | INSERT(이관) | 090 ← MAT_382/383/384/385 USAGE.03 | ON CONFLICT(prd_cd,mat_cd,usage_cd) |
| 3 | t_prd_product_option_groups | INSERT(이관) | 090 ← OPT_067 | ON CONFLICT(prd_cd,opt_grp_cd) |
| 4 | t_prd_product_options | INSERT(이관) | 090 ← OPV_444~447 | ON CONFLICT(prd_cd,opt_cd) |
| 5 | t_prd_product_option_items | INSERT(이관·트리거) | 090 ← 4아이템(MAT ref) | ON CONFLICT(prd_cd,opt_cd,item_seq) |
| 6 | t_prd_product_option_* | UPDATE(은퇴) | 088 OPT_067 items→options→group | del_yn=Y(멱등) |
| 7 | t_prd_product_materials | UPDATE(은퇴) | 088 USAGE.03 382~385 (**USAGE.07 격리**) | del_yn=Y(멱등) |
| 8 | t_prd_product_sets/products | UPDATE(은퇴) | 091/092/093 del_yn=Y·use_yn=N | del_yn=Y(멱등) |

- **신규 mint 0** · **물리 DELETE 0** · 순서[HARD]=자재[2]→옵션[3~5]→은퇴[6~7]→정리[8].

---

## 6. search-before-mint / 경계 준수

- **신규 mint 0** — 면지 멤버(090)·자재(MAT_382~385)·옵션(OPT_067·OPV_444~447)·아이템 전부 라이브 기존 참조. 재사용만.
- **경계(옵션오염 방지 §3 스킬)** — 면지 멤버 090엔 자기 면지자재(USAGE.03)만. 088의 표지/바인딩 자재(USAGE.07 D링)는 090으로 끌어오지 않음(WHERE에 usage_cd='USAGE.03' + mat 명시로 격리). 부모공식 공유(COVERBIND/향후 SSABARI)는 자재 미종속이라 오염 없음.
- **product-type-board** — 면지 멤버 090(=.02 반제품·SEMI_ROLE.03) 유지. 구성원 전부 반제품.

---

## 7. 잔여 / 후속 (게이트 인계)

| 항목 | 상태 |
|---|---|
| 면지 통합(4→1·자재/옵션 이관·부모 은퇴) | 설계 완료·apply-088.sql·DRY-RUN 2회 통과 |
| USAGE.07 D링 불가침 | 확인(DRY-RUN 실측 3종 잔존) |
| 088-redesign 조율 | **미적재 확정·완전 직교·순서 무관**(§2) — 병합 안 함 |
| 인쇄면지(MAT_385/OPV_447) 인쇄비 실현 | **선존 이슈·본 건 무손상 보존만**(면지 멤버 무공식 → "인쇄" 선택해도 인쇄비 0) → 후속 §18(D-3) |
| 구성원 옵션그룹 시뮬레이터 렌더 | 휴면(색 택1은 자재로 발현) → 후속 DEV-REQUEST(D-1) |

## 산출물
- `apply-088.sql` / `undo-088.sql` — 8스텝 멱등. DB 미적재.
- `golden-reproduce-088.md` — 라이브 실엔진 골든 재현(무손상 DRY-RUN).
- `redesign-spec-088.md`(본 문서) · `blocked-board-088.csv` · `t_prd_product_sets-088.csv`.
- 다음: codex 독립 2차 → S1~S8 게이트(evaluate_set_price 재계산·DRY-RUN) → 인간 승인 → load-executor COMMIT → webadmin 실화면(제외0·PRICE≠0).
