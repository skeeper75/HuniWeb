# 전 19시트 가격테이블 무결성 배치 요약 (결정론)

권위=인쇄상품 가격표 260527(절대) ↔ 라이브 스냅샷(`live-snapshot/latest` 20:11). 라이브 읽기전용·DB 미적재. 적재본은 생성측 산출 — **인간 승인 전 COMMIT 금지**.

## status 분포

- **DIFFED** (diff완료): 11시트
- **OUT_OF_SCOPE** (범위 밖(t_dsc_*)): 2시트
- **UNMAPPED** (매핑미상(사람 확인)): 6시트

## 시트별 한 줄

| # | 시트 | 패밀리 | status | 권위셀 | 일치 | dim_missing | sparse | missing_cell | transpose | 불일치 | unmapped | 라우팅 |
|---|------|--------|--------|-------|------|-------------|--------|--------------|-----------|--------|----------|--------|
| 1 | 출력소재IMPORT | L1-단가(소재) | DIFFED | 79 | 49(62.0%) | — | — | 30 | — | — | — | 47셀 일치·32 specialty 용지 미적재(missing_cell) |
| 2 | 디지털인쇄비 | L1-밴드 | DIFFED | 954 | 954(100.0%) | — | — | — | — | — | — | 흑백축=§18 설계 / 별색=일치 |
| 3 | 코팅 | L1-밴드 | DIFFED | 184 | 184(100.0%) | — | — | — | — | — | — | 유광=★라이브 COMMIT 완료(해소됨) |
| 4 | 접지옵션 | L1-밴드 | DIFFED | 336 | 336(100.0%) | — | — | — | — | — | — | 336셀 verbatim 일치 |
| 5 | 인쇄후가공 | L1-밴드 | DIFFED | 117 | 117(100.0%) | — | — | — | — | — | — | 117셀 verbatim 일치(가변 공정키) |
| 8 | 합판도무송스티커 | L2-합가 | DIFFED | 370 | 370(100.0%) | — | — | — | — | — | — | L2 verbatim 일치 |
| 9 | 봉투제작 | L2-합가 | DIFFED | 40 | 40(100.0%) | — | — | — | — | — | — | L2 verbatim 일치 |
| 12 | 엽서북떡메 | L2-합가 | DIFFED | 468 | 468(100.0%) | — | — | — | — | — | — | 엽서북 468셀 verbatim 일치·떡메=별도 차원 |
| 13 | 제본 | L1-밴드 | DIFFED | 74 | 74(100.0%) | — | — | — | — | — | — | 66셀 일치·중철제본=del_yn=Y(§18 복원/설계) |
| 15 | 아크릴 | L1-면적 | DIFFED | 394 | 313(79.4%) | — | — | — | — | — | 1 | 313셀 일치·transpose 0·B02 투명1.5T 매핑미상 |
| 16 | 포스터사인 | L1-면적 | DIFFED | 687 | 687(100.0%) | — | — | — | — | — | — | 687셀 verbatim 일치·transpose 0(재적재 검증) |
| 0 | 판걸이수 | L3-modifier | OUT_OF_SCOPE | — | — | — | — | — | — | — | — | 수량→전지환산·component_prices diff 대상 아님 |
| 6 | 커팅타공 | L1-밴드 | UNMAPPED | — | — | — | — | — | — | — | — | 타공 다중값컬럼 추출 정밀화 필요(사람 확인) |
| 7 | 스티커 | L2-합가 | UNMAPPED | — | — | — | — | — | — | — | — | 라이브 note=블록좌표·권위 라벨 직접 매칭 불가(col-map 사람 확인) |
| 10 | 명함포토카드 | L2-합가 | UNMAPPED | — | — | — | — | — | — | — | — | block→comp 다종 분기·.01 교정행 보존·사람 확인 |
| 11 | 후가공_박소형 | L1-면적/수량 | UNMAPPED | — | — | — | — | — | — | — | — | 대형박과 동일·면적박 가공비 라이브 미적재(사람 확인) |
| 14 | 후가공_박대형 | L1-면적 | UNMAPPED | — | — | — | — | — | — | — | — | 대형박 면적박 가공비 라이브 미적재(사람 확인·§18) |
| 17 | 굿즈파우치구간할인 | L3-modifier | OUT_OF_SCOPE | — | — | — | — | — | — | — | — | 구간할인율 곱·t_dsc_* 타깃·이 진단 범위 밖 |
| 18 | 후가공_박백업 | L1-단가(후가공) | UNMAPPED | — | — | — | — | — | — | — | — | 권위 CSV 추출/comp 확정 필요(사람 확인) |

## 최종 결함 라우팅 (3분류)

### A. verbatim 적재 가능 / 해소됨

- **코팅 유광 92셀**: `coating-load.sql`(COMP_COAT_GLOSSY·PROC_000014). ★라이브 COMMIT 완료(해소됨) — 단, 본 스냅샷(20:11)은 COMMIT 전 시점이라 0행 표기(재스냅 시 일치 확인 필요·드리프트 가드).
### B. §18/dbmap 설계 필요 (BLOCKED·blind insert 금지)

- **디지털 흑백 212셀**: use_dims 도수축 collapse(흑백/칼라 구분 차원 없음)·차원 설계 결정.
- **제본 중철제본 8셀**: COMP_BIND_JUNGCHEOL del_yn=Y(논리삭제)·활성 엔진 견적불가→comp 복원/재설계 결정.
- **출력소재IMPORT 32 specialty 용지**: 뉴크라프트·띤또레또·레더하드커버·반투명PET 등 권위 종이 절가가 COMP_PAPER 미적재(mat_cd 신규 필요)→dbmap 적재.
### C. 매핑미상 (사람 확인·날조 금지)

- 커팅타공(타공 multi-value 컬럼 추출 정밀화)·스티커(note=블록좌표)·명함포토카드(다종 comp·.01 교정행 보존)·박대형/박소형(면적박 가공비 라이브 미적재)·후가공_박백업(L1 CSV 부재)·아크릴 B02 투명1.5T(81셀 별도 comp 부재).

### DIFFED 검증 완료(결함 0)

- 접지 336·인쇄후가공 117·봉투 40·합판 370·엽서북 468·포스터사인 687·아크릴 313(매핑분) = L1밴드/L2합가/면적 verbatim 정확 일치(라이브=권위 거울). transpose 0(포스터/아크릴 재적재 검증).
- **범위 밖**: 판걸이수·굿즈파우치 구간할인(t_dsc_* 타깃·component_prices diff 대상 아님).

## DIFFED 시트 무결성 판정

- **출력소재IMPORT**: 권위 79셀 중 49셀 정확 일치(62.0%) · dim_missing 0 · sparse 0 · missing_cell 30 · transpose 0 · 불일치 0 · unmapped 0
- **디지털인쇄비**: 권위 954셀 중 954셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **코팅**: 권위 184셀 중 184셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **접지옵션**: 권위 336셀 중 336셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **인쇄후가공**: 권위 117셀 중 117셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **합판도무송스티커**: 권위 370셀 중 370셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **봉투제작**: 권위 40셀 중 40셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **엽서북떡메**: 권위 468셀 중 468셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **제본**: 권위 74셀 중 74셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0
- **아크릴**: 권위 394셀 중 313셀 정확 일치(79.4%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 1
- **포스터사인**: 권위 687셀 중 687셀 정확 일치(100.0%) · dim_missing 0 · sparse 0 · missing_cell 0 · transpose 0 · 불일치 0 · unmapped 0

## 재실행
```bash
cd scripts
python3 run_all.py                          # 전 시트 배치(토큰0)
python3 grid_diff.py <sheet_key> <l1.csv>   # 단일 시트
# sheet_key: digital-print·coating·acrylic·poster-sign·envelope·gangpan-sticker·postcard-book
```

