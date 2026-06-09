# 코드 생성·식별자 전략 — 권고안 (huni-dbmap)

> 작성 2026-06-09 · 오케스트레이터 인라인 분석(expert-backend 위임 거부로 직접 수행). 라이브 Railway DB 읽기전용 실측 근거 기반.
> 목적: 자재·공정·사이즈·옵션·템플릿·제약·상품을 **등록할 때마다 코드를 어떻게 생성하고 인식 가능하게 할지** 정의. CPQ 옵션 레이어 적재의 선결 결정.
> [HARD] 설명=한국어, 식별자/테이블/컬럼/코드/SQL=English. DDL은 **제안**이며 적용·COMMIT은 인간 승인.

---

## 0. 독립 검토 반영 (expert-backend, 2026-06-09) — **CONFIRM-WITH-ADJUSTMENTS**

전문 검토자가 라이브 DB로 전 주장 재실측. 핵심 진단(P1·P2·P3)·A안 방향 **확증**. 단 본 문서 초안의 **사실 오류 2건 + 미점검 리스크 1건** 적발 → 아래 정정 반영함.
- **정정① (separator 비용)**: 초안 "FK 참조 거의 없음" = 부정확. 실제 **FK 제약 5개 실재** — `opt_grp_cd` 참조 3경로 + `tmpl_cd` 참조 2테이블(`t_prd_product_addons`·`t_prd_template_selections`). 데이터량은 near-empty이나 제약 구조는 존재 → §3.3 재명명 비용 반영.
- **정정② (코드 스코프)**: 초안 "opt_grp/opt = global 순차" = 키 스코프 오판. PK=`(prd_cd,opt_grp_cd)`·`(prd_cd,opt_cd)` → **키 스코프는 per-product**, 번호만 우연히 전역 단조증가(앱 카운터). 진짜 global 단독 PK는 `templates`(tmpl_cd)뿐 → §4 정정.
- **미점검 리스크 (최대)**: 코드생성 **트리거 추가 시 Django 앱이 이미 `seq_prd_code` 소비 중** → 채번 주체 일원화 없이는 이중발급으로 drift 재발. 281~283 수동 적재 원인(누가 시퀀스 우회했나) 규명 + setval 재동기가 선행돼야 함. **D4 권고: 트리거 도입은 Django 채번 일원화를 필수 전제로** (또는 컬럼 DEFAULT가 트리거보다 단순).
- **트리거 호환 확증**: 코드생성 BEFORE INSERT 트리거는 기존 `fn_chk_opt_item_ref`(ref_dim 무결성만)·`fn_upd_dt`(upd_dt만)와 **무충돌**.

---

## 1. 현황 진단 (라이브 실측)

### 1.1 코드 = 순차 surrogate (zero-padded 6자리)
| 엔티티 | 컬럼 | 범위(라이브) | separator |
|--------|------|--------------|:--:|
| t_prd_products | prd_cd | `PRD_000001`~`PRD_000283` (275) | `_` |
| t_mat_materials | mat_cd | `MAT_000001`~`MAT_000336` | `_` |
| t_proc_processes | proc_cd | `PROC_000001`~`PROC_000083` | `_` |
| t_siz_sizes | siz_cd | `SIZ_000001`~`SIZ_000510` | `_` |
| t_prd_product_option_groups | opt_grp_cd | `OPT-000001`~`OPT-000002` | **`-`** |
| t_prd_product_options | opt_cd | `OPV-000001`~`OPV-000005` | **`-`** |
| t_prd_templates | tmpl_cd | `TMPL-000001`~`TMPL-000009` | **`-`** |
| t_prd_product_constraints | rule_cd | `RULE_001` (상품별 리셋) | `_` |

### 1.2 발견된 3대 문제
- **P1 — separator drift**: 마스터/물리 엔티티는 `_`, 신규 CPQ 3종은 `-`. 동일 DB 내 두 컨벤션 공존.
- **P2 — 코드 생성 장치 부재 + 이미 drift 발생**: DB 시퀀스는 `seq_prd_code`(상품)·`comp_price` IDENTITY 둘뿐. `prd_cd`엔 컬럼 default도 없어 앱(Django)이 시퀀스를 소비. **`seq_prd_code.last_value=280`인데 `MAX(prd_cd)=PRD_000283`** → 281~283은 시퀀스를 거치지 않은 수동 적재 = 현재 ad-hoc 채번이 이미 어긋남. 나머지 전 엔티티(MAT/PROC/SIZ/OPT/OPV/TMPL/RULE)는 트리거·함수 0 → 등록 경로마다(admin·SQL·수동) 코드를 사람이 정해야 함.
- **P3 — 멱등 적재 불가 위험(핵심)**: PK가 *DB가 생성하는 순차코드*이면, 적재 스크립트가 같은 논리적 행을 재실행할 때 **새 코드가 생성**돼 중복 INSERT가 된다. 안정적 `ON CONFLICT`/업서트의 충돌키로 쓸 **불변 비즈니스 키가 없다**(코드는 매 생성마다 달라지므로 충돌키가 될 수 없음). round-6 적재본이 시맨틱 코드(OG-GAGONG)를 발명한 근본 이유가 이것 — 그러나 시맨틱 PK는 라이브 순차 컨벤션과 충돌(silsa OPT-000002 사례).

### 1.3 인식(tag) 현황
- `tags`(jsonb)는 **t_prd_product_options·t_prd_templates 2테이블만** 보유, 현재 전부 NULL(미사용).
- 모든 엔티티에 사람용 **이름 컬럼**은 이미 있음(opt_grp_nm·opt_nm·mat_nm·proc_nm…). → **사람 인식 = 이름 컬럼이 이미 담당.**

---

## 2. 전략 옵션 비교

| 전략 | PK 형태 | 장점 | 단점·이 스키마 적합도 |
|------|---------|------|----------------------|
| **A. 순차 surrogate + 불변 의미키(slug)** (권고) | `PREFIX_NNNNNN` | 라이브 컨벤션 유지·PK 불변(FK·MES payload 안전)·slug로 멱등 적재·dev/매핑 인식 | slug 컬럼/규약 신설 필요. **P1~P3 전부 해소** |
| B. 시맨틱 코드 PK (OG-GAGONG식) | 의미문자열 | 사람이 코드만 봐도 인식 | 라이브 순차 컨벤션과 정면 충돌(silsa 사례)·이름 변경 시 PK 불안정·길이/charset·기존 275 상품과 이질. **기각** |
| C. UUID | uuid | 충돌 0·분산 안전 | 비인식·기존 전부 재작업·과설계. **기각** |

→ **사용자 직관("순차코드 + tag로 인식")이 옳다.** 단 tag의 역할을 **(a) 사람 인식**과 **(b) 멱등 적재용 불변키**로 분리해 정밀화해야 함(아래 §3).

---

## 3. 권고안 — 순차 surrogate PK + 생성 트리거 + 불변 의미키(slug)

### 3.1 세 층위로 분리
1. **PK = 순차 surrogate** (`PREFIX_NNNNNN`) — 불변·opaque. FK·주문 payload·MES 연동의 안정 참조.
2. **생성 = 엔티티별 DB 시퀀스 + BEFORE INSERT 트리거** — 코드가 NULL이면 트리거가 `PREFIX_` ‖ lpad(nextval,6,'0') 부여. **등록 경로(admin·SQL·bulk·수동) 무관하게 race-safe·drift 0.** P2 해소.
3. **불변 의미키 = `slug`** (상품 범위 UNIQUE) — 적재 멱등 충돌키 + 시스템간 매핑 + dev 인식. 사람 표시용 인식은 기존 `*_nm` 컬럼이 담당. P3 해소.

> **slug가 P3(멱등)를 푸는 방식**: 적재가 `OPT_000003`을 *생성*하되 `slug='silsa-gagong'` 부여 → 재실행 시 코드가 아니라 **slug로 조회/업서트** → 중복 0. silsa 충돌(시맨틱 PK 발명)도 이걸로 불필요해짐.

### 3.2 인식키 위치 — `slug` 전용 컬럼 vs `tags` jsonb
| 방식 | 멱등 ON CONFLICT | 조회 | 신규 DDL | 권고 |
|------|:--:|------|:--:|:--:|
| **전용 `slug` text + UNIQUE(prd_cd,slug)** | 깔끔(자연 충돌키) | 인덱스 직접 | 컬럼 추가(여러 테이블) | **권고** — 멱등 적재가 실수요 |
| `tags`jsonb의 `->>'slug'` | 표현식 UNIQUE 인덱스 필요·ON CONFLICT 까다로움 | `->>` 연산 | 기존 컬럼 재활용(2테이블만) | 차선(이미 있는 곳만) |

→ **권고: 적재·매핑 대상 엔티티에 `slug`(또는 `map_key`) text 컬럼 + `UNIQUE(prd_cd, slug)` 추가.** `tags`(jsonb)는 그 외 부가 메타(출처·concept·표시배지)용으로 병행 가능. 사용자가 신규 컬럼을 꺼리면 `tags->>'slug'` + 표현식 UNIQUE 인덱스로 대체(차선).

### 3.3 separator 통일 (P1)
- 라이브 CPQ 실데이터 = **거의 없음**(opt_grp 2·opt 5[테스트성 옵션1/옵션2 + 삭제된 각목]·tmpl 9). option_items=0. **지금이 통일 최저비용 시점.**
- **권고: 마스터 다수파인 `_`로 통일** → `OPT-`→`OPT_`·`OPV-`→`OPV_`·`TMPL-`→`TMPL_` 재명명(16행). **[검토 정정] FK 제약 5개 동반 갱신 필요**(opt_grp_cd 3경로·tmpl_cd 2테이블) — `ON UPDATE CASCADE` 또는 drop/rename/re-add. 데이터 near-empty라 양방향 모두 low-risk이나 "거의 없음"은 아님. 또는 "CPQ=하이픈 네임스페이스"로 의도적 분리를 비준(마이그 0). **사용자 결정 §6.**

---

## 4. 엔티티별 코드 생성·식별 운영규칙 (권고 적용 시)

| 엔티티 | PK 코드 | 생성(권고) | 멱등 키(slug) | 사람 인식 |
|--------|---------|-----------|---------------|-----------|
| 상품 t_prd_products | `PRD_NNNNNN` | seq_prd_code **재동기(setval=283)** + 트리거 신설 | 기존 prd_cd 안정 | prd_nm |
| 자재 t_mat_materials | `MAT_NNNNNN` | seq + 트리거 신설 | slug(mint 시 부여) | mat_nm |
| 공정 t_proc_processes | `PROC_NNNNNN` | seq + 트리거 신설 | slug | proc_nm |
| 사이즈 t_siz_sizes | `SIZ_NNNNNN` | seq + 트리거 신설 | slug | siz_nm |
| 옵션그룹 option_groups | `OPT_NNNNNN`(통일) | global seq + 트리거 | slug(예 `silsa-gagong`) | opt_grp_nm |
| 옵션 options | `OPV_NNNNNN`(통일) | global seq + 트리거 | slug(예 `silsa-tagong4`) | opt_nm |
| 옵션항목 option_items | (prd_cd,opt_cd,item_seq) 자연키 | seq 불요(item_seq 순번) | 자연키로 멱등 충분 | — |
| 템플릿 templates | `TMPL_NNNNNN`(통일) | global seq + 트리거 | slug | tmpl_nm/tags |
| 제약 constraints | `RULE_NNN`(상품별) | 상품별 카운터(현행) 또는 global seq | rule_cd 상품범위 안정 | rule_nm |

> **[검토 정정]** option_groups/options 코드는 번호만 **전역 단조증가**(OPT-000001=PRD_000002, OPT-000002=PRD_000138)이나, PK=`(prd_cd,opt_grp_cd)`·`(prd_cd,opt_cd)`라 **키 스코프는 per-product**(global 아님). 진짜 global 단독 PK는 `templates`(tmpl_cd)뿐. 따라서 생성은 "전역 단조 카운터"(현 앱 동작 유지)로 충분하며 멱등성은 per-product 비즈니스 키(slug/name)가 담당. rule_cd는 **상품별 리셋**(RULE_001이 PRD_000001·PRD_000025 양쪽 존재) — 복합 PK로 충돌 없음, 통일 여부는 사용자 결정.

## 5. 제안 DDL (패턴 예시 — 적용 아님, 인간 승인)

```sql
-- (예시) 옵션그룹 코드 자동 생성: 시퀀스 + BEFORE INSERT 트리거
CREATE SEQUENCE IF NOT EXISTS seq_opt_grp_code;
CREATE OR REPLACE FUNCTION fn_gen_opt_grp_code() RETURNS trigger AS $$
BEGIN
  IF NEW.opt_grp_cd IS NULL OR NEW.opt_grp_cd = '' THEN
    NEW.opt_grp_cd := 'OPT_' || lpad(nextval('seq_opt_grp_code')::text, 6, '0');
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER trg_gen_opt_grp_code BEFORE INSERT ON t_prd_product_option_groups
  FOR EACH ROW EXECUTE FUNCTION fn_gen_opt_grp_code();

-- (예시) 불변 의미키 slug — 멱등 적재 충돌키
ALTER TABLE t_prd_product_option_groups ADD COLUMN IF NOT EXISTS slug text;
CREATE UNIQUE INDEX IF NOT EXISTS ux_opt_grp_slug ON t_prd_product_option_groups (prd_cd, slug) WHERE slug IS NOT NULL;

-- 상품 시퀀스 drift 교정 (재동기) — 적용 전 검토
-- SELECT setval('seq_prd_code', (SELECT max(substr(prd_cd,5)::int) FROM t_prd_products));  -- =283
```

> 동일 패턴을 자재·공정·사이즈·옵션·템플릿에 복제(각 PREFIX·seq). 시퀀스명·트리거·slug 인덱스는 라이브 컨벤션 정합 확인 후 ddl-proposer가 정식 제안서로 격상.

## 6. 사용자 비준 결과 (2026-06-09 — 확정)
- **D1 — 전략**: ✅ 순차 surrogate PK 유지 (A안). 멱등성은 비즈니스 키로.
- **D2 — 식별/멱등 키**: ✅ **이름(prd_cd + `*_nm`) 기반 멱등 — 신규 DDL 0.** slug 전용컬럼·tags 확장 모두 보류. 적재 멱등 = (prd_cd, opt_grp_nm)/(prd_cd, opt_grp_cd, opt_nm) 비즈니스 키로 NOT EXISTS 가드. 인식 = 기존 이름 컬럼. (필요 시 추후 slug 승격.)
- **D3 — separator 통일**: ✅ **지금 `_`로 통일.** 신규 CPQ 코드는 `OPT_/OPV_/TMPL_`. 기존 하이픈 16행(대부분 테스트·삭제분) + FK 5개는 정리 마이그(near-empty 저비용). 신규 적재부터 `_` 강제.
- **D4 — 생성 책임**: ✅ **적재 먼저, 생성 메커니즘(트리거/DEFAULT/Django 일원화)은 별도 트랙.** 본 적재는 코드를 명시 부여(라이브 MAX+1, `_` 포맷). seq_prd_code 재동기·이중채번 일원화는 후속 DDL 제안 트랙.
- **D5 — rule_cd**: 상품별 카운터 유지(복합 PK 충돌 없음).

> **신규 코드 채번 규칙(본 적재 적용)**: `PREFIX_` + lpad(라이브 MAX(suffix)+1, 6, '0'). 예 자재 mint=MAT_000337~, 옵션그룹=OPT_000003~, 옵션=OPV_000006~. 멱등 재실행은 코드가 아닌 이름키로 판정(코드 재발급 방지).

## 7. 경계
- 본 문서는 전략·제안 DDL까지. 실제 시퀀스/트리거/컬럼 적용·코드 통일 마이그레이션·COMMIT = 인간 승인. 정식 DDL 제안서는 `dbm-ddl-proposer`(11_ddl_proposals/)로 격상.
