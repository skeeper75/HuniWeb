# 적대적 검증 결함 보드 — 셋트 계열 · 축 1(출처 실재성 + 권위 정합 + 오염 적발)

> **검증자:** okb-adversarial-verifier(Phase 4·생성≠검증) · 2026-07-03
> **범위:** 셋트 계열 신규 42상품(068~112·284~292) + 공유 formula/set-* + rule/gaps.md 셋트 GAP.
> **방법:** 생성자(builder)·큐레이션 팩 주장 **비신뢰** — live-snapshot awk 전사·§23 post-verify/diagnosis 실측·**cal_golden.py 라이브 evaluate_price 독립 재실행**·결정론 대조.
> **판정: PASS(결함 1건·Medium·격리 아님·builder 교정 가능·원천 데이터 무오염).**

---

## 0. 종합 판정

| 서브축 | 결과 | 근거 |
|--------|------|------|
| ① 출처 실재성 | **PASS(1건 경로오류)** | 25 인용 경로 중 24 실존·내용 일치. 1건 경로 불일치(D-1). |
| ② 권위 정합(골든·바인딩) | **PASS(오차 0)** | 셋트 골든 9종 §23 실호출 verbatim 일치·부모공식 11 바인딩 live 일치·캘린더 골든 5종 **라이브 독립 재실행 오차 0**. |
| ③ 오염 적발(STALE T-1~T-10) | **PASS(오염 0)** | 은퇴멤버 0노드·캘린더 .01/바인딩·화면0원 C트랙·양면표기 완비·구권위 미인용. |

---

## 1. 결함 (High/Medium/Low)

### [D-1·Medium] gap-set-simulate-sizcd — 인용 source_file 경로 부존재(dead citation)
- **노드/위치:** `03_kb/rule/gaps.md` 노드 `gap-set-simulate-sizcd`, line 201.
- **유형:** 출처 실재성 위반(provenance path error).
- **증거(재현):**
  - 인용 경로: `_workspace/huni-set-product/06_load/DEV-REQUEST-set-sim-sizcd-260702.md` → **부존재**(`ls` No such file).
  - 실제 경로: `_workspace/_foundation/remediation/DEV-REQUEST-set-sim-sizcd-260702.md` → 실존(16,890 bytes·2026-07-02·내용 = 셋트 UI siz_cd 미전파·094/097/100·450,000 골든 확인).
- **영향:** 가격 무영향. **사실은 진실**(siz_cd 미전파 코드 C트랙·094/097/100 화면0원)이며 파일은 다른 경로에 실존. HARD-tag GAP 노드의 인용을 따라가는 검증자가 dead file을 만나 추적 실패·불신. 데이터 전파 오류 없음.
- **교정안:** gaps.md:201 source_file 경로를 `_workspace/_foundation/remediation/DEV-REQUEST-set-sim-sizcd-260702.md`로 정정.
- **라우팅:** builder(gaps.md 1줄 경로 수정).

> product-094-postcard-book.md:54는 파일명만(경로 없이) 인용 → 정상.

---

## 2. 통과 실측 증거(적대적 재측정)

### ② 권위 정합 — 셋트 골든 §23 실호출 verbatim 일치(오차 0)
| 셋트 | KB 골든(1/10/100부 or 100부) | §23 원천 실측 | 판정 |
|------|------------------------------|----------------|------|
| 072 | 34,100/159,100/796,900 | 072-post-verify §2 | ✅ 일치 |
| 077 | 34,100/159,100/796,900 | 077-post-verify §2(불변) | ✅ |
| 082 | 30,184/151,844/818,438 | 082-post-verify §2(=set_eval 800,000+내지286 18,438) | ✅ |
| 088 | 34,100/159,100/796,900(현재값) | 088-post-verify §2a·D링 USAGE.07 불가침 | ✅ |
| 068 | 158,688(표지88,688+제본70,000) | diagnosis §0 line12 | ✅ |
| 069 | 138,688(+제본50,000) | diagnosis §0 line13 | ✅ |
| 070 | 288,688(+제본200,000) | diagnosis §0 line14 | ✅ |
| 094 | 450,000(OPV_000491+siz003) | diagnosis §3 line90 | ✅ |
| 097 | 135,000(bdl_qty=50) | diagnosis §3 line91 | ✅ |
| 100 | 1,500,000(OPV_000484+siz269) | diagnosis §3 line92 | ✅ |

### ② 부모공식 바인딩 — live-snapshot 결정론 일치(11/11)
068→PRF_BIND_SUM·069→PRF_BIND_MUSEON(+_FOIL)·070→PRF_BIND_PUR(+_FOIL)·071→PRF_BIND_TWINRING·072/077→PRF_HC_MUSEON_SET·082→PRF_HC_TWINRING_SET·088→PRF_LEATHER_RINGBINDER_SET·094→PRF_PCB_FIXED·097→PRF_TTEOKME_FIXED·100→PRF_PHOTOBOOK_FIXED. {awk t_prd_product_price_formulas.csv} — KB set-formulas 표와 verbatim 일치.

### ② 캘린더 골든 — ★라이브 evaluate_price 독립 재실행(검증자 직접·오차 0)
`cal_golden.py`(HuniSim.simulate·live pricing) 재실행 결과 = KB 노드 값 EXACT:
| prd | 재실행 final | KB 노드 | 판정 |
|-----|-------------|---------|------|
| 108 | 271,555 | 271,555 | ✅ |
| 109 | 197,660 | 197,660 | ✅ |
| 110 | 21,555 | 21,555 | ✅ |
| 111 | 231,032 | 231,032 | ✅ |
| 112 | 261,922 | 261,922 | ✅ |
→ 캘린더 골든 = 라이브 실측 실체(날조 아님). 팩 "🟡 candidate(PRICE≠0 실호출 전)" 요구를 builder가 **실호출 수행으로 해소** → badge=verified 정당.

### ③ 오염 적발 — 전 함정 회피 확증
- **T-1(readiness-master BLOCKED):** 068 노드가 "06-26 readiness-master 🔴 BLOCKED로 적었으나 2026-06-30 mint로 성립(T-2 STALE 정정)"로 **latest-wins 정직 주석** — 현행 권위로 인용 안 함. ✅
- **T-2(068~071 mint 예약):** 068/069/070 구성원 mint 반영·071만 GAP 노드(gap-071-set-notmembered). ✅
- **T-3(스냅샷 면지 구멤버):** 은퇴멤버 075/076/080/081/085/086/087/091/092/093 = **전부 0 노드**(grep 실측). 072=073/284/074·088=089/090(내지없음)만 — post-verify 구조 채택(스냅샷 5~6멤버 미채택). ✅
- **T-4(재설계前 골든 968,119/815,338):** KB 전역 검색 0건. ✅
- **T-5(094/097/100 화면0원=결함 단정):** 세 노드 모두 "가격사실=엔진골든(PRICE≠0)·화면0원=코드 C트랙(gap-set-simulate-sizcd)·badge≠defect"로 정직 양면. ✅
- **T-6(캘린더 .04/가격0행):** 108~112 전부 live PRD_TYPE.01·PRF_DGP_CAL_*/INNER 바인딩(2026-07-01) 실측 일치·위키 .04를 "STALE 교정"으로 명시. ✅
- **구권위 260610/260527:** 셋트 계열 노드 인용 0건(타 상품군 파일에만 존재·범위 밖). ✅
- **양면표기 완비:** 088(current 796,900 + pending 1,800,000·gap-set-088-redesign-pending)·069/070(base + _FOIL·gap-set-069-070-foil)·gap-set-s1s2-double·gap-design-calendar-fixedprice — 전부 실재. ✅

### ① 출처 실재성 — 25경로 중 24실존
셋트 노드 인용 source_file 유니크 25개 존재 검사: 24 실존(post-verify ×4·diagnosis·live-snapshot CSV·pack·docs/kb·cal_golden.py 등) + **1 경로오류(D-1)**. 088-redesign apply.sql·cal_golden.py·DEV-REQUEST(실경로) 모두 내용 대조 통과.

---

## 3. 격리(builder 교정 대상 아님) — 없음
D-1은 builder 교정 가능(경로 1줄). 원천 결함(088-redesign pending·siz_cd C트랙·cover_mult ×2·S1/S2 이중합산)은 노드가 **이미 GAP/C트랙으로 정직 표기**함(정상).
