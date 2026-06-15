-- =====================================================================
-- 00_preload_price_type_03.sql  (round-13 정정 트랙 · D-1b · step 00)
-- 권위: phase-b-d1b-remediation.md §2 (ⓒ-2 채택) — 그대로 실행본화·재설계 0.
-- 무엇: 신규 단가유형 코드 PRICE_TYPE.03(구간고정총액형) 1행 멱등 선적재.
--       그룹① comp prc_typ UPDATE(step 01)의 FK/도메인 선행 — 반드시 먼저.
-- 라이브 실측(2026-06-15): PRICE_TYPE 그룹 = .01/.02만, .03 비점유(충돌 0).
--                          PK = cod_cd 단일 · reg_dt NOT NULL DEFAULT now().
-- 돈-크리티컬: 코드행 1행 추가뿐 — 단가행 무관. DDL(ALTER/CREATE) 아님.
-- 멱등: ON CONFLICT (cod_cd) DO NOTHING — 재실행 시 no-op(delta 0).
--
-- [ⓒ-1 채택 시] 본 파일(§2 base_code) 생략 + step 01 IN절 SET 값 '.03' → '.02' 치환.
--               (ⓒ-1 = .02 합가형 재사용 · webadmin/실무진 C-D1b 결정 사안)
-- =====================================================================

INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note, reg_dt)
VALUES (
  'PRICE_TYPE.03',          -- cod_cd (PK · 라이브 .03 비점유 실측 확인)
  '구간고정총액형',          -- cod_nm (수량구간별 고정 총액 · 수량 무관 1회 부과)
  'PRICE_TYPE',             -- upr_cod_cd (그룹 헤더 — 라이브 .01/.02 동형)
  3,                        -- disp_seq (.01=1 · .02=2 다음)
  'Y',                      -- use_yn (NOT NULL)
  '수량구간 매칭 unit_price를 곱셈/나눗셈 없이 1회 합산(후가공 오시/미싱/가변/둥근모서리 등)',  -- note
  now()                     -- reg_dt (NOT NULL DEFAULT now() — 명시해 DEFAULT 미발화 함정 회피)
)
ON CONFLICT (cod_cd) DO NOTHING;  -- 멱등: 이미 .03 존재 시 no-op
