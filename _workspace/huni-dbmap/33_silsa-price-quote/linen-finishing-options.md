# 린넨패브릭포스터 마감가공 옵션 등록 정립 — round-23 (설계까지·실 COMMIT 인간 승인)

> **작성** 2026-06-17 · round-23. **설계·정리까지 — 적재/COMMIT 안 함.** 입력 = `grouping-model-design.md`(GO·proc_cd 종류축)·`gd2-wiring-design.md`(후가공 배선)·`poster-sign-component-redesign.md`(신안) + 라이브 read-only psql 실측.
>
> **사용자 지시:** 린넨패브릭포스터에 마감가공 5종 + 단가 등록. **단가 verbatim**(오버로크 0·+리본끈 800·말아박기 1000·+면끈 2000·봉미싱(7cm) 2000).

---

## 0. 핵심 5줄

1. **린넨패브릭포스터 = PRD_000124, 신안+G-D2 이미 적용.** 본체 `COMP_POSTER_LINEN_FABRIC` use_dims=`["siz_width","siz_height"]`(신안)·52 단가행 적재·공식 `PRF_POSTER_LINEN`에 본체+후가공(오시·귀돌이·가변·별색·미싱) 9 comp 배선됨(G-D2 패턴 라이브 실현).
2. **마감가공 그룹 그릇 이미 존재**(OPT_000009 "가공"·SEL_TYPE.01 택1) + **3 옵션 이미 등재**(오버로크 OPV_000025·말아박기 OPV_000026·봉미싱(7cm) OPV_000027, 전부 OPT_REF_DIM.04→PROC_000080 봉제 참조). **누락 = 복합 2종(+리본끈·+면끈) + 가격 전무 + 공정 배선 전무**.
3. **5종 등록 = 옵션 5개 각 단가(조합 단가 verbatim).** 사용자가 조합별 단가 명시 → 복합("오버로크+리본끈" 800·"말아박기+면끈" 2000)도 **단일 옵션**으로(BUNDLE 분해 아님). 신규 옵션 2개(OPV +리본끈·+면끈) 추가 → 5택1.
4. **가격 = component_prices add-on 단가행 5개**(0/800/1000/2000/2000) + 린넨 공식에 가공 comp formula_components 배선. 엔진 addtn_yn 무참조·선택 매칭 합산(G-D2). 0원(오버로크)=단가행 0 명시(기본·dflt_yn=Y).
5. **search-before-mint:** 봉제 부모 PROC_000080 **재사용**(오버로크/말아박기/봉미싱은 봉제 가공의 종류 → proc_cd 종류축·신규 자식 proc 5 또는 dim_vals 마감유형). 리본끈/면끈 전용 자재 부재 → 복합 단가에 포함(별 자재 mint 불요·통가). 신규 = add-on comp(린넨 마감) + 단가행 5 + 옵션 2.

---

## 1. 린넨패브릭포스터 정체·기존 현황 (라이브 실측)

| 항목 | 라이브 값 |
|------|----------|
| prd_cd | **PRD_000124** 린넨패브릭포스터 |
| 본체 comp | `COMP_POSTER_LINEN_FABRIC`·use_dims `["siz_width","siz_height"]`(신안)·prc_typ .01·**52 단가행**(siz_width/height) |
| 바인딩 공식 | `PRF_POSTER_LINEN` |
| 공식 배선(9) | 본체(1)·오시(2)·귀돌이둥근(3)·귀돌이직각(4)·가변텍스트(5)·가변이미지(6)·별색S1(7)·별색S2(8)·미싱(9) |
| 가공 option_group | **OPT_000009 "가공"**(SEL_TYPE.01 택1·mand_yn N·note "봉제 가공 유형 param=GAP-PARAM") |
| 가공 옵션(3 등재) | 오버로크 OPV_000025·말아박기 OPV_000026·봉미싱(7cm) OPV_000027 — 전부 item OPT_REF_DIM.04→PROC_000080 |
| 가공 단가 | **0행**(가격 미연결·돈 결함) |
| 가공 comp 배선 | **0**(PRF_POSTER_LINEN에 봉제 가공 comp 없음) |

> **현 상태 결함:** 옵션 그릇·3옵션은 있으나 ① 복합 2종 누락 ② 단가행 0(선택해도 0원) ③ 공식 배선 0(엔진 가산 경로 없음). → 5종 단가 + comp + 배선 등록 필요.

---

## 2. 5 마감가공 옵션 등록 구조

### 2.1 옵션 5택1 (option layer·OPT_000009 그룹)

| # | 옵션 | opt_cd | 단가(verbatim) | dflt | item ref |
|---|------|--------|:--:|:--:|------|
| 1 | 오버로크 | OPV_000025(기존) | **0원** | Y(기본) | OPT_REF_DIM.04→PROC_000080 |
| 2 | 오버로크+리본끈 | **신규 OPV** | **800원** | N | 공정+부속(복합·단일옵션) |
| 3 | 말아박기 | OPV_000026(기존) | **1,000원** | N | OPT_REF_DIM.04→PROC_000080 |
| 4 | 말아박기+면끈 | **신규 OPV** | **2,000원** | N | 공정+부속(복합·단일옵션) |
| 5 | 봉미싱(7cm) | OPV_000027(기존) | **2,000원** | N | OPT_REF_DIM.04→PROC_000080 |

- **택1(SEL_TYPE.01):** 마감가공은 상호배타(하나만) — 기존 그룹 그대로. 5택1.
- **복합(2·4) = 단일 옵션**(사용자가 조합 단가 명시 → BUNDLE 분해 안 함). "오버로크+리본끈"=가공(오버로크)+부속(리본끈) 통가 800. 부속 자재 별 등록 불요(단가에 포함·통가).

### 2.2 가격 = add-on comp + 단가행 5 (그룹핑 모델·proc_cd 종류축)

**모델:** 마감가공 = 1 add-on comp `COMP_POSTEROPT_LINEN_FINISH`(use_dims `["proc_cd","dim_vals"]` 또는 `["opt_cd"]`) + 종류축으로 5종 단가 분기.

| 종류축 후보 | 방식 | 판정 |
|-------------|------|------|
| **proc_cd 종류축**(그룹핑 모델 정본) | 봉제(PROC_000080) 자식 5종 proc 신규(오버로크/오버로크리본/말아박기/말아박기면끈/봉미싱) → 단가행 proc_cd 분기 | △ 복합(부속포함)은 순수 공정 아님 |
| **dim_vals.마감유형**(파라미터형) | dim_vals={"마감":"오버로크+리본끈"} 5값 | ✅ 5종이 같은 가공그룹의 변형·복합 포함 가능 |
| **opt_cd 축**(option 직결) | 단가행 opt_cd=OPV_000025~ 5개 | ✅ option_item과 직접 매칭·가장 단순 |

→ **권고 = opt_cd 축**(option_item과 1:1·복합 자연 표현·proc 5신규 회피). 단 엔진 NON_QTY_DIMS에 opt_cd 포함 확인됨(이전 실측). 단가행 5개:

```
COMP_POSTEROPT_LINEN_FINISH (use_dims ["opt_cd"], prc_typ .01)
  opt_cd=OPV_000025(오버로크)        unit_price=0
  opt_cd=OPV_新(오버로크+리본끈)      unit_price=800
  opt_cd=OPV_000026(말아박기)        unit_price=1000
  opt_cd=OPV_新(말아박기+면끈)        unit_price=2000
  opt_cd=OPV_000027(봉미싱7cm)       unit_price=2000
```

### 2.3 공식 배선 (G-D2 패턴)

- `PRF_POSTER_LINEN`에 `COMP_POSTEROPT_LINEN_FINISH` disp_seq=10·addtn_yn=Y 배선.
- 엔진: 사용자가 마감옵션 선택(opt_cd 전달) → 매칭 단가 가산. 미선택/오버로크(0원)=가산 0.

### 2.4 0원 처리 (오버로크)

- **단가행 0 명시**(opt_cd=OPV_000025·unit_price=0). dflt_yn=Y(기본 선택). 엔진 매칭 시 +0(가산 0)·미적재 아님(명시 0이 "무료 마감 선택됨"을 표현). 미선택 기본보다 **명시 0행 권고**(견적서에 "오버로크(무료)" 표시 가능).

---

## 3. search-before-mint 결과

| 요소 | 라이브 검색 | 재사용 | 신규 |
|------|------------|:--:|:--:|
| 봉제 공정 | PROC_000080(봉제)·088(자식 봉제) | ✅ 부모 재사용 | proc_cd 축 채택 시 자식 5(미채택·opt_cd 권고로 0) |
| 오버로크/말아박기/봉미싱 공정 | 미등재(봉제만) | — | proc 축 시 필요(opt_cd 축이면 불요) |
| 리본끈/면끈 자재 | 전용 부재(우드봉+면끈 번들만 MAT_000224~227) | — | 복합 단가 통가 포함(별 자재 mint 불요) |
| 옵션 OPV(오버로크/말아박기/봉미싱) | **3 기존**(OPV_000025/26/27) | ✅ | 복합 2(+리본끈·+면끈) |
| add-on comp | COMP_POSTEROPT_LINEN_WOODBONG(우드봉용·별개) | — | `COMP_POSTEROPT_LINEN_FINISH` 1 신규 |
| option_group | OPT_000009 "가공"(기존) | ✅ | 0 |

→ **신규 최소:** add-on comp 1 + 단가행 5 + 옵션 2(복합) + 배선 1. proc/자재 신규 0(opt_cd 축·통가).

---

## 4. 7cm·복합·0원 처리 결정

| 항목 | 결정 | 근거 |
|------|------|------|
| **봉미싱(7cm)** | 옵션명 일부(이미 OPV_000027 "봉미싱(7cm)" 등재). 7cm=치수 dim_vals 아님 | 라이브 옵션명에 7cm 포함·단일 단가(7cm 외 변형 없음). 추가 파라미터 불요 |
| **복합(+리본끈·+면끈)** | 단일 옵션·통가(BUNDLE 분해 안 함) | 사용자 조합 단가 명시(800·2000). 부속 자재 단가 분리 표 없음 |
| **0원(오버로크)** | 단가행 0 명시·dflt_yn=Y | 기본 무료 마감·견적 표시·미적재 아님 |

---

## 5. load-builder 인계 단위 + 컨펌

| 단위 | 테이블 | 조치 | 행수 | 멱등키 |
|------|--------|------|:--:|--------|
| **L1 복합 옵션 2** | t_prd_product_options | 오버로크+리본끈·말아박기+면끈 OPV 신규(OPT_000009 그룹) | 2 | (prd_cd,opt_cd) |
| **L1' 옵션 item** | t_prd_product_option_items | 복합 2의 item(OPT_REF_DIM.04→PROC_000080 or opt 자체) | 2 | (prd_cd,opt_cd,item_seq) |
| **L2 add-on comp** | t_prc_price_components | COMP_POSTEROPT_LINEN_FINISH(.01·use_dims ["opt_cd"]) | 1 | comp_cd |
| **L3 단가행 5** | t_prc_component_prices | opt_cd별 단가(0/800/1000/2000/2000) | 5 | 자연키(opt_cd 포함) |
| **L4 공식 배선** | t_prc_formula_components | PRF_POSTER_LINEN←COMP_POSTEROPT_LINEN_FINISH disp10 addtn_yn=Y | 1 | (frm_cd,comp_cd) |
| **L5 dflt** | t_prd_product_options | 오버로크 dflt_yn=Y | 1 UPDATE | (prd_cd,opt_cd) |

- **DRY-RUN(R1~R6):** ① 멱등 delta 0 ② FK 고아 0(OPV·comp·frm 선존재) ③ 동시매칭 0(opt_cd 단일 매칭) ④ 골든: 린넨 600×1800 + 말아박기 = 본체 + 1000 ⑤ 오버로크=+0 ⑥ fn_chk_opt_item_ref 정합(OPT_REF_DIM.04→PROC_000080 실재).

| 컨펌 | 권고 |
|------|------|
| Q-L1 종류축 = opt_cd vs proc_cd 자식5 vs dim_vals | **opt_cd**(option 1:1·복합 자연·proc 신규 0) |
| Q-L2 복합 부속(리본끈/면끈) 자재 별 등록 vs 통가 | 통가(사용자 단가 명시·부속 단가 분리 없음) |
| Q-L3 OPT_000009 note "param=GAP-PARAM" 의미(기존 미완 흔적) | 가공유형 param 미해소 잔재·5옵션 등록으로 대체 |
| Q-L4 오버로크 0원 단가행 vs 미적재 기본 | 0행 명시(견적 표시·기본) |
| Q-L5 add-on comp use_dims ["opt_cd"] 단독 vs proc_grp 토큰 | opt_cd 단독(현수막 PROC_OPT 선례 혼재·opt 직결 단순) |

---

## 6. read-only 준수

- 라이브 SELECT(린넨 PRD·본체 신안 use_dims·52단가행·공식배선9·option_group OPT_000009·3옵션·봉제 공정·리본끈/면끈 자재·OPT_REF_DIM). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력. 단가 verbatim(사용자 5종).
- 설계까지 — load-builder L1~L5 멱등 SQL·DRY-RUN·GO는 dbm-validator·실 COMMIT 인간 승인.
