# 라이브 교정 기록 — 아크릴키링 고리 저청구 (addon 방식·webadmin 실화면 규명)

**일시**: 2026-07-04 · **승인**: 인간(지니·default-approve) · **분류**: 구조 교정(신규 mint 0·값 권위 전사)
**대상 3테이블**: `t_prd_templates`(복원3) · `t_prd_product_addons`(링크3) · `t_prd_product_materials`(제거3)

## 근본원인 (webadmin 실화면이 규명 — 첫 접근 폐기)
- 최초 진단(linkage/등록점검표): 아크릴키링 고리 선택 시 0원 청구(저청구).
- **첫 교정안 = opt_cd 재키잉 → 폐기(SUPERSEDED)**. 라이브 시뮬레이터(webadmin 백엔드) 실측이
  진짜 버그를 드러냄: 고리가 **base 자재(mat_cd)로 오모델링**(MAT_000051 은색고리 등이 투명아크릴과
  같은 USAGE.07 자재로 등록·단가행 0) → 고리 선택 시 base comp 매칭 실패 → **상품 전체 0원**.
- ∴ opt_cd 접근 무효(라이브는 mat_cd 선택). [HARD] webadmin 확인이 잘못된 COMMIT을 막음(생성≠검증).

## 교정 (addon 방식·기존 볼체인 패턴 정합)
1. **삭제 템플릿 복원**: TMPL-000015 은색고리(1,100)·016 금색고리(1,200)·017 은색구슬줄(300)
   → del_yn=N (모두 이미 존재·단가행 권위값 보유·신규 mint 0·search-before-mint 충족).
2. **addon 링크**: PRD_000146 → 위 3템플릿(disp_seq 9/10/11·볼체인 TMPL-000056~063 뒤).
3. **오모델링 자재 제거**: PRD_000146 product_materials MAT_000051/052/456 → del_yn=Y(0원 트랩 제거).

## 검증 체인 (전 게이트 GO)
1. **라이브 sim 선검증**: 삭제 템플릿이라도 addon으로 +1,100/1,200/300 정확 반영(base 25,000 불변).
2. **라이브 드리프트 0**: dryrun 사전게이트(삭제템플릿3·고리자재3·기존링크0) 통과 = 라이브 일치.
3. **dryrun GO**: BEGIN→복원3+링크3+자재제거3→사후게이트 통과→ROLLBACK(라이브 불변).
4. **COMMIT**: UPDATE 3 + INSERT 3 + UPDATE 3 · 게이트 통과.
5. **[HARD] 사후 라이브 sim**: 고리 addon 3종 노출(has_price=True)·mat_cd 고리자재 제거 확인·
   base 25,000 불변 + 은색고리 26,100·금색고리 26,200·은색구슬줄 25,300(권위 일치·0원 트랩 소멸).

## 백업·원복
- 백업: `z_bak_ackeyr2_templates`(3) · `z_bak_ackeyr2_addons`(8) · `z_bak_ackeyr2_materials`(6) — 라이브 잔존.
- undo: `remediate/acryl-keyring-addon/04-undo.sql`(템플릿 del 복원·링크 제거·자재 복원).

## 의미
hdx 교정이 **webadmin 실화면 규명으로 오진단을 자기교정**하고 addon 방식으로 실 COMMIT까지 완주.
등록 점검표(등록 매핑 대조)가 찾은 첫 저청구를 **라이브 검증 기반으로 실제 교정**. 볼체인 패턴 재사용(신규0).
