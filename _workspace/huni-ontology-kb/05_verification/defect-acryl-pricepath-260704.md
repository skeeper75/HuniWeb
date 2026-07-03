# 결함 보드 — 아크릴 축3(가격 경로 + 정직성 + 라이브 simulate 실증)

> **검증자:** okb-adversarial-verifier · Phase 4 · 2026-07-04 · 축3
> **방법:** 구축가·캐시 비신뢰 → 라이브 railway 읽기전용 SELECT 재실측 + webadmin 가격시뮬레이터 실호출(evaluate_price).
> **표본:** M1(148/150/151/152/161) · M3(153/155/160/166) · M4(163) · TBD(165/168/169/170) · 미출시(164/226) · M2 부속(146/147).
> **결과:** High 0 · Medium 1 · Low 0. 축3 가격 경로는 226 1건(미출시 false-gap·drift)을 제외하고 전부 정합.

---

## 실측 증거 요약 (라이브 simulate·qty=100)

| 상품 | 모델 | frm/comp(라이브 SELECT) | 단가행 | simulate 결과 | KB 표기 | 판정 |
|------|------|--------------------------|--------|---------------|---------|------|
| 148/150/151/152 | M1 | PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T | 277 | **480,000 ≠0** | 면적매트릭스 견적가능 | ✅ 정합 |
| 161 | M1 | 〃 | 277 | **384,000 ≠0** | 〃 | ✅ |
| 153 | M3 | PRF_ACRYL_NAMETAG_GS→COMP_*(3셀) | 3 | **340,000 ≠0** | 고정가형 공식(직접룩업 아님) | ✅ |
| 155 | M3 | PRF_ACRYL_BALLPEN(3셀) | 3 | **220,000 ≠0** | 〃 | ✅ |
| 160 | M3 | PRF_ACRYL_FREESTAND(5셀) | 5 | **704,000 ≠0** | 〃 | ✅ |
| 166 | M3 | PRF_ACRYL_CARABINER(4셀) | 4 | **464,000 ≠0** | 〃(R1 미적재 해소) | ✅ |
| 163 | M4 | PRF_ACRYL_MINIPART→COMP_ACRYL_MINIPART_TBD | 1 (10,000 placeholder·note "단가 미정 시그널") | 800,000 (placeholder) | candidate·placeholder 10,000·references gap-acryl-tbd | ✅ 정직(양면) |
| 165/168/169/170 | TBD | PRF_ACRYL_*_TBD→COMP_ACRYL_PENDING_TBD | **0** | **price=0(견적불가)** | gap-acryl-tbd·미출시·팬텀 금지 | ✅ 정직(팬텀 0) |
| 164 | M5(미출시) | PRF_COROTTO_ACRYL→COMP_ACRYL_COROTTO | 36 | 416,000 ≠0 | 미출시(use_yn=N)·추천 제외 | ✅ 정직 |
| 226 | 고정가(미출시) | PRF_GOODS_FIXED_SIZ→COMP_GOODS_FIXED_SIZ | 77(공유) | **900,000 ≠0** | ★"자기 siz 단가행 0건=견적불가"(gap-226-acryl-tbd) | ❌ **false-gap(D-AC-P1)** |

- **라이브 price-chain SELECT = 07-04 캐시·KB와 100% 일치**(146/148/150/151/152/153/155/159/160/163/164/165/166/170/226 frm·comp·prc_typ·단가행수 전건 대조 일치). 캐시 전사 신뢰 확인.
- **silent always-add 없음:** 147 마그넷 부속=본체만 선택 시 subtotal **0**(별도합산 정상)·146 볼체인 addon=본체만 384,000(addon 미가산). 가드 정합.
- **빌드 무결성:** nodes.jsonl 1486줄 sha 256b103f0267829c · edges 4571줄 7cf5a9b57d1561e0 = 구축가 baseline 재현(멱등)·hard 0·I-4 O5/O6 필수엣지 실패 0.

---

## MEDIUM

### [D-AC-P1] 226 아크릴쉐이커코롯토 — "자기 사이즈 단가행 0건=견적불가" false-gap (라이브 simulate=900,000·H-1 drift)
- **파일:** `03_kb/product/product-226-acrylic-shaker-corotto.md`(가격상태·relations references gap-226-acryl-tbd·§가격 경로) + `03_kb/rule/gaps.md`(gap-226-acryl-tbd 형제 서술) 관련.
- **KB 주장:** `가격상태: "★공식 재바인딩됨이나 자기 3사이즈(611/612/613) 단가행 0건=견적 불가(양면·gap-226-acryl-tbd)"` + `references gap-226-acryl-tbd`.
- **라이브 반증(2개):**
  1. **직접 SELECT** `t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' AND siz_cd IN (611/612/613)` = **3행 실재**(SIZ_000611=9,000·612=7,500·613=7,500·note "굿즈 variant 고정가 260704(엑셀 verbatim)").
  2. **simulate**(siz=SIZ_000611·qty100) = **900,000 ≠0**(9,000×100).
- **원인:** 병행 dbmap 세션(§7 "굿즈 variant 32상품 GB-2 전파" 2026-07-04(2))이 226 own-siz 단가행을 구축가 SELECT **이후** 적재(reg 260704). = pack가 **#1 위험으로 명시한 H-1 drift**(live-snapshot 노후→신규 SELECT 필수)를 226에서 그대로 밟음.
- **영향(완화):** 226=**미출시(use_yn=N)** → 추천 결과 제외라 손님 응답에 오노출 안 됨. 그러나 KB가 "견적불가" 거짓 선언(inverse phantom=false-gap)·drift 서사·gap 노드를 **이미 무효화된 전제** 위에 세움. 축3 정직성 직접 위반(simulate가 KB 반증).
- **builder 교정(격리 아님·재-SELECT로 해소):** 226 own-siz 07-04 재-SELECT → `가격상태=고정가형 견적가능(미출시)`로 정정·`references gap-226-acryl-tbd` 제거(또는 gap 노드를 "출시 대기" 성격으로 재정의)·drift_note 갱신. 미출시 status·추천 제외는 유지. O5는 이미 priced_by(PRF_GOODS_FIXED_SIZ)로 충족되므로 gap 참조 제거해도 O5 무손상.

---

## 격리(builder 교정 대상 아님 — 정직 표기가 정당)

- **TBD 4상품(165/168/169/170):** COMP_ACRYL_PENDING_TBD 0단가행 = 실무진 단가 BLOCKED(원천 부재). simulate=0 실증. KB gap-acryl-tbd·미출시 정직. **격리(staff GAP-AC-5).**
- **163 placeholder 10,000:** 라이브 note "단가 미정 시그널" = 실무진 확정 대기. KB 양면(current 10,000/authority 미정) 정직. **격리(staff).**
- **164 코롯토:** use_yn=N 미출시(36셀 실가)·추천 제외. **격리(미출시 정책).**
- **판형 51행(GAP-AC-3)·공정 MISSING(GAP-AC-2)·옵션 items 0행(GAP-AC-4)·mat_typ 오타이핑(GAP-AC-1):** 원천/적재 결함 → §7/§12/§31 위임. 가격 경로 무영향(면적공식 plt_siz_cd 미참조 실증). KB 양면 표기 정당. **격리.**
- **147/149/154 부속 이중표현(GAP-AC-6):** opt_groups 비어 있음(items 미적재)이나 KB가 이중표현·GAP-AC-6 정직 disclose. always-add 아님 실증. **격리(구조 결함 disclose).**

---

## 판정: **CONDITIONAL-GO** (축3)
- 활성 견적가능 상품 전 표본 PRICE≠0 실증·TBD/미출시 팬텀 0 실증·캐시 전사 100% 정합·멱등 무결성 재현.
- 단 1건 **D-AC-P1(226 false-gap·MEDIUM)** = H-1 drift 재-SELECT로 교정 권고(미출시라 손님 무영향이나 KB 내부 사실오류). 교정 후 GO.
