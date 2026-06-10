# 포토북 — 외부 갭헌팅 보드 (round-12 P2)

> **작성** 2026-06-10. 목적 = "후니 시트·스키마에 **없는 속성 축**의 적발"(답습 금지). 기존 KB(round-11 경쟁사 SKU 조사·`07_domain/benchmark-competitors.md`·RedPrinting 역공학) **재사용 우선**, 중복 크롤 금지. 갭 0이어도 "조사·갭 없음"을 대상·Sources와 함께 기록.
>
> **처분 분류:** 매핑 수정 / DDL 제안 라우팅 / 무시(+사유).

---

## 0. 재사용 — round-11 이미 조사분 (재크롤 안 함)

round-11 `domain-research-notes.md` §1이 **글로벌 5사(Shutterfly·Mixbook·Blurb·Saal·PrestoPhoto) + 국내 10곳(레드프린팅·스냅스·퍼블로그·찍스·포토몬·마이북·모노라마·오프린트미·캔바·군소)** SKU 차원을 이미 조사. 결론: **전 업체 1상품+옵션(사이즈·커버타입·커버재질·페이지 base+per-page)** — 후니 모델과 정합. round-12는 이 결론을 **라이브 실재로 확정**(PRD_000100 + 반제품 7 + size 4 + page_rule)했고, 표준(CIP4/ISO) 측 + 가격 모델 갭만 신규 조사.

---

## 1. 신규 조사 — 갭 후보

| # | 조사 대상 | 발견 | 후니 보유 여부 | 후니 영향(처분) | 근거 |
|---|-----------|------|----------------|----------------|------|
| **G-1** | CIP4 XJDF BindingIntent (제본 product intent 표준) | XJDF는 제본을 `BindingIntent`(case-bound/perfect/layflat/saddle), 표지를 별 intent로 모델. ISO 21812-1 PPM이 이를 PDF 메타로 인코딩 | ✅ 보유 — 후니 제본=`t_proc_processes` PROC_000017 family(중철=saddle·무선=perfect·PUR·하드커버무선=case-bound·레이플랫). **표지=USAGE.02/.06 분리** | **무시(후니 우위)** — 후니 제본 공정 모델이 XJDF BindingIntent를 흡수(8 자식 enum). 후니가 표준 표현력 보유 | [CIP4 XJDF 2.2](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) · [CIP4 PPM](https://www.cip4.org/print-automation/pdf-print-production-metadata) |
| **G-2** | 레이플랫 hinged-paper / case-bound 표준 | 레이플랫=case-bound + 중앙 hinged 용지(180도 펼침). 표준 별도 binding method | ⚠️ 부분 — PROC_000025 레이플랫제본 **마스터 존재(use_yn=Y)·적재 미운영**(라이브 실측). 후니 현재 PUR만(Q10) | **매핑 수정 없음·정보 보존** — Q10 확정(PUR만·레이플랫 추후 도입 가능). 레이플랫 코드는 이미 마스터에 존재(도입 시 연결만). DDL 불요 | [Snapfish layflat](https://www.snapfish.com/blog/what-is-a-layflat-photo-book/) · round-11 §1-3(국내 레이플랫 표준) |
| **G-3** | 내지 용지 finish 옵션(matte/lustre/semi-gloss) | Mixbook=hardcover 3 finish(semi-gloss/matte/lustre), layflat 4종. Snapfish=premium luster-silk. **내지 용지 마감을 고객 선택 옵션으로 운영** | ❌ **미보유** — 후니 포토북 내지=몽블랑130 **단일**(C13, 라이브 MAT_000105 1종). finish 선택지 없음 | **무시(+사유)** — Q11(표지타입 확장 없음)·내지 단일 확정 맥락. 후니는 용지 1종 정책. 단 **향후 확장 시 USAGE.01 내지에 자재 다행 + 옵션화 가능**(스키마는 이미 multi-material 지원). 매핑 수정 불요 | [Mixbook paper types](https://www.mixbook.com/inspiration/photo-book-paper-types) |
| **G-4** | 가격 base-pages-included + per-spread 증분 | Snapfish=20p base + per-spread(2p) 추가 · Mixbook=20p base + hardcover $1.79/layflat $2.09 per page. **base 포함 페이지 + 증분 단위 모델** | ✅ 보유 — 후니 C37 기본(24P) + C38 추가(2P당). **24P base·2P 증분이 경쟁사 20p base·spread 증분과 동형** | **매핑 수정 없음(정합 확인)** — Q15 확정. round-2 고정가 base + per-page 증분 component로 적재. 후니 모델이 시장 표준과 1:1 | [Mixbook pricing](https://www.mixbook.com/photo-book-pricing) · [Snapfish pricing](https://www.snapfish.com/helppricing) |
| **G-5** | 표지 재질 확장(패브릭·우드필) | 레드프린팅(후니 본인)=소프트/하드이미지랩/하드프리미엄/패브릭/우드필/레더필 6계열. 스냅스=패브릭 보유 | ⚠️ 부분 — 후니 3종(하드/레더하드/소프트). Q11 확정=현행 3종(확장 당분간 없음) | **무시(Q11 확정)** — 확장 시 USAGE.06 표지타입 + 반제품 sub_prd 추가만(스키마 지원). 매핑·DDL 불요 | round-11 §1-2(레드프린팅 SKU) |

---

## 2. 갭 처분 요약 (M6)

| 처분 | 건수 | 항목 |
|------|:--:|------|
| 매핑 수정 | 0 | — |
| DDL 제안 | 0 | — |
| 무시(후니 우위/정책/확정) | 5 | G-1(제본 표준 흡수)·G-2(레이플랫 Q10)·G-3(내지 finish 정책)·G-4(가격 정합)·G-5(표지확장 Q11) |

**결론:** 외부 5 갭 전부 **후니 스키마/실무진 확정이 이미 닫음** — 신규 매핑 수정·DDL 제안 0건. 후니 포토북 모델(1상품+반제품 variant+page_rule+base/per-page 가격)이 CIP4 표준·글로벌/국내 경쟁사 표현력을 흡수/정합. **답습할 외부 축 없음** 확인.

---

## Sources
- **CIP4/ISO 표준:** [XJDF Specification 2.2](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) · [CIP4 PDF Print Production Metadata (PPM/ISO 21812-1)](https://www.cip4.org/print-automation/pdf-print-production-metadata) · [What is (X)JDF](https://www.cip4.org/print-automation/jdf)
- **경쟁사 가격/사양(신규 검증 2026-06-10):** [Mixbook Photo Books Pricing](https://www.mixbook.com/photo-book-pricing) · [Mixbook Paper Types](https://www.mixbook.com/inspiration/photo-book-paper-types) · [Snapfish Help Pricing](https://www.snapfish.com/helppricing) · [Snapfish What is a Layflat Photo Book](https://www.snapfish.com/blog/what-is-a-layflat-photo-book/)
- **재사용 KB(재크롤 안 함):** round-11 `15_domain-spec/photobook/domain-research-notes.md` §1(글로벌 5·국내 10 SKU) · `07_domain/benchmark-competitors.md` · RedPrinting 역공학.
