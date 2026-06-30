# Huni-Launch-Scope (§28) CHANGELOG

## 2026-06-30 하네스 초기 구성 + 첫 종단 실행 GO(조건부) + xlsx 산출
- **구성**: 6 에이전트(hls-live-cartographer∥hls-foundation-curator → hls-gap-analyst → hls-migration-designer → hls-codex-verifier → hls-scope-gate) + 6 스킬(방법론5 + 오케스트레이터, codex는 hqv-codex-cross-verify 재사용). 하이브리드·전 에이전트 opus. CLAUDE.md §28 등록(MoAI→§29).
- **사용자 결정**: 새 하네스(§24 Shopby·§10 IA 재사용) / 마이그레이션=설계·명세 중심(원천 구 DB 미접근) / 문서 깊이=Phase 1(런칭) 세부, 2차 안정·3차 확장 로드맵.
- **첫 실행 결과**:
  - IA 162기능 누락 0(엑셀 원본 3중 일치)·Phase↔우선순위 1:1(1차64/2차73/3차25).
  - fit-gap 재라벨 후 **SOLVED 48 / PARTIAL 53 / CUSTOM 61**(1차 커스텀 44%). No80·81·123 하향·56/57/58/60/66/151 상향.
  - **L1~L7 GO(조건부)·hard NO-GO 0**. codex(gpt-5.5 high) 합의8·조사9·반박6·FP5.
  - ★런칭 전 GATE 4: G1 가격 전달(견적형 무손실+정산권위+주문서 submit·Shopby 카트 동적가격 직접주입=스펙상 불가) / G2 정산 기준 / G3 머니 이관 안전장치(만료 제한없음·전수 diff·partial-use rollback) / G4 외부계약.
  - 마이그레이션: 회원 25행(native 14 무손실)·머니 4행. 프린팅머니=Shopby 적립금 재해석(방안 A)·비번=최초 로그인 재설정·약관 재동의·잔액 합계대사+전수 diff.
- **산출물**: 최종 문서 `05_gate/후니프린팅_1차런칭_개발범위_Shopby갭_개발방안.md`(223줄) + **xlsx** `docs/huni/후니프린팅_1차런칭_개발범위_Shopby갭_개발방안_260630.xlsx`(8시트·색코딩·자동필터) + 단계별 산출(00_live~05_gate).
- **미해소 리스크**: 가격브리지 견적형 무손실 경로 미확정(1차 최대)·원천 구 DB 미접근(MQ-1~24)·admin-analysis AGED 3.5개월·적립금 semantics 라이브 실측 대기. 실 구현/이관/COMMIT은 인간 승인 후 §6/§24/dbmap 위임.
