# visual-manifest.md — 비전문가용 위젯 플로우 인포그래픽

> 시각화가: hwf-flow-visualizer · 청중=비전문가(기획·운영·고객)
> 이미지 본문=`codex-imgage`(OpenAI Codex CLI 내장 image_generation, ChatGPT OAuth) 생성. 직접 그리지 않음.
> 근거 팩: `01_curation/widget-architecture.md` · `01_curation/path-branch-spec.md` · `01_curation/product-path-matrix.csv`
> 환각 경계: 프롬프트엔 팩 사실만. codex 산출=가설 → 최종 정합 판정은 hwf-validator(F5에서 텍스트 깨짐·사실 정합 점검).

## codex 가용 여부

- `codex-cli 0.140.0` · `Logged in using ChatGPT` · `image_generation = stable / true` → **가용**. 4장 병렬 생성.
- 미가용/데드락 시 폴백: "이미지 생성 codex 의존 — 미생성" 명시 + 임시 mermaid 단순 도해. (이번엔 가용이라 미적용)

## 비전문어 라벨 규칙

전문어 금지 → 일상어 매핑(프롬프트에 반영):
- `exterior.uploadType==="pdf"` / S3 presigned → "Upload my file (PDF)" / "내 파일 직접 올리기"
- `exterior.uploadType==="editor"` / RedEditorSDK·Edicus iframe → "Design in editor" / "편집기로 디자인하기"
- `POST get_ajax_price_vTmpl` / priceCalc → "Price auto-calculated" / "가격 자동계산"
- `canOrder()` 통과 → "Place order / Ready to order" / "주문하기"
- `item_gbn` / 신위젯(Shadow DOM) vs 레거시(product.js) → 제품군 그룹 분류

## 한글 텍스트 깨짐 대응[HARD]

이미지 내 텍스트는 **영어 라벨만** 사용(한글 렌더 불안정). 한국어 의미는 본 manifest·02_mermaid에서 병기. 생성 PNG에 텍스트 깨짐·오탈자가 있으면 manifest "우려"에 기록하고 hwf-validator F5가 점검.

---

## 이미지 1 — journey-overall.png

**의도:** 비전문가가 처음 보고 "주문이 어떻게 흘러가는가"를 좌→우 한 줄로 이해. 분기(업로드/편집기)가 가격계산 전에 합류함을 시각화.

**담은 사실(근거):**
- 5단계 골격: 상품선택 → 옵션 → (업로드/에디터 분기) → 가격 자동계산 → 주문.
  - 옵션→가격 자동계산: `widget-architecture.md:75-90` (옵션 변경→`POST get_ajax_price_vTmpl`→`result_sum`→UI).
  - 업로드/에디터 분기는 옵션 단계 이후·주문 검증 전: `widget-architecture.md:105-119`, `path-branch-spec.md:23-98`.
  - 주문 가능 검증(canOrder)이 분기 종합 지점: `widget-architecture.md:142-152`.
- 분기를 fork로 그리되 둘 다 "주문" 전에 합류 — canOrder가 업로드/에디터 충족을 공통 검증(`widget-architecture.md:144`).

**codex 프롬프트:** `/tmp/codex-img-1.md` 작업의 PROMPT (numbered 1-5 horizontal pipeline, Step3 fork→merge, 가격=won tag, 주문=cart).

**우려:** "Price auto-calculated"가 5단계 중 가격이 사실 옵션 변경마다 실시간 갱신(특정 1스텝 아님)인데, 비전문가 단순화를 위해 단계로 표현 — 의미 왜곡 아님(가격은 옵션 후 자동 산출이 맞음). 텍스트 깨짐은 생성 후 점검.

## 이미지 2 — product-groups.png

**의도:** 26 카테고리(상품군)를 비전문가가 "어떤 상품이 어떤 경로를 쓰나" 3그룹으로 직관 이해.

**담은 사실(근거):**
- GROUP A "Editor + Upload both" = 책자(book2025_item): 내지+표지 각각 PDF 또는 에디터 둘 다 가능. `path-branch-spec.md:108-110`, matrix PR책자 6종(PRBKYPR/PRBKYRN/PRBKYSL/PRBKORD/PRBKOPR/PRBKOST) 확인.
- GROUP B "Editor-focused" = 굿즈(GS)·아크릴(AC) vDigital_item: GSTGMIC·ACNTHAP 신위젯 확인. 코드상 PDF 경로 존재하나 대표 캡처는 에디터 중심 → "editor-focused"로 표기. `path-branch-spec.md:111`, matrix GS/AC '확인'.
- GROUP C "Legacy: Upload-centric" = 명함(BC)·전단(LF)·스티커(ST)·배너(BN) 등 400+ 레거시(product.js, Shadow DOM 없음). `widget-architecture.md` 0절, matrix BC/LF/ST/BN '레거시=신위젯 대상 아님'.

**codex 프롬프트:** `/tmp/codex-img-2.md` PROMPT (3 color-coded buckets, book / acrylic+keyring / card+flyer+sticker+banner).

**우려[HARD·정직]:**
- matrix상 GS/AC 카테고리의 **개별 상품 대다수는 "모름(직접증거 없음)"** — 대표 1건씩만 '확인'. 그룹 분류는 대표 캡처 기반 일반화이며 "전 상품 단정"이 아님. 인포그래픽은 그룹 경향만 표현(비전문가용 단순화). 정밀 단정은 product-path-matrix.csv confidence 컬럼이 권위.
- "Legacy=Upload-centric"의 upload/editor 가용성도 matrix상 다수 '모름' — 레거시=구 시스템(신위젯 아님)이라는 사실만 확정. 라벨 "Upload-centric"은 레거시 인쇄주문의 통상 형태를 비전문가용으로 표현한 것 → hwf-validator가 과단정 여부 점검 권장.

## 이미지 3 — path-compare.png

**의도:** "내 파일 올리기"와 "편집기로 디자인" 두 여정을 나란히 비교(two parallel lanes)해 차이를 한눈에.

**담은 사실(근거):**
- 업로드 레인: 파일선택 → 검증(확장자/1GB) → presigned 안전 업로드(S3 PUT) → 주문가능. `path-branch-spec.md:23-47`.
- 에디터 레인: 편집기 열기(에디터 탭 기본 active+편집하기) → 템플릿으로 디자인 → 저장(save-doc-report) → 위젯 복귀(setEditorData) → 주문가능. `path-branch-spec.md:55-98`.
- 두 레인 모두 끝이 "Ready to order"(canOrder 통과)로 수렴. `path-branch-spec.md:45,97`.

**codex 프롬프트:** `/tmp/codex-img-3.md` PROMPT (left blue lane Upload 4-step, right green lane Editor 5-step, divider).

**우려:** 단계 수가 레인별로 다름(업로드 4 vs 에디터 5)은 의도된 사실(에디터는 위젯↔에디터 왕복이 있어 단계 많음). presigned·postMessage 등 내부 용어는 "Secure upload"·"Save/Back to widget"로 평이화. 텍스트 깨짐 점검 필요.

## 이미지 4 — representative-journeys.png

**의도:** 대표 상품군 2케이스로 그룹 차이를 구체화 — 책자=두 경로 다 가능, 굿즈/아크릴=편집기 중심.

**담은 사실(근거):**
- 책자: 내지(inner)+표지(default) 각각 PDF 또는 에디터 → "Both OK". `path-branch-spec.md:108-110`, `widget-architecture.md:147`.
- 굿즈/아크릴(vDigital_item): 에디터 중심(대표 GSTGMIC/ACNTHAP), 코드상 PDF 경로도 존재. `path-branch-spec.md:111`, matrix GS/AC.

**codex 프롬프트:** `/tmp/codex-img-4.md` PROMPT (Card1 Booklet cover+inner each upload+editor 'Both OK'; Card2 Goods/Acrylic editor primary 'Editor-focused').

**우려[정직]:** "Editor-focused"는 대표 캡처 기반 경향 표기 — 굿즈/아크릴도 코드상 PDF 업로드 경로가 있어 "에디터 전용"으로 단정하지 않음(`path-branch-spec.md:124` 명시: vDigital_item=에디터 전용은 코드 레벨 단정 불가). 카드 배지를 "Editor-focused"(전용 아님)로 둔 이유. 명함류는 본 하네스 신위젯 범위 밖(레거시)이라 대표 케이스에서 제외.

---

## 종합 우려·후속

1. **텍스트 깨짐(F5 점검 대상):** 전 이미지 영어 라벨만 사용했으나 codex 렌더가 철자 누락/왜곡할 수 있음 — 생성 PNG 육안 확인 후 깨짐분 재생성 권장.
2. **그룹 분류의 일반화 한계:** 이미지 2·4의 그룹 경향은 대표 캡처 기반. 상품 단위 정밀 가용성은 product-path-matrix.csv(다수 '모름')가 권위 — 인포그래픽을 "전 상품 확정"으로 오독 금지.
3. **codex 산출=가설:** 본 4장은 hwf-validator 정합 검증 전까지 잠정. 사실 왜곡(없는 단계·수치 추가) 발견 시 해당 장 재생성.
