# A그룹 돈영향 갭 COMMIT 로그 (2026-07-03)

> 적재단계 1차 5시트 진단 → 돈영향 갭 배치(사용자 승인) 중 "즉시 가능 3건" 실 COMMIT.
> 트랙: huni-dbmap round-13(자재 교정)·round-16/18(공식 바인딩). 판수=라이브 fn_calc_pansu 그대로.

## COMMIT 내용 (apply.sql)
1. **캘린더 5상품 종이 드롭다운 부속 6행 논리삭제** — 삼각대(싸바리 MAT_000252@108·종이 MAT_000254@109) + 링블랙(MAT_000253@108/109/111/112). 108/109 링블랙=트윈링 없는데 혼입된 교차오염.
2. **아크릴 146 키링 자재 오적재 교정** — MAT_000043(투명3mm·dflt=Y·격자196행) 재활성 + MAT_000386(굿즈중복) 은퇴. 기본선택이 격자유효로 복귀.
3. **아크릴 151 맥세이프 본체 공식 바인딩** — PRF_CLR_ACRYL(2026-06-28). 부속 맥세이프 바디가격=업체 미정 → 본체만(부속 가산은 가격 확정 후 후속).

## DB 결과
`UPDATE 6 · UPDATE 1 · UPDATE 1 · INSERT 0 1 · COMMIT`. 사후: 캘린더 nonpaper active=0·146 기본선택 MAT_000043/Y·146 MAT_000386 del_yn=Y·151 PRF_CLR_ACRYL 바인딩.

## webadmin 실화면 검증 (가격시뮬레이터 simulate·제외0·PRICE≠0)
- 캘린더 108 종이 드롭다운: 8종 전부 종이(아코팩 포함)·삼각대/링 문자열 NONE.
- 아크릴 146 (투명3mm·50x50·qty100): **480,000**·COMP_ACRYL_CLEAR3T included=true.
- 아크릴 151 (투명3mm·60x60·qty100): **590,000**·제외0.

## 안전장치
- 물리백업: `backup/{calendar-materials-before.csv(56)·acrylic146-materials-before.csv(6)·acrylic151-formula-before.csv(0)}`
- undo: `undo.sql`(캘린더 6행 복원·146 원복·151 바인딩 제거).

## 잔여(후속)
- 아크릴 146 활성 자재 중 금색고리(052)/은색고리(051)/군번줄(456)=고리 부속이 mat_cd에 혼재(기본선택 MAT_000043은 정상). 부속 CPQ(GB-2)에서 정리.
- 캘린더 벽걸이 22종 용지 과다=실무진 확인 Q-CAL-MAT-1.
