import type { Metadata } from 'next';
import { MessageSquare, Send } from 'lucide-react';

export const metadata: Metadata = {
  title: 'SMS 설정',
};

export default function SmsPage() {
  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">SMS 설정</h1>
        <p className="mt-1 text-sm text-gray-500">SMS 알림 및 발송 설정을 관리합니다.</p>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center mb-5">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-green-50">
          <MessageSquare className="h-7 w-7 text-green-600" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">SMS 알림</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">
          주문 접수, 배송 출발, 완료 알림 등 자동 SMS 발송 기능이 제공될 예정입니다.
        </p>
      </div>

      {/* SMS 설정 폼 스켈레톤 */}
      <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
        {/* 발신번호 설정 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
            <h2 className="text-sm font-semibold text-gray-900">발신번호 설정</h2>
          </div>
          <div className="p-5 space-y-4">
            {['발신번호', 'API 키', '비밀 키'].map((label) => (
              <div key={label}>
                <label className="block text-xs font-medium text-gray-400 mb-1">{label}</label>
                <div className="h-9 rounded-lg bg-gray-100 border border-gray-200" />
              </div>
            ))}
          </div>
        </div>

        {/* 템플릿 설정 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
            <Send className="h-4 w-4 text-gray-400" aria-hidden="true" />
            <h2 className="text-sm font-semibold text-gray-900">알림 템플릿</h2>
          </div>
          <div className="p-5 space-y-4">
            {['주문 접수', '배송 출발', '배송 완료'].map((label) => (
              <div key={label}>
                <label className="block text-xs font-medium text-gray-400 mb-1">
                  {label} 메시지
                </label>
                <div className="h-16 rounded-lg bg-gray-100 border border-gray-200" />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
