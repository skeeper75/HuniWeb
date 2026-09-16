> For the complete documentation index, see [llms.txt](https://workspace-help.nhn-commerce.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://workspace-help.nhn-commerce.com/contents/recommended/prm_mileage_guide.md).

# \[엔터프라이즈] 외부 적립금 연동가이드

## 외부 적립금이란? <a href="#ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-9d-b4-eb-9e-80-3f" id="ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-9d-b4-eb-9e-80-3f"></a>

#### 샵바이에 입점하고자하는 고객사에서 별도의 적립금(마일리지) 혜택을 이미 가지고 있는 경우, <a href="#ec-83-b5-eb-b0-94-ec-9d-b4-ec-97-90-ec-9e-85-ec-a0-90-ed-95-98-ea-b3-a0-ec-9e-90-ed-95-98-eb-8a-94-e" id="ec-83-b5-eb-b0-94-ec-9d-b4-ec-97-90-ec-9e-85-ec-a0-90-ed-95-98-ea-b3-a0-ec-9e-90-ed-95-98-eb-8a-94-e"></a>

고객사에서 진행할 수 있는 2가지 외부 적립금 호환 방식이 있습니다.

<br>

### (방법1) 외부 적립금 전환 <a href="#eb-b0-a9-eb-b2-951-ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-84-ed-99-98" id="eb-b0-a9-eb-b2-951-ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-84-ed-99-98"></a>

#### 개념 <a href="#ea-b0-9c-eb-85-90" id="ea-b0-9c-eb-85-90"></a>

고객사 시스템의 적립금을 샵바이 시스템의 적립금으로 '전환'하여, 샵바이 내부 프로세스에 따라 쇼핑몰 고객의 적립금을 지급/차감/조회할 수 있는 개념입니다.\ <br>

#### 상세설명 <a href="#ec-83-81-ec-84-b8-ec-84-a4-eb-aa-85" id="ec-83-81-ec-84-b8-ec-84-a4-eb-aa-85"></a>

샵바이에서는 이와 관련된 server API를 제공하고 있으며, 해당 API의 호출 주체는 고객사입니다.\
쇼핑몰 고객들이 기존의 적립금을 샵바이의 적립금으로 전환할 수 있는 프론트 구현이 필요합니다.\
자세한 API 내용은 [외부 적립금 전환 가이드](https://workspace.nhn-commerce.com/support/recommendedContents/23047)를 참고하시길 바랍니다.<br>

***

### (방법2) 외부 적립금 연동 <a href="#eb-b0-a9-eb-b2-952-ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-97-b0-eb-8f-99" id="eb-b0-a9-eb-b2-952-ec-99-b8-eb-b6-80-ec-a0-81-eb-a6-bd-ea-b8-88-ec-97-b0-eb-8f-99"></a>

본 문서에서 아래 소개 드릴 방식입니다.<br>

#### 개념 <a href="#ea-b0-9c-eb-85-90" id="ea-b0-9c-eb-85-90"></a>

고객사에서 기존에 사용하던 적립금(마일리지)를 전환 절차 없이 그대로 사용할 수 있고, 샵바이에서 고객사의 외부적립금을 연동하는 개념입니다.

#### 상세설명 <a href="#ec-83-81-ec-84-b8-ec-84-a4-eb-aa-85" id="ec-83-81-ec-84-b8-ec-84-a4-eb-aa-85"></a>

고객사에서 아래에서 안내드릴 스펙에 따라 API를 개발하여 저희 측으로 uri 등을 전달주시면, 해당 API의 호출 주체는 저희 샵바이입니다.\
(ex) 적립금 조회 시, 샵바이에서 고객사에서 개발한 API를 호출하여 고객사의 DB를 조회합니다.\ <br>

#### 주의사항 <a href="#ec-a3-bc-ec-9d-98-ec-82-ac-ed-95-a-d" id="ec-a3-bc-ec-9d-98-ec-82-ac-ed-95-a-d"></a>

※ 단, 샵바이에서 API 호출 시, 고객사 서버에서 바로 응답되지 않는 성능 이슈가 발생하지 않도록 신경 써주시길 바랍니다.\
※ 적립금이 중복으로 지급될 수 있는 케이스에 대해 확인하시길 바랍니다. (아래 적립금 지급API '제약조건' 문단 확인)\ <br>

#### 연동 프로세스 <a href="#ec-97-b0-eb-8f-99-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a4" id="ec-97-b0-eb-8f-99-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a4"></a>

* step 1. 아래 안내드릴 API 스펙에 따라 고객사에서 API 개발
* step 2. \[NHN커머스> 고객센터> 1:1문의]를 통해 아래 정보들을 세팅요청 해주시길 바랍니다.  [1:1문의 바로가기>](https://support.nhn-commerce.com/inquiry/list)<br>

| 항목                                 | 샘플 (예시)                                           | 설명                                                     |
| ---------------------------------- | ------------------------------------------------- | ------------------------------------------------------ |
| domain                             | [https://sample-dev.com](https://sample-dev.com/) | 외부 개발사는 개발된 도메인 https 으로 제공해야 함                        |
| 1. 적립금 지급 uri                      | /accumulations/add                                | 필수                                                     |
| 2. 적립금 차감 uri                      | /accumulations/subtract                           | 필수                                                     |
| 3. 적립금 차감 롤백 uri                   | /accumulations/subtract-rollback                  | 필수                                                     |
| 4. 사용가능 적립금 조회 uri                 | /accumulations/available-amounts                  | 필수                                                     |
| 5. 적립금 내역 조회 uri                   | /accumulations                                    | (선택)                                                   |
| 필요한 header 값                       | token : 'abc'                                     | 샵바이 -> 외부 개발사 요청 시, 인증을 위해서 필요한 http request header의 값 |
| <p>(추가)</p><p>memberMappingKey</p> | MEMBER\_ID(default), MEMBER\_NO, CI               | 맴버 맵핑 키                                                |

* step 3. 아래 NHN커머스 샵바이 ACL 추가바랍니다.
  * 리얼 환경: 103.194.111.5, 115.89.203.145
* 2024-08-26 memberMappingKey 항목 추가되었습니다.<br>
* 샘플(예시)

```json
{
    "url": "https://sample-dev.com",
    "headers": {
        "Content-Type": "application/json"
    },
    "memberMappingKey": "MEMBER_NO",
    "externalAccumulationUriGroup": {
        "addUri": "/accumulations/add",
        "searchUri": "/accumulations",
        "subtractUri": "/accumulations/subtract",
        "subtractRollbackUri": "/accumulations/subtract-rollback",
        "getAvailableAmountUri": "/accumulations/available-amounts"
    }
}
```

***

## 적립금 적립/차감/롤백 다이어그램 <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-81-eb-a6-bd-2f-ec-b0-a8-ea-b0-90-2f-eb-a1-a4-eb-b0-b1-eb-8b-a4-ec-9" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-81-eb-a6-bd-2f-ec-b0-a8-ea-b0-90-2f-eb-a1-a4-eb-b0-b1-eb-8b-a4-ec-9"></a>

### 적립금 적립 프로세스 <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-81-eb-a6-bd-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a4" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-a0-81-eb-a6-bd-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a4"></a>

<figure><img src="https://67612295-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FLt0GowPleXLWRjzGIAiV%2Fuploads%2FqZaF6SMswa3OPcH5djoO%2Fimage.png?alt=media&amp;token=56fe7cb5-c529-4084-bd77-a67114146851" alt=""><figcaption></figcaption></figure>

***

### 적립금 차감/ 롤백 프로세스 <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-2f-eb-a1-a4-eb-b0-b1-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-2f-eb-a1-a4-eb-b0-b1-ed-94-84-eb-a1-9c-ec-84-b8-ec-8a-a"></a>

<figure><img src="https://67612295-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FLt0GowPleXLWRjzGIAiV%2Fuploads%2FTjuqLLLtFUEtTLhpYh0i%2Fimage.png?alt=media&amp;token=ce6bb16c-65bd-468c-8f03-d497ae543d40" alt=""><figcaption></figcaption></figure>

***

## 1. 적립금 지급 (필수) <a href="#id-1.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a7-80-ea-b8-89-ed-95-84-ec-88-98" id="id-1.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a7-80-ea-b8-89-ed-95-84-ec-88-98"></a>

### 적립금 지급 API (개발 스펙 안내) <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-a7-80-ea-b8-89-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e-99-ec-95-88-eb-82" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-a7-80-ea-b8-89-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e-99-ec-95-88-eb-82"></a>

{% hint style="info" %}

* request 는 request body 로 전달
* 형태는 json
  {% endhint %}

#### ■ method <a href="#e2-96-a0-method" id="e2-96-a0-method"></a>

* POST

#### ■ request    <a href="#e2-96-a0-request" id="e2-96-a0-request"></a>

<table><thead><tr><th>attribute</th><th>name</th><th width="76.3685302734375">required</th><th>description</th><th>type</th></tr></thead><tbody><tr><td>memberKey</td><td>회원 연계 키</td><td>필수</td><td><p>연동시 사용한 유형의 값<br></p><p>(MEMBER_ID,MEMBER_NO,CI)</p></td><td>String</td></tr><tr><td>amount</td><td>적립금액</td><td>필수</td><td>적립금</td><td>Long</td></tr><tr><td>reason</td><td>적립 세부내역 사유</td><td>필수</td><td></td><td>String</td></tr><tr><td>reasonType</td><td>적립금 지급 사유</td><td>필수</td><td>enum 형식</td><td>String</td></tr><tr><td>expiredDateTime</td><td>적립금 만료일</td><td>필수</td><td></td><td>LocalDateTime : 'yyyy-MM-dd HH:mm:ss'</td></tr><tr><td>mappingKey</td><td>적립키</td><td>필수</td><td><p>롤백용으로 <br>사용하는 값</p><p></p><p>주문번호, 리뷰번호, 주문옵션 번호 또는 "0" 으로 전달</p></td><td>String</td></tr><tr><td>(추가) additionalMappingKey.orderNo<br></td><td>추가정보<br>(연관 주문번호)</td><td>선택</td><td>추가 연동키</td><td>Int(nullable)</td></tr><tr><td>(추가) additionalMappingKey.reviewNo<br></td><td>추가정보<br>(연관 상품리뷰번호)</td><td>선택</td><td>추가 연동키</td><td>Int(nullable)</td></tr><tr><td>(추가) additionalMappingKey.orderOptionNo</td><td>추가정보<br>(연관 주문옵션번호)</td><td>선택</td><td>추가 연동키 </td><td>Int(nullable)</td></tr><tr><td>requestId</td><td>멱등성 키</td><td>필수</td><td>동일한 값으로 재요청 시, 중복 처리하지 않고 정상 응답 변환 필요. </td><td>String</td></tr></tbody></table>

* 2023-07-24 reasonType 항목 추가되었습니다.&#x20;
* 2024-01-24 additionalMappingKey.orderNo, additionalMappingKey.reviewNo,additionalMappingKey.orderOptionNo 항목 추가됩니다. (2/20 배포완료)
* 2026-07-01 requestId 항목이 추가되었습니다.

#### ※ reasonType 코드 값 설명 <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

* 적립 - 적립 - 상품 주문 적립 (구매확정)\
  ADD\_AFTER\_PAYMENT
* 적립 - 적립 - 교환/추가결제 적립 (교환대상 가격 > 원주문 상품가격)\
  ADD\_AFTER\_REPLACE\_PAYMENT
* 적립 - 사이트 활동 적립 - 상품평 작성 완료\
  ADD\_POSTING
* 적립 - 수동적립\
  ADD\_MANUAL
* 적립 - 회원가입시 자동 적립\
  ADD\_SIGNUP
* 적립 - 생일축하 적립\
  ADD\_BIRTHDAY
* 적립 - 회원등급 적립\
  ADD\_GRADE
* 적립 - 등급 혜택 즉시 지급\
  ADD\_GRADE\_BENEFIT

***

#### ■ response <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

#### 성공인 경우 <a href="#ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

| attribute | name   | required | description | type   |
| --------- | ------ | -------- | ----------- | ------ |
| no        | 지급 key | 필수       | 적립 연계키      | String |

#### 실패인 경우 <a href="#ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

* http code 400 으로 전달
* 보통의 경우 errorMessage로 전달된 실패사유를 사용자에게 노출하거나 로그로 남깁니다.
* 아래와 같은 형태의 response body 로 에러 코드와 메시지를 전달

```json
{
"errorCode" : "실패코드",
"errorMessage" : "실패사유"
}
```

### 제약조건 <a href="#ec-a0-9c-ec-95-bd-ec-a1-b0-ea-b1-b4" id="ec-a0-9c-ec-95-bd-ec-a1-b0-ea-b1-b4"></a>

※ `생일자 적립금 지급`, `등급 적립금 지급` 정기 지급 시, 일 배치(daily batch)로 적립금을 지급합니다.\
단, 해당 정기지급은 `mappingKey`가 0으로 등록되어 있어 외부적립금 사용 시 중복 지급될 수 있습니다.

만약 '[적립금 전환 방식](https://shopby.works/support/recommendedContents/23047)'으로 NHN커머스 샵바이의 적립금을 사용할 경우,  적립금 지급 번호와 사유를 내부 코드로 관리하여 중복지급을 제외할 수 있으나\
본 문서에서 안내드리는 '외부 적립금 연동 방식' 을 사용할 경우, 지급코드를 별도로 관리하지 않기 때문에 중복 지급 될 수 있습니다.

(예시) 중복지급 될 수 있는 케이스\
&#x20;: \[고객이 1/1을 생일로 등록]-> \[1/1 일 배치를 통해 생일 적립금 지급]-> \[1/2에 고객이 생일을 1/3으로 변경]-> \[1/3 일 배치에서 생일 적립금 중복 지급]\ <br>

### 참고사항 <a href="#ec-b0-b8-ea-b3-a0-ec-82-ac-ed-95-a-d" id="ec-b0-b8-ea-b3-a0-ec-82-ac-ed-95-a-d"></a>

`적립금 차감 API` 및 `적립금 차감 롤백 API`는 존재하나,\
`적립금 적립 API`에 대한 `적립금 적립 롤백 API` 는 제공하지 않는 점 참고부탁드립니다.

따라서 이미 적립된 적립금을 차감하기 위해서는, 아래 문서에서 소개 드릴 `적립금 차감 API`를 개발하시길 바랍니다.

***

## 2. 적립금 차감 (필수) <a href="#id-2.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-ed-95-84-ec-88-98" id="id-2.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-ed-95-84-ec-88-98"></a>

### 적립금 차감 API (개발 스펙 안내) <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e-99-ec-95-88-eb-82" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e-99-ec-95-88-eb-82"></a>

{% hint style="info" %}

* request 는 request body 로 전달
* 형태는 json
  {% endhint %}

#### ■ method <a href="#e2-96-a0-method" id="e2-96-a0-method"></a>

* POST

#### ■ request <a href="#e2-96-a0-request" id="e2-96-a0-request"></a>

| attribute                          | name                       | required | description                                                       | type             |
| ---------------------------------- | -------------------------- | -------- | ----------------------------------------------------------------- | ---------------- |
| memberKey                          | 회원 연계 키                    | 필수       | <p>연동시 사용한 유형의 값<br></p><p>(MEMBER\_ID,MEMBER\_NO,CI)</p>         | String           |
| amount                             | 차감금액                       | 필수       | 적립금                                                               | Long ( 양수 )      |
| reason                             | 차감 사유                      | 필수       |                                                                   | String           |
| <p>reasonType<br></p>              | 직립금 차감 사유                  | 필수       | <p>enum 형식<br></p>                                                | String           |
| mappingKey                         | 차감키                        | 필수       | <p>롤백용으로 사용하는 값</p><p></p><p>주문번호, 리뷰번호, 주문옵션 번호 또는 "0" 으로 전달</p> | String           |
| additionalMappingKey.orderNo       | <p>추가정보<br>(연관 주문번호)</p>   | 선택       | 롤백용\*                                                             | Int(nullable)    |
| additionalMappingKey.reviewNo      | <p>추가정보<br>(연관 상품리뷰번호)</p> | 선택       | 롤백용\*                                                             | Int(nullable)    |
| additionalMappingKey.orderOptionNo | <p>추가정보<br>(연관 주문옵션번호)</p> | 선택       | 롤백용\*                                                             | Int(nullable)    |
| (추가) orderExtraData                | 주문추가정보(JsonString)         | 선택       | 주문 예약단계에서 shop api(url링크)에서 입력한 ExtraData를 그대로 바이패스               | String(nullable) |
| requestId                          | 멱등성 키                      | 필수       | 동일한 값으로 재요청 시, 중복 처리하지 않고 정상 응답 변환 필요                             | String           |

* 참고사항 (\*)\
  구매확정 후 반품 시, 이미 지급된 적립금 정보 확인을 위해 `적립금 차감 API`의 request 항목이 위와 같이 추가되었습니다.\
  외부적립금 연동 방식을 사용 중인 고객사의 경우, 새로 추가된 데이터에 대응 가능한 구조로 변경하시길 바랍니다.
* 2023-08-10 reasonType 항목 업데이트 되었습니다.&#x20;
* 2024-02-20 request > orderExtraData 항목이 신규 추가됩니다.&#x20;
* 2026-07-01 requestId 항목이 추가되었습니다.

#### ※ reasonType 코드 값 설명 <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

* 차감 - 사용 - 상품 주문 시 적립금 사용 (결제완료)\
  SUB\_PAYMENT\_USED
* 차감 - 사용 - 교환상품 추가 결제 시 적립금 사용 (추가결제 완료)\
  SUB\_EXTRA\_PAYMENT\_USED
* 차감 - 적립취소 - 상품평 삭제\
  SUB\_DELETE\_POSTING
* 차감 - 수동차감\
  SUB\_MANUAL\
  \ <br>
* 샘플 (예시)

{% code overflow="wrap" %}

```json
{
  "amount": 100,
  "reason": "테스트 차감",
  "memberKey": "test@abc.com",
  "mappingKey": "2022080117000000001",
  "additionalMappingKey": {
    "orderNo": "2022080117000000001",
    "reviewNo": "3",
    "orderOptionNo": "2"
  },
  "requestId": "subtract-test@abc.com-ORDER-202607021100123456"
}
```

{% endcode %}

#### ■ response <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

성공인 경우

| attribute | name         | required | description | type   |
| --------- | ------------ | -------- | ----------- | ------ |
| no        | 차감롤백을 위한 key | 필수       | 연계키         | String |

***

## 3. 적립금 차감 롤백 (필수) <a href="#id-3.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-ec-84-a0-ed-83-9d" id="id-3.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-ec-84-a0-ed-83-9d"></a>

### 적립금 차감 롤백 API (개발 스펙 안내) <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e" id="ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e"></a>

{% hint style="info" %}

* request 는 request body 로 전달
* 형태는 json
* 불가능한 경우 적립으로 처리 ( <mark style="background-color:red;">※ 이 경우 적립금 유효기간은 유지되지 않음</mark> )
  {% endhint %}

#### ■ method <a href="#e2-96-a0-method" id="e2-96-a0-method"></a>

* POST

#### ■ request <a href="#e2-96-a0-request" id="e2-96-a0-request"></a>

| attribute     | name                                    | required | description                                                   | type          |
| ------------- | --------------------------------------- | -------- | ------------------------------------------------------------- | ------------- |
| no            | 차감 롤백을 위한 key                           | 필수       | <p>차감 시, 받은 response.no 값<br>전달<br></p><p>없는경우<br>주문번호 전달</p> | String        |
| mappingKey    | 차감롤백을 위한 mapping key                    | 필수       | <p>취소된 <br>주문번호 전달</p>                                        | String        |
| amount        | <p>취소금액  <br>(롤백금액)</p>                 | 필수       |                                                               | Int           |
| reason        | 롤백 사유                                   | 필수       |                                                               | String        |
| lastSubPayAmt | 남은 적립금                                  | 선택       | <p>부분 취소 시, <br>남은 적립금액</p>                                   | Int(nullable) |
| memberKey     | 연동시 사용한 유형의 값(MEMBER\_ID,MEMBER\_NO,CI) |          |                                                               | String        |
| requestId     | 멱등성 키                                   | 필수       | 동일한 값으로 재요청 시, 중복 처리하지 않고 정상 응답 변환 필요                         | String        |

* 2024-08-26 lastSubPayAmt 항목이 추가되었습니다.
* 2026-07-01 requestId 항목이 추가되었습니다.

{% hint style="success" %} <mark style="color:red;">**롤백 케이스 별 amount, lastSubPayAmt 예시**</mark>

* **case1. 전체 취소 시**
  * amount: 1,000
  * lastSubPayAmt: 1,000
* **case2. 100 point 부분 취소 시**
  * amount: 100
  * lastSubPayAmt: 1,000
    {% endhint %}

#### ■ response <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

#### 성공인 경우 <a href="#ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

* http code 200

#### 실패인 경우 <a href="#ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

* http code 400
* 아래와 같은 형태의 response body 로 에러 코드와 메시지를 전달

{% code overflow="wrap" %}

```json
{
"errorCode" : "실패코드",
"errorMessage" : "실패사유"
}

```

{% endcode %}

***

## 4. 사용가능 적립금 조회 (필수) <a href="#id-3.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-ec-84-a0-ed-83-9d" id="id-3.-ec-a0-81-eb-a6-bd-ea-b8-88-ec-b0-a8-ea-b0-90-eb-a1-a4-eb-b0-b1-ec-84-a0-ed-83-9d"></a>

### 사용가능 적립금 조회 API (개발 스펙 안내) <a href="#ec-82-ac-ec-9a-a9-ea-b0-80-eb-8a-a5-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a1-b0-ed-9a-8c-api-ea-b0-9c-eb-b0" id="ec-82-ac-ec-9a-a9-ea-b0-80-eb-8a-a5-ec-a0-81-eb-a6-bd-ea-b8-88-ec-a1-b0-ed-9a-8c-api-ea-b0-9c-eb-b0"></a>

{% hint style="info" %}

* request 는 request param으로 전달
* response 형태는 json
  {% endhint %}

#### ■ method <a href="#e2-96-a0-method" id="e2-96-a0-method"></a>

* GET

#### ■ request (parameter) <a href="#e2-96-a0-request" id="e2-96-a0-request"></a>

| attribute       | name                           | required | description                                               | type                                          |
| --------------- | ------------------------------ | -------- | --------------------------------------------------------- | --------------------------------------------- |
| memberKey       | 회원 연계 키                        | 필수       | <p>연동시 사용한 유형의 값<br></p><p>(MEMBER\_ID,MEMBER\_NO,CI)</p> | String                                        |
| expireStartYmdt | 만료조회 시작일(디폴트 : 오늘 - 30일)       | 선택       |                                                           | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |
| expireEndYmdt   | <p>만료조회 종료일 <br>(디폴트 : 오늘)</p> | 선택       |                                                           | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |

#### ■ response <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

#### 성공인 경우 <a href="#ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

| attribute     | name         | required | description                                                                                                        | type           |
| ------------- | ------------ | -------- | ------------------------------------------------------------------------------------------------------------------ | -------------- |
| amount        | 사용 가능한 총 적립금 | 필수       |                                                                                                                    | Long           |
| expiresAmount | 만료예정 적립금     | 선택       | <p>조회기간(expireStartYmdt \~ expireEndYmdt) <br>동안 만료될 금액<br><br>(만료일이 expireStartYmdt보다 크고, expireEndYmdt보다 작음)</p> | Long(nullable) |

#### 실패인 경우 <a href="#ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

* http code 400
* 아래와 같은 형태의 response body 로 에러 코드와 메시지를 전달

```json
{
"errorCode" : "실패코드",
"errorMessage" : "실패사유"
}
```

***

## 5. 적립금 내역 조회 (선택) <a href="#id-5.-ec-a0-81-eb-a6-bd-ea-b8-88-eb-82-b4-ec-97-a-d-ec-a1-b0-ed-9a-8c-ec-84-a0-ed-83-9d" id="id-5.-ec-a0-81-eb-a6-bd-ea-b8-88-eb-82-b4-ec-97-a-d-ec-a1-b0-ed-9a-8c-ec-84-a0-ed-83-9d"></a>

### 적립금 내역 조회 API (개발 스펙 안내) <a href="#ec-a0-81-eb-a6-bd-ea-b8-88-eb-82-b4-ec-97-a-d-ec-a1-b0-ed-9a-8c-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e" id="ec-a0-81-eb-a6-bd-ea-b8-88-eb-82-b4-ec-97-a-d-ec-a1-b0-ed-9a-8c-api-ea-b0-9c-eb-b0-9c-ec-8a-a4-ed-8e"></a>

{% hint style="info" %}

* request 는 request param으로 전달
* response 형태는 json
  {% endhint %}

#### ■ method <a href="#e2-96-a0-method" id="e2-96-a0-method"></a>

* GET

#### ■ request (parameter) <a href="#e2-96-a0-request" id="e2-96-a0-request"></a>

| attribute     | name         | required | description                                                    | type                                          |
| ------------- | ------------ | -------- | -------------------------------------------------------------- | --------------------------------------------- |
| startDateTime | 검색 시작일       | 필수       |                                                                | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |
| endDateTime   | 검색 종료일       | 필수       |                                                                | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |
| searchType    | 검색 유형        | 필수       | 지급일 기준(REGISTERED),만료일 기준(EXPIRED)                             |                                               |
| type          | 검색 조건(지급/차감) | 선택       | <p>전체("null") - default, <br>지급("ADD"), <br>차감("SUBTRACT")</p> | String                                        |
| memberKey     | 회원 연계 키      | 선택       | null 이면 전체                                                     | String(nullable)                              |
| page          | 페이지 번호       | 필수       | 조회할 페이징 번호 (default 0)                                         |                                               |
| size          | 페이지 사이즈      | 필수       | <p>페이지당 조회할 content 개수 <br>( default 100 )</p>                 |                                               |

#### ■ response <a href="#e2-96-a0-response" id="e2-96-a0-response"></a>

#### 성공인 경우 <a href="#ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-84-b1-ea-b3-b5-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

| attribute-level1 | attribute-level2 | name                           | required | description                  | type                                          |
| ---------------- | ---------------- | ------------------------------ | -------- | ---------------------------- | --------------------------------------------- |
| totalCount       | -                | <p>전체 데이터<br>건수</p>            | 선택       |                              | Int                                           |
| contents         | no               | 적립금 번호                         | 필수       | PK                           | Int                                           |
| contents         | memberKey        | 회원 연계 키                        | 필수       | 연계키                          | String                                        |
| contents         | type             | <p>지급/차감/<br>지급롤백/<br>차감롤백</p> | 필수       | 적립금                          | String                                        |
| contents         | amount           | 적립금액                           | 필수       | 적립금                          | Long                                          |
| contents         | reason           | 사유                             | 필수       |                              | String                                        |
| contents         | registerDateTime | 등록일                            | 필수       |                              | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |
| contents         | expiredDateTime  | 적립금만료일                         | 필수       |                              | LocalDateTime(format : 'yyyy-MM-dd HH:mm:ss') |
| contents         | mappingKey       | 적립키                            | 필수       | 롤백용                          | String(nullable)                              |
| contents         | totalAmount      | 적립/차감시점 잔여 적립금                 | 선택       |                              | Long(nullable)                                |
| contents         | extraData        | 추가 정보                          | 선택       | json 형태로 front에 추가적으로 노출할 정보 | Map\<String,Object> (nullable)                |

* 샘플(예시)

{% code overflow="wrap" %}

```json
{
  "totalCount" : 15,
  "contents" : [
     {
       "no" : "1",
        "memberKey" : "abc",
        "type" : "지급",
        "amount" : 100,
        "reason" : "상품평 작성 적립",
        "registerDateTime" : "2021-01-01 13:12:30",
        "expiredDateTime" : "2022-01-01 13:12:30",
        "mappingKey" : "20210501123456123",
        "totalAmount" : 1200,
        "extraData" : {
             "a" : "b",
             "C" : "D"
         }
     }
  ]
}
```

{% endcode %}

#### 실패인 경우 <a href="#ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0" id="ec-8b-a4-ed-8c-a8-ec-9d-b8-ea-b2-bd-ec-9a-b0"></a>

* http code 400
* 아래와 같은 형태의 response body 로 에러 코드와 메시지를 전달

{% code overflow="wrap" %}

```json
{
"errorCode" : "실패코드",
"errorMessage" : "실패사유"
}
```

{% endcode %}
