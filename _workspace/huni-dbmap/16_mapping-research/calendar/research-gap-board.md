# 캘린더 + 디자인캘린더 — 외부 갭헌팅 보드 (round-12 P2)

> **작성** 2026-06-10 · round-12. 목적 = "후니 시트·스키마에 없는 속성 축"의 적발(답습 금지). 국내외 경쟁사 + 표준을 캘린더 상품 렌즈로 조사. 갭 0이어도 "조사했고 갭 없음"을 대상·Sources와 함께 기록.
>
> **재사용 우선:** `07_domain/benchmark-competitors.md`(B5 장수·자재 IMPORT)·RedPrinting 역공학(사용자 본인 시스템) 먼저. 신규 WebSearch는 캘린더 고유 축 확인용 2건만.

---

## 1. 조사 대상 (캘린더 상품군 적합 선별)

| 풀 | 대상 | 조사 출처 |
|----|------|-----------|
| **국내** | 레드프린팅(역공학·landing/calendar), 퍼블로그, 오프린트미, 성원애드피아, 디티피아, 달카닷컴, 북토리, 캔바 | WebSearch + 기존 KB |
| **해외** | Vistaprint, Mixam, MOO | WebSearch + WebFetch |
| **표준** | CIP4(JDF 제본·자재), ISO 12647, 용지 규격(국전/46전) | 기존 KB(pdf-domain-knowledge·benchmark) |

---

## 2. 갭 보드 (갭 · 출처 · 후니 영향 · 근거)

| # | 발견 축 | 경쟁사/표준 | 후니 보유? | **처분** | 근거 |
|---|---------|-------------|:---------:|----------|------|
| G-CAL-1 | **시작월(start month) 커스텀** | Vistaprint("Edit calendar dates"), 퍼블로그(시작월 설정), RedPrinting(starting month) | ✗(시트/스키마 부재) | **무시 — 에디터 콘텐츠 귀속** | RedPrinting 역공학이 시작월을 명시적으로 "Content/Editor Settings (Non-pricing)"로 분류. 후니=Edicus 에디터가 처리. BOM/가격 축 아님 → t_* 매핑 불요 |
| G-CAL-2 | **시작연도(year) 커스텀** | Vistaprint, 퍼블로그(연도) | ✗ | **무시 — 에디터 콘텐츠** | G-CAL-1과 동류. 캘린더 콘텐츠 = 에디터 변수, 상품 사양 아님 |
| G-CAL-3 | **음력/공휴일/큰글씨/달력폼 ON·OFF** | 퍼블로그(음력·큰글씨·달력폼) | ✗ | **무시 — 에디터 콘텐츠/디자인 템플릿** | 디자인 템플릿(Q6 에디터 디자인)의 콘텐츠 변형. PRD_TYPE.04 디자인 템플릿 내부 |
| G-CAL-4 | **링컬러 다양화(실버·골드·화이트)** | RedPrinting(black/silver/gold/white) | △(후니=블랙만 실측) | **무시 — 표현력 보유**(링칼라 param) | 후니 `prcs_dtl_opt.링칼라`가 이미 색 축 보유. 현재 엑셀=블랙뿐이나 스키마는 다색 수용. 확장은 코드값 추가만(DDL 불요) |
| G-CAL-5 | **거치대 종류 다양화(컬러스탠드 vs 골판지)** | RedPrinting(color stand black/navy/ivory · corrugated cardboard) | △(후니=삼각대 그레이/블랙·우드거치대) | **무시 — 자재/param 보유** | 후니 삼각대컬러(그레이/블랙)+우드거치대(자재·Q13). 거치 종류=자재+공정 param으로 표현 가능 |
| G-CAL-6 | **A4/A3 규격 호칭** | RedPrinting 벽걸이(A4/A3) | ✓(후니=치수 직접 210x297/210x420) | **무시 — 치수가 더 정밀** | 후니 t_siz_sizes 치수 직접 표기가 A-호칭보다 정밀. 답습 불요 |
| G-CAL-7 | **장수=시트 FixedUnit vs pages 배열** | RP=시트 FixedUnit·WP=pages 배열 | (후니 미결→Q12 확정) | **매핑 반영 — Q12 고객옵션+공식** | benchmark B5 L83. 후니는 "장수=고객 선택 옵션+가격공식"(Q12)로 확정 — RP/WP 어느 답습도 아닌 후니 결정 |
| G-CAL-8 | CIP4 JDF 제본 자원(BindingIntent: Ring/SaddleStitch) | CIP4 JDF | ✓(후니=공정 PROC + GRP-CAL-가공) | **무시 — 공정 모델 정합** | 트윈링/타공/삼각대거치 = 후니 process 행으로 표현. JDF BindingIntent와 의미 대응. 추가 축 없음 |

---

## 3. 갭 처분 요약

- **무시(에디터 콘텐츠 귀속):** G-CAL-1·2·3 — 시작월/연도/음력/공휴일은 캘린더 **콘텐츠**(에디터 변수)이지 상품 BOM/가격 사양이 아니다. RedPrinting(사용자 본인 시스템)이 동일하게 분류. 후니 Edicus 에디터·PRD_TYPE.04 디자인 템플릿이 흡수. **DDL/매핑 수정 불요.**
- **무시(후니 표현력 보유):** G-CAL-4·5·6·8 — 링컬러/거치대/규격호칭/제본자원은 후니가 이미 param·자재·치수·공정으로 표현. 경쟁사 답습 불요(메모리 `dbmap-domain-knowledge-before-asking` 정합).
- **매핑 반영:** G-CAL-7 — 장수 모델은 Q12 확정(고객옵션+공식)으로 mapping-final §A C17에 반영.

> **신규 DDL 제안 0건. 매핑 수정 0건(Q12는 이미 mapping-final 반영).** 캘린더는 07_domain·후니 스키마 커버리지가 외부 경쟁사 표현력을 흡수/능가 — 외부 갭은 전부 에디터 콘텐츠이거나 후니 보유 축. **"조사했고 후니 미보유 BOM/가격 축 갭 없음" 확정.**

---

## Sources (WebFetch 검증)
- 레드프린팅 캘린더(역공학·본인 시스템): https://www.redprinting.co.kr/ko/landing/calendar — 탁상5(mini/narrow/small/large/wide)·벽걸이2(A4/A3)·트윈링/페이퍼링·링컬러(black/silver/gold/white)·거치대(컬러스탠드/골판지)·**시작월=Non-pricing Content/Editor Settings**(WebFetch 검증).
- 퍼블로그: https://www.publog.co.kr/service/search/search.asp?q=calendar — 탁상·벽걸이·2단·우드 4종 13사이즈·시작월·음력·큰글씨·달력폼 ON/OFF (WebSearch).
- Vistaprint 캘린더: https://www.vistaprint.com/photo-gifts/calendars — 시작월(Edit calendar dates·school-year)·휴일 커스텀·탁상 rect 4x8(단면)/sq 8x8(양면)·벽걸이 22.5x14.5 (WebSearch).
- Mixam wall/desk calendars: https://mixam.com/wallcalendars (WebSearch — 캘린더 커스텀 옵션 상세는 미노출).
- 기존 KB: `07_domain/benchmark-competitors.md`(B5 장수 RP FixedUnit/WP pages 배열·L83 후니 결정·자재 IMPORT B1).
