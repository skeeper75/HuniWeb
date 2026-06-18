# 등록 명세 — 인쇄옵션 (`t_prd_product_print_options`) 🔴

> **하네스** hbg Phase 3 설계가 · 2차 회차. **작성** 2026-06-18.
> **입력:** `02_diagnosis/diagnosis-printoption.md`(🔴 UV 오적재 63행) · `01_authority/axis-authority-printoption.md`.
> **재사용:** dbmap `regspec-process.md §1`(목적지 그릇 = 기존 dtl_opt). **[B4 정정] V-1 `ref_param_json` 신설·`ref-param-json-proposal.sql` = 철회**(기존 dtl_opt 실재).
> **[HARD] 명세 ≠ 적용.** 실 COMMIT = dbmap 위임. **돈 크리티컬 — round-23 아크릴 가격사슬 묶임(formula 경유 간접).**

---

## 0. 한 줄 평결 [B4·B2·B5 정정]

**print_side에 UV 변형 enum 오적재 63행 축이동이 유일 결함(🔴).** 정답 = print_side를 단면/양면 정규화 + 변형값(풀빼다/배면양면/투명테두리)을 **기존 `t_prd_product_option_items.dtl_opt`로 이관**(신규 컬럼 0·B4). **★[B2] "21상품 전건 UV" 과장 정정 → PO-1a(UV 14 실연결·~42행·즉시 가능) / PO-1b(UV 7 무연결·~21행·PROC_000002 링크 선행).** **★[B5] FK 위상: dtl_opt는 기존 그릇이므로 진짜 선결 = 해당 아크릴 상품 option_items 행 선적재(현재 0행) → dtl_opt 이관 → print_side 정규화.** 순서 위반 시 변형 구분·가격 손실(돈 크리티컬·formula 간접경로). **신규 그릇 0·신규 print_side 코드행 0·4축 신규 mint 0.**

---

## 1. ★ PO-1 — UV 변형 enum 축이동 (PO-1a/PO-1b 분기·FK 위상 [HARD])

### 1.1 등록 명세 단위

| 명세 단위 | 내용 |
|-----------|------|
| **대상 t_* + 값** | `t_prd_product_print_options.print_side` 63행(풀빼다 21·배면양면 21·투명테두리 21) → 단면/양면 **교정(UPDATE)** + 변형값은 **기존 `t_prd_product_option_items.dtl_opt`로 이관**(신규 컬럼 0·B4). print_side 5종 도메인 기존(166행)·신규 코드행 0. |
| **★대상 상품 [B2 정정]** | UV 오적재 21상품 중 **14만 PROC_000002 실연결**(아크릴키링146·마그넷147·뱃지148·집게149·스마트톡150·맥세이프톡151·명찰152·볼펜155·네임택157·포카키링158·자유형스탠드160·판아크릴161·포카스탠드162·미니파츠163) · **7은 공정연결 전무**(명찰골드실버153·지비츠156·코스터159·코롯토164·포카코롯토165·카라비너166·지비츠★171). "전건 UV" 과장 철회. |
| **올바른 의미** | print_side = 인쇄면(단면/양면)만. UV 변형(풀빼다=화이트 발색·배면양면·투명테두리) = PROC_000002(UV) `prcs_dtl_opt` `{"변형":enum[...]}` param의 *선택값*. **별색/UV는 print_side 금지**(OM-5). |
| **권위 근거** | `diagnosis-printoption.md §6`(B4 dtl_opt 재실측·B2 14/7 분기 라이브 실측) · `diagnosis-process.md §6.1`(dtl_opt 실재) · round-13(print_side UV 오적재 CONFIRMED). |
| **search-before-mint** | **신규 그릇 0** — 변형 선택값 슬롯 = **기존 `dtl_opt`**(공정 PR-1·B4·라이브 실재). print_side 칸 5종 도메인 보존. 신규 코드행·테이블·컬럼 0. |

### 1.2 ★ PO-1a / PO-1b 분기 + FK 위상 [HARD·B2·B5]

```
[PO-1a — UV 14 실연결(~42행) : 즉시 가능]
 ① 해당 14상품 option_items 행 선적재 (현재 미적재·B5)   ← 진짜 선결(신규 컬럼 ALTER 아님)
 ② UV 변형값을 기존 dtl_opt로 이관:
      풀빼다 → {"변형":"풀빼다"} · 배면양면 → {"변형":"배면양면"} · 투명테두리 → {"변형":"투명테두리"}
 ③ print_side를 단면/양면 정규화 (UPDATE):
      단면형(back=CLR_000001) → '단면' · 배면양면형(back=CLR_000005) → '양면'
                                          ← 도수(front/back colrcnt)는 정확·손대지 않음

[PO-1b — UV 7 무연결(~21행) : 공정 링크 선행]
 ⓪ PROC_000002(UV) product_processes 링크 선적재 (현재 연결 0·고아 param 방지)
   + 상품 정체 컨펌(코롯토164·카라비너166 = round-22 B-10 BLOCKED와 정합)
 ①~③ 이후 PO-1a와 동일
```

> **★[HARD·B5] 선결 정정:** 신규 컬럼 신설 아님(dtl_opt 기존 실재). 진짜 선결 = **① option_items 행 선적재(현재 0행)** + **(PO-1b) PROC_000002 링크 선적재**. 순서 위반(행 없이 dtl_opt 이관 / 링크 없이 이관) 시 고아 param·변형 구분 소실 → round-23 아크릴 가격사슬 파손. **print_side 직접 정규화는 행/링크 선결 전 BLOCKED.**

---

## 2. ★ 돈 크리티컬 — round-23 아크릴 가격사슬 간접경로 [HARD·B5]

| 사실(라이브 실측) | 함의 |
|-------------------|------|
| UV 14 실연결 = **round-23 가격 COMMIT 대상**(siz_width/height·골든 30×30 3T) | 색 siz 오염(가격 0참조)과 달리 **교정이 무비용 아님**(가격 묶임). |
| **★[B5] print_side ↔ 가격 = `t_prc_component_prices`에 prd_cd 부재** | print_side는 component_prices에 직접 키가 **없음** → 가격 연결은 **formula(`PRF_CLR_ACRYL`) 경유 간접**(상품→공식→구성요소→단가). print_side 정규화가 component_prices 단가행을 직접 건드리지 않음 — **단 formula의 print_side 분기(단면/양면 가격차) 입력이 바뀌면 견적 결과 변동** → 간접경로 규명 필수. |
| 변형 enum에 "단면" 포함 | print_side 칸이 인쇄면(단면) + UV처리를 한 축에 평면화 → 분리 시 단면형은 print_side='단면'·나머지는 dtl_opt로. |
| round-23 acrylic은 print_side를 **그대로** 가격연결(교정 미실행) | 교정·가격 트랙 별개 — PO-1 축이동 시 **① component_prices 단가행 byte 불변 ② front/back colrcnt 무접촉 ③ formula 분기 입력(단면/양면)이 골든값 유지** 3중 보장이 검증 게이트(dbmap R1~R6). |

> **단가행 보존 원칙 [B5]:** PO-1 교정 = print_side 값 정규화 + 변형값 dtl_opt 이관. **component_prices에 prd_cd 없음 → 단가행 직접 변경 0**(간접 formula 경유). 골든(30×30 3T 3,100 등) 재현이 적재 게이트.

---

## 3. 자재 print_side 14행 수신 (1차 자재 정합)

| 항목 | 판정 |
|------|------|
| 자재 .09 print_side 14행 수신(`regspec-material.md §3.4`) | 단면/양면/가로형/세로형 → print_side. **즉시 가능**(컨펌 무관·기존 5종 도메인). |
| FK 위상(자재 수신) | ① print_option 등록 → ② BOM link 제거(GPM-4) → ③ .09 print_side 자재행 del_yn='Y'(마지막). |
| PO-1 UV 교정과의 관계 | 별개 트랙 — 자재 수신(.09→print_side)은 정상값 추가·UV 축이동(63행)은 오적재값 이관. 혼동 금지. |

> 자재 print_side 수신 등록 명세는 `regspec-material.md §3.4`에서 처리(중복 명세 금지·본 문서는 PO-1 UV 교정 전담).

---

## 4. del_yn / use_yn 권위 적용

- print_side 오적재 63행 = **삭제 대상 아님**(교정 대상·값만 정규화). del_yn='N' 유지. 삭제 라우팅 0.
- del_yn 권위([[dbmap-del-yn-soft-delete-authority]])는 교정 트랙엔 비적용(소프트삭제 아님).

---

## 5. 등록 명세 건수 집계

| 라우팅 | 행수 | 신규 mint | 즉시/컨펌 |
|--------|:--:|:--:|------|
| **PO-1a UV 14 실연결**(print_side→dtl_opt) | **~42행**(14×3변형) | 0(dtl_opt 재사용·B4) | **option_items 행 선적재 후 즉시**(그릇 실재) |
| **PO-1b UV 7 무연결**(print_side→dtl_opt) | **~21행**(7×3변형) | 0(dtl_opt 재사용) | **PROC_000002 링크 선행 + 정체 컨펌**(코롯토/카라비너 BLOCKED) |
| 자재 print_side 수신(.09 14·자재 §3.4) | 14 | 0 | 즉시(별 트랙·material 처리) |
| 신규 print_side 코드행 | **0** | 0 | 5종 도메인 기존 |
| 소프트삭제 | **0** | 0 | 교정 트랙(삭제 아님) |

> **인쇄옵션 실 조치 = UV 변형 63행 축이동(PO-1a 42 + PO-1b 21)** — **신규 컬럼 0(기존 dtl_opt 재사용·B4)**. 선결 = option_items 행 적재(PO-1a) / PROC_000002 링크(PO-1b). 돈 크리티컬(formula 간접·골든 불변)·신규 그릇 0.

---

## 6. ★ 컨펌 큐 (escalate — 평이한 한국어 질문)

| ID | 막힌 결정 | 평이한 한국어 질문 |
|----|-----------|--------------------|
| **B-PO-1** [B2 보정] | 화이트/클리어 underbase가 별색공정(PROC_000008)인지 UV 변형 param(풀빼다)인지 — **UV 14 실연결 한정 적용** | "아크릴 투명 소재에 흰색을 먼저 깔아 색이 잘 보이게 하는 작업(풀빼다)이 있는데, UV로 인쇄하는 14개 아크릴 상품은 'UV 변형(풀빼다)'으로 보면 될까요? (디지털/실사는 '별색 화이트', UV는 '풀빼다')" |
| **PO-1b 정체(7 무연결)** | UV 변형값은 있으나 공정 연결이 없는 7상품(코롯토164·카라비너166 등)의 정체·연결 여부 | "코롯토·카라비너 같은 7개 상품은 화면엔 'UV 변형'이 적혀 있는데 실제 UV 공정 연결이 없습니다. 이 상품들이 정말 UV 가공인가요, 아니면 비활성/정체 상태인가요? 공정 연결을 먼저 정해야 변형값을 옮길 수 있습니다." |
| **AX-5(인용)** | UV 변형값 이관 범위(기존 dtl_opt·신규 칸 아님) | (공정 §6 AX-5와 동일·B4 정정 — 신규 컬럼 철회·이관 범위만) |

> **escalate [B2 보정]:** **B-PO-1은 UV 14 실연결분에 한정 적용**(underbase 풀빼다 유력·실무진 확정). **7 무연결분은 underbase 판정보다 PROC_000002 공정 연결 선결이 먼저**(연결 없이 underbase 논할 수 없음). AX-5는 이관 범위 결정(신규 그릇 아님).

---

## 7. dbmap 인용 (재제안 금지)

- **round-13** "print_side에 UV 전역 오적재" = 라이브 잔존 CONFIRMED(63행). 미교정 상태 유지가 정상 인용(round-23 acrylic은 이 print_side를 *그대로* 가격연결·교정과 별개).
- **round-23** 아크릴 동형(siz_width/height·골든 30×30 3T)은 21상품 가격 COMMIT — print_side UV값 손대지 않음(교정 미실행이 정상 인용).
- L2 CPQ option_items 대부분 미적재(OM-6) — print_side 오적재는 L1 차원행 결함(L2 포인터 아님).

---

## 8. hbg-validator 통지

- **인쇄옵션 축 = UV 변형 63행 축이동(PO-1a 42 + PO-1b 21)이 유일 결함.** [B4·B2·B5 정정] 검증 포인트: ① **★신규 컬럼 0**(기존 dtl_opt 재사용·ref_param_json 신설 철회·B4) ② **★FK 위상 [B5]: 진짜 선결 = option_items 행 적재(PO-1a)·PROC_000002 링크(PO-1b)**·순서 위반 시 고아 param ③ **B2: 14 실연결/7 무연결 분기**("전건 UV" 과장 정정) ④ 돈 크리티컬 **간접경로**(component_prices에 prd_cd 부재·formula PRF_CLR_ACRYL 경유·단가행 byte 불변·골든 재현·colrcnt 무접촉 3중 보장) ⑤ print_side 5종 도메인 기존(신규 코드행 0) ⑥ 자재 .09 print_side 14행 수신은 별 트랙(material §3.4) ⑦ 삭제 0(교정·del_yn='N').
- **escalate [B2 보정]:** B-PO-1(underbase 귀속·**UV 14 한정**)·PO-1b 정체(7 무연결 공정 연결 선결)·AX-5(이관 범위·신규 그릇 아님). 평이한 한국어 질문 §6.
