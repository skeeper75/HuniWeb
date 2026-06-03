// L-12 (D4 정당화 신규 leaf #2) — ACC 부자재 다단 캐스케이드/멀티 패널.
//  Red Acc(deob_07:2006~2291): accFilterConfigMap[pdtCode][pttCode].uiType(CASCADE/MULTI) +
//  filters[].GRP_TYPE 4분기 Selector. 우리는 어댑터가 accSpec(AccPanelSpec)으로 평면화 → 본 패널이 렌더.
//  - CASCADE: 단계별 종속 select(상위선택→하위 활성). dependsOn 단계는 상위 미선택 시 비활성.
//  - MULTI: 그룹별 독립 멀티선택(체크박스).
//  [HARD RULE-5] 라벨 props(.map). 선택값은 그룹 id 별로 store selection 에 보관(어댑터 평면 키).
import type { AccPanelSpec, AccFilterGroup } from '@/contract';
import { cn } from '../primitives/cn';

interface Props {
  spec: AccPanelSpec;
  // 그룹 id → 현재 선택(단일=string / 멀티=string[]).
  values: Record<string, string | string[] | undefined>;
  onChange: (groupId: string, value: string | string[]) => void;
}

function CascadeStep({
  group,
  value,
  enabled,
  onChange,
}: {
  group: AccFilterGroup;
  value: string | undefined;
  enabled: boolean;
  onChange: (v: string) => void;
}) {
  return (
    <div className="flex flex-col gap-1">
      <label className="text-[14px] font-medium text-[#424242]">{group.label}</label>
      <div className="flex flex-wrap gap-0" role="radiogroup" aria-label={group.label}>
        {group.values.length === 0 ? (
          // 옵션 부재(상위선택 의존) — 상위 미선택 시 안내, 선택 시 동적옵션은 후니 BFF 가 채움(slot).
          <span className="text-[13px] text-[#979797]">{enabled ? '상위 옵션 선택 후 표시' : '이전 단계를 먼저 선택하세요'}</span>
        ) : (
          group.values.map((v) => {
            const selected = v.id === value;
            const disabled = !enabled || v.disabled === true;
            return (
              <button
                key={v.id}
                type="button"
                role="radio"
                aria-checked={selected}
                aria-disabled={disabled}
                disabled={disabled}
                onClick={() => !disabled && onChange(v.id)}
                style={{ height: 44 }}
                className={cn(
                  'flex items-center justify-center rounded-[4px] px-3 text-[14px] font-semibold transition-colors border bg-white',
                  disabled
                    ? 'border-[#CACACA] bg-[#F5F5F5] text-[#CACACA] cursor-not-allowed'
                    : selected
                      ? 'border-2 border-[#553886] text-[#553886]'
                      : 'border-[#CACACA] text-[#979797] hover:border-[#553886]',
                )}
              >
                {v.label}
              </button>
            );
          })
        )}
      </div>
    </div>
  );
}

function MultiGroup({
  group,
  value,
  onChange,
}: {
  group: AccFilterGroup;
  value: string[];
  onChange: (v: string[]) => void;
}) {
  const toggle = (id: string) =>
    onChange(value.includes(id) ? value.filter((x) => x !== id) : [...value, id]);
  return (
    <div className="flex flex-col gap-1">
      <label className="text-[14px] font-medium text-[#424242]">{group.label}</label>
      <div className="flex flex-wrap gap-0" role="group" aria-label={group.label}>
        {group.values.map((v) => {
          const on = value.includes(v.id);
          return (
            <button
              key={v.id}
              type="button"
              role="checkbox"
              aria-checked={on}
              onClick={() => toggle(v.id)}
              style={{ height: 44 }}
              className={cn(
                'flex items-center justify-center rounded-[4px] px-3 text-[14px] font-semibold transition-colors border bg-white',
                on ? 'border-2 border-[#553886] text-[#553886]' : 'border-[#CACACA] text-[#979797] hover:border-[#553886]',
              )}
            >
              {v.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}

export function AccPanel({ spec, values, onChange }: Props) {
  return (
    <div className="flex flex-col gap-3" role="group" aria-label="부자재">
      {spec.groups.map((g) => {
        if (spec.uiType === 'MULTI' || g.kind === 'multi-group') {
          const v = values[g.id];
          return <MultiGroup key={g.id} group={g} value={Array.isArray(v) ? v : []} onChange={(nv) => onChange(g.id, nv)} />;
        }
        // CASCADE: dependsOn 이 있으면 직전 단계가 선택돼야 활성.
        const v = values[g.id];
        const cur = Array.isArray(v) ? v[0] : v;
        const enabled = g.dependsOn == null || values[g.dependsOn] != null;
        return (
          <CascadeStep key={g.id} group={g} value={cur} enabled={enabled} onChange={(nv) => onChange(g.id, nv)} />
        );
      })}
    </div>
  );
}
