# 굿즈파우치 Phase 1 — 33 단일가 상품 base 단가 라이브 COMMIT (2026-07-04)

> 트랙: huni-dbmap §7 적재(§21 GP-1 base 패턴 동형). 정답 그릇 = `t_prd_product_prices`(pricing.py:470 unit_price×qty).
> 권위 = 상품마스터 260702(=260610 변경0) 엑셀 `가격` verbatim. 값=스크립트 도출(손전사 0).

## 배경 / 세그먼트
굿즈파우치 라이브 98상품(PRD_000183~280) 중 무가격 71(72%). 엑셀 가격구조 3분류:
- **단일가 63**(distinct price 1) → direct base 단가로 적재 가능
- **variant가 35**(사이즈등급/색상마다 상이·예 캔버스삼각 M9,800/L11,500) → GB-2 설계 선행
- **무가격 5** → 실무진 BLOCKED

라이브 대조 → 미적재·단일가 **33** = Phase 1 적재 대상(나머지 단일가 30은 §21 GP-1로 기적재).

## COMMIT 내용
`t_prd_product_prices` **UPSERT 33행**(apply_ymd='2026-06-10' 권위 vintage·기존 GP-1 26행과 정합, unit_price=엑셀 verbatim).
- 단가합 **516,800** · 신규 mint 0. `PRE 0 → INSERT 0 33 → POST 33`. COMMIT.
- 대상 33: 틴거울3,000·컴팩트거울3,600·레더/코르크/우드/린넨/규조토코스터·미니매트16,000·반팔티12,000·후드티35,000·말랑키링10,000·레더숄더백58,000·캔버스숄더백59,500·에코백류·필통류·미니파우치류 등.

## 사후 검증
- 라이브 98상품 with_direct **59**(26+33)·무가격 **71→38**(=variant 33 + 무가격 5).
- webadmin 실화면(라이브 admin simulate·인증): 틴거울3,000·반팔티12,000·레더숄더백58,000·캔버스숄더백59,500·린넨코스터4,500 = 전부 final_price 기대 정확·ok=true·PRICE≠0.

## 안전장치
- 물리백업 `backup/pre_product_prices.csv`(사전=기존 GP-1 26행·대상 33은 미적재).
- undo `undo.sql`(apply_ymd='2026-06-10' AND 대상 33 prd_cd 만 삭제·기존 26 무접촉).
- 실행기 `apply.sh`(dryrun 기본·`commit` 인자로 실 반영).

## 범위 밖 (다음 단계·GB-2 설계 선행)
- **variant가 33상품** — 사이즈등급/색상마다 가격 상이. 현재 variant가 MAT_TYPE.09 자재로 오적재(GB-2). 정답 모델(t_prd_product_prices 차원 vs template vs CPQ 추가가)은 **도메인 컨펌 Q-GP-1/2 선결**. 오적재 자재행 정리(round-13)→CPQ 신설(round-6).
- **무가격 5**(투명부채·미니CD앨범·극세사타월·타이벡북커버·말랑증사홀더) — 엑셀에도 가격 없음 → 실무진 BLOCKED.
- GB-3(볼체인/스탠드 addon·잉크 자재오염)·GB-4(가공 택일그룹)·GB-6(206 빈 CPQ) = ①UI 트랙(별도).
