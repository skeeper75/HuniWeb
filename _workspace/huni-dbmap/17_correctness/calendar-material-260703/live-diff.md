# 캘린더 5상품 — 종이 드롭다운 라이브 실측 vs 정답 diff (round-13 · GAP-CAL-2)

> **작성** 2026-07-03. 읽기전용 SELECT만(쓰기 0). 비밀값 비노출(`.env.local` 환경변수). `t_prd_product_materials` ⋈ `t_mat_materials` 전수 실측.
> **재현 SELECT:**
> ```
> set -a; source .env.local; set +a
> PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "
> SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd, pm.dflt_yn, pm.del_yn, pm.disp_seq
> FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
> WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
> ORDER BY pm.prd_cd, m.mat_typ_cd, pm.disp_seq, pm.mat_cd;"
> ```

---

## 1. 상품별 자재행 수 — 현재 vs 정답

| 상품 | 현재 자재행(del_yn=N) | 종이(MAT_TYPE.01) | 부속(≠.01) | 정답 종이 수 | 제거 대상(부속) |
|------|:---:|:---:|:---:|:---:|:---:|
| 탁상형(108) | 10 | 8 | **2** (삼각대싸바리·링블랙) | 8 | **2** |
| 미니탁상형(109) | 9 | 7 | **2** (삼각대종이·링블랙) | 7 | **2** |
| 엽서(110) | 10 | 10 | 0 | 10 | 0 (이미 종이만·정합) |
| 벽걸이(111) | 23 | 22 | **1** (링블랙) | 22 | **1** |
| 와이드(112) | 4 | 3 | **1** (링블랙) | 3 (명시 정답) | **1** |
| **합계** | 56 | 50 | **6** | 50 | **6** |

---

## 2. 부속 혼입 6행 — 정밀 식별 (제거 확정)

| # | 상품 | mat_cd | mat_nm | mat_typ | usage | dflt | 마스터 del_yn | 판정 | 오적재 유형 |
|---|------|--------|--------|:---:|:---:|:---:|:---:|------|------|
| R1 | 탁상(108) | MAT_000252 | 삼각대(싸바리) | .15 | .07 | Y | N | 부속(거치 공정) | 부속혼입 |
| R2 | 탁상(108) | MAT_000253 | 링 블랙 | .07 | .07 | Y | **Y(은퇴)** | 부속(제본 공정) | **교차오염**(탁상=삼각대, 트윈링 아님) + 마스터 은퇴행 참조 |
| R3 | 미니(109) | MAT_000254 | 삼각대(종이) | .07 | .07 | Y | N | 부속(거치 공정) | 부속혼입 |
| R4 | 미니(109) | MAT_000253 | 링 블랙 | .07 | .07 | Y | **Y(은퇴)** | 부속(제본 공정) | **교차오염**(미니=삼각대, 트윈링 아님) + 은퇴행 참조 |
| R5 | 벽걸이(111) | MAT_000253 | 링 블랙 | .07 | .07 | Y | **Y(은퇴)** | 부속(제본 공정) | 부속혼입(벽걸이 자체 트윈링이나 종이 아님) + 은퇴행 참조 |
| R6 | 와이드(112) | MAT_000253 | 링 블랙 | .07 | .07 | Y | **Y(은퇴)** | 부속(제본 공정) | 부속혼입(와이드 자체 트윈링이나 종이 아님) + 은퇴행 참조 |

**핵심 실측 사실:**
- **6행 전부 `mat_typ_cd`가 .07/.15**(부속) — 종이(.01) 드롭다운에 섞임. `usage_cd=USAGE.07`(본체 종이와 같은 슬롯)·`dflt_yn=Y`(기본노출)로 손님에게 종이처럼 보임.
- **링 블랙(MAT_000253)은 마스터에서 이미 은퇴**(`t_mat_materials.del_yn='Y'`)인데 **4상품(108/109/111/112) 상품링크는 여전히 활성**(pm.del_yn='N') = 은퇴 자재 참조 잔존. 제거 확정 신호.
- **교차오염 확증(R2·R4):** 링(트윈링 제본)은 벽걸이·와이드 전용. 탁상(108)·미니(109)는 삼각대 거치이며 트윈링 자체가 없음 → 링 블랙은 **애초에 108/109에 무관한 벽걸이 부속의 잘못된 복제**.

```sql
-- 재현: 6 제거대상 추출 (읽기전용)
SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, m.mat_typ_cd, m.del_yn AS master_del
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
  AND m.mat_typ_cd <> 'MAT_TYPE.01' AND pm.del_yn='N';  -- 6 rows
```

---

## 3. 종이(MAT_TYPE.01) 목록 — 과다 여부는 권위 부재 (제거 안 함·escalate)

```sql
SELECT pm.prd_cd, count(*) FILTER (WHERE m.mat_typ_cd='MAT_TYPE.01' AND pm.del_yn='N') papers
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112') GROUP BY 1;
```
| 상품 | 종이 수 | 판정 |
|------|:---:|------|
| 108 | 8 | 종이 다종 — 엑셀 `*별도설정`이 명시 목록 안 줌 → 과다 여부 **escalate** |
| 109 | 7 | 동일 escalate |
| 110 | 10 | 동일 escalate |
| 111 | 22 | 전 디지털 표준군 무차별 의심(gap-board) — 그러나 권위 부재 → **escalate** |
| 112 | 3 | **엑셀 명시(3절 3종)와 정확 일치 → 정합(CORRECT)** |

**아코팩(MAT_000113) 특기 — 사용자 문제제기의 반증:**
- 사용자 지시는 "삼각대·링·**아코팩** 등 비종이" 제거를 예시했으나, 실측 결과 **아코팩=마스터 `MAT_TYPE.01`(종이)** 이며 **금은별색엽서·모양엽서·미니접지카드·3단접지카드·소량전단지·접지리플렛** 등 다수 상품에서 `USAGE.07` 본체 종이로 실사용. → **아코팩은 정상 종이(고급/특수지), 부속 아님.** 제거 대상에서 **제외**(마스터 불가침·오삭제 방지).
```sql
-- 아코팩이 종이로 실사용됨을 재현
SELECT pm.prd_cd, p.prd_nm FROM t_prd_product_materials pm JOIN t_prd_products p ON pm.prd_cd=p.prd_cd
WHERE pm.mat_cd='MAT_000113' AND pm.del_yn='N';  -- 금은별색엽서·접지리플렛 등 다수
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000113';  -- MAT_TYPE.01
```

---

## 재현 노트
- 전 쿼리 읽기전용 SELECT. INSERT/UPDATE/DDL 0. 비밀값 비노출.
- 제거 대상 = mat_typ<>.01 6행(부속). 종이 50행 무손상. 110=이미 종이만(정합).
