# 기초코드 거버넌스 검증 게이트 — verdict (B1~B6)

> **하네스** hbg Phase 4 검증 게이트(`hbg-validator`). **작성** 2026-06-18. 1순위 축 = **자재·카테고리**.
> **방법:** 생성자(큐레이터·진단가·설계가) 산출을 신뢰하지 않고 **라이브 Railway DB 읽기전용 SELECT로 직접 재실측**(2-pass) 후 대조.
> **종합 평결:** **CONDITIONAL-GO** — 핵심 load-bearing 사실(MAT_TYPE 14코드·행수·BOM 177/USAGE.07·cp 0참조·카테고리 고아 3노드·search-before-mint)이 **라이브와 셀 단위 일치**. 단 **del_yn='Y'=143(특히 .09 전수)** 미측정 1건(B5/B6 보완 지시).

---

## 라이브 재실측 원장 (전 게이트 공유 증거)

| 측정 | 라이브 실측값(2026-06-18) | 생성자 주장 | 일치 |
|------|--------------------------|-------------|:--:|
| MAT_TYPE 자식 코드 | **14** (`MAT_TYPE.01~.14`) | 14 (진단 §0) | ✅ |
| MAT_TYPE 라벨 | .01 디지털인쇄용지·.02 제본부자재·.05 특수소재·.07 부자재·.11 스티커용지·.12 사입자재·.13 합판 스티커용지·.14 합판 봉투용지 | 스냅샷 B 일치 | ✅ |
| 자재 행수 by typ | .01=93·.02=9·.03=14·.04=19·.05=12·.06=5·.07=32·.08=17·.09=69·.10=43·.11=16·.12=6·.13=3·.14=2 | 진단 §0 전건 동일 | ✅ 전건 |
| 자재 총행 | **340** · use_yn='N'=**0** | 340·use_yn='N' 0 | ✅ |
| **del_yn='Y'** | **143**(.08=6·.09=**69 전수**·.10=7) | (미측정·"별도 컬럼 존재"만) | ⚠️ **누락** |
| MAX(mat_cd) | MAT_000340 (mint=337~) | 000336→337~ | ✅(+4 진화) |
| component_prices.mat_cd → .08/.09/.10 | **0** | 0(가격사슬 안전) | ✅ |
| BOM link .08/.09/.10 | .08=34(29상품)·.09=**113**(52상품)·.10=30(9상품)=**177** | 34·113·30=177 | ✅ 전건 |
| BOM usage_cd | **USAGE.07 = 177 전건** | USAGE.07 전건 | ✅ |
| 카테고리 총 | 307·use_yn Y=296·N=11 | 307·296·11 | ✅ |
| 고아(upr NULL·lvl≥2) | 14 = use_yn='N' 11 + use_yn='Y' **3**(CAT_000294 명함·302 데스크·304 말랑) | 11 교정완료 + 3 잔존 | ✅ 전건 |
| CAT_000294 연결 상품 | **0** | 0 | ✅ |
| CAT_000302/304 연결 | 각 1(PRD_000218 타이벡북커버·PRD_000229 이미지피켓·둘 다 use_yn='N') | 동일 | ✅ |
| 명함 정상 leaf 48~57 | 10·전부 use_yn='Y' | 10 실재 | ✅ |
| product_categories | 281 (392→281) | 281 | ✅ |
| shape_cd 컬럼·nonspec 테이블 | **부재(미구현)** | "적재경로 미상·DDL 후 확정" | ✅(정직) |
| print_options(print_side) | 테이블·컬럼 실재·166행 | 166행·5종 | ✅ |
| bundle_qtys / option_items | 28 / 477행 실재 | 28 / 477 | ✅ |

---

## B1 권위 충실성 — GO

- **검증:** 정답 사전(material/category) 각 정답값을 라이브 셀과 대조. 특히 ① .08 색 5행(MAT_000255~259) ② .09/.10 전수 mat_nm을 직접 덤프해 진단의 버킷 분류가 권위(상품마스터 명시 = 물리 재료만 자재)에 충실한지 셀 대조.
- **증거:**
  - .08 MAT_000255~259 = 화이트/블랙/홀로그램/골드/실버 (라이브 실측) → "색=자재 오염" 판정 = 권위 §2 "색상 5행 오염" 정합. **날조 0.**
  - .09 69행 전수 덤프 = 형상(원형/사각/꽃/별/하트/마카롱)·치수(미니50mm/A5용/11~15인치/M·L·S·XL)·인쇄면(단면/양면/양면가로형/전면만/배면만/양면유광)·구수(1~4구)·색(화이트M/청보라/핑크글리터 등) — **진짜 소재 0** 라이브 실증. 권위 §2 "자재가 하나도 없다" 정합.
  - .10 43행 전수 덤프 = 봉투5·볼체인본체/와이어링/천정고리/투명케이스/행택끈/자석고무판·우드거치/봉/행거(진짜 부속) + 볼체인 색8(202~209)·만년스탬프 잉크색8(232~239)(오염). → 진단이 **정답 사전 §2 "43행 전수 오염"을 "혼재(부속~26+오염~16)"로 정정**한 것이 라이브 권위와 일치. **권위를 덮어쓴 게 아니라 권위 사전의 과단정을 라이브가 교정.**
- **판정:** **GO.** 역공학/경쟁사가 권위 침묵 아닌데 정답 단정한 항목 0. 날조(없는 권위 인용) 0. C-MAT-1 라벨 충돌은 라이브 SELECT가 정당하게 종결(스냅샷 B=라이브 일치).

---

## B2 진단 정확성 — GO

- **검증:** 4-way 결함을 라이브 `information_schema`·실데이터로 재실측. 지정 6항목(① MAT_TYPE 14코드·행수 ② 오염 129행 ③ cp 0참조 ④ BOM 177/USAGE.07 ⑤ 카테고리 round-22 ⑥ COMMIT 반영·잔여 고아 3노드) 전수 대조.
- **증거:**
  - ① **MAT_TYPE 14코드·라벨·행수 전건 라이브 일치**(원장 참조). 진단 §0의 C-MAT-1 해소가 라이브로 재현됨.
  - ② 오염 = .08(17)+.09(69)+.10(43)=**129행** 라이브 일치(진단이 정답 사전 131→129 갱신·정당).
  - ③ **cp 0참조** 라이브 재현(가격사슬 안전 CONFIRMED).
  - ④ **BOM 177 link·USAGE.07 전건** 라이브 재현(.08=34/.09=113/.10=30).
  - ⑤⑥ 카테고리 307·고아 3노드(CAT_000294 상품0·302/304 비활성상품1)·product_categories 281 라이브 재현. **round-22 COMMIT분(고아 11 use_yn='N')을 미교정으로 오판하지 않음**(재진단 금지 준수).
- **판정:** **GO.** dbmap 기진단·기COMMIT을 중복 재진단/미교정 오판한 stale 결함 0. **단, ⚠️ del_yn='Y'=143(특히 .09 100%) 미측정** — 이건 진단 정확성 오류는 아님(use_yn 기준 판정은 라이브와 일치)이나, 동일 행에 이미 걸린 별도 삭제 플래그를 인지하지 못해 영향분석이 불완전 → **B5/B6에서 보완 지시**.

---

## B3 라우팅 타당성 — GO

- **검증:** 원인유형(전건 ⓐ v03)·라우팅(축이동 90·교정 26+아크릴22·삭제 1·BLOCKED 2)이 결함과 논리 정합한지, 색 2~3종 자재유지/4종+ CPQ 경계 준수하는지.
- **증거:**
  - 라이브 .09/.10 raw 덤프가 라우팅을 뒷받침: 형상→②siz·치수→②siz·색→옵션·인쇄면→print_side·구수→bundle — 의미와 목적지 축 정합.
  - **색 경계 규칙 준수:** .10 볼체인 8색·.09 7색 잉크는 "선택 색 목록 4종+→옵션"(정답). .08 5색은 4종+이나 "상품별 1색 고정 vs 팔레트" 미실측 → **B-MAT-3 컨펌으로 정직 보류**(자동 단정 안 함). 경계 규칙 위반 0.
  - 원인유형 전건 ⓐ(v03 입력 오염)·교정/축이동/삭제 라우팅이 결함종류(오염/고아)와 1:1 정합.
- **판정:** **GO.** 라우팅 논리 정합. 경계 모호분은 컨펌 큐로 정직 분리(dodge 아님).

---

## B4 search-before-mint 준수 — GO

- **검증:** 신규 코드행 0·신규 그릇 2(V-12 형상·비치수 size)가 정당한지, 남발 0인지 라이브 그릇 실재로 검증.
- **증거:**
  - **MAT_TYPE 신규 코드행 0** — 라이브 14코드 이미 실재(원장). 사다리 1단 정지 정당.
  - **신규 그릇 2건 정당:** `shape_cd` 컬럼·`nonspec`/`nondim` 테이블 **라이브 부재**(information_schema 실측 = 빈 결과) → V-12 형상축·비치수 size 마스터는 **진짜 vessel-gap**(둘 다 dbmap 기제안 재사용·재발명 0). 명세가 "DDL 적용 후 확정·적재경로 미상"으로 정직 표기.
  - 색/구수/인쇄면 오염 = 기존 print_side(166행)·bundle(28행)·option_items(477행) **실재 그릇으로 수신**(신규 그릇 0). 신소재 MAT_TYPE = .05 흡수·mint 0(보류).
- **판정:** **GO.** 신규 코드행 0·신규 그릇 vessel-gap 2건 외 남발 0. 정당성 라이브 입증.

---

## B5 등록 명세 실행가능성 — CONDITIONAL-GO

- **검증:** FK 위상 무모순·webadmin 적재경로 실재 또는 "미상" 정직 표기·채번 정합·영향분석 완비·dry walk-through.
- **증거(PASS):**
  - **FK 위상** 무모순: 본체 .05/.06 선적재 → 목적지 축 → 오염 use_yn='N' 마지막. BOM 177 load-bearing·cp 0참조가 라이브로 뒷받침 → 순서 규약 정당.
  - **적재경로 실재:** print_side/bundle/option_items 목적지 그릇 라이브 실재·USAGE.07 FK 타깃 실재. DDL-needed 2건은 "미상" 정직 표기(B4).
  - **채번:** MAT MAX=340→337~(라이브 340·실측 정합)·CAT MAX=308·`_` separator·멱등 NOT EXISTS — 규약 정합.
  - 카테고리 CAT_000294 논리삭제 = 상품 0 라이브 확인·무영향. dry walk-through 성립.
- **증거(보완 필요):**
  - ⚠️ **del_yn='Y'=143 영향분석 누락.** 명세 §1은 "삭제 = use_yn='N' 논리삭제만"이라 규정하나, 라이브 대상 행(.09 69행 **전수 del_yn='Y'**·.08 색 6·.10 7)이 **이미 del_yn='Y'이면서 use_yn='Y'이고 BOM 113 link 여전히 활성**. 운영자가 명세만 보고 등록 시 "del_yn='Y'인데 왜 use_yn='Y'·BOM 활성인가"를 알 수 없음 → **두 플래그 권위 관계(use_yn vs del_yn) 명시 필요**. 롤백·멱등 가드가 del_yn을 무시하면 재적재 시 충돌 가능.
- **판정:** **CONDITIONAL-GO.** FK·적재경로·채번·가격사슬 영향분석은 실행가능. **단 del_yn 플래그 영향분석 1건 보완 후 GO.**

---

## B6 생성-검증 독립성 — GO (단, 진단 dodge 1건 지적)

- **검증:** 생성자 산출을 베끼지 않고 라이브 직접 재실측. self-approve·dodge(어려운 자재 오염·고아 건너뜀) 능동 탐색.
- **증거:**
  - 본 게이트는 생성자 인용 수치를 **전부 라이브 psql로 재측정**(원장 20행). 베끼기 0.
  - **dodge-hunt 결과:** 진단가가 어려운 .09 전수 오염·.10 혼재·카테고리 잔여 고아 3노드를 **건너뛰지 않고 전수 처리**(raw 덤프로 확인). self-approve 0.
  - **★검증자가 적발한 진단 blind-spot 1건:** 진단/설계 전 단계가 **del_yn 컬럼을 측정만 하고 값을 보지 않음**("별도 컬럼 존재" 1줄). 라이브 재실측이 **.09 전수 del_yn='Y' + use_yn='Y' + BOM 활성**이라는 비자명 상태를 노출 — 생성자가 회피했다기보다 **미관측**. 독립 재실측이 아니었으면 묻혔을 항목 → 검증 독립성의 가치 입증.
- **판정:** **GO.** 독립 재실측 수행·self-approve 0·dodge 0. del_yn 미관측은 생성자에 환류(B5 보완 지시).

---

## 종합 평결 — CONDITIONAL-GO

**1순위 자재·카테고리 등록 명세 마스터는 라이브 권위에 충실하고 실행 가능하다.** 핵심 load-bearing 사실(MAT_TYPE 14코드·행수 전건·BOM 177/USAGE.07·cp 0참조·카테고리 고아 3노드·search-before-mint 신규그릇 2)이 라이브와 셀 단위로 일치하며, 날조·권위 덮어쓰기·stale 오판·신규그릇 남발·dodge가 **전건 0**. 진단이 정답 사전의 과단정(.10 전수 오염→혼재)을 라이브로 정정한 것은 오류가 아니라 검증 가치.

**유일한 보완 항목(del_yn)** 해소 후 무조건 GO. FAIL 게이트 없음.

### 재산출 지시 (1건 — `hbg-basecode-diagnostician` + `hbg-registration-designer`)

| 게이트 | 항목 | 지시 |
|--------|------|------|
| B5/B6 | **del_yn='Y'=143 영향분석 누락** | 라이브 .09 69행 전수·.08 6·.10 7이 `del_yn='Y'` + `use_yn='Y'` + BOM link 활성. ① 진단 보드에 del_yn 분포 실측 추가 ② 등록 명세 §1 삭제 규약에 **use_yn vs del_yn 권위 관계** 명시(어느 플래그가 BOM 활성/비활성을 지배하는가·논리삭제 시 둘 다 세팅할지) ③ 멱등·롤백 가드가 del_yn 충돌 회피하는지 walk-through. |

### 미검증 항목 (정직 명시 — 본 1순위 scope 밖, NO-GO 아님)

- **컨펌 큐 5건**(B-MAT-3 .08 색 팔레트 여부·AX-1 잉크색 귀속·부속 typ .10→.07·AC-2 아크릴 두께·C-CAT-1 비활성상품)은 권위 모호로 **목적지 미확정** — 명세는 정직히 분기 보류. 검증 대상 아님(사용자 결정 큐).
- **GPM-1/2 본체자재 41행 설계 GO·미COMMIT** 인용분 — round-22 산출로 본 게이트 재검증 범위 밖(라이브 .05/.06 본체 link 미적재 상태 확인은 했으나 설계 적정성은 dbmap 트랙 권위).
- **자재명 코팅 흡수·아크릴 두께(.01 종이축·.03 아크릴축)** — 진단이 "다음 회차" 정직 표기. 1순위 미실측.
- **.09 색 버킷 정확 카운트** — raw 덤프 기준 color/color×size 복합이 21 추정과 정합 범위이나 셀 단위 정확 분류는 색×사이즈 분해 결정(B-MAT-3) 후 확정. 진단이 복잡성 정직 인정.

---

## 첨부 — 라이브 SELECT 로그 (읽기전용·자격증명 비노출)

전 수치는 Railway `railway` DB 읽기전용 `SELECT`로 2026-06-18 측정. 쓰기 0. 측정 쿼리:
`t_cod_base_codes(upr_cod_cd='MAT_TYPE')` · `t_mat_materials GROUP BY mat_typ_cd` · `del_yn 분포` ·
`t_prc_component_prices JOIN t_mat_materials` · `t_prd_product_materials JOIN ... GROUP BY usage_cd` ·
`t_cat_categories(upr_cat_cd IS NULL AND cat_lvl>=2)` · `t_prd_product_categories` ·
`information_schema.columns(shape/nonspec/nondim)` · `t_prd_product_{print_options,bundle_qtys,option_items}`.

---
---

# B5 재검증 (del_yn 보정 후) — 2026-06-18 append

> **계기:** 1차 verdict B5 CONDITIONAL-GO + del_yn blind-spot 1건. 진단가·설계가가 보정 완료 통지(삭제 권위 use_yn→del_yn 전건 교체·FK 위상 4단계·멱등 가드 `del_yn='N'`·회귀 경고·카테고리 del_yn 미완 보정).
> **방법:** 보정 파일 4종(regspec-material/category·_registration-master·diagnosis del_yn 섹션) 정독 + **생성자 인용 del_yn 분포를 라이브 읽기전용 SELECT로 직접 재실측**해 날조 여부 대조.

## 라이브 재실측 원장 (보정 검증 — 생성자 인용 ↔ 라이브)

| 측정 | 라이브 실측값(2026-06-18) | 생성자 인용 | 일치 |
|------|--------------------------|-------------|:--:|
| 카테고리 del_yn×use_yn | N/N=10·N/Y=68·Y/N=1·Y/Y=228 | 진단 §A(Y/Y=228·총 Y=229·N=78) | ✅ |
| 카테고리 del_yn 총 | Y=**229**·N=**78** | 229 / 78 | ✅ |
| 카테고리 고아 14노드 del_yn | **CAT_000297만 del_yn='Y'**·나머지 13(294·293·295·296·298~301·303·305·306·302·304) del_yn='N' | 진단 §B "진짜 소프트삭제 완료 = CAT_000297 1노드뿐" | ✅ |
| CAT_000294 상태 | use_yn='Y'+del_yn='N'(완전 노출 활성 고아) | 진단 §B "결함 확정" | ✅ |
| 자재 del_yn×use_yn | N/Y=**197**·Y/Y=**143**·Y/N=**0** | 진단 §C(197·143·Y/N=0) | ✅ |
| .09 BOM link by del_yn | del_yn='Y'인데 **113 link 활성** | 진단 §D "소프트삭제가 BOM에서 행 못 떼어냄" | ✅ |

## 재검증 포인트 3건 — 전건 충족

**① FK 위상에 BOM link 제거(GPM-4)가 del_yn='Y'에 선행하는가 — PASS.**
- `regspec-material §0` FK 위상 = **4단계**로 교체: 본체 선적재 → 목적지 축 → **③ 오염 BOM link 제거/재배선(GPM-4·177건) → ④ 오염 자재행 del_yn='Y'(+del_dt) 마지막.** BOM 제거가 del_yn에 명확히 선행.
- 라이브가 이 순서의 필요성을 실증: **.09 69행이 이미 del_yn='Y'인데 BOM link 113 여전히 활성** → del_yn만으로는 기능적 떼어냄 불가(신규 UI 숨김까지만). 진단 §D 메커니즘(`price_views.py:537-538` "그리드는 기존 셀 코드 보존"·BOM JOIN mat del_yn 미필터) 정합. **진짜 미완 = BOM link 제거가 선결**임을 명세가 정확 반영.

**② 삭제 권위 = del_yn 전건 교체됐는가·잔여 use_yn='N'이 정당 문맥인가 — PASS.**
- 소프트삭제 권위가 `regspec-material §0·§252`·`regspec-category §0·§1`·`_registration-master §1·§112`에서 **use_yn='N' → del_yn='Y'(+del_dt)** 전건 교체. 소스 근거 인용(`admin.py:452-461` get_queryset exclude·`cfg_utils logical_delete`·`views.py:662` `filter(del_yn='N')`·`sql/24_add_del_yn.sql`).
- **잔여 "use_yn='N'" grep 전수 점검(11건) → 전부 정당 문맥:** ⓐ round-22 ⑥ COMMIT 인용(빈 노드 use_yn='N' 토글 — 과거 사실 기술) ⓑ BLOCKED 비활성 상품 PRD_000218/229 use_yn='N'(상품 상태 기술·삭제 규약 아님) ⓒ use_yn=list_filter 부차 토글 설명(권위 대조용) ⓓ "use_yn='N' → del_yn='Y' 정정" 대조 문맥. **삭제 조치를 use_yn='N'으로 규정한 잔존 0.** 라이브가 use_yn 권위 약함 입증: 자재 Y/N=0·카테고리도 del_yn이 조회 게이트(229 숨김).

**③ 카테고리 del_yn 미완 보정이 round-22 COMMIT분 재제안과 구분되는가 — PASS.**
- `regspec-category §1.2·§3`이 명확 구분: round-22 ⑥ **DELETE 111(고아 페어)+UPDATE use_yn='N' 토글 12 = 재제안 금지**, 단 **del_yn 미수행분(~12노드·CAT_000297 제외) = 신규 보정**(중복 아님).
- 라이브가 구분의 정당성 입증: **고아 14노드 중 del_yn='Y'는 CAT_000297 1개뿐**, 나머지 13(294 포함·302/304 BLOCKED)은 del_yn='N' = round-22가 del_yn 미수행 확정. 진단 `_exec_category/apply-log.md` 인용("DELETE+UPDATE use_yn='N'·del_yn 미사용")과 라이브 정합.

## B5 권위 충실성·실행가능성 보강 — admin 소스 근거 (B1/B5 교차)

진단이 인용한 del_yn 소스 메커니즘(`admin.py` get_queryset exclude·`logical_delete`·`views.py` 전반 `del_yn='N'` 필터·`price_views.py:537-538` 그리드 보존·`load_master.py:233` del_yn 미명시→DEFAULT 'N'→TRUNCATE 재적재 휘발)은 본 게이트가 소스 파일 직접 재독은 안 했으나, **라이브 동작 증거가 소스 주장과 정합**(del_yn='Y' 행이 BOM link 보유 = "그리드 기존 셀 보존" 동작 실측 확인). 회귀 경고(del_yn='Y' TRUNCATE 휘발·근본=경로 Y)는 round-22 P-TRUNCATE 가드와 정합.

## B5 최종 판정 — GO

- **검증:** FK 위상 4단계(GPM-4 선행)·삭제 권위 del_yn 전건 교체·잔여 use_yn 문맥·카테고리 del_yn 구분·멱등 가드를 보정 파일 정독 + 라이브 del_yn 분포 직접 재실측으로 대조.
- **증거:** 생성자 인용 del_yn 분포(카테고리 229/78·고아 297만 Y·자재 143/197/0·.09 BOM 113 활성) **전건 라이브 일치·날조 0.** FK 위상에 BOM 제거가 del_yn 선행·삭제 권위 del_yn 교체·round-22 구분 명확 — 재검증 3포인트 전건 충족.
- **판정:** **GO.** 1차 verdict B5의 유일한 보완 항목(del_yn 영향분석 누락)이 해소됨. 운영자가 명세만으로 등록 시 use_yn vs del_yn 권위 관계·BOM 제거 선행·멱등 가드를 명확히 알 수 있음(dry walk-through 성립).

## 잔존 미검증(정직 — NO-GO 아님)

- **소스 파일 라인 직접 재독 안 함**(`admin.py:452-461`·`views.py:662`·`price_views.py:537-538`·`load_master.py:233`) — 라이브 동작 증거로 간접 정합 확인까지. 소스 라인 실재성 정밀 대조는 webadmin 레포 접근 시(본 게이트 범위 밖·라이브 거동과 모순 징후 0).
- **GPM-4 BOM link 177 제거 실행 적정성** — round-22 dbmap 트랙 권위(본 게이트는 선행 순서만 검증).
- **컨펌 큐 5건**(B-MAT-3·AX-1·부속 typ·AC-2·C-CAT-1) 변동 없음 — 사용자 결정 큐·del_yn 보정과 무관.

---
---

# 종합 평결 (갱신) — GO

**1차 CONDITIONAL-GO의 유일 보완 항목(del_yn blind-spot)이 진단가·설계가 보정으로 해소됐고, 보정 내용이 라이브 del_yn 분포와 전건 일치(날조 0)함을 독립 재실측으로 확인했다.** B1~B6 전 게이트 GO:

| 게이트 | 1차 | 최종 |
|--------|:--:|:--:|
| B1 권위 충실성 | GO | **GO** |
| B2 진단 정확성 | GO | **GO** |
| B3 라우팅 타당성 | GO | **GO** |
| B4 search-before-mint | GO | **GO** |
| B5 실행가능성 | CONDITIONAL-GO | **GO**(del_yn 보정 해소) |
| B6 생성-검증 독립성 | GO | **GO** |

**1순위 자재·카테고리 기초코드 등록 명세 마스터 = GO.** 실 적재(축이동·교정·소프트삭제)는 `dbm-axis-staged-load`(경로 Y 우선)/`dbm-load-execution` 인간 승인 후. 컨펌 큐 5건은 사용자 결정 대기(GO와 독립). FAIL 게이트 없음.

---
---

# 2차 회차(4축) 검증 — 사이즈·도수·인쇄옵션·공정 (2026-06-18 append)

> **계기:** hbg 2차 회차 Phase 4. 축 = **② 사이즈·③ 도수·인쇄옵션·⑤ 공정**. 1차(자재·카테고리)와 별개.
> **방법:** 생성자(큐레이터·진단가·설계가) 산출을 신뢰하지 않고 **라이브 Railway DB 읽기전용 SELECT로 직접 재실측**(2-pass). 정직 규율 — 일부만 검증 가능하면 CONDITIONAL.
> **종합 평결(4축):** **CONDITIONAL-GO** — 도수(🟢)·사이즈(SZ-1 무비용 교정)·인쇄옵션(UV 63행)·공정 마스터 건전성은 라이브와 셀 단위 일치. **단 B4(search-before-mint) NO-GO 1건** — 공정 PR-1 `ref_param_json` 신규 jsonb 컬럼이 **기존 `t_prd_product_option_items.dtl_opt` jsonb(동일 테이블·이미 param 값 저장 중)를 사다리에서 평가하지 않음** → 신규 그릇 정당성 미입증. 재산출 대상.

## 라이브 재실측 원장 (4축 — 생성자 인용 ↔ 라이브 2026-06-18)

| 측정 | 라이브 실측값 | 생성자 인용 | 일치 |
|------|--------------|-------------|:--:|
| **③도수** t_clr_color_counts | **5행**·CLR_000001~005·chnl 0~4·전건 del N/use Y | 5행 SEED | ✅ |
| 도수 별색 혼입(clr_nm ~ 화이트\|클리어\|금\|은\|별색\|핑크) | **0** | 혼입 0 | ✅ |
| **⑤공정** t_proc_processes count/max | **102 / PROC_000102** | 102·MAX 102 | ✅ |
| 공정 family head(001 인쇄·007 별색·008 화이트~012 은색·017 제본·025 레이플랫·033 박·053/054/055 완칼/반칼/스티커완칼) | **전건 실재**·upr_proc_cd 정합 | family head 정합 | ✅ |
| **PROC_000084 열재단** | **실재**(del N·use Y·family head·upr 없음) | C-PROC-1 해소·실재 | ✅ |
| 공정 마스터 오염(del<>N or use<>Y) | **0 / 0** | 오염 0 | ✅ |
| PROC_000002 prcs_dtl_opt | `{"변형":enum["일반","배면양면","풀빼다","투명테두리","단면"]}` | 동일 | ✅ |
| **②사이즈** t_siz_sizes count | **520**·impos Y=15·del Y=65 | 520·15·65 | ✅ 전건 |
| t_siz_sizes 컬럼 = work/cut_width만(siz_width/height 부재) | **확인**(siz_width/height는 t_prc_component_prices에만) | "siz 마스터엔 없음·cp에만" | ✅ |
| cp siz_width 채움 | **922 / 7293** | 922/7293 | ✅ |
| SZ-1 색오염 SIZ_000104/105 | "화이트/블랙165x115mm(10장)"·del N | 동일 | ✅ |
| **SZ-1 104/105 component_prices 참조** | **0** | 0(무비용) | ✅ |
| **인쇄옵션** t_prd_product_print_options total | **166** | 166 | ✅ |
| print_side 분포 | 단면 62·양면 41·**풀빼다 21·배면양면 21·투명테두리 21** | 동일 | ✅ 전건 |
| UV 변형 = **63행 / distinct 21상품** | **63 / 21** | 63행·21상품 | ✅ |
| colrcnt 별색 혼입(front/back CLR 밖) | **0 / 0** | 혼입 0 | ✅ |
| **★UV 21상품 중 PROC_000002(UV) 실연결** | **14 / 21**(7상품 무연결: 아크릴명찰·지비츠·코스터·코롯토·포카코롯토·카라비너·지비츠★) | "21상품 **전건** UV(PROC_000002)" | ⚠️ **과장**(전건 아님·14) |
| ref_param_json 컬럼(option_items) | **부재**(information_schema 0) | "미구현 GAP" | ✅(정직) |
| option_items 행수 | **477** | 469/477 | ✅ |
| **★기존 option_items.dtl_opt jsonb** | **실재·param값 저장 중**(`{"유형":"봉미싱(7cm)","폭":7.0}`·키=유형/폭) | (사다리에서 **미평가**) | ❌ **search-before-mint 누락** |
| 라이브 jsonb 컬럼 수 | **9건**(dim_vals·use_dims·logic·**dtl_opt**·options.tags·dtl_opt(template_sel)·templates.tags·prcs_dtl_opt·sizes.tags) | "7건·8번째 동종" | ⚠️ option_items.dtl_opt·template_selections.dtl_opt 누락→실제 9 |
| shape_cd 컬럼·nonspec 테이블 | **부재**(t_prd_product_sizes shape_cd 0·nonspec/nondim 테이블 0) | "DDL 후 확정·미상" | ✅(정직) |
| bundle_qtys | **28** | 28 | ✅ |

---

## B1 권위 충실성 — GO

- **검증:** 4축 정답 사전(color/size/printoption/process) 각 정답값 ↔ 라이브 셀 대조. 특히 ① 도수 5행 SEED ② 별색=공정 경계(PROC_000007 family·clr_cd 없음) ③ UV 변형 저장 위치(print_side ✗·prcs_dtl_opt param ✓).
- **증거:**
  - 도수 5행 = 권위 SEED와 byte 일치·별색 혼입 0. **별색=공정 경계** 라이브 입증: PROC_000007(별색인쇄)→008 화이트·012 은색 family·도수칸 혼입 0. 권위 §2 "별색은 도수 아님·공정"과 정합. **날조 0.**
  - UV 변형(풀빼다/배면양면/투명테두리) = PROC_000002 prcs_dtl_opt `{"변형":enum}` 값과 byte 일치 → 권위 §2 "UV 변형=print_side 금지·PROC_000002 param" 정합. 인쇄옵션이 권위를 덮어쓴 게 아니라 권위가 규정한 오적재를 라이브가 재현.
  - SZ-1 색오염 2행이 OM-1 "siz=물리치수만" 권위 위반임을 라이브 셀이 확인.
- **판정:** **GO.** 역공학/경쟁사가 권위 침묵 아닌데 정답 단정한 항목 0. 날조 0.

---

## B2 진단 정확성 — CONDITIONAL-GO (1건 과장)

- **검증:** 지정 5항목(① 공정 102행·PROC_000084·family head ② siz 520·cp 922 ③ 도수 5행·혼입 0 ④ print_side UV 63행·아크릴 21상품 ⑤ 공정 마스터 오염 0)을 라이브 information_schema·실데이터로 재실측. round-13/22/23 기진단 중복/stale 오판 탐색.
- **증거(PASS):**
  - ① 공정 102행·MAX PROC_000102·PROC_000084 열재단 실재(C-PROC-1 종결)·family head 6종 전건 실재·마스터 오염 0/0 라이브 재현.
  - ② siz 520·impos 15·del 65·cp siz_width 922/7293 전건 일치. **diagnosis-size §0 "siz 마스터엔 siz_width/height 없음(cp에만)" = 라이브 정확**(t_siz_sizes 컬럼 전수 = work/cut_width만 확인).
  - ③ 도수 5행·별색 혼입 0·colrcnt 혼입 0(즉시 어긋남 게이트 통과).
  - ④ print_side UV 63행(각 21)·distinct 21상품·colrcnt 혼입 0 라이브 재현.
  - round-13 print_side UV 오적재 = **잔존 CONFIRMED**(재진단 아님·현재 상태 인용). round-22 ②사이즈/⑤공정 종단·round-23 구간차원/별색 dedup 기COMMIT을 미교정 오판하지 않음(stale 0).
- **증거(과장 1건):**
  - ⚠️ **diagnosis-printoption §1 "UV 21상품 전건 PROC_000002 UV"는 라이브와 불일치** — 21상품 중 **14만** t_prd_product_processes에 PROC_000002 연결, 나머지 **7상품(아크릴명찰·지비츠·코스터·코롯토·포카코롯토·카라비너·지비츠★)은 공정 연결 0건**. 이들도 아크릴 도메인·UV 변형 print_side를 갖지만 "전건 UV" 단정은 라이브 미실측 과장. B-PO-1 일괄결정("21상품 전건 UV라 풀빼다 유력")의 전제도 약화.
- **판정:** **CONDITIONAL-GO.** 핵심 행수·family·혼입 0은 전건 정확. **단 "21상품 전건 PROC_000002 UV" 과장 1건 → 진단가 정정 필요**(14 실연결·7 무연결 구분). 결함 라우팅 자체(UV 변형 축이동)는 영향 적으나 권위 정확성 흠.

---

## B3 라우팅 타당성 — GO

- **검증:** 도수 0(정상)·사이즈 교정 2(SZ-1)·UV 축이동 63·공정 ref_param_json 1·판정불가 31(SZ-2 30·PR-2 1)이 결함과 논리 정합한지.
- **증거:**
  - 도수 라우팅 0 = 폐쇄 SEED 정상(라이브 5행 무오염)과 정합.
  - SZ-1 색→옵션/자재·수량→bundle·siz_nm 정규화 = OM-1 위반 교정으로 의미 정합. cp 0참조 라이브 확인 → "무비용" 라우팅 정당.
  - UV 63행 print_side→param 축이동 = print_side 도메인 오류(인쇄면 vs UV처리 평면화)와 정합. ⓐ v03 전파 + ⓑ 그릇 부재 원인유형 정합.
  - 판정불가 31(SZ-2 형상+EA·PR-2 레이플랫)을 자동 단정하지 않고 정직 보류(dodge 아님).
- **판정:** **GO.** 라우팅 논리 정합. 경계 모호분 컨펌 큐 분리.

---

## B4 search-before-mint 준수 — NO-GO (재산출)

- **검증:** 신규 코드행 0·신규 그릇 ref_param_json jsonb 1(V-1 vessel-gap)이 정당한지 — **기존 코드행/컬럼/JSONB/junction으로 표현 불가임을 입증했는지** 라이브 그릇 실재로 검증.
- **증거(PASS):**
  - 신규 코드행 0 라이브 확인: 도수 SEED 폐쇄·print_side 5종 도메인 기존·열재단 PROC_000084/미싱(086)/봉제(088)/에폭시(095) **라이브 실재**(재제안 금지 정당)·siz SZ-1은 기존 행 정규화(채번 0).
  - shape_cd 컬럼·nonspec 테이블 라이브 부재 확인(자재 회차 V-12·비치수 마스터는 진짜 vessel-gap).
- **증거(NO-GO 핵심):**
  - ❌ **ref_param_json 신규 jsonb 컬럼의 search-before-mint 사다리가 불완전.** 공정 PR-1·vessel-process-parameter §2 사다리는 ① 코드행 ② 고정 컬럼 N개 ③ **신규** jsonb 컬럼 ④ 자식 테이블만 평가하고 **"기존 jsonb 컬럼 재사용"을 빠뜨림.**
  - 라이브 실측: `t_prd_product_option_items.dtl_opt jsonb`가 **동일 테이블에 이미 존재하며 param 선택값을 이미 저장 중** — `{"유형":"봉미싱(7cm)","폭":7.0}`·`{"유형":"오버로크+리본끈"}`(린넨 가공옵션, round-23). 키 = `유형`/`폭`. 제안하는 UV `{"변형":"풀빼다"}`·`{"줄수":2}`·`{"조각수":4}`와 **구조 동형**(prcs_dtl_opt 스키마↔값 instance).
  - `t_prd_template_selections.dtl_opt`도 `{"면":"양면"}` 저장 중(완전 동형).
  - 사다리 "8번째 동종 jsonb·라이브 7건" 주장도 **라이브 9건**(option_items.dtl_opt·template_selections.dtl_opt 누락) → 두 dtl_opt가 정확히 param-value 용도라는 사실을 놓침.
  - 즉 명세는 "신규 컬럼이 기존 dtl_opt로 표현 불가"임을 **입증하지 못함**(평가조차 안 함). dtl_opt가 "옵션 유형 전용·공정 param 부적합"이라는 의미 분리 논거가 있다면 정당할 수 있으나, 그 논거가 명세에 0.
- **판정:** **NO-GO.** ref_param_json 신규 그릇은 **기존 `dtl_opt` jsonb 재사용 가능성을 사다리에 추가해 재입증**해야 함. 두 경로 중 하나:
  - (a) dtl_opt가 공정 param 값을 담을 수 있으면 → **신규 컬럼 mint 0**(dtl_opt 재사용·진짜 search-before-mint 통과).
  - (b) dtl_opt가 의미상 분리돼야 하면(예: dtl_opt=옵션 표시용·ref_param_json=공정 검증용) → 그 **분리 논거를 명세에 명시**해야 vessel-gap 정당.
  - **재산출 대상: `hbg-registration-designer`(regspec-process §1 사다리 + vessel-process-parameter §2) + `hbg-basecode-diagnostician`(diagnosis-process PR-1 "슬롯 없음" → "dtl_opt 있으나 의미 분리 검토" 재진단).**

---

## B5 등록 명세 실행가능성 — CONDITIONAL-GO

- **검증:** ★FK 위상(ref_param_json 신설이 UV 축이동에 선행)·단가행 byte 불변·colrcnt 무접촉·적재경로 "미상" 정직 표기·dry walk-through.
- **증거(PASS):**
  - **FK 위상 순서 정합:** PO-1 = ① param 슬롯 그릇 선결 → ② UV 변형값 이관 → ③ print_side 정규화. 순서 위반 시 변형값 소실 논거 타당. (단 B4 결과에 따라 ①의 "신규 컬럼" 여부는 dtl_opt 재검토 후 확정.)
  - **colrcnt 무접촉:** front/back colrcnt 혼입 0 라이브 확인·명세가 "도수 손대지 않음" 명시. 정합.
  - **적재경로 정직 표기:** regspec-process §1 "현재 admin UI에 ref_param_json 입력 위젯 미구현 → 적재경로 미상(DDL 후 pvEdit 폼 확장)" 정직. shape_cd/비치수 마스터도 "미상" 표기.
  - **영향분석:** ADD COLUMN NULL 백필 0·무잠금·트리거 fn_chk_opt_item_ref 미참조·롤백 DROP+백업 권고. 멱등 가드 정합.
- **증거(보완 필요):**
  - ⚠️ **돈 크리티컬 가격사슬 영향분석이 간접 경로 미규명.** 명세는 "UV print_side 63행이 round-23 아크릴 가격사슬에 묶임"이라 하나, 라이브 `t_prc_component_prices`는 **prd_cd 컬럼 부재**(comp/proc/siz/clr 키)·해당 아크릴 21상품의 option_items=0(샘플 6건). print_side→가격 결합은 **직접 아님**(formula PRF_CLR_ACRYL/PRF_COROTTO_ACRYL 경유 간접). "단가행 byte 불변" 보장은 옳으나(print_side 정규화가 component_prices 미접촉) **결합 경로 자체가 명세에 정밀 규명 안 됨** → 운영자 dry walk-through 시 "왜 print_side 교정이 가격에 영향?" 불명확.
  - ⚠️ **option_items 목적지 부재.** PO-1은 변형값을 option_items.ref_param_json으로 이관하나, 라이브 해당 아크릴 상품 option_items=0행. **컬럼만 신설해선 담을 행이 없음** — 변형값 이관 전 option_items 행 INSERT가 선행돼야(명세 누락). OM-6 "option_items 대부분 미적재"와 충돌.
- **판정:** **CONDITIONAL-GO.** FK 위상·colrcnt·적재경로 정직·영향분석 골격은 실행가능. **단 ① 가격 결합 간접경로 규명 ② option_items 행 선적재(목적지 행 부재) 2건 보완 후 GO.** (B4 dtl_opt 재검토와 연동.)

---

## B6 생성-검증 독립성 — GO (validator 적발 2건)

- **검증:** 생성자 인용 수치를 베끼지 않고 라이브 직접 재실측. self-approve·dodge(UV 63행·형상+EA 30 건너뜀) 탐색.
- **증거:**
  - 본 게이트는 원장 24행 전부 라이브 psql 재측정(베끼기 0). 도수·공정·사이즈·인쇄옵션 핵심 수치 전건 라이브 대조.
  - **dodge-hunt:** 진단가가 UV 63행·SZ-2 형상+EA를 건너뛰지 않고 처리(판정불가 정직 분류). self-approve 0.
  - **★validator 독립 적발 2건(생성자 미관측):**
    1. **option_items.dtl_opt jsonb가 이미 param 값 저장 중**(B4) — 생성자 3개 산출(diagnosis·regspec·vessel) 전부 미관측. 독립 재실측이 아니었으면 묻혔을 핵심 결함.
    2. **UV 21상품 전건 PROC_000002 아님**(14 실연결·7 무연결·B2) — 생성자 "전건 UV" 과장. 라이브 process JOIN으로 적발.
  - 추가 정직: SZ-2 "형상+EA 30행"은 라이브 패턴(정사각/원형/하트+EA) **44행**(별/꽃 포함)·30은 좁은 서브셋 추정 → 카운트 정밀 흠(판정불가 라우팅엔 무영향).
- **판정:** **GO.** 독립 재실측 수행·self-approve 0·dodge 0. 적발 2건은 생성자 환류(B4/B2 재산출).

---

## 종합 평결 (4축) — CONDITIONAL-GO

**도수(🟢 폐쇄 SEED·byte 일치)·사이즈(SZ-1 무비용 교정·기계적 삭제 금지)·인쇄옵션(UV 63행 오적재 잔존)·공정 마스터 건전성(102행·family·열재단·param 스키마)은 라이브와 셀 단위 일치하며 날조·권위 덮어쓰기·stale 오판이 전건 0.** 그러나 **B4(search-before-mint)가 NO-GO** — 핵심 신규 그릇 `ref_param_json`이 동일 테이블의 기존 `dtl_opt` jsonb(이미 param 값 저장 중)를 사다리에서 평가하지 않아 정당성 미입증. B2(UV 전건 과장)·B5(가격 간접경로·option_items 목적지 부재) 보완 동반.

| 게이트 | 판정 |
|--------|:--:|
| B1 권위 충실성 | **GO** |
| B2 진단 정확성 | **CONDITIONAL-GO**(UV 전건 과장 1건) |
| B3 라우팅 타당성 | **GO** |
| **B4 search-before-mint** | **NO-GO**(ref_param_json ↔ dtl_opt 미평가) |
| B5 실행가능성 | **CONDITIONAL-GO**(가격 간접경로·option_items 목적지 2건) |
| B6 생성-검증 독립성 | **GO**(validator 적발 2건) |

**4축 등록 명세 = CONDITIONAL-GO + B4 NO-GO 재산출 필요.** 도수·사이즈·공정 마스터·인쇄옵션 진단/라우팅 골격은 건전하나, ref_param_json 신규 그릇은 dtl_opt 재사용 재검토 전 BLOCKED.

### 재산출 지시 (4축)

| 게이트 | 항목 | 지시 대상 | 지시 |
|--------|------|-----------|------|
| **B4** | ref_param_json ↔ 기존 dtl_opt jsonb 미평가 | `hbg-registration-designer`(regspec-process §1·vessel-process-parameter §2) + `hbg-basecode-diagnostician`(diagnosis-process PR-1) | 사다리에 **"기존 jsonb 컬럼 재사용(option_items.dtl_opt)"** 단계 추가. 라이브 dtl_opt=`{"유형":"봉미싱(7cm)","폭":7.0}` param값 저장 중. (a) dtl_opt 재사용 가능 → 신규 mint 0 / (b) 의미 분리 필요 → 분리 논거 명시. 둘 중 하나로 재입증. |
| **B2** | "UV 21상품 전건 PROC_000002" 과장 | `hbg-basecode-diagnostician`(diagnosis-printoption §1) | 라이브: 14상품만 PROC_000002 실연결·7상품(아크릴명찰/지비츠/코스터/코롯토/포카코롯토/카라비너/지비츠★) 공정 연결 0. "전건 UV"→"14 실연결·7 무연결(아크릴 도메인이나 미연결)"로 정정. B-PO-1 전제도 보정. |
| **B5** | 가격 간접경로·option_items 목적지 부재 | `hbg-registration-designer`(regspec-printoption §2·regspec-process) | ① print_side→가격 결합 = component_prices 직접 아님(prd_cd 부재·formula PRF_CLR_ACRYL 경유 간접) 규명 ② 변형값 이관 전 해당 아크릴 option_items 행 INSERT 선행(현재 0행) 명세 추가. |

### 미검증 항목 (정직 명시 — NO-GO 아님)

- **SZ-2 형상+EA siz 칼틀 매칭**(30~44행) — 상품별 t_prd_product_sizes 칼틀 실측 미수행(판정불가 정당·다음 회차).
- **PR-2 레이플랫 PROC_000025 운영 여부** — 연결 상품 실측 미수행(AX-6 컨펌·라이브 활성만 확인).
- **컨펌 큐 4건**(AX-5·B-PO-1·AX-6·SZ-2) — 사용자/실무진 결정 큐·검증 대상 아님.
- **round-23 아크릴 가격 골든값 byte 불변** — dbmap 적재 트랙 권위(본 게이트는 print_side 정규화의 component_prices 미접촉만 확인).
- **webadmin 소스 라인 직접 재독**(admin.py·price_views.py·load_master.py) — 라이브 거동 정합으로 간접 확인까지(레포 접근 시 정밀 대조).

### 첨부 — 라이브 SELECT 로그 (읽기전용·자격증명 비노출)

전 수치는 Railway `railway` DB 읽기전용 SELECT로 2026-06-18 측정(쓰기 0). 측정 쿼리:
`t_clr_color_counts` · `t_proc_processes(count/max/family/del/use)` · `t_siz_sizes(count/impos/del/columns)` ·
`t_prc_component_prices(siz_width filled·104/105 ref)` · `t_prd_product_print_options(print_side·colrcnt·UV distinct)` ·
`t_prd_product_processes JOIN(UV PROC_000002 실연결)` · `t_prd_product_option_items(dtl_opt keys/values)` ·
`t_prd_template_selections(dtl_opt)` · `information_schema.columns(ref_param_json·jsonb 전수·shape_cd·nonspec 테이블)` · `t_prd_product_bundle_qtys`.

---
---

# 2차 회차 재검증 — B4 NO-GO / B2 과장 / B5 보완 정정 (2026-06-18 append)

> **계기:** 직전 4축 검증의 B4 NO-GO + B2 과장 + B5 보완 2건에 대해 진단가·설계가가 정정 완료 통지. 정정 파일 6종 정독 + **인용 수치를 라이브 읽기전용 SELECT로 직접 재실측**해 날조·dodge 여부 대조.
> **방법:** 정정 골격(B4 dtl_opt 재사용·B2 14/7 분기·B5 행 선적재/간접경로)을 라이브로 grounding. 쓰기 0.

## 라이브 재실측 원장 (정정 검증 — 생성자 인용 ↔ 라이브 2026-06-18)

| 측정 | 라이브 실측값 | 생성자 인용 | 일치 |
|------|--------------|-------------|:--:|
| **B4** option_items.dtl_opt jsonb 컬럼 | **실재**(data_type=jsonb) | "기존 컬럼 라이브 실재" | ✅ |
| dtl_opt 채움 행 | **6 / 477** | 6행 실사용 | ✅ |
| dtl_opt 실값 = 공정 param 인스턴스 | **전건 OPT_REF_DIM.04 → PROC_000080**(`{"유형":"봉미싱(7cm)","폭":7.0}`·오버로크·말아박기) | 공정 param 선택값·동형 | ✅ |
| jsonb 컬럼 전수 | **9건**(dim_vals·use_dims·logic·**option_items.dtl_opt**·options.tags·**template_sel.dtl_opt**·templates.tags·prcs_dtl_opt·sizes.tags) | 정정문 3슬롯(prcs_dtl_opt·dtl_opt·template_sel) 명시 | ✅ |
| **B2** UV 변형 보유 21상품 | **21** | 21 | ✅ |
| ├ PROC_000002 실연결 | **14** | 14 | ✅ |
| ├ 공정 연결 전무(zero) | **7** | 7 | ✅ |
| 14 실연결 prd_cd | **146·147·148·149·150·151·152·155·157·158·160·161·162·163** | 동일 14 | ✅ 전건 |
| 7 무연결 prd_cd/nm | **153 명찰골드실버·156 지비츠·159 코스터·164 코롯토·165 포카코롯토·166 카라비너·171 지비츠★**(각 proc_links=0·uv_rows=3) | 동일 7(코롯토164·카라비너166 BLOCKED) | ✅ 전건 |
| **B5** 21상품 option_items 행 | **0** | "현재 0행·선적재 선결" | ✅ |
| component_prices.prd_cd 컬럼 | **부재**(0) | "prd_cd 부재·formula 간접" | ✅ |
| PRF_CLR_ACRYL / PRF_COROTTO_ACRYL formula | **실재** | "formula 경유 간접" | ✅ |

---

## B4 search-before-mint — NO-GO → **GO**

- **검증:** ref_param_json 신규 컬럼 철회·기존 dtl_opt 재사용이 라이브 실재 그릇으로 정당한지(신규 mint 0)·search-before-mint "0단 dtl_opt 재사용" 단계가 추가됐는지.
- **증거:**
  - `t_prd_product_option_items.dtl_opt` jsonb **라이브 실재**·**6행이 공정 param 선택값을 이미 저장**(전건 OPT_REF_DIM.04→PROC_000080 봉제 옵션·`{"유형":"봉미싱(7cm)","폭":7.0}`). 내가 1차에서 적발한 바로 그 그릇.
  - 목표 UV `{"변형":"풀빼다"}`와 **키-값 jsonb 동형**·같은 의미축(공정 param 선택값). 의미 분리 불요 → 판정 (a) **재사용 가능·신규 mint 0** 정당.
  - regspec-process §1·diagnosis-process §6.1·_routing-summary §13·_registration-master §5 전부 **search-before-mint 0단(dtl_opt 재사용 검증) 명시 추가**. rpmeta V-1 vessel-gap → **data-gap 격하** 일관 반영. ref-param-json-proposal.sql ALTER 철회.
  - **dodge 0:** 신규 컬럼 철회를 회피 없이 6파일 전반 반영(ALTER 0·DROP COLUMN 위험 소멸·영향분석 갱신).
- **판정:** **GO.** 1차 NO-GO 핵심(기존 jsonb 미평가)이 해소. dtl_opt 재사용이 라이브로 grounding되고 사다리 0단 명시됨. **4축 신규 mint = 0** 확정.

## B2 진단 정확성 — CONDITIONAL-GO → **GO**

- **검증:** UV 14 실연결/7 무연결 분기가 라이브 t_prd_product_processes와 일치하는지·"전건 UV" 과장이 철회됐는지.
- **증거:**
  - 라이브 분기 **14/7 전건 일치**: UV 보유 21 → PROC_000002 실연결 14·공정 연결 전무 7(with_any_process=14가 7의 무연결 입증). 14 prd_cd·7 prd_cd/prd_nm **명단 byte 일치**(dodge-hunt 전수 대조).
  - 7 무연결 = 각 proc_links=0·uv_rows=3(7×3=21=PO-1b 행수와 정합). 코롯토164·카라비너166 = round-22 B-10 BLOCKED와 정합.
  - PO-1 → PO-1a(14·~42행 즉시)/PO-1b(7·~21행 PROC_000002 링크 선행) 분기 전 파일 반영. B-PO-1 전제 = **14 실연결 한정**으로 보정. PO-1b 정체 신규 컨펌 큐 추가.
- **판정:** **GO.** "전건 UV" 과장 철회·14/7 분기 라이브 전건 일치·명단 정확. 과장 0.

## B5 등록 명세 실행가능성 — CONDITIONAL-GO → **GO**

- **검증:** option_items 행 선적재가 FK 위상에 명시됐는지·가격 간접경로가 규명됐는지.
- **증거:**
  - **FK 위상 정정 grounding:** 21상품 option_items **0행** 라이브 확인 → "진짜 선결 = option_items 행 선적재(신규 컬럼 ALTER 아님)" 정당. PO-1a = ① option_items 행 선적재 → ② dtl_opt 이관 → ③ print_side 정규화·PO-1b = ⓪ PROC_000002 링크 선적재 추가. 순서 위반 시 고아 param 논거 타당.
  - **가격 간접경로 규명:** `component_prices.prd_cd` **부재** 라이브 확인 → print_side는 단가행 직접 키 없음. 가격 결합 = `PRF_CLR_ACRYL`/`PRF_COROTTO_ACRYL` formula 경유 간접(실재 확인). regspec-printoption §2가 "단가행 byte 불변·colrcnt 무접촉·formula 분기 입력 골든 유지 3중 보장"으로 정밀 규명.
  - **dodge 0:** 1차 적발 2건(목적지 행 부재·간접경로) 모두 회피 없이 라이브 grounding + 명세 반영.
- **판정:** **GO.** option_items 행 선적재 FK 위상 명시·가격 간접경로 규명 완료. dry walk-through 성립(운영자가 선적재→이관→정규화 순서·가격 영향 경로 인지 가능).

---

## 종합 평결 (4축·재검증 후) — GO

**1차 B4 NO-GO + B2 과장 + B5 보완 2건이 진단가·설계가 정정으로 전건 해소됐고, 정정 골격(dtl_opt 재사용·14/7 분기·행 선적재/간접경로)이 라이브와 셀 단위 일치(날조·dodge 0)함을 독립 재실측으로 확인했다.** B1~B6 4축 전 게이트 GO:

| 게이트 | 1차(4축) | 최종(4축) |
|--------|:--:|:--:|
| B1 권위 충실성 | GO | **GO** |
| B2 진단 정확성 | CONDITIONAL-GO(UV 전건 과장) | **GO**(14/7 분기 정정·전건 일치) |
| B3 라우팅 타당성 | GO | **GO** |
| **B4 search-before-mint** | **NO-GO**(ref_param_json↔dtl_opt 미평가) | **GO**(dtl_opt 재사용·신규 mint 0·0단 추가) |
| B5 실행가능성 | CONDITIONAL-GO(목적지 행·간접경로) | **GO**(option_items 선적재·formula 간접 규명) |
| B6 생성-검증 독립성 | GO(validator 적발 2건) | **GO**(정정 라이브 grounding·dodge 0) |

**4축(사이즈·도수·인쇄옵션·공정) 기초코드 등록 명세 = GO.** 핵심: **4축 신규 mint = 0**(ref_param_json 신설 철회·기존 dtl_opt 재사용 grounding)·UV 14/7 분기 정확·option_items 행 선적재 FK 위상 명시·가격 formula 간접경로 규명. 실 적재(SZ-1 색오염 2·PO-1a 14·PO-1b 7 dtl_opt 이관·print_side 정규화)는 `dbm-axis-staged-load`/`dbm-load-execution` 인간 승인 후. FAIL 게이트 없음.

### 잔존 미검증 (정직 — NO-GO 아님)

- **컨펌 큐 5건**(AX-5 dtl_opt 이관 범위·B-PO-1 underbase[UV 14 한정]·PO-1b 정체[7 무연결 공정 연결]·AX-6 레이플랫·SZ-2 형상 칼틀) — 사용자/실무진 결정 큐·검증 대상 아님.
- **SZ-2 형상+EA 칼틀 매칭·PR-2 레이플랫 연결 상품** — 라이브 칼틀/연결 실측 다음 회차(판정불가 정당).
- **round-23 아크릴 골든값 byte 불변·option_items 행 적재 적정성** — dbmap 적재 트랙 권위(본 게이트는 print_side 정규화의 component_prices 미접촉·선적재 선결만 확인).
- **webadmin UV 변형 입력 폼 적재경로** — 명세 "미상" 정직 표기(admin 위젯 미확인).

### 첨부 — 라이브 SELECT 로그 (재검증·읽기전용)

`information_schema.columns(dtl_opt·jsonb 전수·component_prices.prd_cd)` · `t_prd_product_option_items(dtl_opt 채움·OPT_REF_DIM.04 PROC_000080)` · `t_prd_product_print_options × t_prd_product_processes(UV 21→14/7 분기·명단)` · `t_prd_products(7 무연결 prd_nm·proc_links)` · `t_prc_price_formulas(PRF_CLR_ACRYL·PRF_COROTTO_ACRYL)`. 쓰기 0.
