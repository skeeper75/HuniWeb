# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 6세션)

> 재시작 포인터. 활성 하네스=가격테이블 무결성(§26·배치빌더 신설)·셋트(§23)·가격 종단(§27).
> 권위=2엑셀(상품마스터260610·가격표260527). ★[[price-authority-model-reframe]]: 엑셀=권위·이전사이트=거울(가격값 정답 아님)·차이=조사신호(엑셀 채택).

## ★이번 세션(6세션) 한 일 — "토대 먼저" 전환 + 돈크리티컬 2건 COMMIT
1. **§23 하네스 개선** — [HARD] "상품별 구성요소 경계(옵션 오염 방지)" 원칙 + 게이트 **S8** 추가(8개 파일). 각 상품은 자기 시트 허용 구성요소만·공유공식도 자기 분기만(중철공식이 무선에 새는 B-4 가드).
2. **셋트 미구성 4(068~071) 설계** — 표지+속지 2구성원(면지 없음)·★계산공식집 원리 확정(068~070=펼침 표지×1·**071 트윈링=표지×2**·표지단가=1면 기준·내지=×1 page파생·면지=제본비 포함). 설계 rev.2(표지 단/양면=print_opt selection·071 표지인쇄/코팅/용지 ×2·표지용지비 추가). **게이트 전 보류**(토대 먼저).
3. **이전사이트 = 서버 AJAX 가격조회 발견** — `a_<FORMCODE>.asp` GET·정적select≠동적거동·OFAT 수집기 `harvest_booklet.sh`. ★표지 양면 가격축 +60~67% 누락 실증(068~071 공통·R-4). [[huni-live-site-crosscheck-oracle]].
4. **가격테이블 현황 지도** — 19시트 중 셀골든 2개(아크릴·스티커)만·"분석 충분·적재 부족" 진단.
5. **★명함 18개 .01 과대청구 라이브 COMMIT** — 시뮬 037 ×42·024/025 ×20 해소(14→.02·2→.03·2→.02+min20). [[bandtotal-x-qty-overcharge-260628]].
6. **★포스터사인 transpose verbatim 재적재 라이브 COMMIT** — 491행+4·권위 100%정합·600×1400=20,000·1200×3000=72,000(blind swap 금지).
7. **라이브 실측 환경 구축** — `_foundation/live-snapshot/`(snapshot.sh·db-check.sh·36 t_* CSV·codex 스냅샷 우회).
8. **결정론 배치 빌더 하네스** — `hpti-matrix-batch-builder`+`hpti-matrix-batch-build`(권위CSV↔스냅샷CSV diff·토큰0·§26 확장).

## ★다음 시작점 (우선순위)
1. **배치 빌더 파일럿** — 디지털인쇄비 1시트로 `hpti-matrix-batch-builder` 실증(권위↔스냅샷 grid-diff 스크립트 빌드·실행→결함보드·적재본 자동·토큰0 확인)→어댑터로 전 시트 전파.
2. **셋트 068~071** — 보류한 게이트(rev.2) → 부품 8개(표지4+속지4·PRD_000285~292 예약) mint는 dbmap/§7·인간 승인 → 셋트행 적재. ★전 책자 표지 양면 배선(R-4·068~071 공통).
3. **포스터 T2** — 레더아트액자132 소형4·족자135 A1 단가 추출→INSERT(별 트랜잭션).
4. **굿즈/파우치/문구 직접단가** — "(가격포함)=직접단가" 125건 §7 적재(공식 아님).
5. **전 상품 확장** — 이전사이트 AJAX 수집기를 전 상품군으로(폼코드별 응답 사전 1회 매핑).

## 미해결/블로커
- **셋트 부품 mint**(8 반제품)·전 책자 표지 양면 배선 = dbmap/§7·인간 승인.
- **코드 트랙(C·개발팀)**: DBLPANSU(내지 이중÷pansu)·S2 부활·전 책자 공통. webadmin 코드 직접수정 금지.
- 포스터 잔여 T2 2건·silsa 35행 rekey는 이미 적용(드리프트).

## 이번 세션 결정 (relitigate 금지)
- **가격테이블 토대 먼저**(§27 순서: 무결성→교정적재→공식→검증). 셋트 공식(지붕)을 토대(가격표 적재) 없이 짜던 것 교정.
- **AI 셀분석 → 결정론 배치 빌더**(토큰0). 권위CSV·라이브 스냅샷 CSV diff.
- **이전사이트=서버 AJAX 거울**(가격값 정답=엑셀·차이=조사신호).
- **셋트 책자 원리**: 068~070 펼침 표지×1·071 트윈링 표지×2·표지단가 1면기준(×2≠이중)·내지×1·면지=제본포함.
- **단가=가격표 매트릭스 verbatim**(계산식·배수 치부 금지·blind swap 금지).
- **상품별 구성요소 경계(S8)**: 경계 넘는 옵션=오염.

## 건드리지 말 것 (라이브 COMMIT·undo 보유)
- **명함 18 .01 교정 COMMIT**(undo=`huni-price-table-integrity/02_load/namecard-band-undo.sql`·백업 bak_*_20260629_1749).
- **포스터 transpose 재적재 COMMIT**(undo=`huni-basedata-dedup/poster-sign/_exec/undo.sql`·백업 bak_*_postersign_dedup_20260629_1934).
- 이전 세션 COMMIT 전부·라이브 실측 환경·배치 빌더 하네스 파일.

## 산출물 위치
- 실측 환경: `_foundation/live-snapshot/`(snapshot.sh·db-check.sh·latest/).
- §26: `huni-price-table-integrity/`(02_load/{namecard,poster-sign}-*·04_gate/*-verdict·_batch/[파일럿 대기]).
- 셋트: `huni-set-product/`(01_authority/booklet-formula-principle·03_design/booklet-068-071-design rev.2·02_reference/{prevsite-harvest,cover-spread}).
- 메모리: [[bandtotal-x-qty-overcharge-260628]]·[[huni-live-site-crosscheck-oracle]]·[[set-semifinished-3tier-model-260629]].
