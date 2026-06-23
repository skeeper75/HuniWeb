# validation-r1-r6.md — RC-2 추가물형(비BLOCKED) 적재본 R1~R6 독립 검증

> dbm-validator · 2026-06-23 · §21 RC-2. **생성자(arbiter·option-mapper·load-builder) 주장 비신뢰 — 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN + 엔진 순수함수 재현으로 전건 직접 재실측.**
> 자격증명 `.env.local RAILWAY_DB_*`. 라이브 파괴적 쓰기 0 (전 DRY-RUN `BEGIN…ROLLBACK`·COMMIT 0).
> 대상 = 메쉬현수막(139)·캔버스행잉(133)·린넨우드봉(134) 3상품 23행. PET(136)=HOLD-1 BLOCKED 제외분 확인.
> 권위순서[HARD]: silsa-l1(260610) + **라이브 t_prc_component_prices verbatim**(단가) · pricing.py `_row_matches`/`match_component`(엔진).

---

## 종합 판정: **GO**

R1~R6 전 게이트 PASS. 단일 FAIL 없음. 생성자 산출을 재사용하지 않고 라이브·권위·엔진 원본 직접 대조로 독립 입증.
실 COMMIT(`./apply.sh commit`)은 본 GO + **인간 승인** 후 hbd-load-executor / dbm-load-execution이 수행. 검증자는 COMMIT 권한 없음.

| 게이트 | 항목 | 판정 | 핵심 근거 |
|---|---|---|---|
| R1 | 권위 충실성 (단가 verbatim) | **PASS** | 라이브 단가행 8개 = 적재본 주장과 1원도 안 틀림. 적재 중 단가 0 변경(DRY-RUN 합계 불변) |
| R2 | 라이브 정합 | **PASS** | opt MAX·comp·use_dims·단가행 PK·frm·siz 등록·disp·바인딩충돌 전건 라이브 일치 |
| R3 | 멱등성 (2-pass) | **PASS** | DRY-RUN 직접: PASS1 23행·PASS2 0행 재현 |
| R4 | 차원·엔진 정합 (always-add 가드) | **PASS** | 엔진 순수함수 재현: 미선택 가산0·선택 정확단가·ERR 0·RC-4 재배선 정합 |
| R5 | 제약·부작용 범위 | **PASS** | FK 부모 실재·23행 외 영향0·기초코드 마스터 불변·PET 완전 제외·undo 정확 원복 |
| R6 | 생성-검증 독립성 | **PASS** | 라이브 SELECT·엔진 코드·권위 엑셀 원본 직접 대조 (생성자 산출 0 재사용) |

---

## R1 — 권위 충실성 (단가 verbatim·날조 0) · PASS

### 라이브 직접 SELECT (단가행 8개)
```sql
SELECT comp_price_id, comp_cd, siz_cd, opt_cd, unit_price, apply_ymd
FROM t_prc_component_prices WHERE comp_price_id IN (4751,4753,4598,4599,4600,4604,4605,4606);
```
| id | comp | 단가(라이브) | 적재본 주장 | 일치 |
|---|---|---|---|---|
| 4751 | MESH_ADD_QBANG_4 | 3000.00 | 3000 (큐방) | ✅ |
| 4753 | MESH_ADD_STRING_4 | 4000.00 | 4000 (끈) | ✅ |
| 4598 | CANVAS_HANGING_WOODHANGER | 16000.00 | 16000 (우드행거 A4) | ✅ |
| 4599 | 〃 | 18000.00 | 18000 (A3) | ✅ |
| 4600 | 〃 | 20000.00 | 20000 (A2) | ✅ |
| 4604 | LINEN_WOODBONG_WOODBONG | 7000.00 | 7000 (우드봉 A4) | ✅ |
| 4605 | 〃 | 9800.00 | 9800 (A3) | ✅ |
| 4606 | 〃 | 12000.00 | 12000 (A2) | ✅ |

### 권위 엑셀(silsa-l1 260610) 교차 — 권위순서 명시
- silsa-l1에서 캔버스(004-0017)·린넨(004-0018) 추가물 단가는 `???`·"신규 사이즈 가격 알아봐야함"으로 **미명시**.
  메쉬현수막(005-0004)은 "추가없음/끈추가"만 명시(큐방은 일반현수막 005-0003에 명시). → **엑셀에 단가 셀 부재**.
- 명세·설계가 천명한 권위순서[HARD] = "silsa-l1 + **라이브 t_prc_component_prices verbatim**". 엑셀 단가 부재 영역의 단가 권위는 **라이브 단가행**이며, 적재본은 그 라이브값을 1원도 변경 없이 유지.
- R3 DRY-RUN 적재후 단가 합계: 3000·4000·54000(16000+18000+20000)·28800(7000+9800+12000) = **라이브 현재 합계와 동일** → 적재 중 단가 변경 0.
- **결론: 단가 날조·임의값 0. opt_cd/siz_cd만 충전, unit_price는 WHERE 가드값으로만 참조(미변경).** PASS.

---

## R2 — 라이브 정합 (대상행·코드·채번) · PASS

전 항목 라이브 직접 SELECT로 재실측, 적재본 manifest 주장과 전건 일치:

| 검증 | 라이브 실측 | 결과 |
|---|---|---|
| opt_cd 채번 MAX (`^OPV_[0-9]{6}$`) | OPV_000424 | ✅ 신규 425/426/429/430 충돌 0 (4종 SELECT=0행) |
| 대상 4 comp 실재·현재 use_dims | 메쉬 2개 `[]`·캔버스/린넨 `["siz_cd"]` | ✅ 명세 현재값 일치 |
| 단가행 PK·comp_cd·siz_cd·opt_cd(NULL) | 위 R1 표 | ✅ comp_cd 오타 0·잘못된 행 타격 0 |
| 본체 공식 frm_cd 3종 | 133=PRF_POSTER_CANVAS_HANGING·134=LINEN_WOODBONG·139=BANNER_M | ✅ |
| frm 마스터 실재 (`t_prc_price_formulas`) | 3종 실재 | ✅ 바인딩 FK 부모 확인 |
| 옵션그룹 3종 실재 (`t_prd_product_option_groups`) | (133,OPT_000012)·(134,OPT_000014)·(139,OPT_000023) | ✅ FK 부모 |
| 각 그룹 disp_seq MAX | 전부 1 | ✅ 신규 2/3 충돌 0 |
| 대상 4 comp 기존 바인딩 | 0행 | ✅ 바인딩 충돌 0 |
| 대상 frm disp_seq MAX | 전부 1 | ✅ 신규 disp 2/3 충돌 0 |
| comp_cd 최장 길이 (varchar(50)) | 40자 | ✅ |

---

## R3 — 멱등성 (롤백전용 DRY-RUN 2-pass 직접 실행) · PASS

`apply.sql` 4단계를 같은 트랜잭션에서 연속 2회 실행 후 ROLLBACK (라이브 무변경 확인).

```
PASS 1: INSERT 0 1 ×4 (옵션) · UPDATE 1 ×15 (use_dims4+opt_cd8+siz3) · INSERT 0 1 ×4 (바인딩)  = 23행
PASS 2: INSERT 0 0 ×4         · UPDATE 0 ×15                          · INSERT 0 0 ×4          = 0행
```
- 제약위반(FK/NOT NULL/CHECK/트리거) 0 — `ON_ERROR_STOP on` 하 전 문장 통과.
- 가드 작동 입증: `NOT EXISTS`(옵션)·`IS DISTINCT FROM`(use_dims·siz)·`unit_price = verbatim AND opt_cd IS DISTINCT`(opt)·`ON CONFLICT DO UPDATE WHERE`(바인딩).
- siz_cd UPDATE의 `siz_cd IN (cur,new)` 가드로 오행 보호 확인(PASS2 0행).
- 적재후 상태 직접 SELECT: 옵션 disp 2/3/2/2·use_yn=Y·del_yn=N / use_dims opt_cd 충전 / 단가행 siz 재배선(4598→172·4599→174·4600→197)·opt 충전 / 바인딩 addtn_yn=Y. **단가 합계 불변.**

---

## R4 — 차원·엔진 정합 (★always-add 가드 핵심) · PASS

pricing.py `_row_matches`/`match_component` **순수함수를 Django 비의존으로 재구현해 라이브 단가행 입력으로 재현**(코드 로직 verbatim 복사).

### 우드행거(설계후: use_dims opt_cd 포함·단가행 opt_cd=OPV_000429 충전)
| 입력 | 결과 | 판정 |
|---|---|---|
| 출력만(opt_cd=OPV_000030)+siz172 | row=None → 가산 0 | ✅ |
| opt_cd 없음+siz172 | row=None → 가산 0 | ✅ always-add 해소 |
| 우드행거 선택+siz172/174/197 | 16000/18000/20000 단일·error=None | ✅ |
| (현재 결함 재현: opt_cd NULL+출력만) | 가산 16000 | 🔴 결함 입증(opt 충전 전) |

### 메쉬 큐방/끈 (opt_cd만·siz_cd 없음)
| 입력 | 결과 | 판정 |
|---|---|---|
| 큐방·추가없음(OPV_000045) | row=None → 가산 0 | ✅ |
| 큐방 선택(OPV_000425) | 3000 | ✅ |
| 끈 선택(OPV_000426) | 4000 | ✅ |

### 우드봉 (린넨·재배선 불요·258/315/317)
| 입력 | 결과 | 판정 |
|---|---|---|
| 우드봉 미선택+siz258 | row=None → 가산 0 | ✅ |
| 우드봉+258/315/317 | 7000/9800/12000 | ✅ |

- **ERR_AMBIGUOUS/ERR_DUPLICATE = 0건** (전 케이스 단일 조합 매칭).
- **RC-4 재배선 정합 (결정적)**: 캔버스 본체 comp `COMP_POSTER_CANVAS_HANGING`의 use_dims=`["siz_width","siz_height","min_qty"]` → 본체는 **siz_cd 미사용**(치수 티어). 따라서 본체 단가행 siz_cd(258/315/317)는 본체 매칭에 무관, 본체↔가산 격자 충돌 없음.
  우드행거 가산은 use_dims에 siz_cd 포함 → selections.siz_cd(=상품133 등록사이즈 **172/174/197**)로 매칭. 현재 258/315/317은 133 미등록 → 매칭불가. **재배선 172/174/197 필요·정합 확정** (치수 대조: 258=A4 210×297=172 / 315=A3 297×420=174 / 317=A2 420×594=197). 린넨(134) 등록사이즈=258/315/317 → 우드봉 재배선 불요 확인.

---

## R5 — 제약·부작용 범위 · PASS

| 검사 | 라이브/적재본 실측 | 결과 |
|---|---|---|
| 옵션 INSERT FK (부모 그룹) | 3 그룹 실재·opt_cd PK 충돌 0 | ✅ |
| 옵션 NOT NULL (prd_cd·opt_cd·opt_grp_cd·opt_nm·use_yn·del_yn·reg_dt) | INSERT가 전 컬럼 명시 충전 | ✅ |
| 바인딩 FK (frm_cd→t_prc_price_formulas·comp_cd→t_prc_price_components) | 3 frm·4 comp 실재·PK=(frm,comp) | ✅ |
| 바인딩 disp_seq 중복 | UNIQUE 제약 無·신규 2/3 기존 충돌 0 | ✅ |
| addtn_yn CHECK ('Y'/'N') | 적재값 'Y' | ✅ |
| 23행 외 영향 | DRY-RUN 영향행수 정확히 23 (PASS1) | ✅ |
| 기초코드 마스터 (t_siz_sizes/t_mat) | UPDATE 대상 0 (siz_cd 재배선은 component_prices의 참조값만 변경·siz 마스터 행 불변) | ✅ |
| PET(136) 완전 제외 | apply.sql의 'PET' 매칭=주석 1건뿐·STAND_OUT/STAND_IN/OPV_000427/428/OPV-000019/PRD_000136 실 구문 0 | ✅ |
| undo round-trip | apply→undo 같은 tx: opt_remaining=0·use_dims 원복([]·["siz_cd"])·단가행 siz258/opt NULL 복귀·단가 verbatim·bind_remaining=0 | ✅ 정확 원복 |

---

## R6 — 생성-검증 독립성 · PASS

- 라이브 DB 직접 SELECT(채번·comp·단가행·frm·siz·그룹·바인딩), 엔진 `pricing.py` 코드 직접 재현(`_row_matches`/`match_component` verbatim), 권위 엑셀 `silsa-l1.csv` 직접 대조.
- arbiter `rc2-silsa-addon-binding-design.md`·option-mapper `rc2-addon-load-spec-unblocked.md`·builder `dryrun-result.md`는 **검증 대상**으로만 읽고, 그 판정값을 근거로 채택하지 않음.
- 빌더 측 DRY-RUN 결과(23행·멱등·always-add)를 **독립적으로 재현해 동일 결과 확인** — self-approve 아님.

---

## 잔존 BLOCKED/HOLD (적재본 범위 밖·정직 보고)

- **PET S1/S2 (HOLD-1·BLOCKED)**: OPT-000009 그룹 모델링 충돌(실외용거치대 통합 vs 단면/양면). 실무진 CONFIRM 전 제외 — 적재본에서 정확히 배제됨(R5 확인).
- **option_item(MES 환원) HOLD-2/3**: 큐방 자재 MAT_000337(139 미등록)·우드 부속 자재 미확정. **가격 무영향**(가격=단가행 opt_cd/siz_cd) → 본 적재본은 가격 정합만 달성, 자재 환원은 후속 트랙. 적재본에 option_item INSERT 없음(정합).

---

## 인간 결정 큐

1. **실 COMMIT 승인**: 본 GO를 토대로 `./apply.sh commit` 실행 여부 (검증자는 COMMIT 불가).
2. **PET S1/S2 모델링 CONFIRM** (HOLD-1) — 별 트랙.
3. **자재행 선등록** (HOLD-2/3) 후 option_item MES 환원 후속 — 가격 무영향.
