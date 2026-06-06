# 가격 매핑 독립 게이트 — 박(foil) 면적매트릭스 + 봉투제작(ENV)

> **역할**: R6/G9 독립 게이트(설계자 ≠ 검증자). 양 트랙 적대 재계산·라이브 read-only 재확인.
> **권위순**: 라이브 DB > 스키마시트 > 매핑 설계 / 엑셀 원셀 > 정규화 CSV.
> **HARD 준수**: DB 쓰기·COMMIT·DDL 0건. 비밀번호 미출력. read-only SELECT만.
> **결론 요약**: **박 = CONDITIONAL-GO** (실결함 1 BLOCKER + 1 MINOR, 가격 재계산 자체는 무결) · **ENV = GO** (전건 정합).

---

## TARGET 1 — 박(foil) 면적매트릭스

### 등급 소멸 grep (사용자 핵심 지시) — **PASS**
- 적재 데이터 컬럼(comp_cd/siz_cd/clr/mat/coat/bdl) 전수 스캔: 바른 A~E 토큰 출현 = **0**.
- note 컬럼 `등급[A-E]`/`분류[A-E]` 패턴 = **0**.
- 등급은 B02⋈B03 조인 키로만 사용되고 결과에 면적좌표(siz_cd)·박종(comp_cd)·수량(min_qty)만 남음. **헤드라인 체크 통과.**

### G-recompute (B02⋈B03 조인 재계산) — **PASS (0 mismatch)**
독립 파서로 L1 원셀에서 4개 가격표(소형 일반/특수, 대형 일반/특수)와 grade 매트릭스를 재구성하고
**2,143 적재행 전건을 재계산**:
- `checked=2143, mismatch=0, nocoord=0, nograde=0`. 모든 행이 (가로,세로)→등급→(수량)→가격 조인과 정확 일치.
- 표본 4종(요청) 전부 일치:

| # | 입력 | 적재 siz | 수량 | 가격 | 판정 |
|---|------|---------|------|------|------|
| EX1 소형일반 10×80 q200 | C→16400 | SIZ_000725 | 200 | 16400 | MATCH |
| EX2 대형일반 170×170 q10000 | E→2000000 | SIZ_000774 | 10000 | 2000000 | MATCH |
| EX3 대형동판 50×130 | (룩업)15000 | SIZ_000735 | NULL | 15000 | MATCH |
| EX4 소형특수 40×40 q500 | D→44900 | SIZ_000333 | 500 | 44900 | MATCH |

### G7 무손실 (collapse 정합) — **PASS (수치) / MINOR (문서 표 오기)**
- 실제 comp별 행수: SG=234, SS=234, LG=806, LS=806, DIE_SMALL=1, DIE_LARGE=62 = **2,143**.
- collapse는 **REVERSED 동일가 병합만** 수행(전수 same-price 입증):
  - SMALL gen: (20,40)~(40,20) 1쌍 병합 → 전 수량밴드 가격충돌 **0**.
  - LARGE gen: orientation-distinct 28쌍 중 가격동일 28/가격상이 0. 실제 drop된 (70,30)/(90,70) 모두 kept 역방향과 **가격동일**.
  - 전 comp 가격충돌 = **0** (price conflict swallowed = 0). 자연키 중복 = **0**, comp_price_id 유니크.
- **MINOR-1**: 설계 §5 무손실 표의 per-line 분해(소형 14×18=252, 대형 64×13=832, raw 2233 −90)는 **실제 산출물과 불일치**.
  실제는 SG/SS 각 −18(13좌표), LG/LS 각 −26(62좌표), DIE_LARGE −2 = 합 −90이며 최종 2,143은 맞으나
  표의 중간 수치(252/832/2233/65)는 collapse 전 raw를 잘못 적은 오기. 순(net) 무손실 성질은 정합. → designer 표 정정 권고.

### search-before-mint (라이브 재확인) — **BLOCKER-1 + 수치 정정**
라이브 read-only 결과:
- **mint 53 (722~774)**: 라이브 부재 **확증(count=0)**. 신규 좌표 발급 정당.
- **충돌**: 라이브 `max(siz_cd)=SIZ_000500`. 면적매트릭스 511~721도 **아직 라이브 미적재(count=0)**.
  → 722~774는 충돌 없음(전방 예약). 단 설계가 "면적이 511~721 점유"를 기정사실로 적은 것은 **미적재 상태**임을 명기 필요(차단 아님, 채번 조정은 면적 트랙과 동시 적재 시 유효).
- **재사용 siz 수치 오기**: 설계 §3 "26 재사용". 실제 적재 CSV는 **21 distinct 라이브 siz** 재사용(53 mint + 21 = 74 distinct). 26≠21 → designer 수치 정정.
- **BLOCKER-1 (실결함) — 재사용 siz 차원축 불일치 + SIZ_000047 삼중 바인딩**:
  재사용 21 siz를 그 바인딩된 박 좌표(note 가로×세로)와 라이브 `work`/`cut` 치수로 교차대조 →
  매칭 축이 **일관되지 않음**(일부는 cut 치수, 일부는 work 치수, 일부는 reversed로 hit).
  - 가장 심각: **SIZ_000047** (라이브 work 50×90 / cut 40×80)이 **3개 물리 좌표에 동시 바인딩**:
    - COMP_FOIL_SMALL_GEN/SPC → **40×80** (cut 치수 매칭)
    - COMP_FOIL_LARGE_GEN/SPC → **50×90** (work 치수 매칭)
    - COMP_FOIL_DIE_SMALL → **80×40** (cut의 reversed)
    - COMP_FOIL_DIE_LARGE → **50×90**
    → 40×80(3200㎟)·50×90(4500㎟)·80×40(3200㎟)는 **서로 다른 물리 면적**인데 단일 siz_cd로 수렴.
      자연키 충돌은 없으나(런타임 면적 룩업의 의미 손상): 50×90 대형박과 40×80 소형박이 동일 siz로 해소되어
      **면적 권위가 모호**. 설계 §3 "cut/work 정확매칭" 문구가 실제 혼합축 매칭을 은폐.
  - 추가 차원 mismatch: SIZ_000006(live 112×172, 좌표 110×170 — cut은 일치), SIZ_000008(92×52 vs 90×50, cut 일치),
    SIZ_000011(60×60 vs 50×50, cut 일치). → **cut 치수 기준이면 정당**하나 work 기준 좌표(대형)와 섞여 축이 분열.
  - SIZ_000119/336/346: 라이브 work 치수 **NULL**(cut만 존재) → 면적좌표로서 검증 불가, 그럼에도 박 좌표에 바인딩.
- **권고**: 박 면적좌표↔siz 매칭 축을 **하나로 통일**(권장: cut_width/cut_height = 마감 트림면적 = 박 스탬프면적).
  통일 시 SIZ_000047의 large 바인딩(50×90→work)이 mint 또는 다른 cut-매칭 siz로 재배정되어야 함.
  → **dbm-mapping-designer 라우팅**: 재사용 siz 21건 전수를 단일 축(cut)으로 재대조, 혼합축/삼중바인딩 해소,
    work-NULL siz는 mint로 전환 또는 cut-검증 가능 siz로 교체. 재게이트 대상.

### FK / 코드행 — **PASS**
- 라이브 코드행 선존재: `PRC_COMPONENT_TYPE.05 박형압비`(use=Y), `FRM_TYPE.02 단순형`(use=Y), `.06 완제품비`(use=Y).
  → 코드행 INSERT 불요(설계 §4 "stale" 진술 정확).
- `COMP_FOIL_*`(6) 라이브 부재(count=0) → 신규, 자연키 충돌 불가.
- `PRF_FOIL_AREA` 라이브 부재(0) → 신규.
- comp_price_id 9100000~9102142 라이브 미사용(0), 컬럼 bigint(64)로 범위 적합.
- **FLAG-3 정직 표기 — PASS**: standalone 후가공_박 product 부재 → `t_prd_product_price_formulas.csv` **빈 채로 산출**(헤더만).
  발명 없이 정직하게 빈 바인딩 표기. 침묵 드롭 아님. 박을 add-on으로 거는 product 지정은 인간 결정 대상.

### 박 종합 판정 — **CONDITIONAL-GO (적재 차단)**
가격 재계산·등급소멸·무손실·코드행/FK는 무결하나, **BLOCKER-1(재사용 siz 혼합축·삼중바인딩)** 미해소 상태로는
면적 룩업 의미가 모호하여 **적재 차단**. designer가 siz 매칭 축 통일 후 재게이트 필요.
(추가로 FLAG-2 siz 등록·FLAG-3 바인딩 대상은 인간 승인 대기 — 차단 정당.)

---

## TARGET 2 — 봉투제작(ENV)

### 작업사이즈→siz EXACT 재사용 (라이브 재확인) — **PASS**
라이브 read-only:

| placeholder | 봉투 | 좌표 | 라이브 siz | work_width×height | 판정 |
|-------------|------|------|-----------|-------------------|------|
| ENV_TICKET | 티켓 | 225×193 | SIZ_000191 | 225.00×193.00 | EXACT |
| ENV_SMALL | 소봉투 | 238×262 | SIZ_000192 | 238.00×262.00 | EXACT |
| ENV_JACKET | 자켓 | 262×238 | SIZ_000193 | 262.00×238.00 | EXACT |
| ENV_LARGE | 대봉투 | 510×387 | SIZ_000194 | 510.00×387.00 | EXACT |

전부 impos=N, use=Y, del=N. **mint 0 (hidden mint 없음).** 박과 달리 work 치수 정확매칭 — 축 일관.

### 자켓 vs 소봉투 reversal (FLAG-A) — **PASS**
- 라이브가 이미 SIZ_000192(238×262) ≠ SIZ_000193(262×238) **distinct 보유**(count=2, del=N).
- 봉투종류 정체성(소≠자켓) 보존 + 라이브 권위 distinct → collapse 안 함 정당. 박 REVERSED 수렴과 대조적 결정 타당.

### 40행 무손실 — **PASS**
- 40행(4봉투×2소재×5수량), residual placeholder=**0**.
- siz별 10 / mat별 20(MAT_000159·168) / 수량별 8 — 정확. 자연키 중복=0, comp_price_id 1713~1752 유니크.
- comp_cd 전건 COMP_ENV_MAKING, clr/coat/bdl 전건 공란(NULL).
- 앵커 4종 verbatim: 티켓1000 모조 **96000**/레자크 **111000**, 대봉투1000 모조 **134000**/레자크 **152000** — 전부 일치.
- 40 unit_price 전건이 source(price-envelope-l1) 가격셀에 존재(missing=0). 무손실 입증.

### binding / FK / 코드행 — **PASS**
라이브 read-only 전건 확인:
- PRD_000050 봉투제작(use=Y) 선존재.
- COMP_ENV_MAKING(comp_typ `.06 완제품비`, use=Y), PRF_ENV_MAKING(frm_typ `FRM_TYPE.02`, use=Y) 선존재.
- 바인딩 PRD_000050→PRF_ENV_MAKING 라이브 선존재(apply 2026-06-01) → **바인딩 INSERT 불요**(설계 정확).
- MAT_000159(모조120g)/MAT_000168(레자크체크백색110g) 라이브 선존재.
- COMP_ENV_MAKING component_prices 라이브 **0행** → 본 40행이 채울 빈 슬롯(설계 정확).
- comp_price_id 1713~1752 라이브 미사용(0), max 라이브=4805 무충돌.
- **"no code-row needed" 검증됨**: `.06`·FRM_TYPE.02·COMP_ENV_MAKING 전부 선존재 → 코드행 INSERT 0. FLAG-A/B 침묵 드롭 아님.

### ENV 종합 판정 — **GO**
placeholder siz 4종 라이브 EXACT 해소, 40행 무손실, 전 FK 부모 선존재, mint·신규바인딩·신규코드행 0,
자연키 충돌 0, id 충돌 0. **적재 가능성 입증. 적재본 빌드 진행 가능.**

---

## 라우팅 / 적재 전 필수 조치

| # | 심각도 | 트랙 | 항목 | 라우팅 |
|---|--------|------|------|--------|
| BLOCKER-1 | BLOCKER | 박 | 재사용 21 siz 혼합축 매칭 + SIZ_000047 삼중바인딩(40×80/50×90/80×40 1 siz) + work-NULL siz(119/336/346) 바인딩 | **dbm-mapping-designer** — siz 매칭 축 단일화(cut 권장), 삼중바인딩 해소, work-NULL siz mint 전환. 재게이트 |
| MINOR-1 | MINOR | 박 | §5 무손실 표 per-line 수치 오기(252/832/2233/65 = collapse-전 raw 혼입) | dbm-mapping-designer — 표 정정(net 2143은 정합) |
| MINOR-2 | MINOR | 박 | §3 "26 재사용" → 실제 21 distinct 재사용 / "면적 511~721 점유"는 라이브 미적재(max=500) | dbm-mapping-designer — 수치·전제 정정 |
| FLAG-2/3 | (인간) | 박 | siz 53 등록 + standalone 박 product 바인딩 대상 미확정 | 인간 결정(적재 승인 게이트) |

## 종합 판정
- **박(foil): CONDITIONAL-GO** — 가격 재계산·등급소멸·무손실 무결, **BLOCKER-1 미해소로 적재 차단**. 축 통일 후 재게이트.
- **봉투(ENV): GO** — 전건 정합, 적재본 빌드 진행 가능.

**HARD 준수 확인**: DB 쓰기·COMMIT·DDL 0건. read-only SELECT만. 비밀번호 미출력. 설계자 파일 미수정(라우팅만).
