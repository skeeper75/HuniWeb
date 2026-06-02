/// <reference types="vite/client" />

declare module '*.css?inline' {
  const content: string;
  export default content;
}

// Edicus 연동 env (값은 .env.local — 하드코딩·커밋 금지, 운영 폴백만 코드에).
interface ImportMetaEnv {
  readonly VITE_EDICUS_EDITOR_HOST?: string; // 에디터 iframe 호스트
  readonly VITE_EDICUS_BASE_HOST?: string; // origin allowlist 운영 origin
}
interface ImportMeta {
  readonly env: ImportMetaEnv;
}
