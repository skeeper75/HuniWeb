# POSTER 면적 적재 설계 보정 (재게이트 입력)

> 2026-06-15 · 입력 = 독립 게이트 NO-GO(area-load-design-gate.md) + 오염 반증(contamination-remediation.md) + off-grid/수량 리서치(quantity-offgrid-research.md) + **가격표 포스터사인 시트 직접 확인**.
> 이 보정이 `area-load-design.md` 본문과 `area-load-design-gate.md` §P6를 갱신한다(권위).

## 0. 가격표 수량축 직접 확인 결과 [확정]
포스터사인 시트(메인 직접 열람 R1~R14): 블록=소재별(아트프린트포스터 등), 매트릭스 = **[가로(열 600/800/1000/1200) × 세로(행 600~2800+)] 2D 면적만**, 셀=장당 코팅포함가. **수량축 부재.**
→ **수량 = 선형(면적단가 × 수량) 확정.** 수량구간 체감은 가격표에 없음 → 현재 미도입(도입 시 volume floor tier·별 정책·가격표 명시값이 권위).

## 1. 보정 C-1 ~ C-6

| ID | 항목 | 보정 |
|----|------|------|
| **C-1** | siz 채번 수 | 신규 **109 → 108** (실재 3 아닌 **4**·SIZ_000402 work_dims 1000x1500=일반현수막 좌표 재사용). search-before-mint은 siz_nm 문자열이 아니라 **work_dims 매칭**으로. 비가역이라 보정 후 채번. |
| **C-2** | orientation | 좌표 규약 = **work_width=가로(가격표 열)·work_height=세로(가격표 행)**. 비대칭 좌표 방향 고정·명문화. 기존 부분적재 행(600x1800·1500x1000) 방향 점검 후 정합. |
| **C-3** | 설치옵션 prc_typ | 타공/각목/거치대 = **건당 고정총액** → `.01` 단가형 오적재(D-1b 패턴) → 구간고정총액형 정정 대상(round-13/엔진 트랙). **면적 본체 `.01` 단가형은 정당**(면적단가×수량 선형). 3축 분리 유지. |
| **C-4** | off-grid | **ceiling·앱 런타임·DB 미저장.** 격자 **112좌표만 적재**, 입력 미일치 시 각 축 독립으로 한 단계 큰 격자 흡수(가로 500→600·세로 1100→1200). off-grid 좌표 채번/단가행 적재 **금지**. |
| **C-5** | 수량 방식 | **선형 확정**(§0 가격표 직접 확인). `area-load-design.md §1-3 "밴드 9 comp [siz_cd, min_qty]"` 정정 — 포스터 본체 `min_qty` NULL/1·밴드 부재·use_dims=`[siz_cd]`만. 수량할인 도입 시 **면적단가에만**(설치/거치 제외). |
| **C-6** | nonspec 제약 | nonspec_yn=Y = **포스터/현수막 11상품**(보드/액자 17상품은 이산규격 N). 입력범위 constraints 전수 보강(현 7상품 적재·119/123/127/138 등 누락 → G4.5). JSONLogic size_mode=nonspec width/height min·max. |

## 2. P6 정정 — 게이트 철회

게이트 §P6 "PRD_134/135 오염 실재 → 🔴 FAIL"은 **오판**이다(`contamination-remediation.md`):
- 원인 = 공유 그룹코드(opt_grp_cd) 집계 아티팩트. validator가 prd_cd로 거르지 않고 그룹코드로 집계 → 형제 상품(엽서/스티커/책자) 정상 옵션을 134/135로 오귀속(PRD-키 5행 vs 그룹-키 46행).
- 실제 134=오버로크+봉미싱·135=사각/원형족자 = 엑셀 L1 일치(**clean**·builder 옳음).
- → **P6 철회 · AQ-0(오염 정정) CLOSED 불요.** 3-pass(builder clean → validator FAIL → auditor 반증)로 진실.

## 3. 재게이트 입력 · 적재 선결 순서

보정 반영 후 재게이트(P1~P6, P6 철회·siz 108·수량 선형·off-grid 런타임·prc_typ 분리·nonspec 보강).

```
~~G0 오염정정~~ (CLOSED) → G1 siz 108 채번(비가역·AQ-1) → G2/G3 소재공식 30·바인딩 교체
  → G4 면적단가행(선형·use_dims=[siz_cd]) → G5 설치/거치 옵션(prc_typ 분리)
```

인간 승인 큐: AQ-1 siz 108 채번 / AQ-2 소재공식 30+바인딩 / AQ-3 면적단가행 / AQ-4 설치·거치 옵션 + prc_typ 정정 / AQ-5 엔진(evaluate_price·off-grid ceiling·선형 수량).

미해소 컨펌: PS-B-ADJ(SIZ_000402 현수막 좌표 재사용) · Q-QO-2(수량구간 체감 도입 여부 = 가격표에 없으니 현재 선형·도입은 별 정책).
