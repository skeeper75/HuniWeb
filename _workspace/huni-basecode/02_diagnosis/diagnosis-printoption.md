# 진단 보드 — (인쇄옵션) `t_prd_product_print_options` 🔴

> **하네스** hbg Phase 2 진단가 · 2차 회차. **작성** 2026-06-18. 라이브 읽기전용 SELECT(2026-06-18).
> **기준선:** `01_authority/axis-authority-printoption.md`. **결론: print_side에 UV 변형 enum 오적재 63행 잔존(🔴) — round-13 진단 CONFIRMED.**

---

## 0. 라이브 실측

```
SELECT count(*) FROM t_prd_product_print_options;                 -- 166 (정답 사전 §0 일치)
SELECT print_side, count(*) FROM t_prd_product_print_options GROUP BY print_side;
SELECT front_colrcnt_cd, count(*) ... GROUP BY front_colrcnt_cd;
```

| print_side | count | 정답 판정 |
|-----------|:--:|-----------|
| 단면 | 62 | ✅ 정상 인쇄면 |
| 양면 | 41 | ✅ 정상 인쇄면 |
| **풀빼다** | 21 | 🔴 UV 변형 enum(print_side 아님) |
| **배면양면** | 21 | 🔴 UV 변형 enum |
| **투명테두리** | 21 | 🔴 UV 변형 enum |

- **행수 166 = 정답 사전 §0 권위와 일치**(C-PO-3 해소: ref-csv 172는 del 반영 전 stale, 권위=166).
- **정상(단면/양면) 103 vs UV변형 63** = 38%가 print_side 칸에 UV 변형값.
- **colrcnt 별색 혼입 0**: front_colrcnt_cd 전건 CLR_000005(4도)·back ∈ {CLR_000001 인쇄안함, CLR_000005}. CLR 5종 밖 값 **0건**. 별색이 colrcnt로 새지 않음(✅).

---

## 1. UV 변형 enum 오적재 진단 (🔴 핵심 결함)

**대상 21상품 = 아크릴 굿즈**(라이브 실측):

| prd_cd | prd_nm | 인쇄방식(product_processes) |
|--------|--------|------------------------------|
| PRD_000146 | 아크릴키링 | PROC_000002 (UV) |
| PRD_000147 | 아크릴마그넷 | PROC_000002 (UV) |
| PRD_000148 | 아크릴뱃지 | PROC_000002 (UV) |
| PRD_000149 | 아크릴집게 | PROC_000002 (UV) |
| … | (21상품 중 **14만 UV 실연결**·7 공정연결 전무 — **[B2 정정 §6.2]** "전건 UV" 과장 철회) | PROC_000002 |

- 이 상품들의 `print_side`에 **풀빼다/배면양면/투명테두리**(각 21행) = `PROC_000002`(UV) `prcs_dtl_opt` 의 `{"key":"변형","values":["일반","배면양면","풀빼다","투명테두리","단면"]}` enum 값과 **동일**.
- 즉 print_side가 **인쇄면 축이 아니라 UV 변형 param 축으로 오용**됨(변형 enum에 "단면"이 포함돼 두 의미가 한 칸에 평면화).
- front=CLR_000005·back은 변형에 따라 CLR_000001(단면형) / CLR_000005(배면양면형) — **도수 자체는 정확**, 문제는 **print_side 칸의 도메인 오류**.

---

## 2. 4-way 대조

| 항목 | ①권위 | ②라이브 | ③역공학(rpmeta) | ④경쟁사 |
|------|-------|---------|-----------------|---------|
| UV 변형 저장처 [→§6.1 정정] | UV 변형=PROC_000002 param·선택값 목적지=**기존 `option_items.dtl_opt`**(라이브 실재). **print_side에 ✗**(OM-5) | **print_side에 풀빼다/배면양면/투명테두리 63행** = 오적재 | V-1이 `ref_param_json` 신설 제안했으나 **dtl_opt 미관측 오류** → data-gap(B4) | GAP-PROC-1 CIP4 Process+Parameter — 후니 dtl_opt 인스턴스 슬롯 **실재**(미적재) |
| 화이트/클리어 underbase | 디지털/실사→PROC_000008 별색·UV→PROC_000002 풀빼다(정답 사전 §2.1) | 본 21상품=UV → 풀빼다(=화이트 발색)가 print_side에. **별색 underbase로 갈 게 아니라 UV param** | vessel-print-method-recipe: 인쇄방식이 귀속 분기 | B-PO-1 일괄결정 후보 |
| 도수 colrcnt | CLR 5종 참조 | **혼입 0**(✅) | ③도수 진단과 정합 | (제외) 흡수·능가 |

---

## 3. 결함 전수 보드

| # | 현재값 | 정답 | 원인유형 | 결함종류 | 라우팅 | 컨펌 |
|---|--------|------|----------|----------|--------|------|
| PO-1 [→§6 정정] | print_side='풀빼다/배면양면/투명테두리' 63행 | UV 변형은 PROC_000002 인스턴스 param·선택값=**기존 `option_items.dtl_opt`**(B4·신설 불요). print_side는 단면/양면만 | ⓐ v03 전파(변형을 인쇄면칸에 평면화) + **ⓒ data-gap**(dtl_opt 그릇 실재·UV 변형 미적재) ← [B4: ⓑ→ⓒ] | 오염(잘못된 축 인코딩) | **교정**(변형값→dtl_opt 이관 + print_side 단면/양면 정규화). [B2] PO-1a(14 즉시)·PO-1b(7 연결선행) | **B-PO-1**(14 한정) |
| — | colrcnt 별색 혼입 | — | — | — | **결함 0**(✅) | — |

---

## 4. ★교정 영향 / FK 위상 [HARD]

| 사실(라이브 실측) | 함의 |
|-------------------|------|
| UV 오적재 21상품 = **아크릴 굿즈** [B2: 14 UV 실연결·7 무연결] | 14상품 print_side 행이 **가격사슬·option_items에 묶임**(round-23 acrylic). 색 siz 오염(가격 0참조)과 달리 **교정이 무비용 아님** |
| 변형 선택값 저장처 = **기존 `t_prd_product_option_items.dtl_opt`** [B4 정정] | print_side에서 변형값을 빼낼 목적지가 **이미 라이브 실재**(6행 공정 param 사용·동형 jsonb) → **신규 컬럼 신설 불요(mint 0)**. 그릇 선결 BLOCKED 해소 |
| 변형 enum에 "단면" 포함 | print_side 칸이 단면(인쇄면) + UV처리(풀빼다/배면양면/투명테두리)를 **한 축에 평면화** → 분리 시 단면형은 print_side='단면'으로, 나머지는 dtl_opt로 |

> **★[HARD] 교정 선후 [B4·B2 정정]:** ~~ref_param_json 컬럼 신설~~ **불요** → ① **UV 14 실연결**: 변형값을 기존 `dtl_opt`로 이관 → print_side 단면/양면 정규화(즉시·그릇 실재) / ② **UV 7 무연결**(명찰골드153·지비츠156·코스터159·코롯토164·포카코롯토165·카라비너166·지비츠★171): **PROC_000002 링크 선행** 후 이관(연결 없이 이관 시 고아 param·정체 BLOCKED). **순서 위반 시 변형 정보·가격 손실.**

---

## 5. dbmap 인용 (재진단 금지)

- **round-13** "print_side에 UV 전역 오적재" 진단 = **라이브 잔존 CONFIRMED**(63행). 재진단 아니라 현재 상태 재확인 — 미교정 상태 유지(round-23 acrylic은 이 print_side를 *그대로* 가격연결, 교정과 별개 트랙).
- **round-23** 아크릴 동형(siz_width/height·골든 30×30 3T)은 이 21상품 가격을 COMMIT — print_side UV값은 손대지 않음(교정 미실행 상태가 정상 인용).
- L2 CPQ option_items 대부분 미적재(OM-6) — print_side 오적재는 **L1 차원행 결함**(L2 포인터 아님).

---

## del_yn / use_yn 권위 적용

- print_side 오적재 63행은 **삭제 대상 아님**(교정 대상). del_yn='N' 유지·값만 정규화. 삭제 라우팅 0. del_yn 권위([[dbmap-del-yn-soft-delete-authority]])는 교정 트랙엔 비적용(소프트삭제 아님).

---

## 6. ★보완 진단 (검증자 B4 NO-GO + B2 과장 정정 — 라이브 재실측 2026-06-18)

### 6.1 [B4] dtl_opt jsonb 재실측 — search-before-mint 누락분 적발

검증자 적발: **`dtl_opt` jsonb가 이미 존재하고 공정 param 값을 저장 중**인데 PR-1/PO-1 진단·rpmeta V-1 사다리가 "기존 dtl_opt 재사용" 단계를 빠뜨리고 신규 `ref_param_json` mint를 제안 → search-before-mint 위반.

**라이브 jsonb 컬럼 전수(information_schema):**
| 테이블 | 컬럼 | 용도 |
|--------|------|------|
| `t_proc_processes` | `prcs_dtl_opt` | 공정 param **스키마**(정의) — 기진단 |
| **`t_prd_product_option_items`** | **`dtl_opt`** | **공정 param 선택값(인스턴스)** — ★누락 적발 |
| `t_prd_template_selections` | `dtl_opt` | 템플릿 선택 인스턴스(`{"면":"양면"}`) |

**`t_prd_product_option_items.dtl_opt` 실값(공정 OPT_REF_DIM.04 참조 6행, PRD_000124 린넨):**
```
ref_key1=PROC_000080(봉제) · dtl_opt = {"폭":7.0,"유형":"봉미싱(7cm)"}
                                       {"유형":"오버로크"} / {"유형":"말아박기+면끈"} / {"유형":"오버로크+리본끈"} / {"유형":"말아박기"}
```
- 즉 **공정 param 선택값(인스턴스)을 적을 칸이 이미 라이브에 실재**(option_items.dtl_opt, 6행 실사용). 구조 = `{"키":"값"}` jsonb = 우리가 제안한 `ref_param_json {"변형":"풀빼다"}`와 **동형**. UV 변형값을 담을 수 있음.

**판정 = (a) dtl_opt 재사용 가능 → 신규 ref_param_json mint 불요(0).**
| 근거 | 내용 |
|------|------|
| 구조 동형 | dtl_opt `{"유형":"봉미싱(7cm)"}` ↔ 목표 `{"변형":"풀빼다"}` 동일 jsonb 키-값 패턴 |
| 같은 의미축 | 둘 다 *공정 param 선택값*(봉제 유형 ↔ UV 변형). 의미 분리 불요(b 기각) |
| 참조 일관 | dtl_opt 보유 6행 전건 OPT_REF_DIM.04(proc_cd 참조) = 공정 옵션. UV 변형도 PROC_000002 공정 param → 같은 슬롯 |
| 채움 현황 | option_items.dtl_opt 477행 중 6행만 채움(공정 param 미적재 지배) = **data-gap**(그릇 있음·미적재) |

> **★rpmeta V-1 vessel-gap 판정 정정:** V-1이 dtl_opt를 못 봐 "인스턴스 슬롯 부재 = vessel-gap·신규 mint"로 오판. **실제 = data-gap**(option_items.dtl_opt 그릇 실재·UV 변형 미적재). vessel-gap → **data-gap** 격하. 신규 컬럼 mint 0.

### 6.2 [B2] UV 21상품 실연결 정정 — "전건 UV" 과장 적발

검증자 적발: §1에서 "21상품 전건 UV PROC_000002"라 했으나 **14만 실연결·7 무연결**.

**라이브 재실측(t_prd_product_processes 조인):**
| 분류 | 상품수 | 상품 |
|------|:--:|------|
| **UV 실연결**(PROC_000002 있음) | **14** | 아크릴키링146·마그넷147·뱃지148·집게149·스마트톡150·맥세이프톡151·명찰152·볼펜155·네임택157·포카키링158·자유형스탠드160·판아크릴161·포카스탠드162·미니파츠163 |
| **공정 연결 0**(total_proc_links=0) | **7** | 명찰골드실버153·지비츠156·코스터159·코롯토164·포카코롯토165·카라비너166·지비츠★171 |

> **§1 정정:** "21상품 전건 UV" → **"14 UV 실연결 + 7 공정연결 전무"**. 7상품은 print_side에 UV 변형값이 있으나 **공정(PROC_000002) 연결 자체가 없음**(round-22 B-10 코롯토 정체·카라비너 비활성 보류 등과 정합).

### 6.3 PO-1 라우팅 재분류 (무연결 7 분기)

| 분류 | 행수 추정 | 라우팅 | 선결 |
|------|:--:|--------|------|
| **PO-1a UV 실연결 14상품** | ~42행(14×3변형) | dtl_opt에 변형값 이관 + print_side 정규화 | 공정 연결 실재 → 이관 즉시 가능(그릇=dtl_opt) |
| **PO-1b UV 무연결 7상품** | ~21행(7×3변형) | **공정(PROC_000002) 연결 선행** 후 dtl_opt 이관. 연결 없이 이관 시 고아 param | ★PROC_000002 product_processes 링크 선적재 + 정체 컨펌(코롯토164/카라비너166 round-22 BLOCKED) |

> **★B-PO-1 전제 보정:** "UV 21상품 전건이 화이트 underbase 별색공정 일괄결정 후보"가 아님. **14는 UV 실연결**(UV param 정규화) / **7은 공정 연결조차 없음**(정체·연결 선결이 underbase 판정보다 선행). 화이트 underbase(풀빼다=발색) 별색공정 vs UV param 갈림은 14 실연결분에 한정해 B-PO-1 적용.
