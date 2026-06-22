// Firebase 클라이언트 SDK 초기화
// 환경 변수에서 Firebase 설정을 로드하여 앱과 인증 인스턴스를 초기화합니다
// @MX:ANCHOR: Firebase 앱 초기화 - auth.ts, useAuth.ts 등에서 참조
// @MX:REASON: app, auth 인스턴스가 다수의 Firebase 관련 모듈에서 공유됨
import { initializeApp, getApps, type FirebaseApp } from 'firebase/app';
import { getAuth, type Auth } from 'firebase/auth';

// Firebase 프로젝트 설정
// NEXT_PUBLIC_ 접두사: 클라이언트에 안전하게 노출되는 공개 설정값
const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.NEXT_PUBLIC_FIREBASE_DATABASE_URL,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
};

// Firebase 앱 인스턴스 (중복 초기화 방지)
// Next.js HMR에서 앱이 여러 번 초기화되지 않도록 getApps()로 확인
const app: FirebaseApp =
  getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0]!;

// Firebase Auth 인스턴스
const auth: Auth = getAuth(app);

export { app, auth };
