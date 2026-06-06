# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-06(최신). 권위 goal=`docs/goal-2026-06-06-02.md`. 본 문서 + `09_load/_exec/load-decision-request.md`(결정 종합) + 각 `_migrate_*/MIGRATION.md`를 읽으면 재발견 0으로 재개. 이전 round-2/4/5 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
"html(product-viewer)을 토대로 전체 상품마스터+인쇄가격 적재" 진행 중. **GO분은 실제 라이브 적재 완료**(가격 3,504행+상품마스터 398행), 후니 권위 가격모델로 round-2 오모델링 정정, **고정가·면적 2대 마이그레이션 준비·DRY-RUN 검증 완료(승인 대기)**. 남은 차단은 STK/GP/ENV·상품마스터 290건·코드행(전부 후니 결정/등록/COMMIT 승인).

## 다음 시작점 (정확한 다음 행동)
1. **[자율 quick win] GP 합판도무송 원형 100행 적재본 빌드** — GP 원형(10~60mm) = **sticker 066(합판도무송스티커) 원형과 동일 직경** → round-5 sticker 원형 siz(`SIZ_000501~510` + 35mm=`SIZ_000422`) **재사용**으로 해소(신규등록 0). GP placeholder→그 siz 치환 마이그레이션 빌드(고정가/면적 패턴). **GP·sticker 원형은 같은 物이므로 siz 등록은 1회만**(중복 등록 금지).
2. **[후니 승인] 고정가·면적 마이그레이션 적용** — `09_load/_migrate_fixedprice/apply.sh commit` + `09_load/_migrate_areamatrix/apply.sh commit`(각 backup→commit→뷰어확인→이상시 undo). 적용 시 가격 4,272/4,805(89%) 적재.
3. **[후니 결정] STK 판수축·ENV 봉투모델** — STK 기준 A4=SIZ_000258·A3=SIZ_000315 실존(B3/B4/100x148/90x110·판수 1P/2P/8판/12판 미결), ENV 봉투 4종 라이브 0.
4. **[후니 원천] 상품마스터 290 findings** — MAT_* 자재변형 179·PLATE_FILETYPE 43(별색 손실위험)·PRINTSIDE_INVALID 63·검토 5.

## 미해결 / 블로커
- **실제 COMMIT 승인**(인간): 고정가/면적 마이그레이션 apply, siz 211+sticker 원형 10 등록, 코드행(PROC_000084·PRC_COMPONENT_TYPE.06) 등록.
- **STK/GP/ENV 차원모델**: GP는 sticker 원형 재사용으로 자율해소 가능(위 1). STK 판수축·ENV 봉투는 후니 모델 결정.
- **상품마스터 290건**: 후니 원천확정(특히 PLATE_FILETYPE는 별색/칼선이 output_file_typ에 합성돼 단순정규화 시 손실 — 후니 정규화 방식 결정).
- **siz 번호 조율(HARD)**: 미등록 siz 충돌 방지 할당 = `501~510 sticker 원형`(=GP 공유)·`511~721 면적`·`721+ 이후 ENV/STK`. 후니가 최종 코드 부여 가능. (면적 마이그가 원래 501부터 노렸다가 sticker와 충돌→511로 수정한 이력.)

## 이번 세션 결정 (재론 금지)
- **GO분 실제 적재됨**(커밋 9ec8be9): 가격 3,504행(component_prices 3,292 등) + 상품마스터 398행(materials 716·processes 260·bundle 26). 백업=`09_load/_exec*/backup_20260606_202911/`. "DB 미적재" 원칙 → **"GO분 적재됨·차단/결정분만 미적재"로 갱신**.
- **후니 권위 가격모델**(메모리 `dbmap-price-formula-types-authority`): 면적매트릭스형(실사/현수막/아크릴=[세로][가로])·고정가형(수량×옵션). off-grid=한단계 큰 크기(런타임). **데이터 R²아닌 후니 권위공식이 기준**(면적함수 추천은 오판).
- **판형 매핑**(메모리 `dbmap-output-plate-mapping`): 가격 출력판형(국4절/3절/면적)은 신규등록 아닌 기존 판형/siz 재사용. GUK4 870→SIZ_000499·3JEOL 304→SIZ_000077(impos=Y 근거)·GP35 10→SIZ_000422 = 1,184행 자율교정(GO 포함 적재됨). round-2가 28 포스터상품 전부 면적-좌표로 오모델→면적13/고정가15 정정.
- **고정가 siz 전건 라이브 재사용**(신규등록 0): 규격옵션 A1~A5·5x5~8x10·mm좌표 전부 기존 siz.
- **교정=마이그레이션**: GO 커밋 후 교정은 멱등 append 아닌 별도 마이그레이션(DELETE/UPDATE). `_exec*`에 append 금지.

## 건드리지 말 것 (확정 산출)
- `09_load/_exec/`·`_exec_price/`: GO 적재본(라이브 반영됨). **재생성/수정 금지**(라이브와 동기).
- `09_load/_migrate_fixedprice/`·`_migrate_areamatrix/`: 검증된 승인-대기 마이그레이션. 적용 전 변경 금지.
- `09_load/_exec*/backup_20260606_202911/`: GO 적재 undo용 before-state. 보존.
- `02_mapping/load_price_correction/`·`price-correction-poster-sign.md`: 권위 정정본.

## 핵심 산출물 위치
- 결정 종합: `09_load/_exec/load-decision-request.md`
- 가격 정정: `02_mapping/price-correction-poster-sign.md` + `load_price_correction/`
- 스키마/매핑 분석: `00_schema/schema-relationship-analysis.md` · `02_mapping/price-siz-mapping-inspection.md`
- 게이트: `03_validation/{load-execution-gate,domain-semantic-gate}.md` · 전체 매트릭스 `09_load/_exec/catalog-loadability.md`
- 커밋: GO 9ec8be9 · 고정가 9c6c134 · 면적 a606710 · 안전망 f272c2e · 스키마 d6d4b4f · 정정 32cc6a3

## 하네스 운영 메모 (다음 세션 주의)
- 빌더 에이전트 spawn 시 **"자가커밋 금지"** 명시(과거 자가커밋 사례). **커밋된 라이브 데이터 교정은 DELETE/UPDATE 마이그레이션**(멱등 append 아님).
- 라이브는 이제 GO분 적재 상태 — 조회 시 t_prc_*·materials 등 비어있지 않음. siz 신규 제안 전 search-before-mint(판형·기존 좌표·sticker 원형 공유까지 확장).
