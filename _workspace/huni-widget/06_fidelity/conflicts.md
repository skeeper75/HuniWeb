# conflicts.md — 구조 충돌 · 후니 스펙 갭 · 애매 항목 (1차 정적 + 2차 시각검증)

> 규칙: 충돌 시 Red 구조 유지 + 후니 외형만 적용, 임의 판단·삭제 금지. 출처 병기로 기록만 하고 보고한다.
> 후니 스펙에 없는 외형은 창작하지 않고 GAP으로 보고(진실 소스 이중화 방지).

## A. 시각 검증 (2차 패스 — 해소됨)

### CONF-VIS-1 · 시각 렌더 미검증 — **CLOSED (2026-06-03 2차)**
- 1차 현황: claude-in-chrome 미노출로 정적 토큰 대조만 가능했음.
- 2차 해소: gstack `browse` 헤드리스 브라우저(bun 1.3.14) 확보. dev 서버 http://localhost:5174/ 위젯을 실제 렌더 → Shadow root 관통(`getElementById('host').shadowRoot`) computed style 덤프 + BEFORE/AFTER 스크린샷 수집.
- 결과: 1차 정적 판정 7종 전부 실측으로 **확인(보정 0건)**. 추가로 GAP-2 시각 발견·정합. fidelity-report §0 실측 대조표 참조.

## B. 후니 스펙 갭 (창작 금지 → 보고)

### GAP-1 · image-chip 라벨 색 — 시각 미검증(상품군 제약)
- 위젯: 라벨 `text-[11px] text-[#979797]` (ImageChip.tsx, LargeColorChip span 동일).
- 후니 출처: DESIGN §7.6 image-chip-label textColor **#424242**(text-label). §7.8 large-color-chip-label도 #424242.
- 충돌: 위젯 라벨 #979797(text-muted) vs 스펙 #424242.
- 2차 결과: 렌더 대상 PRBKYPR(책자)에 **image-chip/color-chip 미렌더** → 실제 시각 검증 불가. ColorChip/ImageChip 사용 상품(스티커 STTHCIC/아크릴 등) 로드 필요.
- 미적용 사유: 시각 미확인 + 회색지대(미선택 톤 의도 가능). 다음 라운드 해당 상품군 렌더 후 결정.

### GAP-2 · select-box 드롭다운(Popover.Content) radius·shadow — **CLOSED (2차 정합)**
- 1차 현황: `shadow-lg`만 className, radius 유틸 없음.
- 2차 시각 발견: 실측 결과 드롭다운 radius **0px**, **box-shadow 비어있음**(rgba(0,0,0,0) 0px). Tailwind `shadow-lg`가 Shadow DOM 내부에서 `--tw-shadow` 변수 체인(base layer 초기화) 단절로 무력화됨.
- 정합: `rounded-b-[4px]` 추가 + `shadow-lg` 제거 후 `style.boxShadow`에 Tailwind shadow-lg 표준값(`0 10px 15px -3px rgba(0,0,0,.1), 0 4px 6px -4px rgba(0,0,0,.1)`) 명시 주입. 2차 재측정 radius 4px·shadow 적용 확인.
- 출처: DESIGN §5 드롭다운 오버레이 = `shadow-lg ... rounded-b-[4px]`. 외형 토큰만 변경(포털 컨테이너·핸들러 무변경).

### GAP-3 · finish-button 폰트 weight — 보류(구조 분기 경계)
- 위젯: option/finish 공용 `text-[14px] font-semibold`. 2차 실측 finish-button(116px) **14px/600** 확인.
- 후니 출처: DESIGN §7.11 FinishButton 기본 12px/400, 선택 caption-semibold(12px/600).
- 충돌: finish=12px이어야 하나 공용 OptionButtonBase라 14px/600 동일.
- 미적용 사유: width는 props로 분기(116) 가능하나 fontSize/weight는 현재 공용 className 하드코딩. 변경하려면 finish 전용 variant 분기 필요 → 외형/구조 경계(hw-architect 협의). 회색지대로 보류.

## C. 애매 / 보류 (외형 변동 위험)

### AMB-1 · ColorChip / ImageChip `ring-offset-2` — 시각 미검증(상품군 제약)
- 위젯: 선택 시 `ring-2 ring-[#553886] ring-offset-2`.
- 후니 출처: DESIGN §7.4/RULE-4 = "흰 채움 + #553886 ring 2px" — offset 명시 없음.
- 2차 결과: PRBKYPR에 color-chip/image-chip **미렌더** → 시각 확인 불가. 회색지대(offset이 "흰 채움" 보강 의도일 수 있음). 해당 상품군 렌더 후 결정.

### AMB-2 · summary 부가세/배송비 행 라벨 색 — 회색지대 유지
- 위젯: 부가세·배송비 라벨·금액 모두 `text-[12px] text-[#424242]`. 2차 실측 #424242 확인.
- 후니 출처: §7.13 summary-item caption #616161은 "공정별 분해 항목"(lines) 기준. 위젯 lines 라벨은 실측 **#616161(일치)**, 부가세/배송비는 별도 고정행.
- 미적용 사유: 부가세/배송비가 §7.13 item 규격 직접 대상인지 스펙 불명. 회색지대 유지(실무 확인 권장).

### AMB-3 · letter-spacing em 비례 차이 — 회색지대(1px 강박 금지)
- 2차 발견: 전 요소 실측 letter-spacing `-0.8px` 균일. `:host`의 `-0.05em`이 em 기준이라 host 16px 고정값(16×-0.05=-0.8)을 상속, 자식 fontSize에 비례하지 않음.
- 후니 출처: DESIGN §3 "letterSpacing = fontSize × -0.05"(14px→-0.7, 12px→-0.6).
- 미적용 사유: 토큰 `-0.05em` 자체는 정합이고 차이는 0.1~0.2px 수준(1px 강박 금지 원칙). 엄밀 비례가 필요하면 컴포넌트별 letter-spacing 명시 필요 — 외형이나 14개 전수 변경 부담. 회색지대 유지.

### AMB-4 · 미선택 버튼 weight 600 vs §7.1 400 — 보류(구조 분기 경계)
- 2차 발견: option-button 미선택 실측 fontWeight **600**(공용 `font-semibold`). DESIGN §7.1 기본은 14px/**400**, 선택만 600.
- 미적용 사유: 선택/미선택 weight 분기는 className 조건부로 가능(외형)하나, 현재 base className에 `font-semibold` 고정. 변경 시 selected 분기에 weight 추가 이동 필요 — 외형 범위지만 RULE-2 핵심 표현(선택=강조)과 맞물려 시각 영향 큼. 미선택 약화가 후니 의도("미선택=placeholder 톤")와 부합할 수 있어 보류, 시각/실무 확인 후 결정.

## D. 구조 충돌 (Red 권위 — 외형 변경 불가, 발생 0건)
- 1차·2차 통틀어 후니 외형 적용이 Red 배치·캐스케이드·상태전이와 충돌한 사례 **없음**. 모든 정합이 순수 className 토큰 + style.boxShadow(외형) 레벨에서 완결(git diff 구조 0변경 + test 76 통과로 입증).

---

## 다음 라운드 입력 우선순위
1. **GAP-1·AMB-1**: ColorChip/ImageChip 사용 상품군(스티커 STTHCIC, 아크릴 등) 위젯 로드 후 라벨색·ring-offset 시각 검증·결정.
2. **GAP-3·AMB-4**: finish-button weight·미선택 weight — variant 분기는 외형/구조 경계라 hw-architect 협의 후 처리.
3. **AMB-2·AMB-3**: summary 고정행 색·letter-spacing 비례 — 실무진 확인(회색지대, 토큰 영향 광범위).
