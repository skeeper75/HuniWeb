# _migrate_plate_load_guk4 — 국4절(316x467) 32상품 plate 적재 실행본

상품마스터 `파일사양_출력용지규격` 컬럼 권위로, **국4절 316x467 32상품 plate**를 출력용지규격 siz
`SIZ_000499`(라이브 존재·impos=Y·재사용)로 적재하는 round-5 실행본. **상세는 `MIGRATION.md`.**

> **범위(사용자 확정 2026-06-07)**: 국4절 316x467 32상품만. **3절(330x660)·투명(315x467) 6상품은 제외**
> (validator G-1 MAJOR — 그 6상품을 신규 siz로 옮기면 디지털인쇄 공정비 가격조회가 즉시 깨짐. 가격 정합
> 트랙 분리). 본 32상품은 가격이 이미 SIZ_000499(870행)에 정합이라 **단독 적재 안전**(V6 GO 판정분).

## 한눈에

- **신규 siz 0** — 316x467=`SIZ_000499` 라이브 재사용. DDL 0. 가격(component_prices) 미터치.
- **plate DELETE 101** — 31교정상품 작업사이즈 중복행(siz_cd<>SIZ_000499) 제거.
- **plate INSERT 31** — 31상품 × SIZ_000499 1행(`dflt_plt_yn='Y'`·`OUTPUT_PAPER_TYPE.01`).
- **PRD_000016(프리미엄엽서) KEEP** — SIZ_000499 1행 이미 정답. DELETE/INSERT 대상 외(자동 보존).
- **작업사이즈 soft-delete 53** — 32상품 범위 한정 ORPHAN(전체38 CSV의 62 ≠ 32범위 53. 6상품 참조 siz 제외).
- plate 102행 → 32행 collapse(KEEP 1 + 신규 31). 판수=앱 런타임 계산이라 행수 축소 무해.

## 실행

```bash
./backup.sh            # (권장) 읽기전용 before-state 덤프(plate 102행 + 53 siz del_yn)
./apply.sh             # DRY-RUN (기본, 롤백). DB 무변경
./apply.sh --commit    # 실제 적재 (인간 승인 시에만)
```

기본은 항상 **롤백 DRY-RUN**. `--commit`은 인간 승인 전용. 자격증명 `.env.local`만, 비밀번호 미출력.

## FK 위상순 (단일 트랜잭션 — apply.sql)

```
01 plate 교정 (t_prd_product_plate_sizes)  DELETE 101 → INSERT 31
   └─→ 02 작업사이즈 soft-delete (t_siz_sizes)  53행 del_yn='Y'
       (plate→siz RESTRICT 때문에 plate DELETE 선행 필수. NOT EXISTS 3중 가드)
```

## 멱등성 (R1)

- plate INSERT `ON CONFLICT (prd_cd, siz_cd) DO NOTHING` — 2회차 0행(PK 둘 다 NOT NULL → 정상 발화).
- plate DELETE `siz_cd<>'SIZ_000499' AND del_yn='N'` — 2회차 0행(작업사이즈행 이미 삭제됨).
- siz soft-delete `del_yn='N'` 조건 — 2회차 0행(이미 'Y'). NOT EXISTS 3중 가드는 plate 교정 후 항상 참.

## 검증 핸드오프

`dbm-validator`에게 G1~G9 carry-forward + R1~R6 + 라이브 롤백 DRY-RUN(2회 멱등·제약위반0) 변경분 재게이트
요청. 빌더는 자기 승인하지 않는다. committed `_exec`/`_exec_price`/`_migrate_*`와 무간섭(별도 디렉터리,
가격 미터치). 라이브 DRY-RUN(쓰기 트랜잭션·롤백) 실행은 **lead 승인**, 실제 COMMIT은 **인간 승인**.
