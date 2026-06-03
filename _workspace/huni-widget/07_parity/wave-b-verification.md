# wave-b-verification.md — Wave-B 독립 재검증 (L-3b / L-1 속성칩 / C-A)

> 검증자: hw-qa. 일시: 2026-06-03. 입력: wave-a-verification.md(§6 C-A 내가 플래그), major-capture-note.md, parity-matrix-D1/D4, Red 소스 mod_05_app_api.js.
> **원칙: 빌더 자가보고 미신뢰.** 증거는 내가 직접 수집(Red 소스 정독 + diff·fixture 추출 + 독립 vite-node probe + 게이트 재현). 기준 = 책임/로직/분기 재현 동등.
> INV-3 의도적 RELAX(구조결함). 최소·additive 판정 포함.

---

## 0. 한 줄 결론

**Wave-B 3항목 전부 RESOLVED**(독립 증거). tsc 0 / vitest **123/123** / build OK 내 눈으로 확인. **C-A(내가 Wave-A에서 플래그한 silent no-op) 진짜 해소 + 과잉 disable 없음**(독립 probe 양방향 입증). **L-3b 반경 fabrication 없음**(GSCDPOP-only를 Red 소스에서 직접 확인, 미등록=고정 '4'). **L-1 2-shape 구분 진짜**(FOI 그리드 / RIN_DFT ATTB_CD echo). INV-3 최소·additive(Wave-B는 신규 contract 0 — 기존 attb 슬롯 재사용). → **Wave-C GO. 신규 concern 0.**

---

## 1. 항목별 독립 판정

### L-3b ROU_DFT 반경 번들상수 이식 — **RESOLVED, fabrication 0**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **GSCDPOP-only 소스 확인** | `docs/reversing/.../mod_05_app_api.js:1668` 직접 정독 | `Yr = { GSCDPOP: { factor:"size", value:{1:"3",2:"6"} } }` — **GSCDPOP 단일 엔트리 확정**. 빌더 ingest(`ROUNDING_CONFIG_MAP`)가 이와 byte 일치 |
| **fabrication 없음** | component-type-map roundingRadius 로직 정독 + probe | 미등록 상품(BCFOXXX/BCSPDFT) → `ROUNDING_DEFAULT_RADIUS='4'`(Red 4/6mm 고정 라디오 default와 일치, mod_07:3320). off-grid DIV_SEQ(99) → '4'. **반경 날조 0** — size-linked는 GSCDPOP만, 나머지 전부 고정 '4' |
| **단위 테스트 실재** | parity-wave-b.test.ts:27-38 정독 | `ROUNDING_CONFIG_MAP.GSCDPOP` 정확값, `roundingRadius('GSCDPOP',1)='3'/,2='6'`, 미등록='4' 단언 — 타우톨로지 아님 |
| **ATTB 슬롯 흐름(독립 probe)** | vite-node BCFOXXX | ROU multiple=true, 4귀 value.attb 전부 '4', **직렬화 PCS_INFO ROU 엔트리 ATTB="4"**(이전 빈 슬롯 해소). size-linked 상품은 fixture 부재라 고정 '4'로 검증(major-capture-note §2: 반경은 번들상수 의존, 캡처 불가 — slot 유지 정당) |

### L-1 속성칩 2-shape — **RESOLVED, 강제경로 아님**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **2-shape 진짜 구분** | red-adapter mapPcsGroups 정독 | `attbCd = it.ATTB_CD ?? undefined; attb = rouRadius ?? attbCd ?? undefined`. (a) FOI 박(ATTB_CD 부재) → attb undefined, PCS_DTL_COD가 선택축. (b) RIN_DFT(ATTB_CD='RIN_SLV') → attb='RIN_SLV'. **두 경로 분기, 하나로 강제 안 함** |
| **shape(b) 직렬화(독립 probe)** | vite-node HLCLWAL | RIN_DFT value.attb='RIN_SLV' → **serialized ATTB="RIN_SLV"**(이전 빈→오산 해소). 테스트 84-94 동일 단언 |
| **shape(a) FOI** | 테스트 63-82 정독 | FOI_GDG finish-button(color-chip 아님), TFGGS/TFGGD detail, attb undefined, 직렬화 ATTB='' (선택그리드 정상) |
| **fixture +30 진짜 semantic add** | `git diff --ignore-all-space` HLCLWAL | 702줄 diff는 들여쓰기 churn(2→1 space), **--ignore-all-space로도 +30 = RIN_DFT PCS 엔트리(ATTB_CD:RIN_SLV/ATTB_NM:은색) 실 추가**. 빌더 whitespace-churn 주장 사실 |

### C-A 합성 disable 미스매치 보정 (내가 Wave-A서 플래그한 부채) — **RESOLVED + 과잉 disable 0**

| 검증(독립 probe, PRBKYPR) | 결과 |
|---------------------------|------|
| **silent no-op 해소(핵심)** | trigger=RXOMO080 선택 → `PCS_COT_DFT__coating` **all-disabled=true**, `__side` all-disabled=true, **선택 coating 자동 해제=true**. 이전(C-A 버그): group-id 미스매치로 disable 안 됨 → 이제 base-id 매칭(`compositeBaseId`/`groupDisabledBy`)으로 합성 분해 그룹까지 disable. **no-op 사라짐** |
| **과잉 disable 없음(CRITICAL)** | non-trigger=RXART300 선택 → `__coating` **some-active=true, all-disabled=false, 선택 유지=true**. 트리거 아닌 자재는 코팅 안 막음 — **material-scoped 불변 유지** |
| **scope 정확** | trigger 시 `PCS_CUT_DFT`(비합성) **unaffected=true** — COT 룰이 다른 그룹 오염 안 함(base-match가 compositeBaseId 없는 그룹엔 direct-only) |
| 테스트 진정성 | parity-wave-b.test.ts:100-132 — 트리거→disable+deselect 단언 + 비트리거→일부활성(과잉 disable 회귀 0) 단언. 양방향 |

→ **내가 플래그한 정확한 결함이 정확히 닫혔다**: base-id 매칭으로 `PCS_COT_DFT` 룰이 `__coating`/`__side`에 적용. 그리고 우려했던 과잉 disable 회귀는 독립 probe로 없음 확인.

---

## 2. C-A 특별 정밀 (요구사항: no-op 해소 AND 과잉 disable 0)

**우려:** base-id 매칭이 너무 넓게 잡아 비-트리거 자재에서도 코팅을 막거나, 합성 아닌 그룹을 오염시킬 위험.

내가 직접 vite-node probe 3종:
1. **no-op 해소**: RXOMO080(트리거) → __coating/__side 전 값 disable + 선택해제 ✅
2. **과잉 disable 0**: RXART300(비트리거) → __coating 일부 활성·선택 유지 ✅ (`groupDisabledBy`는 `activeGroupDisable` 집합에 base가 있을 때만 true — 트리거 자재만 그 집합 채움. 비트리거는 빈 집합 → false)
3. **scope 격리**: CUT_DFT(비합성) → `compositeBaseId` undefined라 direct-match만 → COT 룰 영향 0 ✅

**구조 분석:** `groupDisabledBy(gid, set)` = `set.has(gid) || (compositeBaseId(gid) && set.has(base))`. 합성 그룹만 base 확장, 그 외는 기존 direct-match 그대로. 따라서 (a) 합성 그룹은 base 룰로 disable 받고, (b) 비합성 그룹은 무변경, (c) set 자체가 트리거 자재로만 채워지므로 material-scope 유지. **과잉 disable 구조적으로 불가.**

---

## 3. INV-3 RELAX 최소·additive — **PASS**

| 영역 | Wave-B 변경 | 판정 |
|------|------------|------|
| **contract** | **신규 0** — L-3b 반경은 기존 `OptionValue.attb?`(BLOCKER 슬롯), L-1 ATTB_CD도 동일 attb 슬롯, RedPriceReqOrdInfo ATTB도 기존. itemGroup?/VisibilityRule/OrderReadiness는 Wave-A 것 | **재사용 — Wave-B 신규 contract 0** |
| **cascade.ts** | C-A: `COMPOSITE_SUFFIXES`+`compositeBaseId`+`groupDisabledBy` 헬퍼 + 3 call-site swap = **~+23줄** | **최소·정당** — 헬퍼 격리, 기존 disable 로직은 매칭함수만 교체(로직 불변) |
| **신규 leaf** | **0** (L-3a MultiCheckGroup은 Wave-A) | D4 가드 준수 |
| **신규 ComponentType** | **0** | dispatcher 무변경 |
| **adapters/red** | component-type-map(ROUNDING 상수+roundingRadius), red-adapter(attb/rouRadius 주입) — 어댑터 데이터 이식 | 어댑터 책임 |

- **scope-creep 0**: Wave-B 3항목에 정확히 한정. Wave-C(의류/ACC) 미손댐.
- cascade.ts C-A +23은 매칭함수 추상화(direct→base-aware)로 기존 disable 로직 자체는 불변 — 회귀면 최소.

---

## 4. 게이트 재현 (내가 직접 실행)

```
cd 04_build
npx tsc --noEmit  → tsc_rc=0
npx vitest run    → Test Files 15 passed, Tests 123 passed (114→123, +9 Wave-B 회귀가드)
npx vite build    → build_rc=0, dist/widget.js 831KB (Wave-A 830KB +1KB: L-3b/L-1 데이터만, 신규 컴포넌트 0)
```
`test/parity-wave-b.test.ts` 9케이스 정독: L-3b(상수맵 정확값+roundingRadius 분기+ROU ATTB 직렬화) 4 / L-1(FOI 그리드+RIN_DFT ATTB_CD echo) 3 / C-A(트리거 disable+비트리거 과잉방지) 2. **전부 실 소스값(GSCDPOP)·실 fixture(HLCLWAL RIN_SLV)·실 cascade 대조 — 타우톨로지 아님.**

---

## 5. 최종 Wave-B 판정

## **GO (Wave-C 진행 가능)**

- **RESOLVED 3 / PARTIAL 0 / NOT-RESOLVED 0**.
- **C-A 확인**: 내가 Wave-A서 플래그한 silent no-op이 base-id 매칭으로 정확히 닫혔고, 우려했던 과잉 disable 회귀는 독립 probe로 없음 입증(material-scope 불변 유지).
- **L-3b**: GSCDPOP-only를 Red 소스에서 직접 확인, 미등록 상품 고정 '4' — **반경 fabrication 0**.
- **L-1**: FOI 선택그리드 / RIN_DFT ATTB_CD echo **2-shape 진짜 구분**(강제경로 아님), RIN_SLV 직렬화 ATTB 채워짐(이전 오산 해소).
- **INV-3 최소·additive**: Wave-B 신규 contract 0(기존 슬롯 재사용), cascade C-A +23 격리, 신규 leaf/ComponentType 0, scope-creep 0.
- **신규 concern 0.** Wave-A에서 넘긴 부채(C-A)가 Wave-B에서 닫힘 — 잔여 부채 없음.

**검증 통찰(회의적):** Wave-B는 빌더 주장(123테스트·GSCDPOP-only·2-shape·C-A 수정)이 전부 사실이며, 가장 중요한 C-A는 **내가 직접 양방향 probe(해소 + 과잉방지)로 확인**해 위양성·위음성 모두 배제했다. L-3b는 Red 소스를 직접 열어 GSCDPOP가 유일 엔트리임을 확인해 fabrication 가능성을 원천 차단했다. Wave-C(의류 30 + ACC) 진행 가능 — 단 그것은 후니 day-1 판매 확정이 선결(플랜 §6).
