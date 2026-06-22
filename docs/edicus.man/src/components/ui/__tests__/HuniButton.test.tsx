// HuniButton 컴포넌트 테스트
import { render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { HuniButton } from '../HuniButton';

describe('HuniButton', () => {
  it('renders with primary variant by default', () => {
    render(<HuniButton>Click me</HuniButton>);
    const button = screen.getByRole('button', { name: 'Click me' });
    expect(button).toBeInTheDocument();
    expect(button.className).toContain('bg-huni-primary');
  });

  it('renders outline variant correctly', () => {
    render(<HuniButton variant="outline">Outline</HuniButton>);
    const button = screen.getByRole('button', { name: 'Outline' });
    expect(button.className).toContain('border-huni-primary');
    // outline variant는 solid bg-huni-primary가 아닌 bg-transparent 사용
    expect(button.className).toContain('bg-transparent');
    expect(button.className).not.toContain('text-white');
  });

  it('renders small variant correctly', () => {
    render(<HuniButton size="sm">Small</HuniButton>);
    const button = screen.getByRole('button', { name: 'Small' });
    expect(button.className).toContain('h-8');
  });

  it('renders disabled state correctly', () => {
    render(<HuniButton disabled>Disabled</HuniButton>);
    const button = screen.getByRole('button', { name: 'Disabled' });
    expect(button).toBeDisabled();
    expect(button.className).toContain('disabled:opacity-50');
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLButtonElement>();
    render(<HuniButton ref={ref}>Ref Test</HuniButton>);
    expect(ref.current).toBeInstanceOf(HTMLButtonElement);
  });

  it('has correct displayName', () => {
    expect(HuniButton.displayName).toBe('HuniButton');
  });

  it('applies primary color classes', () => {
    render(<HuniButton>Primary Colors</HuniButton>);
    const button = screen.getByRole('button');
    expect(button.className).toMatch(/huni-primary/);
  });

  it('passes additional props to button element', () => {
    render(<HuniButton type="submit" data-testid="submit-btn">Submit</HuniButton>);
    const button = screen.getByTestId('submit-btn');
    expect(button).toHaveAttribute('type', 'submit');
  });
});
