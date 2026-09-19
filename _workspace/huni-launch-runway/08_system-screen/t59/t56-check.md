# ㉳ t56 보정 제안 2건 검증

t56 원장(`t56/rejudge.csv` · 커밋 `5bb97cfd`)은 **고치지 않았다.** 아래는 제안이고 결정은 지니다.
검증 방식 = 해당 행의 `evidence` 가 가리키는 **파일을 직접 열어** 확인.

---

## 1. `STD-ADC-014` 「인쇄 가이드 콘텐츠 관리」 → 서희항 재배정은 분할이 맞지 않는가

**t56 판정**: 재배정 → 서희항 · `merged-owner_side` · 근거 「그 일이 사는 곳=webadmin」
(`t56/rejudge.csv:477` · `t56/reassign-proposal.md:32`)

### 실독

| 연 파일 | 확인한 것 |
|---|---|
| `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:72-87` | 「상품별 작업가이드 파일 관리」 라우트 6개 실재 — `guide_file_md`(목록 화면) · `guide_list` · `guide_presign` · `guide_save` · `guide_delete` · `guide_discard`. 전부 `admin.site.admin_view` 로 감싼 **webadmin 화면**이다. |
| `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/s3_guide.py:269-291` | `presign_put` — 브라우저 직결 PUT presign 발급. 업로드 경로가 webadmin 에 완성돼 있다. |
| `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:81-83` | `guide_save` 주석: 「prd_cd 스코프 부분 upsert(**표시명·태그·순서·비고만** 갱신, 원본파일명·키는 불변)」 |
| `_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv` | 504행 · 상품 88종 · **`guide_nm`(표시명) 504행 전부 공란** (스냅샷 260827) |

### 판정 — **t56 의 재배정은 맞다. 그러나 분할이 더 맞다.**

- **도구(화면·업로드·삭제) = webadmin = 서희항.** t56 이 옳다. 뒤집지 않는다.
- **그런데 이 행의 이름은 「콘텐츠 관리」다.** `guide_save` 가 갱신하는 것은 파일 자체가 아니라
  **표시명·태그·순서·비고** — 즉 **운영이 채워야 하는 값**이고, 라이브 스냅샷에서 그 값이 **전건 공란**이다.
  계약 **보충 3**의 「능력(build)과 오픈 전 실무진이 값을 넣는 일(config)은 별도 행」에 정확히 해당한다.
- **제안**: `STD-ADC-014` 를 **분할** — 도구·화면 = **서희항**(t56 판정 유지) / 파일 등재·표시명·태그·순서 채우기 =
  **최숙진**(`NEW-G4`). t56 이 `STD-CAT-019`·`STD-INF-007` 에 적용한 「원고와 화면은 다른 일」 논리를 같은 축에 일관되게 적용하는 것이다.

### 덤으로 찾은 결함 1건 — `check_method` 가 다른 시스템을 가리킨다

`plan-rows.csv` 의 `STD-ADC-014` 는 `evidence` 로 **webadmin** 을 대고 있으면서
`check_method` 는 **「샵바이 셀러어드민(service.shopby.co.kr) > 회원/게시판/프로모션 메뉴에서 …」**를 확인처로 적는다.
그 화면은 webadmin(`urls.py:72-87`)에 있고 셀러어드민에 없다. **확인처 교정 필요**(제안 — 원장 수정은 지니 결정).

---

## 2. `STD-CAT-007`·`STD-CAT-034`·`STD-ADP-015` — 도구=김동학 유지 + 콘텐츠 짝 행=최숙진

**t56 판정**: `STD-CAT-007` 담당맞음(김동학) · `STD-CAT-034` 분할(김동학+서희항) ·
`STD-ADP-015` 담당맞음(김동학 · **manual-read**) (`t56/rejudge.csv:36,61,413`)

### 실독

| 연 파일 | 확인한 것 |
|---|---|
| `/Users/innojini/Dev/huni-skin-shopby/src/app/(main)/product/[slug]/page.tsx:49-56` | 스킨은 `fetchPublishedDetailTabs(...)` 로 **발행본을 읽기만** 한다. 만드는 코드가 아니다. |
| `/Users/innojini/Dev/huni-skin-shopby/src/lib/printly/detail-tabs.ts:16-32` | `TAB_SOURCES` — 발행본으로 채울 수 있는 탭은 **차별점·디자인보기·디자인가이드·유의사항 4종**뿐 |
| `/Users/innojini/Dev/huni-skin-shopby/src/lib/printly/detail-tabs.ts:5-6` | 주석: 「여기 없는 탭(유의사항·포장/배송·상품리뷰)은 항상 기존 정적/라이브 섹션」 |
| `/Users/innojini/Dev/huni-skin-shopby/src/components/product/product-sections.tsx:14-46` | 발행본이 없을 때의 차별점 = **핀버튼 전용 카피** 하드코딩 |
| `/Users/innojini/Dev/huni-skin-shopby/src/components/product/product-sections.tsx:146-153` | 유의사항 고시값 = 품명 「프리미엄 인쇄 상품」·`A4`·「몽블랑 190g」·「3박 4일」·「OPP 포장」 **전 상품 고정** |

### 판정 — **도구 담당은 t56 이 맞다. 짝이 되는 콘텐츠 행은 원장에 없다.**

- **세 행 모두 도구·화면·배선이다.** 김동학 유지(`STD-CAT-034` 의 김동학+서희항 분할도 유지).
  `STD-ADP-015` 는 t56 이 이미 파일을 열어 판정한 `manual-read` 행이고, 이 카드가 같은 파일을 다시 열어 같은 결론을 얻었다.
- **그런데 그 도구로 무엇을 채울지는 어디에도 없다.** 상세탭 축의 원장 행 5개(`STD-CAT-007`·`034` ·
  `STD-ADP-015` · `STD-SYS-021` · `STD-SYS-049`)가 **전부 도구 쪽**이고 최숙진 행은 **0**이다.
- **제안 — 계약 보충 3의 `config` 짝 행 4건**(전부 최숙진):

| 신규 | 내용 | 근거 |
|---|---|---|
| `NEW-D1` | 게시 상품별 탭 4종 발행본 채우기 | `detail-tabs.ts:16-32` |
| `NEW-D2` | 미발행 상품 정적 폴백 문구 교체 **또는** 오픈 전 발행 필수 상품 목록 확정 | `product-sections.tsx:14-46` |
| `NEW-D3` | 유의사항 상품정보 고시값을 상품(군)별로 정의 | `product-sections.tsx:146-153` |
| `NEW-D4` | 포장/배송·상품리뷰 탭 문구 확정 주체 지정(페이지빌더로 못 고친다) | `detail-tabs.ts:5-6` |

보충 3 은 「`config` 쌍둥이 행을 모든 build 행에 기계적으로 만들지 않는다 — 오픈 전 필수 세팅임을 evidence 로 댈 수 있을 때만」이라고
제한한다. 위 4건은 그 조건을 만족한다: **발행본이 없으면 오픈 시점에 핀버튼 카피와 고정 고시값이 전 상품에 노출된다**(`product-sections.tsx` 실독).

### 남은 미확인

**분모를 재지 못했다** — 게시 상품 중 발행본이 있는 상품이 몇 건인지는 라이브 조회(`vc_v_product_detail_tabs`)가 필요해
이 카드에서 재지 않았다. `NEW-D1`~`D4` 의 크기는 그 수가 나와야 정해진다.
