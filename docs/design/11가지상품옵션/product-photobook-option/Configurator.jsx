// Huni printing — PRODUCT_PHOTOBOOK_OPTION 포토북 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, QuantityStepper,
    Button, Callout, onAddToCart,
  } = C;

  /* ── 옵션 ── */
  const [size,  setSize]  = React.useState("s8x8");
  const [cover, setCover] = React.useState("hard");
  const [qty,   setQty]   = React.useState(20);

  /* ── 가격 (예시) ── */
  const subtotal = 75000;
  const vat      = 7500;
  const total    = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* 상품명 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          포토북 [디자인명]
        </h1>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          <Stars value={5} />
          <span style={{ font: "var(--type-body)", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>(44 Reviews)</span>
        </div>
        <p style={{ margin: 0, font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)", lineHeight: "var(--leading-normal)" }}>
          간략한 설명이 있다면 여기에
        </p>
      </div>

      <Divider />

      {/* 사이즈 */}
      <OptionField label="사이즈">
        <OptionButtonGroup columns={3} value={size} onChange={setSize}
          options={[
            { value: "a5",     label: "A5 (148 x 210 mm)" },
            { value: "a4",     label: "A4 (210 x 297 mm)" },
            { value: "s8x8",   label: "8x8 (200 x 200 mm)" },
            { value: "s10x10", label: "10x10 (250 x 250 mm)" },
          ]} />
      </OptionField>

      {/* 커버타입 */}
      <OptionField label="커버타입">
        <OptionButtonGroup columns={3} value={cover} onChange={setCover}
          options={[
            { value: "hard",        label: "하드커버" },
            { value: "soft",        label: "소프트커버", info: true },
            { value: "leatherHard", label: "레더하드커버", info: true },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={1} step={1} max={500} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 합계금액 */}
      <div style={{ display: "flex", flexDirection: "column" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
            <span style={{
              font: "var(--type-title)", fontSize: "var(--text-md)",
              fontWeight: "var(--weight-bold)", color: "var(--text-heading)",
              letterSpacing: "var(--tracking-tight)",
            }}>합계금액</span>
            <span style={{
              font: "var(--type-body)", fontSize: "var(--text-sm)",
              color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)",
            }}>상품가 {krw(subtotal)}원&nbsp;&nbsp;부가세 {krw(vat)}원</span>
          </div>
          <span style={{
            fontSize: 32, fontWeight: "var(--weight-bold)",
            color: "var(--huni-purple-600)", letterSpacing: "var(--tracking-tight)",
            lineHeight: 1,
          }}>{krw(total)}</span>
        </div>
        <div style={{ height: 1, background: "var(--huni-gray-100)", marginTop: 12 }} />
      </div>

      {/* 에디터 (포토북은 에디터 전용) */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="primary" block leadingIcon={<EditIcon />} onClick={() => onAddToCart(total)}>에디터로 디자인하기</Button>
        <Callout tone="muted" glyph="i">에디터 사용방법 보기</Callout>
      </div>

    </div>
  );
}

/* ── 헬퍼 ── */
function Divider() {
  return <div style={{ height: 1, background: "var(--huni-gray-100)" }} />;
}

function Stars({ value }) {
  return (
    <span style={{ display: "inline-flex", gap: 2 }}>
      {[0,1,2,3,4].map(i => (
        <svg key={i} width="20" height="20" viewBox="0 0 24 24"
          fill={i < Math.round(value) ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}>
          <path d="M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.8 5.9 20.4l1.4-6.8L2.2 9l6.9-.7L12 2z"/>
        </svg>
      ))}
    </span>
  );
}

function EditIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
      <path d="M4 20h4l10-10-4-4L4 16v4zM14 6l4 4"
        stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

window.PhotobookConfigurator = Configurator;
