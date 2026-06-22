// Huni printing — PRODUCT_ARRYLIC_OPTION 아크릴 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper, Slider, TextField,
    Button, Callout, onAddToCart,
  } = C;

  const [size,   setSize]   = React.useState("s30x40");
  const [customW, setCustomW] = React.useState("");
  const [customH, setCustomH] = React.useState("");
  const [material, setMaterial] = React.useState("clear3");
  const [pieces, setPieces] = React.useState("5");
  const [process, setProcess] = React.useState("none");
  const [qty,    setQty]    = React.useState(20);
  const [discIdx, setDiscIdx] = React.useState(1);
  const [chain,  setChain]  = React.useState("none");
  const [chainQty, setChainQty] = React.useState("");

  const subtotal = 75000, vat = 7500, total = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");
  const sizeLabel = { s20x30: "20 x 30 mm", s30x30: "30 x 30 mm", s30x40: "30 x 40 mm", s95x210: "95 x 210 mm", s110x170: "110 x 170 mm", s148x210: "148 x 210 mm", s135x135: "135 x 135 mm" }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          아크릴 상품명
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
            { value: "s20x30",  label: "20 x 30 mm" },
            { value: "s30x30",  label: "30 x 30 mm" },
            { value: "s30x40",  label: "30 x 40 mm" },
            { value: "s95x210", label: "95 x 210 mm" },
            { value: "s110x170", label: "110 x 170 mm" },
            { value: "s148x210", label: "148 x 210 mm" },
            { value: "s135x135", label: "135 x 135 mm" },
          ]} />
      </OptionField>

      {/* 크기 직접입력 */}
      <OptionField label="크기 직접입력">
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          <TextField value={customW} onChange={setCustomW} placeholder="가로크기" align="center" />
          <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
          <TextField value={customH} onChange={setCustomH} placeholder="세로크기" align="center" />
        </div>
        <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
          가로 30 ~ 125 mm / 세로 30 ~ 170 mm
        </p>
      </OptionField>

      {/* 소재 */}
      <OptionField label="소재">
        <OptionButtonGroup columns={2} value={material} onChange={setMaterial}
          options={[
            { value: "clear3", label: "투명아크릴 3mm" },
          ]} />
      </OptionField>

      {/* 조각수 */}
      <OptionField label="조각수" info>
        <SelectBox value={pieces} onChange={setPieces}
          options={[
            { value: "1",  label: "1조각" },
            { value: "3",  label: "3조각" },
            { value: "5",  label: "5조각" },
            { value: "10", label: "10조각" },
          ]} />
      </OptionField>

      {/* 가공 */}
      <OptionField label="가공">
        <OptionButtonGroup columns={3} value={process} onChange={setProcess}
          options={[
            { value: "none",   label: "고리없음" },
            { value: "silver", label: "은색고리" },
            { value: "gold",   label: "금색고리" },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      {/* 구간할인 */}
      <DiscountSlider Slider={Slider} index={discIdx} onChange={setDiscIdx} />

      <Divider />

      {/* 볼체인 */}
      <OptionField label="볼체인">
        <SelectBox value={chain} onChange={setChain}
          options={[
            { value: "none",   label: "없음" },
            { value: "orange", label: "볼체인 오렌지 3개 1팩 (+1,000원)" },
            { value: "blue",   label: "볼체인 블루 3개 1팩 (+1,000원)" },
            { value: "black",  label: "볼체인 블랙 3개 1팩 (+1,000원)" },
          ]} />
      </OptionField>

      {/* 수량 */}
      <SelectBox value={chainQty} onChange={setChainQty}
        options={[
          { value: "",  label: "수량" },
          { value: "1", label: "1개" },
          { value: "2", label: "2개" },
          { value: "3", label: "3개" },
        ]} />

      <Divider />

      {/* 가격 요약 */}
      <PriceBlock krw={krw} subtotal={subtotal} vat={vat} total={total}
        items={[
          { label: `사양 : ${sizeLabel}, 투명아크릴 3mm, ${process === "none" ? "고리없음" : "고리"}, ${qty}ea`, amount: 50000 },
          { label: "할인구간 : 6%off", amount: -25000 },
          { label: `추가상품 : ${chain === "none" ? "선택안함" : "볼체인"}`, amount: chain === "none" ? 0 : 1000 },
        ]} />

      {/* CTA */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="primary" block leadingIcon={<EditIcon />} onClick={() => onAddToCart(total)}>에디터로 디자인하기</Button>
        <Callout tone="muted" glyph="i">에디터 사용방법 보기</Callout>
      </div>
    </div>
  );
}

function DiscountSlider({ Slider, index, onChange }) {
  return (
    <div style={{ background: "var(--huni-gray-50, #FAFAFA)", border: "1px solid var(--huni-gray-100)", borderRadius: "var(--radius-lg)", padding: 20 }}>
      <div style={{ font: "var(--type-body-strong)", fontSize: "var(--text-base)", color: "var(--text-heading)", marginBottom: 16 }}>제작수량별 구간할인</div>
      <Slider stops={["1","10","50","100","500","1000+"]} index={index} onChange={onChange} />
      <p style={{ margin: "14px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)", lineHeight: "var(--leading-normal)" }}>
        할인적용단가 : <strong style={{ color: "var(--huni-purple-600)" }}>3,200 6%off</strong><br/>
        제작수량에 따라 할인율이 적용되어 자동계산됩니다.
      </p>
    </div>
  );
}

function PriceBlock({ krw, subtotal, vat, total, items }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
      {items.map((item, i) => (
        <div key={i} style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", padding: "6px 0" }}>
          <span style={{ font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)" }}>{item.label}</span>
          <span style={{ font: "var(--type-body-strong)", fontSize: "var(--text-base)", color: "var(--text-heading)", letterSpacing: "var(--tracking-tight)", flexShrink: 0, marginLeft: 12 }}>{item.amount < 0 ? "- " + krw(-item.amount) : krw(item.amount)}</span>
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
function EditIcon() { return <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M4 20h4l10-10-4-4L4 16v4zM14 6l4 4" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>; }

window.ArrylicConfigurator = Configurator;
