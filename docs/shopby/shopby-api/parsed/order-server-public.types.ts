// Auto-generated TypeScript types from order-server

export interface task-messages-1424864304 {
  /** 첨부파일 정보 (nullable)^| */
  uploadedFileInfos?: any[];
  /** 메시지를 작성한 담당자 번호 (서비스일 경우 null, 파트너일 경우 parter no) (nullable)^|1 */
  fromTargetNo?: number;
  /** 진행상황^|(PROCESSING: Processing, DONE: Done) */
  taskMessageStatusType: string;
  /** 관리자 번호 (nullable)^|544844 */
  registerAdminNo?: number;
  /** 주문번호^|1 */
  orderNo: string;
  /** 메시지를 작성한 담당자 타입 (nullable)^|(PARTNER: Partner Center, SERVICE: Service Admin) */
  fromTargetType?: string;
  /** 주문옵션번호^|1 */
  orderProductOptionNo: number;
  /** 메시지를 작성한 담당자 번호 (서비스일 경우 null, 파트너일 경우 parter no)^|1 (nullable)^|1 */
  toTargetNo?: number;
  /** 업무메시지 유형^|(PAY: Payment(Deposit), PRODUCT: Product, DELIVERY: Delivery, CLAIM: Cancel/Exchange/Return, REFUND: Refund, ETC: ETC) */
  taskMessageType: string;
  /** 담당자 타입^|(PARTNER: Partner Center, SERVICE: Service Admin) */
  toTargetType: string;
  /** 상품 이름 (nullable)^| */
  productName?: string;
  /** 내용^|1 */
  content: string;
}

export interface orders-update-invoices-96635585 {
}

export interface accounts-orders-confirmation-1567762679 {
}

export interface accounts-orders-1300752720 {
}

export interface previous-orders276177791 {
  contents?: any[];
  /** 전체 주문수^|10 */
  totalCount: number;
}

export interface wish53840767 {
  contents?: any[];
  /** 위시리스트 크기^|10 */
  totalCount: number;
}

export interface task-messages103273964 {
  /** 총 수량^|12 */
  totalCount: number;
  /** 주문 내역 */
  items: any[];
}

export interface previous-orders-2097246096 {
  /** 등록 개수^|1 */
  count: number;
}

export interface task-messages27727223 {
  /** 업무메시지 번호^|1 */
  taskMessageNo: number;
}

export interface orders-change-status-by-shipping-no-236918478 {
  /** 주문상태^|DELETE */
  orderStatusType?: string;
  changeStatusList?: any[];
}

export interface previous-orders-delete-1499897203 {
  /** 삭제 개수^|1 */
  count: number;
}

export interface shipping-addresses60484751 {
  /** 주소지 목록 */
  contents: any[];
  /** 총 건수 */
  totalCount: number;
}

export interface orders1248582396 {
  contents?: any[];
  /** 총 건수^|10 */
  totalCount: number;
}

export interface task-messages-taskMessageNo-452177317 {
  /** 첨부파일 정보 (nullable)^| */
  uploadedFileInfos?: any[];
  /** 주문옵션번호^|1 */
  orderProductOptionNo: number;
  /** 메시지를 작성한 담당자 번호 (서비스일 경우 null, 파트너일 경우 parter no)^|1 (nullable)^|1 */
  toTargetNo?: number;
  /** 업무메시지 유형^|(PAY: Payment(Deposit), PRODUCT: Product, DELIVERY: Delivery, CLAIM: Cancel/Exchange/Return, REFUND: Refund, ETC: ETC) */
  taskMessageType: string;
  /** 담당자 타입^|(PARTNER: Partner Center, SERVICE: Service Admin) */
  toTargetType: string;
  /** 내용^|1 */
  content: string;
}

export interface orders-reserve-to-normal395982850 {
  /** 예약 주문의 주문옵션번호^|[10221,10343] */
  orderOptionNos: any[];
}

export interface task-messages-taskMessageNo-details326404204 {
  /** 상세 업무메시지 번호^|1 */
  taskMessageDetailNo: number;
}

export interface previous-orders-1326242519 {
}

export interface orders-tax-invoice-872144232 {
}

export interface task-messages-taskMessageNo-details-taskMessageDetailNo-637914009 {
  /** 첨부파일 정보 */
  uploadedFileInfos?: any[];
  /** 내용^|1 */
  content: string;
}

export interface orders-prepare-delivery486549215 {
}

export interface task-messages-taskMessageNo-details-1223057146 {
  /** 메시지를 작성한 담당자 이름 (nullable)^|홍길동 */
  registerAdminName?: string;
  /** 첨부파일 정보 */
  uploadedFileInfos?: any[];
  /** 처리완료여부^|false */
  completion: boolean;
  /** 관리자번호 (nullable)^|544844 */
  registerAdminNo?: number;
  /** 내용^|1 */
  content: string;
}

export interface cart-1890208080 {
  contents?: any[];
  /** 장바구니 크기^|10 */
  totalCount: number;
}

export interface orders-orderNo-792507223 {
  /** 최초 결제 시간^|2023-01-01 00:00:00 */
  firstPayYmdt?: string;
  /** 결제 정보 */
  payments: any[];
  /** 플랫폼타입^|PC */
  platformType?: string;
  /** 채널타입^|NAVER_EP */
  channelType: string;
  /** 마지막 실제결제금액(적립금제외)^|2500 */
  lastMainPayAmt?: number;
  /** 주문메모^|고객님 주문입니다. */
  orderMemo?: string;
  /** 업데이트일시^|20201010 */
  updateYmdt?: string;
  /** 결제수단^|ACCOUNT */
  payType?: string;
  /** 주문추적키 (쇼핑몰에서 생성되어 주문번호를 특정하는 구분값)^|12121212 */
  trackingKey?: string;
  /** 적용 환율 (nullable)^|1 */
  exchangeRate?: number;
  /** 클레임 정보 */
  claimInfos: any[];
  /** 회원주문여부^|true */
  isMemberOrder: boolean;
  /** 최초결제 */
  firstBalance: Record<string, any>;
  /** 등록일^|YYYY-MM-DD hh:mm:ss */
  registerYmdt?: string;
  /** 외부 PG사^|KCP */
  pgType?: string;
  /** 주문번호^|2020101000009 */
  orderNo?: string;
  /** 배송정보 */
  shippings: any[];
  /** 주문 상품 */
  orderProducts?: any[];
  /** 최종결제 */
  lastBalance: Record<string, any>;
  /** 외부주문번호^|EO0001 */
  externalOrderNo: string;
  /** 회원번호^|1 */
  memberNo?: number;
  /** 주문자정보 */
  orderer: Record<string, any>;
  /** ^|{} */
  extraJson?: string;
  /** 쇼핑몰 번호^|1 */
  mallNo?: number;
  /** 결제 통화 코드^|KRW */
  currencyCode?: string;
}

export interface orders-change-status-by-shipping-no1542267718 {
  failures?: any[];
  /** 실패 건 수^|1 */
  failCount: number;
  /** 성공 건 수^|1 */
  successCount: number;
  /** 총 처리 건 수^|2 */
  totalCount: number;
}

export interface orders-cash-receipt1742593779 {
}

export interface accounts-orders-confirmation1583574419 {
}

export interface accounts-orders-orderNo-1794504581 {
  /** 주문자 이메일^|account@bank.com */
  ordererEmail: string;
  /** 주문번호^|123456 */
  orderNo: string;
  /** 주문금액^|58000 */
  bankAmt: number;
  /** 주문자 연락처^|010-0000-0000 */
  ordererContact: string;
  /** 입금 은행명^|입금은행 */
  bankName: string;
  /** 입금자명^|김입금 */
  remitterName: string;
  /** 주문자 이름^|김주문 */
  ordererName: string;
  /** 입금 계좌번호^|123-45567-12 */
  account: string;
  products?: any[];
  /** 주문일자^|2025-10-27T11:17:24.889498644 */
  registerYmdt: string;
}

export interface orders-delivery839290676 {
}

export interface recurring-payments-20916618 {
  /** 검색 결과 */
  contents: any[];
  /** 검색 결과 수 */
  totalCount: number;
}

export interface orders-deliveries1896881641 {
  contents?: any[];
  /** 총 건수^|10 */
  totalCount: number;
}

export interface previous-orders-delete-by-order-nos-565536975 {
  /** 주문 번호 리스트^|[202402271234567890] */
  orderNos: any[];
}

export interface orders-extra-data-1305470581 {
}

export interface orders-update-invoices-1079341162 {
}

