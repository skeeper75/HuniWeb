# 등록 명세 — ② 사이즈 (`t_siz_sizes`) 🟡

> **하네스** hbg Phase 3 설계가 · 2차 회차. **작성** 2026-06-18.
> **입력:** `02_diagnosis/diagnosis-size.md`(🟡 색오염 2·nonspec data-gap·형상+EA 판정불가) · `01_authority/axis-authority-size.md`.
> **재사용:** dbmap `11_ddl_proposals/{goods-pouch-nondim-size,shape-axis}.sql` · `00_schema/code-identifier-strategy.md` · `regspec-material.md §3.1/§3.2`(자재 29행 수신).
> **[HARD] 명세 ≠ 적용.** 실 COMMIT = dbmap 위임. **round-23 구간차원 COMMIT분·기계적 삭제 절대 금지.**

---

## 0. 한 줄 평결

**색 오염 2행(SIZ_000104/105 카드봉투) 교정이 즉시 가능한 유일 실 조치 — 가격 cp 0참조=무비용.** nonspec 25/275 채움 = data-gap(그릇 있음·dbmap 위임). 형상+EA 30행 = 판정불가(SZ-2·칼틀 실측 후속). **★기계적 size 삭제 절대 금지**(component_prices 116siz 2,601행 CASCADE·round-22 ② CORRECT 반증). round-23 siz_width/height 구간차원·스티커/반칼 채번 COMMIT분 **재제안 금지**. 신규 그릇 = 비치수 마스터(자재 수신용·기제안 재사용).

---

## 1. ★ SZ-1 — 색 오염 2행 교정 (즉시·무비용)

### 1.1 등록 명세 단위

| 명세 단위 | 내용 |
|-----------|------|
| **대상 t_* + 코드값** | `t_siz_sizes` SIZ_000104 "화이트165x115mm(10장)" · SIZ_000105 "블랙165x115mm(10장)"(del_yn='N' 활성). |
| **올바른 의미** | siz = **165x115mm 치수만**. 색(화이트/블랙) = ④자재 본체색/옵션(카드봉투 색) · 수량(10장) = bundle. siz_nm에 색·수량 인코딩 금지(OM-1 카드봉투 대표 위반). |
| **권위 근거** | `diagnosis-size.md §2 SZ-1`(ⓐ v03 + ⓓ 코드도메인) · `axis-authority-size.md` OM-1(물리 치수만) · `regspec-material.md §2`(카드봉투 색=본체색 동일 케이스). |
| **교정 명세** | ① 색 → 카드봉투(PRD_000004) 본체색 옵션/자재로 축이동(material §2 정합) · 수량(10장) → bundle · ② siz_nm을 "165x115mm"로 정규화(색·수량 제거). 치수 165x115 자체는 정당 siz 보존. |
| **search-before-mint** | **신규 그릇 0** — 165x115 치수는 기존 siz 정규화(UPDATE siz_nm). 색은 material §2(본체색 자재 유지 or 옵션)·수량은 bundle 기존 그릇. siz 신규 채번 0(기존 행 정규화). |
| **FK 위상** | ① 색 → material/옵션 축이동 · 수량 → bundle → ② siz_nm 정규화(UPDATE). **삭제 아님** — 165x115 치수 보존(중복 siz면 del_yn='Y' 소프트삭제 단 치수 자체는 정당이므로 정규화 우선). |
| **적재경로** | siz 정규화 = product-viewer `pvEdit(PRD_000004, sizes)` 섹션(siz_nm UPDATE) 또는 catalog Django `tsizsizes__change`. 색/수량 축이동 적재경로는 material §2·bundle 섹션. |
| **영향분석** | **★색 오염 siz(SIZ_000104/105) component_prices 참조 = 0**(라이브 실측·`diagnosis-size.md §4`) → **교정 무비용**(가격행 파손 없음). FK CASCADE 무관(가격 0참조). 롤백 = siz_nm 원복(단순 UPDATE). |
| **컨펌** | — (material §2 카드봉투와 동일 케이스·가격 안전·B-MAT-3/색 귀속 1차 자재 산출에서 확정). |

---

## 2. SZ-3 — nonspec 비규격 채움 (data-gap·dbmap 위임)

| 명세 단위 | 내용 |
|-----------|------|
| **대상 t_*** | nonspec_* 컬럼(t_siz_sizes 또는 cp) — **25/275만 채움**(nonspec_yn 구동). |
| **올바른 의미** | 비규격 상품(실사/현수막)은 nonspec_* 범위 채워야(입력UX). 가격=면적매트릭스(AX-3·round-23 siz_width/height cp 구간차원). |
| **원인유형** | ⓒ **data-gap**(그릇 있음·미적재) — 모델 부재 아님. |
| **search-before-mint** | 신규 그릇 0 — nonspec_* 컬럼 라이브 실재. 채움만(GAP-SIZ-1). |
| **라우팅** | **신규 채움**(사이즈 축 확장 시·자재 아님) — dbmap 적재 트랙 위임. 본 회차 등록 0(data-gap·설계가/확장 트랙). |
| **★round-23 정합** | siz_width/siz_height = `t_prc_component_prices`의 가격 구간 차원(use_dims·922행 COMMIT) — **좌표 siz 채번 폐기 확정**. 면적매트릭스 가격은 siz 마스터 행수 증가 없이 표현. nonspec 입력UX와 가격 격자는 별개([[dbmap-area-matrix-wh-dimension]]). |

> **재제안 금지:** round-23 siz_width/height 구간차원·스티커 SIZ_000518/519·반칼 SIZ_000520 채번은 라이브 COMMIT 완료. 좌표 siz 재모델·재채번 0(`diagnosis-size.md §5` 인용).

---

## 3. SZ-2 — 형상+EA 30행 (판정불가·컨펌 큐)

| 명세 단위 | 내용 |
|-----------|------|
| **현재값** | 정사각/원형/하트 + EA 30행(예 SIZ_000212 "정사각10x10mm(8EA)"). |
| **정답(분기)** | (a) 칼틀 물리존재(합판도무송/아크릴 형상)면 → siz_cd 1:1 **정당**(Q7·§2.1) · (b) 규격형이면 → 공정 param이어야. EA(8EA/6EA) = 판걸이수(앱 계산·부수보존 정당) or 조각수 오염(상품별 칼틀 매칭 필요). |
| **라우팅** | **판정불가/정상 혼재** — 칼틀존재 여부 상품별 미실측. 대부분 정당(칼틀형 siz는 §2.1 분기상 siz 유지). |
| **명세(조건부)** | 칼틀 물리존재 입증 시 → siz_cd 1:1 보존(변경 0·정상). 규격형 입증 시 → 형상은 shape_cd(SHAPE 코드·shape-axis DDL)·EA는 ref_param_json `{"조각수":N}`(공정 param·V-1). **실측 전 등록/삭제 0.** |
| **컨펌** | **SZ-2**(아래 §6·칼틀 실측 후속). |

> **★기계적 삭제 금지 [HARD]:** 형상 siz 30행은 칼틀 매칭 미실측 상태 → 함부로 삭제 시 정당 칼틀 siz 전손. round-3 G-AC·합판도무송 칼틀 1:1 인용 가능(다음 회차 전수).

---

## 4. SZ-4 — 굿즈파우치 size (round-22 ② CORRECT 반증·재진단 금지)

| 항목 | 판정 |
|------|------|
| 굿즈파우치 폰기종/사이즈등급 size 적재(AX-2) | 치수형=size 유지·옵션형=CPQ option. **round-22 ② CORRECT 반증·가역0** — 기계적 삭제 금지. |
| 라우팅 | **재진단·재제안 0**(round-22 ② 종단·가격종속·인용). |

---

## 5. 자재 29행 수신 (1차 자재 정합)

| 항목 | 판정 |
|------|------|
| 자재 .09 shape 18 + size 11 = 29행 수신(`regspec-material.md §3.1/§3.2`) | 치수보유→siz·비치수→nondim 마스터·형상→shape_cd(SHAPE 코드). |
| 비치수 마스터 search-before-mint | dbmap `goods-pouch-nondim-size.md §2` 입증: t_siz_sizes work/cut NULL 순수 라벨 0건 → 비치수 라벨 siz 둔갑 불가. **신규 마스터 `t_siz_nonspec_sizes`(사다리 4) 정당**(vessel-gap data-gap). |
| 형상 SHAPE search-before-mint | shape-axis DDL — **신규 테이블 0**(SHAPE 코드행 6 + 기존 junction `t_prd_product_sizes.shape_cd` 컬럼·V-12 vessel-gap 정당). |
| 적재경로 | 실치수 siz=`pvEdit(sizes)`. 비치수 마스터/shape_cd 컬럼 = **DDL 적용 후 catalog 모델 노출(현재 admin 미구현·적재경로 미상)**. 정직 표기. |

> 자재 29행 수신 등록 명세는 `regspec-material.md §3.1/§3.2`에서 전수 처리(중복 명세 금지·본 문서는 SZ-1 색오염 교정 전담 + 수신 그릇 정합 확인).

---

## 6. ★ 컨펌 큐 (escalate — 평이한 한국어 질문)

| ID | 막힌 결정 | 평이한 한국어 질문 |
|----|-----------|--------------------|
| **SZ-2** | 형상 siz(정사각/원형/하트 30행)가 칼틀 물리존재(정당 siz)인지 규격형(공정 param)인지 + EA가 판걸이수인지 조각수 오염인지 | "정사각·원형·하트 같은 모양 사이즈가 30개 있는데, 이게 실제로 그 모양의 '칼틀'(찍어내는 금형)이 따로 있어서 사이즈로 둔 건가요, 아니면 그냥 모양 이름만 적어둔 건가요? 또 '8EA' 같은 숫자가 한 판에 몇 개 들어가는 수(판걸이수)인가요, 아니면 조각 개수인가요? 칼틀이 있으면 그대로 두고, 아니면 모양은 형상칸으로 옮깁니다." |

> **escalate:** SZ-2는 상품별 t_prd_product_sizes 연결 + 합판도무송/아크릴 칼틀 여부 실측 전 등록/삭제 0(판정불가·보류). 다음 회차 전수.

---

## 7. ★ FK 위상 / 가격사슬 안전 [HARD]

| 사실(라이브 실측) | 함의 |
|-------------------|------|
| **색 오염 siz(SIZ_000104/105) component_prices 참조 = 0** | SZ-1 교정 무비용 — 색→옵션 축이동·siz 정규화가 가격행 파손 없음. |
| `t_prc_component_prices.siz_cd` = **ON DELETE CASCADE** FK | 가격 묶인 siz(round-22 ② 116siz 2,601행)는 삭제 시 가격 전손 → **기계적 삭제 절대 금지**(AX-2·round-22 ②). |
| round-23 siz_width/height = cp 구간차원(922행) | 면적매트릭스 가격 = comp use_dims(좌표 siz 채번 폐기) — siz 마스터 행수 증가 없이 가격 표현. |

---

## 8. 등록 명세 건수 집계

| 라우팅 | 행수 | 신규 mint | 즉시/컨펌 |
|--------|:--:|:--:|------|
| **SZ-1 색 오염 교정(siz_nm 정규화 + 색/수량 축이동)** | **2행** | 0(기존 siz 정규화) | **즉시·무비용**(가격 0참조) |
| SZ-3 nonspec 채움(data-gap) | 25(미채움분) | 0(nonspec_* 기존) | dbmap 위임·본 회차 0 |
| SZ-2 형상+EA(판정불가) | 30 | 0 | **SZ-2 컨펌·보류** |
| SZ-4 굿즈파우치 size | — | 0 | round-22 ② 종단·재진단 0 |
| 자재 29행 수신(material §3.1/§3.2) | 29 | 비치수 마스터·SHAPE 코드6(기제안) | material 처리·DDL 후 |
| 기계적 삭제 | **0** | — | **금지**(가격 CASCADE) |

> **사이즈 축 즉시 실 조치 = SZ-1 색오염 2행 교정(무비용)뿐.** nonspec data-gap·형상 판정불가·자재 수신은 dbmap/후속 위임. 기계적 삭제 절대 금지.

---

## 9. dbmap 인용 (재제안 금지)

- **round-22 ②사이즈** = 라이브 가역 0(component_prices 116siz 2,601행 CASCADE·전부 가격종속·size↔option 경계/판형혼동 0건 CORRECT 반증) — 종단 완료.
- **round-23** siz_width/height 구간차원 라이브 COMMIT([[dbmap-area-matrix-wh-dimension]])·스티커 SIZ_000518/519·반칼 520 채번 — 좌표 siz 채번 폐기·재모델 0.
- **round-13** 실사 size 매트릭스 CORRECT 반증 — 좌표 siz 재모델 불요.

---

## 10. hbg-validator 통지

- **사이즈 축 = SZ-1 색오염 2행 교정(즉시·무비용)이 유일 즉시 조치.** 검증 포인트: ① 색 오염 siz component_prices 0참조(가격 안전·무비용) ② **★기계적 size 삭제 절대 금지**(116siz 2,601행 CASCADE·round-22 ② CORRECT 반증) ③ round-23 구간차원·스티커/반칼 채번 재제안 0 ④ nonspec=data-gap(dbmap 위임·본 회차 등록 0) ⑤ 형상+EA 판정불가(SZ-2 컨펌·칼틀 실측 전 보류) ⑥ 자재 29행 수신 그릇(비치수 마스터·SHAPE 코드 기제안 재사용·material 처리) ⑦ siz_nm 정규화는 UPDATE(삭제 아님·치수 보존).
- **escalate:** SZ-2(형상 칼틀 여부·EA 의미). 평이한 한국어 질문 §6.
