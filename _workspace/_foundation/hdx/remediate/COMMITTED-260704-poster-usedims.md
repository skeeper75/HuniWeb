# 라이브 교정 기록 — 포스터 use_dims += siz_cd (hdx 파이프라인 첫 실적재)

**일시**: 2026-07-04 · **승인**: 인간(지니) · **분류**: auto_data(값 날조 없는 메타데이터 교정)
**대상**: `t_prc_price_components.use_dims` / `COMP_POSTER_CANVAS_HANGING`(캔버스 행잉포스터 완제품가)
**변경**: `["siz_width","siz_height","min_qty"]` → `["siz_width","siz_height","min_qty","siz_cd"]`

hdx 통합 배치(P2 진단→P3 교정생성→P4 재실측→P5-① 라운드)가 낸 **첫 실적재 교정**. 종단 실증.

## 근거(결함)
`DimConformanceDx` UNDECLARED·siz_cd: 단가행이 siz_cd 별로 실제 상이(A4=6000·A3=10500·A2=20000)한데
comp `use_dims` 가 siz_cd 미선언 → silent 가산/무시 위험. 교정 = 선언을 실데이터 구조에 정합.

## 검증 체인(적재 전)
1. **라이브 재-SELECT(드리프트 0)**: use_dims·단가행 siz_cd 분포가 스냅샷과 완전 일치(H-1).
2. **dryrun(BEGIN…ROLLBACK)**: 백업·사전/사후 게이트·UPDATE 1행 무오류, ROLLBACK 후 라이브 불변.
3. **P4 적대적 재실측(engine verbatim)**: 가격중립·결함해소·무회귀 GO(엔진은 siz_cd 를 use_dims 무관 하드코딩 매칭).
4. **[HARD] webadmin 실화면(라이브 가격시뮬레이터 백엔드)**: 3사이즈 전부 PRICE≠0·포스터 comp 정상 매칭
   (A4=6000·A3=10500·A2=20000). baseline 확보.

## 실행·사후검증
- **COMMIT**: fix SQL 실행(백업 `z_bak_dimconf_usedims_comp_poster_canvas_hanging` 생성 + UPDATE 1 + 게이트 통과).
- **사후 라이브 시뮬레이터 재대조**: A4=6000·A3=10500·A2=20000 **전 사이즈 불변**(가격중립 실서비스 확증).
- **스냅샷 재생성**: snap_20260704_1554.
- **라운드4 재진단**: dim_conformance 38→37·총 327→326·**포스터 UNDECLARED siz_cd 0(해소)**·auto_go 1→0.

## 원복(undo)
```sql
UPDATE t_prc_price_components t
SET use_dims = b.use_dims, upd_dt = now()
FROM z_bak_dimconf_usedims_comp_poster_canvas_hanging b WHERE t.comp_cd = b.comp_cd;
```
백업 테이블 라이브 보유(`z_bak_dimconf_usedims_comp_poster_canvas_hanging` = 원본 `["siz_width","siz_height","min_qty"]`).

## 의미
hdx 반자동 라운드가 **진단→교정→재실측→인간 승인→라이브 적재→재진단 결함 해소**를 실제 라이브에서
한 바퀴 완주. 가격 파일럿 종단 검증 완료(값 날조 0·가격중립 실서비스 확증·전 게이트 통과·백업/undo 보유).
