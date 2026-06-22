// Huni printing — PRODUCT_ACCESSORIES_OPTION 액세서리 (피그마 원본 기반)
function Configurator(C) {
  const { OptionField, OptionButtonGroup, QuantityStepper, Button, onAddToCart } = C;

  const [size, setSize] = React.useState("s80x100");
  const [qty,  setQty]  = React.useState(20);

  const subtotal = 75000, vat = 7500, total = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          액세서리 상품명
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
        <OptionButtonGroup columns={2} value={size} onChange={setSize}
          options={[
            { value: "s70x200", label: "70 x 200 mm (50입)" },
            { value: "s80x100", label: "80 x 100 mm (50입)" },
          ]} />
      </OptionField>

      {/* 수량 */}
      <OptionField label="수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 합계금액 */}
      <div style={{ display: "flex", flexDirection: "column" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
            <span style={{ font: "var(--type-title)", fontSize: "var(--text-md)", fontWeight: "var(--weight-bold)", color: "var(--text-heading)", letterSpacing: "var(--tracking-tight)" }}>합계금액</span>
            <span style={{ font: "var(--type-body)", fontSize: "var(--text-sm)", color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)" }}>상품가 {krw(subtotal)}원&nbsp;&nbsp;부가세 {krw(vat)}원</span>
          </div>
          <span style={{ fontSize: 32, fontWeight: "var(--weight-bold)", color: "var(--huni-purple-600)", letterSpacing: "var(--tracking-tight)", lineHeight: 1 }}>{krw(total)}</span>
        </div>
      </div>

      {/* 장바구니 */}
      <Button variant="primary" block size="md" style={{ height: 56, fontSize: "var(--text-md)" }} onClick={() => onAddToCart(total)}>
        장바구니 담기
      </Button>
    </div>
  );
}

function Divider() { return <div style={{ height: 1, background: "var(--huni-gray-100)" }} />; }
function Stars({ value }) {
  return (
    <span style={{ display: "inline-flex", gap: 2 }}>
      {[0,1,2,3,4].map(i => (
        <svg key={i} width="20" height="20" viewBox="0 0 24 24" fill={i < Math.round(value) ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}>
          <path d="M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.8 5.9 20.4l1.4-6.8L2.2 9l6.9-.7L12 2z"/>
        </svg>
      ))}
    </span>
  );
}

window.AccessoryConfigurator = Configurator;
