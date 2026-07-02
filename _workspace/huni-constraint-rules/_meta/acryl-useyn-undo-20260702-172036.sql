-- undo: 아크릴 3상품 use_yn 원복(Y) — 2026-07-02 미출시 정리의 역
UPDATE t_prd_products SET use_yn='Y' WHERE prd_cd IN ('PRD_000168','PRD_000169','PRD_000170');
