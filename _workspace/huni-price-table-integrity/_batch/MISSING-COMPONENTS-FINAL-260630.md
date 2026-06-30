# 전 19시트 가격테이블 미적재 가격구성요소 최종 판정 (2026-06-30 10세션)

> 권위=인쇄상품 가격표 260527(절대) ↔ 라이브 스냅샷 `snap_20260630_1603`(박류 COMMIT 반영·component_prices 18,414행).
> 방법=결정론 배치 diff(`run_all.py`) + 원리2 바인딩 필터(가짜결함 가드) 직접 라이브 실측. DB 미적재.
> 목적=사용자 요청 "각 시트 가격테이블에서 빠진 가격구성요소 확인 → 적재 준비".

## 결론 한 줄

**진짜 미적재 가격구성요소 = 0건. 인쇄상품 가격표 19시트 전 가격테이블 적재 완료.** 박류(foil)가 마지막 적재 대상이었음(10세션 COMMIT).
- 출력소재 specialty 18행 = 가짜결함(원리2 바인딩 0·적재 금지).
- 아크릴 B02 투명1.5T 81셀 = **이미 적재됨**(COMP_ACRYL_CLEAR3T·mat_cd=MAT_000042·verbatim 81/81 일치·가짜 unmapped).

## 시트별 최종 상태 (19시트)

| 분류 | 시트 | 판정 |
|---|---|---|
| **적재 완료 (17)** | 박소형·박대형(10세션) | COMP_FOIL_*SMALL/LARGE 2,168+7,168행 COMMIT·종결 |
| | 디지털인쇄비 | 954/954(100%)·8세션 흑백 COMMIT 반영 |
| | 코팅·접지·인쇄후가공·제본 | 100% verbatim 일치(제본 74/74 복원 반영) |
| | 합판·봉투·엽서북·포스터사인 | 100% verbatim 일치 |
| | 커팅·스티커·명함포토카드 | UNMAPPED 분류였으나 라이브 comp 실재(COMP_CUT/STK/NAMECARD 적재됨·gap-0) |
| **범위 밖 (2)** | 판걸이수·굿즈파우치 구간할인 | t_dsc_* 타깃·component_prices diff 대상 아님 |
| **가짜결함 (적재 불요)** | 출력소재 specialty 18행 | ↓ 원리2 바인딩 0 — 적재 시 오적재 |
| **적재 완료(가짜 unmapped)** | 아크릴 B02 투명1.5T 81셀 | COMP_ACRYL_CLEAR3T·MAT_000042 81/81 verbatim 일치(아래) |

## 출력소재 specialty 18행 = 가짜결함 (원리2 바인딩 필터 라이브 실측)

`paper_import_match.py`가 "to_insert"로 분류한 18행(국4절 13+3절 5)을 라이브 바인딩 필터로 재판정:
**18행 전부 `COMP_PAPER` 공식 바인딩 상품 0건** → 적재해도 어떤 상품 견적에도 영향 0(BOM-only).

- **스티커용지 9종**(MAT_TYPE.11: 유포·무광/유광코팅·미색매트·리무벌아트·수분리·투명·홀로그램·크라프트) +
  **합판스티커 1종**(.13 비코팅) = COMP_PAPER가 **틀린 그릇**(스티커=COMP_STK_PRINT·합판=COMP_GANGPAN_PRINT) → 원리1 위반.
- **종이 6종**(.01: 백색모조지·투명/반투명PET·3절 4종) = 그릇은 맞으나 **COMP_PAPER 공식 쓰는 상품 0** → 원리2 위반.
- → 8세션 핸드오프 "출력소재 gap-0(파싱한계 false)" 판정 **재확인**. `paper-specialty18-load.sql`(신규 mint MAT_000347~365)은 prior 오류 배치 — **적재 금지**.
- 레더하드커버 A4/A5 = 매칭 자재 del_yn=Y(논리삭제) → 보류(기존과 동일).

## 아크릴 B02 = 이미 적재됨 (가짜 unmapped·진단 완료)

- 권위 B02 = "투명아크릴1.5T (직접입력형) 양면9도/단면7도" 81셀 = 가로 9종(20~100mm)×세로 9종 면적격자.
- 라이브 `COMP_ACRYL_CLEAR3T`는 use_dims=`[mat_cd,siz_width,siz_height,min_qty]` — **두께를 mat_cd로 구분**:
  - **MAT_000042 "아크릴 투명 1.5mm" = 81행** ← B02(투명1.5T)
  - MAT_000043 "아크릴 투명 3mm" = 196행 ← B01(투명3T)
- 판아크릴(PRD_000161) = `PRF_CLR_ACRYL` → `COMP_ACRYL_CLEAR3T` 바인딩(직접입력형 = off-grid ceiling).
- **전수 verbatim diff: 권위 81셀 ↔ 라이브 MAT_000042 81셀 = 미적재 0·불일치 0·100% 일치.**
- "매핑미상"은 `grid_diff.py`가 B02 블록을 mat_cd(MAT_000042)로 자동 연결하지 않은 **스크립트 한계**(가짜 신호)였음.
  → run_all 레지스트리에 아크릴 B02=MAT_000042 매핑 추가하면 다음 배치부터 자동 일치(후속 개선·적재 무관).

## 재현
```bash
bash _workspace/_foundation/live-snapshot/snapshot.sh          # 라이브 스냅샷 갱신
cd _workspace/huni-price-table-integrity/_batch/scripts
python3 run_all.py                                             # 전 19시트 결정론 diff
python3 paper_import_match.py                                  # 출력소재 매처
# 원리2 바인딩 필터 = MISSING-COMPONENTS-FINAL-260630.md 본문 쿼리
```
