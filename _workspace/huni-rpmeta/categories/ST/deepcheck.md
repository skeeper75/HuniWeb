# ST(스티커) — codex-cli Deep-Augmentation (deepcheck)

> rpm-deepcheck. RedPrinting ST 카테고리 분석(reverse + metamodel 17축 + gap §XIII~XIV + _resolved-fragments S-1~S-10)을
> 독립 OpenAI 모델(codex-cli·gpt-5.5/ChatGPT)에 컨텍스트로 주고, 우리 ST 분석이 놓친
> 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보를 second-opinion으로 발굴한 산출물.
>
> **[HARD] 환각 경계:** codex(OpenAI) 제안 = `unverified` 가설. 후니 라이브/엑셀/RedPrinting 라이브 권위로
> 검증되기 전엔 사실 아님. codex 후보를 deepcheck 자신이 채택하지 않는다(triage까지). 검증 후 살아남는
> 후보만 metamodel-architect(Ph3)·gap-analyst(Ph4)·reverse-engineer(Ph2)·vessel-designer로 라우팅.
> codex "라이브 인용 보유→checkable" 주장 신뢰 금지(네트워크 격리 confabulation — PR H-1·TP 교훈).

---

## 상태: ✅ DEEPCHECK 완료 — codex 가용·후보 30건 발굴·triage 완료

- **codex 가용 확인:** preflight `AVAILABLE model=gpt-5.5`(이번 세션 재확인). codex v0.140.0·ChatGPT 계정·read-only sandbox.
- **consult:** `cat _tmp/rpm-st-context.md | codex exec -m gpt-5.5 -c mcp_servers='{}' --sandbox read-only --skip-git-repo-check --output-last-message /tmp/rpm-deepcheck-ST.md -`
  (★stdin pipe — arg로 주면 hang·PR/TP 교훈). EXIT=0·56,011 tokens·62줄 응답.
- **결과:** Short Verdict + Q1(#18 후보 6검토)·Q2(4 distinct 후보 재판정)·Q3(누락 도메인 14항)·Q4(위험 도메인 사실 9항). 일부 중복.
- 비밀값·.env 프롬프트 주입 0(준수). RedPrinting=사용자 본인 시스템·읽기전용.

---

## ★directive 핵심 직답 — #18 distinct 축 후보 적대 확인 결과

> directive: "ST가 형상 #17로 포화를 깬 시점 — codex가 **추가 distinct 축(#18 후보)**을 제시하는지 적대 확인 + 칼선/점착/재단 facet 판정 codex 반론 수집."

**codex 결론 = "#18 distinct 축 없음(no defensible #18 yet)" — 우리 판정을 독립 모델이 지지.**
codex가 우리 17축·4 distinct 후보 판정을 컨텍스트로 받고 적대적으로 검토했음에도, **형상 #17 1종만 distinct가 맞고
나머지(칼선·재단입자·점착·인쇄방식·판/die-cut·롤/시트 배송형태)는 전부 facet**이라고 독립 판정.
- **칼선·재단입자·점착·인쇄방식·판/die-cut 5종 = 우리 facet 판정과 codex 판정 일치** → 적대 확인 통과(과잉승격 아님 입증).
- **#18 watchlist 2종 제시(distinct 아님):** ① VDP 데이터모델(NUM_DFT는 공정옵션일 뿐 — 외부 데이터소스/필드스키마/머지검증/레코드별 미리보기 lifecycle 입증 시에만 #18) ② 롤가공 사양(unwind/core/repeat-pitch/splice/roll-length 독립 lifecycle 입증 시 강한 서브모델 — 단 top-level 축 아님). **둘 다 ST 증거로는 distinct 미입증** → HIGH 후보로 검증 등재.
- **형상 #17 적대 반론(codex Q2):** "형상은 항상 독립 상업옵션 아님 — 전면 강제하면 모델 오염. distinct는 `shape_info` 분리 + shape→size 1:N or shape가 공정 게이팅인 곳에서만." → **우리 판정과 정확히 동일**(gap-matrix XIII-1 "1:1 흡수 카테고리는 size 유지·전면 강제 금지"). codex가 우리 안전장치를 독립 재발견 = 형상 판정 robustness 입증.

---

## Triage 요약 (30 후보 → 분류)

| 분류 | 건수 | 비율 |
|---|---:|---|
| **HIGH** 검증가치(신규 축 후보·강한 도메인 누락) | **6** | 20% |
| **MED** 검증가치(기존 축 보강·도메인 디테일) | 11 | 37% |
| **LOW**(샘플 확대 시·우선순위 낮음) | 4 | 13% |
| **이미 커버됨**(우리 분석에 있음) | 6 | 20% |
| **환각의심/부적용** | 3 | 10% |

> 정직 분류: codex가 우리 17축·gap·fragment를 컨텍스트로 받았음에도 **이미 커버된 항목을 20% 재제기**(반칼/완칼 facet·점착=material attribute·인쇄방식=#12·판=#4 흡수·disable=UI availability — 우리가 이미 판정·gap에 명시한 것). "신규"로 채택하지 않고 정직히 폐기. **순 신규 검증가치(HIGH+MED) = 17건.**
> ★codex의 최대 기여 = "새 축이 아니라 **under-modeled sticker 생산 제약·옵션 디테일**"(Q3 14항) — 칼선 geometry·블리드/안전여백·스티커 간격·라이너/전사형태·롤/시트 배송·역상/창문print·weeding·라미네이션 변종·security 소재·특수 substrate. 우리가 메타모델 축은 잡았으나 *축 내부 채움(facet 멤버·제약 슬롯·자재 enum)* 이 얕다는 정직한 지적.

---

## HIGH 후보 (6건) — 검증 우선·신규 축 후보 또는 강한 도메인 누락

| ID | codex 주장(claim) | unverified | 라우팅 | 검증 방법(checkable) | 우리 분석 대비 |
|---|---|:---:|---|---|---|
| **H-1** | **VDP/가변데이터 모델이 #18 후보**(NUM_DFT 넘버링은 공정옵션이나, 외부 데이터소스·필드스키마·머지검증·레코드별 미리보기·가변 QR/바코드/이름목록 관리 시 독립 lifecycle → #18 승격 가능). ST 단독으론 미입증·TP 티켓/네임스티커 확인 필요 | unverified | metamodel-architect | **TP deepcheck H-6 이미 검증=REFUTED**(VDP=RedEditorSDK 45메서드 중 3개·`getCurrentTemplateVdpList`=템플릿 종속·edicus_item에서만·#16 ⊃ VDP 포함관계). ST 넘버링(NUM_DFT) 라이브 옵션 트리(로그인 캡처) 재확인 — start/digits/prefix/position 파라미터면 공정#2+#9·외부 데이터소스 관리면 재검토 | **TP에서 이미 REFUTED — ST가 동형 재제기**. NUM_DFT는 S-9에서 공정#2(+가변=VDP#16) 판정. codex가 TP 결론 모르고 동일 후보 부활 → **검증 시 REFUTED 예상**(VDP=#16 facet 유지) |
| **H-2** | **롤가공 사양이 강한 서브모델 후보**(마스킹테이프 STTPMSK 롤 — unwind direction·core·repeat pitch·splice tolerance·roll length가 독립 lifecycle이면 die-cut/판과 다른 생산형태). top-level 축은 아니나 #14/#15에 under-specified | unverified | reverse-engineer · metamodel-architect | RedPrinting STTPMSK/STTPBND 라이브 옵션 페이지(로그인 캡처) — 롤 폭×길이·코어·권취방향 옵션 실재 확인. 후니 t_* 롤 사양 컬럼 유무(information_schema) | **S-10에서 완제SKU(#4+#15) facet 판정·"규격 unobserved→gap/validation"** 이미 명시. codex가 롤 *전용 사양*(core/pitch/splice)을 강조 = S-10 검증 시 확인할 디테일 보강. distinct 미입증(우리와 일치) |
| **H-3** | **블리드/안전여백/칼선오프셋 + 최소칼사이즈/최소반경/narrow-bridge 제약 누락**(자유칼선은 임의 디테일 수용 불가 — min size·min corner radius·min gap·min island 규칙 필요). 팀은 칼선은 잡았으나 *아트워크 geometry 규칙* 미언급 | unverified | vessel-designer · gap-analyst | RedPrinting 스티커 아트워크 가이드(라이브 정적 페이지·도무송/자유형 업로드 가이드). 후니 운영 SOP/엑셀 생산규칙. **형상축 #17(V-12) 설계 시 칼선 geometry 제약 슬롯 동반 검토** | **★신규·강함** — 우리 분석에 블리드/안전여백/min-radius/min-island 제약 전무. 형상#17·공정파라미터#9·제약#5의 *내부 채움* 누락. V-12 형상 그릇 설계 시 "형상→칼틀 게이팅 + 칼선 geometry 제약"을 함께 봐야(XIII-3 미묘점과 합류) |
| **H-4** | **전사테이프/어플리케이션 시트 + weeding(여백 제거)**(전사스티커·창문/벽면 데칼·비닐 레터링은 application tape/paper 필요·여백제거 여부가 노동·산출물 변경). 전사·전차스·컷팅스티커에 존재 | unverified | reverse-engineer | RedPrinting 카탈로그 검색 — 전사(transfer)·전차스(STEWDFT 메탈전차스?)·컷팅스티커 상품 옵션. 후니 t_prd_product_addons(전사테이프=부속물#8?)·t_proc_processes(weeding 공정 유무) | **부분 신규** — STEWDFT 메탈(전차스)는 그룹D에 있으나 *전사테이프(부속물)·weeding(공정)* 은 미발굴. 컷팅스티커(STCUUSR 조각·자유칼선)에 전사지 동반 가능. 부속물#8·공정#2 멤버 후보 |
| **H-5** | **수정스티커(STMDDFT) = 인쇄방식이 아니라 use-case/material**(불투명 백색 cover-up 라벨일 가능성 — RedPrinting이 별 인쇄엔진 노출 안 하면 material/use-case로 분류해야). 팀은 인쇄방식 분기군(E)에 넣음 | unverified | metamodel-architect · reverse-engineer | RedPrinting STMDDFT 라이브 옵션 페이지(로그인 캡처) — material code·process list·별도 가격엔진 유무. 불투명백 자재면 자재#1·별 print engine이면 #12 | **★우리 분류 정정 후보** — reverse §4-E·discovered-axes 그룹E가 STMDDFT를 "인쇄방식/용도(수정)"로 묶음. codex: 불투명백 cover-up=자재 use-case일 수 있음 → 검증 시 #12에서 #1로 재귀속 가능(인쇄방식군 8→7) |
| **H-6** | **돔/에폭시 스티커가 ST에 누락**(후니는 에폭시 공정을 다른 곳[아크릴 PRD_000169]에 보유 — ST 분석은 돔 스티커 미확인). 형태가공#14+공정#2 | unverified | gap-analyst · reverse-engineer | RedPrinting 카탈로그 검색 `에폭시/돔/입체 스티커`(catalog 36 ST 상품에 dome 유무). 후니 t_proc_processes 에폭시 공정(round-22 에폭시 PRD_000169 라이브 실재) ST 연결 가능성 | **신규** — ST 36상품에 돔/에폭시 스티커가 catalog상 있는지 미확인(우리 36상품 그룹 횡단에 dome 없음). 있으면 형태가공#14(평면→입체 에폭시 돔)·공정#2 멤버. 후니 에폭시 공정 재사용 가능 |

> **HIGH 정직 메모:** H-1(VDP)은 TP에서 이미 REFUTED — ST 재제기는 **검증 시 REFUTED 예상**(등재는 하되 새 결론 가능성 낮음). H-3(칼선 geometry 제약)·H-4(전사/weeding)·H-6(돔/에폭시)이 **진짜 신규 검증가치** — 우리가 축은 잡고 *멤버/제약 슬롯*을 얕게 둔 곳. H-2(롤사양)·H-5(수정스티커 재귀속)는 기존 판정(S-10·그룹E)의 *디테일 정정* 후보. **distinct 신축 후보는 전부 미입증(codex도 #18 없음 확정) — 적대 확인 통과.**

---

## MED 후보 (11건) — 기존 축 보강·도메인 디테일

| ID | codex 주장 | unverified | 라우팅 | 검증 방법 | 귀속 축 |
|---|---|:---:|---|---|---|
| M-1 | **라미네이션 변종**(soft-touch·hologram·scratch-resistant·textured) — 팀은 유광/무광(COT_DFT)만 캡처·프리미엄/UV/security 상품에 더 있을 수 있음 | unverified | reverse-engineer | RedPrinting UV/프리미엄/옥외/오토바이 스티커 옵션 페이지 | 공정#2 + 파라미터#9 |
| M-2 | **부분UV/raised UV/clear ink 구분**(SCO_DFT 부분UV로 부족 — UV인쇄·clear varnish·raised spot UV가 다른 공정일 수 있음) | unverified | metamodel-architect | RedPrinting 옵션 payload·process code 매핑(STPAU* UV군) | 공정#2 |
| M-3 | **역상/미러/창문 내부 인쇄**(창문 스티커=역상 인쇄·접착면 인쇄·화이트 백킹 순서 필요) | unverified | reverse-engineer | 투명PET/창문 스티커 페이지·아트워크 가이드 | 인쇄방식#12 + 파라미터#9 |
| M-4 | **스티커 간격(시트 위)**(kiss-cut 시트=스티커 간·시트 가장자리 최소 간격) | unverified | reverse-engineer | 자유형/다중조각 스티커 업로드 가이드 | 제약#5 + 수량/레이아웃#10 |
| M-5 | **라이너/백킹지 종류**(white·transparent·slit-back·release liner — 투명후지는 언급되나 라이너=관리 레이어로 미모델) | unverified | reverse-engineer | 자재 payload 필드·후니 자재 마스터(t_mat_materials) | 자재#1 or 부속물#8 |
| M-6 | **security/위변조 방지**(VOID·destructible·hologram·scratch-off — 스크래치는 listed이나 VOID/destructible/security film 부재) | unverified | gap-analyst | RedPrinting 카탈로그 + 후니 엑셀 자재 목록 | 자재#1 + 공정#2 |
| M-7 | **반사·야광·형광·감열(thermal) substrate**(흔한 특수 스티커 substrate·26소재 enum 요약에 부재) | unverified | gap-analyst | 후니 라이브 스키마 + 공급사 자재 엑셀 | 자재#1 |
| M-8 | **컬러 관리**(CMYK·white·spot·metallic·overprint order — 화이트언더베이스는 잡았으나 잉크레이어 순서·spot채널 규칙 미모델) | unverified | vessel-designer | 아트워크 가이드·prepress 요구사항 | 인쇄방식#12 + 공정#2 |
| M-9 | **registration tolerance**(인쇄/박UV/칼선 간 정합 허용오차 — 박/형압/spot UV/칼선 정렬이 생산 가능성에 중요) | unverified | vessel-designer | 후니 생산 SOP or RedPrinting 가이드 | 제약#5 |
| M-10 | **"DTF 화이트 항상 강제" 글로벌 위험**(STPADPN은 맞으나 투명필름·흰 의류·gang-sheet·no-white 워크플로에서 다를 수 있음) | unverified | reverse-engineer | STPADPN/STPADDY/STPADNM payload — PRT_WHT disable 가능 지점 확인 | 제약#5(S-7 보강) |
| M-11 | **투명PET→화이트 옵션성 명시 제약**(화이트 잉크가 optional/forced/recommended 인지 디자인 가시성·백킹면 따라 다름 — 명시 제약 필요) | unverified | vessel-designer | RedPrinting 투명PET 옵션·아트워크 가이드 | 제약#5(S-7 cascade) |

---

## LOW 후보 (4건) — 샘플 확대 시·우선순위 낮음

| ID | codex 주장 | 사유 |
|---|---|---|
| L-1 | THO_GRA vs THO_DFT vs THO_CUT 정의 비교(한국어 가이드 언어) | S-2에서 공정#2 두 모드 판정 완료·THO_CUT=GS 합류 명시. 로그인 캡처 시 정의 확인 정도(우선순위 낮음) |
| L-2 | "후지=photo print" 미확인(투명후지=백킹/라이너 가리킬 수 있음·STBPDFT 미확정) | reverse §0.5 이미 "후지=은염사진(추정)·unobserved" 정직 표기. 로그인 캡처 대기분 |
| L-3 | "묶음재단 자체=kiss-cut 등치 금지"(NOTICE가 라이너 거동 확인 전엔) | S-3에서 PROC_054 반칼=종이만 확정·NOTICE 명문 인용. codex 신중론은 타당하나 우리 KB 권위로 이미 확정 |
| L-4 | 코너 라운딩(corner-rounding) — Q3에 미명시이나 sticker 일반 옵션 | 우리 형상축(RC 사각라운드)·칼틀에 일부 흡수. 별 옵션이면 공정#2 멤버(샘플 확대 시) |

---

## 이미 커버됨 (6건) — 폐기(우리 분석에 있음)

| codex 항목 | 우리 분석 위치 |
|---|---|
| 반칼/완칼=공정 facet(not #18) | S-3 판정(PROC_053/054/055)·gap XIII-2 #3 PASS |
| 점착class=material attribute(not #18·adhesion_grade/removability/temp/weather) | S-4 판정(자재#1 합성 차원)·gap XIII-2 #4 WEAK·dictionary §1 |
| 인쇄방식=#12(not #18·material pool/ink stack/white/price engine) | S-5 판정·gap XIII-2 #5 GAP·#12 D-7 |
| 판 vs die-cut=#4+#13+#10+#11+#15(no new lifecycle) | S-6·S-10 판정·reverse §0.6 |
| 롤/시트/개별 배송=#14/#15/#4 | S-10 완제SKU 판정(단 codex H-2는 롤 *전용 사양* 강조 = MED→HIGH 분리) |
| disable=금지 제약(semantically weak·UI availability 유지) | S-8 판정·gap XIII-2 #6 WEAK·#5 RULE_TYPE |

---

## 환각의심/부적용 (3건) — 기각

| codex 항목 | 기각 사유 |
|---|---|
| "도무송=물리 다이 사용 die cutting·THO_GRA를 free-form로 collapse 금지" | **부분 타당하나 우리 KB가 권위** — pdf-domain-knowledge.md "도무송=칼선 자유모형 컷팅·완칼/반칼 계열"로 확정. codex가 일반 인쇄업계 도무송(물리 다이)과 RedPrinting THO_GRA(아트워크 자유 contour)를 혼동 가능성 — 우리 후니 KB 권위 유지(라이브 인용 confabulation 경계) |
| "Shape axis fully solves free-form" 반론(cutline path complexity·islands 미저장) | **우리가 이미 인지** — XIII-3 미묘점에서 "형상축은 단독 enum 아니라 형상→칼틀 게이팅 + FR→완칼 모양 파라미터(#9 GAP) 관계 그릇"으로 명시. codex가 우리 V-12 설계포인트를 "miss"로 오인(이미 반영됨). 단 칼선 geometry 제약(H-3)은 별도 신규로 분리 등재 |
| codex 라이브 상품코드 인용(STPADPN/STMDDFT/STEWDFT 등) "checkable" 신뢰 | **인용 자체는 우리 컨텍스트에서 받은 것**(codex 네트워크 격리·자가 라이브 접근 0) → codex가 "verify against live"라 한 것은 정당하나 codex 자신이 라이브 확인했다는 함의는 금지(PR H-1·TP 교훈). 검증 트리거로만 |

---

## 검증 라우팅 종합 (verify 후 생존분만 메타모델/갭/그릇/역공학 재진입)

- **metamodel-architect:** H-1(VDP=#18? — TP REFUTED 동형 예상)·H-5(수정스티커 #12→#1 재귀속)·M-2(부분UV/clear/raised 공정 분화)
- **reverse-engineer:** H-2(롤 전용 사양)·H-4(전사테이프·weeding)·H-6(돔/에폭시 catalog 검색)·M-1(라미네이션 변종)·M-3(역상/창문)·M-4(스티커 간격)·M-5(라이너)·M-10(DTF 화이트 disable 지점) — **로그인 캡처 묶음**(STPAU* UV·STBPDFT 후지·STMDDFT 수정·STTPMSK 롤·STEWDFT 전차스 + 아트워크 가이드)
- **gap-analyst:** H-6(에폭시 공정 ST 연결)·M-6(security/VOID)·M-7(반사/야광/감열 substrate) — 후니 t_mat_materials·엑셀 자재 목록 대조
- **vessel-designer:** H-3(블리드/안전여백/min-radius/min-island 제약 — V-12 형상 그릇 설계 시 동반)·M-8(컬러관리/overprint order)·M-9(registration tolerance)·M-11(투명PET 화이트 제약 명시) — 제약#5·공정파라미터#9·형상#17 V-12 채움

> **채택 0(후보 등재까지).** 생존은 verify 후 metamodel(02)/gap(03)/vessel(04) 재진입. validator(M-gate)에게 본 후보 리스트 전달 — 묵시 채택(unverified→사실) 0 확인 대상.
> **★directive 충족:** #18 distinct 축 — codex 독립 모델이 "없음" 확정(우리 형상#17 1종 판정 적대 확인 통과)·칼선/점착/재단 facet 판정도 codex 동의(반론은 "facet이나 디테일 깊다"이지 "distinct"가 아님). **순 신규 검증가치 = 칼선 geometry 제약(H-3)·전사/weeding(H-4)·돔/에폭시(H-6)·security/특수substrate(M-6/M-7)·컬러관리/registration(M-8/M-9)** — 축이 아니라 *축 내부 채움(facet 멤버·제약 슬롯·자재 enum)* 누락이 codex의 정직한 최대 기여.
