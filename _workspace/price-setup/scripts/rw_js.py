"""화면에서 할 일(새 행 추가 + 옛 행 삭제표시)을 JS 로 만든다. 저장은 셸이 한 번만 누른다."""
import json
import sys
swaps = json.loads(sys.argv[1])
print('''(() => {
  const $ = window.django && window.django.jQuery;
  if (!$) return 'NO_JQUERY';
  const SW = %s;
  const sels = () => Array.from(document.querySelectorAll('select[name*=comp_cd]'))
    .filter(s => !s.name.includes('__prefix__'));
  const addBtn = Array.from(document.querySelectorAll('a,button'))
    .find(e => e.textContent.trim().includes('구성요소 더 추가'));
  // 빈 줄이 교체 건수만큼 생길 때까지 화면의 「구성요소 더 추가하기」를 누른다.
  for (let guard = 0; sels().filter(s => !s.value).length < SW.length; guard++) {
    if (!addBtn) return 'NO_ADD_BTN';
    if (guard > 20) return 'ADD_ROW_LIMIT';
    addBtn.click();
  }
  const log = [];
  for (const pair of SW) {
    const oldCd = pair[0], newCd = pair[1];
    const blank = sels().find(s => !s.value);
    if (!blank) return 'NO_BLANK_ROW:' + newCd;
    if (!Array.from(blank.options).some(o => o.value === newCd))
      blank.appendChild(new Option(newCd, newCd, true, true));
    $(blank).val(newCd).trigger('change');
    const old = sels().find(s => s.value === oldCd);
    if (!old) return 'OLD_ROW_NOT_FOUND:' + oldCd;
    const m = old.name.match(/set-(\\d+)-comp_cd/);
    const cb = document.querySelector('[name="tprcformulacomponents_set-' + m[1] + '-DELETE"]');
    if (!cb) return 'NO_DELETE_CB:' + oldCd;
    cb.checked = true;
    cb.dispatchEvent(new Event('change', {bubbles: true}));
    log.push(oldCd + '→' + newCd);
  }
  return log.join(' · ');
})()''' % json.dumps(swaps, ensure_ascii=False))
