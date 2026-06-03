// PdfUploader — api-contract #3·4 + s3-upload-flow. presigned → S3 직접 PUT → file-meta.
// 면별 uploadType='pdf' 인 면(책자 내지 등)에 렌더. application/pdf 검증.
// DESIGN: 직사각 영역, Noto Sans, 선택/완료 상태는 흰배경+보라테두리.
import { useRef } from 'react';
import type { SideKey } from '@/contract';
import { useSideInput } from '../stores/context';
import { cn } from './primitives/cn';

export function PdfUploader({ side, label }: { side: SideKey; label: string }) {
  const { artifact, uploading, uploadPdf } = useSideInput(side);
  const inputRef = useRef<HTMLInputElement>(null);
  const done = artifact?.kind === 'pdf' && !!artifact.storedFileName;

  const pick = () => inputRef.current?.click();
  const onFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) void uploadPdf(file);
    // 같은 파일 재선택 허용을 위해 input 초기화.
    e.target.value = '';
  };

  return (
    <div className="flex flex-col gap-2">
      {/* 숨김 native input(파일 선택기만 사용). 표시 UI 는 커스텀 버튼. */}
      <input
        ref={inputRef}
        type="file"
        accept="application/pdf"
        className="hidden"
        onChange={onFile}
        aria-label={`${label} PDF 업로드`}
      />
      <button
        type="button"
        onClick={pick}
        disabled={uploading}
        className={cn(
          'flex h-[50px] items-center justify-center rounded-[4px] bg-white px-4 text-[14px] transition-colors',
          done
            ? 'border-2 border-[#553886] text-[#553886]'
            : 'border border-[#CACACA] text-[#424242] hover:border-[#553886]',
          uploading && 'cursor-progress opacity-60',
        )}
        style={{ maxWidth: '100%' }}
      >
        {uploading
          ? '업로드 중…'
          : done
            ? `${artifact?.originalFileName ?? 'PDF'} (변경)`
            : `${label} PDF 파일 업로드`}
      </button>
      {done && artifact?.totalPageCount != null && (
        <p className="text-[11px] text-[#979797]">{artifact.totalPageCount}페이지 업로드 완료</p>
      )}
    </div>
  );
}
