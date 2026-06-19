# codex 독립 교차검증 — PO (포맥스·폼보드·등신대·피켓)

> 후니 RP-Meta 하네스 Phase 6.5 (rpm-codex-validator). codex-cli `codex exec` 읽기전용 독립 2nd opinion.
> **모델 = gpt-5.5** (codex-cli 0.140.0, `--sandbox read-only --skip-git-repo-check`).
> ★독립성 HARD: codex 프롬프트에 우리 mgate-verdict(GO/NO-GO·부결 라벨·"제작방식=#12"·"자립=형상+부속물") **비노출**. 증거(reverse 원자 + 17축 frame)만 제시·codex 자체 판정 요구.
> ★[HARD] 모든 codex 주장 = `unverified` 가설. 라이브/권위 재검증 전 채택 금지(환각 경계). 라이브 우선·codex 인용 신뢰 금지.

---

## codex 독립 판정 원문 (verbatim, gpt-5.5)

**판정: ABSORBED** `[unverified]`

**1. 신규 축 여부 — ABSORBED** `[unverified]`
> PO는 하드보드 인쇄라는 상품군일 뿐, 관리 의미는 기존 축으로 손실 없이 분해됩니다. `paper`는 #1 material의 substrate/thickness/color facet, `coating`과 `tiling`은 #2 process, 단면/양면은 #3, 스탠드/와이어는 #8, 면적 기반 가격은 #10/#11/#13, 모양재단은 #17 shape입니다. 별도 18번째 축을 만들 근거는 약합니다.

**2. 생산방식(direct-print vs laminated) — 신규 축 아님** `[unverified]`
> 이는 #12 print-method recipe의 값 또는 상품별 recipe 분기입니다. 특히 HAP/PRT가 `pdtCode`로 상품을 나누고, 그 결과 coating 활성 여부와 material 후보군이 달라지는 구조라서 "생산방식이 후속 옵션을 gate한다"는 #12의 기존 역할에 정확히 들어갑니다. Lamination 자체는 #2 process로도 표현됩니다.

**3. 자립 구조(등신대 스탠드 / 피켓 손잡이) — 신규 축 아님** `[unverified]`
> 등신대는 shape-cut/cutout + stand accessory 조합입니다. 스탠드는 독립 SKU도 있으므로 #8 accessory/add-on에 잘 들어갑니다. 피켓 손잡이는 별도 부속물이 아니라 판재 자체의 형상/구조이므로 #17 shape 또는 material/recipe facet으로 흡수하는 쪽이 맞습니다.

**4. fabrication / overfit / 부적절한 gap call 징후 — 없음** `[unverified]`
> 제공 증거 기준으로는 조작이나 날조 징후는 보이지 않습니다. 다만 `hard-substrate`, `self-standing`, `laminated-method`를 각각 신규 축으로 승격하면 overfit입니다. 모두 기존 축의 조합으로 일반화가 더 잘 됩니다. print-domain 관점에서도 포맥스/폼보드 POP류는 "새 관리축"이라기보다 **판재 자재 + 면적 사이즈 + 후가공 + 부속물 + 형상 + 생산레시피**의 전형적 조합입니다.

---

## 가용성 노트
- **codex 가용** = gpt-5.5 (codex-cli 0.140.0). foreground `cat prompt | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check --output-last-message …` 정상 작동·last-message 수집 성공.
- preflight 백그라운드 행/timeout 미설치 회피 위해 foreground 직접 호출 사용.
- codex `-s read-only` (저장/쓰기 부작용 0). 자격증명·내부 specifics 프롬프트 비노출.

*독립 2nd opinion. codex 주장=가설(unverified). reconcile은 `05_validation/codex-reconcile-PO.md`.*
