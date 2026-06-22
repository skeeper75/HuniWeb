# R3 — 환각 가드 (execution-validate + codex 2차) 산출

> 재역공학 강화 2단계 R3. R0~R2 주장을 file:line + 런타임 + 캡처로 execution-validate(CASCADE).
> codex high 독립 2차 교차(읽기전용). codex 주장=가설(확증 전 사실 아님). G-1 날조 선례 경계.

---

## 1. Execution-validate (CASCADE) — 주장↔근거 재측정 [검증 완료]

| # | 주장 | 검증 방법 | 근거 | 결과 |
|---|------|----------|------|------|
| EV1 | GarageUploader 컴포넌트 존재 | deob 재읽기 | widget.deob.js L18233 `__name:"GarageUploader"` | ✅ PASS |
| EV2 | Garage→AWS 폴백 | deob 재읽기 | L18307(garage) / L18309(aws fallback) | ✅ PASS |
| EV3 | s3_region GA/AWS 판별 | deob 재읽기 | L18272 `s3_region: m ? "AWS" : "GA"` | ✅ PASS |
| EV4 | upload emit = 배열 `[{gbn:"I",…}]` | deob 재읽기 | L18274 `o("upload", [N])` (object N=L18266-18273) | ✅ PASS (배열형 확정) |
| EV5 | ADD_CLR_YN/PACK_PRN_CNT ORD_INFO | deob 재읽기 | L13982 / L13984 | ✅ PASS |
| EV6 | jn/is API base | deob 재읽기 | L12292 / L12294 | ✅ PASS |
| EV7 | get_fld_download / get_basicKalSize | deob 재읽기 | L12466 / L12444 | ✅ PASS |
| EV8 | 캐스케이드 FLD_DFT/LAM_DFT | deob 재읽기 | L14424 / L14426 | ✅ PASS |
| EV9 | 수량래더 PRN=MIN+ADD·h | deob 재읽기 | L15438-15439 | ✅ PASS |
| EV10 | item_gbn offset2023/edicus/digital | 라이브 product_info | new-feature-products-probe.json | ✅ PASS (라이브) |
| EV11 | isUseGarage="Y" 활성 | 라이브 product_info | product_NCCDDFT.json | ✅ PASS (라이브) |
| EV12 | Garage presigned 발급+PUT 200 | 라이브 호출 | garage-presigned-sample.json + PUT status 200 | ✅ PASS (라이브 e2e) |
| EV13 | 신규 후가공 라이브 노출(FLD/HOL/ROU) | 라이브 product_info | pdt_pcs_info | ✅ PASS (라이브) |
| EV14 | 캐스케이드 disable 라이브 | 라이브 product_info | pdt_disable_pcs_info 25건 | ✅ PASS (라이브) |
| EV15 | PRICE≠0 + 메타모픽(qty↑, +접지) | 라이브 price | price-metamorphic-NCCDDFT.json | ✅ PASS (라이브) |
| EV16 | postPcs 29→49 신규20·제거0 | 4월 vs 6월 diff | 1단계 drift-audit | ✅ PASS |
| EV17 | Pinia store 라이브 state 덤프 | headless getStoreSnapshot | store-snapshot(null) | ⚠ 미확정(헤드리스 한계) |
| EV18 | SDK sizing.type 런타임 | (위젯 미참조·에디터 미구동) | 1단계 정적 diff만 | ⚠ 미확정(정적만) |

**Execution-validate 통과율: 16/18 PASS (89%), 2 미확정(정직 표기·은폐 없음).**
미확정 2건 모두 비차단: EV17은 product_info가 store 원천이라 대체검증됨, EV18은 widget 비사용 파라미터.

---

## 2. codex high 독립 2차 reconcile [완료]

- 실행: `codex-review.sh codex-prompt.txt gpt-5.5 redo-260623 high` (읽기전용, 토큰 180,497).
- codex가 deob 파일을 독립적으로 재탐색해 line 번호 재도출.

| claim | codex verdict | Claude(나) | reconcile |
|-------|--------------|-----------|-----------|
| 1 GarageUploader | AGREE (L18232-18233) | PASS | **합의** |
| 2 Garage→AWS 폴백 | AGREE (L18306-18309) | PASS | **합의** |
| 3 s3_region GA/AWS | AGREE (L18264-18272) | PASS | **합의** |
| 4 emit payload shape | AGREE + caveat: 실제 `o("upload",[N])` **배열** | PASS(배열로 기재) | **합의**(caveat=내 R2 §1.2/contracts와 동일=배열) |
| 5 ADD_CLR_YN/PACK_PRN_CNT | AGREE (L13978-13985) | PASS | **합의** |
| 6 jn/is base | AGREE (L12292/12294) | PASS | **합의** |
| 7 get_fld_download/basicKalSize | AGREE (L12457-12466/12438-12445) | PASS | **합의** |
| 8 캐스케이드 | AGREE (L14424/14426) | PASS | **합의** |
| 9 수량래더 | AGREE (L15432-15439) | PASS | **합의** |
| 10 breaking change 없음 | **CANNOT-CONFIRM**(단일파일선 history diff 불가) + "no breaking evidence·additive-only로 보임" | PASS(1단계 4월vs6월 diff로 제거0 입증) | **부분합의**: codex는 단일파일 스코프라 baseline 미보유 → 보수적 CANNOT-CONFIRM. 내 판정은 **1단계 실제 4월-6월 byte diff 근거**(codex 미접근 자료)로 "additive-only·제거0" 유지. codex도 정성적으로 동의. |

### reconcile 결론
- **합의 9/10**(정량 라인근거 전건 일치). 환각 0 — codex가 내 9개 line 주장을 독립 확증.
- **불일치 0**. claim 10은 "불일치"가 아니라 codex의 스코프 제약(baseline 부재)에 따른 보수 verdict이며, 1단계 diff로 보강 확정.
- claim 4 codex caveat(배열형)는 내 산출물(R2/contracts)과 이미 동일 → 추가 정정 불요.

---

## 3. codex 가설 처리 [원칙 준수]
- codex 주장은 모두 deob file:line 재읽기로 확증된 것만 채택(가설→사실 승격은 EV 재측정 통과분).
- codex의 claim10 "추정"은 사실로 채택하지 않고, 1단계 실측 diff(권위)로 대체 확정.

## 4. 미확정/리스크 (은폐 금지)
| 항목 | 상태 | 비차단 사유 |
|------|------|------------|
| Pinia store 라이브 state 덤프 | 미확정(헤드리스 한계) | product_info=store 원천·4월 5스토어 구조 유효 |
| SDK sizing.type 런타임 | 미확정(정적만) | widget 미참조·후니 어댑터서 흡수 |
| ADD_CLR_YN/PACK_PRN_CNT 정확 가격함수 | 미확정 | 엔진 수용·존재 확정, 가격함수는 후니 자체 엔진(이식 금지) |
| acrylic2025/clothes2025 라이브 프로브 | 미확정(코드근거만) | 대표 offset/book/edicus/digital 커버 |
| breaking-change 절대부재 | 매우 낮은 리스크 | 1단계 diff 제거0·rename 미발견·codex 정성동의 |
