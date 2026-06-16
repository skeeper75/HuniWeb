# 후니 기초데이터 관리 그릇 정비 로드맵 (_vessel-roadmap)

> rpm-vessel-designer. `04_vessel/vessel-*.md` 전 그릇을 leverage + FK/마이그 의존 순으로 정렬 + 후니 base-data 관리 정비 계획.
> 권위 = 라이브 read-only 실측(2026-06-17·gap-matrix와 동일 세션). [HARD] design ≠ apply — 전 항목 인간 승인. 라이브 CREATE/ALTER/COMMIT 0.
>
> **── 버전 ──**
> - **v1.0 (BN):** §0 8축 인벤토리·§1 Wave·§2·§3. **보존(아래 v1.0 표는 그대로, v2.0 행 추가).**
> - **v2.0 (GS·2026-06-17):** + V-3 굿즈 확장(§7 in vessel-material-axis)·**V-8 형태가공**·**V-9 생산형태**·**MAT_TYPE 오라벨 교정**. GS 라이브 재측이 #14·#15를 BN 추정보다 *덜 vessel-gap*으로 확증(형태가공=분류축 1개·생산형태=신규 그릇 0). 인벤토리·Wave·정비권고에 GS 행만 추가, v1.0 무수정.

---

## 0. 그릇 인벤토리 (v1.0 BN 8축 + v2.0 GS 4 → 설계 결과)

### v1.0 (BN) — 8축
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-1 공정파라미터** (#9) | GAP ❌ | `ref_param_json jsonb` 컬럼 1개 | **3 JSONB** | 컬럼 1 (기존 ddl-proposer 재사용) |
| **V-2 인쇄방식레시피** (#12) | GAP ❌(조건부) | 제약 축 흡수(경로 A) — **신규 그릇 0** | 데이터 | 0 (open decision) |
| **V-3 자재분해축** (#1) | WEAK 🟡 | `MAT_FACET` 코드 2~3 (+선택 `mat_facet_cd` 컬럼) — 두께/무게는 기존 컬럼 PASS | 1 코드행(+선택 컬럼) | 코드 2~3 |
| **V-4 제약논리유형** (#5) | WEAK 🟡 | `RULE_TYPE.04 match`·`.05 범위` 코드 2 (essential=PASS 재분류) | 1 코드행 | 코드 2 |
| #4 템플릿가격 | WEAK 🟡 | 가격 사슬 위임 — **신규 그릇 0** | — | 0 (open decision) |
| **V-5 수량** (#10) | WEAK 🟡 | 보류 — **신규 그릇 0** | — | 0 (샘플 확대) |
| **V-6 사이즈 nonspec** (#13) | WEAK 🟡 | V-4 RULE_TYPE.05 흡수 — **신규 그릇 0** | (V-4 공유) | 0 |
| **V-7 가격 role** (#11) | WEAK 🟡 | 가격 트랙 위임 — **신규 그릇 0** | — | 0 |

### v2.0 (GS) — 4 (V-3 확장 포함)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-3 굿즈 분해축** (#1 GS·§7) | WEAK 🟡 | `MAT_FACET.03 용량` 코드 1 (+조건부 `capacity` 컬럼) — 색=CPQ option 위임·소재/두께/무게=기존 컬럼·brand=note | 1 코드행(+조건부 컬럼) | 코드 1 |
| **V-8 본체 형태가공** (#14) | GAP ❌→부분PASS | `PROC_CLASS` 코드 5 + `proc_class_cd` 컬럼 1 (파라미터=prcs_dtl_opt+ref_param_json PASS·지퍼/조립 행=data) | 1 코드행 + 1 컬럼 | 코드 5 + 컬럼 1 |
| **V-9 생산형태 governing** (#15) | WEAK 🟡→PASS | **신규 그릇 0** — prd_typ_cd + `semi_role_cd`(set_structure 실재)로 PASS·잔여는 값 교정(data round-15) | — | 0 (PASS 재분류) |
| **MAT_TYPE 오라벨 교정** | vessel-level 분류축 결함 | `.09/.10 use_yn='N'`(행 선이동 후)·신소재 .05 흡수 — 신규 0 | 코드 use_yn(행 의존) | 0 (★open decision·B-3 강결합) |

### 카운트 (v1.0 + v2.0 통합)
- **설계한 실 그릇(DDL/코드행 필요): 5** — V-1(JSONB 컬럼)·V-3(BN facet 코드 2 + GS 용량 코드 1)·V-4(코드행 2)·**V-8(PROC_CLASS 코드 5 + proc_class_cd 컬럼 1)**. (+조건부: V-3 capacity 컬럼).
- **"신규 그릇 불요" 재분류: 7** — V-2·#4·V-5·V-6·V-7 + **V-9(prd_typ_cd+semi_role_cd PASS)** + MAT_TYPE(신규 0·use_yn만). + essential(V-4 내부 PASS).
- **신규 테이블 mint = 0건 유지**(GS도 전부 코드행/컬럼/기존 그릇 재사용). ★GS 핵심 교훈: 라이브 재측이 갭분석 추정을 *완화* — #14 형태가공은 prcs_dtl_opt(봉제 파라미터 실재)+ref_param_json으로 거의 PASS·분류축 1개만 결손, #15 생산형태는 semi_role_cd(set_structure) 발견으로 신규 0. **갭분석 "GAP/WEAK"를 designer 라이브 재측이 정정한 정당 사례.**

---

## 1. 적용 순서 (leverage + FK 위상)

> [HARD] FK 위상: 목적지 그릇(자재 분해·제약 코드)이 옵션/제약/축이동의 참조 대상 → 선행. 공정 파라미터는 공정 행 선행(이미 라이브).

### Wave 1 — 경량 코드행 (즉시·무위험·무영향)
1. **V-4 RULE_TYPE.04/.05 코드행** — 제약 거버넌스. 기존 행 무영향·FK 0. match/min-max(V-6 포함) 일원화. → dbm-ddl-proposer 코드그룹.
2. **V-3 MAT_FACET 코드행** — 자재 분해 facet 분류축(소재/두께). 기존 340행 무영향. → B-3 축이동 *목적지* 선행 조건.

### Wave 2 — JSONB 컬럼 (무잠금·백필 0)
3. **V-1 `ref_param_json` ALTER** — 공정 파라미터. ★영향분석 라이브 469행 기준 갱신(`vessel-process-parameter.md §4`): ADD COLUMN NULL = 백필 0·무잠금, 단 롤백 시 채운 값 백업 권고. CPQ option layer 완성의 선결. → `ref-param-json-proposal.sql` 재사용.

### Wave 3 — 선택적/조건부 (도메인 결정 후)
4. **V-3 `mat_facet_cd` 컬럼** — upr_mat_cd 계층으로 부족 입증 시만(search-before-mint 잔여).
5. **V-2 제약흡수 데이터** — 인쇄방식 게이팅 constraints(경로 A). 후니 1급화 결정(open decision) 후.

### 위임 (본 하네스 밖)
- #4 템플릿가격·V-5 수량·V-7 가격 role → dbmap 가격 트랙 / 샘플 확대.
- 자재/색/형상 **행 오염 축이동(B-3 data)** → dbmap round-22(vessel Wave 1·2 선행 후).

---

## 2. 후니 base-data 관리 체계 정비 권고

1. **jsonb 페이로드 패턴 일관화** — 라이브 jsonb 7컬럼(logic·tags×3·dim_vals·use_dims·prcs_dtl_opt) 중 `options.tags`(494행 전부 빈값)·`sizes.tags`(510중 1행)는 **미사용 유연 슬롯**. 새 facet은 테이블 신설 전에 이 tags/코드행부터 검토(사다리 준수). GIN 인덱스 0 컨벤션 유지(조회는 PK).
2. **분류축은 코드행, 값은 기존 컬럼/jsonb** — V-3 MAT_FACET·V-4 RULE_TYPE 확장이 보여주듯 후니 메타모델 표현력 확장의 90%는 `t_cod_base_codes` 코드행으로 도달. 테이블 mint는 진짜 1:N/독립 lifecycle만.
3. **vessel 선행 → data 이동** [HARD] — round-22 B-3 자재 축이동은 목적지 그릇(MAT_FACET·본체색 option·비치수 size)이 *먼저* 있어야 안전(80/82 상품 BOM이 .08/.09/.10 의존, 자재행 use_yn='N'은 마지막). 본 로드맵 Wave 1·2가 그 선결.
4. **라이브 = 권위, 스냅샷 stale 경계** — 00_schema 스냅샷(2026-06-06)은 round-22 이전이라 다수 stale(option_items 0→469 등). 그릇 판정은 라이브 information_schema 실측으로(본 세션 전건 라이브 확인).
5. **propose ≠ apply** — 전 그릇 인간 승인 게이트. 가격(#4·V-7)·돈 크리티컬은 특히 신중.

---

## 3. rpm-validator(M-gate) 인계
- **검증 요청:** ① search-before-mint 누락 없는지(특히 V-3 두께/무게 PASS·V-4 essential PASS 재분류·5건 "그릇 불요" 정당성) ② V-1 영향분석이 라이브 469행 반영했는지(기존 제안 0행 stale 교정) ③ 컨벤션 정합(코드 cod_cd 형식·jsonb 관용·FK) ④ 정규화(무손실·무중복·함수종속) ⑤ 신규 테이블 mint 0의 적정성(과소설계 아닌지).
- **NEVER:** 라이브 CREATE/ALTER/COMMIT. M-gate FAIL 시 해당 vessel만 수정·재산출.
- **DDL 위임:** 정밀 SQL = dbm-ddl-proposer(`ref-param-json-proposal.sql` 재사용·코드행 패턴). 본 하네스는 *which vessel & why* + 라이브 영향 갱신.
