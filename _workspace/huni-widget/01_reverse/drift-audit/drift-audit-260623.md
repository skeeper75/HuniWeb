# RedPrinting 위젯/에디터 역공학 자산 드리프트 감사 (2026-06-23)

> 파이프라인 ① hw-reverse-engineer. 4월 원천(역공학 기반) vs 6월 라이브 최신 자산 드리프트 진단.
> 라이브 읽기전용 GET만 수행(주문/폼submit 0). 비밀값 비노출.
> 권위 방법론: `_workspace/huni-re-verify/_meta/re-methodology-research.md` Stage 0.

---

## 1. 자산 인벤토리 — 최신 취득 결과 [라이브 검증]

라이브 CDN: `https://d2vgy67dgpwzce.cloudfront.net/` (HEAD/GET으로 실측)

| 자산 | 4월 원천 (역공학 기반) | 6월 라이브 (취득) | 드리프트 | sourcemap |
|------|----------------------|-------------------|----------|-----------|
| `widget.js` | 450,469 B · 2026-04-01 | **587,493 B · 2026-06-22** | **+137,024 B (+30%)** | 없음 |
| `RedEditorSDK.min.js` | 250,188 B · 2026-04-01 (symlink) | **250,177 B · 2026-06-05** | -11 B (국소 변경) | 없음 |
| `widget.css` | 28,310 B · 2026-04-01 | **45,433 B · 2026-06-22** | **+17,123 B (+60%)** | 없음 |

취득물 보존(4월 원천 비파괴): `_workspace/huni-widget/01_reverse/_latest/`
- `widget.js.20260622` (etag 89f7faf2…, last-modified Mon 22 Jun 2026 08:03:02 GMT)
- `RedEditorSDK.min.js.20260605` (etag f69ffc3d…, last-modified Fri 05 Jun 2026 03:27:03 GMT)
- `widget.css.20260622` (etag 289385d9…)

`raw/widget_monitor/local/widget.js`(6/22 587,493 B)는 이미 라이브 최신과 byte-동일 — 이미 최신. 단 `RedEditorSDK.min.js`·`widget.css`는 local에서 4월 원천을 symlink(STALE) → `_latest/`에 6월 실물 확보.

### sourcemap 가용성 — 없음 [라이브 검증]
- 3개 자산 모두 inline `sourceMappingURL` 없음.
- `.map` sibling 5종 변형 probe 전부 S3 403(부재): `widget.js.map`/`widget.min.js.map`/`RedEditorSDK.min.js.map` 등.
- 번들러 지문: widget.js = **Vite/Rollup IIFE**(Vue 3.5.21), `__webpack_require__`/webpackChunk 마커 0 → `unwebpack-sourcemap` 비적용.
- **결론**: Stage 0 sourcemap recovery 경로 불가. 재역공학은 **Babel AST 디옵 + 런타임 Pinia 추출**(Stage 0 대안 ②③)으로 진행해야 함.

---

## 2. widget.js +137KB 드리프트 분석 [라이브 검증]

프레임워크 동일(Vue @vue/shared **3.5.21** 변화 없음) → +137KB는 **앱 코드(신규 기능)**.

### 2.1 한글 UI 라벨 +318 토큰 (515→833, +62%)
TRANSLATIONS_KO가 대폭 확장. 신규 기능 도메인(증거=신규 한글 토큰):

| 신규 도메인 | 신규 토큰(예) | 의미 |
|------------|--------------|------|
| 귀돌이/라운드 | 귀돌이, 귀돌이최소선택안내, 사각라운드형 | 모서리 라운드 가공 옵션 |
| 걸이/거치 | 걸이형, 걸이타입, 거치대, 자석거치대부착가능/불가, 책받침코팅 | 걸이/스탠드 제품군 |
| 접지(fold) | 가로방향접지, 세로방향접지, 단접지, 접지가이드(다운로드/불가/안내), 병풍 | 접지 가공 옵션 + 가이드 |
| 글꼴(font) | 글꼴선택, 폰트안내, 나눔고딕, 고딕 | 폰트 선택 UI |
| 포장 | 개별포장, 낱장인쇄중단안내, 묶음 | 개별포장/묶음 옵션 |
| 업로드 | 업로드규격확인안내, 파일업로드후가공안내 | 업로드 가이드 강화 |

### 2.2 신규 API 엔드포인트 [라이브 검증]
| 신규 | 4월 | 의미 |
|------|-----|------|
| `/api/garage/presigned` | (S3만) | **신규 Garage 업로더 서브시스템** |
| `get_basic` | 없음 | 기초정보 조회 |
| `get_fld_download` | 없음 | 접지 가이드 다운로드 |

### 2.3 신규 업로더 서브시스템: Garage [라이브 검증]
4월에 없던 `GarageUploader`, `Garage`, `garage`, `/api/garage/presigned`, `s3_region` 토큰 추가.
기존 `S3Uploader`/`/api/aws/presigned`와 **병존하는 제2 업로드 경로**.

### 2.4 가격 API 필드사전 신규 필드 [라이브 검증]
4월 widget.js에 없던 대문자 상수(가격/주문 페이로드 관련):
`ADD_CLR_YN`, `ADD_ORD_PRN_CNT`, `FLD_DFT_H`, `FLD_DFT_V`, `MAX_PRN_CNT`, `MIN_ORD_PRN_CNT`,
`PACK_PRN_CNT`, `REAM_CNT`(연/ream), `UNIT_PRN_CNT`, `PDT_SIZE_INFO`, `NCDFFLD`, `RIN_CUT`,
`STTTDFT_CUT_DFT`, `STTTDFT_THO_CUT`.
→ 접지(FLD_DFT_*)·포장수량(PACK_PRN_CNT)·연수(REAM_CNT)·추가색상(ADD_CLR_YN) 등 신규 가격 차원.

---

## 3. RedEditorSDK 드리프트 — MINOR [라이브 검증]

버전 문자열 **6.6.48 동일**. 전체 250KB 중 단일 함수 블록(prefix 182716 / suffix 34282)만 변경.
한글/API 토큰 신규 0. 구체 diff 3건:

1. 커맨드 빌더 `G()` 선두 `console.log(t,e),` **디버그 제거**.
2. customTab 경로 `console.log(">>>>>>>>>>>>>",{usePalette:k},…)` + 캡처 변수 `k=` **디버그 제거**.
3. **`documentSizeInfo.type` 신규 처리**: createProject/openProject 양쪽에서
   `I=w.type … I&&(e.extra.sizing.type=I)` → editor config에 `sizing.type` 필드 추가(MINOR 기능 확장).

`From-KOI-Passive` 프로토콜(load/save/error/close), `createProject`/`openProject` 계약,
psCode 특수분기(PHBKPRM=표지 삭제), Sentry(betterwaysystems) 통합 — **전부 4월과 동일·온전**.
→ 기존 editor-bridge 역공학은 SDK 측은 거의 유효(sizing.type만 보강 필요).

---

## 4. 기존 역공학 산출물 stale 지점 (4월 기반 → 6월 어긋남)

| 산출물 | stale 지점 | 심각도 | 근거 |
|--------|-----------|--------|------|
| `s3-upload-flow.md` | **Garage 업로더(/api/garage/presigned) 완전 부재** | **BLOCKER** | §2.3 신규 서브시스템·기존 spec 0건 언급 |
| `price-engine-reversed.md` | 신규 가격 필드(FLD/PACK/REAM/ADD_CLR/UNIT_PRN) 미반영 | **MAJOR** | §2.4 신규 14필드 |
| `option-schema-catalog.json` | 신규 옵션군(귀돌이·걸이형·접지·글꼴·개별포장) 미수록 | **MAJOR** | §2.1 +318 한글토큰 |
| `editor-bridge-protocol.md` | `sizing.type` 신규 파라미터 누락 | MINOR | §3-3 |
| `widget-runtime-spec.md` | 5스토어/6API 골격은 유효, 신규 API 2종(get_basic/get_fld_download) 미반영 | MINOR | §2.2 |
| `gaps-resolved.md` | 4월 위젯 기준 "구현 착수 가능" 판정 — 6월 신규 기능 미커버 | MAJOR | 전반 |

§22(huni-re-verify) 가격 API **계약**은 정합했으나, 그 검증도 4월 필드사전 기준이라 신규 14필드는 미검증.

---

## 5. 드리프트 심각도 종합

| 자산 | 심각도 | 요지 |
|------|--------|------|
| widget.js (앱코드 +137KB) | **MAJOR** | 신규 기능군 6+·신규 API 3·Garage 업로더·가격필드 14 — 구조 보존하나 표면적 대폭 확장 |
| RedEditorSDK | **MINOR** | 디버그 제거 + sizing.type 1필드. 프로토콜/계약 온전 |
| widget.css (+17KB) | MINOR-MAJOR | 신규 옵션군 UI 스타일 추가 추정(미정밀분석) |

BLOCKER(계약 깨짐)는 **없음** — 기존 계약은 superset으로 확장됐을 뿐(필드 제거·rename 미발견). 단 신규 기능 미커버가 "제대로 동작 수준"을 막음.

---

## 6. 재역공학 강화 계획 (실행=승인 후 다음 단계)

베스트프랙티스 순서(re-methodology Stage 0): sourcemap → AST deob → runtime.

### Phase R0 — 정적 디옵 (sourcemap 불가 → AST 경로) [예상 산출]
- 6월 widget.js를 Babel parse → AST 등가보존 디옵(string-edit 금지). `ast-grep` 구조검색으로 신규 모듈(Garage 업로더·접지·귀돌이·글꼴) 함수 위치 특정.
- 4월 deob(`03_deobfuscated/` 4모듈)과 diff하여 변경/신규 함수만 타겟 디옵(전체 재디옵 회피).
- 산출: `drift-audit/deob-diff-modules.md` (신규/변경 함수 file:line 인덱스).

### Phase R1 — 런타임 추출(추론 > 실측) [예상 산출]
- `raw/widget_monitor/local` 테스트베드 구동(server.js :3001, cookies/token 갱신) → 위젯 마운트 후 **4(5)스토어 라이브 추출**(config/product/order/exterior/acc-order)으로 신규 옵션 스키마 실측.
- 신규 기능 보유 대표 상품(접지/귀돌이/걸이형/글꼴) product_info 라이브 캡처 → option-schema-catalog 보강.
- 산출: 신규 상품군 캡처 → `captures/` 추가, `option-schema-catalog.json` 갱신.

### Phase R2 — 신규 계약 정밀화 [예상 산출]
- **Garage 업로더 플로우**: `/api/garage/presigned` 라이브 캡처(GET 발급→PUT, 비밀 REDACTED) → `s3-upload-flow.md`에 Garage 경로 추가(S3와 병기).
- **신규 가격 필드 14종**: 접지/포장/연수/추가색상 옵션 조합 가격 sweep → `price-engine-reversed.md` 필드사전·역산 규칙 갱신.
- 산출: `s3-upload-flow.md`(Garage 추가), `price-engine-reversed.md`(신규 필드).

### Phase R3 — 환각 가드 + 검증 [원칙]
- 모든 디옵 주장은 file:line(deob) + 런타임 상태 + 캡처 응답으로 execution-validate(CASCADE).
- §22 V-PRICE/V-WIDGET/V-EDITOR 게이트 + codex-cli 독립 2차로 신규 필드/플로우 교차.
- gaps-resolved.md 갱신: 6월 기준 잔존 미검증 재분류.

---

## 7. 미취득/리스크

| 항목 | 사유 |
|------|------|
| widget.css 정밀 분석 | 본 단계는 size/date 드리프트만 확인. 신규 셀렉터/Shadow DOM 스타일 영향은 R0에서 |
| Garage 업로더 런타임 페이로드 | 라이브 구동 미수행(계획 R2). 현재는 문자열 식별만 |
| 신규 가격필드 실측값 | 조합 sweep 미수행(계획 R2). 현재 필드명 식별만 |
| sourcemap | 라이브에 부재 확정 — 복구 불가(AST로 폴백) |
