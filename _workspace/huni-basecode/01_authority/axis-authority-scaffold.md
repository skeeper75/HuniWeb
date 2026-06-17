# 축별 정답 사전 스캐폴드 — 나머지 4축 (사이즈·도수·인쇄옵션·공정)

> **하네스** hbg Phase 1 · 후속 확장용 스캐폴드. **작성** 2026-06-18.
> 이번 회차 1순위(자재·카테고리)는 `axis-authority-material.md`·`axis-authority-category.md`로 완성.
> 본 문서는 나머지 4축의 **헤더 + 요약**만 둔다 — 후속 회차에서 정답 사전 표를 채운다.
>
> **권위 순서·확정도 범례는 자재/카테고리 사전과 동일.** 각 축의 1차 권위 입력 경로를 명시해 후속 확장이 재탐색 없이 시작되게 한다.

---

## ② 사이즈 — `t_siz_sizes`

- **정의:** 물리 치수만. 이중축 — **작업치수**(`work_width/height`, 블리드 포함) ↔ **재단치수**(`cut_width/height`, 완성품). `margin_*`(도련)·`impos_yn`(조판가능).
- **소속 코드 도메인:** `SIZ_` 순차 surrogate · OUTPUT_PAPER_TYPE(판형 분류) 참조.
- **라이브 행수(권위):** 500(`schema-design-intent-map §0`) / 510(`02 §0` del 53·impos_yn=Y 79).
- **오염 경계(핵심 결함):** 색상을 siz_nm에 인코딩 금지(OM-1 카드봉투)·형상 enum drop 금지·수량(10장) 인코딩 금지·출력판형↔완성품 혼동 금지. 판걸이수=앱 계산(DB 미저장).
- **상태:** 🟡 size↔option 경계·평면화(부분). 대부분 CORRECT(`02 §1 ②`).
- **삼중 바인딩:** ① `option-button`(이산≤6)/`dimension-matrix-input`(면적형) ② 재단치수=작업지시 컷 ③ 면적매트릭스형 siz=가격 격자 셀/고정가형 siz=직접단가 키 (`schema-design-intent-map §3` #1·#2).
- **1차 권위 입력:** `01-rules §2`(정의·권위·판별·경쟁사·정규화·선후) · `schema-design-intent-map §2.1` · OM-1/OM-3.
- **미해소 컨펌:** AX-2(굿즈파우치 size→option 사슬 보존) · AX-3(실사 비규격 좌표 vs 면적함수).

> **[채울 표 헤더]** `| 코드값/분류 | 올바른 의미 | 소속 t_* | 코드 도메인 | 권위 출처(파일:셀) | 확정도 |`

---

## ③ 도수 — `t_clr_color_counts`

- **정의:** 잉크 색 채널 수(ink color count)만. `chnl_cnt` 0~4. **5행 고정 SEED**(신규 발급 없음): CLR_000001 인쇄안함(0)·002 1도흑백(1)·003 2도(2)·004 3도(3)·005 CMYK4도(4·default).
- **소속 코드 도메인:** `CLR_` 순차(도메인 폐쇄·채널수 0~4 물리 상한).
- **라이브 행수(권위):** 5(`schema-design-intent-map §0`·`02 §0`).
- **오염 경계 [HARD]:** **별색(화이트/클리어/핑크/금/은)을 도수 칸에 넣지 말 것 — 별색=공정**(`PROC_000007` family, clr_cd=NULL). UV 변형을 print_side에 금지. 단/양면(인쇄면)≠도수.
- **상태:** 🟢 양호(별색 분리 정상). ④자재에서 잉크색 유입 시 흡수 목적지(`02 §1 ③`).
- **삼중 바인딩:** ① `option-button`(단/양면) ② 단/양면 인쇄=인쇄팀 ③ 인쇄비(PRC_COMPONENT_TYPE.01) (`schema-design-intent-map §3` #4).
- **1차 권위 입력:** `01-rules §3` · `schema-design-intent-map §2.2`(t_clr WHY) · `entity-semantic-model §3.2`.
- **미해소 컨펌:** AX-1(만년스탬프 잉크색 도수 vs 별색 vs 옵션).

> **[채울 표 헤더]** 위와 동일.

---

## (인쇄옵션) — `t_prd_product_print_options`

> ★ 본 축은 마스터(③도수)와 별개의 **상품연결행 + 별색/UV 라우팅 축**. 정답 사전 시 ③도수·⑤공정과 경계 정밀화 필요.

- **정의:** 인쇄면 도수(단/양면, 앞/뒷면 color count). `opt_id` PK · `print_side` · `front_colrcnt_cd`/`back_colrcnt_cd`(→CLR 5종).
- **소속 코드 도메인:** opt_id(상품별 시퀀스) · OPT_REF_DIM.06(도수=opt_id, NOT clr_cd — `schema-design-intent-map §1.2`).
- **라이브 행수(권위):** 166(`schema-design-intent-map §0`).
- **오염 경계:** 별색을 도수칸에 금지(별색=공정). UV 변형(배면양면/풀빼다)을 print_side에 금지(UV=PROC_000002 param·OM-5). 단면 시 뒷면도수=CLR_000001.
- **삼중 바인딩:** ① `option-button` ② 단/양면=인쇄팀, UV평판=PROC_000002 ③ 인쇄비 (`schema-design-intent-map §3` #4).
- **1차 권위 입력:** `01-rules §3.2·§5.2` · `schema-design-intent-map §2.2` · OM-5.
- **미해소 컨펌:** OM-5(UV/별색 위치) · CONFIRM-DP-4(별색 핑크/금/은 proc_cd 정합).

> **[채울 표 헤더]** 위와 동일. ★ "인쇄옵션"은 도수(③)와 인쇄면·별색 라우팅이 교차하는 축 — 별도 사전 권장.

---

## ⑤ 공정 — `t_proc_processes`

- **정의:** 공정(coating·binding·foil·emboss·cutting·sewing·perforation·attach) + 인쇄방식(self-ref `PROC_000001` 인쇄 부모 → UV/옵셋/디지털/실크/실사 자식) + 별색(`PROC_000007` family) + **`prcs_dtl_opt` JSON param**(타공 구수·오시 줄수·UV 변형).
- **소속 코드 도메인:** `PROC_` 순차(라이브 MAX 000083) · self-ref family · upr_proc_cd.
- **라이브 행수(권위):** 83(`schema-design-intent-map §0`) / 84·22 공정유형(`02 §0`).
- **오염 경계 [HARD]:** 공정 param을 행 분리로 비대화 금지(OM-7·1공정행+param). 자재(거치대/종이)를 공정으로 금지(Q13). 칼틀(모양)을 prcs_dtl_opt에 중복 금지(Q7 siz=칼틀). 별색을 도수로 금지(역방향). 순수공정(열재단·타공)은 자재 억지부여 금지.
- **상태:** 🟡 누락 지배(봉제/보드/삼각대/미싱제본 자식 0)·소수 MIS-LOADED(`02 §1 ⑤`).
- **삼중 바인딩:** ① `finish-button`/`finish-select-box` ② 후가공팀 공정·타공구수=param ③ 후가공비(.04)·박형압비(.05)·코팅비(.02) (`schema-design-intent-map §3` #5·#6).
- **1차 권위 입력:** `01-rules §5` · `schema-design-intent-map §2.2`(t_proc WHY) · `process-recipe-tree §1·§3` · OM-7.
- **미해소 컨펌:** AX-5(공정 param 저장처 prcs_dtl_opt vs ref_param_json) · AX-6(PUR vs 레이플랫) · AX-7(캐스케이드 제약) · B-7(신규 공정 신설).

> **[채울 표 헤더]** 위와 동일.

---

## 후속 확장 시 주의 (전 축 공통)

1. **추정 0** — 권위 침묵분은 가설+출처+컨펌ID로 분리(자재/카테고리 사전 포맷 답습).
2. **라이브 행수 = `schema-design-intent-map §0` 권위 주석** 사용(추가 DB 접속 불요).
3. **삼중 바인딩 인용**(`schema-design-intent-map §3`) — 재유도 금지.
4. **경쟁사는 갭헌팅 전용** — `_authority-conflict-board.md`에 빈칸 후보로만.
5. **scope 규율** — 권위 추출·정리만. 라이브 어긋남 판정은 진단가, 등록 명세는 설계가.
