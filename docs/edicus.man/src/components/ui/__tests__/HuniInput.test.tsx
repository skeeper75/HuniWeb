// HuniInput 컴포넌트 테스트
import { render, screen, fireEvent } from '@testing-library/react';
import { createRef } from 'react';
import { HuniInput } from '../HuniInput';

describe('HuniInput', () => {
  it('renders with default state', () => {
    render(<HuniInput placeholder="Enter text" />);
    const input = screen.getByPlaceholderText('Enter text');
    expect(input).toBeInTheDocument();
  });

  it('has correct height class (h-11)', () => {
    render(<HuniInput data-testid="test-input" />);
    const input = screen.getByTestId('test-input');
    expect(input.className).toContain('h-11');
  });

  it('applies focus styles', () => {
    render(<HuniInput data-testid="test-input" />);
    const input = screen.getByTestId('test-input');
    expect(input.className).toContain('focus:ring-2');
    expect(input.className).toContain('focus:ring-huni-primary');
  });

  it('renders disabled state correctly', () => {
    render(<HuniInput disabled data-testid="test-input" />);
    const input = screen.getByTestId('test-input');
    expect(input).toBeDisabled();
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLInputElement>();
    render(<HuniInput ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLInputElement);
  });

  it('accepts user input', () => {
    render(<HuniInput data-testid="test-input" />);
    const input = screen.getByTestId('test-input') as HTMLInputElement;
    fireEvent.change(input, { target: { value: 'test value' } });
    expect(input.value).toBe('test value');
  });

  it('merges custom className', () => {
    render(<HuniInput className="custom-class" data-testid="test-input" />);
    const input = screen.getByTestId('test-input');
    expect(input.className).toContain('custom-class');
  });
});
