# 후니 흡수 후보 — 스티커 가격계산 (이산규격×소재×수량 + 형상=칼틀 비가격축 종단)

> `hpe-benchmark-analyst` 산출 — 디지털인쇄·아크릴·실사/현수막·문구/제본·굿즈/파우치 6종단에 이어 **스티커** 종단(7번째).
> **목적[HARD]**: 와우프레스·레드프린팅이 스티커류(반칼/완칼·도무송 형상·소재별·팬시·소량·타투·판/DTF)의 가격을
> *어떻게 계산하는가*(형상·칼선·재단입자·소재·수량·인쇄방식)를 역공학해 후니 스티커 가격 설계에 흡수할 메커니즘을 추출.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수, naming/codes(`digital_price`·`vTmpl_price`·`THO_DFT`/`THO_GRA`·`CUT_DFT`·`MTRL_CD` 등) 후니 유입 금지,
> 권위 엑셀(상품마스터260610·가격표260527) 덮어쓰기 금지. 후니가 이미 담으면 흡수 불요(overfit 경계).

## 출처 표기

- `[red:ST-reverse]` = `_workspace/huni-rpmeta/categories/ST/reverse.md`(2026-06-17 rpm 역공학·STTHUSR/STCUXXX/STPADPN 풀 infoCall+priceCall 실측 + 33상품 그룹 A~F 횡단·shape_info 5형상·THO_DFT/THO_GRA 칼선 2메커니즘·CUT_DFT 재단입자·점착소재 26종·인쇄방식 4계열·disable 227건).
- `[red:ST-summary]` = `_workspace/huni-rpmeta/categories/ST/summary.md`(ST 메타모델·**#17 형상 distinct 승격**·17축 포화 붕괴·codex 독립 #18 부결).
- `[huni:stk-3axis]` = `_workspace/huni-dbmap/33_silsa-price-quote/sticker-3axis-design.md`(스티커 가격표 260527 7블록 3축 분리·라이브 t_prc_* 실측·권위).
- `[huni:bankal]` = `_workspace/huni-dbmap/33_silsa-price-quote/bankal-shapes-resolution.md`(058~064 반칼 모양 가격출처 재확인·**형상=칼틀=가격축 아님** 판정·라이브 verbatim).
- `[huni:area-dim]` = 메모리 `dbmap-area-matrix-wh-dimension`(스티커는 면적매트릭스 siz_width/height 구간 **제외**·이산 siz_cd).
- `[wow:probe]` = WowPress 라이브 읽기전용(2026-06-20·`goods/list?category=sticker`·`goods/view` 전부 HTTP 404·옵션/가격 미관측).
- `unobserved` = 미관측(날조 금지).

---

## 0. 경쟁사 스티커 가격화 방식 — 한눈 요약

| 항목 | 레드프린팅(RedPrinting) | 와우프레스(WowPress) | 후니 `t_prc_*` 대응 |
|------|------------------------|----------------------|---------------------|
| 스티커 가격엔진 | **die-cut = `digital_price`**(좌표+칼틀 PCS 산정)·**판/DTF/UV = `vTmpl_price`**(판 규격 템플릿가)·**자유형 정가 = `tmpl_price`** = 3엔진 형태별 분기 `[red:ST-reverse §0.6·§3]` | 미관측(경로 404·옛 캡처에 스티커 명목 존재나 옵션/가격 페이지 미해소) `[wow:probe]` | `PRF_STK_FIXED`(스티커 단일 공식·라이브 실재·3건 바인딩) `[huni:stk-3axis §2]` |
| 사이즈 가격화 | **자유사이즈 좌표입력**(CUT_WDT/HGH·자유형) + **프리셋 칼틀이 사이즈 겸함**(CL001~010 원형·RC001~025 라운드·SQ 사각) `[red:ST-reverse §0.2]` | unobserved | **이산 siz_cd**(124x186·A4·A3·90x190·100x148·90x110 등 명시규격·**면적매트릭스 아님**) `[huni:stk-3axis §1.3·huni:area-dim]` |
| 형상(원형/사각/타원/라운드/자유) | **`shape_info` 1급 enum(SQ/CL/EL/RC/FR)** → 칼선 게이팅 `[red:ST-reverse §0.1]` | unobserved | **가격축 아님**(가격표에 형상 차원 0·같은 사이즈/소재=같은 단가) → 형상=상품정체+칼틀(siz_cd 형상코드/CPQ) `[huni:bankal §2]` |
| 칼선/재단(반칼/완칼) | **칼선 2메커니즘**(자유 THO_GRA / 프리셋칼틀 THO_DFT) + **재단입자 2종**(묶음재단 DFXXX=반칼시트 / 개별재단 DFITM=완칼낱장) — PCS로 가격 전달 `[red:ST-reverse §0.2·§0.3]` | unobserved | 칼선=공정(`proc_cd` 도무송/완칼/반칼 PROC_053/054/055)·**가격축 아님**(반칼/완칼은 같은 사이즈/소재면 같은 단가·다른 단가면 siz_cd 분리) `[huni:bankal §2·huni:stk-3axis]` |
| 소재(점착 spectrum) | **자재 합성코드**(지종 PTT × 평량 WGT × 점착성)·26종 한 상품 enum + 점착특화 상품 분기(리무버블/옥외/저온/자석) `[red:ST-reverse §0.4]` | unobserved | **`mat_cd` 차원**(B01 7소재: 유포/비코팅/미색/무광코팅/유광코팅/투명/홀로그램) — ★라이브 3 collapse + 170 오매핑 결함 `[huni:stk-3axis §2.1]` |
| 인쇄방식(일반/UV/DTF/후지) | **pdtCode prefix 분기**(STTH일반/STPAU UV/STPAD DTF/STBP후지) + 가격엔진·자재·도수노출·화이트강제 동반결정 `[red:ST-reverse §0.5·§3]` | unobserved | 상품 정체(pdtCode≠후니)·DTF/UV는 별 상품+종속자재(mat_cd)+화이트강제 제약(round-6 CPQ) |
| 수량 처리 | die-cut prn_cnt 100단위·이중수량(디자인수 ordCnt × 수량 printCnt)·판/DTF는 장 단위(FIR 1·INC 1) `[red:ST-reverse §1·§3]` | unobserved | **수량 min_qty 상향구간**(B01 36단·B02~04 6단·.01 단가형) + **세트형 .02 합가형**(타투 3장당4000·팩 54장당4000) `[huni:stk-3axis §1.2]` |

**한 줄 결론**: 레드프린팅은 스티커를 **형태별 3엔진(die-cut `digital_price` 좌표+칼틀 / 판·DTF·UV `vTmpl_price` 규격템플릿 / 자유형정가 `tmpl_price`)으로 분기**하고, *사이즈(자유좌표 or 프리셋칼틀) × 소재(점착 합성자재) × 수량 × 인쇄방식(상품분기)* 으로 계산한다. **형상(shape_info)·칼선(THO)·재단(CUT)은 RedPrinting이 1급 옵션 슬롯으로 두지만 가격 PCS로 전달될 뿐 — 후니 가격표는 형상/반칼·완칼을 가격 차원으로 두지 않는다**(같은 사이즈/소재면 같은 단가·`[huni:bankal §2]`). 후니 스티커 가격 골격(이산 siz_cd × mat_cd × min_qty 수량구간 + 세트형 .02 합가형)은 `PRF_STK_FIXED` + `COMP_STK_PRINT`이 **이미 동형**으로 담으며 **신규 가격축/테이블 신설은 0건**. 실질 흡수 = ① 점착소재 spectrum을 mat_cd로 충실 전개(라이브 collapse 결함 보강) ② 소재→후가공 disable 제약(227건) ③ 형태별 공식 분기를 frm_cd로(엔진 코드 분기 아님). ★**rpmeta ST는 형상 #17 distinct 승격(옵션 관리 그릇 관점·vessel-gap)이나, 가격계산 관점에선 형상=가격축 아님(price-axis ≠ option-axis)** — 둘을 혼동하면 오모델. WowPress 스티커는 옵션·가격 미관측(보강 불가·정직 기록).

---

## 1. 흡수 후보 요약 보드 (C-S1~C-S8)

| ID | 흡수 후보 | 출처 | 후니 그릇 | 사다리 | 우선순위 | overfit 위험 | 답습 리스크 |
|----|----------|------|----------|--------|---------|------------|------------|
| **C-S1** | 형상(원형/사각/타원/라운드/자유) = **가격축 아님**(칼틀·상품정체) — 가격 차원에 형상 baked-in 금지 | 레드 shape_info 1급 / 후니 가격표 형상차원 0 `[huni:bankal]` | (가격축 부재) siz_cd 형상코드 or 상품정체 or CPQ | (가격엔진과 직교) | **High(가드)** | **낮음** | 낮음 |
| **C-S2** | 반칼/완칼·재단입자 = **공정**(`proc_cd`)·가격축 아님 — 같은 사이즈/소재면 동일가 | 레드 CUT_DFT 2종(DFXXX 반칼/DFITM 완칼) / 후니 PROC_053/054/055 | `proc_cd`(공정) + (단가 다르면) siz_cd 분리 | 코드행(이미 존재) | **High(가드)** | 낮음 | 낮음 |
| **C-S3** | 사이즈 = **이산 siz_cd**(명시규격·드롭다운)·**면적매트릭스 아님** | 레드 프리셋칼틀(CL/RC enum)+자유좌표 / 후니 가격표 2D 격자 `[huni:area-dim]` | `component_prices` `use_dims=[siz_cd,mat_cd,min_qty]` | 데이터(이미 존재) | **High** | 낮음(권위 정합) | 낮음 |
| **C-S4** | 점착소재 spectrum = `mat_cd` 차원(7종+) — 라이브 collapse/오매핑 보강 | 레드 자재 26종 합성코드 / 후니 B01 7소재(3 collapse·170 오매핑) `[huni:stk-3axis §2.1]` | `component_prices.mat_cd` 단가행 전개 | 데이터(보강) | **High** | 낮음 | 낮음 |
| **C-S5** | 소재→후가공 disable 제약(특수소재→박/형압/미싱/부분UV 비활성) | 레드 `pdt_disable_pcs_info` 227건 / 후니 미보유 | round-6 CPQ constraints(JSONLogic) | JSONLogic 제약행 | **Medium** | 낮음 | 낮음 |
| **C-S6** | 형태별 공식 분기(die-cut 단가형 / 판·DTF 템플릿 / 세트형 합가형)를 frm_cd로 | 레드 3엔진(`digital`/`vTmpl`/`tmpl`) / 후니 frm_cd | `frm_cd` 바인딩 + prc_typ_cd(.01/.02) | 코드행(이미 존재) | Medium | 중(엔진 과분화 경계) | 중(naming 가드) |
| **C-S7** | 인쇄방식(UV/DTF/후지) = 상품분기 + 종속자재 + 화이트강제 | 레드 pdtCode prefix(STPAU/STPAD/STBP)·DTF필름 단일 / 후니 상품정체 | 상품 정체 + mat_cd 종속 + CPQ 제약 | 데이터/제약 | Low | 낮음 | 중(naming 가드) |
| **C-S8** | 세트형 합가형(타투 3장당4000·팩 54장당4000) = `.02 prc_typ` + bdl_qty | 레드 die-cut/판 외 완제형 / 후니 B05 타투·B06 팩 `[huni:stk-3axis §1.2]` | `.02 합가형` comp + `bdl_qty` 차원 | 데이터(이미 그릇 존재) | **Medium(돈크리티컬)** | 낮음 | 낮음 |

**신규 테이블(vessel) 신설 = 0건.** 전부 기존 후니 그릇(이산 siz_cd·mat_cd 차원·proc_cd 공정·세트형 .02 합가형·round-6 CPQ 제약/옵션·frm_cd 바인딩)으로 닫힌다. ★rpmeta ST의 **#17 형상 distinct 승격(V-12 shape 슬롯)은 옵션 관리 그릇(vessel) 관점이며, 가격계산 관점에선 형상=가격축 아님** → 가격엔진엔 형상 차원 불요(둘은 직교·아래 §2 핵심 분리).

---

## C-S1. 형상 = 가격축 아님 (칼틀·상품정체) ★ (우선순위 High·핵심 가드·흡수=오모델 회피)

### 흡수 메커니즘 (그리고 흡수 ≠ 답습의 결정적 사례)
레드프린팅은 형상을 **1급 enum 슬롯**(`option_info.shape_info` = SQ/CL/EL/RC/FR)으로 두고, 이게 칼선(THO_DFT 프리셋 vs THO_GRA 자유)을 게이팅한다 `[red:ST-reverse §0.1]`. STDCFBR는 한 상품에 5형상 superset을 담아 형상=독립 선택차원임을 입증. **그러나 가격 reqBody를 보면 형상 자체가 가격 인자가 아니라 칼틀(PCS=THO_DFT/SQXXX)이 좌표/사이즈를 전달**할 뿐(`[red:ST-reverse §2 priceCall]`).

### 후니 매핑 (가격표 권위 — 형상 차원 0)
후니 가격표 스티커 B01 = `[수량] × [사이즈6] × [소재그룹3]` 3D 매트릭스로 **형상 차원이 아예 없다** `[huni:bankal §2.1]`. 058~063(반칼원형/정사각/직사각/띠지/팬시) 7상품을 라이브 실측하면 형상별 단가 분기가 0 — **같은 사이즈·소재면 형상이 달라도 같은 단가**(B01). 형상별 단가는 별 상품인 합판도무송(066)에만 존재. 즉 형상(원형/정사각/팬시)은 **반칼 칼선 모양(도무송 목형)** = 생산 칼틀이지 가격 결정요소 아님.

### 사다리 판정 (search-before-mint)
**가격엔진에 형상 차원 신설 = 부결(오모델).** 형상은 ① 상품 정체(상품명에 내재) ② 칼틀/도무송 형상은 siz_cd 형상코드(round-3 G-AC 형상 siz) or round-6 CPQ 옵션으로 별 관리 — **가격엔진과 직교**. ★rpmeta ST가 형상을 **#17 distinct 축으로 승격(V-12 shape_info 전용 슬롯)** 한 것은 *옵션 관리 그릇* 관점(KB G-SK-2 "형상이 어느 축에도 없음")이며, 그것이 *가격축 신설*을 의미하지 않는다. **option-axis ≠ price-axis** — 둘을 혼동해 component_prices에 형상 차원을 baked-in 하면 가격 폭발 + 오모델.

### trade-off
- 장점: 형상을 가격축에서 분리하면 가격표(이산 siz_cd×mat_cd) 단순 보존 + 형상은 CPQ/siz 형상코드로 자유 선택(UX).
- 단점: 형상이 *진짜* 단가를 가르는 예외(합판도무송 066처럼 형상별 고정사이즈 단가)는 **별 상품/별 공식**으로 분리(형상=가격축이 아니라 그 상품이 형상별 고정가일 뿐).

### naming 유입 가드 [HARD]
`shape_info`/SQ/CL/EL/RC/FR/THO_DFT 후니 유입 금지. 후니는 형상을 가격엔진 밖(상품정체·siz_cd 형상코드·CPQ)으로 번역.

---

## C-S2. 반칼/완칼·재단입자 = 공정 (가격축 아님) ★ (우선순위 High·핵심 가드)

### 흡수 메커니즘
레드프린팅 재단입자 `CUT_DFT` 2종 `[red:ST-reverse §0.3]`: **DFXXX 묶음재단**("기본 A5~A4 묶음재단:반칼로 떼어 쓸 수 있도록")=**반칼시트(kiss-cut)** / **DFITM 개별재단**("낱개=개별재단")=**완칼낱장(full-cut)**. 상품명 "사각반칼"의 "반칼"이 곧 묶음재단(DFXXX) 기본값. 가격 reqBody에 `CUT_DFT/DFXXX`가 PCS로 전달(`[red:ST-reverse §2]`).

### 후니 매핑 (공정·가격 직교)
후니는 반칼/완칼/도무송을 **공정**(`proc_cd` PROC_053/054/055 — rpmeta ST S-3 PASS로 라이브 실재)으로 둔다. 가격은 가격표가 권위: B01(반칼) 격자에 "반칼이라서 +α" 같은 가산이 없고, 같은 사이즈/소재면 동일 단가. ★단, **완칼이 반칼과 다른 단가를 가지면**(예: 낱장완칼 B02/B03이 반칼 B01과 다른 가격표 블록) 그건 **siz_cd 분리**로 표현 — 058~061이 A4(SIZ_172=B02 낱장완칼가)에 등록돼 잘못 매칭될 위험이 dbmap에서 적발됨(`[huni:bankal §3]`). 즉 "재단입자가 가격을 가르면 siz_cd로, 안 가르면 공정으로".

### 사다리 판정 (search-before-mint)
**가격엔진에 재단입자 차원 신설 = 부결.** 공정(proc_cd) 기존 코드행으로 닫힘. ★돈-크리티컬 가드: 반칼 사이즈에 완칼 단가행(또는 그 반대)을 매핑하면 오청구(dbmap A4 돈크리티컬 분리 사례 — 반칼전용 siz_cd 별 채번으로 해소). RedPrinting이 반칼/완칼을 가격 PCS로 전달하는 것을 "재단=가격축"으로 오독 금지.

### trade-off
- 장점: 재단입자=공정으로 두면 가격표 격자 보존·생산BOM 정합. 단가 차이는 siz_cd가 흡수(반칼시트 vs 완칼낱장 단가표가 다르면 siz 분리).
- 단점: 반칼/완칼 단가가 같은 사이즈 코드를 공유하면 오청구 — 단가가 다른 순간 siz_cd 분리 필수(돈크리티컬).

### naming 유입 가드 [HARD]
`CUT_DFT`/DFXXX/DFITM 후니 유입 금지. 후니 `proc_cd`로 번역.

---

## C-S3. 사이즈 = 이산 siz_cd (면적매트릭스 아님) ★ (우선순위 High·흡수 강·결정적 분기)

### 흡수 메커니즘
레드프린팅 스티커 사이즈는 두 모드 `[red:ST-reverse §0.2·§1·§3]`: ① die-cut 자유형 = **자유좌표 입력**(CUT_WDT/HGH·4×4mm~) ② 정형(원형/라운드) = **프리셋 칼틀 enum이 사이즈 겸함**(CL001~010 원형 10x10~100x100·RC001~025 라운드 40x20~100x100). 판/DTF = 고정 판규격(140x200·A4).

### 후니 매핑 (이산 siz_cd — 면적매트릭스 명시 부결)
후니 가격표 스티커는 **명시 이산 규격값**(124x186·A4·A3·90x190·100x148·90x110·B4·B3·A2 등)이고 가격표가 `[수량]×[규격]` 2D 격자다 `[huni:stk-3axis §1.3]`. ★**아크릴·실사/현수막과 결정적으로 다름**: 그쪽은 자유 가로/세로 연속입력 → off-grid ceiling 필요 → `siz_width/siz_height` 구간 매트릭스가 정답(메모리 `dbmap-area-matrix-wh-dimension`). **스티커는 사이즈가 드롭다운 선택지(6개·5개)라 `siz_cd` 정확매칭이 맞다**(신안 siz_width/height 구간 전환 대상에서 **제외**). 판수(4판/2판/12판)=임포지션 판걸이수=siz_cd note 보존·앱 계산(가격 미저장).

### 사다리 판정 (search-before-mint)
**신규 불요.** `component_prices` `use_dims=[siz_cd,mat_cd,min_qty]` 기존 그릇이 담는다(라이브 COMP_STK_PRINT 258행). ★흡수 = "**스티커 사이즈는 이산 siz_cd**(면적매트릭스 아님)"를 설계 원칙으로 못박는 것. RedPrinting 자유좌표(die-cut)는 후니 자유형 스티커(052/055 반칼자유형/낱장자유형)가 가격표 규격 격자에 매핑되는지 확인 — 후니 자유형도 가격표는 이산 규격(124x186 등)이라 면적 함수 부결.

### trade-off
- 장점: 가격표 이산 격자 그대로 보존·엔진 정확매칭. 면적함수 오판 회피(메모리 `dbmap-price-formula-types-authority`).
- 단점: B01 6사이즈 중 라이브 2개만 적재(100x148·90x110 미적재·siz 신규 채번 대상)·B02/B03 B4/B3 단가행 미적재 — data-gap(채번/적재 문제이지 모델 문제 아님).

### naming 유입 가드 [HARD]
RedPrinting 자유좌표/CL001/RC025/STICKER_TYPE 후니 유입 금지. 후니 siz_cd(명시규격) 번역.

---

## C-S4. 점착소재 spectrum = mat_cd 차원 (라이브 collapse/오매핑 보강) ★ (우선순위 High·흡수 강·결함 보강)

### 흡수 메커니즘
레드프린팅 스티커 자재(`pdt_mtrl_info`)는 **지종(PTT) × 평량(WGT) × 점착성 합성**으로 26종까지 한 상품 enum에 공존 `[red:ST-reverse §0.4]`: 일반 라벨/초강접/PET투명·은무·금광/유포(옥외)/리무버블/금은동 메탈/한지/자석/저온. 점착 종류는 ① 한 상품 소재 옵션 ② 점착특화 상품(STRMDFT 리무버블·STOTDFT 옥외·STMADFT 자석) 동시 인코딩.

### 후니 매핑 (mat_cd 차원 — 라이브 결함 보강 필요)
후니 가격표 B01 = 7소재(유포·비코팅·미색·무광코팅·유광코팅·투명·홀로그램) `[huni:stk-3axis §2.1]`. 메커니즘 = `component_prices.mat_cd` 단가행(가격표 그룹이 같은 단가라도 소재별 개별 행 — 엔진이 mat_cd로 매칭). ★**라이브 결함**: 7소재가 **3 mat_cd로 collapse**(153 유포·155 무광·170 투명) + **투명 162가 170 합판도무송 전용 소재로 오매핑** + 비코팅/미색/유광/홀로그램 4소재 미적재. 이건 신규 축이 아니라 **data-gap(소재 전개) + 오매핑 교정**(round-13 동시).

### 사다리 판정 (search-before-mint)
**신규 테이블 불요.** mat_cd 차원 기존 그릇. 흡수 = 가격표 7소재를 mat_cd로 충실 전개(균등 단가 적재) + 170→162 오매핑 교정. RedPrinting의 점착 spectrum(리무버블/옥외/저온/자석)은 후니 자재축(round-22 ④·basecode §12)이 점착성/내후성 facet을 mat_cd로 담을지 입력(rpmeta ST S-4 WEAK=기존 #1 자재축 흡수).

### trade-off
- 장점: 소재별 정확 단가매칭·점착특화 상품(옥외/리무버블)도 mat_cd variant로 일관 인코딩.
- 단점: 같은 단가라도 소재별 행 분리(엔진 매칭 위해)·소재 오염 코드(유포 152/153/154·홀로그램 257/191/163) 중 .11 점착지 정답코드만 사용(round-13 정합). MAT_TYPE.13(비코팅/미색/투명데드롱) 의미 컨펌 미해소.

### naming 유입 가드 [HARD]
`MTRL_CD`(RXATL090)·PTT/WGT 슬롯·STRMDFT 등 후니 유입 금지. 후니 mat_cd 번역.

---

## C-S5. 소재→후가공 disable 제약 (우선순위 Medium·흡수 중)

### 흡수 메커니즘
레드프린팅 `pdt_disable_pcs_info` = **227건**(26소재 × 후가공 조합) `[red:ST-reverse §1]` — 특수소재(PET/금속/한지) 선택 시 미싱(MIS_DFT)·부분UV(SCO_DFT)·접지(FLD_DFT)·코팅(COT_DFT)·형압(EMB_DFT)·박(FOI_DFT) 등 10종 후가공 UI disable. PR(24건)·아크릴 명찰(3건)보다 압도적으로 깊다 = 스티커 소재 다양성이 제약 폭발의 원인.

### 후니 매핑
후니 가격엔진엔 "이 소재엔 이 후가공 불가" 제약이 없다 → round-6 CPQ constraints(JSONLogic)로 닫는다: `{"if":[{"in":[{"var":"mat_cd"},["<특수소재>"]]}, {"not":{"in":[{"var":"pcs"},["<미싱>","<부분UV>","<박>"]]}}]}`. 화이트인쇄=투명/유색소재 종속, DTF=화이트강제도 같은 제약 레이어.

### 사다리 판정 (search-before-mint)
round-6 CPQ constraints 제약행 추가로 무손실(C-S7 인쇄방식·디지털 C-4·아크릴 C-A5 제약 레이어와 동일 그릇). **data-gap이지 vessel-gap 아님.**

### trade-off
- 장점: 잘못된 (소재, 후가공) 조합 가산을 견적에서 차단 → 가격 정합·UX 정합(특수소재 박 불가 등).
- 단점: 227건 = 데이터화 비용 큼(스티커가 제약 가장 무거운 상품군). 권위 엑셀 상품마스터 후가공 컬럼에 명시면 그게 정답(경쟁사=보강).

### naming 유입 가드 [HARD]
`disable_pcs`·MIS_DFT/SCO_DFT/FOI_DFT/EMB_DFT 후니 유입 금지. 후니 proc_cd/JSONLogic 번역.

---

## C-S6. 형태별 공식 분기 (die-cut / 판·DTF / 세트형)를 frm_cd로 (우선순위 Medium·엔진 과분화 경계)

### 흡수 메커니즘
레드프린팅 ST **한 카테고리에 3 가격엔진 공존** `[red:ST-reverse §0.6·summary]`: ① die-cut(자유형/반칼·자유좌표+칼틀)=`digital_price` ② 판/DTF/UV(고정규격·장단위)=`vTmpl_price` ③ 자유형 정가(STPADIY)=`tmpl_price`. 형태가 가격엔진을 가른다.

### 후니 매핑
후니는 이를 `frm_cd`(상품→공식 바인딩) + `prc_typ_cd`(.01 단가형/.02 합가형)로 표현 — 엔진 코드 분기 아님. 현 라이브 `PRF_STK_FIXED`(단일 공식·3건 바인딩)가 die-cut·낱장을 담고, 세트형(타투/팩)은 `.02 합가형` 별 comp(C-S8). 판/DTF 스티커가 후니 상품군에 들어오면 별 frm_cd(판 규격 템플릿가)일 수 있으나 — **단일 evaluate_price + 데이터(frm_cd/comp) 분기가 권위**(메모리 `harness-audit-maintenance`).

### 사다리 판정·overfit 경계
**기존 frm_cd 코드행으로 닫힘(신규 테이블 0).** ★엔진 과분화 경계 — RedPrinting `digital_price`/`vTmpl_price`/`tmpl_price`처럼 "스티커 전용 엔진"을 후니 코드 레벨로 신설하면 overfit. 흡수 = 공식 분기를 데이터(frm_cd)로 두는 것. rpmeta ST가 가격엔진 3종을 가격#11 facet으로 흡수(distinct 부결)한 것과 정합. 같은 die-cut 계열은 가능한 한 1 공식(PRF_STK_FIXED) + siz_cd/mat_cd 차원, *계산 방식이 진짜 다를 때만*(세트형 .02·판 템플릿가) 별 공식.

### trade-off
- 장점: 형태별 공식 가독성·관리성↑(die-cut 단가형 / 세트형 합가형 / 판 템플릿가).
- 단점: 공식을 형태마다 신설하면 관리 비용 — 세트형은 prc_typ_cd .02 분기로 충분(별 엔진 불요).

### naming 유입 가드 [HARD]
`digital_price`/`vTmpl_price`/`tmpl_price` 후니 유입 금지. 후니 frm_cd(의미기반 한글공식명) 번역·naming 권위순서(후니 레거시 최우선).

---

## C-S7. 인쇄방식(UV/DTF/후지) = 상품분기 + 종속자재 + 화이트강제 (우선순위 Low·흡수 약)

### 흡수 메커니즘
레드프린팅은 인쇄방식을 **pdtCode prefix 상품분기**(STTH일반/STPAU UV/STPAD DTF/STBP후지)로 두고, 인쇄방식이 **자재(DTF=DTF전용필름 단일)·도수노출(DTF=dosu 숨김)·화이트강제(DTF=PRT_WHT ESN_YN=Y)·가격엔진(판=vTmpl_price)** 을 동반 결정 `[red:ST-reverse §0.5·§3]`. PR 책자 인쇄방식(윤전/토너/인디고) 분기와 횡단 동형.

### 후니 매핑
후니는 인쇄방식을 **상품 정체**(별 상품)로 두고 + 종속자재(`mat_cd` DTF필름)·화이트강제(round-6 CPQ 제약)·도수 고정(clr_cd). 가격은 그 상품의 frm_cd/comp가 담음. 메모리 `dbmap-print-method-not-absolute-axis`("인쇄방식≠절대축")와 정합 — 인쇄방식이 절대 가격축이 아니라 상품 정체+종속속성.

### 사다리 판정 (search-before-mint)
신규 불요 — 상품 정체 + mat_cd + CPQ 제약 기존 그릇. rpmeta ST S-5(인쇄방식 GAP=기존 #12 흡수). 후니 디지털인쇄 가격엔진(`PRF_DGP_*`)에 UV/DTF가 들어오면 별 상품+종속자재.

### trade-off
- 장점: 인쇄방식별 종속자재/화이트강제를 제약으로 정확 표현.
- 단점: 후니 스티커 상품군에 UV/DTF가 실재하는지 권위 엑셀 확인 필요(없으면 흡수 보류·watchlist).

### naming 유입 가드 [HARD]
STPAU/STPAD/STBP·`vDigital_item`·PXPUF003(DTF필름) 후니 유입 금지. 후니 상품정체/mat_cd 번역.

---

## C-S8. 세트형 합가형 (타투 3장당4000·팩 54장당4000) = .02 prc_typ + bdl_qty ★ (우선순위 Medium·돈크리티컬)

### 흡수 메커니즘
레드프린팅 die-cut/판 외에 **묶음판매 완제형**이 존재(타투·팩·마스킹테이프·밴드 — `[red:ST-reverse §0.6·그룹 F]`). 후니 가격표가 이를 명확히 보유 `[huni:stk-3axis §1.2]`: **B05 타투 = "3장마다 4000원"**(합가형 구간총액)·**B06 스티커팩 = "54장 1세트 4000"**(세트당). 이는 die-cut의 개당×수량(.01 단가형)과 결정적으로 다른 **묶음 총액형**.

### 후니 매핑 (이미 그릇 보유·라이브 결함)
후니 = `.02 합가형` comp(`COMP_STK_TATTOO`·`COMP_STK_PACK`) + `bdl_qty` 차원(타투 bdl_qty=3·팩 bdl_qty=54) + 엔진 `구간총액÷min_qty×수량`. ★**라이브 결함**: B06 팩이 `prc_typ_cd=.01 단가형`으로 **오적재**(가격표 "54장 1세트 4000"=.02 합가형이어야)·공식·바인딩도 없음 + B05 타투는 공식·comp·단가행 전무. 이건 **디지털 ×qty 과청구·아크릴 .02 정합 위험과 동일 클래스의 돈크리티컬**(prc_typ 오적재가 가격을 ×수량 왜곡).

### 사다리 판정 (search-before-mint)
**신규 그릇 불요** — `.02 prc_typ` + `bdl_qty` 차원이 라이브에 이미 존재(round-23 스티커 COMP_STK_PACK/TATTOO 합가형 교정 = 디지털 명함 .01→.02 교정·아크릴 min_qty 동형 선례). 흡수 = 가격표 묶음 단위(3장/54장)를 bdl_qty로 정확 인코딩 + prc_typ_cd .02 교정.

### trade-off
- 장점: 묶음 총액형(타투/팩)을 개당단가와 분리해 정확 표현(÷min_qty×수량으로 골든 재현).
- 단점: 환산 단위(÷54 장당 vs 세트당) 컨펌 미해소(Q-STK-3)·타투 "기본가 2000 + 3장당 4000" 관계 컨펌(Q-STK-1·3장 미만 최소가 별 base comp?).

### naming 유입 가드 [HARD]
RedPrinting 묶음 코드 후니 유입 금지. 후니 `.02 prc_typ`+`bdl_qty`+한글 comp명 번역.

---

## 2. ★핵심 분리: 형상·칼선·재단 = 옵션축이지 가격축 아님 (price-axis ≠ option-axis)

> 이 절은 directive 특별 요청("반칼/완칼·도무송 형상·소재·판형이 가격에 미치는 영향" + dbmap "반칼=칼틀=가격축 아님" + rpmeta ST 형상 distinct 승격 연결)의 핵심 종합.

| 차원 | RedPrinting 처리 | 후니 가격표 처리 | 가격축인가? |
|------|------------------|------------------|------------|
| **형상**(원형/사각/타원/라운드/자유) | `shape_info` 1급 enum·칼선 게이팅(옵션 슬롯) | 가격 차원 0(같은 사이즈/소재=같은가) | ❌ **가격축 아님**(상품정체·칼틀·CPQ) |
| **칼선**(자유 THO_GRA / 프리셋 THO_DFT) | PCS 그룹 2종·가격 reqBody 전달 | 공정(proc_cd 도무송) | ❌ **가격축 아님**(공정) |
| **재단입자**(반칼 DFXXX / 완칼 DFITM) | CUT_DFT PCS·가격 전달 | 공정(PROC_053/054/055) | ❌ **가격축 아님**(단, 단가 다르면 siz_cd 분리) |
| **사이즈** | 자유좌표 or 프리셋칼틀 | 이산 siz_cd(명시규격) | ✅ **가격축**(siz_cd·면적매트릭스 아님) |
| **소재**(점착 spectrum) | 자재 합성코드 26종 | mat_cd 7소재 | ✅ **가격축**(mat_cd) |
| **수량** | prn_cnt·이중수량 | min_qty 구간 + 세트형 bdl_qty | ✅ **가격축**(min_qty/bdl_qty + t_dsc) |
| **인쇄방식**(UV/DTF/후지) | pdtCode 상품분기 | 상품정체+종속자재 | △ **간접**(상품정체+mat_cd, 절대축 아님) |

### 핵심 시사점 (designer 입력)
1. **형상/칼선/재단 = 옵션 관리축이지 가격축 아님 [HARD]**. RedPrinting이 형상(shape_info)·칼선(THO)·재단(CUT)을 1급 옵션 슬롯으로 두는 것을 보고 "가격에도 형상/칼선 차원이 있어야" 한다고 오독하면 가격 폭발 + 오모델. **가격축 = 사이즈(이산 siz_cd) × 소재(mat_cd) × 수량(min_qty/bdl_qty)** 3축뿐(rpmeta ST 형상 #17 distinct ↔ 가격 무관).
2. **rpmeta ST 형상 distinct 승격(V-12) = 옵션 그릇 vessel-gap, 가격 vessel-gap 아님**. 형상이 어느 *옵션 축*에도 없다는 결함(KB G-SK-2)은 옵션 관리 그릇 신설을 요구하나, *가격엔진*에는 형상 차원 불요. **option-axis ≠ price-axis 분리 원칙을 엔진 설계에 명시**.
3. **단, 재단입자가 단가를 가르는 순간 siz_cd로 [돈크리티컬]**. 반칼 vs 완칼이 같은 사이즈인데 다른 단가표(B01 반칼 vs B02 낱장완칼)면 같은 siz_cd 공유 시 오청구 → 반칼전용 siz_cd 별 채번(dbmap 돈크리티컬 분리 사례·`[huni:bankal §3]`). "재단=공정(가격무관)"이 기본이되 "단가 다르면 siz_cd 분리"가 예외.
4. **형상별 고정사이즈 단가가 있는 예외 = 별 상품/별 공식**(합판도무송 066처럼 형상별 고정가) — 이건 형상=가격축이 아니라 그 상품이 형상별 고정가형일 뿐(C-S1 trade-off).

---

## 3. 디지털 ×qty / 아크릴 .02 돈크리티컬 맥락 — 스티커 수량처리 대조 ★

> 디지털인쇄(.01 ×수량 과청구)·아크릴(.02 정합 미확정)과 동일 클래스 위험을 스티커에서 점검.

| 관점 | 레드프린팅 스티커 | 후니 스티커 가격표 | 시사점 |
|------|------------------|-------------------|--------|
| die-cut 본체 수량 | prn_cnt 100단위 select·이중수량(ordCnt×printCnt) `[red:ST-reverse §1]` | B01 min_qty **상향 36단**(.01 단가형 `단가×수량`)·B02~04 6단 `[huni:stk-3axis §1.2]` | die-cut = **개당×수량**(.01 정상)·디지털 ×qty 과청구와 다른 정상 구조(단가행이 개당 단가) |
| **세트형 본체** | 타투/팩(묶음판매·완제형) | **B05 타투 .02 합가형**(3장당4000)·**B06 팩 .01 오적재**(54장당4000인데 단가형) | ★**팩 prc_typ .01 오적재 = 디지털 명함 .01 과청구·아크릴 .02 위험과 동일 클래스**(.02여야 ÷54로 정확·.01이면 ×수량 왜곡) |
| 후가공 가산 | 코팅/화이트/넘버링/부분UV PCS·ESN_YN=N(선택) | B01 후가공 추가단가(추정 개당 1회) | 후가공이 **개당 1회**인지 ×수량인지 = 디지털 결함과 동일 클래스(prc_typ .01 ×수량 = 과청구) — 검증 선결 |
| 이중수량 | 디자인수(ordCnt) × 수량(printCnt) 명시분리 | 가격축 아님(주문라인) | 디자인 건수를 가격 차원에 baked-in 금지(디지털 C-5·아크릴 동일 가드) |
| 수량 곡선 | 100단위 이산 + 36단 구간 | min_qty 36단 + 구간할인 t_dsc 별 단계 | 스티커 = 대량 이산구간 + 별 단계 할인(면적단가×수량 후 할인 아님·단가형) |

### 핵심 대조 시사점
1. **★B06 팩 prc_typ .01 오적재 = 돈크리티컬**. 가격표 "54장 1세트 4000"이 .01 단가형이면 엔진이 ×수량 → 54배 과청구. .02 합가형(÷54×수량)으로 교정 선결(디지털 명함 .01→.02·아크릴 min_qty 교정 동형 클래스). **추측 적재 금지·prc_typ 확정 후 적재**.
2. **B05 타투 .02 합가형은 정합**(3장당4000÷3×수량)이나 "기본가 2000" 관계 컨펌 미해소(3장 미만 최소가 별 base comp인지·Q-STK-1).
3. **후가공 "개당 1회 vs ×수량" 명시** — 디지털 결함 교훈으로 스티커 후가공 comp prc_typ·수량축 정합 검증(designer 엔진 계약).
4. **할인 적용 순서** — die-cut은 단가형(단가×수량) 후 t_dsc 구간할인 별 단계. 면적단가형(아크릴)의 "면적단가×수량 후 할인"과 다름(스티커는 단가행 자체가 수량구간 단가). designer가 할인 적용 순서를 엔진 계약에 명시.

---

## 4. 흡수 종합 판정

1. **스티커 가격계산 골격(이산 siz_cd × mat_cd × min_qty 수량구간 + 세트형 .02 합가형 + 형태별 frm_cd)은 후니 가격표(260527 스티커 7블록)와 라이브 `PRF_STK_FIXED`/`COMP_STK_PRINT`가 이미 동형으로 담는다** → 핵심 흡수 불요(C-S3·C-S8 = 이미 그릇 보유·설계 원칙 못박기).
2. **실질 흡수 = ① 점착소재 spectrum mat_cd 전개(C-S4·라이브 collapse/오매핑 보강·data-gap) ② 소재→후가공 disable 제약 227건(C-S5·round-6 CPQ) ③ 형태별 공식 분기 frm_cd(C-S6)** — 전부 기존 그릇으로 닫힘.
3. **핵심 가드(C-S1·C-S2·§2) = 형상·칼선·재단입자는 옵션축이지 가격축 아님** [HARD]. RedPrinting이 1급 옵션 슬롯으로 두는 것을 가격축으로 오독 금지. **option-axis ≠ price-axis** — 단, 재단입자가 단가를 가르면 siz_cd 분리(돈크리티컬).
4. **신규 가격축/테이블 신설 = 0건** — rpmeta ST의 **#17 형상 distinct 승격은 옵션 관리 그릇(V-12) 관점이며 가격 vessel-gap 아님**(가격엔진엔 형상 차원 불요). search-before-mint 통과. 6종단 누적 결론(신규 가격축 0·후니 그릇 우월·배선/data-gap)과 일관.
5. **WowPress 스티커 = 옵션·가격 미관측**(라이브 경로 404·옛 캡처에 스티커 명목 존재나 옵션/가격 페이지 미해소 `[wow:probe]`) — 가격화 방식 보강 불가·정직 기록(실사/아크릴 동일). RedPrinting(사용자 본인 설계·흡수 정당)이 주 오라클.
6. **★돈크리티컬 2건**: B06 팩 prc_typ .01 오적재(→.02 교정 선결·54배 왜곡 위험)·반칼/완칼 단가 다른데 siz_cd 공유(오청구·siz 분리). 디지털 ×qty·아크릴 .02 정합과 동일 클래스.
7. **모든 흡수는 권위 엑셀이 최종** — 경쟁사가 가격표(B01~B06)와 충돌하면 가격표가 이긴다.

### designer로 넘기는 핵심 입력
- **가격축 3개뿐**: 사이즈=**이산 siz_cd**(면적매트릭스 부결·C-S3) × 소재=**mat_cd 7종 전개**(라이브 collapse 보강·C-S4) × 수량=**min_qty 구간 + 세트형 bdl_qty**(C-S8).
- **형상·칼선·재단 = 가격축 밖**(상품정체·proc_cd·CPQ·C-S1/C-S2/§2) — **option-axis ≠ price-axis 엔진 설계 명시** [HARD]. 단 재단입자 단가 차이는 siz_cd 분리(돈크리티컬).
- **형태별 공식 분기**(die-cut PRF_STK_FIXED 단가형 / 세트형 .02 합가형 / 판 템플릿가)는 `frm_cd`+`prc_typ_cd` 데이터로(엔진 코드 분기 아님·C-S6).
- **소재→후가공 disable + 인쇄방식 화이트강제**는 round-6 CPQ constraints(C-S5/C-S7·227건이 상품군 중 가장 무거움).
- **★돈크리티컬**: B06 팩 `prc_typ .01→.02 교정`(54배 왜곡 회피)·후가공 "개당 1회 vs ×수량" 엔진 계약 확정·반칼/완칼 단가 다르면 siz_cd 분리(추측 적재 금지).
- **할인 적용 순서**(die-cut 단가×수량 후 t_dsc 구간할인 별 단계)를 엔진 계약에 명시.
