// data-contract.md §4 — 업로드 계약 (presigned).
import type { SideKey } from './product';

export interface NormalizedPresignedRequest {
  fileName: string;
  productCode: string;
  contentType: string; // "application/pdf"
  side: SideKey;
}

export interface NormalizedPresigned {
  uploadUrl: string; // presigned PUT URL (60분 만료 — 발급 직전 호출)
  storedFileName: string; // 서버생성 UUID
  expiresInSec: number;
}

export interface NormalizedUploadResult {
  side: SideKey;
  storedFileName: string;
  originalFileName: string;
  pageCount?: number;
  sizeBytes?: number;
}
