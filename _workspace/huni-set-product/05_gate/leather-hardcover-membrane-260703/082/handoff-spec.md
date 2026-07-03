# 082 하드커버 링책자 — 면지 통합 재설계 · load-executor 인계 명세 (COMMIT 승인 대기)

> §23 · 2026-07-03 · 게이트 판정 **GO**(S1~S8 PASS) → 인간 승인 후 `hsp-load-executor` COMMIT.
> **게이트는 COMMIT 안 함**(DB 미적재). 본 명세는 승인·적재 인계용.

## 1. 적재 대상 (GO)
- **파일**: `03_design/leather-hardcover-membrane-redesign-260703/082/apply-082.sql`(8스텝·멱등) + `undo-082.sql`(역순 복원).
- **셋트**: PRD_000082 하드커버 링책자 · 면지 4멤버(084/085/086/087)→1멤버(084) 통합.
- **신규 mint 0·물리 DELETE 0**(은퇴=del_yn 논리·undo의 084 이관분만 물리 DELETE).

## 2. COMMIT 전 필수 확인 (load-executor)
1. **FK 선행**: 084·MAT_382~385·OPT_066·OPV_440~443 라이브 실재(게이트 실측 확인·재확인).
2. **물리 백업**: 조작 대상 행(t_prd_product_materials/option_*/sets/products 082·084·085·086·087) 백업.
3. **적재 순서 [HARD]**: 자재[2]→옵션그룹[3]→옵션[4]→옵션아이템[5]→부모옵션은퇴[6]→부모자재은퇴(USAGE.03만)[7]→멤버은퇴[8]. (트리거 `fn_chk_opt_item_ref` 선행조건 — 게이트 DRY-RUN 통과 확인.)
4. **트랜잭션 래핑**: BEGIN … (apply-082.sql) … 사후검증 → 이상 없으면 COMMIT.

## 3. 사후 재실측 (COMMIT 후 · load-executor)
- `set_full_scan.py PRD_000082` = **818,438**(set_eval 800,000 + 내지 18,438) 무손상 재확인.
- 활성멤버 = 083/286/084 (3) · 085/086/087 use_yn=N.
- 082 USAGE.03=0(은퇴) · **082 USAGE.07 링자재 = 3 활성 유지(불가침 확인 항 [HARD])**.
- 084 자재 4(화 dflt/블/그/인쇄) · 옵션 OPT_066(4옵션) 활성 · 리네임='하드커버 링책자-면지'.

## 4. ★USAGE.07 링자재 유지 확인 항 [HARD]
COMMIT 후 반드시 재확인:
```
SELECT count(*) FROM t_prd_product_materials
 WHERE prd_cd='PRD_000082' AND usage_cd='USAGE.07' AND del_yn='N';  -- 기대 3 (MAT_013/014/015)
```
게이트 DRY-RUN 실측: PRE=3 · POST-APPLY=3 · POST-ROLLBACK=3 (전 구간 불변). apply-082.sql `usage_cd='USAGE.03'` 가드로 링자재 미참조. **3이 아니면 즉시 롤백.**

## 5. webadmin 실화면 확인 [HARD · §1 도메인규칙]
COMMIT 후 product-viewer/가격시뮬레이터 라이브 실화면:
- **제외 0 · PRICE≠0**(818,438대) · 판형 자동선택.
- 084 면지 카드 = 화/블/그/**인쇄** 4종 드롭다운(기본 화이트) 노출.
- **085/086/087 미노출**(은퇴).
- **링자재(화이트링/블랙링/링메탈링) 유지 노출**(불가침).

## 6. 후속 트랙 (재설계 블로커 아님 · 비차단)
- **D-3 인쇄면지(MAT_385) 인쇄비 실현**: 084 무공식 → 인쇄 선택 시 기여 0(선존 결함 무손상 이월). §18 hpe-engine-design 라우팅. `blocked-board-082.csv` 등재.
- **D-1 구성원 옵션그룹 렌더**: OPT_066 이관은 시뮬레이터 휴면(색/인쇄 택1은 자재 드롭다운 담당). §6 위젯 DEV-REQUEST.
- **D-2 내지 286 개수필드 정정**: 파일럿 미포함(§23-inner와 묶어야 코히런트). apply-082.sql 선택 주석 블록 활성화 금지 유지.

## 7. 판정 요약
| 항목 | 상태 |
|---|---|
| S1~S8 게이트 | **전부 PASS (GO)** |
| 골든 818,438 | **무손상(라이브 재현)** |
| USAGE.07 링 보존 | **CONFIRMED(활성 3 불변)** |
| 오차단(S5) | **0(4택1 드롭다운 발현)** |
| 이중합산 | **0** |
| 인간 승인 | **대기** → 승인 후 load-executor COMMIT |
