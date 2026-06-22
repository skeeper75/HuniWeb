'use client';

// Firebase 인증 상태를 관리하는 React 훅
// 로그인 상태, Edicus 토큰, 관리자 권한을 통합 관리합니다
// @MX:ANCHOR: 인증 상태 관리 훅 - 로그인 관련 컴포넌트에서 호출
// @MX:REASON: login, logout, edicusToken이 다수의 페이지/컴포넌트에서 참조됨
import { useState, useEffect, useCallback } from 'react';
import type { User } from 'firebase/auth';
import {
  signInWithEmail,
  signUpWithEmail,
  signOutUser,
  onAuthChange,
  generateEdicusUid,
} from '@/lib/firebase/auth';

// useAuth 훅 반환 타입
export interface UseAuthReturn {
  // 현재 Firebase 사용자 (미로그인 시 null)
  user: User | null;
  // 인증 상태 초기 로딩 여부
  loading: boolean;
  // 인증 오류 메시지
  error: string | null;
  // Edicus API 토큰 (로그인 후 자동 발급)
  edicusToken: string | null;
  // 관리자 권한 여부 (Firebase 커스텀 클레임 기반)
  isAdmin: boolean;
  // 이메일/패스워드 로그인
  login: (email: string, password: string) => Promise<void>;
  // 이메일/패스워드 회원가입
  register: (email: string, password: string) => Promise<void>;
  // 로그아웃
  logout: () => Promise<void>;
}

// @MX:NOTE: Edicus 토큰은 Firebase 인증 상태 변경 후 /api/edicus/auth를 통해 자동 발급됩니다
// 토큰은 메모리에만 보관되며 localStorage에 저장하지 않습니다 (XSS 방지)
export function useAuth(): UseAuthReturn {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [edicusToken, setEdicusToken] = useState<string | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);

  // Firebase 인증 상태 변경 시 Edicus 토큰 발급
  const fetchEdicusToken = useCallback(async (firebaseUser: User): Promise<void> => {
    try {
      const edicusUid = generateEdicusUid(firebaseUser.uid);
      const response = await fetch('/api/edicus/auth', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ uid: edicusUid }),
      });

      if (!response.ok) {
        // Edicus 토큰 발급 실패는 치명적 오류가 아님 - 기록만 하고 계속 진행
        console.error('Edicus 토큰 발급 실패:', response.status);
        setEdicusToken(null);
        return;
      }

      const data = (await response.json()) as { token: string };
      setEdicusToken(data.token);
    } catch (err) {
      console.error('Edicus 토큰 요청 오류:', err);
      setEdicusToken(null);
    }
  }, []);

  // Firebase 인증 상태 변경 감지
  useEffect(() => {
    const unsubscribe = onAuthChange(async (firebaseUser) => {
      setUser(firebaseUser);

      if (firebaseUser) {
        // 커스텀 클레임에서 관리자 권한 확인
        const idTokenResult = await firebaseUser.getIdTokenResult();
        setIsAdmin(idTokenResult.claims['admin'] === true);

        // __session 쿠키 설정 (미들웨어 인증용)
        // Firebase ID 토큰을 쿠키에 저장하여 미들웨어에서 인증 상태 확인
        const idToken = await firebaseUser.getIdToken();
        document.cookie = `__session=${idToken}; path=/; SameSite=Strict; max-age=3600`;

        // Edicus 토큰 자동 발급
        await fetchEdicusToken(firebaseUser);
      } else {
        // 로그아웃 시 상태 초기화 및 쿠키 삭제
        setIsAdmin(false);
        setEdicusToken(null);
        document.cookie = '__session=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT';
      }

      setLoading(false);
    });

    return unsubscribe;
  }, [fetchEdicusToken]);

  // 이메일/패스워드 로그인
  const login = useCallback(async (email: string, password: string): Promise<void> => {
    setError(null);
    try {
      await signInWithEmail(email, password);
    } catch (err) {
      const message = err instanceof Error ? err.message : '로그인에 실패했습니다';
      setError(message);
      throw err;
    }
  }, []);

  // 이메일/패스워드 회원가입
  const register = useCallback(async (email: string, password: string): Promise<void> => {
    setError(null);
    try {
      await signUpWithEmail(email, password);
    } catch (err) {
      const message = err instanceof Error ? err.message : '회원가입에 실패했습니다';
      setError(message);
      throw err;
    }
  }, []);

  // 로그아웃
  const logout = useCallback(async (): Promise<void> => {
    setError(null);
    try {
      await signOutUser();
    } catch (err) {
      const message = err instanceof Error ? err.message : '로그아웃에 실패했습니다';
      setError(message);
      throw err;
    }
  }, []);

  return {
    user,
    loading,
    error,
    edicusToken,
    isAdmin,
    login,
    register,
    logout,
  };
}
