# ㉲ 입력 자료 실재 확인 — 정책 엑셀 · 가이드북 원고 · 대조 리포트

읽기전용 확인. **찾은 것은 절대경로와 실측값으로, 못 찾은 것은 「찾지 못했다」와 돌린 패턴으로 적는다.**

---

## 1. 정책 엑셀 — **있다**

| 파일 | 절대경로 | 갱신 | 상태 |
|---|---|---|---|
| 운영정책 260918 | `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_260918.xlsx` | 2026-09-18 20:41 | **일부 미완**(아래 표) |
| 운영정책 260827 | `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_260827.xlsx` | 2026-08-27 10:51 | 이전 판 |
| 리뉴얼 정책체크리스트 | `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx` | 2026-04-01 14:06 | 시트 5(IA-정책 통합 체크리스트 · shopby 분류 요약 · CUSTOM 필수 개발 · 운영정책 결정사항 · 범례) |
| 이용약관 / 개인정보처리방침 | `…/후니프린팅_이용약관_260827.docx` · `…/후니프린팅_개인정보처리방침_260827.docx` | 2026-08-27 11:30 | 현행 약관 원천 |

**운영정책 260918 시트 실측**(`openpyxl` · `max_row`·`max_column` 을 루프 전에 고정 · 값은 셀에서 직접 읽음):

| 시트 | max_row | max_col | 내용행 |
|---|---|---|---|
| 구매배송정보 | 1007 | 26 | 10 |
| 할인쿠폰 | 1003 | 27 | 2 |
| 회원등급 | 14 | 13 | 8 |
| 리뷰정책 | 15 | 4 | 9 |
| 프린팅머니 | 30 | 6 | 6 |
| 결제방법 | 7 | 4 | 6 |
| 증빙서류신청 | 34 | 3 | 6 |
| 삭제기준 | 8 | 2 | 4 |
| IA(정리중) | 45 | 5 | 41 |
| FAQ(정리중) | 157 | 3 | 94 |

「내용행」 = 그 행에 비지 않은 셀이 하나라도 있는 행의 수. **두 시트가 시트명에 「(정리중)」을 달고 있고**,
FAQ 시트 3행의 값은 문자 그대로 「정리중입니다」다.

## 2. 운영정책 260918 ↔ 현행 약관 대조 리포트 — **있다**

커밋 **`48714c44`** (2026-09-19 07:35, 지니) — 이 브랜치의 분기점이다.

| 산출물 | 절대경로 |
|---|---|
| 리포트(md) | `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_검토요청_260918.md` |
| 리포트(html) | `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_검토요청_260918.html` |

커밋 메시지와 본문이 적은 상태: 정책 항목 **49건** — 실무진 결정 대기 **21건** · 바로 반영 가능 **20건** ·
화면 문구 **5건** · 오픈일(10/06) 이후 목표 **21건**. 개발 공수 분해로는 49건 중 25건이 공수 0에 가깝고 실제 개발 24건.
리포트는 약관·화면 파일을 수정하지 않았다(리포트만 추가한 커밋).

→ **③ 축의 입력은 이미 갖춰져 있다.** 없는 것은 **21건에 대한 회신을 담는 원장 행**이다(`NEW-P4`).

## 3. 가이드북 원고 — **찾지 못했다**

고객용 가이드북(파일작업·책자·인쇄와 종이·후가공·주문·편집기)의 **글 원고 파일을 찾지 못했다.**

돌린 패턴(전부 읽기전용):

```
ls /Users/innojini/Dev/HuniWeb/docs/huni/ | grep -i "가이드\|guide"        → 0건
find /Users/innojini/Dev/HuniWeb/_workspace -iname "*가이드*" -o -iname "*guide*"
```

찾은 것 중 **가이드북 원고가 아닌 것**(오인 방지용으로 남긴다):

- `_workspace/print-quote/05_guides/printing-guide-story-manual.md` — 사업 설명 스토리텔링 초안(2026-07-04). 고객 가이드가 아니다.
- `_workspace/huni-dbmap/10_configurator/option-vs-template-guide.md` · `_workspace/print-dsl/PRINTDSL-GUIDE.md` — 내부 개발 문서.

**대신 확인된 것 — 가이드 「파일」은 있고 「글」이 없다.**

- 화면·글: `/Users/innojini/Dev/huni-skin-shopby/src/lib/guide-data.ts` 에 **72편 중 71편이 자리표시자**(§①).
- 다운로드 자료: 라이브 스냅샷 `_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv`
  — **504행 · 상품 88종 · del_yn 전건 N · 확장자 ai 313 / psd 191**.
  그런데 **`guide_nm`(표시명)이 504행 전부 공란**이다.
  webadmin 의 가이드파일 관리 화면은 표시명·태그·순서·비고를 upsert 할 수 있다
  (`/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:81-83` `guide_save`) — **도구는 있고 값이 비어 있다.**
  ⚠ 이 수치는 **2026-08-27 스냅샷**이고 라이브 현재값이 아니다. 오픈 전 재확인 필요.

## 4. 그 밖에 이 카드가 실재를 확인한 입력

| 자료 | 절대경로 | 확인한 것 |
|---|---|---|
| CTO 주문흐름 문서 | `/Users/innojini/Dev/HuniWeb/docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html` | 구간 08 네 단계 · 구간 09 「가장 큰 공백」 문장 |
| 진입 조건 9항 | `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md:89-97` | 9항 전문 · **담당 열 없음** |
| 실무운영 인원 | `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md:62` | 「실무운영 최숙진 실장·김용기 부장」 |
| 상세탭 매칭 규칙 | `/Users/innojini/Dev/huni-skin-shopby/src/lib/printly/detail-tabs.ts:5-6,16-32` | 발행 가능 탭 4종 · 나머지는 정적 |
| 정적 폴백 문구 | `/Users/innojini/Dev/huni-skin-shopby/src/components/product/product-sections.tsx:14-46,146-153` | 핀버튼 카피 · 고정 고시값 |
| 가이드 관리 화면 | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:72-87` · `webadmin/catalog/s3_guide.py:269-291` | 목록·presign·save·delete·discard 실재 |

`raw/webadmin` 은 별도 git 저장소다 — 이 카드는 **읽기만** 했다(쓰기·커밋 0).
