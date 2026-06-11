# 횡단 결함 종합 (crosscut-synthesis · round-13 메타)

> **작성** 2026-06-11 · round-13 메타. 11 family(10 디렉토리) GO된 correction-manifest를 가로질러 동종 finding을 패턴화. **신규 finding 날조 0** — 기존 GO finding만 종합. 라이브 SELECT는 종합 집계 검산용(신규 감사 아님). 비파괴(COMMIT/DDL/DELETE 0).
>
> **재료:** digital-print · goods-pouch · product-accessory · silsa · acrylic · stationery · sticker · booklet · photobook · calendar(+디자인캘린더). 각 family `correction-manifest.md` + `_gate/<family>-gate.md`(전건 GO·보정 반영분 채택).
>
> **검증된 카운트만 채택:** acrylic print_side 20·UV 14(F-AC-G1/G2 보정), digital-print 카테고리 정상노드 273/274/275/283(F-GATE-1 보정), stationery 카테고리 의미매칭(F-ST-G1 보정), photobook MAT_000186 6상품(validator 재실측). 본 메타가 라이브로 핵심 횡단 수치를 독립 재검산(§7).

---

## 0. 전체 finding 횡단/단발 분류 (요약)

11 family correction-manifest의 결함성 finding(CORRECT·CORRECT-경로불명 제외)을 3대 패턴축 + 추가 횡단 + family 단발로 분류했다.

| 구분 | 건수(인스턴스) | 영향 family 수 | 비고 |
|------|:--:|:--:|------|
| **① 카테고리 고아 오연결** | 9 family 인스턴스 | 9 | 14 고아 노드·113 상품(라이브 검산 §7) |
| **② MAT_TYPE.07~10 자재 오염** | 8 family 인스턴스 | 8 | MAT_000186 6상품 등 단일원인 다중오염 |
| **③ v03 정규화 진원** | 10 family 전반 | 10(전부) | load_master=전파기·진원=상류 v03 |
| **추가-A 코팅 Q9 정책 분산** | 4 family 인스턴스 | 4 | 공정 50상품 vs 자재 16+8상품 |
| **추가-B 레더 자재유형 .08/.01→.06** | 4 family 인스턴스 | 4 | ②의 특수 하위(.06 가죽 고아행 재연결) |
| **추가-C plate output_paper 적재경로** | 5 family 인스턴스 | 5 | 값정답·경로 퇴행 위험(.01↔.03) |
| **추가-D 봉투/케이스 세트 미적재(addon/sets)** | 3 family 인스턴스 | 3 | Q-ID-A 단일 모델 결정 |
| **추가-E MES_ITEM_CD NULL 정책** | 5 family 인스턴스 | 5 | load_master 의도 NULL·값정답 보존 |
| **추가-F page_rule 잡음(떡제본 3/3/3)** | 2 family 인스턴스 | 2 | booklet·stationery 동형 |
| **추가-G usage 슬롯 미분화(USAGE.07/01)** | 4 family 인스턴스 | 4 | 종이=내지/공통·본체/부속 코드 부재 |
| **추가-H CPQ 옵션 레이어 전면 미적재** | 6+ family | 6+ | round-6 트랙·횡단 구조 부재 |
| **추가-I 가격 미적재(prices 0행)** | 4 family 인스턴스 | 4 | round-2 트랙·포토북/디자인캘린더/문구/부자재 |
| **family 단발(정체별 고유)** | ~20 | 개별 | 미싱제본·보드마운팅·완칼전무·삼각대거치 등 |

> **핵심:** 결함의 다수는 family 고유가 아니라 **횡단 공통 진원**(v03 정규화 + 적재 로직의 구조적 한계)에서 나온다. 따라서 family별 개별 교정보다 **패턴축별 일괄 교정 + 일괄 컨펌**이 효율적이다(batch-confirmations.md·remediation-roadmap.md).

### 0-bis. 전 finding 1:1 전수 추적표 (X1 커버리지 완전성)

전 10 family correction-manifest의 **모든 finding을 1행=1 finding으로 전수** 추적. 각 행 = family · finding-id · 분류 · 귀속(횡단 패턴축 ①②③/추가 A~I · 또는 family-단발 · 또는 AMBIGUOUS-미해소 · 또는 CORRECT-유지). 무인용 누락 0 기계 보증(grep 전수 추출 기반). **[F-XC-1b 보정]** 개념 분류 → 1:1 행 추적으로 완성.

> **귀속 약어:** 횡단①=카테고리고아 · ②=MAT_TYPE오염 · ③=v03진원(전반·개별귀속은 1차축으로) · A=코팅Q9 · B=레더.06 · C=plate경로 · D=봉투세트 · E=MES · F=page잡음 · G=usage · H=CPQ · I=가격 · **단발**=family고유 · **AMB-미해소**=batch부록 보류 · **CORRECT**=유지(반증 포함).

#### digital-print (18)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| digital-print | C-01 | CORRECT | CORRECT(엽서 size 일치·round-12 "13종" 반증) |
| digital-print | C-02 | CORRECT | CORRECT(엽서 공정 일치) |
| digital-print | C-03 | CORRECT | CORRECT(usage.07 공통 정당)→추가-G(정당분) |
| digital-print | C-04 | MIS-LOADED | 추가-D(봉투 addon) |
| digital-print | C-05 | MIS-LOADED | 횡단①(상품권 카테고리 고아 295) |
| digital-print | C-06 | AMBIGUOUS | 단발(박 8색 부모 PROC_000033) |
| digital-print | C-07 | MISSING | 단발(배경지 전용 커팅 PROC_000053) |
| digital-print | C-08 | MISSING | 추가-D(배경지 봉투 세트) |
| digital-print | C-09 | MIS-LOADED | 횡단①(배경지/라벨택 카테고리 296) |
| digital-print | C-10 | MISSING | 단발(배경지 접지 PROC_000056) |
| digital-print | C-11 | MISSING | 추가-D(배경지 케이스 세트) |
| digital-print | C-12 | CORRECT | CORRECT(라벨택 size 일치) |
| digital-print | C-13 | MISSING | 단발(라벨택 형상 커팅) |
| digital-print | C-14 | MIS-LOADED | 횡단①(라벨택 카테고리 296→283) |
| digital-print | C-15 | CORRECT(경로불명) | 추가-E/③(qty_unit 값정답·경로불명) |
| digital-print | C-16 | CORRECT(경로불명) | 추가-C(plate output_paper 값정답·경로불명) |
| digital-print | C-17 | AMBIGUOUS | AMB-미해소(separator 하이픈/_) |
| digital-print | C-18 | AMBIGUOUS | AMB-미해소(배경지 자재 재확인) |

#### goods-pouch (17)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| goods-pouch | GP-C-01 | MIS-LOADED | 횡단①(카테고리 고아 35상품) |
| goods-pouch | GP-C-02 | EXTRA | 횡단①(잉여 고아 노드 6 논리삭제) |
| goods-pouch | GP-C-03 | MIS-LOADED | 횡단②(본체색×규격 폭증 .09) |
| goods-pouch | GP-C-04 | MIS-LOADED | 횡단②(형상/용량/잉크색=자재) |
| goods-pouch | GP-C-05 | MIS-LOADED | 횡단②(자재유형 .09 무차별 오염) |
| goods-pouch | GP-C-06 | MIS-LOADED | 단발(봉제→부착 공정 081→080·정체별 후가공) |
| goods-pouch | GP-C-07 | MISSING | 단발(봉제/에폭시/맥세이프 공정 0행) |
| goods-pouch | GP-C-08 | MISSING | 횡단②연계(만년스탬프 잉크색→도수) |
| goods-pouch | GP-C-09 | MISSING | 단발(볼체인/리필잉크 addon 재연결) |
| goods-pouch | GP-C-10 | MISSING | 추가-H(CPQ 옵션 레이어) |
| goods-pouch | GP-C-11 | CORRECT | CORRECT(치수형 size·기계삭제 금지) |
| goods-pouch | GP-C-12 | CORRECT | CORRECT(usage.07 공통)→추가-G(정당분) |
| goods-pouch | GP-C-13 | CORRECT | CORRECT(sets 0 정당) |
| goods-pouch | GP-C-14 | CORRECT | CORRECT(정상 노드 56상품) |
| goods-pouch | GP-C-15 | AMBIGUOUS | 추가-H(폰기종/등급 size↔option 경계) |
| goods-pouch | GP-C-16 | AMBIGUOUS | 단발(머그 ROOT lvl1 직결·①변종) |
| goods-pouch | GP-C-17 | CORRECT | CORRECT(MES NULL 신규)→추가-E(정당분) |

#### product-accessory (14)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| product-accessory | PA-01 | MIS-LOADED | 횡단①(카테고리 고아 293·15상품) |
| product-accessory | PA-02 | MIS-LOADED | 횡단②(색상 variant .10·006/015) |
| product-accessory | PA-03 | MISSING | 추가-I(부자재 가격) |
| product-accessory | PA-04 | MISSING | 추가-D(봉투 세트) |
| product-accessory | PA-05 | MISSING | 단발(묶음수 bundle) |
| product-accessory | PA-06 | MIS-LOADED | 단발(사이즈 치수×묶음 평면화) |
| product-accessory | PA-07 | AMBIGUOUS | 단발(카드봉투 색상·이중등록 역할) |
| product-accessory | PA-08 | MIS-LOADED | 횡단②(색상 variant .10·007/010·GATE-1) |
| product-accessory | PA-09 | MIS-LOADED | 단발(묶음 단위 EA/매 혼선) |
| product-accessory | PA-10 | MIS-LOADED | 단발(siz_nm 묶음수 잔존) |
| product-accessory | PA-11 | AMBIGUOUS | 단발(천정고리 use_yn=N) |
| product-accessory | PA-12 | CORRECT(의도) | CORRECT(이중등록 의도·09_delete 제외) |
| product-accessory | PA-13 | AMBIGUOUS | 단발(우드 길이 variant) |
| product-accessory | PA-14 | CORRECT(경로불명) | 추가-E/③(MES/qty_unit 값정답·경로불명) |

#### silsa (14)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| silsa | C-01 | MIS-LOADED | 횡단①(카테고리 고아 298·28상품) |
| silsa | C-02 | CORRECT | CORRECT(size 면적매트릭스·round-9 오판 반증) |
| silsa | C-03 | CORRECT | CORRECT(usage.07 공통)→추가-G(정당분) |
| silsa | C-04 | MIS-LOADED | 횡단②/B(패브릭→.05·레더→.06) |
| silsa | C-05 | CORRECT | 추가-A(코팅=공정 정합·옵션) |
| silsa | C-06 | MISSING | 추가-H(봉제/족자 variant→CPQ) |
| silsa | C-07 | MISSING | 단발(보드마운팅 공정 마스터 부재) |
| silsa | C-08 | MISSING | 단발(부속 addon 재연결) |
| silsa | C-09 | CORRECT(경로불명) | 추가-E(MES 값정답·경로불명) |
| silsa | C-10 | CORRECT(경로불명) | 추가-C(qty_unit/plate 값정답·경로불명) |
| silsa | C-11 | AMBIGUOUS | 단발(수량 L1 원본 빈값) |
| silsa | C-12 | AMBIGUOUS | AMB-미해소(보드 소재 빈값) |
| silsa | C-13 | CORRECT | CORRECT(투명포스터★ 비활성 정당) |
| silsa | C-14 | AMBIGUOUS | 단발(액자 귀속 공정 vs 부속) |

#### acrylic (22)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| acrylic | AC-C1 | CORRECT | CORRECT(두께 자재 일치) |
| acrylic | AC-C2 | CORRECT | CORRECT(부속 자재 다행) |
| acrylic | AC-C3 | CORRECT | CORRECT(UV 14상품 PROC_000002) |
| acrylic | AC-C4 | CORRECT | CORRECT(조각수 bundle) |
| acrylic | AC-C5 | CORRECT | CORRECT(nonspec 범위) |
| acrylic | AC-C6 | CORRECT | CORRECT(qty_unit backfill) |
| acrylic | AC-C7 | CORRECT | CORRECT(형상부기 siz·OM-7) |
| acrylic | AC-C8 | CORRECT | CORRECT(size 차원 work>cut) |
| acrylic | AC-M1 | MIS-LOADED | 단발(print_side에 UV변형 오적재 20상품) |
| acrylic | AC-M2 | MIS-LOADED | 추가-G(본체/부속 usage 미분화 .07) |
| acrylic | AC-M3 | MIS-LOADED | 단발(상품별 인쇄변형 무시·AC-M1 쌍) |
| acrylic | AC-X1 | MISSING | 단발(완칼 PROC_000053 전 아크릴 0건) |
| acrylic | AC-X2 | MISSING | 횡단②연계/단발(부착공정 PROC_000081 부분) |
| acrylic | AC-X3 | MISSING | 단발(활성상품 UV 미연결 154/169) |
| acrylic | AC-X4 | MISSING | 단발(카라비너 고리 7색) |
| acrylic | AC-X5 | MISSING | 단발(네임택 와이어링/스트랩) |
| acrylic | AC-X6 | MISSING | 단발(완칼 조각수 param·AC-X1 종속) |
| acrylic | AC-R1 | REMOVED | 단발(볼체인 addon 소실·Phase7 tmpl) |
| acrylic | AC-A1 | AMBIGUOUS | 단발(입체블럭 라미10T 자재) |
| acrylic | AC-A2 | AMBIGUOUS | AMB-미해소/단발(입체코롯토 전 속성 0·외주 미정) |
| acrylic | AC-A3 | AMBIGUOUS | 추가-H(볼펜색/지비츠 variant) |
| acrylic | AC-A4 | AMBIGUOUS | 단발(★상품 정체·미등록) |

#### stationery (18)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| stationery | ST-01 | MIS-LOADED | 횡단①(플래너 카테고리 고아 300) |
| stationery | ST-02 | MIS-LOADED | 추가-G(종이 usage.07→.01 내지) |
| stationery | ST-03 | MIS-LOADED | 추가-A(코팅 평면화 분해) |
| stationery | ST-04 | AMBIGUOUS | 횡단②/B(레더 .08→.06) |
| stationery | ST-05 | MIS-LOADED | 단발(떡제본 mand 혼재 097/179) |
| stationery | ST-06 | MISSING | 단발(미싱제본 신규 mint) |
| stationery | ST-07 | MIS-LOADED | 추가-F(page_rule 잡음 3/3/3) |
| stationery | ST-08 | MISSING | 단발(만년다이어리 면지 자재) |
| stationery | ST-09 | MISSING | 단발(스프링노트 실버링 자재) |
| stationery | ST-10 | MISSING | 단발(만년다이어리 PVC커버 자재) |
| stationery | ST-11 | MISSING | 단발(내지/합지보드 자재) |
| stationery | ST-12 | MISSING | 단발(B셋트 sub_prd/sets) |
| stationery | ST-13 | MISSING | 추가-I(문구 가격) |
| stationery | ST-14 | MISSING | 단발(레더소프트 공정 전 누락) |
| stationery | ST-15 | AMBIGUOUS | 추가-F연계/단발(bundle dflt 중복) |
| stationery | ST-16 | AMBIGUOUS | 추가-C(폴더 output_paper) |
| stationery | ST-17 | CORRECT(의도) | CORRECT(준비중 보류) |
| stationery | ST-18 | CORRECT | CORRECT(떡메모 sub_prd) |

#### sticker (17)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| sticker | C-ST-01 | CORRECT | CORRECT(size 일치) |
| sticker | C-ST-02 | MIS-LOADED | 횡단①(카테고리 root 직결 16상품) |
| sticker | C-ST-03 | CORRECT | CORRECT(합판도무송 형상=size·Q7 반증) |
| sticker | C-ST-04 | MIS-LOADED | 추가-A(코팅=자재 8상품) |
| sticker | C-ST-05 | MISSING | 추가-H(조각수 param·ref_param_json) |
| sticker | C-ST-06 | MISSING | 추가-H(규격형 형상 param) |
| sticker | C-ST-07 | MISSING | 단발(063 화이트 underbase) |
| sticker | C-ST-08 | MISSING | 추가-E(MES NULL) |
| sticker | C-ST-09 | MIS-LOADED | 횡단②(자재유형 .01→.11 스티커) |
| sticker | C-ST-10 | MIS-LOADED | 단발(자재명 절단 유포지+엠보) |
| sticker | C-ST-11 | MIS-LOADED | 단발(커팅 mand_proc_yn N→Y) |
| sticker | C-ST-12 | EXTRA | 단발(066 빈 옵션그룹 논리삭제) |
| sticker | C-ST-13 | MISSING | 단발(스티커팩 세트 구성) |
| sticker | C-ST-14 | CORRECT | CORRECT(화이트 053/4/6) |
| sticker | C-ST-15 | CORRECT | CORRECT(도수 단면 4도) |
| sticker | C-ST-16 | AMBIGUOUS | 추가-C(plate output_paper/file) |
| sticker | C-ST-17 | CORRECT | CORRECT(타투/팩 공정 0 정당) |

#### booklet (13)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| booklet | BK-1 | MIS-LOADED | 추가-G(097 usage.07 동일 mat 복제) |
| booklet | BK-2 | MIS-LOADED | 단발(sub_prd 078 몽블랑 잡음·최위험) |
| booklet | BK-3 | AMBIGUOUS | 횡단②/B(레더 .08→.06) |
| booklet | BK-4 | EXTRA | 횡단①(097 카테고리 2중) |
| booklet | BK-5 | EXTRA | 횡단①(CAT_000297 가이드 고아) |
| booklet | BK-CAT | EXTRA | 횡단①(전용 잎노드 미사용·root 직결) |
| booklet | BK-6 | AMBIGUOUS | 단발(레더바인더 088 후공정 불명) |
| booklet | BK-7 | MISSING | 추가-C(plate output_paper NULL) |
| booklet | BK-8 | EXTRA | 추가-F(page_rule 3/3/3 잡음) |
| booklet | BK-9 | CORRECT | CORRECT(택일그룹 불요·1:1) |
| booklet | BK-10 | CORRECT | CORRECT(코팅 0행·round-11 반증) |
| booklet | BK-11 | CORRECT(의도) | CORRECT(MES NULL)→추가-E(정당분) |
| booklet | BK-12 | CORRECT | CORRECT(박색 공정 자식·Q2 검증) |

#### photobook (17 · PB-M3→PB-A2 재분류 반영)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| photobook | PB-C1 | MIS-LOADED | 횡단②/B(레더 .01/.08→.06·6상품 횡단) |
| photobook | PB-C2 | MIS-LOADED | 추가-A(아트250+무광코팅 평면화) |
| photobook | PB-C3 | MIS-LOADED | 단발(PUR 제본 mand N→Y) |
| photobook | PB-C4 | CORRECT(경로불명) | 추가-E/③(qty_unit 값정답·경로불명) |
| photobook | PB-M1 | MISSING | 추가-I(가격 전체 미적재) |
| photobook | PB-M2 | MISSING | 추가-A(무광코팅 공정 미연결·PB-C2 연동) |
| photobook | PB-A1 | AMBIGUOUS/GAP | 단발(표지 펼침 작업사이즈 미연결) |
| photobook | PB-A2 | AMBIGUOUS/GAP | 단발(소프트/레더 page_rule 엑셀 공란·F-PB-1) |
| photobook | PB-OK-1 | CORRECT | CORRECT(1상품 모델·폭증 없음) |
| photobook | PB-OK-2 | CORRECT(반증) | 횡단①(카테고리 고아 부재 반증) |
| photobook | PB-OK-3 | CORRECT | CORRECT(size 4 variant) |
| photobook | PB-OK-4 | CORRECT | CORRECT(내지/면지/하드/소프트 자재) |
| photobook | PB-OK-5 | CORRECT | CORRECT(도수 정합) |
| photobook | PB-OK-6 | CORRECT | CORRECT(인쇄옵션 2) |
| photobook | PB-OK-7 | CORRECT | CORRECT(반제품 빈 껍데기) |
| photobook | PB-OK-8 | CORRECT | CORRECT(책등 미저장·앱 런타임) |
| photobook | PB-OK-9 | CORRECT | CORRECT(수량/채널/MES) |

#### calendar + 디자인캘린더 (20)
| family | finding-id | 분류 | 귀속 |
|--------|-----------|------|------|
| calendar | C-CAL-01 | MIS-LOADED | 횡단②(삼각대=자재→공정) |
| calendar | C-CAL-02 | MIS-LOADED | 횡단②(링=자재→트윈링 param) |
| calendar | C-CAL-03 | EXTRA | 횡단②(탁상/미니 링 잉여 논리삭제) |
| calendar | C-CAL-04 | MIS-LOADED(경로) | 추가-C(plate 적재경로 .01 퇴행) |
| calendar | C-CAL-05 | MISSING | 추가-H(장수 옵션) |
| calendar | C-CAL-06 | MISSING | 추가-H(캘린더가공 택일그룹) |
| calendar | C-CAL-07 | MISSING | 단발(삼각대거치 공정 마스터 부재) |
| calendar | C-CAL-08 | MISSING | 추가-D(봉투 addon) |
| calendar | C-CAL-09 | MISSING | 단발(우드거치대 자재·Q13) |
| calendar | C-DC-10 | MISSING(MISMATCH) | 단발(디자인 editor_yn=Y surface) |
| calendar | C-DC-11 | MISSING | 추가-I(디자인 고정가) |
| calendar | C-DC-12 | AMBIGUOUS | 단발(디자인캘린더 종이 권위) |
| calendar | C-CAL-13 | MISSING | 추가-E(MES 007-0001~5) |
| calendar | C-CAL-14 | AMBIGUOUS | 단발(미니 카테고리 112 vs 113) |
| calendar | OK-1 | CORRECT | CORRECT(size 변형 커버리지·D-1 반증) |
| calendar | OK-2 | CORRECT | CORRECT(도수) |
| calendar | OK-3 | CORRECT | CORRECT(plate 값) |
| calendar | OK-4 | CORRECT(반증) | 횡단①(카테고리 고아 부재 반증) |
| calendar | OK-5 | CORRECT | CORRECT(prd_typ_cd 디자인상품) |
| calendar | OK-6 | CORRECT | CORRECT(디자인=같은 상품 surface) |
| calendar | OK-7 | CORRECT | CORRECT(트윈링/타공 공정) |

#### 검산 — family별 finding 수 (전수 1:1)
| family | 행수 | 결함성(CORRECT 제외) |
|--------|:--:|:--:|
| digital-print | 18 | 13 |
| goods-pouch | 17 | 11 |
| product-accessory | 14 | 11 |
| silsa | 14 | 8 |
| acrylic | 22 | 14 |
| stationery | 18 | 16 |
| sticker | 17 | 11 |
| booklet | 13 | 8 |
| photobook | 17 | 8 |
| calendar | 21 | 13 |
| **합계** | **171** | **113** |

> **검산 해설:** 전수 1:1 행 = **171 finding**(CORRECT/CORRECT-경로불명/반증 포함). 결함성(CORRECT 계열 제외) = **113건**. 사용자 표기 "67"은 메타 착수 시 핵심 결함성 추정치였으나, **전수 추출 결과 결함성 113·전 finding 171**이 정확. **calendar 21**=§1 메인 표 C-CAL/C-DC 14 + §2 별도 CORRECT 표 OK-1~7 7행(manifest 분류 분포 요약 "합계 20"은 §1만 카운트해 OK-1~7 7건을 누락한 표기였음 — 전수 추적에서는 OK-1~7도 실재 finding이라 21이 정확). **validator 지목 미귀속 14건(GP-C-06·C-ST-10/11/12·ST-05/10/11/12/14·AC-M1/M3/X2/X3/X5/X6/A2) 전건 위 표에 명시 귀속 완료.** finding-id 중복 0·무인용 누락 0(grep 전수 추출 기반 기계 보증).

---

## ① 카테고리 고아 오연결 [9 family·14 노드·113 상품]

### ①-1 정의·진단
상품이 **전용 잎노드(정상·올바른 상위 트리에 위상 연결됨)** 대신 **잉여 고아 노드(upr_cat_cd=NULL·lvl3)**에 직결되어, 정작 전용 카테고리는 상품 0의 고아가 되는 패턴. 진원은 `load_categories`(load_master.py:164-178, 특히 :171 NULL·:175 UPDATE)가 v03 `11_상품별카테고리` 시트의 `구분` 라벨을 별도 고아 노드로 생성하고 `load_rel_categories`(:282-291)가 상품을 거기 연결하기 때문(L-H/L-PA-B/L-ST-C/L-SL-C 동형).

### ①-2 라이브 검산 — 잉여 고아 노드 전수 (§7-1 재현)
`SELECT … WHERE upr_cat_cd IS NULL AND cat_lvl>=2`로 14개 잉여 고아 노드 확정:

| 고아 노드 | cat_nm | 연결 상품 | 영향 family | 정상 재연결 대상 노드 |
|-----------|--------|:--:|------|----------------------|
| CAT_000293 | 상품악세사리 | 15 | product-accessory | 276(봉투/케이스)·285(자석)·287(부속) |
| CAT_000294 | 명함 | 10 | digital-print(명함) | (정상 명함 노드 — Q확인) |
| CAT_000295 | 상품권 | 2 | digital-print(상품권) | 03 인쇄홍보물 하위(Q확인) |
| CAT_000296 | 배경지 | 4 | digital-print(배경지/라벨택) | 273(배경지OPP)·274(케이스)·275(헤더택)·283(라벨) |
| CAT_000297 | 레드프린팅 책자 가이드 | 0 | booklet(BK-5) | (상품 아님·논리삭제) |
| CAT_000298 | 실사 | 28 | silsa | 067~099(상품명별 정상노드) |
| CAT_000299 | 단품형 | 14 | goods-pouch/sticker(추정) | (정상 굿즈/스티커 노드) |
| CAT_000300 | 플래너 | 5 | stationery | 119~123(커버타입 의미매칭) |
| CAT_000301 | 소품 | 5 | goods-pouch | 정상 굿즈 노드 |
| CAT_000302 | 데스크/사무용품 | 9 | goods-pouch | 정상 굿즈 노드 |
| CAT_000303 | 디지털악세서리 | 2 | goods-pouch | 정상 굿즈 노드 |
| CAT_000304 | 말랑(PVC고주파) | 9 | goods-pouch | 정상 굿즈 노드 |
| CAT_000305 | 레더파우치 | 9 | goods-pouch | 213~221(레더 정상노드) |
| CAT_000306 | 에코백부자재 | 1 | goods-pouch | 정상 굿즈 노드 |
| **합계** | | **113** | **9 family** | |

> **추가 패턴(같은 진원·다른 증상):** sticker는 16상품이 잉여 고아가 아니라 **CAT_000002(lvl1 root)** 직결(C-ST-02, 정상노드 030~047 두고)·booklet은 068~071이 **CAT_000006(lvl1) 직결**·077/082가 상위노드에 묶이고 전용 잎노드(CAT_000100~103/106/107) 상품 0(BK-CAT). **root 직결도 동일 진원의 변종** — 별도 고아 노드는 안 만들었으나 "전용 잎노드 미사용"은 동일.

### ①-3 family별 인스턴스 집계
| family | finding-id | 분류 | 대상 노드 | 상품 수 |
|--------|-----------|------|----------|:--:|
| digital-print | C-05·C-09·C-14 | MIS-LOADED | 295·296 | 6(041/042/043/044/045/046) |
| goods-pouch | GP-C-01·GP-C-02 | MIS-LOADED/EXTRA | 301·302·303·304·305·306·299 | 35+(고아 6노드) |
| product-accessory | PA-01 | MIS-LOADED | 293 | 15 |
| silsa | C-01 | MIS-LOADED | 298 | 28 |
| stationery | ST-01 | MIS-LOADED | 300 | 5 |
| sticker | C-ST-02 | MIS-LOADED | CAT_000002(root) | 16 |
| booklet | BK-5·BK-CAT | EXTRA | 297·전용잎노드 6 | 6+ |
| photobook | PB-OK-2 | CORRECT(반증) | — | 0(고아 없음=반례) |
| calendar | OK-4 | CORRECT(반증) | — | 0(고아 없음=반례) |
| acrylic | — | (해당 없음) | — | — |

> **반례 2 family(photobook·calendar)는 고아 0** — 패턴 미해당. 정체가 명확한 일반 인쇄물/디자인상품은 정상 노드 연결됨. **고아 패턴은 정체 오분류(포장재·굿즈 잎노드)와 강한 상관.**

### ①-4 통합 교정 방향 (search-before-mint)
1. **정상 잎노드는 전부 실재**(273/274/275/283·067~099·119~123·030~047·213~221 등 라이브 확인) → **신설 0·재연결만**.
2. 상품을 `t_prd_product_categories` cat_cd UPDATE로 의미 매칭 정상노드에 재연결(stationery F-ST-G1 교훈: prd_cd순≠노드발급순 → **커버타입/상품명 의미로 매칭**, 기계적 순차 금지).
3. 재연결 후 잉여 고아 노드는 `use_yn='N'` 논리삭제(hard-delete 금지). CAT_000297(상품 0)은 즉시 논리삭제 안전.
4. 정상노드 미발견 일부(명함 294·상품권 295·굿즈 단품형 299 등)는 정상 트리 확인 후 재연결 — **Q확인 필요**(batch Q-CAT).

---

## ② MAT_TYPE.07~10 자재 오염 [8 family]

### ②-1 정의·진단
색·형상·용량·부속(삼각대·링·끈·핀·자석 등)·실사소재·레더가 **자재 행**(MAT_TYPE.07 부속·.08 실사소재·.09 파우치·.10 악세사리)으로 적재된 패턴. 정규화 원칙(메모리 dbmap-material-option-normalization ★HARD: 색상≠자재·형상→규격·본체색→재질 합성·부속→공정 PROC)에 위배. 진원은 v03 `05_자재정보`·`14_상품별자재` 시트가 비소재 속성을 자재 행으로 인코딩하고 load_materials(:236/:237)가 충실 전파(L-PA-D/L-A 동형).

### ②-2 라이브 검산 — 오염 자재 영향 범위 (§7-2 재현)
| mat_typ_cd | 자재 행수 | 연결 상품 수 | link 행수 | 주 오염 family |
|-----------|:--:|:--:|:--:|------|
| MAT_TYPE.07 부속 | 33 | (정상부속 일부) | | acrylic(부속) — 일부 정당 |
| MAT_TYPE.08 실사소재 | 22 | 36 | 42 | silsa(소재)·레더 오염(MAT_000186 6상품) |
| MAT_TYPE.09 파우치 | 75 | 58 | 120 | goods-pouch(무차별 오염 핵심) |
| MAT_TYPE.10 악세사리 | 43 | 8 | 29 | product-accessory(색상 오염) |

### ②-3 family별 인스턴스 집계
| family | finding-id | 분류 | 오염 대상 | mat_typ | 정규화 방향 |
|--------|-----------|------|----------|:--:|------|
| goods-pouch | GP-C-03·04·05 | MIS-LOADED | 본체색×규격 폭증·형상/용량/잉크색·무차별 .09 | .09 | 색→재질합성(2행)·규격→option·용량→siz·잉크색→도수·mat_typ 소재별 정정 |
| product-accessory | PA-02·PA-08 | MIS-LOADED | 색상 variant(볼체인8·리필잉크7·와이어링3·행택끈3) | .10 | 색상→option_items·묶음/용량 분리 |
| silsa | C-04 | MIS-LOADED | 패브릭/가죽 6상품(.08) | .08 | 원단→.05·레더→.06 |
| acrylic | AC-M2 | MIS-LOADED | usage 미분화(.07 공통) + 부속 .07 | .07 | mat_typ로 본체/부속 식별 가능·usage 코드 도메인 컨펌 |
| calendar | C-CAL-01·02·03 | MIS-LOADED/EXTRA | 삼각대(.07)·링(.07) | .07 | 삼각대→공정·링→트윈링 param·탁상/미니 링 잉여 논리삭제 |
| booklet | BK-3 | AMBIGUOUS | 레더(.08) | .08 | →.06 가죽(고아행 재연결) |
| photobook | PB-C1 | MIS-LOADED | 레더(.01·.08) | .01/.08 | →.06(mat_typ만 UPDATE) |
| stationery | ST-04 | AMBIGUOUS | 레더(.08) | .08 | →.06(고아행 재연결) |
| sticker | C-ST-09 | MIS-LOADED | 비코팅/미색/투명/타투(.01→.11) | .01 | →.11 스티커(점착지) |

### ②-4 단일 원인 다중 상품 오염 (Top 3)
라이브 검산으로 확정한 "한 자재 행이 여러 상품을 동시 오염":

| 순위 | 자재 | 현 mat_typ | 정답 | 오염 상품 수 | 영향 family |
|:--:|------|:--:|:--:|:--:|------|
| **1** | **MAT_000186 레더(화이트)** | .08 실사소재 | .06 가죽 | **6**(책자77·링바인더88·포토북100·레더아트프린트126[CAT_000298 실사]·다이어리174/175) | booklet·photobook·silsa·stationery 4 family 횡단 |
| **2** | **MAT_TYPE.09 파우치 풀** | .09 | 소재별(.05/.04/.02 등) | **58상품**(120 link) | goods-pouch(자재구분 v03 "파우치" 오기) |
| **3** | **MAT_000260 아트250+무광코팅** | .01(코팅 평면화) | 아트250(.01)+무광공정 | **7**(+250=1, 합 8) | stationery·photobook(코팅 평면화·추가-A 연계) |

> **MAT_000186이 가장 시급한 횡단 1건**(§5): 4 family를 가로지르는 단일 자재 행 1개의 mat_typ UPDATE(`.08→.06`)가 6상품의 생산 BOM·라우팅을 동시 교정. **단 6상품 일괄 영향 확인 후 적용**(photobook 컨펌-Q1·booklet Q-BK-A·stationery Q-ST-D·silsa C-04 통합).

### ②-5 통합 교정 방향
- **색상→option_items**(메모리 ★HARD): goods-pouch 본체색·product-accessory 색상 variant. CPQ 옵션(round-6).
- **형상→규격(siz)·용량→비치수 siz·잉크색→도수**: 비소재 자재행 논리삭제 후 정확 축 신규.
- **부속→공정 PROC**: 삼각대거치(calendar)·아일렛/박는 타공(메모리 dbmap-option-material-process-bundle: 자재+공정 2축).
- **레더 .08/.01→.06**: mat_typ UPDATE 또는 .06 고아행(MAT_000008/173~175, 전부 linked=0 검산) 재연결 — **search-before-mint(신설 0)**.
- **mat_typ 정정만**(재연결 불요): MAT_000186·sticker 점착지 4자재.

---

## ③ v03 정규화 진원 [10 family 전부]

### ③-1 정의·진단
모든 MIS-LOADED·다수 MISSING의 **진짜 진원은 상류 v03 정규화 단계**(`data/raw/prdmaster_full_migration_v03_20260518.xlsx`, 레포 미동봉). `load_master.py`는 변환 로직 없는 **순수 전파기** — v03 행을 t_*로 충실 옮길 뿐. [HARD 사용자 directive] v03=상품마스터 미분석 오류 多·정답 참조 금지. **정답 기준=상품마스터 원본 L1**. load_master를 고칠 게 아니라 v03 정규화 또는 하류 DB를 L1 권위로 교정.

### ③-2 진원 분기: v03 결함 vs load_master 코드 결함 vs 적재경로 불명
| 진원 유형 | 정의 | 인스턴스 예 | 교정 방향 |
|-----------|------|-----------|----------|
| **v03 정규화 결함** | v03 시트가 잘못 인코딩(자재화·고아·평면화·필수성 N) | 대다수 MIS-LOADED(코팅=자재·색상=자재·카테고리 고아·레더 슬러그 분할·복합표기 평면화) | **상품마스터 L1 권위 델타**(round-5/6/10) |
| **load_master 코드 결함** | load_master 코드 자체가 값 손실 | MES_ITEM_CD None 강제(:261)·output_paper 무조건 .기타(:340/346)·하드코딩 ACRYLIC print_side(:357-369) | 코드 정합화 제안(C-CAL-04 plate 매핑 추가) |
| **적재경로 불명(finding)** | 라이브 값이 load_master로 재현 불가(후속 backfill) | qty_unit·plate .01·MES 일부 채움(C-15/16·PB-C4·PA-14) | 값 정답이라 유지·**재적재 시 NULL 회귀 주의**(load_master --all 위험) |

### ③-3 family별 v03 진원 인스턴스 (대표)
| family | v03 진원 결함 | load_master 코드 결함 | 적재경로 불명 |
|--------|------|------|------|
| digital-print | 카테고리 고아·봉투 세트 미파싱 | output_paper·qty_unit | C-15·C-16 |
| goods-pouch | 자재구분 "파우치"·본체색·size→option 미적용 | (대부분 v03) | MES NULL(GP-C-17) |
| product-accessory | 색상=자재·카테고리 고아·사이즈 평면화 | MES/qty_unit None | PA-14 |
| silsa | 카테고리 고아·레더 .08·봉제/족자 축약 | qty_unit·output_paper | C-09·C-10 |
| acrylic | usage 빈값·완칼 미부여·UV 부분 누락 | print_side 하드코딩 | qty_unit(AC-C6) |
| stationery | 카테고리 고아·종이 usage 공란·미싱제본 부재·코팅 평면화 | — | (대부분 v03) |
| sticker | 코팅=자재·조각수 미전개·063 화이트 누락·자재유형 혼재 | MES NULL | plate .03 |
| booklet | sub_prd 078 잡음·떡메모 카테고리 2중·page 3/3/3 placeholder | MES NULL·output_paper | — |
| photobook | 레더 슬러그 분할·복합표기 평면화·PUR 필수성 N | — | PB-C4 qty_unit |
| calendar | 삼각대/링 자재 평면화 | output_paper(plate .01 퇴행)·MES None | plate 적재경로 |

> **결론:** 10 family **전부** v03 진원 결함 보유. load_master 코드 결함은 소수(MES None·output_paper·acrylic 하드코딩)에 한정. **교정 트랙은 "상품마스터 L1 권위 델타"가 기본**이며, v03 상류 수정은 webadmin 팀 영역(batch Q-V03).

---

## 추가-A. 코팅 Q9 정책 분산 [4 family]

### 정의·진단·검산 (§7-3)
실무진 Q9★=**코팅=공정**. 그러나 라이브 적재가 family마다 다름:
- **공정으로 적재(정합)**: PROC_000014 유광 **21상품** + PROC_000015 무광 **29상품**(책자·캘린더·실사·아크릴·문구 일부 — 라이브 검산).
- **자재로 오적재(스티커)**: MAT_000155 무광코팅스티커 **8상품** + MAT_000156 유광 **8상품**(C-ST-04).
- **자재명 평면화(코팅이 자재명에 흡수)**: MAT_000250(1)+MAT_000260(7)="아트250+무광코팅" **8상품**(stationery ST-03·photobook PB-C2).

| family | finding-id | 코팅 적재 형태 | 분류 | 통일 방향 |
|--------|-----------|------|------|------|
| booklet | BK-10 | 공정 0행(코팅 없음=정답) | CORRECT | (해당없음) |
| stationery | ST-03·Q-ST-E | 자재명 평면화(아트250+무광코팅) | MIS-LOADED | 자재(아트250)+공정(PROC_000015) 분해 |
| photobook | PB-C2·PB-M2 | 자재명 평면화 + 공정 미연결 | MIS-LOADED/MISSING | 자재명 정정 + PROC_000015 연결 |
| sticker | C-ST-04·Q-ST-A | 코팅스티커 자재(MAT_000155/156) | MIS-LOADED | **CONFLICT**: Q9=공정 vs round-11 "점착지 표면사양=자재 variant 정당" vs 가격모델(3컬럼) |

### 통합 교정 방향
Q9 권위(공정) 통일이 원칙이나 **스티커는 CONFLICT 미해소**(Q-ST-A): 코팅별 단가(가격표 비코팅/무광/유광 3컬럼)를 공정 단가로 옮기는 비용 + round-11 "완제 점착지" 입장. → **batch Q-COAT 단일 결정점**으로 묶어 "코팅=공정 전면 통일(스티커 자재행 정리+가격엔진 공정단가)" vs "스티커만 자재 예외" 결정.

---

## 추가-B. 레더 자재유형 .08/.01→.06 [4 family]
②의 특수 하위. MAT_000186(.08)·MAT_000006(.01)이 6상품(책자77·링바인더88·포토북100·레더아트프린트126[실사]·다이어리174/175) 횡단 연결(§7-2 검산). 정답=.06 가죽. **.06 고아행 4개(MAT_000008/173/174/175) 전부 linked=0**(재연결 후보 실재·신설 0).

| family | finding-id | 상품 | 현 자재/유형 | 교정 |
|--------|-----------|------|------|------|
| booklet | BK-3·Q-BK-A | 077·088 | MAT_000186 .08 | (a).08유지 (b).06 고아행 재연결 (c).06신설(불요) |
| photobook | PB-C1·컨펌-Q1 | 100 | MAT_000006 .01·MAT_000186 .08 | mat_typ만 .06 UPDATE(재연결 아님) |
| stationery | ST-04·Q-ST-D | 174·175 | MAT_000186 .08 | booklet Q-BK-A 통합 |
| silsa | C-04 | 레더(화이트) | MAT_000186 .08 | →.06 mat_typ UPDATE |

> **방식 분기 주의(검증자 교훈):** photobook은 "연결행이 이미 포토북용 → mat_typ만 UPDATE"·booklet/stationery는 "고아행 재연결" — **MAT_000186 단일 행을 6상품이 공유**하므로 .08→.06 UPDATE 1회가 6상품에 동시 영향. **단 booklet/stationery가 MAT_000186을 .06 고아행으로 재연결하면 MAT_000186은 .08로 남아야**(silsa/photobook이 여전히 쓸 수 있음). → **batch Q-LEATHER 단일 결정**(mat_typ UPDATE vs 재연결, MAT_000186 운명 일괄).

---

## 추가-C. plate output_paper 적재경로 [5 family]
값은 정답·**적재경로가 load_master로 재현 불가**(후속 plate 교정 c722c24 산물). 재적재 시 `.01→.03` 퇴행 위험(calendar C-CAL-04).

| family | finding-id | 분류 | 라이브 | 위험 |
|--------|-----------|------|------|------|
| calendar | C-CAL-04·CL-C | MIS-LOADED(경로) | .01/.03 값정답 | load_master 재적재 시 .03 퇴행 |
| digital-print | C-16 | CORRECT(경로불명) | .01 | 경로 비공식 |
| silsa | C-10 | CORRECT(경로불명) | .기타 | 정합 |
| sticker | C-ST-16 | AMBIGUOUS | .03/NULL 혼재 + output_file 메타 침입 | output_file `*아이마크` 정리 |
| booklet/stationery | BK-7·ST-16 | MISSING/AMBIGUOUS | NULL | 폴더→output_paper vs 생산메타(견적밖) |

> **통합:** load_master `load_rel_plate_sizes`에 치수→계열 매핑(316x467→.01·330x660→.03) 추가 제안(C-CAL-04)·polder→output_paper 적재 여부는 batch Q-PLATE(견적밖 vs 적재). round-14 Phase11 가격엔진 차원 변경과 정합 확인 필요.

---

## 추가-D. 봉투/케이스 세트 미적재 [3 family·단일 모델]
배경지/엽서/캘린더가 봉투·케이스를 세트로 판매하나 addon=0·sets=0. **봉투 template(TMPL-000005/006/009) 실재**(search-before-mint). product-accessory가 Q-ID-A를 라이브 실측으로 답함(sets+CPQ 사이즈매칭).

| family | finding-id | 호스트 상품 | 세트 대상 |
|--------|-----------|------|------|
| digital-print | C-08·C-11·Q-ID-A | 배경지043/044 | OPP봉투·PP케이스 |
| product-accessory | PA-04·§5 권고 | 배경지(호스트)·봉투001~009 | sets+사이즈매칭 |
| calendar | C-CAL-08 | 110엽서/디자인 | 캘린더봉투 PRD_000005(template mint) |

> **통합:** batch Q-SET 단일 결정(sets vs addon vs CPQ). product-accessory §5 권고=`t_prd_product_sets`+CPQ 사이즈매칭 캐스케이드. 캘린더봉투만 template mint 필요.

---

## 추가-E. MES_ITEM_CD NULL 정책 [5 family]
load_master:261 의도적 None(MES 중복 UNIQUE 회피). 값은 L1에 실재. **중복 없는 1:1 상품군은 채울 수 있음**.

| family | finding-id | 분류 | 채움 가능성 |
|--------|-----------|------|------|
| sticker | C-ST-08·Q-ST-MES | MISSING | L1 002-0001~0016 실재·중복 정리 후 |
| booklet | BK-11 | CORRECT(by-design) | 006-0001~0008·중복 회피 |
| silsa | C-09 | CORRECT(경로불명) | 004-0001~·일부 공유(중복) |
| calendar | C-CAL-13·CL-G | MISSING | **007-0001~5·1:1 중복없음→채움 가능** |
| product-accessory | PA-14 | CORRECT(경로불명) | 7/15 채움 |

> **통합:** batch Q-MES 단일 정책(중복정리 후 일괄 재적재 vs 의도 NULL 유지). 캘린더는 중복 없어 즉시 채움 후보.

---

## 추가-F. page_rule 잡음(떡제본 3/3/3) [2 family]
떡제본/낱장은 page_rule 무의미(intent-map L358). 진짜 축=묶음수. v03가 placeholder 3/3/3 생성.

| family | finding-id | 분류 | 교정 |
|--------|-----------|------|------|
| booklet | BK-8·Q-BK-B | EXTRA | page 3/3/3 논리정리(note 보존·침묵삭제 금지) |
| stationery | ST-07·Q-ST-G | MIS-LOADED | 동형(097 3/3/3) |

> **통합:** batch Q-PAGE 단일 결정(정리 vs page=장수3 의미 유지).

---

## 추가-G. usage 슬롯 미분화 [4 family]
USAGE.07 공통 default(load_master:324 빈용도→공통)·본체/부속 코드 부재.

| family | finding-id | 분류 | 정답 usage |
|--------|-----------|------|------|
| stationery | ST-02 | MIS-LOADED | 종이→USAGE.01 내지 |
| booklet | BK-1 | MIS-LOADED | .07 동일 mat 복제(097 1건) 논리삭제 |
| acrylic | AC-M2·CONFIRM-AC-usage | MIS-LOADED | 본체/부속 코드 도메인 컨펌 |
| (silsa/digital/goods) | C-03·GP-C-12 | CORRECT | 낱장=USAGE.07 공통 정당 |

> **주의(검증자 정밀화):** "USAGE.07 풀 324행"은 .01 복제가 아닌 **용도-미지정 풀**(낱장 상품은 .07 정당) — booklet BK-1(097 1건 .01↔.07 복제)과 구분. **"USAGE.07=결함"으로 일반화 금지**. batch Q-USAGE는 종이=내지/공통 판정 + 본체/부속 코드 신설 여부.

---

## 추가-H. CPQ 옵션 레이어 전면 미적재 [6+ family]
option_groups/options/option_items가 굿즈·캘린더 등 전역 미적재(전역 6행=테스트 잔재). round-6 트랙. ②의 색상→option·size→option 교정이 여기 의존.

| family | finding-id | 의존 |
|--------|-----------|------|
| goods-pouch | GP-C-10·Q-GP-1 | 폰기종/등급 size↔option·색×규격 분리 |
| product-accessory | PA-02·Q-PA-B | 색상 variant |
| calendar | C-CAL-05·06 | 장수·캘린더가공 택일그룹 |
| silsa | C-06·Q-SL-2 | 봉제/족자 variant |
| sticker | C-ST-05·06 | 조각수·형상 param(OM-7 ref_param_json) |
| acrylic | AC-A3 | 볼펜색/지비츠타입 variant |

> **통합:** round-6 CPQ 일괄 적재 트랙. **excl_grp_cd 컬럼은 sql/23에서 삭제됨**(round-14 Phase11) → 택일그룹 표현은 option_groups SEL_TYPE.01로(GP-3 주의). ref_param_json은 OM-7 미구현(ddl-proposer).

---

## 추가-I. 가격 미적재(prices 0행) [4 family]
round-2 트랙. 가격포함 시트는 본 round-13 범위 외였으나 미적재가 finding으로 표면화.

| family | finding-id | 분류 | 가격 모델 |
|--------|-----------|------|------|
| photobook | PB-M1·컨펌-Q3 | MISSING | size×표지타입 base+per-page(고정가) |
| calendar(디자인) | C-DC-11·★Q15 | MISSING | 고정가형 직접단가 |
| stationery | ST-13 | MISSING | 고정형 PRF·떡메모=묶음×size 매트릭스 |
| product-accessory | PA-03 | MISSING | variant별 고정가 |

> **통합:** round-2 dbm-price-formula 트랙. round-14 Phase11 영향(template_prices·PRICE_TYPE 단가/합가형) 반영 — batch Q-PRICE(목표 테이블=t_prd_product_prices vs t_prd_template_prices).

---

## family 단발 finding (정체별 고유 — 횡단 아님)
패턴축에 안 묶이는 family 고유 결함(정체·생산방식 특수). 일괄화 대상 아님·개별 교정.

| family | 단발 finding | 분류 | 비고 |
|--------|------|------|------|
| stationery | ST-06 미싱제본(PROC_000017 자식 부재) | MISSING | 신규 mint 후보(제본 family 재사용 없음) |
| silsa | C-07 보드마운팅 공정 마스터 부재 | MISSING | ddl-proposer(공정 mint) |
| acrylic | AC-X1 완칼 전 아크릴 0건·AC-R1 볼체인 addon 소실 | MISSING/REMOVED | 완칼 묵시·Phase7 tmpl 재구조화 |
| calendar | C-CAL-07 삼각대거치 공정 부재·C-DC-10 editor_yn | MISSING | ddl-proposer(공정 mint)·surface 교정 |
| sticker | C-ST-07 063 화이트 underbase·C-ST-13 스티커팩 세트 | MISSING | 투명 베이스·팩 구성 불명 |
| product-accessory | PA-05 묶음수·PA-13 우드 길이 | MISSING/AMBIGUOUS | bundle·길이 variant |
| digital-print | C-06 박 8색(부모 PROC_000033 미연결) | AMBIGUOUS | 옵션풀 vs 부모박 |
| digital-print | **C-13 라벨택 형상 커팅(PROC_000053 완칼 0행)** | MISSING | 형상 param·C-07 배경지 커팅과 동형(단 라벨택 고유 형상 8종) |
| goods-pouch | **GP-C-07 봉제/에폭시/맥세이프 공정(0행)** | MISSING | load-execution(round-5)·PROC_000080/083/081 신규 연결·정체별 후가공 |
| goods-pouch | **GP-C-16 머그=라이프 ROOT(lvl1) 직결(8상품)** | AMBIGUOUS | ①카테고리 패턴 변종(ROOT 직결, 무결성 위반 아님)·말단 노드 미사용·정밀화 선택 |
| booklet | BK-2 sub_prd 078 몽블랑 잡음(전 DB 1건) | MIS-LOADED | 가장 위험(반제품 BOM 오염) |

---

## 종합 — 횡단 vs 단발 비율
- **횡단 패턴 9축**(①②③ + 추가 A~I)이 결함 finding의 다수를 흡수.
- **family 단발 ~20건**은 정체·생산방식 특수(미싱제본·보드마운팅·완칼·삼각대거치·박색·sub_prd 잡음).
- **메타 교훈:** 결함의 뿌리는 family 고유가 아니라 **v03 진원 + 적재 로직 구조 한계의 횡단 발현**. 따라서 **패턴축 일괄 교정**(roadmap)과 **패턴별 일괄 컨펌**(batch-confirmations)이 개별 family 교정보다 정확·효율적이다.
