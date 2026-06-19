# NC([옵셋] 명함·카드·쿠폰·포토카드) — codex 심층 발굴 (deepcheck)

> 후니 RP-Meta 하네스 Phase 4.5 산출물 (rpm-deepcheck). **발굴측**(Phase 6.5 게이트검증과 별개).
> codex(OpenAI gpt-5.5)를 독립 second-opinion으로 호출해 NC 분석이 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보를 발굴.
> ★[HARD] codex 주장 = **가설**(환각 경계). 전부 `unverified` — 라이브/권위 엑셀 검증 전 채택 금지. 발굴이지 채택 아님.

## codex 가용성·호출
- preflight: **AVAILABLE (gpt-5.5)** — foreground 직접 호출(공용 preflight 백그라운드 호출은 hang/exit144).
- 호출: `codex exec -m gpt-5.5 --sandbox read-only --output-last-message /tmp/rpm-deepcheck-NC.md "<prompt>"` (read-only·주문/POST 0).
- 결과: 17건 발굴(테이블) + 결론. EXIT 0. 원본 last-message = `/tmp/rpm-deepcheck-NC.md`.
- 입력 컨텍스트: NC reverse §0~3(옵셋 토큰·이산 tier·자재풀·접지 SKU·후가공 그룹) + 17축 포화 현황 + #12 인쇄방식 distinct 기준.

## codex 핵심 결론 (요약)
1. **인쇄방식 #18 신축 = 불필요** (codex 독립 동의 → NC 1차 예측 "부결(흡수)"와 일치·11번째 카테고리 재포화 지지).
2. 발굴 17건은 **전부 (B)기존 축 흡수 또는 (C)data-gap** — 신규 distinct 축 후보 0건.
3. 가장 강한 반례 = **variable-data offset**(offset base + digital numbering/overprint 복합) → 새 축이 아니라 **#12 인쇄방식이 단일 token이 아닌 *복합 recipe* 표현력을 가져야** 한다는 갭(아래 NC-DC-17).

---

## Triaged 후보 (전부 unverified)

판정 범례: **(A)** 신규 distinct 축 후보 → metamodel-architect / **(B)** 기존 축 흡수 → 폐기(노트) / **(C)** data-gap(축 있으나 미적재) → gap-analyst·reverse-engineer / **(거부)** 오류·부적용.

### ★우선 후보 — 검증 가치 높음 (checkable·후니 그릇 영향)

| ID | 발굴 claim | 판정 | 라우팅 | 검증법 |
|---|---|---|---|---|
| **NC-DC-04** | **쿠폰 넘버링(일련번호)** = 쿠폰 핵심 옵션인데 NC 관찰 후가공(재단/코팅/타공/귀돌이/부자재/오시)에 **없음**. 시작번호/자리수/접두어/VDP 데이터 입력 동반 가능. | **(C) data-gap** — 공정#2(+가변=VDP#16). ST S-9·TP T-3 합류(넘버링=공정 or VDP 양분). | **reverse-engineer**(NCDFCPN 쿠폰 재캡처·후가공 NUM/넘버링 코드 확인) + **gap-analyst**(VDP vs 공정 귀속·#16 입력채널 그릇). | NCDFCPN infoCall `pdt_pcs_info`에 numbering 멤버·`option_info`에 시작번호/증분 필드 존재 확인. 라이브 캡처. |
| **NC-DC-05** | **쿠폰 미싱/절취선(perforation·tear-off stub)** = 쿠폰 흔한 후가공인데 관찰 목록 없음. 절취선 개수/위치/방향 파라미터·본권+반권 stub 레이아웃·번호 양면 매칭 가능. | **(C) data-gap** — 공정#2 + 공정파라미터#9(절취선 위치/수). stub 레이아웃은 템플릿#4. | **reverse-engineer**(쿠폰 미싱 코드) + **gap-analyst**(절취선 파라미터·stub SKU 그릇). | NCDFCPN `pdt_pcs_info` 미싱/절취 멤버 + `pcs_dtl`에 위치/개수 파라미터 확인. |
| **NC-DC-01** | **특수지/합지 자재** — 관찰 3종(스노우250/300·모조220)은 너무 좁음. 옵셋 명함엔 cotton/kraft/recycled/colored/pearl/textured/duplex-triplex(합지) 흔함. | **(C) data-gap** — 자재#1(usage/surface/평량). NCDFQLT(고급지 명함)이 자재 superset일 가능성(reverse §NC 9상품표 "자재 superset 동형" 미캡처). | **reverse-engineer**(NCDFQLT·NCCDQLT 고급지 상품 미캡처분 캡처). | NCDFQLT `pdt_mtrl_info` MTRL_CD 전수 — 컬러지/펄/합지/크라프트 코드 존재 확인. **★NC 9상품 중 고급지 2종 미캡처 = 자재 풀 과소관측 위험.** |
| **NC-DC-17** | **variable-data offset** — 넘버링/바코드/쿠폰코드처럼 offset preprint + digital overprint 조합이면 `offset2023` **단일 token만으로 부족**. "same slots, different values" 전제를 흔드는 가장 강한 반례. | **(C/B) 흡수 단, #12 표현력 갭** — 새 축 아님. 인쇄방식 recipe가 *복합*(base+overprint)을 담아야. | **metamodel-architect**(#12 인쇄방식 recipe가 단일 token vs 복합 recipe 표현력 — N-1 가격엔진 선택자 nuance와 연결). | NC 쿠폰에서 offset base + digital VDP 2차인쇄 동시 가능여부 라이브 확인. 후니 `product_price_formulas` 바인딩이 1상품 다중 인쇄방식 허용하는지. **★N-2(이산 tier)·N-1(가격엔진 선택자)과 합류 검증.** |

### 부차 후보 — data-gap·검증 후순위

| ID | 발굴 claim | 판정 | 라우팅 | 검증법 |
|---|---|---|---|---|
| NC-DC-02 | **엣지 컬러/엣지박/측면도색** = 일반 코팅·귀돌이와 다른 후가공. 관찰 없음. | (C) data-gap — 공정#2 + 파라미터#9(앞/뒤/측면). | reverse-engineer(엣지/측면 코드) + gap-analyst. | `pdt_pcs_info`에 edge/측면/도색 멤버 확인(고급지 명함류). |
| NC-DC-03 | **부분 UV/spot gloss/soft-touch** — "코팅"만으론 부족. 전체/부분·앞/뒤·유광/무광 파라미터 구분 필요. | (C) data-gap — 공정#2 코팅 family의 공정파라미터#9. | reverse-engineer(COT_DFT detail 전개) + gap-analyst. | NCDFDFT 캡처의 `COT_DFT` detail(전체/부분·유광/무광) 파라미터 전수 확인(reverse §1 "코팅 변형 다수 COT_DFT detail" 언급분 미전개). |
| NC-DC-06 | **별색/Pantone/1도·2도** — 옵셋 명함은 CMYK 외 별색 대응 흔함. NC 도수 관찰 = 단면4/양면8(SID_S/D)뿐, 별색 unobserved(reverse §1 note). | (C) data-gap — **별색=공정#2**(round-22 HARD 경계·도수 아님) + 도수 enum. | reverse-engineer(별색 코드) + gap-analyst(별색=공정 귀속·#6 enum 규모). | `pdt_dosu_info`에 1도/2도·`pdt_pcs_info`에 별색(PROC_000007 family) 멤버 확인. **별색을 도수로 오적재 금지(round-22).** |
| NC-DC-13 | **대량 포토카드 묶음 제약** — 박스단위 포장·다종 디자인 합산·종당 최소수량·세트 구성 제한. | (C/B) data-gap — addon#8(포장) + 수량모델#10(합산) + 제약#5. | gap-analyst(NCCDPHO 포장/디자인종수). | NCCDPHO `pcs_info` 포장 멤버·디자인 n종 업로드 필드·종당 min qty 확인. |
| NC-DC-16 | **split-run/multi-design** — 한 주문 여러 디자인을 한 수량 tier에 섞으면 "same slots" 흔듦. design_count·per-design qty·합산가격. | (C) data-gap — 수량모델#10(다중슬롯·A-2 ORD_CNT 동형). | gap-analyst(NC 디자인 건수 슬롯). | `pdt_prn_cnt_info`에 ORD_CNT(디자인 건수) 슬롯 활성여부 — A-2 이중수량축과 합류. |

### 흡수/거부 — 폐기(노트)

| ID | 발굴 claim | 판정 | 노트 |
|---|---|---|---|
| NC-DC-09 | 판비/CTP/셋업비(makeready) | **(B) 흡수** — 가격기여역할#11 구성요소. 고객 선택축 아님. codex도 "#18 아님" 명시. | 후니 t_prc_* formula_components의 한 단가행(판비)으로 흡수. 관리축 아님. |
| NC-DC-10 | 합판/터잡기/하리꼬미(ganging/imposition) | **(B) 흡수 / 운영계** — 앱계산 derived(판걸이수 동형·메모리 `dbmap-compute-in-app-db-stores-lookup`) 또는 생산 라우팅. 옵션관리 새 축 아님. | DB 미저장 derived. ★NC 1차예측·메모리 교훈과 정확히 정합(판수=앱계산·DB 룩업만). codex도 동의. |
| NC-DC-11 | 최소수량(MOQ/min-run) | **(B) 흡수** — 수량모델#10 + 제약#5. NC 이산 tier(자재×부수 free-input-disabled)가 이미 MOQ 강제. | reverse §0.2 exp_prn_cnt가 곧 MOQ 흡수. N-2와 동일. |
| NC-DC-08 | 견본/교정쇄(proofing) | **(B) 흡수** — addon#8 또는 공정#2. 새 축 아님. | 유료 옵션이면 addon, 리드타임이면 SLA(NC-DC-12). |
| NC-DC-14 | 박/형압(foil/emboss) Coming-soon 런칭 시 구조 | **(B) 흡수(예상)** — 공정#2 family + 파라미터#9(foil color/side/area/동판비) + 가격#11. 현재 모델로 담을 수 있어야. | ST S-4·PR TP T-E 박=공정 동형. **단 NCDFFOI/NCCDFOI 출시 후 재캡처 필요**(reverse ambiguous#5 unobserved). |
| NC-DC-07 | 도무송/형태재단(die-cut) | **(B) 흡수** — 공정#2 + 형상#17(ST 재사용). 자유사이즈≠도무송. | 명함에선 드묾·쿠폰/카드 칼선 시 ST 형상축 재사용. |
| NC-DC-12 | 리드타임(lead time) | **(거부/운영계)** — 인쇄방식 축 아님. SLA/생산일정 축은 옵션관리 메타모델 범위 밖. codex도 "NC #18 아님" 명시. | RP-Meta(옵션 관리 그릇) scope 밖. 출고일 rule은 별 도메인. |
| NC-DC-15 | (NC-DC-16과 동일 split-run·중복) | 위 NC-DC-16 참조. | — |

---

## 신규 distinct 축 후보 유무 (directive 핵심 질문 답)
- **신규 distinct 축 = 0건.** codex가 17건을 발굴했으나 **전부 (B)기존 축 흡수 또는 (C)data-gap**이며, (A)신규 distinct 후보는 없음.
- codex가 **인쇄방식 #18 부결을 독립 동의** → NC 1차 예측("흡수·강한 부결 신호")·11번째 카테고리 재포화(PR/CL 패턴 반복)를 외부 모델이 지지.
- 가장 강한 반례 variable-data offset(NC-DC-17)도 **새 축이 아니라 #12 인쇄방식 recipe 표현력 갭**(단일 token→복합 recipe) → metamodel-architect가 N-1(가격엔진 선택자)과 묶어 검증.

## data-gap 묶음 (검증 라우팅 요약)
- **쿠폰 누락분(★최우선)**: 넘버링(NC-DC-04)·미싱/절취(NC-DC-05) — NCDFCPN 쿠폰 미캡처. reverse §1~3이 명함 3상품(NCDFDFT/FLD/NCCDPHO) 중심이라 **쿠폰 전용 후가공(넘버링/미싱) 미관측**이 실제 갭일 가능성 높음.
- **자재 풀 과소관측**: NC 9상품 중 **고급지 2종(NCDFQLT/NCCDQLT) 미캡처** → 자재 superset 미확인(NC-DC-01). 특수지/합지 존재여부 라이브 확인.
- **공정 파라미터 미전개**: 코팅 detail(NC-DC-03)·엣지(NC-DC-02)·별색(NC-DC-06) — 관찰된 그룹의 하위 파라미터 미전개.
- 전부 **라이브 infoCall 재캡처**(NCDFCPN·NCDFQLT·NCCDQLT)로 checkable. read-only.

## validator 인계 (M-gate)
- 본 후보 16건(중복 NC-DC-15 제외) 전부 `unverified` — 어느 것도 메타모델/그릇에 silent 채택 0건 확인 요망.
- 특히 NC-DC-17(복합 recipe)이 #12 축 정의를 바꾸지 않았는지(라이브 검증 전 흡수 처리), 별색 NC-DC-06이 도수축으로 오적재되지 않았는지(round-22 별색=공정 HARD) M-gate 확인.

---

**산출 시각**: 2026-06-19 · codex gpt-5.5 read-only · last-message `/tmp/rpm-deepcheck-NC.md`
