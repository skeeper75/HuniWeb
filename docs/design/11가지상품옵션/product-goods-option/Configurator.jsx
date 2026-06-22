// Huni printing — PRODUCT_GOODS_OPTION 굿즈/파우치 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper, Slider,
    ColorChip, Button, Callout, onAddToCart,
  } = C;

  const [size,   setSize]   = React.useState("s100x150");
  const [color,  setColor]  = React.useState("black");
  const [process, setProcess] = React.useState("label");
  const [qty,    setQty]    = React.useState(20);
  const [discIdx, setDiscIdx] = React.useState(1);
  const [chain,  setChain]  = React.useState("none");
  const [chainQty, setChainQty] = React.useState("");

  const subtotal = 75000, vat = 7500, total = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  const colorsRow1 = [
    { id: "white", color: "#F5F5F5" },
    { id: "gray",  color: "#D9D9D9" },
    { id: "black", color: "#000000" },
  ];
  const colorsRow2 = [
    { id: "blue",   color: "#3B17E0" },
    { id: "red",    color: "#FF0000" },
    { id: "black2", color: "#000000" },
    { id: "cyan",   color: "#0FB4F0" },
    { id: "green",  color: "#10A02A" },
    { id: "magenta",color: "#E512C8" },
    { id: "yellow", color: "#F5D915" },
  ];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          굿즈/파우치 상품명
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
            { value: "s73x68",  label: "73 x 68 mm" },
            { value: "s98x98",  label: "98 x 98 mm" },
            { value: "s100x150", label: "100 x 150 mm" },
          ]} />
      </OptionField>

      {/* 옵션 (색상) */}
      <OptionField label="옵션">
        <div style={{ display: "flex", flexDirection: "column", gap: 16, paddingTop: 6 }}>
          <div style={{ display: "flex", gap: 16 }}>
            {colorsRow1.map(c => (
              <GoodsColor key={c.id} color={c.color} selected={color === c.id} onClick={() => setColor(c.id)} />
            ))}
          </div>
          <div style={{ display: "flex", gap: 16, flexWrap: "wrap" }}>
            {colorsRow2.map(c => (
              <GoodsColor key={c.id} color={c.color} selected={color === c.id} onClick={() => setColor(c.id)} />
            ))}
          </div>
        </div>
      </OptionField>

      {/* 가공 */}
      <OptionField label="가공">
        <OptionButtonGroup columns={2} value={process} onChange={setProcess}
          options={[
            { value: "none",  label: "미방없음" },
            { value: "label", label: "라벨부착" },
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
            { value: "none",   label: "선택안함" },
            { value: "orange", label: "볼체인 (오렌지) 3개 1팩 (+1,000원)" },
            { value: "blue",   label: "볼체인 (블루) 3개 1팩 (+1,000원)" },
            { value: "pink",   label: "볼체인 (핑크) 3개 1팩 (+1,000원)" },
            { value: "black",  label: "볼체인 (블랙) 3개 1팩 (+1,000원)" },
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
          { label: `사양 : ${{s73x68:"73 x 68 mm",s98x98:"98 x 98 mm",s100x150:"100 x 150 mm"}[size]}, ${process === "label" ? "라벨부착" : "미방없음"}, ${qty}ea`, amount: 50000 },
          { label: "할인금액 : 6%off", amount: -25000 },
          { label: `추가상품 : ${chain === "none" ? "선택안함" : "볼체인"}`, amount: chain === "none" ? 0 : 1000 },
        ]} />

      {/* CTA */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="secondary" block leadingIcon={<UploadIcon />}>PDF파일 직접 올리기</Button>
        <Callout tone="muted" glyph="i">작업가이드 및 파일가이드 다운로드</Callout>
      </div>
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

/* ── 옵션 색상 원 (70×70, 라벨 없음) ── */
function GoodsColor({ color, selected, onClick }) {
  return (
    <button onClick={onClick} style={{
      width: 50, height: 50, borderRadius: "50%",
      background: color, border: "none", cursor: "pointer", padding: 0,
      boxShadow: selected ? "0 0 0 3px var(--huni-purple-600)" : "0 0 0 1px var(--huni-gray-200)",
    }} />
  );
}
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
function UploadIcon() { return <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M12 16V4m0 0L7 9m5-5l5 5M5 20h14" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>; }
function EditIcon() { return <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M4 20h4l10-10-4-4L4 16v4zM14 6l4 4" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/></svg>; }

window.GoodsConfigurator = Configurator;
