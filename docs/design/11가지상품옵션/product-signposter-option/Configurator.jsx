// Huni printing — PRODUCT_SIGN-POSTER_OPTION 실사/사인 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper, TextField,
    Button, Callout, Badge, onAddToCart,
  } = C;

  const [size,   setSize]   = React.useState("a1");
  const [customW, setCustomW] = React.useState("");
  const [customH, setCustomH] = React.useState("");
  const [paper,  setPaper]  = React.useState("snow");
  const [spotW,  setSpotW]  = React.useState("none");
  const [coat,   setCoat]   = React.useState("none");
  const [process, setProcess] = React.useState("overlock");
  const [extra,  setExtra]   = React.useState("none");
  const [qty,    setQty]    = React.useState(20);

  const subtotal = 75000, vat = 7500, total = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");
  const sizeLabel = { a3: "A3 (297 x 420 mm)", a2: "A2 (420 x 594 mm)", a1: "A1 (594 x 841 mm)", custom: `${customW} x ${customH} mm` }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          실사/사인 상품명
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
            { value: "a3",     label: "A3 (297 x 420 mm)" },
            { value: "a2",     label: "A2 (420 x 594 mm)" },
            { value: "a1",     label: "A1 (594 x 841 mm)" },
            { value: "custom", label: "직접입력" },
          ]} />
      </OptionField>

      {/* 직접입력 */}
      <OptionField label="직접입력">
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          <TextField value={customW} onChange={setCustomW} placeholder="가로크기" align="center" />
          <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
          <TextField value={customH} onChange={setCustomH} placeholder="세로크기" align="center" />
        </div>
        <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
          가로 200 ~ 1200 mm / 세로 200 ~ 3000 mm
        </p>
      </OptionField>

      {/* 소재 */}
      <OptionField label="소재" info>
        <SelectBox value={paper} onChange={setPaper}
          badge={paper === "snow" ? <Badge tone="brand" size="md">추천</Badge> : null}
          options={[
            { value: "snow",   label: "스노우 200g" },
            { value: "pet",    label: "유포지 (방수, +6,000원)" },
            { value: "banner", label: "현수막 원단 (+12,000원)" },
          ]} />
      </OptionField>

      {/* 별색인쇄 (화이트) */}
      <OptionField label="별색인쇄 (화이트)">
        <OptionButtonGroup columns={2} value={spotW} onChange={setSpotW}
          options={[
            { value: "none",   label: "화이트인쇄(없음)" },
            { value: "single", label: "화이트인쇄(단면)" },
          ]} />
      </OptionField>

      {/* 코팅 */}
      <OptionField label="코팅">
        <OptionButtonGroup columns={3} value={coat} onChange={setCoat}
          options={[
            { value: "none",  label: "코팅없음" },
            { value: "matt",  label: "무광코팅" },
            { value: "gloss", label: "유광코팅" },
          ]} />
      </OptionField>

      {/* 가공 */}
      <OptionField label="가공">
        <OptionButtonGroup columns={3} value={process} onChange={setProcess}
          options={[
            { value: "overlock",    label: "오버로크" },
            { value: "overlockRibbon", label: "오버로크+리본끕" },
            { value: "roll",        label: "말아박기" },
          ]} />
      </OptionField>

      {/* 추가 */}
      <OptionField label="추가">
        <OptionButtonGroup columns={3} value={extra} onChange={setExtra}
          options={[
            { value: "none",    label: "거치대없음" },
            { value: "indoor",  label: "실내용 배너거치대" },
            { value: "outdoor", label: "실외용 배너거치대" },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={1} step={1} max={500} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 가격 요약 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        {[
          { label: `사양 : ${sizeLabel}, 스노우 200, ${spotW === "none" ? "화이트없음" : "화이트단면"}, ${qty}ea`, amount: 50000 },
          { label: "추가상품 : 선택안함", amount: 25000 },
        ].map((item, i) => (
          <div key={i} style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", padding: "6px 0" }}>
            <span style={{ font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)" }}>{item.label}</span>
            <span style={{ font: "var(--type-body-strong)", fontSize: "var(--text-base)", color: "var(--text-heading)", letterSpacing: "var(--tracking-tight)", flexShrink: 0, marginLeft: 12 }}>{krw(item.amount)}</span>
          </div>
        ))}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 12 }}>
          <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
            <span style={{ font: "var(--type-title)", fontSize: "var(--text-md)", fontWeight: "var(--weight-bold)", color: "var(--text-heading)", letterSpacing: "var(--tracking-tight)" }}>합계금액</span>
            <span style={{ font: "var(--type-body)", fontSize: "var(--text-sm)", color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)" }}>상품가 {krw(subtotal)}원&nbsp;&nbsp;부가세 {krw(vat)}원</span>
          </div>
          <span style={{ fontSize: 32, fontWeight: "var(--weight-bold)", color: "var(--huni-purple-600)", letterSpacing: "var(--tracking-tight)", lineHeight: 1 }}>{krw(total)}</span>
        </div>
        <div style={{ height: 1, background: "var(--huni-gray-100)", marginTop: 12 }} />
      </div>

      {/* PDF 업로드 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="secondary" block leadingIcon={<UploadIcon />} onClick={() => onAddToCart(total)}>PDF파일 직접 올리기</Button>
        <Callout tone="muted" glyph="i">작업가이드 및 파일가이드 다운로드</Callout>
      </div>
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
function UploadIcon() {
  return <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M12 16V4m0 0L7 9m5-5l5 5M5 20h14" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>;
}

window.SignConfigurator = Configurator;
