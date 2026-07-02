# O1~O7 최종 게이트 판정 — 2026-07-03

> 게이트: okb-query-gate(독립 3차) · 방법론: `.claude/skills/okb-adversarial-gate/SKILL.md §4`
> 원칙: 러너(시나리오 3보고서·Phase 4 판정·빌드 리포트) 주장 비신뢰 — 그래프 직접 재빌드(2회 멱등)·graph.db 블라인드 재질의·라이브 evaluate_price 직접 재호출로만 판정.
> 독립 재실측 범위: 시나리오 4건(구체 S1·용도 S-I1·거절·환각 S-H4) graph.db 블라인드 재주행 + 가격 4건(9,424/16,024/4,071/10,177) 라이브 실호출 + O1 소스 228토큰 전수 + O2 qty 4상품 + O3 오염 + O4 빌드 2회 + O5 R3 스크립트 재실행.

## 종합: **GO** (O1~O7 전부 PASS · 단일 FAIL 없음)

| 게이트 | 판정 | 핵심 근거(직접 재실측) |
|---|:---:|---|
| O1 출처 실재성 | **PASS** | 204 노드 sources 228 경로토큰 전수 sweep → missing **0**(base 보정·유니코드 조각 배제 후). 잔존 Low 1(팩 §3.5 rootless)=그래프 노드 소스 아님·파일 실재. |
| O2 권위 정합 | **PASS** | KB raw 수치(qty 016=15/041=12/033=100/046=20)=라이브 sim_meta 완전 일치. 가격 4건 라이브값=러너 주장 **오차 0**. price_component 26 use_dims/prc_typ_cd verbatim(Phase4). |
| O3 오염 필터 | **PASS** | 085 환각 has_process edge **0**·010/011 STALE addon edge **0**·del_yn=Y 인용 0. 양면표기 준수(S1 판수 GAP·S-C1 DEMO 엔진미강제). |
| O4 그래프 무결성 | **PASS** | build_graph.py **2회 byte-identical**(md5 동일)·nodes204/edges430·hard**0**·soft30·dup edge0·jsonl=sqlite=report=430. audit 날조/누락 노드·엣지 0(204/204·327/327). |
| O5 연결 완전성 | **PASS** | verify_r3 재실행 VERDICT=PASS(8/8 상품 종단경로 끊김0·option_refs75 실재·dead-link0). GAP 15 전부 extra 3필드 보유(빌드 hard-lint 실작동 확인). 커버리지 공백=GAP_016_material로 정직 선언. |
| O6 종단 질의 재현 | **PASS** | 시나리오 **31**(구체8+용도/조건8+거절/엣지15)≥12·유형 **5종 전부**. 가격 대조 오차0·PRICE≠0·PRD_999999→404. 거절 정직(현수막/아크릴/3단/머그 환각0). |
| O7 생성≠검증 독립성 | **PASS** | builder(03_kb 생성)↔verifier(build 재실행+스냅샷)↔본 게이트(3차 독립 재실측) 분리. builder 자기승인 0. 본 게이트가 자기 툴 형식오류(proc 문자열)를 스스로 적발·정정=KB 결함 아님 확증. |

## 재실측 증거 요약(숫자)

- **O4 멱등:** run1=run2 md5 `nodes=0282be6f… edges=fa2740e2…`, hash `nodes=f116635e edges=da3e882a`, hard=0.
- **O6 가격(라이브 직접 재호출·오차 0):**
  - S1 016 73×98 단면 백색모조지220g 100장 = **9,424**(인쇄9,000+용지423.84·pansu18)
  - S1-v 양면 = **16,024**(인쇄15,600+용지423.84)
  - S-C2 016 15장 = **4,071**(인쇄4,000+용지70.64)
  - S-I1 041 쿠폰 108장 = **10,177**(인쇄9,900+용지276.57·pansu12)
- **O6 유형 커버리지:** 구체(S1~S3)·용도(S-I1~3)·조건(S-C1~3)·옵션(S10~S12,V2)·거절(S-I4,S-C4,S-R1~5,S-H1~5,S-G1~4).
- **O1:** 228/228 실재. **O2:** qty 4/4·가격 4/4 diff 0. **O3:** 085=0·010/011=0.

## 검증 범위·한계 (정직 표기)

- **전수(스크립트):** 그래프 재빌드 멱등·소스 228토큰·엣지/노드 대응·8상품 재귀CTE·option_refs75·GAP15 형식.
- **표본(직접 재측):** 시나리오 4/31·가격 4건(러너 주장과 오차0으로 신뢰 확립)·qty 4상품. 나머지 27 시나리오는 러너 3보고서 표본검증(재현 관례 일관·모순 0).
- **"무결" 단정 아님:** 파일럿=디지털인쇄 8상품 한정. 가격 값 정합은 8상품 evaluate_price 실호출까지 확인, 비파일럿 셀 무결성은 §26 소관.

## 동형 전파 가능성 평가

- **✅ 스키마 고정 경로는 전파 가능.** `product→has_size/print_option/process→priced_by→formula→has_component→use_dims + qty_rule/constraint/option_refs`는 상품 무관 고정 탐색이라, 나머지 파일럿 밖 상품·타 상품군도 **노드만 채우면 동일 질의 재현**. 거절 기계(RULE_scope_boundary·GAP·노드부재)도 횡단 전파 가능.
- **⚠️ 무조건 복제는 금물(재실측 필수).** ① 비종이류(현수막/아크릴/롤소재)는 §26/§27 라이브 결함(fn_calc_pansu·sparse grid·C트랙 코드버그) 미해소분 존재 → 가격 값 정합은 상품군별 재실측 필요. ② GAP·candidate badge는 상품별 원천 상태 종속(전파 시 재판정). ③ intent 추천 도달은 category `in_category` 역질의 의존 → 카테고리 커버리지 확장이 선행.
- **권고(비차단):** OBS-1(scope_boundary "쿠폰" 토큰 중의성→과잉거절 위험·curator)·OBS-2(파일럿 밖 상품 명시 RULE 부재·architect)·R3-01(GAP_016_material 대표subset vs 전수민팅 정책·architect)·R3-02(gap_what 문구 정밀화·curator). 전부 Low/Medium·게이트 FAIL 아님.

## NO-GO 라우팅

- 해당 없음(GO). 후속 비차단 항목만 위 권고로 curator/architect 큐 등재.
