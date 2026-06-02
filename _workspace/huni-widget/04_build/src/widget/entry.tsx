// 위젯 런타임 청크 진입점 — loader 가 동적 import 하는 모듈.
// 기본 BFF 는 stub(Red 어댑터+fixture). 실 BFF 주입 시 createWidgetRoot 의 bff 옵션 교체.
import { mountWidget, type MountOptions, type MountedWidget } from './shadow/mount';
import { StubBffClient } from '@/bff/stub';
import type { BffClient } from '@/bff/client';
import type { NormalizedCartHandoff } from '@/contract';

export interface CreateWidgetOptions {
  productCode: string;
  locale?: string;
  deviceType?: 'pc' | 'mobile';
  memberTier?: string;
  // 데이터 소스 토글: 미지정 시 fixture stub. 실 BFF 는 HTTP BffClient 주입.
  bff?: BffClient;
  onCartHandoff?: (p: NormalizedCartHandoff) => void;
  onPriceChange?: (p: import('@/contract').NormalizedPriceBreakdown) => void;
}

export function createWidgetRoot(host: HTMLElement, opts: CreateWidgetOptions): MountedWidget {
  const bff = opts.bff ?? new StubBffClient();
  const mountOpts: MountOptions = {
    productCode: opts.productCode,
    bff,
    locale: opts.locale,
    deviceType: opts.deviceType,
    memberTier: opts.memberTier,
    onCartHandoff: opts.onCartHandoff,
    onPriceChange: opts.onPriceChange,
  };
  return mountWidget(host, mountOpts);
}

export { mountWidget };
export type { MountedWidget };
