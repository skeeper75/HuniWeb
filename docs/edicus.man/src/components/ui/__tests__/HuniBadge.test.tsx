// HuniBadge 컴포넌트 테스트
import { render, screen } from '@testing-library/react';
import { HuniBadge } from '../HuniBadge';

describe('HuniBadge', () => {
  it('renders with default variant', () => {
    render(<HuniBadge>Default</HuniBadge>);
    const badge = screen.getByText('Default');
    expect(badge).toBeInTheDocument();
    expect(badge.className).toContain('bg-huni-primary-light-2');
    expect(badge.className).toContain('text-huni-primary');
  });

  it('renders success variant correctly', () => {
    render(<HuniBadge variant="success">Success</HuniBadge>);
    const badge = screen.getByText('Success');
    expect(badge.className).toContain('bg-green-100');
    expect(badge.className).toContain('text-green-700');
  });

  it('renders warning variant correctly', () => {
    render(<HuniBadge variant="warning">Warning</HuniBadge>);
    const badge = screen.getByText('Warning');
    expect(badge.className).toContain('bg-yellow-100');
    expect(badge.className).toContain('text-yellow-700');
  });

  it('renders danger variant correctly', () => {
    render(<HuniBadge variant="danger">Danger</HuniBadge>);
    const badge = screen.getByText('Danger');
    expect(badge.className).toContain('bg-red-100');
    expect(badge.className).toContain('text-red-700');
  });

  it('has correct displayName', () => {
    expect(HuniBadge.displayName).toBe('HuniBadge');
  });

  it('renders as span element', () => {
    render(<HuniBadge>Badge</HuniBadge>);
    const badge = screen.getByText('Badge');
    expect(badge.tagName).toBe('SPAN');
  });

  it('merges custom className', () => {
    render(<HuniBadge className="custom-badge">Custom</HuniBadge>);
    const badge = screen.getByText('Custom');
    expect(badge.className).toContain('custom-badge');
  });
});
