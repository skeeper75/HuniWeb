// HuniCheckbox 컴포넌트 테스트
import { render, screen, fireEvent } from '@testing-library/react';
import { createRef } from 'react';
import { HuniCheckbox } from '../HuniCheckbox';

describe('HuniCheckbox', () => {
  it('renders unchecked state by default', () => {
    render(<HuniCheckbox data-testid="checkbox" />);
    const checkbox = screen.getByTestId('checkbox') as HTMLInputElement;
    expect(checkbox).not.toBeChecked();
  });

  it('renders checked state correctly', () => {
    render(<HuniCheckbox checked readOnly data-testid="checkbox" />);
    const checkbox = screen.getByTestId('checkbox') as HTMLInputElement;
    expect(checkbox).toBeChecked();
  });

  it('has correct size classes (w-5 h-5 = 20x20px)', () => {
    render(<HuniCheckbox data-testid="checkbox" />);
    const checkbox = screen.getByTestId('checkbox');
    expect(checkbox.className).toContain('w-5');
    expect(checkbox.className).toContain('h-5');
  });

  it('applies primary color for checked state', () => {
    render(<HuniCheckbox data-testid="checkbox" />);
    const checkbox = screen.getByTestId('checkbox');
    expect(checkbox.className).toContain('checked:bg-huni-primary');
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLInputElement>();
    render(<HuniCheckbox ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLInputElement);
    expect(ref.current?.type).toBe('checkbox');
  });

  it('renders disabled state correctly', () => {
    render(<HuniCheckbox disabled data-testid="checkbox" />);
    const checkbox = screen.getByTestId('checkbox');
    expect(checkbox).toBeDisabled();
  });

  it('calls onChange when clicked', () => {
    const handleChange = vi.fn();
    render(<HuniCheckbox onChange={handleChange} data-testid="checkbox" />);
    fireEvent.click(screen.getByTestId('checkbox'));
    expect(handleChange).toHaveBeenCalledTimes(1);
  });
});
