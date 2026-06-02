/* 비교 검증 하네스 — 컨트롤 + 검증 패널 주입. 의존성 없음.
 * 두 위젯은 서로 다른 코드베이스이므로 자동 옵션 동기화는 의도적으로 하지 않음.
 * 사람 눈 비교 + 수동 체크리스트 + DESIGN.md 시각 의도 = 3중 기준. */
(function () {
  'use strict';

  // ── 뷰포트 폭 ──────────────────────────────────────
  var vwSel = document.getElementById('vw');
  function applyVw() {
    document.documentElement.style.setProperty('--vw', vwSel.value + 'px');
  }
  vwSel.addEventListener('change', applyVw);
  applyVw();

  // ── 새로고침 ───────────────────────────────────────
  var fOurs = document.getElementById('frameOurs');
  var fRed = document.getElementById('frameRed');
  document.getElementById('reload').addEventListener('click', function () {
    fOurs.src = fOurs.src; // eslint-disable-line no-self-assign
    fRed.src = fRed.src;   // eslint-disable-line no-self-assign
  });

  // ── 스크롤 동기화 (cross-origin iframe 내부는 막힘 → 바깥 스크롤 컨테이너만 동기화) ──
  var sync = document.getElementById('syncScroll');
  var bodies = Array.prototype.slice.call(document.querySelectorAll('.pane-body'));
  var lock = false;
  bodies.forEach(function (b) {
    b.addEventListener('scroll', function () {
      if (!sync.checked || lock) return;
      lock = true;
      var top = b.scrollTop;
      bodies.forEach(function (o) { if (o !== b) o.scrollTop = top; });
      requestAnimationFrame(function () { lock = false; });
    });
  });

  // ── 검증 패널 데이터 (DESIGN.md PRBKYPR / 4-Zone 기반) ──
  var checklist = [
    ['옵션 그룹 노출', '사이즈 · 종이/지질 · 인쇄도수 · 후가공 · 제작수량 그룹이 모두 보이는가'],
    ['옵션 캐스케이드', '상위 옵션(사이즈/종이) 변경 시 하위 선택지가 갱신/제한되는가'],
    ['가격 재계산', '옵션·수량 변경 즉시 합계금액이 다시 계산되는가 (Red 토큰 만료 시 가격은 안 뜰 수 있음)'],
    ['수량 입력', 'CounterInput 3-part(− / 값 / +) 직사각형 형태로 동작하는가'],
    ['후가공 접기/펼치기', 'FinishTitleBar 토글로 후가공 섹션이 열고 닫히는가'],
    ['가격 요약 분해', 'Summary 항목별(상품가/부가세) 분해 + 합계가 나오는가'],
    ['에디터/업로드 진입', 'PDF업로드 / 디자인에디터 / 장바구니 CTA 3종이 보이고 클릭되는가'],
    ['선택 상태 시각', '선택된 버튼이 흰 배경 + 보라 테두리(RULE-2)로 표시되는가'],
    ['컬러칩 형태', 'ColorChip이 50×50 원형(RULE-4)으로 렌더되는가'],
    ['CSS 격리', '호스트 페이지 공격 CSS(빨강 둥근 버튼/Times)에 우리 위젯이 오염되지 않는가']
  ];

  var zones = [
    ['Zone 1', '옵션 선택', 'OptionButton 155×50 3-col · SelectBox 348×50 · 추천배지'],
    ['Zone 2', '수량 + 후가공 헤더', 'CounterInput 223×50 · FinishTitleBar 466×50 토글'],
    ['Zone 3', '후가공 옵션', 'FinishButton 116×50 · AreaInput 140×50 · ColorChip 50×50'],
    ['Zone 4', '부자재 + 합계 + 업로드', 'FinishSelect 461×50 · Summary · Upload 3종 465×50']
  ];

  var swatches = [
    ['#553886', 'primary'], ['#3B2573', 'p-dark'], ['#9580D9', 'p-2nd'],
    ['#E6B93F', 'gold'], ['#7AC8C4', 'teal'], ['#1E1E1E', 'text'], ['#CACACA', 'border']
  ];

  // ── 렌더 ───────────────────────────────────────────
  var el = document.getElementById('sidebody');
  var html = '';

  html += '<div class="legend">' +
    '<span style="background:#2563eb">우리 = 구현</span>' +
    '<span style="background:#d92121">Red = 동작 정답</span>' +
    '<span style="background:#553886">DESIGN = 시각 의도</span></div>';
  html += '<p class="note">왼쪽(우리)과 가운데(Red)에 같은 옵션을 직접 눌러 가며 아래 항목을 눈으로 대조하세요.</p>';

  html += '<h3>비교 체크리스트</h3><ul class="checklist">';
  checklist.forEach(function (c, i) {
    html += '<li><input type="checkbox" id="ck' + i + '">' +
      '<span class="label"><b>' + c[0] + '</b><small>' + c[1] + '</small></span></li>';
  });
  html += '</ul>';

  html += '<h3>4-Zone 구조 (DESIGN.md §4.1)</h3><table class="spec">' +
    '<tr><th>Zone</th><th>명칭</th><th>주요 컴포넌트</th></tr>';
  zones.forEach(function (z) {
    html += '<tr><td><b>' + z[0] + '</b></td><td>' + z[1] + '</td><td>' + z[2] + '</td></tr>';
  });
  html += '</table>';

  html += '<h3>브랜드 컬러 (시각 의도)</h3><div class="swatch-row">';
  swatches.forEach(function (s) {
    html += '<div class="swatch" style="background:' + s[0] + '"><small>' + s[1] + '</small></div>';
  });
  html += '</div><div style="height:16px"></div>';

  html += '<h3>레퍼런스 메모</h3><div class="refbox">' +
    '<b>동작 기준</b>: Red(:3001) — 가격 API·옵션 캐스케이드·Edicus 에디터 진입 흐름의 정답.<br>' +
    'RP 토큰이 만료되면 <b>렌더·상호작용은 정상</b>이나 라이브 가격은 안 뜰 수 있음(정상).<br><br>' +
    '<b>시각 기준</b>: <code>_workspace/print-quote/04_design/DESIGN.md</code> (14 componentType, Noto Sans, primary #553886).<br>' +
    'Figma 원본 <code>docs/figma/huni_product_option.fig</code> 은 바이너리라 여기 인라인 불가(참고용).<br><br>' +
    '<b>주의</b>: 두 위젯은 별개 코드베이스 → 자동 옵션 동기화는 의도적으로 미구현. 같은 값을 양쪽에 손으로 맞춰 비교.' +
    '</div>';

  el.innerHTML = html;

  // ── 체크 진행률 (제목바에 표시) ────────────────────
  var titleMuted = document.querySelector('.topbar-title .muted');
  var baseTitle = titleMuted.textContent;
  function updateProgress() {
    var boxes = el.querySelectorAll('.checklist input');
    var done = 0;
    boxes.forEach(function (b) { if (b.checked) done++; });
    titleMuted.textContent = baseTitle + '  ·  체크 ' + done + '/' + boxes.length;
  }
  el.addEventListener('change', updateProgress);
  updateProgress();
})();
