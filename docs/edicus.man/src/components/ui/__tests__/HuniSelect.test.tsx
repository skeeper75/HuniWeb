// HuniSelect 컴포넌트 테스트 - RULE-1: 네이티브 select 사용 금지 검증
import { render, screen, fireEvent } from '@testing-library/react';
import { createRef } from 'react';
import { HuniSelect, type SelectOption } from '../HuniSelect';

const mockOptions: SelectOption[] = [
  { value: 'opt1', label: '옵션 1' },
  { value: 'opt2', label: '옵션 2' },
  { value: 'opt3', label: '옵션 3' },
];

describe('HuniSelect', () => {
  it('renders as custom component (not native select element)', () => {
    const { container } = render(
      <HuniSelect options={mockOptions} />
    );
    // RULE-1: 네이티브 <select> 요소가 존재하지 않아야 함
    const nativeSelect = container.querySelector('select');
    expect(nativeSelect).toBeNull();
  });

  it('renders trigger button with correct caret symbol', () => {
    render(<HuniSelect options={mockOptions} />);
    const trigger = screen.getByRole('button');
    // ▼ 캐럿 문자 (HTML entity &#9660;) 확인
    expect(trigger.textContent).toContain('▼');
  });

  it('shows dropdown options on click', () => {
    render(<HuniSelect options={mockOptions} />);
    const trigger = screen.getByRole('button');

    // 드롭다운이 처음에는 닫혀 있어야 함
    expect(screen.queryByRole('listbox')).toBeNull();

    // 클릭 시 드롭다운 열림
    fireEvent.click(trigger);
    expect(screen.getByRole('listbox')).toBeInTheDocument();
    expect(screen.getByText('옵션 1')).toBeInTheDocument();
    expect(screen.getByText('옵션 2')).toBeInTheDocument();
  });

  it('calls onChange when option is selected', () => {
    const handleChange = vi.fn();
    render(
      <HuniSelect options={mockOptions} onChange={handleChange} />
    );

    fireEvent.click(screen.getByRole('button'));
    fireEvent.click(screen.getByText('옵션 1'));
    expect(handleChange).toHaveBeenCalledWith('opt1');
  });

  it('closes dropdown after selection', () => {
    render(<HuniSelect options={mockOptions} />);
    fireEvent.click(screen.getByRole('button'));
    fireEvent.click(screen.getByText('옵션 1'));
    expect(screen.queryByRole('listbox')).toBeNull();
  });

  it('shows placeholder when no value is selected', () => {
    render(<HuniSelect options={mockOptions} placeholder="선택하세요" />);
    expect(screen.getByText('선택하세요')).toBeInTheDocument();
  });

  it('shows selected option label', () => {
    render(<HuniSelect options={mockOptions} value="opt2" />);
    expect(screen.getByText('옵션 2')).toBeInTheDocument();
  });

  it('renders disabled state correctly', () => {
    render(<HuniSelect options={mockOptions} disabled />);
    const trigger = screen.getByRole('button');
    expect(trigger).toBeDisabled();
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLDivElement>();
    render(<HuniSelect options={mockOptions} ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLDivElement);
  });

  it('has correct displayName', () => {
    expect(HuniSelect.displayName).toBe('HuniSelect');
  });

  it('RULE-1: no <select> HTML element in rendered output', () => {
    const { container } = render(
      <HuniSelect options={mockOptions} value="opt1" />
    );
    // RULE-1 명시적 검증 - 어떠한 경우에도 <select> 요소 존재 불가
    expect(container.querySelectorAll('select')).toHaveLength(0);
  });
});
