# 자재 마스터 교정 로드맵 (전 자재) — 인간 승인 큐

- 범위: `t_mat_materials` 전수. **분석·명세까지만 — 실 COMMIT/DDL은 인간 승인 후 dbmap 적재 트랙 위임.**
- 권위: 상품마스터 260610 + 사용자 확정 원칙 4. 근거 실측 = `material-master-audit.md` 재현 SQL.
- 안전: 라이브 읽기전용 SELECT만 수행함. 아래는 **제안**(파괴적 쓰기 0).

---

## 공유 마스터 위험 (선행 경고) [HARD]

`t_mat_materials`는 **공유 기초코드 마스터** — 한 자재행이 여러 상품 BOM(`t_prd_product_materials`) + 가격행(`t_prc_component_prices`)에 참조된다. 자재행 1건 변경이 다수 상품/가격에 전파.

- [HARD·메모리 catalog-conformance-remediation-scope] 카탈로그 정합 교정은 상품별 구성요소만 — **공유 자재 마스터 직접 수정은 공유자원 충돌**. 자재 교정은 영향 상품 전수 SELECT 선행 필수.
- [HARD·메모리 dbmap-del-yn-soft-delete-authority] 진짜 삭제 = **BOM link 제거 선행** 후 del_yn=Y. root 삭제 전 자식 재연결 선행.
- webadmin(HuniProductPrice2) 코드 직접 수정 금지 — 데이터 교정만.

---

## Wave 1 — 🔴 논리삭제 정합 복구 (돈영향·구조 우선)

### W1-1. 좀비 가격행 귀속 재판정 (돈영향 직접)
- 대상: MAT_000159 모조120g(단가행20·wire1), MAT_000119 리브스250g(단가행1·wire4).
- 명세: 각 단가행을 정본 활성 자재로 이전할지, 자재를 부활할지 판정.
  - 모조120g → 활성 MAT_000073(백색모조지 120g)과 동일물 여부 확인 → 단가행 재귀속 or 부활.
- 영향분석 SQL(승인 전 필수):
  ```sql
  SELECT * FROM t_prc_component_prices WHERE mat_cd IN ('MAT_000159','MAT_000119');
  SELECT pm.* FROM t_prd_product_materials pm WHERE pm.mat_cd IN ('MAT_000159','MAT_000119') AND pm.del_yn='N';
  ```
- 라우팅: **dbmap dbm-correctness-audit / dbm-load-execution** (단가행 이동은 돈 크리티컬 → dbm-price-arbiter 사전 심의).
- 승인 큐: ☐ 정본 자재 확정 ☐ 단가행 이전 vs 자재부활 결정.

### W1-2. 좀비 배선 92건 정리
- 대상: del_yn=Y인데 활성 상품 배선 보유 92건. 대표 MAT_000008 레더(wire23).
- 명세: 각 배선을 정본 활성 자재로 재지정(레더 → 활성 레더 stock) 후 삭제 확정. 정본 부재 시 자재 부활.
  ```sql
  SELECT t.mat_cd,t.mat_nm,count(pm.*) FROM t_mat_materials t
   JOIN t_prd_product_materials pm ON pm.mat_cd=t.mat_cd AND pm.del_yn='N'
   WHERE t.del_yn='Y' GROUP BY 1,2 ORDER BY 3 DESC;
  ```
- 라우팅: **dbmap dbm-correctness-audit**(BOM 재배선) → dbm-load-execution.
- 승인 큐: ☐ 레더 정본 stock 지정 ☐ MAT_TYPE.09 색/사이즈 라벨 배선 처리(이는 옵션값이어야 — W2와 연계).

### W1-3. 🔴 종이 family 계층 부활 (고아 64)
- 대상: 삭제 root 9개(몽블랑/스노우/아트/앙상블/백모조/랑데뷰/투명/반투명/띤또) + 비종이 고아(아크릴/D링/링/투명커버 root).
- 명세 — 2안 택1(인간 결정):
  - **(A) root 부활**: 삭제 root del_yn=N 복원 → 활성 자식이 다시 정상 부모를 가짐(최소 변경, 채번 불요).
  - **(B) root 신규 mint + 재연결**: search-before-mint로 root 새로 등록 후 자식 upr_mat_cd 재지정(부활이 부적절할 때).
- 권장: **(A) 부활** — root는 grouping 의미만 가지고 가격행 없음(가격은 자식에). 부활이 채번·재배선 없이 계층 복구.
- 영향분석 SQL:
  ```sql
  SELECT p.mat_cd,p.mat_nm,p.del_yn, count(c.*) active_children
  FROM t_mat_materials p JOIN t_mat_materials c ON c.upr_mat_cd=p.mat_cd AND c.del_yn='N'
  WHERE p.del_yn='Y' GROUP BY 1,2,3;
  ```
- 라우팅: **dbmap dbm-axis-staged-load(자재축)** — root 부활은 자재축 교정.
- 승인 큐: ☐ 부활(A) vs mint(B) 선택 ☐ 비종이 고아(.07/.04/.03/.02) 동일 처리 여부.

---

## Wave 2 — 🟡 오염 정리 (의미/용도/색상 → 옵션·용도 이전)

### W2-1. 면지 3색 CPQ 옵션화 (원칙 ③')
- 대상: MAT_000001 화이트면지 · MAT_000002 블랙면지 · MAT_000003 그레이면지 (가격행 0, wire 각 4).
- 명세:
  1. CPQ 면지색 옵션그룹/옵션값으로 이전(화이트/블랙/그레이 = 색택1). 배선은 이미 usage_cd=USAGE.03(면지) → 옵션 차원으로 환원.
  2. 자재 마스터에서 3행 논리삭제(**BOM link 제거 선행** → del_yn=Y).
  3. **MAT_000004 인쇄면지는 STOCK 유지**(권위: 하드커버링/레더링바인더 전용 실 인쇄 stock). 단 유형 .01 디지털인쇄용지 오귀속 — 면지 용도 stock으로 정합 검토.
- 라우팅: **dbmap dbm-cpq-option-mapping**(옵션값 이전) + dbm-axis-staged-load(자재 논리삭제).
- 승인 큐: ☐ 면지색 옵션그룹 위치(어느 상품군) ☐ 인쇄면지 유형 정정 여부.

### W2-2. 투명커버 마감 옵션화
- 대상: MAT_000010 투명커버 유광 · MAT_000011 투명커버 무광 (wire 0, 즉시 가능).
- 명세: 마감 옵션(무광/유광/없음)으로 — 자재 아님. wire 0이라 영향 최소. 자재 논리삭제 + CPQ 마감 옵션 확인.
- 라우팅: dbm-cpq-option-mapping.
- 승인 큐: ☐ 투명커버 옵션 기존재 확인 후 자재 삭제.

### W2-3. 코팅 융합 stock명 정규화
- 대상: MAT_000172 하드커버전용지+무광코팅(wire0) · MAT_000250 아트250+무광코팅 등.
- 명세: stock(아트250) + 코팅(무광) 분리 표기 검토. 권위(표지종이사양)도 융합 표기라 보류 가능 — 중간 우선.
- 라우팅: dbm-correctness-audit(표기 정규화).

---

## Wave 3 — 🟢 명명·구조 개선 (저위험, 후속)

### W3-1. 카테고리-라벨 grouping shell
- 대상: MAT_000031 캘린더부자재(자식3) · MAT_000012 링(자식5).
- 명세: 자식 보존, root는 grouping 의미만 — 명명 개선(stock 아닌 분류라벨 명시) or 자식 직접 root화. 즉시 위험 없음.

### W3-2. 평면 출력소재 root 통합(보류)
- 스티커/실사 평면 나열 → family root 도입 여지. 단 권위가 단일 stock 운영 → **보류**. 면지/계층 정리 후 재판정.

### W3-3. 누락 출력소재
- 권위(260610) 한정 누락 0. **MES 종이 마스터 통합** 별도 트랙에서 신규등록 재판정(`*별도설정` 해소 시).

---

## 라우팅 요약

| Wave | 결함 | 우선 | dbmap 트랙 |
|---|---|---|---|
| W1-1 | 좀비 가격행 2(돈) | 🔴 | dbm-price-arbiter → dbm-correctness-audit/load-execution |
| W1-2 | 좀비 배선 92 | 🔴 | dbm-correctness-audit → load-execution |
| W1-3 | 종이 계층 부활 64 | 🔴 | dbm-axis-staged-load(자재축) |
| W2-1 | 면지 3색 옵션화 | 🟡 | dbm-cpq-option-mapping + axis-staged-load |
| W2-2 | 투명커버 옵션화 | 🟡 | dbm-cpq-option-mapping |
| W2-3 | 코팅 융합 정규화 | 🟡 | dbm-correctness-audit |
| W3-* | shell/평면/누락 | 🟢 | 후속/보류 |

기초코드 마스터(MAT_TYPE 코드 자체) 변경 필요 시 → **basecode 거버넌스(§12 hbg-*)**. 본 로드맵은 자재 데이터 교정 → **dbmap(§7)** 위임. 전 항목 실 COMMIT 전 인간 승인 + .env.local IGNORED 확인.
