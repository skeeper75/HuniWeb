# 등록 명세 인덱스 — 4축 (사이즈·도수·인쇄옵션·공정)

> **하네스** hbg Phase 3 설계가. **갱신** 2026-06-18(2차 회차 — scaffold 틀 → **전수 명세 요약 인덱스**로 승격).
> **지위:** 1순위(자재·카테고리)는 `regspec-material.md`·`regspec-category.md` 전수. 본 4축은 `regspec-{size,color,printoption,process}.md` 전수 완성 → 본 문서는 **요약 인덱스**.
> **공통 채번/적재경로 규약:** `regspec-material.md §0`·`_registration-master.md §1` 인용.

---

## 0. 4축 라이브 행수 (2026-06-18 라이브 실측)

| 축 | t_* | 라이브 행수 | 등급 | 전수 명세 |
|----|-----|:--:|:--:|------|
| ② 사이즈 | `t_siz_sizes` | 520 | 🟡 | `regspec-size.md` |
| ③ 도수 | `t_clr_color_counts` | 5(SEED 폐쇄) | 🟢 | `regspec-color.md` |
| 인쇄옵션 | `t_prd_product_print_options` | 166 | 🔴 | `regspec-printoption.md` |
| ⑤ 공정 | `t_proc_processes` | 102 | 🟡 | `regspec-process.md` |

---

## 1. 축별 등록 명세 요약 (1줄)

| 축 | 핵심 실 조치 | 신규 mint | FK 위상 | 컨펌 |
|----|-------------|:--:|------|------|
| ② **사이즈** 🟡 | SZ-1 색오염 2행 교정(siz_nm 정규화·무비용·가격 0참조) | 0 | 색/수량 축이동 → siz_nm UPDATE(삭제 아님) | SZ-2 |
| ③ **도수** 🟢 | **0건**(폐쇄 SEED·정상·빈 라우팅) | 0 | N/A | 없음 |
| **인쇄옵션** 🔴 | PO-1 UV 변형 63행 축이동(print_side→**기존 dtl_opt**·PO-1a 14/PO-1b 7·**underbase=UV param 확정**) | 0(dtl_opt 재사용·B4) | **★option_items 행/PROC 링크 선적재 → 축이동** | **B-PO-1 ✅**·잔여 PO-1b 정체 |
| ⑤ **공정** 🟡 | **기존 dtl_opt 재사용**(param 채움) + **레이플랫 PROC_000025 소프트삭제 1**(AX-6 ✅·연결 0) | 0(data-gap) | option_items 행 적재 → dtl_opt 채움 | 잔여 AX-5(이관 범위) |

---

## 2. ★ FK 위상 핵심 — 기존 dtl_opt 재사용·행 선적재 [HARD·B4·B5]

```
[목적지 = 기존 t_prd_product_option_items.dtl_opt (신규 컬럼 ALTER 아님·B4)]
[PO-1a UV 14 실연결 — 즉시]
 ① 해당 14상품 option_items 행 선적재 (현재 0행·B5)   ← 진짜 선결
 ② UV 변형값을 기존 dtl_opt로 이관 ({"변형":"풀빼다"} 등)
 ③ print_side를 단면/양면 정규화(UPDATE)
[PO-1b UV 7 무연결 — 공정 링크 선행]
 ⓪ PROC_000002 product_processes 링크 선적재 + 정체 컨펌(코롯토164/카라비너166)
 ①~③ 이후 동일
   ※ 행/링크 선결 위반 시 고아 param·변형 구분 소실 → round-23 아크릴 가격사슬 손실(formula 간접·골든 불변)
```

- **★[B4] 신규 ref_param_json 컬럼 신설 철회** — `t_prd_product_option_items.dtl_opt` jsonb 라이브 실재(6행 실사용)·재사용. vessel-gap→data-gap. **진짜 선결 = option_items 행 적재(PO-1a)·PROC_000002 링크(PO-1b)**(B5).
- 사이즈 SZ-1은 독립(색 0참조·무비용). 도수는 변경 0.

---

## 3. 4축 건수 집계

| 축 | 교정 | 축이동 | 신규 컬럼 | 소프트삭제 | 판정불가(컨펌) |
|----|:--:|:--:|:--:|:--:|:--:|
| ② 사이즈 | 2(SZ-1) | (색/수량→타축·material) | 0 | 0 | 30(SZ-2 형상+EA) |
| ③ 도수 | 0 | 0 | 0 | 0 | 0 |
| 인쇄옵션 | (63 정규화) | 63(PO-1a 14 / PO-1b 7·→dtl_opt) | 0 | 0 | 0 |
| ⑤ 공정 | 0 | 0 | **0(dtl_opt 재사용·B4)** | **1(레이플랫 PROC_000025·AX-6 확정·연결 0)** | 0 |
| **4축 계** | **2 즉시** | **63(행/링크 선결 의존)** | **0** | **1**(레이플랫·del_yn='Y') | **30**(SZ-2 형상+EA) |

> **★4축 신규 그릇 = 0**(B4·ref_param_json 컬럼 신설 철회·기존 dtl_opt 재사용·data-gap). 신규 코드행·컬럼·테이블 0. 자재 수신 그릇(비치수 마스터·SHAPE 코드)은 material §3 처리(중복 명세 금지).

---

## 4. data-gap / dbmap 위임 (본 회차 등록 0)

| 항목 | 축 | 위임처 |
|------|----|--------|
| nonspec 25/275 채움(SZ-3) | 사이즈 | dbmap 적재 트랙(그릇 있음·미적재) |
| 캐스케이드 제약(GAP-PROC-2) | 공정 | dbmap CPQ constraints(constraints.logic 기존 그릇) |
| 자재 29행 수신(siz/shape/nondim) | 사이즈 | `regspec-material.md §3.1/§3.2`(material 처리) |
| 자재 14행 수신(print_side) | 인쇄옵션 | `regspec-material.md §3.4` |
| 아크릴 두께 분리(AC-2) | 사이즈 인접 | dbmap 31_acrylic |

---

## 5. 후속 회차 주의 (전 4축)

1. **라이브 재실측 필수** — ⑤공정 84→102·②사이즈 510→520 진화. 후속 진단 착수 시 stale 위험.
2. **[B4·B5] 행 선적재 강제** — 인쇄옵션 PO-1 적재 시 신규 컬럼 ALTER 아님(기존 dtl_opt). 진짜 선결 = option_items 행 적재(PO-1a)·PROC_000002 링크(PO-1b)·순서 위반 = 고아 param.
3. **기계적 size 삭제 금지** — component_prices CASCADE(116siz 2,601행)·round-22 ② CORRECT 반증.
4. **추정 0** — 컨펌 확정 2(B-PO-1 underbase=UV param·AX-6 레이플랫 소프트삭제·연결 0 실측)·잔여 3(AX-5 범위·PO-1b 정체·SZ-2 칼틀)은 가설+컨펌ID 분리·평이한 한국어 질문 첨부.
