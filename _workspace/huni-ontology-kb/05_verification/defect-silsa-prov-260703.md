# 결함 보드 — 실사(silsa) 출처·권위·오염 + 레더 crosscut

> verifier(okb-adversarial) · 2026-07-03 · 대상 = 실사 28상품 PRD_000118~145 (silsa-file 노드 322개)
> 방법 = `05_verification/scripts/silsa_prov_authority_260703.py`(결정론 재실측·live-snapshot snap_20260702_1119 직접 재조회) + 반증 패널.
> 생성자 리포트 비신뢰 — 판정은 nodes.jsonl/edges.jsonl 직접 로드 + CSV 재조회로만.

## 판정 요약 (배정 축)

| 축 | 결과 | 근거 |
|----|------|------|
| 출처 실재성(5필드) | PASS 0결함 | 322 노드 전수 src 5필드 결측 0·src_id 결측 0 |
| 권위 정합(live 재조회) | PASS 0오차 | 28상품 prd_typ_cd/use_yn/del_yn live 일치·anchor 실재 0결함 |
| 오염(STALE·양면위반·false-defect) | PASS 0 | STALE 인용 0(경고문맥 제외)·양면표기 정확·false-defect 0 |
| 레더 crosscut | PASS 정확 | 아래 §1 |
| 카테고리/constraints 해소 양면표기 | PASS 정확 | 아래 §2·§3 |
| 결함 | **Low 1건**(src_id 추적성) | 아래 §4 |

## 1. 레더 MAT_000186 crosscut — 전수 일치 (반증 실패=생존)
- live `t_mat_materials/MAT_000186`: `mat_typ_cd=MAT_TYPE.05·use_yn=Y·del_yn=N·upd 2026-06-27` → KB node `material-MAT_000186` claim **일치**.
- crosscut(del_yn=N)= `PRD_000100·126·296·298` (4상품) → KB note "100/126/296/298" **정확**. (all-rows=동일·논리삭제 잔재 없음)
- MAT_TYPE 코드 개편 실측: `.05=특수소재·.06=도장부자재·.08=실사소재·.19=시트커팅지·.12=사입자재` → KB의 "round-13 목표 '.06 가죽'은 STALE" 판정 **정확**(false-defect 아님).
- 패브릭 소재유형 현재값 전수 대조: 181 그래픽천/182 현수막천/183 메쉬 = 아직 `.08`(미교정), 184 린넨/185 캔버스/186 레더/187·188 타이벡 = `.05`, 189 시트커팅지 = `.19`, 190 카드거울 = `.12` → KB claim 전수 **일치**.
- ★false-defect 반증: mesh 128(MAT_000183 여전히 `.08`)은 **양면 defect가 아니라 GAP**(`gap-128-mesh-mattype-correction`)으로 정직 선언 — 정정 목표 코드가 개편으로 불명이라 단정 회피. DB note의 "→원단(.05)" 목표 라벨을 STALE로 정확히 격리. **과적발 없음**.

## 2. 카테고리 고아 해소 — 양면표기 정확
- live `CAT_000298 실사 del_yn=Y`(06-18 삭제) → 실사→CAT_000298 잔여 링크 **0**(해소).
- 재배치 분포 전수: `CAT_000004×12·005×3·072×2·076×3·080×7·092×4·097×2·314×6·315×4`. 신규 노드 `CAT_000314 아트포스터`(lvl2·upr 004)·`CAT_000315 배너/현수막`(lvl2·upr 005) live 실재·활성.
- KB node(118/126)는 `CAT_000298 del_yn=Y·STALE·해소`를 양면표기 — round-13 "전부 고아"를 현재값 결함으로 **오재발 안 함**(T-1 통과).
- 관찰(비결함·Low↓): root(004/005) 직결 15건 + leaf 병기 = main/sub 이중링크. KB가 "root 직결·leaf 귀속 정밀도 확인대상"으로 이미 정직 라벨(현재값). 정합 판정은 연결완전성 레인 몫.

## 3. constraints·addon·set — live 재조회 일치
- 실사 constraints = 7행 / 7상품 `118·120·121·122·124·125·139` 각 1행 → KB claim **정확**. `138 일반현수막=0행` 확인. logic=실 JSONLogic(size_mode/width 범위) 실재.
- addon 0행·set(부모) 0행 → KB "잔존 미교정" **정확**(위키 🔴 유효).

## 4. [Low·PROV-HYGIENE] src_id 비-레지스트리·별칭 불일치 — 추적성 결함
- **증거(재현):** `silsa_prov_authority_260703.py` + alias 집계. `src_id`는 `source-registry.md`·`pack-silsa.md` 어디에도 정의 없음(SR-* 키 0건). 즉 레지스트리 백킹 없는 빌더 임의 태그.
  - 같은 `mapping.md`가 **5개 src_id**로 인용: `SR-13-silsa-mapping·SR-map-areamatrix·SR-mapping-silsa·SR-pack-silsa·SR-silsa-mapping`.
  - `HARNESS-DOMAIN-RULES-260701.md` = 2개(`SR-4-domrules·SR-domain-rules`).
  - ★`gap-142-uv-process`가 live CSV `t_prd_product_processes.csv`를 `SR-pack-silsa`로 태깅(팩 아님=오태깅).
- **영향:** 가격·권위 영향 **없음**(source_file/source_locator 실측 필드는 전수 정확·재검증 0오차). 그러나 src_id→레지스트리 lookup 불가·상호참조 신뢰 불가·"정규 인덱스" 착시.
- **심각도:** Low(추적성 위생·가격 무영향).
- **교정안:** ① src_id 정규 키 표(source-registry에 SR-* 등록) 신설 후 별칭 통일, 또는 ② src_id를 free-form로 강등 명시(그래도 §4 CSV 오태깅은 SR-5-livesnap로 교정). 
- **라우팅:** architect(src_id 컨벤션 결정) + builder(별칭 통일·CSV 오태깅 교정).

## 검증 범위·한계 (정직 명시)
- 전수(결정론): 실사 322 노드 src 5필드·28상품 authority·레더 crosscut·카테고리/constraints/addon/set·STALE 패턴·양면표기·transcribe 스크립트 존재(45/45)·numeric 표본(레더 52셀 19000~126000 EXACT).
- 표본/미수행: 가격 evaluate_price 실호출 대조는 본 축 범위 밖(연결완전성/가격경로 레인 몫)·고정가 15상품 단가행 셀 전수 값대조 미수행(면적 13 표본만)·constraints logic 의미 정합(폼빌더 shape 적정성)은 §31 레인 몫.
- **"무결" 단정 안 함** — 본 축(출처·권위·오염+레더)은 반증 실패로 생존, Low 1건 잔존. 타 축(그래프 무결성 재실행은 별도 확인: idem hash 동일·hard=0) 판정은 해당 verifier 몫.
