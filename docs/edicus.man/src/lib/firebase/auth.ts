// Firebase Auth 헬퍼 함수 모음
// 인증 관련 모든 Firebase 작업을 중앙화하여 관리합니다
// @MX:ANCHOR: Firebase Auth 공개 API - useAuth 훅과 미들웨어에서 참조
// @MX:REASON: signInWithEmail, getIdToken, generateEdicusUid가 다수의 모듈에서 호출됨
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  type User,
  type Unsubscribe,
} from 'firebase/auth';
import { auth } from './config';

// Firebase 이메일/패스워드 로그인
// 성공 시 User 반환, 실패 시 Firebase Auth 오류를 throw
export async function signInWithEmail(email: string, password: string): Promise<User> {
  const credential = await signInWithEmailAndPassword(auth, email, password);
  return credential.user;
}

// Firebase 이메일/패스워드 회원가입
// 성공 시 User 반환, 실패 시 Firebase Auth 오류를 throw
export async function signUpWithEmail(email: string, password: string): Promise<User> {
  const credential = await createUserWithEmailAndPassword(auth, email, password);
  return credential.user;
}

// Firebase 로그아웃
export async function signOutUser(): Promise<void> {
  await signOut(auth);
}

// Firebase 인증 상태 변경 리스너 등록
// 반환된 Unsubscribe 함수를 호출하면 리스너가 제거됩니다
export function onAuthChange(callback: (user: User | null) => void): Unsubscribe {
  return onAuthStateChanged(auth, callback);
}

// 현재 로그인된 Firebase 사용자 반환 (미로그인 시 null)
export function getCurrentUser(): User | null {
  return auth.currentUser;
}

// Firebase ID 토큰 조회
// forceRefresh: true 시 캐시된 토큰 대신 서버에서 새 토큰을 발급받습니다
export async function getIdToken(forceRefresh = false): Promise<string | null> {
  const user = auth.currentUser;
  if (!user) return null;
  return user.getIdToken(forceRefresh);
}

// @MX:NOTE: Firebase UID를 Edicus 호환 UID로 변환합니다
// Edicus API는 영숫자와 하이픈만 허용하며 최대 64자 제한이 있습니다
// PII(개인식별정보)를 포함하지 않도록 UID를 직접 사용하되 형식을 정규화합니다
export function generateEdicusUid(firebaseUid: string): string {
  // Firebase UID는 이미 영숫자로 구성되어 있으나, 안전하게 정규화
  // 영숫자와 하이픈 이외의 문자를 제거하고 64자로 제한
  const normalized = firebaseUid
    .replace(/[^a-zA-Z0-9-]/g, '')
    .slice(0, 64);

  return normalized;
}
