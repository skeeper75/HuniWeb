# 디지털인쇄 — 외부 갭헌팅 보드 (round-12 P2)

> **작성** 2026-06-10 · round-12. 목적 = "후니 시트·스키마에 없는 속성 축"의 적발(답습 아님). 기존 KB(`07_domain/benchmark-competitors.md`·RedPrinting 역공학·WowPress) 우선 재사용, 중복 크롤 금지. 모든 외부 인용 Sources 명기.
>
> **결론 미리:** 디지털인쇄(명함/엽서/전단/리플렛/접지카드/상품권/배경지)는 **07_domain·benchmark KB가 이미 경쟁사 표현력을 흡수/능가** — 신규 갭 0. 외부 표준(CIP4/XJDF·ISO 21812)은 후니 모델(별색=공정·판수=앱계산)을 **재확인(corroborate)**할 뿐 새 축을 요구하지 않음.

---

## 1. 기존 KB 재사용 (신규 크롤 0 — 디지털인쇄 커버 영역)

| 축 | 기존 KB 권위 | 디지털인쇄 적용 | 신규 갭 |
|----|--------------|-----------------|:--:|
| 형상/커팅(완칼·도무송) | benchmark §2(B3) — RP 형상=PCS param·WP namestep / 후니=prcs_dtl_opt.모양 흡수 | C24 커팅=PROC_000053{모양} | 없음 |
| 묶음/명함 건수 | benchmark §4(B6) — RP 재단PCS+수량밴드·WP qty min/max / 후니=묶음수+조각수(Q8 둘다) | C26~29 수량(QTY_UNIT.02 매) | 없음 |
| 공정 세부 param(오시/미싱/가변) | benchmark §5(B8) — 후니 prcs_dtl_opt가 RP/WP보다 표현력 우위 | C31~34 오시/미싱/가변 줄수·개수 param | 없음 |
| 별색(화이트/금/은) | benchmark §7 — 후니 별색=공정(PROC_000007 family)이 RP "별색=PCS/도수 혼재"보다 일관 | C18~22→PROC_000007 family | 없음 |
| 자재(종이·평량) | benchmark §7 — 종이 자재 축 표준 | C16→MAT_TYPE.01·평량=mat_nm | 없음 |
| 캐스케이드 제약(자재→공정 disable) | benchmark §9 — **유일 보강 권고**(RP disable_pcs·WP rst_awkjob) | C23 ★180g이상 코팅 = constraint_json | **보강 권고(기보유)** |

---

## 2. 신규 외부 리서치 (디지털인쇄 미커버 영역 한정)

### G-EXT-1 — 경쟁사 디지털인쇄 판매 속성 축 (Vistaprint·MOO)
- **조사 질문:** 해외 대형 web-to-print가 명함/엽서 디지털인쇄를 어떤 속성 축으로 파는가 — 후니 시트에 없는 축이 있는가?
- **발견:** Vistaprint/MOO 명함·엽서 = ① paper(종이) ② finish(gloss/matte/**soft-touch laminate**) ③ shape ④ **rounded corner(quarter-inch)** ⑤ variable data(MOO Printfinity 멀티디자인). 2026 Vistaprint "Premium+"=16pt 두꺼운 종이+soft-touch.
- **후니 시트 대조:** paper=C16 자재 · finish=C23 코팅(soft-touch=코팅 variant, 신규 축 아님) · shape=C24 커팅 · rounded corner=**C30 모서리(직각/둥근=PROC_000027/028)** · variable data=C33/34 가변(VDP).
- **후니 영향:** **무시(갭 없음)** — 5개 축 전부 후니 시트에 매핑 존재. soft-touch는 코팅 광택 값(무광/유광 외 신규 값 추가 여지이나 *축* 신설 불요).
- **Sources:** [Vistaprint Business Cards](https://www.vistaprint.com/business-cards/standard) · [MOO Printfinity](https://www.moo.com/us/about/printfinity) · [Vistaprint Postcards](https://www.vistaprint.com/marketing-materials/standard-postcards) (WebSearch 2026-06, US)

### G-EXT-2 — CIP4 JDF/XJDF·ISO 21812 product intent (별색·임포지션 표준)
- **조사 질문:** 인쇄 표준이 디지털인쇄의 별색·판수(임포지션)·제품의도를 어떻게 모델링하는가 — 후니 모델이 표준과 어긋나는가?
- **발견:** ① **ISO 21812-1:2019 product intent** = binding-style·media-type 등 완성품 특성을 PDF DPart에 임베드(XJDF product intent 개념). ② **임포지션(n-up)** = `LayoutPreparationParams`(ResourcePool) — **plate-prep 계산 단계**(색분해 직전·직후). ③ **spot color separation** = 임포지션과 함께/직후 일어나는 생산 단계 → plate file 생성.
- **후니 모델 대조:** ① media-type=자재(C16)·binding-style=N/A(낱장) — 정합. ② **판수=임포지션=계산 단계 → 후니 "판수=앱 런타임 계산(DB 미저장)" 정확히 corroborate**(C6 미저장이 GAP 아님을 표준이 뒷받침). ③ **spot color=생산 단계 → 후니 "별색=공정(PROC_000007)" corroborate**(도수 아님).
- **후니 영향:** **무시(갭 없음·오히려 후니 모델 검증)** — 표준이 후니의 두 핵심 결정(판수=앱계산·별색=공정)을 독립적으로 지지. 충돌 0.
- **Sources:** [CIP4 PDF Print Production Metadata](https://www.cip4.org/print-automation/pdf-print-production-metadata) · [XJDF Specification 2.2](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) · [JDF Specification 1.8](https://www.cip4.org/files/cip4/documents/JDF%20Specification%201.8%20www.pdf) (WebSearch 2026-06)

---

## 3. 갭 처분 종합 (M6 — 모든 갭에 처분 존재)

| 갭 ID | 갭 요지 | 출처 | 후니 영향 | 처분 |
|-------|---------|------|-----------|------|
| (KB) 캐스케이드 제약 | 자재→공정 disable 데이터 보강 | benchmark §9 | constraint_json(C23 ★180g 기보유) | **무시(기보유)** — round-6 CPQ constraints로 적재 |
| G-EXT-1 | Vistaprint/MOO 5축 | Vistaprint·MOO | 전부 후니 시트 매핑 존재 | **무시(갭 없음)** — soft-touch는 코팅 값 추가 여지(축 신설 불요) |
| G-EXT-2 | CIP4/ISO 별색·임포지션 | CIP4/XJDF·ISO 21812 | 후니 모델 재확인 | **무시(corroborate)** — 매핑 수정·DDL 제안 불요 |

> **순 신규 갭 = 0.** 디지털인쇄는 round-9 메모리 `dbmap-domain-knowledge-before-asking`("후니 스키마는 경쟁사 표현력 흡수/능가") 정합. 외부 리서치는 답습 0·검증 only. soft-touch 코팅 값 추가는 매핑 수정이 아니라 *값 enum 확장* 여지로만 기록(현 시트 무광/유광으로 충분).
