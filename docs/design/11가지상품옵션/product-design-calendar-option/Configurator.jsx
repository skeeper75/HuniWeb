// Huni printing — PRODUCT_DESIGN CALENDAR_OPTION 디자인 캘린더 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper,
    Button, Callout, Badge, onAddToCart,
  } = C;

  /* ── 옵션 ── */
  const [size,  setSize]  = React.useState("s130x220");
  const [paper, setPaper] = React.useState("snow");
  const [page,  setPage]  = React.useState("30p");
  const [qty,   setQty]   = React.useState(20);
  const [envelope, setEnvelope] = React.useState("none");
  const [envQty,   setEnvQty]   = React.useState("");

  /* ── 가격 ── */
  const subtotal = 75000;
  const vat      = 7500;
  const total    = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  const sizeLabel = { s220x145: "220 x 145 mm", s130x220: "130 x 220 mm" }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* 상품명 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          캘린더 [디자인명]
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
            { value: "s220x145", label: "220 x 145 mm" },
            { value: "s130x220", label: "130 x 220 mm" },
          ]} />
      </OptionField>

      {/* 종이 */}
      <OptionField label="종이" info>
        <SelectBox value={paper} onChange={setPaper}
          badge={paper === "snow" ? <Badge tone="brand" size="md">추천</Badge> : null}
          options={[
            { value: "snow",       label: "스노우 200g" },
            { value: "montblanc",  label: "몽블랑 190g" },
            { value: "rendezvous", label: "랑데뷰 250g (+5,000원)" },
          ]} />
      </OptionField>

      {/* 페이지 */}
      <OptionField label="페이지">
        <SelectBox value={page} onChange={setPage}
          options={[
            { value: "14p", label: "14P (7개월)" },
            { value: "30p", label: "30P (13개월)" },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 캘린더봉투 */}
      <OptionField label="캘린더봉투">
        <SelectBox value={envelope} onChange={setEnvelope}
          options={[
            { value: "none", label: "없음" },
            { value: "env",  label: "캘린더봉투 240 x 230 mm 10장 (+1,100원)" },
          ]} />
      </OptionField>

      {/* 수량 */}
      <SelectBox value={envQty} onChange={setEnvQty}
        options={[
          { value: "",  label: "수량" },
          { value: "1", label: "1개" },
          { value: "2", label: "2개" },
          { value: "3", label: "3개" },
        ]} />

      <Divider />

      {/* 가격 요약 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        {[
          { label: `사양 : ${sizeLabel}, 몽블랑 190, 양면, ${page === "30p" ? "30P" : "14P"}, ${qty}ea`, amount: 50000 },
          { label: "가공 : 고리형트윈링제본", amount: 25000 },
          { label: `추가상품 : ${envelope === "none" ? "선택안함" : "캘린더봉투"}`, amount: envelope === "none" ? 0 : 1100 },
        ].map((item, i) => (
          <div key={i} style={{
            display: "flex", justifyContent: "space-between", alignItems: "baseline",
            padding: "6px 0",
          }}>
            <span style={{
              font: "var(--type-body)", fontSize: "var(--text-base)",
              color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)",
            }}>{item.label}</span>
            <span style={{
              font: "var(--type-body-strong)", fontSize: "var(--text-base)",
              color: "var(--text-heading)", letterSpacing: "var(--tracking-tight)",
              flexShrink: 0, marginLeft: 12,
            }}>{krw(item.amount)}</span>
          </div>
        ))}

        {/* 합계금액 */}
        <div style={{
          display: "flex", justifyContent: "space-between", alignItems: "center",
          marginTop: 12,
        }}>
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

      {/* 에디터 (디자인 캘린더는 에디터 전용) */}
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

window.DesignCalConfigurator = Configurator;
