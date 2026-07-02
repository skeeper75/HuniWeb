# Huni-Constraint-Rules (§31) — HANDOFF

## 다음 시작점 (fresh 세션)
1. **실무진 답변 대기 3건**(`_meta/confirm-queue.md`·문안 작성 완료): ① Q-DGP-CUTSIZE(043·046 커팅모양×가능 사이즈) ② Q-DGP-OSMS(018·041·042 오시×미싱 동시 가능?) ③ OG-2(020 화이트+클리어 동시/택일). 답 오면 **"제약규칙 하네스 재실행 — 컨펌 큐 처리"** → 승격분만 designer→gate→승인→registrar.
2. **048/049 코팅×종이두께**: 옵션그룹 미적재(BLOCKED-UI)라 §7 dbmap 선적재 후 wave3(047) 동형 승격 — `03_rules/wave3-dgp/` 스크립트 파라미터만 교체.
3. **§23발 신규 후보 — 박(FOIL) 6상품 최소수량 제약**(027/029/031/034/069/070 "박 선택 시 최소 10/200부"·§23 오후 세션 라우팅): 수량 조건이지만 `bdl_qty`(int)는 var 계약에 있어 표현 가능성 있음 — hcr-scenario-curator로 CN 판정부터(수치 비교 shape이 폼빌더 한계 C-9에 걸리는지 확인 선행).
4. **개발자 전달**: `05_gate/dev-handoff-final.md`(C-1~C-10·V-1~V-4·R-1~R-5) 개발팀 전달 대기. High=강제 지점 부재(가격·주문이 제약 미참조)·폼빌더 수치범위 미지원(C-9·CN-5 19건+박크기 7건이 걸림).

## 이번 세션 결정 — relitigate 금지
- 하네스 구축: 5 에이전트(hcr-*)+5 스킬·CN-1~CN-6 필요상황 규정·CR1~CR7 게이트. **완료 정의=UI에서 규칙·차원 확인·조정 가능**(폼빌더 정형 shape만·raw 금지)[HARD 사용자 directive].
- 라이브 COMMIT 2건(실화면 4항 전부 PASS): ① 129/130 구 R_DEMO_MATSIZ(RAW-ONLY 실증) 논리삭제→자재별 R_MATSIZ_* 8규칙(단가행 자동 유도·오차단 0) ② 047 `R_EXCL_COATING_THIN_PAPER`(코팅×180g 미만 15종 금지·전수 188조합 오차단 0).
- **C-10 패턴**: "X→Y∈[리스트]" implication(.03)은 폼빌더 result 단일 {dim,val} 한계로 RAW-ONLY → **여집합 금지형(.02)으로 뒤집기**(047 전형·048/049 적용 예정).
- 디지털 34상품 "제약 MISSING"=뭉치 해체(진짜 1건뿐·블리드=파일사양·수량=컬럼·별색=CN-6). 옵션그룹 "그룹 폭발" 미실재(실체=명명 비일관→§12). CN-2 확정=129/130뿐.
- 058 RULE_001 죽은 규칙=사용자 지시 **유지**(테스트 중). 아크릴 5상품=미출시 확정→제약 안 만듦·use_yn 전부 N 정리 COMMIT(undo=`_meta/acryl-useyn-undo-*.sql`).

## 건드리지 말 것
- 라이브 등록 규칙: 129/130 `R_MATSIZ_*` 8건·047 `R_EXCL_COATING_THIN_PAPER`·016 R_DEMO_VIS/EXC(PASS 판정)·058 RULE_001(사용자 유지).
- undo 계보: `03_rules/wave1-pilot/undo.sql`·`03_rules/wave3-dgp/undo.sql`·백업=`04_register/wave{1,3}/backup-*`.
- 유도 스크립트(`derive_matsiz.py`·`derive_coating_paper.py`)+스냅샷 — 신규 자재/사이즈 추가 시 재생성으로 규칙 갱신(수동 나열 금지).
