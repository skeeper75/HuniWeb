// NC-1 #dimension-matrix-input — 규격프리셋 칩 + 비규격 가로×세로 자유입력을 한 leaf 로 제공.
// 책임: 선택 모드에 따라 2D 단가 차원(cutW/cutH)을 store 에 공급. 가격 산술은 0(INV-1) — 수치 전달만.
// 패턴: 프리셋 칩 = OptionButton RULE-2(흰배경+border-2 #553886), 자유입력 = AreaInput native input 토큰 동일.
import type { OptionGroup } from '@/contract';
import { cn } from '../primitives/cn';

export interface DimensionInput {
  w: number;
  h: number;
}

interface Props {
  group: OptionGroup; // values = 규격프리셋 + 자유입력 sentinel, inputSpec = 자유입력 범위(min/max + axis2)
  selectedId: string | undefined; // 현재 선택된 프리셋/sentinel id
  freeInputId: string; // 자유입력 sentinel 의 OptionValue.id (sizeRule cutW=0&cutH=0 으로 어댑터/브리지가 식별)
  dimension: DimensionInput | undefined; // 자유입력 W/H (widget-store numeric slot)
  onSelectPreset: (valueId: string) => void; // selection(opaque id) 갱신
  onChangeDimension: (d: DimensionInput) => void; // numeric slot 갱신
}

function clampAxis(raw: string, min: number, max: number): number {
  const n = parseInt(raw.replace(/[^0-9]/g, ''), 10);
  if (!Number.isFinite(n)) return 0;
  if (max > 0 && n > max) return max; // MAX_CUT 초과 거부(상한 clamp)
  if (n < min) return n; // 입력 중 하한 미달은 허용(완성 시 검증) — 0 입력 차단 방지
  return n;
}

export function DimensionMatrixInput({
  group,
  selectedId,
  freeInputId,
  dimension,
  onSelectPreset,
  onChangeDimension,
}: Props) {
  const spec = group.inputSpec;
  const isFree = selectedId === freeInputId;
  const w = dimension?.w ?? 0;
  const h = dimension?.h ?? 0;

  const setW = (raw: string) =>
    onChangeDimension({ w: clampAxis(raw, spec?.min ?? 0, spec?.max ?? 0), h });
  const setH = (raw: string) =>
    onChangeDimension({
      w,
      h: clampAxis(raw, spec?.axis2?.min ?? 0, spec?.axis2?.max ?? 0),
    });

  return (
    <div>
      {/* 규격프리셋 + 자유입력 sentinel 칩 (RULE-2) */}
      <div className="flex flex-wrap gap-0" role="radiogroup" aria-label={group.label}>
        {group.values.map((v) => {
          const selected = v.id === selectedId;
          const disabled = v.disabled === true;
          return (
            <button
              key={v.id}
              type="button"
              role="radio"
              aria-checked={selected}
              aria-disabled={disabled}
              disabled={disabled}
              onClick={() => !disabled && onSelectPreset(v.id)}
              style={{ width: 155, height: 50 }}
              className={cn(
                'flex items-center justify-center text-[14px] font-semibold transition-colors',
                'border bg-white',
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
        })}
      </div>

      {/* 자유입력 모드: 가로×세로 number input 2개 (AreaInput 토큰 동일) */}
      {isFree && (
        <div className="mt-2">
          <div className="flex items-center gap-2">
            <input
              type="text"
              inputMode="numeric"
              aria-label="가로"
              value={w === 0 ? '' : w}
              onChange={(e) => setW(e.target.value)}
              placeholder="가로"
              className="h-[50px] w-[140px] border border-[#CACACA] bg-white px-3 text-[14px] text-[#424242] outline-none placeholder:text-[#CACACA] focus:border-[#553886]"
            />
            <span className="text-[14px] text-[#424242]">X</span>
            <input
              type="text"
              inputMode="numeric"
              aria-label={spec?.axis2?.label ?? '세로'}
              value={h === 0 ? '' : h}
              onChange={(e) => setH(e.target.value)}
              placeholder={spec?.axis2?.label ?? '세로'}
              className="h-[50px] w-[140px] border border-[#CACACA] bg-white px-3 text-[14px] text-[#424242] outline-none placeholder:text-[#CACACA] focus:border-[#553886]"
            />
            <span className="text-[14px] text-[#979797]">mm</span>
          </div>
          {spec?.helpText && (
            <p className="mt-1 text-[11px] text-[#979797]">{spec.helpText}</p>
          )}
        </div>
      )}
    </div>
  );
}
