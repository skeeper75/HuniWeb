# M-Gate Verdict — OT (상자·패키징) · 12번째 카테고리

> RP-Meta Phase 6 · rpm-validator 독립 교차검증 · 2026-06-20
> 입력: `categories/OT/{reverse.md,deepcheck.md,captures/ot_cap_*.json}` + `02_metamodel/{discovered-axes,_resolved-fragments,metamodel-dictionary}.md`(v12.0) + `03_gap/{gap-matrix §XXIII,vessel-needs v12.0,_data-gaps-noted §13}` + 후니 라이브 information_schema(읽기전용 SELECT 직접 재실측).
> 방법: 생성자 주장 비신뢰·경계면 교차 재측정·단일 실결함=FAIL·정직 CONDITIONAL.

## 종합 판정

| 게이트 | 판정 | 한 줄 |
|---|---|---|
| **M1 추출 충실성** | **GO** | 6 캡처 전건 reverse 주장과 byte 일치·날조 0·OTCPHOL 미캡처 정직 표기 |
| **M2 메타모델 정합** | **GO** | O-1~O-4 17축 오버피팅 0 귀속·관계 무모순(_resolved-fragments 10항·dictionary v12.0) |
| **M3 distinct 타당성** | **GO** | 전개도/dieline #18 부결 비준(전용슬롯+KB결함 둘 다 불충족)·#14 음의사례 타당·과소강등 0 |
| **M4 갭 판정 정확** | **GO** | t_siz work/cut/margin 8컬럼·PROC family·height 부재·templates 그릇 전건 라이브 일치 |
| **M5 vessel 건전성** | **GO** | 신규 vessel 0·V-11/V-12 불변·DC-1 makers 응답 표면 실측=generic 포인터(subtype 불요) |
| **M6 생성-검증 독립성** | **GO** | self-approve 0·핵심 4주장 재유도·dodge-hunt 4건 깨기 시도 → 부결 견딤 |

**최종: M1~M6 전건 GO. distinct 0 비준. 전개도/dieline #18 부결 확인. t_siz work/cut 컬럼 실재 확정. 라이브 재실측 일치 = 4쿼리(컬럼·실데이터·PROC·templates) 전건.**
저위험 표현 결함 2건(L-OT-1·L-OT-2, FAIL 무관·소유자 라우팅).

---

## M1 — 추출 충실성 (GO)

OT reverse 원자를 캡처 원본(`captures/ot_cap_*.json`·infoCall 0·SSR select·2026-06-19)과 직접 대조.

| reverse 주장 | 캡처 실측 | 일치 |
|---|---|---|
| OTPKCAK selects: paper[BV]·paper_sub[350]·sodu[단면]·size 3프리셋·number2_sel 건수·number1_sel 수량 (reverse:39-75) | `selects` 정확히 일치(케익상자 소495×280/중553×296/대694×336) | ✅ |
| OTPKCAK 표시 "제품 130×105 높이80 / 재단 485×270 / 작업 495×280" (reverse:38) | snip "제품사이즈:130 X 105mm (높이:80mm) 재단사이즈:485 X 270mm 작업사이즈:495 X 280mm" | ✅ |
| optBlock "납작하게 접힌 상태로 배송·상자로 만들어 사용" (reverse:93) | optBlocks[0] verbatim 일치 | ✅ |
| specKw 오시/사이즈/높이/코팅/박 (reverse §7 도무송/오시) | specKw `{오시:1,사이즈:11,높이:4,코팅:2,박:2,용지:3}` | ✅ |
| OTPKFLT/HMN/ENV/ARP = 동일 슬롯·size 프리셋만 차이 (reverse:84-90) | 4 캡처 전건 동일 슬롯·프리셋 라벨/치수만 차이(FLT 324×331 등·ENV 봉투상자 중435×332/대597×446) | ✅ |
| OTPOCLP 클래퍼: paper[아트지·백색모조]·sodu[양면]·코팅 후가공 (reverse:110-132) | `paper:[아트지,백색모조]·sodu:[양면]·specKw 코팅:9·칼선:1` 일치·snip "코팅을 원치 않으면 백색모조" | ✅ |
| OTCPHOL 에어홀더 미캡처·unobserved (reverse:29,162) | captures/ 에 OTCPHOL 파일 부재 → 정직 표기 | ✅ honest-scope |

**판정 GO** — 6/7 대표샘플 캡처 전건 일치·날조/unsourced fragment 0·미캡처 1건(OTCPHOL) `unobserved` 정직 표기(fact로 포장 0).

---

## M2 — 메타모델 정합 (GO)

- O-1~O-4 facet은 `_resolved-fragments.md`에 명시 항목 10건(grep `O-[1-4]`=10)·`metamodel-dictionary.md` v12.0(:14)에 OT 통합·17축 재포화 명시.
- 귀속: O-1 3D치수→사이즈#13(파생)·O-2 dieline템플릿→#16 TemplateAsset·O-3 전개도2치수/도무송오시→사이즈#13+공정#2·O-4 박스형태→사이즈#13 프리셋+카테고리#7. **단일 상품 오버피팅 0** — 전부 평면 인쇄물(PR/NC) 공유 축으로 일반화·신규 dictionaried 축 0(17 유지).
- 관계 무모순: 박스 size 프리셋↔공정 칼틀/접지 게이팅이 ST 칼선#2·PR 접지#2 family와 동형(FK 충돌·composition 모순 0).

**판정 GO.**

---

## M3 — distinct 타당성 (GO·핵심)

### ① 전용 슬롯 부재 재검 (독립 실측)
캡처 5박스 selects = `paper·paper_sub_select·sodu·size·number2_sel·number1_sel` — **PR/NC 평면 인쇄물과 100% 동일 슬롯**(실측). 전개도·접지·3D·dieline 전용 select 슬롯 **0건**. ST가 가진 `shape_info` 같은 분리 슬롯 OT 부재. → ① 불충족 확정.

### ② KB 결함 부재 재검 (라이브 실측 — M4와 교차)
- 사이즈#13: `t_siz_sizes` work/cut/margin 8컬럼이 박스 재단/작업 2치수를 무손실 담음(66행 work≠cut 실데이터).
- 공정#2: 도무송/오시/접지 PROC family 라이브 실재.
- → "전개도를 어느 축에도 못 담는다"는 후니 결함 **미관측**. ST 형상(G-SK-2 "어느 축에도 없음")급 명시 결함 부재. ② 불충족 확정.

### 결정적 분기 비준
- **OT 전개도 #18**: ①전용슬롯 부재 + ②KB결함 부재 = **둘 다 불충족 → 부결** ✅
- ST 형상#17: ①shape_info 슬롯 실재 + ②G-SK-2 결함 = 둘 다 충족 → 승격. 정반대 패턴 일관.
- PH-2 거치·FS-1 타일링: ①OBSERVED·②불충족 = 부결. OT는 ①조차 불충족 = *더 약한 후보의 더 깨끗한 부결*. 기준 일관.

### #14 음의사례 타당성
reverse:93 "박스 조립=고객 수작업 → #14 형태가공(RP가 평면→입체 생성)의 반대". 캡처 optBlock "납작하게 접힌 상태 배송·고객 조립" 실측 확정. RP는 평면(전개도+칼선+오시)까지만 생산 → #14를 *요구하지 않음*(입체화 안 함)이라 새 vessel 압박 없음. #14 GAP(PD/GS 봉제)와 정합. **음의사례 타당**.

### 과소강등 적대 (진짜 새 축을 뭉갰나)
- 3D 입체치수: 선택 옵션 아님(표시 텍스트)·라이브 height 컬럼 부재이나 작업사이즈에서 비선형 파생 → 미저장 파생이 정답(별 축 아님). 과소강등 아님.
- 전개도(dieline): size 작업치수+공정 도무송/오시로 분배 흡수·전용 슬롯 0. 과소강등 아님.
- codex(deepcheck) 독립 동의: "Confirmed new axis: 없음" — 12번째 외부 재포화. contradiction 로그 0.

**판정 GO** — distinct 0 비준·전개도 #18 부결 정당·#14 음의사례 타당·과소강등 0.

---

## M4 — 갭 판정 정확 (GO·라이브 재실측 4쿼리)

후니 라이브 `information_schema` + 실데이터 직접 SELECT(읽기전용·POST/write 0).

| gap §XXIII/§13 주장 | 라이브 재측정 | 일치 |
|---|---|---|
| O-3: `t_siz_sizes`에 work_width/height·cut_width/height·margin_top/bot/lft/rgt 4종(8컬럼) 보유 | `information_schema.columns` → work_width·work_height·cut_width·cut_height·margin_top·margin_bot·margin_lft·margin_rgt **8컬럼 전건 실재** | ✅ |
| O-3: work≠cut 2치수 분리 등록 실데이터(SIZ_000007 A5 work150×212/cut148×210/margin1) | `SELECT … WHERE work<>cut` → SIZ_000007 정확 일치·work≠cut **66행**(gap "65행"=미세 −1 오차·결론 불변) | ✅ |
| O-1: 3D=height 컬럼 부재(미저장 파생 정답) | `t_siz_sizes` 전 컬럼 = siz_cd/siz_nm/work_*/cut_*/margin_*/impos_yn/use_yn/note/.../tags → **height(3D) 전용 컬럼 부재 확정**(work/cut_height는 2D 세로치수) | ✅ |
| O-3: 도무송칼틀/오시접지 = PROC_000029/090(오시)·056~074(접지)·050(형압)·079/092(타공) 실재 | `t_proc_processes WHERE proc_cd IN (…)` → 오시·형압·접지 family(2~8단/롤/병풍/미싱/6단오시접지)·타공 **전건 실재·인용 100% 정확** | ✅ |
| O-2: dieline=#16 TemplateAsset·`t_prd_templates`(tmpl_cd·base_prd_cd·tags) 그릇 보유 | `t_prd_templates` 컬럼 tmpl_cd·base_prd_cd·tmpl_nm·tags 실재·행수 **13행**(gap "12행"=미세 +1·PH/NC 게이트 12행과 시점차·결론 불변) | ✅ |

- **비존재 컬럼 인용 0**·**실재 그릇 GAP 오판 0**.
- 양면 검증: O-3 PASS의 양쪽(컬럼 존재 + 실데이터 work≠cut) 모두 라이브 확인. O-1 PASS 양쪽(height 부재 + 파생 정당성) 확인. data-gap(박스 siz 프리셋 미적재·dieline 좌표 미관측)은 dbmap/validator 라우팅 정확.

**판정 GO** — 라이브 재실측 4쿼리 전건 일치·미세 카운트 오차 2건(66 vs 65행·13 vs 12행)은 결론 무영향 Low.

---

## M5 — vessel 건전성 (GO)

- 신규 vessel **0건**(vessel-needs v12.0:16 "신규 vessel-gap = 0건"·OT facet 5항 전부 기존 V-항목/data-gap 흡수). V-11 TemplateAsset·V-12 형상 축 **불변**(누적 신규 테이블 mint 2건 유지). search-before-mint 통과(박스 차원이 기존 #13/#2/#16/#7로 표현됨을 라이브로 입증).
- **DC-1(structural dieline subtype) 라이브 부분 실측** (deepcheck/§13.2 "unobserved"라 표기했으나 실제 캡처됨):
  - makers `/v1/templates/OTPKCAK` 응답 표면 = `{list:[{template_uri(gcs JSON 포인터)·layout_uris:[]·unresolved_font_group_ids:[]·resource_id·token}]}`.
  - **응답 표면에 fold-line/glue-tab 좌표·cut/crease/perf line type·CAD export 필드 부재** → generic 디자인 시안 리소스 포인터(resource_id+token) 구조. structural dieline 좌표는 `template_uri`가 가리키는 gcs JSON 내부(1-hop 더 깊음·미해석).
  - **결론: 응답 표면=generic TemplateAsset과 동형 → V-11 subtype 1차 불요 판정 타당**(gcs 내부 미해석이라 완전 확정은 CONDITIONAL·정직 표기). DC-1은 vessel 신설 압박 아님·정밀화 검증 질문으로만 잔존.

**판정 GO** — 신규 mint 0·정규화/컨벤션 적합·V-11/V-12 불변·DC-1 응답 표면 실측이 부결 보강.

---

## M6 — 생성-검증 독립성 (GO)

- **self-approve 0**: reverse는 §7 "1차 예측(승격 판정은 metamodel/validator 몫)"로 판정권 위임. deepcheck는 "전 후보 unverified·finding 아님". gap/vessel은 생성자(architect/gap/vessel)가 작성·본 validator가 별도 재측정.
- **핵심 4주장 재유도(echo 아님)**: ① t_siz work/cut 컬럼 = 라이브 SELECT 직접 재query(생성자 인용 무신뢰) ② PROC family = proc_cd IN 직접 조회 ③ height 부재 = 전 컬럼 나열 재확인 ④ 캡처 일치 = JSON 원본 직접 파싱.
- **dodge-hunt 4건 (최리스크 깨기 시도)**:
  1. *전개도 #18 부결*: 캡처 5박스 슬롯이 평면 인쇄물과 동일함을 직접 확인 → 부결 견딤.
  2. *O-3 PASS*: 두 산출물 메커니즘 설명 불일치 발견(dictionary "size+plate_size 2축" vs §13 "단일행 work/cut") → 라이브 실측이 §13 정확 중재·둘 다 동일 PASS 결론 → 견딤(L-OT-1로 라우팅).
  3. *#14 음의사례*: optBlock "고객 조립" 실측·#14 GAP 정합 → 견딤.
  4. *distinct 0*: codex 독립 동의 + 라이브 KB 결함 부재 재확인 → 견딤.

**판정 GO.**

---

## 결함 (Low·FAIL 무관·소유자 라우팅)

| ID | 결함 | 위치 | 영향 | 라우팅 |
|---|---|---|---|---|
| **L-OT-1** | O-3 메커니즘 설명 불일치 — dictionary v12.0:14는 "재단=size#13 + 작업=plate_size **2 별개 축 분리 매핑**", gap-matrix §XXIII·_data-gaps §13은 "`t_siz_sizes` **단일 행 work/cut/margin** 직접 담음·plate_size 동원 불요". 라이브 실측=단일행 8컬럼이 직접 담음(§13 정확). dictionary 표현이 부정확하나 동일 PASS/부결 결론. | `02_metamodel/metamodel-dictionary.md:14` | 표현만·판정 무영향 | metamodel-architect(O-3 문구 단일화) |
| **L-OT-2** | "makers 응답 스키마 unobserved" 부정확 — reverse:171·deepcheck DC-1이 makers 응답을 unobserved로 표기했으나 응답 표면은 실제 캡처됨(`otherApis`에 5박스 전건·generic 포인터 스키마). 정확히는 "응답 표면=generic 포인터 캡처·gcs JSON 내부 dieline 좌표만 unobserved". | `categories/OT/reverse.md:171`·`deepcheck.md` DC-1 | 표현 정밀도·부결 결론 오히려 보강 | reverse-engineer(표기 정정·gcs 1-hop 명시) |

> 두 결함 모두 **distinct 0·전개도 부결·신규 vessel 0·M1~M6 GO 판정에 영향 없음**. NO-GO 사유 아님 → `_defects.md` 신규 등재 불요(Low note만).

## Phase 6.5 codex reconcile 베이스라인
- distinct #18 = **부결**(전용슬롯+KB결함 둘 다 불충족·라이브 실측 비준).
- t_siz work/cut/margin 컬럼 = **8컬럼 실재**·work≠cut 66행.
- PROC family(오시/접지/형압/타공) = 전건 실재·인용 정확.
- 신규 vessel = 0·V-11/V-12 불변.
- Low 표현 결함 2건(L-OT-1·L-OT-2)·FAIL 무관.
- (codex 비노출 — 본 판정이 reconcile 기준선)
