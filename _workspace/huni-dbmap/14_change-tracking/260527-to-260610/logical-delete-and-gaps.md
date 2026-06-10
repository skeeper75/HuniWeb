# 논리삭제 제안 + GAP / escalate — 상품마스터 260527 → 260610

[HARD] hard-delete 금지(V3). 엑셀에서 사라진 행은 라이브를 물리삭제하지 않는다 —
주문·FK 참조 파손 위험. 논리삭제(`use_yn='N'`/`del_yn='Y'`) **제안**만 + escalate(인간 결정).

## 1. REMOVED 상품 → 논리삭제 제안: 0건

- 전 13시트 상품 REMOVED 0. **단종/삭제된 상품 없음.** 논리삭제 제안 대상 상품 없음.

## 2. 변형행 감축 → 논리삭제 후보 (escalate)

### 아크릴미니파츠 (ID 14636 / PRD_000163) — 변형행 −16 (34→18)
- 엑셀에서 변형행 16개 감소. 라이브는 PRD_000163의 size **1행만** 적재(이미 최소 적재).
- 위치정렬 cell-diff는 LOW(tail-shift 유령) → 개별 셀 삭제로 단정 금지.
- **escalate**: 감축된 16변형이 (a) 진짜 단종 변형인지 (b) 통합/정리인지 사람 판단.
  라이브 1행과의 정합상 **즉시 처리 불필요**(라이브가 이미 축소 상태). 제안:
  ```sql
  -- [제안·미실행] 만약 감축 변형이 라이브에 적재돼 있었다면:
  -- UPDATE t_prd_product_sizes SET use_yn='N', upd_dt=now()
  --   WHERE prd_cd='PRD_000163' AND siz_cd IN (<감축 siz_cd 목록>);
  -- 현 라이브 1행이라 대상 후보 없음 → 무처리(NO_OP).
  ```

## 3. GAP (적용 대상 t_* 없음)

### 실사 범례 텍스트 (1셀)
- MES ITEM_CD 헤더영역 주석에 가격표 참조 안내문 추가. **상품 속성 아님** → 적용 대상
  엔티티/컬럼 없음. GAP / NO_OP. 매니페스트에 provenance 보존(`실사!N5` 영역).

## 4. escalate (재분류 — 옵션레이어 설계 필요)

### 굿즈파우치 size → option 재분류 (224쌍 / 58상품)
- 신규 권위가 size 값을 CPQ 옵션으로 재분류. 라이브는 이를 size로 적재
  (예 레더라벨제작 PRD_000280 = 레더15x30/레더20x40/레더30x50).
- 전역 CPQ 옵션레이어 거의 미적재(option_groups 5·options 16·option_items 18 = 전부 silsa).
- **escalate → `dbm-cpq-option-mapping`(L2)**. 기계적 size 삭제 금지(price/size 사슬 파손,
  schema-design-intent-first). 적재된 size 행의 운명(유지 vs use_yn='N')은 L2에서 동반 결정.

### 스티커 합판도무송스티커 커팅옵션 클리어 (37셀)
- `커팅(옵션)` 텍스트 제거. 라이브는 커팅을 size(정사각NxN(EA) 37행)로 적재, 커팅 옵션그룹 없음.
- **escalate**: 커팅을 옵션으로 재모델할지 / 제거 의도인지 도메인 확인 후 처리.

## 5. GAP 제안 — DB 레벨 변경이력 테이블 (선택·DDL 제안만)

현재 전용 변경이력 테이블 부재 → 본 매니페스트(`change-manifest.csv`)가 감사 권위.
버전쌍 변경을 DB에 영속화하려면 아래 신규 테이블을 `dbm-ddl-proposer`로 제안 가능
(본 트랙은 DDL 미적용):

```sql
-- [제안·미적용] 상품마스터 버전 변경이력
-- CREATE TABLE t_aud_product_master_changelog (
--   chg_id      bigserial PRIMARY KEY,
--   src_version varchar(16) NOT NULL,   -- '260527'
--   dst_version varchar(16) NOT NULL,   -- '260610'
--   sheet       varchar(64) NOT NULL,
--   prd_key     varchar(64),            -- ID 또는 prd_nm
--   change_type varchar(16) NOT NULL,   -- ADDED/REMOVED/MODIFIED
--   col_name    varchar(128),
--   before_val  text, after_val text,
--   cell_ref    varchar(64),            -- provenance
--   apply_class varchar(32) NOT NULL,   -- ESCALATE/GAP/UPDATE/...
--   reg_dt      timestamp NOT NULL DEFAULT now()
-- );
```

권장: 우선은 매니페스트(파일) 기반 추적 유지, DB 이력 테이블은 향후 버전쌍이
누적될 때 도입 검토.
