# 회원 이관 설계·명세 (member-migration-spec)

> 산출: hls-migration-designer · 2026-06-30 · Huni-Launch-Scope(§28)
> ★위상: **설계·명세 중심**. 구 사이트 원천 DB 직접 접근 없음 — 라이브 마이페이지 화면 관찰값(`00_live/migration-screen-clues.md`) + Shopby 회원 모델(`docs/shopby`)을 양 끝점으로 한 청사진. **실제 추출/적재는 인간 승인 후 별도 트랙.**
> ★개인정보·자격증명 실값 비노출. 화면 미확인 항목은 "원천 확인 필요"로 분류(추측 0).

---

## 0. 요약

- **이관 단위:** 구 huniprinting.com 회원(Classic ASP) → Shopby 회원(member) + 배송지 주소록 + 회원 추가항목(extraInfo).
- **매핑 가능(native) 핵심:** 아이디·이름·이메일·휴대폰·일반전화·주소(우편/도로명/지번/상세)·상호·사업자번호·SMS/마케팅 동의·등급(매핑)·휴면/탈퇴 상태.
- **확장(extraInfo/주소록)으로 보존:** 대표자명·업태·업종·직업·회사전화·팩스·회사주소1/2.
- **이행 불가(전략 대체):** 비밀번호(단방향 해시) → 재인증 전환 전략.
- **잔여 결정 종속:** 등급 매핑(OQ-G6)·사업자/다중주소 수용(OQ-G5)·가입일/휴면/탈퇴 원천 플래그.

---

## 1. 이관 대상 항목 (관찰 기반)

### 1-1. 개인 (modify.asp / login.asp / main.asp 관찰)
| 구 필드 | 의미 | Shopby 대상 | 비고 |
|---------|------|-------------|------|
| user_id | 로그인 아이디 | member.memberId | 아이디 기반 로그인 유지 |
| user_pwd | 비밀번호(해시) | member.password | ★이행 불가→§4 전환전략 |
| 회원명 | 표시/실명 | member.memberName | |
| user_email | 이메일 | member.email | 중복/형식 검증 |
| user_hp1/2/3 | 휴대폰(3분할) | member.mobileNo(+CountryCode 82) | concat·하이픈 정규화 |
| user_tel1/2/3 | 일반전화(3분할) | member.telephoneNo | concat |
| user_zip | 우편번호 | member.zipCd | 자릿수 체계 확인 |
| user_addr1 | 도로명/기본주소 | member.address | |
| user_addr2 | 상세주소 | member.address(상세)/jibunDetailAddress | 분할구조 정합 확인 |
| jibun_addr | 지번주소 | member.jibunAddress | |
| user_zone(hidden) | 도로명코드(추정) | 주소 부가코드(추정) | ★원천 확인 전 보류 |
| check_sms | SMS 수신동의 | member.smsAgreed(+smsAgreeYmdt) | 동의일시 원천 확인 |
| check_email | 마케팅 이메일 수신 | member.directMailAgreed(+directMailAgreeYmdt) | ★재동의 권고(§5) |

### 1-2. 사업자/회사 (modify.asp 세금계산서 영역)
| 구 필드 | Shopby 대상 | 매핑 방식 |
|---------|-------------|-----------|
| user_company(상호) | member.businessName | native |
| user_number1/2/3(사업자등록번호) | member.businessRegistrationNumber | concat(10자리)·유효성 검증 |
| user_owner(대표자명) | member.extraInfo[대표자명] | 추가항목(TEXTBOX) |
| user_uptae(업태) | member.extraInfo[업태] | 추가항목 |
| user_upjong(업종) | member.extraInfo[업종] | 추가항목 |
| user_job(직업·select) | member.extraInfo[직업] | 코드→라벨 매핑 후 |
| user_ctel1/2/3(회사전화) | member.extraInfo[회사전화] / BFF | native 미보유 |
| user_cfax1/2/3(팩스) | member.extraInfo[팩스] / BFF | native 미보유 |
| user_c1*(회사주소1) | 배송지 주소록 1건 | post-profile-shipping-addresses |
| user_c2*(회사주소2/추가배송지) | 배송지 주소록 1건 | post-profile-shipping-addresses |

→ **회원 = 개인 + 사업자 + 다중주소(개인·회사1·회사2).** Shopby 단일 프로필 주소를 넘어서는 분량은 **주소록 + extraInfo**로 보존(OQ-G5 수용범위 확정 종속).

### 1-3. 등급·상태
| 항목 | Shopby 대상 | 비고 |
|------|-------------|------|
| 회원할인율(%)(대시보드) | member.gradeNo(memberGrade) | 구 등급↔Shopby 등급 매핑표 필요(OQ-G6). 0%=기본등급 |
| 가입일 | 가입일시(registerYmdt) | ★화면 미관측·보존 가능 여부 확인 |
| 휴면상태 | member.dormant | ★원천 플래그 확인(법적 필수·1년 미접속) |
| 탈퇴/탈퇴사유(out.asp) | member.expelled | ★이관 범위·개인정보 보존기간 정책 |

---

## 2. Shopby 회원 모델 매핑 판정 (capability 근거)

- **native 수용(손실 없음):** memberId·memberName·email·mobileNo·telephoneNo·zipCd·address·jibunAddress·businessName·businessRegistrationNumber·smsAgreed·directMailAgreed·gradeNo·dormant·expelled — `member-shop-public.types.ts`/`member-server-public` 확인.
- **extraInfo[](회원정보 추가항목) 수용:** 대표자명·업태·업종·직업·회사전화·팩스 — `configurations-member-extra-info-config`(extraInfoType TEXTBOX/옵션) 근거. ★추가항목은 **사전 정의 후** 적재(이관 전 어드민 등록 선행).
- **배송지 주소록 수용:** 회사주소1/2 → `post-profile-shipping-addresses`.
- **BFF 대안:** extraInfo 수용범위가 부족하면(검색·증빙 연계 필요 시) 사업자정보 다건을 후니 BFF에 별도 저장(fit-gap No26/27 PARTIAL과 정합).

---

## 3. 비밀번호/인증 전환 전략 (★HARD)

구 `user_pwd`는 **단방향 해시**(알고리즘 미상·ASP MD5/SHA1/salt 추정) → Shopby 해시와 호환 불가 → **평문/해시 어느 쪽도 이행 불가.** 비번은 이행하지 않고 아래 전략으로 대체.

| 전략 | 방식 | 장점 | 단점/리스크 | 권고 |
|------|------|------|------------|------|
| A. 최초 로그인 시 재설정 | 회원 시드 시 비번 비활성→첫 로그인에서 find-password URL(이메일) 재설정 강제 | 비용 낮음·표준 API(put-profile-password-sending-email-with-url) | 이메일 미수신/오류 회원 진입 장벽·전환율 | ★1차 기본 |
| B. 임시PW 일괄 발송 | 컷오버 시 임시 비번 생성→SMS/이메일 발송 | 즉시 로그인 가능 | SMS 계약(OQ-G8) 비용·임시PW 노출 보안·대량발송 스팸판정 | 보조(휴대폰만 보유 회원) |
| C. 소셜/SSO 전환 | 네이버/카카오 OAuth로 신규 인증(post-oauth-openid) | 비번 자체 폐기·UX 우수 | 기존 이메일 계정과 연결 매칭 필요·소셜 미사용자 누락 | 선택지 제공(병행) |

**권고 조합:** A를 기본으로, 휴대폰만 검증된 회원은 B, 소셜 가능 회원은 C 안내를 병행. **전 회원 재인증 1회 발생은 불가피**(이관 공지문에 포함).

본인확인 방법(비번변경/탈퇴 전, OQ-G12)도 컷오버 전 확정 필요.

---

## 4. 약관·개인정보 재동의

- **서비스 이용약관/개인정보처리방침:** 플랫폼 이전은 처리자/위탁 구조 변경을 수반할 수 있어 **재동의 또는 사전 고지 필요**(이관 공지 + 최초 로그인 약관 동의 게이트 권고). Shopby 약관 도메인(native)으로 신규 동의 수집 가능.
- **마케팅 수신동의(check_sms/check_email):** 동의값은 이관하되, **동의일시(smsAgreeYmdt/directMailAgreeYmdt) 원천이 없으면 법적 근거가 약화**됨 → 마케팅 수신은 **재동의 캠페인 권고**. 원천 동의일시 확보 시 그대로 보존.
- **본인인증(certificated):** 구 인증완료 상태를 Shopby로 이관 가능한지 불명 → 미이관 시 일부 기능 제한 가능(원천 확인 필요).

---

## 5. 이관 절차 (추출 → 변환 → 적재 → 검증 → 롤백)

```
[1 추출]  구 DB → 회원 원본 스냅샷(기준시각 동결)         ← 원천 DB 제공 후(인간 승인)
   │        · PII 최소수집·암호화 전송·접근통제
[2 변환]  정규화·매핑(field-mapping.csv 규칙)              ← 멱등 변환·검증 가능 산출
   │        · 전화/사업자번호 concat·주소 분할 정합
   │        · 중복 이메일/아이디 충돌 해소(§6)
   │        · extraInfo 항목 사전 등록(어드민)
   │        · 비번=시드 제외(§3)
[3 적재]  Shopby 회원 벌크/프로필 API                       ← 배치·재시도·externalKey 추적
   │        · 회원 생성(profile-bulk / post-profile)
   │        · 주소록(post-profile-shipping-addresses)
   │        · 등급(gradeNo)·휴면(dormant)·탈퇴(expelled) 상태
[4 검증]  ★게이트(§7)                                       ← 통과 못하면 컷오버 중단
[5 롤백]  실패 회원 격리·재처리 / 전량 무효화 경로          ← 멱등키로 안전 재실행
```

- **멱등성:** 회원당 **이관 멱등키**(예: 구 user_id 또는 해시) 보유 → 재실행 시 중복 생성 방지(이미 존재하면 skip/갱신).
- **재시도:** 배치 실패는 회원 단위 격리 후 부분 재처리(전량 재적재 금지).

---

## 6. 예외 처리 규칙

| 예외 | 규칙 |
|------|------|
| 중복 이메일(다계정) | Shopby 1이메일 1계정 가정→대표계정 선정·나머지는 보류 리스트(수기 병합 결정). 임의 병합 금지 |
| 중복/규칙위반 아이디 | Shopby loginId 규칙 위반(문자/길이) 정규화·충돌 시 보류 리스트 |
| 탈퇴회원 | 이관 범위 정책에 따름(기본=제외 권고). 보존기간 경과분 이관 금지(법적) |
| 휴면회원 | 휴면 상태로 이관(법적 필수). 마케팅·로그인 처리 정합 |
| 필수값 누락(이메일/휴대폰 없음) | 보류 리스트→재인증/보완 경로. 임의 더미값 주입 금지 |
| extraInfo 미정의 항목 | 적재 전 어드민에 추가항목 선등록(없으면 적재 실패) |

---

## 7. 검증 게이트 (컷오버 GO 기준)

| 게이트 | 기준 | 방법 |
|--------|------|------|
| M-G1 건수 대사 | 추출 회원수 = 적재 성공 + 보류 + 의도적 제외, 누락 0 | 카운트 reconcile |
| M-G2 샘플 1:1 | 대표 샘플(등급/사업자/다중주소/휴면/탈퇴 각 케이스) 필드 1:1 일치 | 원본↔Shopby 조회 대조 |
| M-G3 로그인 가능성 | 재설정 흐름(§3 A) 종단 1건 실증(이메일 수신→재설정→로그인) | 종단 테스트 |
| M-G4 등급 매핑 | 구 등급↔gradeNo 매핑표 전 등급 커버·미매핑 0 | 매핑표 대조 |
| M-G5 동의 정합 | smsAgreed/directMailAgreed 값 일치·동의일시 정책 적용 확인 | 샘플 대조 |
| M-G6 멱등 재실행 | 동일 배치 2회 실행 시 중복 회원 0 | 멱등키 검증 |
| M-G7 PII 안전 | 산출물·로그에 평문 PII/비번 0·전송 암호화 | 점검 |

★단일 게이트 FAIL = 컷오버 NO-GO. 머니 잔액 대사(P-G1)는 `printmoney-migration-spec.md` §6.

---

## 8. 미해결 → `migration-open-questions.md` 핸드오프

원천 DB 미접근으로 **실 컬럼/타입/플래그 확정 불가**한 항목(가입일·휴면/탈퇴 플래그·동의일시·등급체계·user_zone/check_bunho 의미·중복 이메일 분포·구 해시 알고리즘)은 open-questions로 분리. 원천 DB 제공 시 field-mapping을 실 스키마로 승격.
