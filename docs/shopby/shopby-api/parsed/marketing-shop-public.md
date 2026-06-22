# marketing-shop

**버전**: 1.0
**서버**: https://shop-api.e-ncp.com

마케팅(marketing) 관련 shop API입니다.

---

## Marketing

### GET /marketing/sns-share

**요약**: SNS 공유 설정 조회하기

**설명**:

## 부가설명 및 특이사항

SNS 공유 설정 조회하는 API 입니다

**파라미터**:

| 이름      | 위치   | 타입   | 필수 | 설명                                        |
| --------- | ------ | ------ | ---- | ------------------------------------------- |
| productNo | query  | number | ✅   | 상품 번호                                   |
| Version   | header | string | ✅   | API 버전                                    |
| clientId  | header | string | ✅   | 쇼핑몰 클라이언트 아이디                    |
| platform  | header | string | ✅   | 클라이언트 플랫폼(PC, MOBILE_WEB, AOS, IOS) |

**응답**:

- **200**: 200

---
