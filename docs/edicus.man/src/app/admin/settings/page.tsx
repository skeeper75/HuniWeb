'use client';

// 설정 페이지
// 일반/알림/보안 설정 + Custom CSS 섹션 포함
import { useState, useEffect } from 'react';
import { Settings, Bell, Shield, Globe, Code2, Check } from 'lucide-react';
import { CSS_PRESETS, type CssPreset } from '@/lib/edicus/custom-css';
import { HuniSelect } from '@/components/ui';

// 설정 섹션 정의 (기존)
const SETTING_SECTIONS = [
  {
    title: '일반 설정',
    icon: Globe,
    fields: ['사이트 이름', '사이트 URL', '기본 언어', '시간대'],
  },
  {
    title: '알림 설정',
    icon: Bell,
    fields: ['이메일 알림', '주문 알림', '배송 알림'],
  },
  {
    title: '보안 설정',
    icon: Shield,
    fields: ['2단계 인증', '세션 만료 시간', 'IP 허용 목록'],
  },
];

const PRESET_OPTIONS = Object.entries(CSS_PRESETS).map(([key, preset]: [string, CssPreset]) => ({
  key,
  name: preset.name,
  description: preset.description,
  css: preset.css,
}));

export default function SettingsPage() {
  const [cssValue, setCssValue] = useState('');
  const [selectedPreset, setSelectedPreset] = useState('default');
  const [isSaving, setIsSaving] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [showPreview, setShowPreview] = useState(false);

  const partner = process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip';

  // 현재 CSS 로드
  useEffect(() => {
    fetch(`/api/edicus/css?partner=${encodeURIComponent(partner)}`)
      .then(async (res) => {
        if (!res.ok) return;
        const data = (await res.json()) as { css: string };
        setCssValue(data.css ?? '');
      })
      .catch(console.error);
  }, [partner]);

  // 프리셋 선택 처리
  const handlePresetChange = (presetKey: string) => {
    setSelectedPreset(presetKey);
    const preset = CSS_PRESETS[presetKey];
    if (preset) {
      setCssValue(preset.css);
    }
  };

  // CSS 저장
  const handleSave = async () => {
    setIsSaving(true);
    setSaveError(null);
    setSaveSuccess(false);

    try {
      const res = await fetch('/api/edicus/css', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ partner, css: cssValue }),
      });

      if (!res.ok) throw new Error('저장에 실패했습니다');

      setSaveSuccess(true);
      setTimeout(() => setSaveSuccess(false), 3000);
    } catch (err: unknown) {
      setSaveError(err instanceof Error ? err.message : '저장 중 오류가 발생했습니다');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">설정</h1>
        <p className="mt-1 text-sm text-gray-500">Edicus Manager 시스템 설정을 관리합니다.</p>
      </div>

      {/* 준비 중 안내 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm p-12 text-center mb-5">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-gray-100">
          <Settings className="h-7 w-7 text-gray-600" aria-hidden="true" />
        </div>
        <h2 className="text-lg font-semibold text-gray-900 mb-2">시스템 설정</h2>
        <p className="text-sm text-gray-500 mb-1">준비 중입니다.</p>
        <p className="text-xs text-gray-400">
          일반, 알림, 보안 등 다양한 설정 기능이 제공될 예정입니다.
        </p>
      </div>

      {/* 기존 설정 섹션들 */}
      <div className="space-y-5">
        {SETTING_SECTIONS.map(({ title, icon: Icon, fields }) => (
          <div key={title} className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
              <Icon className="h-4 w-4 text-gray-400" aria-hidden="true" />
              <h2 className="text-sm font-semibold text-gray-900">{title}</h2>
            </div>
            <div className="p-5 space-y-4">
              {fields.map((field) => (
                <div key={field} className="flex items-center justify-between">
                  <label className="text-sm font-medium text-gray-400">{field}</label>
                  <div className="h-9 w-48 rounded-lg bg-gray-100 border border-gray-200" />
                </div>
              ))}
            </div>
          </div>
        ))}

        {/* Custom CSS 섹션 */}
        <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
          <div className="flex items-center gap-2 px-5 py-4 border-b border-gray-100">
            <Code2 className="h-4 w-4 text-gray-400" aria-hidden="true" />
            <h2 className="text-sm font-semibold text-gray-900">Custom CSS</h2>
            <span className="ml-auto text-xs text-gray-400">편집기 브랜딩 커스터마이징</span>
          </div>
          <div className="p-5 space-y-4">
            {/* 프리셋 선택 */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                프리셋 선택
              </label>
              <HuniSelect
                options={PRESET_OPTIONS.map(({ key, name, description }) => ({
                  value: key,
                  label: `${name} - ${description}`,
                }))}
                value={selectedPreset}
                onChange={handlePresetChange}
              />
            </div>

            {/* CSS 편집 텍스트에어리어 */}
            <div>
              <label
                htmlFor="custom-css-textarea"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                CSS 편집
              </label>
              <textarea
                id="custom-css-textarea"
                value={cssValue}
                onChange={(e) => setCssValue(e.target.value)}
                placeholder="/* 편집기에 적용할 CSS를 입력하세요 */&#10;:root { --theme-color: #0070f3; }"
                rows={10}
                className="w-full px-3 py-2.5 rounded-lg border border-gray-300 text-sm font-mono text-gray-700 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-huni-primary focus:border-transparent resize-y"
                spellCheck={false}
              />
              <p className="mt-1 text-xs text-gray-400">
                편집기 iframe 내부에 적용되는 CSS입니다. :root 변수를 활용하세요.
              </p>
            </div>

            {/* 오류 메시지 */}
            {saveError && (
              <div className="rounded-lg bg-red-50 border border-red-200 px-4 py-3">
                <p className="text-sm text-red-600">{saveError}</p>
              </div>
            )}

            {/* 성공 메시지 */}
            {saveSuccess && (
              <div className="rounded-lg bg-green-50 border border-green-200 px-4 py-3 flex items-center gap-2">
                <Check className="h-4 w-4 text-green-600" aria-hidden="true" />
                <p className="text-sm text-green-600">저장되었습니다.</p>
              </div>
            )}

            {/* 액션 버튼 */}
            <div className="flex items-center gap-3 pt-1">
              <button
                onClick={handleSave}
                disabled={isSaving}
                className={[
                  'px-4 py-2 text-sm font-semibold rounded-lg transition-colors',
                  isSaving
                    ? 'bg-huni-primary-secondary text-white cursor-not-allowed'
                    : 'bg-huni-primary text-white hover:bg-huni-primary-dark',
                ].join(' ')}
              >
                {isSaving ? '저장 중...' : '저장'}
              </button>

              <button
                onClick={() => setShowPreview((v) => !v)}
                className="px-4 py-2 text-sm font-semibold rounded-lg border border-gray-300 text-gray-700 hover:bg-gray-50 transition-colors"
              >
                {showPreview ? '미리보기 닫기' : '미리보기'}
              </button>
            </div>

            {/* CSS 미리보기 영역 */}
            {showPreview && (
              <div className="mt-4 rounded-lg border border-gray-200 overflow-hidden">
                <div className="px-4 py-2.5 bg-gray-100 border-b border-gray-200">
                  <p className="text-xs font-medium text-gray-600">편집기 프레임 미리보기</p>
                </div>
                <div className="p-4 bg-white min-h-[120px]">
                  <style
                    // dangerouslySetInnerHTML은 사용자가 직접 입력한 CSS 미리보기용으로만 사용
                    dangerouslySetInnerHTML={{ __html: cssValue }}
                  />
                  <div className="flex flex-col gap-2">
                    <div
                      className="h-8 rounded-md text-white text-xs flex items-center justify-center"
                      style={{ backgroundColor: 'var(--theme-color, #3b82f6)' }}
                    >
                      테마 색상 버튼 예시
                    </div>
                    <div className="h-8 rounded-md bg-gray-100 border text-xs flex items-center justify-center text-gray-500">
                      일반 요소 예시
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
