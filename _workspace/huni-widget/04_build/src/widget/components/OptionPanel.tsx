// component-tree §1 — OptionPanel: optionGroups.filter(visible).map() (RULE-5 동적, Zone 하드코딩 금지).
// 책자: 표지(default)/내지(inner) side 섹션 분리.
import type { ProductSide, SideKey } from '@/contract';
import { useProduct, useEditorSession, useSideInput } from '../stores/context';
import { OptionControl } from './controls/OptionControl';
import { PriceSummary } from './PriceSummary';
import { OrderCTA } from './OrderCTA';
import { PdfUploader } from './PdfUploader';
import { EditorOverlay } from '../editor/EditorOverlay';
import { cn } from './primitives/cn';
import type { NormalizedCartHandoff } from '@/contract';

// 면별 입력 수단(editor/pdf) — runtime §3. 표지=editor, 내지=pdf 분기.
function SideInput({ sideDef }: { sideDef: ProductSide }) {
  const { openEditor } = useEditorSession();
  const { artifact } = useSideInput(sideDef.key);
  if (sideDef.uploadType === 'pdf') {
    return <PdfUploader side={sideDef.key} label={sideDef.label} />;
  }
  // editor 면 — "편집하기" 버튼(완료 시 보라 강조).
  const done = artifact?.kind === 'editor' && !!artifact.projectId;
  return (
    <button
      type="button"
      onClick={() => void openEditor(sideDef.key)}
      className={cn(
        'flex h-[50px] items-center justify-center rounded-[4px] bg-white px-4 text-[14px] transition-colors',
        done
          ? 'border-2 border-[#553886] text-[#553886]'
          : 'border border-[#CACACA] text-[#424242] hover:border-[#553886]',
      )}
      style={{ maxWidth: '100%' }}
    >
      {done ? `${sideDef.label} 편집 완료 (다시 편집)` : `${sideDef.label} 편집하기`}
    </button>
  );
}

function SideSection({ sideDef }: { sideDef: ProductSide }) {
  const product = useProduct();
  if (!product) return null;
  const side: SideKey = sideDef.key;
  // visible=false 는 hidden essential(자동적용) → UI 미렌더.
  const groups = product.optionGroups.filter((g) => g.side === side && g.visible);
  const multiSide = product.sides.length > 1;
  if (groups.length === 0) return null;
  return (
    <section className="flex flex-col gap-5">
      {multiSide && <h2 className="text-[16px] font-semibold text-[#424242]">{sideDef.label}</h2>}
      {groups.map((g) => (
        <div key={g.id} className="flex flex-col gap-2">
          <label className="text-[16px] font-medium text-[#424242]">{g.label}</label>
          <OptionControl group={g} />
        </div>
      ))}
      {/* 면별 입력(편집/PDF) — 옵션 아래 배치. */}
      <div className="flex flex-col gap-2">
        <label className="text-[16px] font-medium text-[#424242]">{sideDef.label} 작업</label>
        <SideInput sideDef={sideDef} />
      </div>
    </section>
  );
}

export function OptionPanel({
  onCartHandoff,
}: {
  onCartHandoff?: (p: NormalizedCartHandoff) => void;
}) {
  const product = useProduct();
  if (!product) return null;

  return (
    <div className="flex flex-col gap-8 bg-white p-6 text-[#424242]">
      {product.sides.map((s) => (
        <SideSection key={s.key} sideDef={s} />
      ))}
      <div className="border-t border-[#CACACA] pt-6">
        <PriceSummary />
      </div>
      <OrderCTA onCartHandoff={onCartHandoff} />
      {/* Edicus 편집기 오버레이 — editorConfig 가 있을 때만 Shadow 내부에 포털 렌더. */}
      <EditorOverlay />
    </div>
  );
}
