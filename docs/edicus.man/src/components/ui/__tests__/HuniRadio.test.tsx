// HuniRadio 컴포넌트 테스트
import { render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { HuniRadio } from '../HuniRadio';

describe('HuniRadio', () => {
  it('renders unselected state by default', () => {
    render(<HuniRadio data-testid="radio" />);
    const radio = screen.getByTestId('radio') as HTMLInputElement;
    expect(radio).not.toBeChecked();
  });

  it('renders selected state correctly', () => {
    render(<HuniRadio checked readOnly data-testid="radio" />);
    const radio = screen.getByTestId('radio') as HTMLInputElement;
    expect(radio).toBeChecked();
  });

  it('has correct size classes (w-5 h-5 = 20x20px)', () => {
    render(<HuniRadio data-testid="radio" />);
    const radio = screen.getByTestId('radio');
    expect(radio.className).toContain('w-5');
    expect(radio.className).toContain('h-5');
  });

  it('is rendered as radio input type', () => {
    render(<HuniRadio data-testid="radio" />);
    const radio = screen.getByTestId('radio') as HTMLInputElement;
    expect(radio.type).toBe('radio');
  });

  it('forwards ref correctly', () => {
    const ref = createRef<HTMLInputElement>();
    render(<HuniRadio ref={ref} />);
    expect(ref.current).toBeInstanceOf(HTMLInputElement);
    expect(ref.current?.type).toBe('radio');
  });

  it('renders disabled state correctly', () => {
    render(<HuniRadio disabled data-testid="radio" />);
    const radio = screen.getByTestId('radio');
    expect(radio).toBeDisabled();
  });

  it('renders within a radio group correctly', () => {
    render(
      <>
        <HuniRadio name="group" value="a" data-testid="radio-a" />
        <HuniRadio name="group" value="b" data-testid="radio-b" />
      </>
    );
    expect(screen.getByTestId('radio-a')).toBeInTheDocument();
    expect(screen.getByTestId('radio-b')).toBeInTheDocument();
  });
});
