# 포스터사인/실사 면적격자 — 적재 무결성 게이트 판정 (I1~I7)

> 2026-06-29. §26 integrity-gate. 권위=인쇄상품 가격표 "포스터사인" [가로(열)×세로(행)] 면적매트릭스(절대)·라이브 읽기전용 SELECT만·DB 미적재.
> ★독립 재실측: 생성측(load-inspector) 비신뢰. 라이브 직접 SELECT + 권위 L1 추출 cell-by-cell 재대조 + 라이브 시뮬레이터 실호출 + codex high(gpt-5.5) 스냅샷 교차.
> 근거: 권위=`huni-dbmap/06_extract/price-poster-sign-l1.csv`(B01~B27 1,223행) · 라이브=`t_prc_component_prices`(684 격자행) · 스냅샷=`_foundation/live-snapshot/latest/`.

---

## 0. 종합 판정 — 분리 GO

| 결함 | 진단 판정 | 교정 방법 판정 | GO/NO-GO |
|---|---|---|---|
| **DEF-1 transpose** (13 comp·687 권위셀) | ★transpose 확정(독립 입증·codex 수렴) | **verbatim 재적재 = GO** / blanket swap = **CONDITIONAL**(14셀 깨짐) | **GO**(verbatim 경로) |
| **DEF-2 silsa siz_cd rekey** (9상품) | ★rekey 이미 적용됨(라이브 dryrun 0행·옵션 커버리지 OK) | 잔여 2건(미적재 단가행)만 BLOCKED | **GO**(rekey분)·BLOCKED(2 미적재) |

종합: **GO** — transpose 결함 실재·돈크리티컬 실증·교정방법 확정(verbatim 우선). 단 "일괄 blind swap" 단독은 NO-GO(14셀 회귀). silsa rekey는 라이브에 이미 반영(드리프트 적발).

---

## 1. ★최우선 확정 — 포스터 vs 현수막 방향 (사용자 핵심 우려)

**결론: 포스터·현수막 13 comp 전부 동일하게 transpose 됨. "현수막은 이미 정상"은 거짓.**

권위 면적매트릭스는 포스터·현수막 **모두 동일 레이아웃** `[가로(열 헤더) × 세로(행 헤더)]`:
- 포스터: 가로(열) 600~1200 · 세로(행) 600~3000 (세로로 김). 근거 B01 헤더행 `가로/세로`, 열 B-E=600/800/1000/1200, 행 A=600~3000.
- 현수막: 가로(열) 900~1750 · 세로(행) 900~5000 (긴 변=세로축에 적재). 근거 B26 행245 `가로/세로`, 열 B-F=900~1750, 행 A=900~5000.

라이브는 **양쪽 다 siz_width↔siz_height를 뒤집어** 적재 → 포스터 live siz_width max=3000(세로가 들어감)·현수막 live siz_width max=5000.

**cell-by-cell 매치율** (권위셀 vs live DIRECT / live SWAP=live(h,w)):

| comp | 권위셀 | DIRECT | SWAP | 판정 |
|---|---:|---:|---:|---|
| 11 포스터(B01~B11) | 559 | 31~33% | 94~98% | transpose |
| BANNER_NORMAL(B26) | 80 | 9(11.2%) | 78(97.5%) | **transpose** |
| BANNER_MESH(B27) | 48 | 8(16.7%) | 46(95.8%) | **transpose** |
| **전 13 comp** | **687** | **193(28.1%)** | **671(97.7%)** | transpose |

비대칭 가격셀 방향확정(증거): 권위 `W600×H1400=20000` → 라이브 `(siz_width=1400, siz_height=600)=20000`에 존재, `(600,1400)`은 ABSENT. 권위 `W1750×H900(현수막)=12960` → 라이브 `(900,1750)=12960`에 존재, `(1750,900)` ABSENT. → 양쪽 모두 세로(긴 변)가 siz_width로 들어감 = 동일 transpose.

★**일괄 swap이 현수막을 거꾸로 망가뜨릴 위험 = 없음** — 현수막도 포스터와 같은 방향으로 뒤집혀 있어, 같은 방향 swap이 둘 다 정상화한다. 단 "blind swap 단독"은 별개 이유(아래 §3)로 14셀 회귀.

---

## 2. I1~I7 게이트 판정

### I1 정답 격자 완전성 — PASS
권위 L1 추출(`price-poster-sign-l1.csv`)에서 13 comp(B01~B11·B26·B27)의 차원열+전 데이터셀을 (가로,세로)→가격 격자로 재펼침. 합계 687셀(B01=52·B02=39·B03~B11=52×9·B26=80·B27=48). 샘플 시트 엑셀 대조: B01 행2 `가로/세로`, 열헤더 600~1200, 행헤더 600~3000, W600×H1400=20000 verbatim 확인. 격자 차원·셀 모두 펼쳐짐.

### I2 미적재 셀 실재 — PASS (false-positive 아님)
라이브 SQL 재실측: transpose 결함의 실체는 "순수 미적재"가 아니라 **좌표 뒤바뀜**(셀 수 권위≈라이브, 위치 transpose). 단 **진짜 양방향 부재 2셀** 실재 확인:
- BANNER_NORMAL `900×5000=36000` · BANNER_MESH `900×5000=90000` (live DIRECT·SWAP 둘 다 ABSENT).
근거 SQL: `SELECT comp_cd,siz_width,siz_height,unit_price FROM t_prc_component_prices WHERE comp_cd IN (...) AND siz_width IS NOT NULL`.

### I3 차원 누락 실재 — PASS (차원 부재 아님·false-positive 가드)
13 comp use_dims=[siz_width,siz_height(,min_qty)] = 면적축 정상 보유. 상품 PRD_000118 nonspec yn=Y, w_max=1200·h_max=3000(권위 축과 정합). **결함은 축 값 transpose**이지 차원 부재 아님. silsa 9 comp use_dims=[siz_cd] 정상 보유.

### I4 정합 불일치 실재 — PASS
transpose = 적재값 좌표 불일치(가격값 자체는 verbatim 일치). 28.1%만 직접 일치(대칭셀 우연). 의미축 정당 차이 아님(가격 비대칭 셀이 명백히 뒤바뀜). silsa siz_cd 불일치는 라이브 dryrun에서 **이미 정본화됨**(아래 §4) — 현 시점 불일치 0(드리프트).

### I5 돈영향 정확 — PASS (★라이브 엔진 실호출 재계산)
라이브 시뮬레이터(`/admin/price-viewer/PRD_000118/simulate/` 인증 POST) 실호출:

| 주문(아트프린트포스터) | 라이브 final | 권위 정답 | 판정 |
|---|---:|---:|---|
| 가로600×세로1400 | **21,600** | 20,000 | ★과청구(transpose 셀 ceiling) |
| 가로600×세로600(대칭) | 12,000 | 12,000 | 정확(대칭셀 무해) |
| 가로1200×세로3000 | **None(견적불가)** | 72,000 | ★견적불가(live siz_height max=1800) |
| 가로600×세로3000 | **None(견적불가)** | 36,000 | ★견적불가 |

→ transpose가 **과청구 + 견적불가** 동시 유발 실증(세로>1200 긴 포스터 전부 영향). 대칭셀만 무해. 돈영향 분류 정확.

### I6 codex 수렴 — PASS (완전 수렴·divergence 0)
codex high(gpt-5.5) 스냅샷 CSV(`/tmp/codex_authority_grid.csv`·`codex_live_poster_grid.csv`) 독립 판정. 전 수치 Claude와 일치: DIRECT 193/687(28.1%)·SWAP 671/687(97.7%)·현수막 2종 transpose·blanket swap 14셀 깨짐·진짜 미적재 2셀(banner 900×5000). codex도 "진단 transpose GO·blind swap 단독 NO-GO·verbatim 권고" 동일 결론.

### I7 생성검증 독립성 — PASS
게이트가 생성측 결함보드 복붙 아님 — 권위 L1을 직접 재파싱해 격자 재구성, 라이브 직접 SELECT(684행)·시뮬레이터 실호출, codex는 스냅샷 CSV로 별도 재대조. 생성측 "13 comp 혼재 0·일괄 swap 안전" 주장을 **부분 반증**(swap 자체는 안전하나 14셀 회귀를 생성측이 누락) → 독립성 입증.

**단일 FAIL 없음 → 종합 GO.** 교정 방법은 verbatim 재적재(blanket swap은 CONDITIONAL).

---

## 3. ★일괄 swap vs 분리/verbatim 결론

| 교정안 | 정확도 | 안전성 | 판정 |
|---|---:|---|---|
| 현 상태(무조치) | 28.1%(193/687) | — | 결함 |
| **일괄 blind swap**(siz_width↔siz_height 전행) | 97.7%(671/687) | ★14셀 회귀(이미 정상셀 깨짐) | **CONDITIONAL** |
| **권위 verbatim 재적재** | 100%(687/687) | 깨짐 0·미적재 2셀 동시 해소 | ★**권장 GO** |

**일괄 blind swap의 위험 = 현수막 망가짐 아님(현수막도 transpose라 swap 필요)** — 진짜 위험은 **14개 "이미 정상" 셀이 swap으로 뒤집혀 회귀**:
- 12셀: 11 포스터 각 `W600×H1800`(+ARTPAPER `W900×H1200`) — 현재 DIRECT로 권위와 일치(이 셀만 비-transpose 적재). blind swap 시 (1800,600)으로 이동→권위에 없는 좌표→견적불가/오ceiling.
- 2셀: 현수막 `W900×H1200` 대칭쌍 얽힘.
근거: `04_gate/poster-sign-cells-confirmed.csv`(16행: 14 breaker + 2 genuine-missing).

★ dryrun(`poster-transpose-dryrun.sql`) 독립 재실행: BEFORE width>1200=479 → UPDATE 684 → AFTER(포스터 11 comp 한정 IN)=11(=각 포스터 H1800셀이 새 width=1800으로 이동한 잔재) → ROLLBACK 검증(479 그대로 유지=미COMMIT). 즉 dryrun의 "AFTER=11"이 바로 위 12 breaker의 흔적.

**결론: transpose 교정 = 권위 verbatim 재적재(687셀, 100%)로 GO.** blanket swap 스크립트는 14셀 보정(H1800·W900×H1200 셀은 swap 제외) 또는 verbatim 전면 재적재로 대체해야 함 → dbmap 트랙(dbm-price-import-prep 그릇 재추출 + dbm-load-execution 멱등 재적재).

---

## 4. DEF-2 silsa siz_cd rekey — 이미 적용됨(드리프트 적발)

라이브 `silsa-sizcd-rekey-260629-dryrun.sql` 독립 재실행: BEFORE 재키잉 대상 0행·UPDATE 0×5·AFTER 커버리지 silsa 9상품 옵션 siz_cd 전부 `OK(매칭됨)`. 라이브 9 silsa comp siz_cd 분포 = 이미 정본(174/197/293/172/170…). 중복본 315/317/258은 silsa comp엔 없음(타 comp 잔존).
→ **silsa siz_cd 불일치 견적0 = 이미 해소됨**(FINDING 작성 시점 이후 COMMIT 또는 라이브 변동·스냅샷 drift). 게이트 시점 기준 silsa rekey 결함 실재 안 함 = GO(추가 조치 불요).

**단 잔여 2건 BLOCKED(미적재 단가행·재키잉 무관)** — 라이브 SELECT 확인:
- 레더아트액자132: SIZ_000304(5x5)·306(5x7)·308(8x8)·310(8x10) 단가행 0행 → 해당 사이즈 견적0 지속.
- 족자포스터135: SIZ_000293(A1) 단가행 0행 → A1 견적0 지속.
→ 권위 가격표(액자/족자 블록)에서 해당 단가 추출 후 INSERT(자동 추정 금지·인간 승인).

---

## 5. 교정 명세 (별 트랜잭션·승인 큐)

### T1 — transpose 교정 (DEF-1·돈크리티컬·P0)
- 대상: 13 comp(11 포스터 + BANNER_NORMAL/MESH) 격자행(684행).
- 정답: 권위 [가로(열)×세로(행)] = live (siz_width=가로, siz_height=세로). 현재 뒤바뀜.
- **방법(권장)**: 권위 verbatim 재적재(`price-poster-sign-l1.csv` 격자→t_prc_component_prices, 100%·14셀 회귀 0·미적재 2셀 동시 채움). 단가값 verbatim 불변.
- 대안: siz_width↔siz_height swap **단 H1800·W900×H1200 14셀 제외**(blind swap 금지).
- dbmap 트랙: `dbm-price-import-prep`(그릇 재추출) → `dbm-load-execution`(멱등 UPSERT·트랜잭션 래핑·ROLLBACK dryrun→인간 승인 COMMIT).
- 사후검증: 시뮬레이터 아트프린트 가로600×세로1400=20,000·가로1200×세로3000=72,000(현 None) 재실증.

### T2 — silsa 잔여 미적재 단가행 INSERT (DEF-2 잔여·P1·BLOCKED)
- 레더132 소형4(SIZ_000304/306/308/310) + 족자135 A1(SIZ_000293) 단가 권위 추출 후 INSERT.
- 권위=인쇄상품 가격표 포스터사인 액자/족자 블록(B14·B16). 추정 금지.
- dbmap 트랙: `dbm-load-execution`. 별 트랜잭션(T1과 분리).

### 인간 승인 큐
1. **T1 transpose verbatim 재적재**(13 comp·684행·돈크리티컬) — 게이트 GO. 방법=verbatim 권장(blind swap 금지). 승인 후 dbmap.
2. **T2 silsa 잔여 2건 단가행 INSERT** — 권위 단가 추출 선행 후 승인.
3. silsa rekey(35행)는 **이미 적용 확인** — 추가 승인 불요(드리프트 재확인만).

---

## 6. 위상 [HARD]
권위=엑셀 절대·라이브=감사 대상(읽기전용 SELECT만 수행)·DB 미적재(실 COMMIT은 인간 승인 후 dbmap 위임)·webadmin 엔진 코드 미변경. 모든 판정 근거=시트:셀(B01~B27)·테이블:행(t_prc_component_prices)·SQL·시뮬레이터 실호출·codex 스냅샷.
