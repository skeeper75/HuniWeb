# 라이브 고객사이트 가격 교차검증 헬퍼 (huniprinting.com · gstack browse)

> §27 가격 종단 마스터 오케스트레이터의 **신설 오라클** — 단계1(구성요소·옵션 발굴)·단계5(가격값)
> 에서 라이브 고객사이트를 손님처럼 구동해 우리 적재값과 대조한다.
> ★위상[HARD·사용자 결정 2026-06-28]: **교차검증 오라클**(경쟁사 벤치마크와 동류이되 본인 사이트라 더 강함).
> 권위 엑셀(상품마스터260610·가격표260527)이 **절대 기준**. 라이브 ASP는 **구 시스템**(리뉴얼 대상)이라
> 값이 옛것일 수 있다. **차이 = 조사 신호**(자동 교정 금지). 라이브 ASP에 맞춰 우리 값을 바꾸지 않는다.

## 왜 별도 오라클인가 (webadmin 시뮬레이터와 다름)
- webadmin `/admin/price-simulator/` = **우리 리뉴얼 DB**(t_prc_*) 계산값 = 검증 대상.
- huniprinting.com `goods.asp` = **현재 손님이 실제 보는 라이브 ASP 값** = 독립 오라클.
- 둘이 일치하면 고신뢰. 불일치하면 조사: ⓐ 우리 적재 오류 ⓑ 의도된 가격 변경(리뉴얼) ⓒ 라이브 ASP가 stale.

## 라이브 사이트 사실 (정찰 2026-06-28·검증됨)
- **봇 차단:** `curl` → HTTP 403. **gstack browse(진짜 Chromium)** → 200. ★반드시 browse.
- **인코딩:** EUC-KR. 정적 fetch 본문 decode는 되나 `<title>`·breadcrumb는 JS 주입(고정 모지바케 "캑")이라
  **네비게이트 후 렌더된 `body.innerText`로 읽어야** 정확. 상품 그리드도 JS 렌더(정적 fetch 무용).
- **메뉴:** 이미지 스프라이트(gif·텍스트 없음). 카테고리명은 상품 상세 breadcrumb로만 신뢰.
- **상품 상세 = `https://www.huniprinting.com/product/goods.asp?pcode=N`** (손님 주문 폼).
  - 상품명: `body.innerText` 첫 줄 breadcrumb `홈 > <카테고리> > <상품명>`.
  - **옵션/구성요소 오라클:** `<select>` 들 — `tmp_width`/`tmp_height`(면적 가로x세로 mm)·`tmp_p02`(소재)·
    `tmp_p05`/`tmp_p06`…(가공/부속 옵션). 옵션 라벨 = 라이브가 제공하는 실제 구성요소.
  - **가격 오라클:** 옵션 선택 → onchange `setActionCheck()` → 본문 `합계금액 : N원 ( 공급가 : S원 + 부가세 )`
    또는 `#trans_total_num`(공급가)·`price_01`. **공급가(supply price)로 비교**(우리 골든=부가세 전).

## 구동 절차 (한 상품)
```bash
B=/Users/innojini/.claude/skills/gstack/browse/dist/browse
PC=72   # goods.asp pcode (라이브)
$B goto "https://www.huniprinting.com/product/goods.asp?pcode=$PC" >/dev/null 2>&1
# 1) 상품명 + 옵션 구조(구성요소 오라클)
$B js "document.body.innerText.split('\n').map(s=>s.trim()).filter(Boolean)[0]"          # breadcrumb
$B js "Array.from(document.querySelectorAll('select')).map(s=>(s.name)+': '+Array.from(s.options).map(o=>o.textContent.trim()).join('|')).join('\n')"
# 2) 골든 케이스 선택(우리 매트릭스와 동일 사이즈·소재·옵션) → 가격 읽기
$B select 'select[name=tmp_width]'  "50" >/dev/null 2>&1
$B select 'select[name=tmp_height]' "50" >/dev/null 2>&1
$B select 'select[name=tmp_p02]'    "투명아크릴(3T)" >/dev/null 2>&1
$B select 'select[name=tmp_p05]'    "은색" >/dev/null 2>&1
$B js "typeof setActionCheck==='function'&&setActionCheck()" >/dev/null 2>&1; sleep 1
$B js "var t=document.body.innerText,i=t.indexOf('합계금액');t.slice(i,i+70).replace(/\s+/g,' ')"  # 공급가
```

## pcode 인덱스 만들기 (로스터)
정적 fetch가 그리드를 안 주므로 **네비게이트 스캔**으로 breadcrumb 수집:
```bash
for p in $(seq 1 150); do
  $B goto ".../product/goods.asp?pcode=$p" >/dev/null 2>&1
  bc=$($B js "(document.body.innerText.split('\n').map(s=>s.trim()).filter(Boolean).find(s=>s.indexOf('홈')===0&&s.indexOf('>')>-1))||''")
  [ -n "$bc" ] && echo "$p | $bc"
done
```
→ `_huni_live_pcode-index.csv`(pcode,카테고리,상품명). 우리 prd_cd↔라이브 pcode 수동 매핑(이름 기반).

## 판정 규칙 (교차검증 매트릭스)
| 결과 | 의미 | 처리 |
|------|------|------|
| 구성요소 일치 + 가격 근접 | 고신뢰 | PASS(우리 적재 정상 강화) |
| 구성요소 일치 + 가격 상이 | 조사신호 | 우리 적재·권위 엑셀·라이브 stale 중 무엇인지 조사(자동교정 X) |
| 구성요소 불일치(라이브에 옵션/소재 더 있음) | 갭 신호 | 단계1 무결성으로 라우팅(누락 가능성) |
| 라이브에 상품 없음 / 분류 다름 | 분류 차이 | 리뉴얼 의도 차이 기록(라이브가 정답 아님) |
| 라이브 미실측(폼 구동 실패) | 미실측 | "미실측" 명시(누락 은폐 금지) |

## ★off-grid 공식 역확인 (단가/합가 공식 확정 — 2026-06-28 신설)
고정 셀 대조를 넘어 **가격표에 없는 수량(95·97)·임의 사이즈**를 넣어 실제 계산공식을 확정한다(특히 합가).
확정된 4규칙(라이브 실증)=`price-formula-live-confirmation.md`:
1. **자유수량 단가형**(아크릴 굿즈·실사 규격) = 공급가 = **단가×수량**(선형·95/97 정확 배수). `qty`=text 입력.
2. **per-unit 합가** = 면적 base + 옵션 가산(additive·이중합산 0). 옵션 select 토글로 가산액 분해.
3. **면적 사이즈 = 격자 lookup**(preset만 즉시가)·**off-grid=견적문의**(연속 보간 아님·즉시가 0=정상). 실사 비규격=고객문의.
4. **밴드수량**(디지털·명함·봉투·스티커·엽서) = qty SELECT 밴드 lookup(×qty 아님·97 입력 불가).
```bash
# 자유수량 단가 검증
$B fill 'input[name=qty]' "97"; $B js "typeof setActionCheck==='function'&&setActionCheck()"; sleep 1
$B js "var t=document.body.innerText,i=t.indexOf('공급가');t.slice(i,i+18)"   # = 단가×97 이어야 정답
```
오접근 위험 3종(합가 오류 근원): ① 밴드수량을 ×qty로 모델 ② L2 선조립표인데 L1 단가 또 더함(이중합산) ③ 면적 연속 보간. 셋 다 라이브가 정답을 보여줌.
※ live JS 주의: `$B select`/`$B fill`(네이티브 이벤트) 사용·JS `.value=`+dispatch는 레이스/0원 유발.

## 경계·안전 [HARD]
- 라이브 **읽기 탐색만** — 장바구니/주문/결제/폼 submit **금지**(goods.asp는 옵션선택까지만, 담기 클릭 X).
- 비밀값/세션 비노출. 라이브 ASP는 정답 아님 — **우리 값을 라이브에 맞춰 바꾸지 않는다**(권위=엑셀).
- 차이는 전부 "조사 신호"로 기록 → 인간 판단/단계 라우팅. 교차검증은 **검증 보강**이지 교정 트리거 아님.
