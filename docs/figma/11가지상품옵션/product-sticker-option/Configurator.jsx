// Huni printing — PRODUCT_STICKER_OPTION (피그마 원본 기반)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper,
    FinishSection, Button, Callout, Badge, TextField,
    onAddToCart,
  } = C;

  /* ── 기본 옵션 ── */
  const [size,    setSize]    = React.useState("a4");
  const [paper,   setPaper]   = React.useState("yupo");
  const [print,   setPrint]   = React.useState("single");
  const [spotW,   setSpotW]   = React.useState("single");
  const [cut,     setCut]     = React.useState("c8ea");
  const [pieces,  setPieces]  = React.useState("");
  const [qty,     setQty]     = React.useState(20);

  /* ── 후가공 (닫힌 상태) ── */
  const [finishOpen, setFinishOpen] = React.useState(false);
  const [corner,     setCorner]     = React.useState("square");
  const [crease,     setCrease]     = React.useState("none");
  const [perf,       setPerf]       = React.useState("none");
  const [varText,    setVarText]    = React.useState("none");
  const [varImg,     setVarImg]     = React.useState("none");

  /* ── 가격 계산 ── */
  const sizeBase = { a6: 28000, a5: 38000, a4: 50000 }[size] || 50000;
  const paperAdd = { yupo: 0, art: 5000, pet: 12000 }[paper] || 0;
  const printCost  = Math.round((sizeBase + paperAdd) * qty / 20);
  const finishCost = finishOpen ? 25000 : 0;
  const subtotal   = printCost + finishCost;
  const vat        = Math.round(subtotal * 0.1);
  const total      = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  const sizeLabel = {
    a6: "A6 (105 x 148 mm)",
    a5: "A5 (148 x 210 mm)",
    a4: "A4 (210 x 297 mm)",
  }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* 상품명 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          스티커 상품명
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

      {/* 사이즈 — A6 / A5 / A4 */}
      <OptionField label="사이즈">
        <OptionButtonGroup columns={3} value={size} onChange={setSize}
          options={[
            { value: "a6", label: "A6 (105 x 148 mm)" },
            { value: "a5", label: "A5 (148 x 210 mm)" },
            { value: "a4", label: "A4 (210 x 297 mm)" },
          ]} />
      </OptionField>

      {/* 종이 */}
      <OptionField label="종이" info>
        <SelectBox value={paper} onChange={setPaper}
          badge={paper === "yupo" ? <Badge tone="brand" size="md">추천</Badge> : null}
          options={[
            { value: "yupo", label: "유포스티커" },
            { value: "art",  label: "아트지 (+5,000원)" },
            { value: "pet",  label: "투명 PET (+12,000원)" },
          ]} />
      </OptionField>

      {/* 인쇄 — 단면만 */}
      <OptionField label="인쇄">
        <OptionButtonGroup columns={1} value={print} onChange={setPrint}
          options={[
            { value: "single", label: "단면" },
          ]} />
      </OptionField>

      {/* 별색인쇄 (화이트) */}
      <OptionField label="별색인쇄 (화이트)">
        <OptionButtonGroup columns={1} value={spotW} onChange={setSpotW}
          options={[
            { value: "single", label: "화이트인쇄(단면)" },
          ]} />
      </OptionField>

      {/* 커팅 — 모두 ⓘ */}
      <OptionField label="커팅" info>
        <OptionButtonGroup columns={2} value={cut} onChange={setCut}
          options={[
            { value: "c8ea", label: "30x278mm (8ea)", info: true },
            { value: "c5ea", label: "30x278mm (5ea)", info: true },
            { value: "c4ea", label: "40x278mm (4ea)", info: true },
            { value: "c3ea", label: "50x278mm (3ea)", info: true },
          ]} />
      </OptionField>

      {/* 조각수 */}
      <OptionField label="조각수" info>
        <SelectBox value={pieces} onChange={setPieces}
          options={[
            { value: "",   label: "조각수" },
            { value: "1",  label: "1조각" },
            { value: "2",  label: "2조각" },
            { value: "3",  label: "3조각" },
            { value: "4",  label: "4조각" },
            { value: "5",  label: "5조각" },
            { value: "10", label: "10조각" },
          ]} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* 후가공 (기본 닫힘) */}
      <FinishSection title="후가공" open={finishOpen} onToggle={setFinishOpen}>
        <OptionField label="귀돌이" info>
          <OptionButtonGroup columns={2} value={corner} onChange={setCorner}
            options={[
              { value: "square", label: "직각모서리" },
              { value: "round",  label: "둥근모서리" },
            ]} />
        </OptionField>
        <OptionField label="오시" info>
          <OptionButtonGroup columns={4} value={crease} onChange={setCrease}
            options={[
              { value: "none", label: "없음" },
              { value: "1",    label: "1개" },
              { value: "2",    label: "2개" },
              { value: "3",    label: "3개" },
            ]} />
        </OptionField>
        <OptionField label="미싱" info>
          <OptionButtonGroup columns={4} value={perf} onChange={setPerf}
            options={[
              { value: "none", label: "없음" },
              { value: "1",    label: "1개" },
              { value: "2",    label: "2개" },
              { value: "3",    label: "3개" },
            ]} />
        </OptionField>
        <OptionField label="가변인쇄 (텍스트)" info>
          <OptionButtonGroup columns={4} value={varText} onChange={setVarText}
            options={[
              { value: "none", label: "없음" },
              { value: "1",    label: "1개" },
              { value: "2",    label: "2개" },
              { value: "3",    label: "3개" },
            ]} />
        </OptionField>
        <OptionField label="가변인쇄 (이미지)" info>
          <OptionButtonGroup columns={4} value={varImg} onChange={setVarImg}
            options={[
              { value: "none", label: "없음" },
              { value: "1",    label: "1개" },
              { value: "2",    label: "2개" },
              { value: "3",    label: "3개" },
            ]} />
        </OptionField>
      </FinishSection>

      {/* 가격 요약 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        {[
          {
            label: `인쇄비 : ${sizeLabel}, 유포스티커, 단면, ${qty}ea`,
            amount: printCost,
          },
          ...(finishOpen ? [{
            label: `후가공 : 귀돌이 (${corner === "square" ? "직각모서리" : "둥근모서리"}), 오시(${crease === "none" ? "없음" : crease + "개"})`,
            amount: finishCost,
          }] : []),
          {
            label: "추가상품 : 선택안함",
            amount: 0,
          },
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

window.StickerConfigurator = Configurator;
