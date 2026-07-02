---
name: hlg-option-usage-audit
description: 후니 적재 거버넌스 하네스의 옵션 쓰임새 전수 판정 방법론. 상품별 옵션그룹·옵션·옵션아이템을 3용도 잣대(U-1/U-2/U-3)로 전수 태깅하고, 기준정보 중복(기준정보를 적재하고 똑같이 옵션도 넣은 것)·중복 mint·용도 초과를 적발해 처분 명세(KEEP/RETIRE/MOVE-기준정보/MOVE-제약/MOVE-템플릿/EXTEND)를 만든다. 가격종속=BLOCKED 분리·선택지 손실 0·실무진 IMPORT 존중. 트리거 — '옵션 쓰임새 판정', '옵션 중복 진단', '옵션 처분 명세', '기준정보 옵션 중복', '옵션 오남용 진단', '옵션 판정 다시'. 규범 작성은 hlg-vessel-norm-authoring, 게이트는 hlg-governance-gate-validation 담당.
---

# hlg-option-usage-audit — 옵션 쓰임새 전수 판정 방법론

## 판정 파이프라인 (상품 단위)
1. **인벤토리** — 라이브에서 해당 상품의 option_groups→options→option_items 전수 + ref_dim_cd 해소(어느 축의 무엇을 가리키는가). 동시에 기준정보 바인딩(product_materials·product_processes·product_sizes·print_options·plate_sizes) 전수.
2. **중복 대조 (D-1)** — 옵션아이템의 해소 결과와 기준정보 바인딩을 축별로 조인. 같은 대상을 양쪽이 다 가리키면 중복 후보. 이때 어느 쪽이 실제 소비되는지(가격시뮬레이터 selection·webadmin 화면·evaluate_price 입력 경로) 확인 — 스티커류처럼 시뮬이 option_items.ref_key1을 보는 상품은 옵션이 실소비자다([[sticker-pipeline-260628]]).
3. **용도 태깅 (D-2)** — 각 옵션(그룹)에 U-1/U-2/U-3/OVER 태깅 + 근거. 잣대는 `01_norm/option-usage-criteria.md` verbatim.
4. **중복 mint (D-3)** — 같은 의미 옵션의 상품 내/간 중복(표시명·내부값·ref 대조). §17 표시중복 산출을 1차 증거로.
5. **처분 (D-4)** — KEEP/RETIRE/MOVE-기준정보/MOVE-제약(§31 CN-6 큐)/MOVE-템플릿/EXTEND. RETIRE는 논리삭제(del_yn) 방향만 — 물리 DELETE 명세 금지.

## 안전 가드 [HARD]
- **가격종속 BLOCKED** — 다음 중 하나면 처분안은 내되 실행 금지 분리: option_items가 가격 조회 키(ref_key1 등)로 소비됨 / use_dims에 opt_cd / 옵션이 공정 BUNDLE로 단가행에 참여. 정리하면 가격이 깨진다.
- **선택지 손실 0** — RETIRE/MOVE 전건에 "이관 후 같은 선택이 가능한 경로"를 명시. 경로가 없으면 KEEP. 정당 조합 차단=매출 차단.
- **실무진 IMPORT 존중** — IMPORT 시트로 등록된 자재·옵션은 배선이 안 됐다는 이유로 삭제 대상 아님 — 배선·단가를 채울 EXTEND 갭으로 분류.
- **숫자 전사 금지** — 대조는 CSV 캐시·스크립트 diff로(LLM 손 전사 금지). 기존 추출(24_master-extract·live-snapshot·§21 03_cpq_link)을 1차 재사용.

## 산출 형식
- `option-usage-board.csv` — `prd_cd,옵션그룹,옵션,ref해소,용도태그,기준정보중복,중복mint,가격종속,처분,근거`
- `disposition-spec.md` — 처분별 실행 명세(대상 행 식별자·이관 목적지 테이블·순서·undo 방향)·BLOCKED 목록·AMBIG 컨펌 큐. "정리할 것 없음"이면 NO-OP 명시(억지 결함 생산 금지).
