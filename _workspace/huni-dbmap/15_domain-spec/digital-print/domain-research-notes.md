# 디지털인쇄 — 도메인 리서치 노트 (round-11 파일럿)

> **작성** 2026-06-10 · round-11. **신규로 리서치한 갭·발견한 충돌·🔴/🟡 컨펌 질문만** 기록. 07_domain이 이미 닫은 것은 재기술하지 않는다(재유도 0).
>
> **권위:** 후니 PDF > 07_domain KB > 국내외 표준(보조). 표준 충돌 시 후니 권위.

---

## 0. 07_domain 재사용 — 신규 리서치 불요 영역 (재유도 0)

디지털인쇄의 다음 의미는 07_domain이 이미 권위로 확정 → 본 round-11은 인용만:

| 주제 | 07_domain 권위 | round-11 적용 |
|------|----------------|---------------|
| 디지털 인쇄방식·공정 레시피 | `process-recipe-tree.md §1`(PROC_000004 토너·코팅→재단→후가공) | 7상품 공정 체인 도출 |
| 별색 = 공정(도수 아님) | `entity-semantic-model.md §3-2`(화이트/클리어/금/은 용도) | C18~22 → process |
| 별색금 ≠ 박금 | `§3-2`(잉크 vs 포일 압착) | C21 vs C37 분리 |
| 9속성 의미축 | `§1`(size/material/print/process/plate/bundle/page/addon) | 44컬럼 귀속 |
| size≠plate≠work | `§1·6`·메모리 platesize-is-output-paper | C5/C8/C10 3축 분리 |
| 판수=앱계산 | 메모리 compute-in-app-db-stores-lookup | C6 미저장 |
| 자재=parent+usage(낱장 C단일) | `§4`(생산구조 3종) | 자재 권위 위치 |

→ **디지털인쇄는 07_domain 커버리지가 높아 신규 WebSearch 갭이 적다.** 신규 리서치는 아래 컨펌 항목에 국한.

---

## 1. 발견한 충돌 — 없음

엑셀 실측값 · 07_domain · webadmin 소스 3자가 정합. round-11 파일럿에서 도메인 충돌(예: round-9 카드봉투 색=siz 같은 오모델) 미발견. **디지털인쇄는 의미축이 깨끗하게 분리된 시트** — 별색/도수, 작업/재단/출력판형이 별 컬럼으로 명시돼 있어 평면화 위험이 낮다.

> 단, **카드봉투(화이트/블랙)가 엽서 추가상품(C38)으로 등장** — round-9가 경고한 PRD_000004/281/282 카드봉투 색=siz 오모델과 동일 대상. 디지털인쇄 시트에선 addon(template)으로 나타나므로, 그 귀속은 round-9 escalate + `schema-design-intent-map.md`가 정한다(본 round-11 범위 밖, 포인터만).

---

## 2. 🔴/🟡 컨펌 질문 (인간 결정 대기)

### CONFIRM-DP-1 [🟡] C37 박칼라 — 공정 param vs 포일 자재?
- **상황:** 박칼라(금유광·은유광·동박·먹유광·청박·적박·홀로그램·트윙클 9종)가 박 공정의 색상 선택.
- **두 모델:** (A) 공정 param `prcs_dtl_opt.박색` (B) 포일 자재 `t_mat_materials`(MAT_TYPE 부속) + dep_proc_cd.
- **가설(유력):** (A) 공정 param — 박은 금형 압착 공정이고 색상은 그 변형. 별색잉크가 공정인 것과 평행.
- **검증 필요:** RedPrinting 역공학(`docs/reversing/` 박 componentType·MES) 대조. WowPress 박 SKU 처리 참조.
- **질문:** 박칼라를 박 공정의 param으로 둘까요, 아니면 포일을 자재로 등록할까요?

### CONFIRM-DP-2 [🔴] C11 파일명약어 · C13 폴더 — 견적 DB 귀속?
- **상황:** 파일명약어(엽서·코팅엽서·별색엽서 26종)·폴더(디지털인쇄·*아이마크·박명함·합판인쇄 4종)는 생산 파일명 생성·작업 폴더 라우팅용. t_* 컬럼 부재.
- **가설:** 견적·상품 DB 밖(생산/MES 워크플로우 메타). 견적 위젯엔 불필요.
- **질문:** 이 둘을 (a) 견적 DB 밖(MES 전용)으로 둘지 (b) note 컬럼에 보존할지 (c) 신규 컬럼(dbm-ddl-proposer)으로 둘지?

### CONFIRM-DP-3 [🟡] C7 블리드 — 도출 vs 별 컬럼?
- **상황:** 블리드(1·2·3·5mm)는 작업−재단 치수 차의 절반. `t_siz_sizes`엔 work/cut/margin은 있으나 블리드 전용 컬럼 부재.
- **가설:** work_width−cut_width = 2×블리드로 **도출 가능** → 별 저장 불요. 또는 margin_*에 분배.
- **질문:** 블리드를 work-cut에서 도출할까요, margin에 적재할까요?

### CONFIRM-DP-4 [🟡] 별색 핑크/금/은 proc_cd 정합
- **상황:** 별색 화이트(PROC_000008)·클리어(PROC_000009)는 07_domain 권위 확정. 핑크/금/은(PROC_000010~012)은 family 추정.
- **질문:** 라이브 `t_proc_processes` 별색 family 자식 enum 재확인 필요(dbm-schema-analyst). 본 round-11은 가설 표기.

### CONFIRM-DP-5 [🟡] C26 건수 vs 묶음 단위
- **상황:** 건수(옵션)=Y가 일부 상품. `qty_unit_typ_cd`(QTY_UNIT)에 건/권/세트 enum.
- **질문:** 디지털인쇄 낱장의 수량단위가 "건"인지(QTY_UNIT 코드 확정) — 라이브 코드값 확인.

---

## 3. 다음 단계 (파일럿 → 확대)

1. **컨펌 5건 해소** — CONFIRM-DP-1~5를 사용자/라이브 대조로 닫기.
2. **방법론 검증 완료** → 디지털인쇄가 깊이 기준(컬럼사전 44 + BOM 7 + 적재명세 + 매핑정보)을 세웠으니, 같은 4산출 패턴으로 나머지 10시트(스티커·책자·포토북·캘린더·디자인캘린더·실사·아크릴·문구·굿즈파우치·상품악세사리) 확대.
3. **schema-design-intent-map 입력** — 본 round-11 산출(엑셀 측 의미)을 HANDOFF #1 `schema-design-intent-map.md`(t_* 설계의도)와 결합 → 매핑이 "도출".

---

## Sources
- 후니 권위(1순위): `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf` · `docs/huni/후니프린팅_주문프로세스_20251001.pdf` · 상품마스터 `260610.xlsx` 디지털인쇄 시트(실측).
- 07_domain KB(2순위): `entity-semantic-model.md`(§Sources에 표준 리서치 URL 통합 — UV/별색/제본 표준) · `process-recipe-tree.md`.
- 라이브 적재 소스: `raw/webadmin/webadmin/catalog/{models,admin,basecodes}.py`.
- (신규 WebSearch: 디지털인쇄는 07_domain 커버리지 충분으로 미수행 — 컨펌 해소 시 박/VDP 표준 리서치 예정.)
