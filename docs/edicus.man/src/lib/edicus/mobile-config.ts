// 모바일 SDK 설정 모듈
// 모바일/데스크탑 편집기 초기화 설정을 제공합니다
// @MX:NOTE: [AUTO] 파트너별 private_css를 getCssForPartner()에서 자동 로드
// @MX:SPEC: SPEC-CSS-001
import { getCssForPartner } from './custom-css';

// 모바일 편집기 설정 타입
export interface MobileEditorConfig {
  mobile: boolean;
  lang: string;
  ui_locale: string;
  private_css?: string;
  parent_type?: string;
  ui_style?: string;
}

// 데스크탑 편집기 설정 타입
export interface DesktopEditorConfig {
  mobile: false;
  private_css?: string;
}

/**
 * 파트너에 맞는 모바일 SDK 설정을 반환합니다.
 *
 * @MX:NOTE: 모바일 모드는 편집기 UI를 터치 친화적으로 전환합니다
 */
export function getMobileConfig(partner: string): MobileEditorConfig {
  // 파트너별 커스텀 설정
  const partnerDefaults: Record<string, Partial<MobileEditorConfig>> = {
    hunip: {
      lang: 'ko',
      ui_locale: 'ko',
    },
    red: {
      lang: 'ko',
      ui_locale: 'ko',
      parent_type: 'web_in_app',
    },
  };

  const partnerConfig = partnerDefaults[partner] ?? {};

  // 파트너별 CSS 자동 로드
  const partnerCss = getCssForPartner(partner);

  return {
    mobile: true,
    lang: 'ko',
    ui_locale: 'ko',
    ...partnerConfig,
    ...(partnerCss ? { private_css: partnerCss } : {}),
  };
}

/**
 * 파트너에 맞는 데스크탑 SDK 설정을 반환합니다.
 */
export function getDesktopConfig(partner: string): DesktopEditorConfig {
  const partnerCss = getCssForPartner(partner);

  return {
    mobile: false,
    ...(partnerCss ? { private_css: partnerCss } : {}),
  };
}
