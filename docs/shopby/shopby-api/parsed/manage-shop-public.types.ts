// Auto-generated TypeScript types from manage-shop

export interface boards-boardNo-posts-postNo1598826317 {
  /** 첨부파일 목록 */
  attachments?: any[];
  /** 최종 수정일 (nullable) */
  modifyYmdt?: string;
  /** 카테고리 명 (nullable) */
  categoryLabel?: string;
  /** 최초 등록자 타입 (MEMBER: 회원, ADMIN: 운영자, GUEST: 비회원, DEVELOPER: 워크스페이스 운영자(셀러어드민 이용자)) (nullable) */
  registerType?: string;
  /** 게시글 신고 누적 횟수 */
  reportedCnt?: number;
  /** 제목 (nullable) */
  title?: string;
  /** 최종 수정자 타입 (MEMBER: 회원, ADMIN: 운영자, GUEST: 비회원, DEVELOPER: 워크스페이스 운영자(셀러어드민 이용자)) (nullable) */
  modifierType?: string;
  /** 본문 (nullable) */
  content?: string;
  /** 최초 등록자 번호 (nullable) */
  registerNo?: number;
  /** 조회수 */
  viewCnt?: number;
  /** 이미지 URL (nullable) */
  imageUrl?: string;
  /** 본인의(회원) 게시글 신고 여부 */
  reported?: boolean;
  /** 카테고리 번호 (nullable) */
  categoryNo?: number;
  /** 부모 게시글 */
  parentArticle?: Record<string, any>;
  /** 수정가능 여부 (false: 수정 불가능, true: 수정 가능) */
  modifiable?: boolean;
  /** 검색용 게시글 태그 */
  postSearchTags?: any[];
  /** 최초 등록일 (nullable) */
  registerYmdt?: string;
  /** 본인의(회원) 스크랩 여부 */
  scraped?: boolean;
  /** 최종 수정자 번호 (nullable) */
  modifierNo?: number;
  /** 공지글 여부 (false: 일반글, true: 공지글) */
  noticed?: boolean;
  /** 비밀글 여부 (false: 공개글, true: 비밀글) */
  secreted?: boolean;
  /** 추천 수 */
  recommendedCnt?: number;
  /** 태그 */
  tags?: any[];
  /** 본인의(회원) 추천 여부 */
  recommended?: boolean;
  /** 게시글 번호 */
  postNo?: number;
  /** 해당 게시글에 답글 개수 */
  repliedCnt?: number;
  /** 답글 작성 가능 여부 */
  replyEnabled?: boolean;
  /** 최종 수정자명 (nullable) */
  modifierName?: string;
  /** 최초 등록자명 (nullable) */
  registerName?: string;
  /** 게시글 전시 상태 (전시중: DISPLAY, 차단: BLIND) */
  displayStatusType?: string;
  /** 회원 그룹번호 (nullable) */
  memberGroupNo?: number;
}

export interface boards-configurations333053723 {
  /** 상품 후기 게시판 설정(샵바이 프로인 경우만 값이 있음) */
  productReviewConfig?: Record<string, any>;
  /** 상품 문의 게시판 설정(샵바이 프로인 경우만 값이 있음) */
  productInquiryConfig?: Record<string, any>;
  /** 일반 게시판 설정 */
  boardConfigs?: any[];
  /** 1:1문의 게시판 설정(샵바이 프로인 경우만 값이 있음) */
  inquiryConfig?: Record<string, any>;
}

export interface inquiries195434980 {
  /** 1:1문의 개수 */
  totalCount?: number;
  /** 1:1문의 */
  items?: any[];
}

export interface inquiries-inquiryNo1319745130 {
  /** 1:1 문의 제목 (최대길이 : 400) */
  inquiryTitle?: string;
  /** 답변 등록시 메일 수신여부 (false: 수신 안함, true: 수신함) */
  answerEmailSendYn?: boolean;
  /** 업로드 된 파일명 */
  uploadedFileNames?: any[];
  /** 답변 등록시 SMS 수신여부 (false: 수신 안함, true: 수신함) */
  answerSmsSendYn?: boolean;
  /** 원본 파일명 */
  originalFileNames?: any[];
  /** 1:1 문의 내용 (최대길이 : 16,700,000) */
  inquiryContent?: string;
}

export interface inquiries-types-754076919 {
}

export interface boards-boardNo-posts-postNo-replies778887145 {
  /** 게시글 답글 리스트 개수 */
  totalCount?: number;
  /** 게시글 답글 리스트 */
  items?: any[];
}

export interface inquiries-inquiryNo482104634 {
  /** 원본 파일명 */
  originalFileName?: any[];
  /** 1:1 문의 제목 (최대길이 : 400) */
  inquiryTitle?: string;
  /** 답변 등록시 메일 수신여부 (false: 수신 안함, true: 수신함) (nullable) */
  answerEmailSendYn?: boolean;
  /** 업로드 된 파일명 */
  uploadedFileName?: any[];
  /** 답변 등록시 SMS 수신여부 (false: 수신 안함, true: 수신함) (nullable) */
  answerSmsSendYn?: boolean;
  /** 1:1 문의 내용 (최대길이 : 16,700,000) */
  inquiryContent?: string;
}

export interface page-scripts807368217 {
}

export interface boards-boardNo-articles-articleNo-replies1064969085 {
  /** 게시글 답글 리스트 개수 */
  totalCount?: number;
  /** 게시글 답글 리스트 */
  items?: any[];
}

export interface terms-custom933790498 {
}

export interface holiday-736675939 {
}

export interface addresses-search-1159150621 {
  /** 시도 검색 결과 배열 */
  groupByStates?: any[];
  /** 총 검색 결과 갯수 */
  totalCount?: number;
  /** 주소 검색 결과 배열 */
  items?: any[];
}

export interface boards-posts928791127 {
  /** 게시글 리스트 개수 */
  totalCount?: number;
  /** 게시글 리스트 */
  items?: any[];
}

export interface profile-accumulations-expiration-345917270 {
  /** 만료 리스트^|[AccumulationExpiration(accumulationNo=1, expirationYmdt=2025-10-27T12:10:06.268044937, accumulationReserveReasonDisplay=운영자 지급, reasonDetail=운영자 테스트 지급, amount=1000)] */
  expirations?: any[];
  /** 만료조회 총 적립금액 */
  expiresAmount?: number;
}

export interface boards-boardNo-categories2026858948 {
}

export interface boards-boardNo-articles-articleNo-report-808776058 {
  /** 신고사유(저작권 침해: COPYRIGHT, 비방: SLANDER, ETC: 기타사유) */
  reportReasonType?: string;
  /** 신고 내용 */
  content?: string;
}

export interface inquiries-inquiryNo849373678 {
  /** 답변 등록시 SMS 수신 여부 (false: 수신 안함, true: 수신함) */
  answerSmsSend?: boolean;
  /** 1:1문의 유형 */
  inquiryType?: Record<string, any>;
  /** 주문번호 (nullable) */
  orderNo?: string;
  /** 답변 등록시 메일 수신 여부 (false: 수신 안함, true: 수신함) */
  answerEmailSend?: boolean;
  /** 1:1 문의자 이름 */
  issuerName?: string;
  /** 원본 이미지 url */
  originalImageUrls?: any[];
  /** 답변 상태 (ISSUED(ASKED-이전버전 호환용): 답변대기, IN_PROGRESS: 답변 진행중, ANSWERED: 답변완료) */
  inquiryStatus?: string;
  /** 상품명 (nullable) */
  productName?: string;
  /** 등록인 번호 (nullable) */
  registerNo?: number;
  /** 문의 제목 */
  inquiryTitle?: string;
  /** 1:1문의 답변 (nullable) */
  answer?: Record<string, any>;
  /** 이미지 url */
  imageUrls?: any[];
  /** 문의 내용 */
  inquiryContent?: string;
  /** 영문 상품명 (nullable) */
  productNameEn?: string;
  /** 주문옵션번호 (nullable) */
  orderOptionNo?: number;
  /** 상품번호 (nullable) */
  productNo?: number;
  /** 등록일 */
  registerYmdt?: string;
  /** 1:1문의 번호 */
  inquiryNo?: number;
}

export interface boards-boardNo-articles-articleNo-1875198411 {
  /** 비회원용 게시글 작성 비밀번호 (nullable) */
  password?: string;
}

export interface inquiries-configurations-784433679 {
  /** 답글 작성 허용 여부 (false: 작성 미허용, true: 작성 허용) */
  replyUsed?: boolean;
  /** 비회원 글 작성 허용 여부 (false: 작성 미허용, true: 작성 허용) */
  guestPostingUsed?: boolean;
  /** 게시판 설명 */
  description?: string;
  /** 회원 글 작성 허용 여부 (false: 작성 미허용, true: 작성 허용) */
  memberPostingUsed?: boolean;
  /** 게시판 사용 여부 */
  used?: boolean;
  /** 답변완료 Email 템플릿 사용 여부  (false: 템플릿 미사용, true: 템플릿 사용) */
  answerMailTemplateUsed?: boolean;
  /** 게시판 리스트 이미지 유형 */
  imageDisplayType?: string;
  /** 답변완료 SMS 템플릿 사용 여부 (false: 템플릿 미사용, true: 템플릿 사용) */
  answerSmsTemplateUsed?: boolean;
  /** 게시판 유형 */
  displayType?: string;
  /** 첨부파일 게시 허용 여부 (false: 첨부 미허용, true: 첨부 허용) */
  attachmentUsed?: boolean;
  /** 게시판 이름 */
  name?: string;
  /** 비밀글 작성 허용 여부 (false: 작성 미허용, true: 작성 허용) */
  secretPostingUsed?: boolean;
  /** Email 사용 여부 (false: Email 미사용, true: Email 사용) */
  emailUsed?: boolean;
  /** SMS 사용 여부 (false: SMS 미사용, true: SMS 사용) */
  smsUsed?: boolean;
}

export interface shopby-instagram-media-297972756 {
  data?: any[];
  error?: Record<string, any>;
}

export interface terms-1849610091 {
  /** 약관 타입 */
  key?: Record<string, any>;
}

export interface terms-history143648857 {
}

export interface terms-termsNo-1990424634 {
  /** 약관 내용 */
  contents?: string;
  /** 시행일 */
  enforcementDate?: string;
  /** 약관 사용 여부 (false: 미사용, true: 사용) */
  used?: boolean;
}

export interface boards-boardNo-articles-articleNo-editable-149444152 {
  /** 비회원 글쓰기용 비밀번호 확인 (nullable) */
  password?: string;
}

export interface profile-accumulations-summary-1470401351 {
  /** 사용가능한 총 적립금액 */
  totalAvailableAmt?: number;
  /** 만료조회 총 적립금액 */
  totalExpireAmt?: number;
}

export interface boards-boardNo-articles-articleNo656562113 {
  /** 첨부파일 목록 */
  attachments?: any[];
  /** 최종 수정일 (nullable) */
  modifyYmdt?: string;
  /** 카테고리 명 (nullable) */
  categoryLabel?: string;
  /** 최초 등록자 타입 */
  registerType?: string;
  /** 제목 (nullable) */
  title?: string;
  /** 최종 수정자 타입 (nullable) */
  modifierType?: string;
  /** 본문 (nullable) */
  content?: string;
  /** 게시글 번호 */
  articleNo?: number;
  /** 답글 리스트 */
  childArticles?: any[];
  /** 최초 등록자 번호 (nullable) */
  registerNo?: number;
  /** 조회수 (nullable) */
  viewCnt?: number;
  /** 이미지 URL (nullable) */
  imageUrl?: string;
  /** 게시글 신고 여부 */
  reported?: boolean;
  /** 카테고리 번호 (nullable) */
  categoryNo?: number;
  /** 부모 게시글 */
  parentArticle?: Record<string, any>;
  /** 수정가능 여부 (false: 수정 불가능, true: 수정 가능) */
  modifiable?: boolean;
  /** 공지글 여부 (false: 일반글, true: 공지글) */
  notice?: boolean;
  /** 작성자 아이디 (nullable) */
  memberId?: string;
  /** 최초 등록일 (nullable) */
  registerYmdt?: string;
  /** 추천가능여부 */
  recommendable?: boolean;
  /** 최종 수정자 번호 (nullable) */
  modifierNo?: number;
  /** 비밀글 여부 (false: 공개글, true: 비밀글) (nullable) */
  secreted?: boolean;
  /** 태그 */
  tags?: any[];
  /** 최초 등록자 소속명 (nullable) */
  registerGroupNames?: string;
  /** 추천 수 */
  recommendCount?: number;
  /** 게시글 신고 누적 횟수 */
  reportCount?: number;
  /** 최종 수정자명 (nullable) */
  modifierName?: string;
  /** 회원 닉네임 */
  memberNickname?: string;
  /** 최초 등록자명 */
  registerName?: string;
  /** 게시글 전시 상태 (전시중: DISPLAY, 차단: BLIND) */
  displayStatusType?: string;
}

export interface inquiries1602970542 {
  /** 1:1 문의 일련번호 */
  inquiryNo?: number;
}

export interface profile-accumulations-waiting211812153 {
  /** 총 적립예상금액 */
  waitingAccumulation?: number;
}

export interface boards-boardNo-articles-articleNo2081539190 {
  images?: any[];
  /** 비회원 글쓰기용 비밀번호 확인 (nullable) */
  password?: string;
  /** 게시글 제목 */
  articleTitle?: string;
  /** 게시글 내용 */
  articleContent?: string;
  /** 게시판 카테고리 번호 */
  boardCategoryNo?: number;
  /** 비밀글 여부 (false: 공개글, true: 비밀글) */
  secreted?: boolean;
  /** 검색용 게시글 태그 */
  postSearchTags?: any[];
  /** 대표 이미지 */
  thumbnailUrl?: string;
  /** 태그들 (nullable) */
  tags?: any[];
  /** 비회원 수정자. 생략하면 '비회원'으로 노출. (nullable) */
  guestName?: string;
}

export interface boards-posts-408790453 {
  /** 비밀글 조회 여부(null: 공개+비밀 게시글 전체 조회(default), false: 공개 게시글만 조회, true: 비밀 게시글만 조회) (nullable) */
  isSecreted?: boolean;
  /** 본인이 스크랩한 게시글만 조회 여부(false: 전체 조회(default), true: 스크랩한 게시글만 조회) (nullable) */
  myScrapedOnly?: boolean;
  /** 검색유형 (ALL: 전체, TITLE: 제목, CONTENT: 내용, WRITER: 작성자) (nullable) */
  searchType?: string;
  /** 게시판 번호 Or 게시판 Id (nullable) */
  boardNoOrId?: string;
  /** 조회일 종료일(yyyy-MM-dd HH:mm:ss) (nullable) */
  endYmdt?: string;
  /** 차단된 게시글 스킵 여부(false: 차단된 게시글을 포함하여 조회(default), true: 차단된 게시글을 제외하고 조회 ) (nullable) */
  skipBlinded?: boolean;
  /** 본인이 추천한 게시글만 조회 여부(false: 전체 조회(default), true: 추천한 게시글만 조회) (nullable) */
  myRecommendOnly?: boolean;
  /** 조회일 시작일(yyyy-MM-dd HH:mm:ss) (nullable) */
  startYmdt?: string;
  /** 회원 번호 (nullable) */
  memberNos?: any[];
  /** 게시판 카테고리 (nullable) */
  categoryNo?: number;
  /** 본인이 작성한 글만 조회 여부(false: 전체 조회(default), true: 본인 글만 조회) (nullable) */
  isMine?: boolean;
  /** 검색어 (nullable) */
  keyword?: string;
  /** 공지글 조회 여부(null: 공지+일반 게시글 전체 조회(default), false: 일반 게시글만 조회, true: 공지글만 조회 (nullable) */
  isNoticed?: boolean;
  /** 게시글 검색용 태그 (nullable) */
  postSearchTags?: any[];
  /** 회원 그룹번호 (nullable) */
  memberGroupNo?: number;
  /** 정렬방식(DESC: 최신 순(default), ASC: 오래된 순, RECOMMEND_COUNT: 추천수 많은 순, READ_COUNT: 조회수 많은 순) (nullable) */
  direction?: string;
}

export interface boards-boardNo-articles1572956845 {
  images?: any[];
  /** 비회원 글쓰기용 비밀번호 (nullable) */
  password?: string;
  /** 게시글 제목 */
  articleTitle?: string;
  /** 상위 게시글 번호 (nullable) */
  parentBoardArticleNo?: number;
  /** 게시글 내용 */
  articleContent?: string;
  /** 카테고리 번호 (nullable) */
  boardCategoryNo?: number;
  /** 비밀글 여부 (false: 공개글, true: 비밀글) */
  secreted?: boolean;
  /** 검색용 게시글 태그 (nullable) */
  postSearchTags?: any[];
  /** 대표 이미지 (최대 길이 500자) (nullable) */
  thumbnailUrl?: string;
  /** 태그목록 (nullable) */
  tags?: any[];
  /** 비회원 작성자. 생략하면 '비회원'으로 노출. (nullable) */
  guestName?: string;
}

export interface terms-545033491 {
  /** 약관 대체 문구 */
  replacementPhrase?: Record<string, any>;
  /** 조회할 약관 타입 리스트 (nullable) */
  termsType?: any[];
  /** 사용 중인 약관만 조회 여부 (Default : false) */
  usedOnly?: boolean;
}

export interface inquiries-1704095907 {
  /** 원본 파일명 (nullable) */
  originalFileName?: any[];
  /** 답변 등록시 메일 수신여부 (false: 수신 안함, true: 수신함) (nullable) */
  answerEmailSendYn?: boolean;
  /** 업로드 된 파일명 (nullable) */
  uploadedFileName?: any[];
  /** 주문번호 (nullable) */
  orderNo?: string;
  /** 답변 등록시 SMS 수신여부 (false: 수신 안함, true: 수신함) (nullable) */
  answerSmsSendYn?: boolean;
  /** 비회원 등록 시 작성자 휴대폰 번호 (nullable) */
  mobileNo?: string;
  /** 1:1 문의 제목 (최대길이 : 400) */
  inquiryTitle?: string;
  /** 캡챠서비스 키(미사용 변수, 추후 사용예정) */
  captcha?: string;
  /** 
 1:1 문의 유형 번호<br>
 ※ 어드민에서 등록한 1:1 문의유형은 [GET /malls 몰 정보 조회하기 API](https://docs.shopby.co.kr/#/Mall/get-malls) 호출 시,<br>
 응답값 내 inquiryType에서 inquiryTypeNo(1:1문의 유형번호) 항목 정보를 확인 가능합니다.<br>
 (nullable) */
  inquiryTypeNo?: number;
  /** 1:1 문의 내용 (최대길이 : 16,700,000) */
  inquiryContent?: string;
  /** 주문옵션번호 (nullable) */
  orderOptionNo?: number;
  /** 비회원 등록 시 작성자 이메일 주소 (nullable) */
  email?: string;
  /** 상품번호 (nullable) */
  productNo?: number;
}

export interface boards-boardNo-articles-565179227 {
  /** 게시글 리스트 개수 */
  totalCount?: number;
  /** 게시글 리스트 */
  items?: any[];
}

export interface profile-accumulations-258238611 {
  /** 회원 번호 */
  memberNo?: number;
  /** 적립 총액 */
  totalAmt?: number;
  /** 전체 카운트 */
  totalCount?: number;
  items?: any[];
}

export interface addresses-search-jp-808900162 {
  /** 도도부현 코드 (2자리) */
  prefCode?: string;
  /** 우편번호 */
  zipCode?: string;
  /** 전체 주소 */
  address?: string;
  /** 상세 주소 */
  streetAddress?: string;
  /** 시/구/읍/면 이름 */
  city?: string;
  /** 입력된 우편번호에 해당하는 복수의 주소 리스트 */
  addressList?: any[];
  /** JIS 코드 */
  jisCode?: string;
  /** 도도부현 이름 */
  state?: string;
  /** 전체 주소 (영문) */
  addressEnglish?: string;
}

export interface terms-custom1116014589 {
}

export interface terms-used1135317778 {
  /** 사용중인 약관 타입 */
  termsList?: any[];
}

