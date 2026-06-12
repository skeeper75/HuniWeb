# sticker W-gate verdict — CONDITIONAL-GO (2026-06-12)

> 검증자 = pkw-wiki-qa(독립·생성자≠검증자). 대상 = `recipes/sticker.md`(19 원자블록 + §7.1 양면표 9행).
> 스탠스: 인용·앵커가 실측으로 확인될 때까지 틀렸다고 가정. 모든 FAIL은 (블록 인용)+(재현 가능한 반대 증거) 쌍 보유.
> 라이브 read-only psql 실측 성공(db railway·비표준 포트·비밀값 비노출).

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (의미 대조 전건 일치·G-1/F-PB-1형 날조 0) |
| W2 링크 무결성 | FAIL(Low) | 3 (BROKEN-LINK — 전부 sticker 내부 앵커) |
| W3 스키마 앵커 | FAIL(Low) | 1 (SCHEMA-MISMATCH — `mat_typ` 컬럼명) |
| W4 badge 정합 | PASS | 0 (✅5 전건 C13 round-13 GO/라이브 실측 기반) |
| W5 stale/v03 차단 | PASS | 0 (v03=결함 진원 표기·인용 0·STALE 격리) |
| W6 CQ 커버리지 | PASS | 0 (15 unique answers_cq 전건 cq-registry 실재) |
| W7 index/log 일관성 | PASS | 0 (index 1줄·log 4엔트리·badge 분포 일치) |
| W8 실행가능성 | PASS | 0 (0정체→6적재 dry walk 전 단계 구체입력/축링크) |
| **코팅 CONFLICT(BATCH-3) 처리** | PASS | 0 (양면표기·단정 0) |

**종합 판정: CONDITIONAL-GO** — 치명(FABRICATED/SCHEMA-앵커부재/STALE/W8핵심) 0. 잔존은 Low 2종(W2 깨진 내부링크 3·W3 컬럼명 `mat_typ`→`mat_typ_cd`)뿐. writer 재호출용 보정 후 GO 승격.

---

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-STK-1 | sticker#STK-ID-001 line 21 | W2 | BROKEN-LINK | `[[STK-ST-002]]` — `#` 누락으로 페이지명 "STK-ST-002"로 파싱(그런 페이지 없음). 재현: 보정 linkcheck(recipes scope 포함) → `PAGE-MISSING:STK-ST-002`. 추가로 STK-ST-002는 §7.1 표 행일 뿐 `### [STK-ST-002]` 헤딩 부재 → `#` 붙여도 dead anchor. | §7.1 표 행 STK-ST-002를 `### [STK-ST-002]` 헤딩 블록으로 승격하고 링크를 `[[#STK-ST-002]]`로. 또는 카테고리 거침은 [[load-path#LP-GAP-3]]/축 참조로 대체. |
| F-STK-2 | sticker#STK-ID-002 line 29 | W2 | BROKEN-LINK | `[[STK-BOM-001]]` — `#` 누락. STK-BOM-001 헤딩은 실재(line 57)이므로 앵커 자체는 유효. 재현: 보정 linkcheck → `PAGE-MISSING:STK-BOM-001`. | `[[#STK-BOM-001]]`로 `#` 추가(1글자). |
| F-STK-3 | sticker#STK-DIM-002 line 49 | W2 | BROKEN-LINK | `[[#STK-ST-005]]` — STK-ST-005는 §7.1 표 행(line 175)으로만 존재, `### [STK-ST-005]` 헤딩/item-id 앵커 부재. 재현: `grep -nE '^#.*STK-ST-005' sticker.md` → 0. 보정 linkcheck → `ANCHOR-MISSING:sticker#STK-ST-005`. | STK-ST-005(조각수)를 §7.2에 `### [STK-ST-005]` 블록으로 승격(STK-ST-001/003/004/006 처럼)하거나, 링크를 표 행 대신 [[#STK-DIM-002]] 자기참조 제거·[[price-engine#PE-010]]만 유지. |
| F-STK-4 | sticker#STK-BOM-003 line 75·STK-ST-004 line 202·(앵커) | W3 | SCHEMA-MISMATCH | 앵커 `t_mat_materials.mat_typ` — 라이브 실측 컬럼명은 `mat_typ_cd`(`mat_typ` 부존재). 재현: `SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name='mat_typ'` → 0행; `...column_name='mat_typ_cd'` → 1행. 원천 correction-manifest C-ST-09는 `mat_typ_cd`로 정확 표기 → 위키가 축약하며 오기. (값 `MAT_TYPE.11/.01` 도메인 의미는 정합) | 앵커·본문의 `mat_typ`을 `mat_typ_cd`로 교정(STK-BOM-003·STK-ST-004 + 축 materials#MAT-003/MAT-005 동반 — 축 페이지도 동일 오기). |

> **참고(비-finding) — linkcheck.py 스코프 버그:** `_qa/scripts/linkcheck.py`의 `scope`/`all_pages`가 `recipes/*.md`를 미포함 → 축→레시피 역링크 전건(STK-/DGP-/BK-) `PAGE-MISSING:sticker` 등으로 **거짓 BROKEN 62건** 보고. 재현: 원본 실행 시 62, recipes 포함 보정 실행 시 3(전부 위 F-STK-1~3). **스크립트 자체 보정 권고**(scope에 recipes 추가) — 그러지 않으면 향후 레시피 게이트가 거짓 양성에 묻힘. orchestrator 에스컬레이션.

---

## 게이트별 근거

### W1 인용 실재성 (PASS) — 의미 대조
- 출처 19행 전건 파일 실재. 표본 의미 대조(존재 아닌 주장 일치):
  - STK-ID-001/002(16상품 PRD_000052~067·인쇄방식5분기·토너 PROC_000004·잉크젯 PROC_000006) ↔ product-identity §0 표·§1 정체표 **일치**.
  - STK-BOM-001(반칼 PROC_000054·스티커완칼 PROC_000055·도수별 커팅) ↔ product-identity §1 + gate K6(PROC_000054 모양 input 실측) **일치**.
  - STK-PRC-001(형상×치수×코팅 격자·505행·코팅=가격 컬럼축) ↔ live-crosscheck §5 line 72~76 **일치**.
  - STK-DIM-002(Q8 둘 다·066만 적재·prcs_dtl_opt.조각수 부재 OM-7) ↔ mapping-final L8(row25) **일치**.
  - §7.1 분포 CORRECT5·MIS-LOADED5·MISSING5·EXTRA1·AMBIGUOUS1=17 ↔ correction-manifest §2 **정확 일치**.
- 8상품 코팅 목록(052·058~062·064·066)·카테고리 재연결(052→030···067→046)·063 화이트 누락 ↔ manifest C-ST-04/02/07 **일치**.
- **G-1형(인용 라인 부존재)·F-PB-1형(공란을 MISSING으로 날조) 0** — gate K2가 이미 oracle 인용 날조 0 입증, 위키도 그 GO 산출만 인용.

### W2 링크 무결성 (FAIL Low) — race 손상 점검
- **sticker가 추가한 24 역링크 슬롯(축→sticker) 무손상:** processes/materials/price-engine/cpq-options/widget-contract/load-path의 `사용처:`에 박힌 [[recipes/sticker#STK-PRC-002/BOM-001/DIM-002/ST-001/ST-004/ST-006/LP-001/LP-002/WID-001/WID-002/CPQ-001/PRC-001 등]] **전건 실 헤딩 resolve**·중복/유실/digital-print·booklet 동시편집 손상 0(보정 linkcheck로 확인).
- **단 sticker 내부(forward) 링크 3건 깨짐**(F-STK-1~3) — 전부 페이지 자기참조 오타(`#` 누락·미존재 앵커). 축 그래프엔 영향 없음·Low.

### W3 스키마 앵커 (FAIL Low) — 라이브 information_schema 실측
- 인용 t_* 18테이블 전건 라이브 실재. 핵심 컬럼: `t_prc_price_components.prc_typ_cd`✅·`t_prc_component_prices(siz_cd,proc_cd,opt_cd)`✅·`t_prd_product_constraints.logic` NOT NULL✅(is_nullable=NO)·`t_prd_product_option_items.ref_dim_cd`✅·`t_prd_product_processes.mand_proc_yn`✅.
- 코드값 실재: PRD_TYPE.04(sticker 16상품 distinct)·MAT_000155 무광코팅스티커·MAT_000156 유광코팅스티커·MAT_000084 비코팅스티커·PROC_000013 코팅·PROC_000008 화이트·PROC_000054 반칼·PROC_000055 스티커완칼·PROC_000004 디지털·PROC_000006 실사 **전건 명칭까지 일치**. option_items 라이브 18행(CPQ-008 주장 정확).
- STALE 앵커 면제 정합: constraint_json·pricing_dims·use_dims·dep_proc_cd **라이브 0**(STALE 인용금지 주장 사실).
- **유일 불일치 = `mat_typ`(F-STK-4)** — 컬럼명 오기(라이브 `mat_typ_cd`). 테이블·도메인값은 정합이라 Low.

### W4 badge (PASS)
- ✅5(STK-ID-001/002·DIM-001·BOM-001/002) 전건 출처 tier C13(round-13 GO 산출 product-identity/correction-manifest CORRECT) + gate K6/라이브 실측 뒷받침. 🟡권장 문서 단독 ✅ 0 → BADGE-INFLATED 0.
- 역방향(권위인데 🔴) 과소 0.

### W5 stale/v03 (PASS)
- v03 언급 6곳 전부 (a) STALE 경고 헤더 (b) "load_master=v03 전파기 + [HARD] v03 입력 xlsx 인용 금지" (c) 결함 진원 출처 귀속 — **v03 xlsx를 데이터 권위로 인용한 `출처:` 0**.
- price-engine-ddl·constraint_json·dep_proc_cd 전부 [[PE-STALE]]/[[CPQ-STALE]]/[[LP-STALE]] 격리·"미인용" 명시. STALE-CITED 0.

### W6 CQ (PASS)
- answers_cq 15 unique(CQ-PROD-01/03/05/06/08·PRICE-01/05/08/10·PROC-01/05·FIN-02/03·FILE-05·TERM-04) → `_workspace/print-kb/cq-registry.md` 대조 **전건 실재**. 미존재 0.

### W7 index/log (PASS)
- index.md line 38 sticker 1줄 등재(🟡·round-13 GO·결함17, §7 분포 17과 일치).
- log.md INGEST/INDEX/LINK 4엔트리 append. log 기재 badge `✅5·🟡8·🔴4·⚪2` ↔ 실제 페이지 census **정확 일치**(19블록).

### W8 실행가능성 (PASS) — 신상품 1개 dry walk-through
- 0정체: t_prd_products(prd_typ_cd=PRD_TYPE.04·MES NULL 정책·use_yn·file_upload_yn) ✅구체.
- 1차원: 형상=칼틀 size→t_prd_product_sizes/t_siz_sizes(siz_nm 인코딩)·bundle_qtys ✅.
- 2 BOM: 커팅 PROC_000054(반칼)/055(완칼)·화이트 PROC_000008·자재 점착지 mat_cd+usage_cd(USAGE.07) ✅코드 명시.
- 3가격: t_prc_component_prices 형상×치수×코팅 격자·[[price-engine#PE-007]] 고정가형·판수=[[PE-010]] 앱계산(면제 표기 有) ✅.
- 4 CPQ: option_groups/items ref_dim_cd·트리거 fn_chk_opt_item_ref·미적재 known([[cpq-options#CPQ-008]]) ✅.
- 5위젯: 정규화 계약([[widget-contract#WID-001/002/003]]) — DB 외 앵커 면제 표기 有 ✅.
- 6적재: load_master 로직 oracle·FK 위상([[load-path#LP-003]])·search-before-mint·admin pvEdit([[LP-006]]) ✅.
- "다른 문서 봐야 알 수 있음"이 전부 [[축 링크]]로 해소 → NOT-EXECUTABLE 0.

### 코팅 CONFLICT(BATCH-3) 처리 (PASS)
- STK-ST-001·§7.1 표 STK-ST-001 모두 **라이브 자재(MAT_000155/156) ↔ 정답 공정(PROC_000013)** 양면 표기. "통일은 BATCH-3 컨펌 대기·위키는 양면 표기만·단정 금지" 명문(line 186). 한쪽 단정 0. STK-PRC-001도 "코팅이 가격 변수축 ↔ CONFLICT 얽힘" 정직 연결. **단정 finding 0.**

---

## 재현 (사용 명령 — 비밀값 제외)

```bash
# W2 — recipes 포함 보정 linkcheck(원본 스크립트는 recipes 미포함 → 62 거짓양성)
cd _workspace/print-kb/wiki && python3 - <<'PY'
# all_pages/scope에 glob("recipes/*.md") 추가 후 [[page#anchor]] resolve
# 결과: BROKEN 3 = STK-ST-002(no #)·STK-BOM-001(no #)·#STK-ST-005(no heading)
PY

# W3 — 라이브 스키마 실측
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc \
  "SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name IN ('mat_typ','mat_typ_cd');"
#   → mat_typ_cd (mat_typ 부존재)
PGPASSWORD=... psql ... -tAc "SELECT count(*) FROM t_prd_product_option_items;"  # → 18
PGPASSWORD=... psql ... -tAc "SELECT proc_cd,proc_nm FROM t_proc_processes WHERE proc_cd IN ('PROC_000008','PROC_000013','PROC_000054','PROC_000055');"
PGPASSWORD=... psql ... -tAc "SELECT mat_cd,mat_nm FROM t_mat_materials WHERE mat_cd IN ('MAT_000084','MAT_000155','MAT_000156');"

# W6 — answers_cq 대조
grep -ohE 'CQ-[A-Z]+-[0-9]+' recipes/sticker.md | sort -u  # 15 → 전건 ../../cq-registry.md 실재
```

---

## orchestrator 요약
- **verdict: CONDITIONAL-GO** (치명 0·Low 2종 4 finding).
- 분류별: BROKEN-LINK 3(W2·전부 페이지 내부 오타)·SCHEMA-MISMATCH 1(W3·`mat_typ`→`mat_typ_cd` 컬럼명).
- 날조(FABRICATED) 0·STALE-CITED 0·W8 핵심 FAIL 0·코팅 CONFLICT 단정 0.
- 보정 후 GO 승격(writer 재호출 4건: `#` 2건·앵커 승격 1건·컬럼명 교정 1건+축 동반).
- **에스컬레이션: `_qa/scripts/linkcheck.py` 스코프 버그**(recipes 미포함 → 향후 전 레시피 게이트 거짓양성). orchestrator가 스크립트 보정 결정 필요.

---

## 재측정 (2026-06-12 · 보정 검증 · pkw-wiki-qa)

> 1차 CONDITIONAL-GO Low 4건(F-STK-1~4) writer 보정 완료 신고 → 재측정.

| finding | 1차 분류 | 보정 검증 결과 |
|---|---|---|
| F-STK-1 | BROKEN-LINK | **RESOLVED** — `[[STK-ST-002]]`(dead) → `[[load-path#LP-GAP-3]]`(카테고리 고아 재연결 미적재)로 대체. linkcheck BROKEN 0. |
| F-STK-2 | BROKEN-LINK | **RESOLVED** — `[[#STK-BOM-001]]`(`#` 추가). STK-BOM-001 헤딩 line 57 실재 resolve. |
| F-STK-3 | BROKEN-LINK | **RESOLVED** — STK-ST-005(조각수)를 §7.2에 `### [STK-ST-005]` 헤딩 블록으로 승격(line 207, badge 🔴 교정대기). `[[#STK-ST-005]]` resolve. 출처 correction-manifest C-ST-05 보유 = 날조 0(승격 블록 출처 검증). |
| F-STK-4 | SCHEMA-MISMATCH | **RESOLVED** — STK-BOM-003·STK-ST-004 앵커 `mat_typ`→`mat_typ_cd`(line 75·202). 라이브 `information_schema` → `mat_typ` 부존재·`mat_typ_cd` 실재 확인. 값 .11/.01 정합 유지. |

**회귀:**
- W2: linkcheck.py 전체 → **BROKEN 0**(sticker 깨진링크 3 → 0).
- W7 badge census: STK-ST-005 헤딩 승격으로 🔴 4→5. 현 census `✅5·🟡8·🔴5·⚪2`(19블록). **단 log.md/index 기재 badge는 보정 전 `✅5·🟡8·🔴4·⚪2`로 1건 stale** → 아래 잔존 finding F-STK-5(Low/W7).
- W1/W5: 승격 STK-ST-005 출처(C-ST-05) 실재·의미 일치. 날조·stale 전파 0.

## 재측정 잔존 Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거 | 보정 제안 |
|---|---|---|---|---|---|
| F-STK-5 | log.md sticker INGEST/FIX 행 · index 무영향 | W7 | BADGE-COUNT(Low) | F-STK-3 승격으로 페이지 🔴 4→5(census 확인). log 기재 `✅5·🟡8·🔴4·⚪2`는 보정 전 카운트라 🔴 1건 과소. index line 38은 분포 카운트 미기재(영향 없음). | log sticker FIX 행에 badge `🔴4→🔴5`(STK-ST-005 헤딩 승격분) 1줄 정정. 치명 아님·재판정 차단 사유 아님. |

**재판정: GO(잔존 Low 1 — F-STK-5 log badge 카운트).** 4 finding 전건 RESOLVED·치명 0. F-STK-5는 승격 보정의 산물(부수효과)·자명 정정.
