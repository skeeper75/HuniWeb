// HuniCard 컴포넌트 테스트
import { render, screen } from '@testing-library/react';
import { HuniCard, HuniCardHeader, HuniCardContent } from '../HuniCard';

describe('HuniCard', () => {
  it('renders with default padding (p-6)', () => {
    render(<HuniCard data-testid="card">Card content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card).toBeInTheDocument();
    expect(card.className).toContain('p-6');
  });

  it('renders with sm padding variant (p-4)', () => {
    render(<HuniCard padding="sm" data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.className).toContain('p-4');
  });

  it('applies rounded-lg class', () => {
    render(<HuniCard data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.className).toContain('rounded-lg');
  });

  it('applies shadow-sm class', () => {
    render(<HuniCard data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.className).toContain('shadow-sm');
  });

  it('has white background', () => {
    render(<HuniCard data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.className).toContain('bg-white');
  });

  it('renders children correctly', () => {
    render(<HuniCard>Card content here</HuniCard>);
    expect(screen.getByText('Card content here')).toBeInTheDocument();
  });

  it('renders as div element', () => {
    render(<HuniCard data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.tagName).toBe('DIV');
  });

  it('merges custom className', () => {
    render(<HuniCard className="custom-card" data-testid="card">Content</HuniCard>);
    const card = screen.getByTestId('card');
    expect(card.className).toContain('custom-card');
  });
});

describe('HuniCardHeader', () => {
  it('renders correctly', () => {
    render(<HuniCardHeader data-testid="header">Header</HuniCardHeader>);
    const header = screen.getByTestId('header');
    expect(header).toBeInTheDocument();
    expect(header.className).toContain('mb-4');
  });

  it('has correct displayName', () => {
    expect(HuniCardHeader.displayName).toBe('HuniCardHeader');
  });
});

describe('HuniCardContent', () => {
  it('renders correctly', () => {
    render(<HuniCardContent data-testid="content">Content text</HuniCardContent>);
    const content = screen.getByTestId('content');
    expect(content).toBeInTheDocument();
    expect(content.className).toContain('text-sm');
  });

  it('has correct displayName', () => {
    expect(HuniCardContent.displayName).toBe('HuniCardContent');
  });
});
