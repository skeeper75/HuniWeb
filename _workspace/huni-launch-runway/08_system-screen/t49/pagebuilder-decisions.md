# pagebuilder 결정·관리 안건

계약 보충 4에 따라 `_part-pagebuilder.csv`에서 분리한 행입니다. 화면도 기능도 아니라 **누군가 정해야 끝나는 일**이므로 `screens.csv`의 행이 아닙니다. 9/17 원장 735행이 제자리이고, 여기 두면 이중계상입니다.

판별 신호는 리드가 준 그대로 썼습니다 — `screen_name`을 지어내야 했던 행.

| plan_row_id | 안건 | 미결 내용 | 근거 path:line | 결정 주체 |
|---|---|---|---|---|
| NEW | data-proxy 허용 도메인·인증 정책 공개 (S2) | 파트너사가 `/api/data-proxy`의 허용 도메인·인증 헤더 정책을 공개해야 후니 상품 API 직결 가부를 판정할 수 있다. 현재는 `GET → 405`(라우트 실재·POST 전용)까지만 확인했고 쓰기 요청은 실행하지 않았다. 체크리스트·디자인가이드 탭의 데이터 공급 경로가 여기 걸린다 | `_workspace/huni-page-compose/99_proposal/proposal.md:172` · `_workspace/huni-page-compose/01_recon/pie-canvas-engine-capabilities.md:85-96` | 파트너사 |
| NEW | 사이트 1개 N상품 성능 실측 (X1) | 테스트 사이트에 257항목을 CSV로 등록한 뒤 렌더·편집 응답을 측정한다. 이 실측 1건이 ① 묶음 분할 필요 여부 ② 전사 공통 수정이 1곳인지 2~4곳인지 ③ 실무진이 배울 개념 수를 동시에 결정한다. 제안서가 스스로 "다른 어떤 문서 작업보다 먼저"라고 적은 항목 | `_workspace/huni-page-compose/99_proposal/proposal.md:144` · `:280` | 후니 실무진 |
| NEW | 기존 복제 사이트 회수 기준 (X5 · PC7 FAIL) | 무엇이 확인되면 구 사이트를 내리는가 — 폐기 시점·판단 기준·URL 리다이렉트 규칙·중복 노출 차단 절차가 **문서에 전무**하다. 게이트가 이 부재를 이유로 PC7을 FAIL 처리했다. 대상은 실측 사이트 3개 | `_workspace/huni-page-compose/06_gate/gate-verdict.md:40` · `_workspace/huni-page-compose/99_proposal/proposal.md:152` | 후니 실무진 |

## 옮기지 않은 후보

리드 제안대로 아래 4건은 CSV에 남겼습니다. 기능·행위를 지목하므로 안건이 아닙니다.

| screen_id | 남긴 이유 |
|---|---|
| `pc-req-f1-display-cond` | 템플릿 표시 조건이라는 **기능**. 파트너사가 만들면 끝나는 것이지 누가 정할 일이 아니다 |
| `pc-req-f2-partial-override` | 부분 override라는 **기능** |
| `pc-req-f3-link-1n` | `link-product`를 복수 `productId`로 확장하는 **기능**. 단 C7의 ⓐ(공식 확인) 갈래로 결론나면 이 행은 소멸하고 안건만 남는다 — 그때 다시 옮겨야 한다 |
| `pc-req-s1-domain-allow` | 허용목록에 후니 도메인을 등록하는 **행위**. S2(정책 공개)와 달리 무엇을 할지가 이미 정해져 있다 |

`pc-link-product`·`pc-editor-hardnav`·`pc-new-product`도 남겼습니다. 각각 실재하는 엔드포인트·화면·라우트를 가리키며, 이름을 지어내지 않았습니다.
