// data-contract.md §5 — 에디터 계약 (Edicus).
import type { SideKey } from './product';

export interface NormalizedEditorConfig {
  side: SideKey;
  psCode: string; // "{edicusPsCode}@{productCode}" (불투명)
  templateUrl: string; // gcs://...
  resourceId: number;
  token: string; // JWT (BFF/어댑터 발급, 위젯은 보관 안 함 — 즉시 SDK 전달)
  pluginCustomData?: Record<string, unknown>; // {mtrlCode} 등 — 불투명 전달
}

export interface NormalizedEditorResult {
  // from-edicus:goto-cart 정규화
  side: SideKey;
  projectId: string; // Edicus Firebase pushID
  thumbnailUrls: string[]; // tnUrlList
  totalPageCount: number;
}
