// Huni printing — PRODUCT_BOOK_OPTION 책자 (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper,
    ColorChip, FinishSection, Button, Callout, TextField, Badge,
    onAddToCart,
  } = C;

  /* ── 기본 옵션 ── */
  const [size,    setSize]    = React.useState("a4");
  const [bind,    setBind]    = React.useState("wireless");
  const [bindDir, setBindDir] = React.useState("top");      // 좌철 / 상철
  const [ringColor, setRingColor] = React.useState("silver");
  const [ring,    setRing]    = React.useState("r1");
  const [endpaper, setEndpaper] = React.useState("white");  // 면지
  const [qty,     setQty]     = React.useState(20);

  /* ── 내지 ── */
  const [innerPaper, setInnerPaper] = React.useState("montblanc");
  const [innerPrint, setInnerPrint] = React.useState("double");
  const [pages,      setPages]      = React.useState(8);

  /* ── 표지 ── */
  const [coverPaper, setCoverPaper] = React.useState("montblanc");
  const [coverPrint, setCoverPrint] = React.useState("double");
  const [coverCoat,  setCoverCoat]  = React.useState("none");
  const [clearCover, setClearCover] = React.useState("none");

  /* ── 박,형압 가공 ── */
  const [foilOpen,  setFoilOpen]  = React.useState(true);
  const [foilOn,    setFoilOn]    = React.useState("on");
  const [foilW,     setFoilW]     = React.useState("");
  const [foilH,     setFoilH]     = React.useState("");
  const [foilColor, setFoilColor] = React.useState("matte");
  const [stamp,     setStamp]     = React.useState("none");
  const [stampW,    setStampW]    = React.useState("");
  const [stampH,    setStampH]    = React.useState("");

  /* ── 개별포장 ── */
  const [pack, setPack] = React.useState("none");

  /* ── 가격 계산 ── */
  const sizeBase = { a5: 42000, a4: 50000 }[size] || 50000;
  const innerAdd = { montblanc: 0, rendezvous: 5000, art: 3000 }[innerPaper] || 0;
  const coverAdd = { montblanc: 0, rendezvous: 5000, art: 3000 }[coverPaper] || 0;
  const innerCost = Math.round((sizeBase + innerAdd) * qty / 20 * (pages / 8));
  const coverCost = 25000 + coverAdd;
  const bindCost  = 1100;
  const packCost  = pack === "shrink" ? 500 : (foilOpen ? 25000 : 0);
  const subtotal  = innerCost + coverCost + bindCost + packCost;
  const vat       = Math.round(subtotal * 0.1);
  const total     = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  const sizeLabel = { a5: "A5 (148 x 210 mm)", a4: "A4 (210 x 297 mm)" }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* 상품명 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          책자 상품명
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
            { value: "a5", label: "A5 (148 x 210 mm)" },
            { value: "a4", label: "A4 (210 x 297 mm)" },
          ]} />
      </OptionField>

      {/* 제본 */}
      <OptionField label="제본">
        <OptionButtonGroup columns={2} value={bind} onChange={setBind}
          options={[
            { value: "wireless", label: "무선제본" },
          ]} />
      </OptionField>

      {/* 제본방향 */}
      <OptionField label="제본방향">
        <OptionButtonGroup columns={2} value={bindDir} onChange={setBindDir}
          options={[
            { value: "left", label: "좌철" },
            { value: "top",  label: "상철" },
          ]} />
      </OptionField>

      {/* 링컬러 — 상철(링제본)일 때 */}
      {bindDir === "top" && (
        <OptionField label="링컬러">
          <div style={{ display: "flex", gap: 20, paddingTop: 6 }}>
            <RingColor color="linear-gradient(135deg,#E8E8E8,#A8A8A8)" label="실버링"
              selected={ringColor === "silver"} onClick={() => setRingColor("silver")} />
            <RingColor color="#1A1A1A" label="블랙링"
              selected={ringColor === "black"} onClick={() => setRingColor("black")} />
            <RingColor color="linear-gradient(135deg,#FFD96A,#C8960C)" label="골드링"
              selected={ringColor === "gold"} onClick={() => setRingColor("gold")} />
          </div>
        </OptionField>
      )}

      {/* 링선택 — 상철(링제본)일 때 */}
      {bindDir === "top" && (
        <OptionField label="링선택">
          <RingSelect value={ring} onChange={setRing}
            options={[
              { value: "r1", label: "D링(31mm)" },
              { value: "r2", label: "D링(31mm)" },
              { value: "r3", label: "D링(31mm)" },
            ]} />
        </OptionField>
      )}

      {/* 면지 */}
      <OptionField label="면지">
        <OptionButtonGroup columns={3} value={endpaper} onChange={setEndpaper}
          options={[
            { value: "white", label: "화이트", info: true },
            { value: "gray",  label: "그레이", info: true },
            { value: "black", label: "블랙",   info: true },
            { value: "print", label: "인쇄",   info: true },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 내지종이 */}
      <OptionField label="내지종이" info>
        <SelectBox value={innerPaper} onChange={setInnerPaper}
          badge={innerPaper === "montblanc" ? <Badge tone="brand" size="md">추천</Badge> : null}
          options={[
            { value: "montblanc",  label: "몽블랑 190g" },
            { value: "rendezvous", label: "랑데뷰 250g (+5,000원)" },
            { value: "art",        label: "아트지 150g (+3,000원)" },
          ]} />
      </OptionField>

      {/* 내지인쇄 */}
      <OptionField label="내지인쇄">
        <OptionButtonGroup columns={2} value={innerPrint} onChange={setInnerPrint}
          options={[
            { value: "single", label: "단면" },
            { value: "double", label: "양면" },
          ]} />
      </OptionField>

      {/* 내지 페이지 */}
      <OptionField label="내지 페이지">
        <QuantityStepper value={pages} min={24} step={2} max={300} onChange={setPages} />
        <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
          최소 24P ~ 최대 300P
        </p>
      </OptionField>

      <Divider />

      {/* 표지종이 */}
      <OptionField label="표지종이" info>
        <SelectBox value={coverPaper} onChange={setCoverPaper}
          options={[
            { value: "montblanc",  label: "몽블랑 190g" },
            { value: "rendezvous", label: "랑데뷰 250g (+5,000원)" },
            { value: "art",        label: "아트지 230g (+3,000원)" },
          ]} />
      </OptionField>

      {/* 표지인쇄 */}
      <OptionField label="표지인쇄">
        <OptionButtonGroup columns={2} value={coverPrint} onChange={setCoverPrint}
          options={[
            { value: "single", label: "단면" },
            { value: "double", label: "양면" },
          ]} />
      </OptionField>

      {/* 표지코팅 */}
      <OptionField label="표지코팅">
        <OptionButtonGroup columns={3} value={coverCoat} onChange={setCoverCoat}
          options={[
            { value: "none",        label: "코팅없음" },
            { value: "mattSingle",  label: "무광코팅(단면)" },
            { value: "glossSingle", label: "유광코팅(단면)" },
          ]} />
      </OptionField>

      {/* 투명커버 */}
      <OptionField label="투명커버">
        <OptionButtonGroup columns={3} value={clearCover} onChange={setClearCover}
          options={[
            { value: "none",  label: "투명커버없음" },
            { value: "gloss", label: "유광투명커버", info: true },
            { value: "matt",  label: "무광투명커버", info: true },
          ]} />
      </OptionField>

      {/* 박,형압 가공 */}
      <FinishSection title="박,형압 가공" open={foilOpen} onToggle={setFoilOpen}>
        <OptionField label="박(표지)">
          <OptionButtonGroup columns={2} value={foilOn} onChange={setFoilOn}
            options={[
              { value: "on",  label: "박있음" },
              { value: "off", label: "박없음" },
            ]} />
        </OptionField>

        {foilOn === "on" && (
          <>
            <OptionField label="박(표지) 크기 직접입력" info>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <TextField value={foilW} onChange={setFoilW} placeholder="가로크기" align="center" />
                <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
                <TextField value={foilH} onChange={setFoilH} placeholder="세로크기" align="center" />
              </div>
              <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
                가로 30 ~ 125 mm / 세로 30 ~ 170 mm
              </p>
            </OptionField>

            <OptionField label="박(표지) 칼라">
              <div style={{ display: "flex", gap: 32, paddingTop: 6 }}>
                <ColorChip color="#000000" label="먹유광"
                  selected={foilColor === "matte"} onClick={() => setFoilColor("matte")} />
                <ColorChip color="linear-gradient(135deg,#f5f5ff,#dce8f8,#f5e8f5,#e8f5e8)" label="홀로그램"
                  selected={foilColor === "holo"} onClick={() => setFoilColor("holo")} />
              </div>
            </OptionField>
          </>
        )}

        <OptionField label="형압" info>
          <OptionButtonGroup columns={3} value={stamp} onChange={setStamp}
            options={[
              { value: "none",   label: "없음" },
              { value: "yangak", label: "양각" },
              { value: "eumak",  label: "음각" },
            ]} />
        </OptionField>

        <OptionField label="형압 크기 직접입력">
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <TextField value={stampW} onChange={setStampW} placeholder="가로크기" align="center" />
            <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
            <TextField value={stampH} onChange={setStampH} placeholder="세로크기" align="center" />
          </div>
          <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
            가로 30 ~ 125 mm / 세로 30 ~ 170 mm
          </p>
        </OptionField>
      </FinishSection>

      <Divider />

      {/* 개별포장 */}
      <OptionField label="개별포장">
        <SelectBox value={pack} onChange={setPack}
          options={[
            { value: "none",   label: "개별포장없음" },
            { value: "shrink", label: "수축포장 (500원)" },
          ]} />
      </OptionField>

      <Divider />

      {/* 가격 요약 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        {[
          { label: `내지 : ${sizeLabel}, 몽블랑 190, ${innerPrint === "single" ? "단면" : "양면"}`, amount: innerCost },
          { label: `표지 : 몽블랑 190g, ${coverPrint === "single" ? "단면" : "양면"}, ${coverCoat === "none" ? "코팅없음" : "코팅"}`, amount: coverCost },
          { label: `제본 : ${bind === "wireless" ? "무선제본" : "스프링제본"}, ${bindDir === "left" ? "좌철" : "상철"}, ${qty}ea`, amount: bindCost },
          { label: `개별포장 : ${pack === "shrink" ? "수축포장" : "개별포장없음"}`, amount: packCost },
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

        {/* 합계금액 아래 구분선 */}
        <div style={{ height: 1, background: "var(--huni-gray-100)", marginTop: 12 }} />
      </div>

      {/* PDF 업로드 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="secondary" block leadingIcon={<UploadIcon />}>PDF파일 직접 올리기</Button>
        <Callout tone="muted" glyph="i">작업가이드 및 파일가이드 다운로드</Callout>
      </div>

      {/* 에디터 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <Button variant="primary" block leadingIcon={<EditIcon />}>에디터로 디자인하기</Button>
        <Callout tone="muted" glyph="i">에디터 사용방법 보기</Callout>
      </div>

    </div>
  );
}

/* ── 링컬러 (100×100 색상 원 + 라벨) ── */
function RingColor({ color, label, selected, onClick }) {
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
      <div style={{
        background: selected ? "var(--huni-gray-800)" : "transparent",
        borderRadius: 4, padding: "2px 8px", minHeight: 18,
      }}>
        {selected && (
          <span style={{ fontSize: 11, fontWeight: "var(--weight-semibold)", color: "#fff", whiteSpace: "nowrap" }}>{label}</span>
        )}
      </div>
      <button onClick={onClick} aria-label={label} style={{
        width: 100, height: 100, borderRadius: "50%",
        background: "url(./ring.png) center / cover no-repeat", border: "none", cursor: "pointer", padding: 0,
        boxShadow: selected ? "0 0 0 2px var(--huni-purple-600)" : "0 0 0 1px var(--huni-gray-200)",
      }} />
    </div>
  );
}

/* ── 링선택 (이미지 플레이스홀더 원형 칩) ── */
function RingSelect({ value, onChange, options }) {
  return (
    <div style={{ display: "flex", gap: 20, paddingTop: 6 }}>
      {options.map(opt => (
        <div key={opt.value} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
          <div style={{
            background: value === opt.value ? "var(--huni-gray-800)" : "transparent",
            borderRadius: 4, padding: "2px 8px", minHeight: 18,
          }}>
            {value === opt.value && (
              <span style={{ fontSize: 11, fontWeight: "var(--weight-semibold)", color: "#fff", whiteSpace: "nowrap" }}>{opt.label}</span>
            )}
          </div>
          <button onClick={() => onChange(opt.value)} style={{
            width: 100, height: 100, borderRadius: "50%",
            background: "url(./ring.png) center / cover no-repeat", border: "none", cursor: "pointer", padding: 0,
            boxShadow: value === opt.value ? "0 0 0 2px var(--huni-purple-600)" : "0 0 0 1px var(--huni-gray-200)",
          }}></button>
        </div>
      ))}
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

function UploadIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
      <path d="M12 16V4m0 0L7 9m5-5l5 5M5 20h14"
        stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
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

window.BookConfigurator = Configurator;
