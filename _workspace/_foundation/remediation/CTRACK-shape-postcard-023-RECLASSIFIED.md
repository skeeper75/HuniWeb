# 모양엽서023 — C트랙 가설 반증 (데이터 결함으로 재분류)

> 2026-06-29. 프롬프트는 모양엽서023(PRD_000023·PRF_DGP_B)의 `fn_calc_pansu(전지, 90x90)=NULL`
> 을 **C트랙(엔진 함수 결함·데이터 교정 불가)**으로 분류 권고. 라이브 실측 결과 **반증** — 데이터 결함.

## 반증 근거
- `fn_calc_pansu`(raw/webadmin/sql/32_fn_calc_pansu.sql L46-53)는 아이템 사이즈의
  `work_width/work_height` 가 NULL 이면 **설계대로 RETURN NULL**(함수 정상 동작).
- SIZ_000119(90x90)의 `t_siz_sizes.work_width/work_height` 가 **공란(NULL)** 이라 함수가 NULL 반환.
  형제 정상 사이즈(SIZ_000003·004·006 등)는 work 치수가 채워져 있어 가격됨.
- work 치수 충전(92×92·cut+2mm·형제 패리티) 후 DRY-RUN: `fn_calc_pansu(SIZ_000499,SIZ_000119)=12` (양수).
  → 023 가격 가능. **함수 버그 아님 · 입력 데이터(사이즈 work 치수) 누락**.

## 결론
- 분류 정정: C트랙 → **MIS-LOADED(데이터)**. 교정 가능.
- 교정은 `digital-priced0-260629-dryrun.sql`(SIZ_000119 work 치수 충전)에 포함. C트랙 SQL 불요.
- 참고: 진짜 fn_calc_pansu 임포지션 과다(저청구) 코드 이슈는 별건
  [[pansu-authority-fn-calc-pansu-260628]]·`CTRACK-fn-calc-pansu-authority-pansu.md`(실무진 엑셀
  판걸이수 lookup 우선). 023 의 0원은 그 이슈와 무관(work 치수 NULL 단순 결손).
