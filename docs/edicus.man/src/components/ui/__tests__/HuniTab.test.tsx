// HuniTab 컴포넌트 테스트
import { render, screen, fireEvent } from '@testing-library/react';
import { createRef } from 'react';
import { HuniTab, type HuniTabItem } from '../HuniTab';

const mockTabs: HuniTabItem[] = [
  { value: 'tab1', label: '첫 번째 탭' },
  { value: 'tab2', label: '두 번째 탭' },
  { value: 'tab3', label: '세 번째 탭' },
];

describe('HuniTab', () => {
  it('renders inactive tab by default (no activeTab)', () => {
    render(<HuniTab tabs={mockTabs} />);
    const tabs = screen.getAllByRole('tab');
    // 모든 탭이 비활성 상태
    tabs.forEach((tab) => {
      expect(tab).toHaveAttribute('aria-selected', 'false');
    });
  });

  it('renders active tab with primary color and bottom border', () => {
    render(<HuniTab tabs={mockTabs} activeTab="tab1" />);
    const activeTab = screen.getByRole('tab', { name: '첫 번째 탭' });
    expect(activeTab).toHaveAttribute('aria-selected', 'true');
    expect(activeTab.className).toContain('border-huni-primary');
    expect(activeTab.className).toContain('text-huni-primary');
  });

  it('renders inactive tabs without primary color', () => {
    render(<HuniTab tabs={mockTabs} activeTab="tab1" />);
    const inactiveTab = screen.getByRole('tab', { name: '두 번째 탭' });
    expect(inactiveTab).toHaveAttribute('aria-selected', 'false');
    expect(inactiveTab.className).not.toContain('border-huni-primary');
    expect(inactiveTab.className).not.toContain('text-huni-primary');
  });

  it('calls onTabChange when tab is clicked', () => {
    const handleTabChange = vi.fn();
    render(<HuniTab tabs={mockTabs} onTabChange={handleTabChange} />);
    fireEvent.click(screen.getByRole('tab', { name: '두 번째 탭' }));
    expect(handleTabChange).toHaveBeenCalledWith('tab2');
  });

  it('renders all tabs', () => {
    render(<HuniTab tabs={mockTabs} />);
    expect(screen.getByRole('tab', { name: '첫 번째 탭' })).toBeInTheDocument();
    expect(screen.getByRole('tab', { name: '두 번째 탭' })).toBeInTheDocument();
    expect(screen.getByRole('tab', { name: '세 번째 탭' })).toBeInTheDocument();
  });

  it('has correct displayName', () => {
    expect(HuniTab.displayName).toBe('HuniTab');
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLDivElement>();
    render(<HuniTab tabs={mockTabs} ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLDivElement);
  });

  it('renders tablist role on container', () => {
    render(<HuniTab tabs={mockTabs} />);
    expect(screen.getByRole('tablist')).toBeInTheDocument();
  });
});
