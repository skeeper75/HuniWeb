# deob_07 의미부여·포팅 실현가능성 — 독립 검증 판정 (회의론 게이트)

> 검증자: rcd-equivalence-verifier 자세(생성자 주장 비신뢰·직접 재실측).
> 입력 프로브: `deob07-feasibility-empirical.md`(전이 74%·컨텍스트명명 16.6%·render 38.7%·종합 上),
>           `deob07-feasibility-method.md`(포팅 의미전달 中·render ~21%·"절단 파싱 불가").
> 재실측 대상: `03_deobfuscated/deob_07_app_components.full.js`(5,580줄),
>           v1 = `git HEAD:05_readable/02_readable/deob_07_app_components.js`(4,865줄, `/tmp/v1_deob07.js`로 추출).
> 도구: 기존 `_feas_*.cjs` 재실행 + 검증자 자작 `_vrf_handcheck.cjs · _vrf_handcheck2.cjs · _vrf_render.cjs`(전부 `_tooling/`, 재현 가능).
> 환경: `RCD_NM=…/_tooling/node_modules` NODE_PATH prefix·읽기전용.

---

## 0. 한 줄 판정

**실현가능성 = 중상(中上). 두 프로브의 골격은 옳다(공유 컴포넌트 정렬 전이는 실제로 건전·render는 명명대상 아님). 그러나 핵심 낙관 두 개는 깎아야 한다: ① "컨텍스트 명명 16.6%(268 바인딩)"는 재선언 temp를 셈해 ~2.2배 부풀린 수치 — 진짜 의미부여 단위는 ~123개. ② "render 38.7%"는 호출토큰 비율일 뿐 줄/함수 footprint는 6.5%(과대 프레이밍). 또한 method.md의 "full.js 정식 파싱 불가" 주장은 거짓(errorRecovery 없이도 errors=0으로 파싱됨).** 권고 = **PARTIAL-SETUP-ONLY**(setup 로직 한정·공유→자동/꼬리→반자동/머리→선별 수작업).

---

## 1. 회의론 재확인 — 프로브 수치 직접 재측정

| 프로브 주장 | 재실측 결과 | 판정 |
|---|---|---|
| 총 바인딩 1,745 / 단문자 1,613 / 도메인 132 | `_feas_scan` 재실행 = **1745 / 1613 / 132 동일** | ✅ 정확 |
| 공유 20컴포넌트 = full ∩ v1, v1-only=0 | 직접 `__name` 집합 비교 = full **56**, v1 **20**, 공유 **20**, v1-only **0** | ✅ 정확(full=58 주장은 56로 소폭 과다, 무해) |
| v1은 full의 부분집합(머리 절단+꼬리 미전개) | V1-ONLY=0 실증 | ✅ 정확 — 프롬프트 "절단 머리만 빠짐" 가정 정정은 **타당** |
| 10공유 컴포넌트 setup 바인딩 **187/187(100%) 정렬 전이** | `_feas_align` 재실행 = **187/187 동일** | ✅ 재현됨(단 §2 단서) |
| 컨텍스트 명명 가능 ≈ **16.6%(268)** | 재측정: 268은 **선언 수**, 재선언 temp 포함 → 진짜 nameable 단위 **~123** | ⚠️ **과대(~2.2x) — 깎음** |
| render 함수 비중 ≈ **38.7%** | 호출토큰 = 49.3%(별칭 더 넣으면), **줄 footprint = 6.5%**, ref-occurrence = 9.6% | ⚠️ **프레이밍 오류 — 호출비율을 "함수 비중"으로 호도** |
| (method) full.js **정식 파싱 불가**·recovered.js 필수 | strict 파싱(errorRecovery 끔) = **errors 0·OK**, `node --check` exit 0 | ❌ **거짓** |

---

## 2. ★정렬 전이의 건전성 — 손 검증(프로브가 안 한 것)

`_feas_align`은 **선언 위치 인덱스로 1:1 매칭**만 한다. "100%"가 매칭이 *성립*한다는 뜻인지, *올바른 의미명*을 주는지는 별개다. 검증자가 init 식 본문을 양쪽에서 직접 떠서 **구조 시그니처 동등성**으로 확인(`_vrf_handcheck2.cjs`):

```
Apparel(30) Book(18) BookQty(25) DosuColor(9) PantoneChipModal(11)
CoverGuide(16) ApparelSizeGbn(4) ApparelMultiSizeQty(15) Acc(33) CLD_STD(4)
=> init-구조 동일 155/165 (93.9%)
```

- 동일 155건: full `a=R(()=>n.options.all.length>n.options.dosu.length)` ↔ v1 `showColorSelect=computed(()=>componentProps.options.all.length>componentProps.options.dosu.length)` — **위치정렬이 올바른 의미명을 준다(실증)**.
- 불일치 10건(CoverGuide 3·MultiSizeQty 2·Acc 5)을 **육안 재검** → **전부 올바른 짝**이었다. 불일치는 v1이 가독화 과정에서 삼항 전개·헬퍼 인라인·구조분해 재작성을 한 **양성 편차**일 뿐(예 `U=I[w]||0` ↔ `oldPrice=oldPrices[mtrlCd]||0`). 즉 **정렬 전이 자체는 misalign 0건 = 건전.**

**단, 부수 발견(프로브 누락):** v1은 full의 **순수 리네임이 아니다.** 같은 컴포넌트 AST 노드 수가 다르다(Apparel full 1501 ↔ v1 1524, Acc 1748 ↔ 1782). v1엔 구조 편집(삼항 전개·인라인·포맷)이 섞여 있다. 함의 = ① 전이는 **이름 전이**로 유효하나, ② v1을 verifier G2(원본↔결과 **AST 구조 동등**) 오라클로 그대로 쓰면 FAIL난다. 향후 자동 전이의 정답지는 "v1 이름맵"이지 "v1 AST"가 아니다.

---

## 3. ★컨텍스트 명명 16.6% 깎기 — temp 부풀림 적발

머리 6컴포넌트(Acrylic·AcrylicPrintData·Chevron·DesignQty·Digital·Method)를 재귀속(`_vrf` 측정):

```
Acrylic          선언 108  distinct 23  scopes 51
AcrylicPrintData 선언  23  distinct 17  scopes  7
Chevron          선언   3  distinct  3  scopes  2
DesignQty        선언  47  distinct 29  scopes 19
Digital          선언  66  distinct 36  scopes 33
Method           선언  21  distinct 15  scopes  7
─────────────────────────────────────────────
TOTAL            선언 268  distinct 123
재선언(shadowed temp) 선언 = 179 / 268 (67%)
```

- 프로브의 "268 바인딩(16.6%)"은 **선언 수**다. Acrylic은 **51개 스코프에 흩어진 108 선언이지만 distinct 이름은 23**개 — `C`,`y`,`_`,`I` 같은 글자가 콜백마다 임시 재선언된다(DesignQty 본문 실견: `C=`가 5회, `y=`가 3회 재선언).
- **진짜 의미부여 단위 ≈ 123**(distinct), 그 중에서도 구조/도메인 근거 강한 것(props/emit/inject/store/도메인코드 init) ~1/3, 나머지는 컨텍스트 추론. temp 67%는 **의미명 불요**(generic `idx`/`tmp`/`item` 또는 면제 — method.md §5.2의 "render 콜백 temp 면제" 원칙과 동일하게 처리).
- 따라서 **conf 0.87 평균은 호도**: 36 샘플이 구조/도메인 쉬운 케이스로 편향(weak 2건만 인정). 모집단은 2/3가 throwaway라 "평균 conf"라는 지표 자체가 부적절. 정직한 진술 = **"머리에서 의미 있는 명명 대상은 ~123, 그 중 강근거 ~40·중근거 ~50·면제(temp) 다수."**

---

## 4. ★render "비중" 정정 — 호출토큰 ≠ 함수 footprint

`_vrf_render.cjs` 3지표 동시 측정:

| 지표 | 값 | 의미 |
|---|---|---|
| render-헬퍼 **호출** 비율 | 1239/2515 = **49.3%** | 호출부의 절반이 g/V/M/S… (프로브 38.7%는 별칭 9개만 셈) |
| render-헬퍼 **ref-occurrence** 비율 | 1294/13543 = **9.6%** | 전체 식별자 노드 중 (method "~21%"는 분모를 ref 6,065로 잡음 — 둘 다 성립하나 분모 명시 필요) |
| render **줄** footprint | 365/5581 = **6.5%** | setup-return render arrow가 점유한 줄 |

- **줄 footprint 6.5%**가 낮은 이유: 58 setup 중 단순 `return (g(),…)` arrow로 잡힌 건 **10개뿐**. 나머지는 `Be(re({…}))` 래핑·컴파일 패턴이라 render가 별도 형태로 인라인 → region 스크립트가 못 잡음. 즉 "render가 줄의 38.7%"는 **명백한 오류**(호출토큰을 줄/함수 비중으로 호도). 정정: **render는 호출부를 지배하지만(≈49%) 줄 footprint는 작다(≈6.5%, 단 미검출분 감안 보수적으로 ~10–20% 가능).**
- **그러나 결론(render는 명명 대상 아님)은 양쪽 프로브 다 옳다.** render 트리는 ① 헬퍼 별칭(Rosetta 65로 전역 처리) ② 이미 명명된 setup 바인딩 참조 ③ 정적 리터럴뿐 — **새 명명 대상 식별자를 거의 도입 안 함.** 포팅 시 `<template>` 재작성이 정답(template→render 단방향·비가역)이라는 method §4 판단은 타당.

---

## 5. 포팅 목적 — "의미 전달" 어디까지 가능한가 (정직한 경계)

method.md §2의 "변수명 ≠ 포팅 충분(타입·의도주석·DTO·외부의존 동반 필요)"는 **전적으로 타당**하며 검증자도 동의. 추가 검증으로 확인한 경계:

- **가능(가치 高):** 공유 20컴포넌트의 **setup 로직**(props/emit/inject·computed·watch·이벤트핸들러·도메인 규칙) — 이름은 v1 전이로 자동, 의미는 init 식+도메인코드(PDT_CD·DFT_PRN_CNT·QUICK_ORD_YN…)가 자증. 포팅 대상 언어로 **상태/규칙 모델 추출 충분**.
- **반자동(가치 中):** 꼬리 30컴포넌트 — v1 한국어 라벨(COT_DFT=코팅 등)이 컴포넌트 의미는 고정하나 내부 바인딩은 §3 방식 개별 명명. 정답지 없음.
- **선별 수작업(가치 中, 부풀림 주의):** 머리 6컴포넌트 distinct ~123 — 구조/도메인 근거분만 명명, temp 면제.
- **불가/저효율(재작성 영역):** render 트리(template 복원 비가역), free-ref(슬라이스에 선언 없어 `scope.rename` 불가 = 외부 청크 PaperModule·BookModule… 동반 필요), magic patchFlag/hoist. → **포팅 = "setup 의미모델 추출 → 대상 프레임워크로 뷰 재작성"이지 "전 식별자 복원"이 아니다.**

**포팅 가치 위치:** setup 로직의 **도메인 규칙·상태 흐름·API 계약(preserve 도메인코드)** 에 집중. 변수명 가독성은 이 중 일부만 올린다. render·temp·free-ref에 LLM 토큰 쓰는 건 ROI 음수.

---

## 6. 정량 종합 — 검증자 보정치

단/이중문자 바인딩 1,613(선언 기준, temp 재선언 포함) 대비:

| 구간 | 프로브 주장 | 검증자 보정 | 비고 |
|---|---|---|---|
| 자동 전이(공유+헬퍼) High | ~47% | **유효 ~40–47%** | 정렬 전이 misalign 0 실증·Rosetta 65 별칭 |
| 반자동(꼬리) Medium | ~37% | **유효 ~30–37%** | 라벨 보조·내부는 개별 명명 |
| 수작업(머리) Low~Med | 16.6%(268) | **실 ~7–8%(distinct ~123)** | temp 67% 부풀림 제거 |
| render | "38.7% 비중" | **호출 49%·줄 6.5%** | 명명대상 아님(양쪽 결론은 유효) |

- **전이가능 % ≈ 65–74%**(자동+반자동) — 상한(74%)은 temp까지 셈한 낙관, **현실 중앙값 ~68%**.
- **컨텍스트 명명가능(머리) ≈ distinct 123 / 강근거 ~40** — "16.6%"는 선언 기준 부풀림.
- **render 함수 share ≈ 호출 49% / 줄 6.5%** — "비중 38.7%" 표현 폐기 권장.

---

## 7. 최종 권고 — **PARTIAL-SETUP-ONLY**

전면 재디옵(DO-FULL-REDEOB)이 아니라 **setup 로직 한정 선별**이 정답. 근거:

1. **공유 20컴포넌트(전이 misalign 0)** = 즉시 자동화 ROI 최고. `_feas_align` rename-map → `path.scope.rename` 결정론 적용. **이건 지금 해도 된다.**
2. **render는 명명 대상이 아님**(줄 6.5%·새 식별자 0) → 전면 재디옵은 가치 없는 49% 호출부에 노력 낭비. 전면 금지.
3. **머리 6컴포넌트는 temp 67% 제거 후 distinct ~123만** 선별 명명(강근거 ~40 우선·temp 면제). 정답지 부재 → verifier G4(잔여 단문자 0·setup 스코프 한정)·G6 게이트 필수.
4. **full.js 직접 입력 가능**(파싱 OK 실증) — method.md의 "recovered.js 필수" 전제는 완화. 단 v1은 순수 rename이 아니므로(§2) 전이 정답지는 "v1 이름맵"만 쓰고 v1 AST를 동등 오라클로 쓰지 말 것.
5. **포팅이 목적이면** 변수명 위에 **타입/의도주석/도메인 DTO/외부의존 카탈로그**가 동반돼야 성립(method §2 동의) — 이건 setup 한정 작업의 산출에 포함, render엔 불필요.

> NEEDS-MORE-PROBE는 아님: 핵심 레버(정렬 전이 건전성·render 명명 무의미·temp 부풀림)는 본 검증으로 실측 확정됨. 추가 프로브 불요.

---

## 8. 재현 메모

- 측정: `RCD_NM=…/_tooling/node_modules NODE_PATH=$RCD_NM node 05_readable/_tooling/<script>`.
- 검증자 자작: `_vrf_handcheck.cjs`(init 본문 양면), `_vrf_handcheck2.cjs`(init 구조 시그니처 동등 155/165), `_vrf_render.cjs`(render 3지표), 머리 귀속/distinct 카운트 inline.
- 프로브 재현: `_feas_scan.cjs <full>`, `_feas_align.cjs <comp...>`, `_feas_coverage.cjs`, `_feas_region.cjs`.
- 파싱: full.js는 strict(`errorRecovery:false`)에서도 errors=0 — 직접 분석 가능.
