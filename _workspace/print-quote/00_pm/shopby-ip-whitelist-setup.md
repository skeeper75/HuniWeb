# Shopby Server API IP 화이트리스트 등록 안내

**필요 사유:** Shopby Server API(`server-api.e-ncp.com`)는 보안 정책상 사전 등록된 IP에서만 호출 가능. 현재 분석 환경 IP(211.221.205.141)가 미등록이라 모든 호출이 400 Bad Request로 거부됨 (`code: S0001 "{IP}는 등록되지 않은 IP 입니다"`).

> **참고:** Shop API (`shop-api.e-ncp.com`, clientId 헤더)는 IP 제한 없음. 카탈로그·진열 등 공개 API는 그대로 사용 가능. 본 작업은 **Server API(어드민/관리자 API)** 전용.

---

## 1. 등록해야 할 IP

### 현재 단계 (분석·개발용)
| 용도 | IP | 비고 |
|------|----|----|
| 로컬 분석 환경 | **211.221.205.141** | 현재 사용 중 (변동 가능 — ISP가 동적 IP 부여 시 재등록 필요) |

> ISP가 동적 IP를 부여 중이면, `curl -sS https://ifconfig.me` 또는 `curl -sS https://api.ipify.org`로 현재 IP 재확인.

### 향후 운영 단계 (사전 합의 필요)
| 용도 | IP | 비고 |
|------|----|----|
| Production BFF 서버 | _TBD_ | 배포 단계 결정. 고정 IP 또는 NAT Gateway IP. |
| Staging BFF 서버 | _TBD_ | 검증 환경. |
| CI/CD (자동 테스트용) | _TBD_ | GitHub Actions/Vercel/CloudFlare 등 IP 범위 고려. |

---

## 2. 등록 절차

1. Shopby 관리자 콘솔 접속
   - URL: https://service.shopby.co.kr
   - ID: `huniprinting` (`SHOPBY_ADMIN_ID`)
   - PW: `.env.local`의 `SHOPBY_ADMIN_PW`

2. 좌측 메뉴 → **앱·솔루션 관리** (또는 **API 설정**)
   - 등록된 앱 목록 확인 — 분석 토큰을 발급한 앱 식별
   - 본 환경의 `clientId`: `csG2RJQcc5UhXBYKOlWvZw==`
   - 본 환경의 `appNo`: **2087** (토큰 payload 디코딩 확인됨)

3. 앱 상세 → **접근 가능 IP** 항목
   - **추가** 클릭 → `211.221.205.141` 입력
   - 메모: "후니프린팅 리뉴얼 분석 (2026-05-27, 신우진)"
   - 저장

4. 검증 (등록 후 약 1~5분 대기)
   ```bash
   set -a; source .env.local; set +a
   curl -sS \
     -H "Authorization: Bearer $SHOPBY_SERVER_ACCESS_TOKEN" \
     -H "version: $SHOPBY_VERSION" \
     -H "platform: $SHOPBY_PLATFORM" \
     -H "systemKey: $SHOPBY_SYSTEM_KEY" \
     "$SHOPBY_SERVER_API_URL/malls" | head -c 400
   ```
   - 정상: 200 + mall JSON (huniprinting48 정보)
   - 여전히 400 "등록되지 않은 IP": 등록 반영 지연 또는 등록한 IP가 실제와 다름

---

## 3. 보안 권장사항

- **분석용 임시 IP 등록은 작업 종료 시 즉시 제거**. 본인 사이트 분석이라도 화이트리스트 최소화.
- **운영 IP 등록은 사전 보안 검토** — VPC 게이트웨이 IP, CDN 우회 가능성 등.
- **토큰 폐기**: 분석 종료 후 `SHOPBY_SERVER_ACCESS_TOKEN`(100년 토큰)을 사용 중지하고 단기 토큰으로 교체 권장. 100년 토큰이 유출되면 영구 노출 위험.
- **Application Password 폐기**: buysangsang.com의 `BS_WP_APP_PASS`도 분석 종료 후 wp-admin에서 폐기. 위치: WP 관리자 → 사용자 → 본인 프로필 → Application Passwords.

---

## 4. 등록 후 가능한 분석 작업

| 작업 | API | 가치 |
|------|----|----|
| Mall 풀 설정 | `/malls` | 55KB 풀 응답(정책·등급·은행계좌·회원가입·적립금) |
| 상품 전수 + 메타 | `/products` + 상세 | huniprinting48의 카탈로그 vs buysangsang 비교 |
| 주문 통계 (있다면) | `/orders` | 운영 데이터 인벤토리 |
| 카테고리 트리 (admin) | `/categories` | buysangsang 1000-2100 ↔ Shopby 매핑 |
| 회원·등급 정책 | `/members/grades` | To-Be 멤버십 모델 입력 |
| 결제·정산 설정 | `/payments/*` | PG 통합 형태 |
| 옵션·재고 | `/products/options`, `/inventories` | huniprinting48이 옵션을 어떻게 운영했는지 |

---

## 5. 추적

- 등록 완료 시 본 문서의 "현재 단계" 표에 등록 일시 기록
- 등록 후 첫 성공 호출의 응답 일부를 `_workspace/print-quote/01_research/shopby/server-api-validation.md`에 저장
