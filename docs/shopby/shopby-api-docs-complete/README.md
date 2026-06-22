# NHN Commerce (Shopby) API Documentation — Complete

> OpenAPI 3.0 YAML → MDX 자동 변환 문서  
> 원본: https://docs.shopby.co.kr/ / https://server-docs.shopby.co.kr/

## 디렉토리 구조

```
shopby-api-docs/
├── 01_shop-api/       # Shop API     — 쇼핑몰 프런트 화면 제작용     (12개)
├── 02_admin-api/      # Admin API    — 관리자 백오피스용              (25개)
├── 03_internal-api/   # Internal API — 서버 내부 / 미들웨어용        (31개)
└── 04_server-api/     # Server API   — 서버 간 통신 (B2B / 파트너)  (12개)
```

## 이미지 처리 방식

| 항목 | 내용 |
|------|------|
| 방식 | 외부 URL 직접 참조 |
| 이미지 서버 | `https://image.toast.com` (NHN Toast Object Storage) |
| 접근 가능 여부 | ✅ HTTPS 200 OK 확인 |
| URL 정규화 | `http://` → `https://` 일괄 변환 적용 |

## MDX 프론트매터

```yaml
---
title: "파일명"
description: "API 설명 첫 줄"
version: "버전"
category: "Shop API | Admin API | Internal API | Server API"
---
```

## 변환 통계

| 카테고리 | 파일 수 |
|----------|---------|
| Shop API | 12개 |
| Admin API | 25개 |
| Internal API | 31개 |
| Server API | 12개 |
| **합계** | **80개** |

- 변환 일시: 2026. 2. 21. 오후 2:28:56
- 실패: 0개
