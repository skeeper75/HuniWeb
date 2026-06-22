# workspace-shop

**버전**: 1.0
**서버**: https://shop-api.e-ncp.com

워크스페이스 (https://workspace.nhn-commerce.com) 관련 shop API 입니다.

---

## ExternalScript

### GET /external-scripts

**요약**: 외부스크립트 조회하기

**설명**:

## 부가설명 및 특이사항

외부스크립트 조회

몰에서 사용중인 외부 스크립트 리스트를 불러옵니다.

**파라미터**:

| 이름     | 위치   | 타입   | 필수 | 설명                                          |
| -------- | ------ | ------ | ---- | --------------------------------------------- | -------------- |
| Version  | header | string | ✅   | API 버전^                                     | 1.0            |
| clientId | header | string | ✅   | 쇼핑몰 클라이언트 아이디^                     | test-client-id |
| platform | header | string | ✅   | 클라이언트 플랫폼 (PC, MOBILE_WEB, IOS, AOS)^ | PC             |

**응답**:

- **200**: 200

---
