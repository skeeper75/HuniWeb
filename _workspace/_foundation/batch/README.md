# 가격 종단 배치 채점 빌드 (isomorphic batch scoring)

> 2026-06-29 신설. §27 가격 종단 마스터의 **계측 레이어**(SCORING-FRAMEWORK-260628 종료 술어를
> 스크립트가 자동 산출). 목적 = "상품 하나씩 LLM 확인=끝없음" → **결정론 배치(토큰0)·동형 전파·자가검증**.
> 기준 템플릿 = 단순상품(프리미엄엽서·PRF_DGP_A) + 세트상품(하드커버책자·t_prd_product_sets).

## 구성
| 파일 | 역할 |
|------|------|
| `lib_huni.py` | 시뮬레이터 인증 클라이언트(sim-meta/simulate/simulate-set) + 라이브 DB 읽기전용 psql. 셀프테스트=프리미엄엽서 결정론 재현 |
| `authority.py` | 권위 엑셀 추출 CSV(24_master-extract-260610) 리더 — 사이즈별 권위 판수·주자재(종이)·요구 OC축·가격공식 |
| `score_batch.py` | 채점 드라이버: sim-meta enumerate → simulate → CALC/PR/R1/R3/OC 채점 → 스코어보드 + 교정 SQL. **`--pr` 플래그=예전사이트 골든 대조 PR(가격재현) 추가** |
| `build_pcode_map.py` | 라이브 prd_cd ↔ 예전사이트 pcode 매핑표 생성(`prd-pcode-map.csv`) |
| `golden_fetch.py` | 예전사이트(goods.asp) 폼 네이티브 구동→공급가 골든 추출(브라우저 독점) |
| `pr_score.py` | 엔진 simulate 금액 ↔ 골든 공급가 대조(match/mismatch/no-golden). 상세=`GOLDEN-FETCH-NOTES.md` |

## 지원 상품군 (그룹)
| 그룹 | 종류 | 모델 | 대상 선정 |
|------|------|------|-----------|
| `digital-print` | 단순 | siz_cd×수량(원자합산) | frm=PRF_DGP_A (10) |
| `sticker` | 단순 | 고정가 by-siz_cd | frm=PRF_STK_FIXED (13) |
| `acrylic` | 단순 | 면적(siz_width×siz_height) | frm=PRF_CLR_ACRYL (12) |
| `stationery`(문구) | 단순(미바인딩) | — | prd_nm LIKE (만년다이어리·플래너·노트…) |
| `booklet-set` | **조립형 세트** | 완제품가공식/구성원합산 | t_prd_product_sets 부모 (7) |

## CALC 상태 분류 (거짓 FAIL 방지)
- **OK** — 전 케이스 PRICE>0 (정상)
- **UNBOUND-미바인딩** — 가격공식 자체 없음(frm None) → §18 가격설계 필요(문구 전건)
- **UNSCORED-축미탑재** — 사이즈축 enumerate 0(siz_cd·면적 둘 다 미노출)=확인필요
- **PRICED-0** — 공식 있는데 0원 = **진짜 결함**(예: 투명엽서019 PET 용지비 미적재)

## 채점 5축 (단순상품·상품당)
- **CALC** 계산가능성 — 전 케이스 PRICE≠0 (위젯/API 실제 경로 재현·자동주입 없음)
- **PR pansu** — 엔진 pansu vs 권위 판수(불일치=systemic 신호·[[pansu-authority-fn-calc-pansu-260628]])
- **R1** 부자재 오염 — 라이브 자재 타입이 주자재(종이 .01/투명 .08) 밖 = 부속물 오염. ★PET·정상종이 false-positive 둘 다 가드(자가수렴)
- **R3** dflt — dflt_yn=Y 정확히 1개
- **OC** 주문완전성 — 권위 요구 축이 손님 선택 가능(sim-meta)

## 사용
```
python3 score_batch.py sticker                  # 단순 동형군 전체(13상품)
python3 score_batch.py acrylic                  # 면적격자 12상품
python3 score_batch.py stationery               # 문구(미바인딩 신호)
python3 score_batch.py booklet-set              # 세트 7부모 채점(갈래2)
python3 score_batch.py digital-print PRD_000016 # 단일(자기검증)
```
산출: `scoreboard-cases.csv`(케이스 원자)·`scoreboard-summary.csv`(단순상품 요약)·
`scoreboard-sets.csv`(세트 요약)·`remediation-r1.sql`(부자재 오염 논리삭제·인간 승인 대기).
※ 단순상품 스코어보드는 그룹마다 덮어쓴다(그룹별 1회).

## PRF_DGP_A 동형군 첫 채점 결과 (2026-06-29)
| 상품 | CALC | PR pansu | R1 오염 | R3 | OC | 처리 |
|------|------|----------|---------|----|----|------|
| 프리미엄엽서016 | OK | 4/6(73x98 18≠15) | 0 | 1✅ | 100 | 완료(이전세션) |
| 코팅엽서017 | OK | 4/6 | 0 | 2❌ | 83(coating) | R3큐·coating축 |
| 스탠다드엽서018 | OK | 2/4 | 0 | 1✅ | 100 | pansu C트랙 |
| **투명엽서019** | **FAIL** | — | 0 | 1✅ | 83 | **PET 용지비 미적재→§26/dbmap** |
| 화이트인쇄020 | OK | — | **볼펜+지비츠** | 4❌ | 75 | R1 COMMIT·R3큐 |
| 핑크별색021 | OK | — | 0 | 3❌ | 80(spot) | R3큐·별색축 |
| 금은별색022 | OK | — | 0 | 3❌ | 80(spot) | R3큐·별색축 |
| 종이슬로건026 | OK | — | 0 | 1✅ | 80(coating) | coating축 |
| 스탠쿠폰041 | OK | — | 0 | 4❌ | 100 | R3큐 |
| 프리쿠폰042 | OK | — | **면끈+고리** | 8❌ | 100 | R1 COMMIT·R3큐 |

### 결정론 안전 교정(인간 승인 대기) = R1 부자재 오염 4건
`remediation-r1.sql` — 화이트인쇄020(볼펜·지비츠)·프리쿠폰042(면끈·고리) 논리삭제(마스터 보존).
프리미엄엽서 부자재3 제거(이전 승인)와 동일 패턴.

### 인간/오라클 큐 (결정론 불가)
- **R3 dflt 2→1**: 어느 자재를 dflt로 둘지 = 라이브 ASP 오라클/권위 첫 토큰 필요(6상품 017·020·021·022·041·042).
- **투명엽서 PET 용지비**: 권위 PET 단가 확보 후 §26/dbmap 적재(미적재 셀).
- **OC 축 미충족**: coating(017·026)·spot_color(019·020·021·022) — 손님 선택 엔티티 미등록.
- **pansu C트랙**: 엔진 fn_calc_pansu 기하 과다 → t_siz_pansu lookup 우선(개발팀 배포).

## 갈래1 결과 — 단순상품 다수 자동 채점 (2026-06-29 빌드)
- **sticker** 13상품 전건 CALC=OK. R1 청정(substrate .11/.13 화이트리스트)·OC 미충족 다수(cutting·print_opt 미선택축)·R3 dflt 다수 FAIL(기본자재 5개 등).
- **acrylic** 12상품 전건 CALC=OK(면적 siz_width×siz_height 입력 모델)·OC 100·R1 청정(권위 토큰 대조).
- **stationery(문구)** 전건 UNBOUND-미바인딩 = "가격공식 없음→§18 설계 필요"(거짓 FAIL 아님·정직 신호).

## 갈래2 결과 — 조립형(세트) 채점 (2026-06-29 빌드)
`lib_huni.simulate_set` 경로 codify. 세트 가격모델 2종 자동 분류:
- **PRICED 2/7** — 엽서북094(완제품가 PRF_PCB_FIXED 450,000)·떡메모지097(PRF_TTEOKME_FIXED 135,000).
  set_selections = 부모 fk 차원 첫 옵션 전부(siz_cd·bdl_qty·print_opt_cd).
- **BLOCKED-미바인딩 5/7** — 하드커버책자072·레더077·링082·레더링바인더088·포토북100.
  구성원/세트공식 미바인딩 → 실무진 대기·§18 단가설계(PRF_BIND_HC_MUSEON 등) 후 PRICED 예상.
- ★이중합산 가드: 완제품가 세트공식 + 구성원 공식 동시 기여 시 `PRICED(★이중합산 의심)` 표기.

## 시작 순서 (BATCH-design)
스티커(완)→문구(미바인딩 신호)→아크릴(완)→디지털인쇄(완)→실사→책자(세트·완·D6 미결 최다).

## 안전 [HARD]
라이브 읽기전용(시뮬레이터 POST=가격 계산 읽기·DB SELECT만)·권위 절대·값 날조 0·
교정 SQL 실 COMMIT은 인간 승인 후 DRY-RUN(BEGIN/ROLLBACK) 선검증. 비밀값 비노출.
