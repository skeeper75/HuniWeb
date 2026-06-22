// Huni printing — PRODUCT_PRINT_OPTION 디지털인쇄 (피그마 원본 기반 v3)
function Configurator(C) {
  const {
    OptionField, OptionButtonGroup, SelectBox, QuantityStepper,
    ColorChip, FinishSection, PriceSummary, Button, Callout, TextField,
    Badge, onAddToCart,
  } = C;

  /* ── 기본 옵션 ── */
  const [size,    setSize]    = React.useState("s100x150");
  const [customW, setCustomW] = React.useState("100");
  const [customH, setCustomH] = React.useState("150");
  const [paper,   setPaper]   = React.useState("montblanc");
  const [print,   setPrint]   = React.useState("single");

  /* ── 별색인쇄 (색상별 독립, 없음→단면→양면 순) ── */
  const [spotWhite,  setSpotWhite]  = React.useState("none");
  const [spotClear,  setSpotClear]  = React.useState("none");
  const [spotPink,   setSpotPink]   = React.useState("none");
  const [spotGold,   setSpotGold]   = React.useState("none");
  const [spotSilver, setSpotSilver] = React.useState("none");

  /* ── 코팅 / 커팅 / 접지 ── */
  const [coat, setCoat] = React.useState("none");
  const [cut,  setCut]  = React.useState("oneRound");
  const [fold, setFold] = React.useState("h2");

  /* ── 건수 / 제작수량 ── */
  const [batches, setBatches] = React.useState(1);
  const [qty,     setQty]     = React.useState(20);

  /* ── 후가공 ── */
  const [finishOpen, setFinishOpen] = React.useState(true);
  const [corner,     setCorner]     = React.useState("square");
  const [crease,     setCrease]     = React.useState("none");
  const [perf,       setPerf]       = React.useState("none");
  const [varText,    setVarText]    = React.useState("none");
  const [varImg,     setVarImg]     = React.useState("none");

  /* ── 박,형압 가공 ── */
  const [foilOpen,    setFoilOpen]    = React.useState(true);
  const [foilFrontOn, setFoilFrontOn] = React.useState("on");
  const [foilFrontW,  setFoilFrontW]  = React.useState("");
  const [foilFrontH,  setFoilFrontH]  = React.useState("");
  const [foilFront,   setFoilFront]   = React.useState("matte");
  const [foilBackOn,  setFoilBackOn]  = React.useState("on");
  const [foilBackW,   setFoilBackW]   = React.useState("");
  const [foilBackH,   setFoilBackH]   = React.useState("");
  const [foilBack,    setFoilBack]    = React.useState("holo");
  const [stamp,       setStamp]       = React.useState("none");
  const [stampW,      setStampW]      = React.useState("");
  const [stampH,      setStampH]      = React.useState("");

  /* ── 엽서봉투 ── */
  const [envelope, setEnvelope] = React.useState("none");
  const [envQty,   setEnvQty]   = React.useState("");

  /* ── 7색 박 컬러칩 데이터 ── */
  const foilColors = [
    { id: "gold",   color: "linear-gradient(135deg,#FFD700,#C8960C)", label: "금색박" },
    { id: "silver", color: "linear-gradient(135deg,#C8D8E8,#A0B8C8)", label: "은색박" },
    { id: "matte",  color: "#111827",                                  label: "먹유광" },
    { id: "copper", color: "linear-gradient(135deg,#D4813B,#B45A20)", label: "동색박" },
    { id: "red",    color: "#E60012",                                  label: "레드박" },
    { id: "blue",   color: "#2A6FDB",                                  label: "블루박" },
    { id: "holo",   color: "linear-gradient(135deg,#f5f5ff,#dce8f8,#f5e8f5,#e8f5e8)", label: "홀로그램" },
  ];
  const foilColorsBack = foilColors.map(c =>
    c.id === "holo" ? { ...c, label: "홀로그램박" } : c
  );

  /* ── 별색 옵션 헬퍼 (없음, 단면, 양면 순) ── */
  const spotOpts = (prefix) => [
    { value: "none",   label: prefix + "(없음)" },
    { value: "single", label: prefix + "(단면)" },
    { value: "double", label: prefix + "(양면)" },
  ];

  /* ── 가격 계산 ── */
  const sizeBase = {
    s73x98: 25000, s98x98: 28000, s100x150: 35000,
    s95x210: 55000, s110x170: 42000, s148x210: 65000, s135x135: 50000, custom: 50000,
  }[size] || 35000;
  const paperAdd   = { montblanc: 0, rendezvous: 5000, misty: 6000, popset: 4000, art: 3000 }[paper] || 0;
  const printCost  = Math.round((sizeBase + paperAdd) * qty / 20);
  const finishCost = finishOpen ? 25000 : 0;
  const envCost    = envelope !== "none" ? (envelope === "opp150" ? 1150 : 1100) : 0;
  const subtotal   = printCost + finishCost + envCost;
  const vat        = Math.round(subtotal * 0.1);
  const total      = subtotal + vat;
  const krw = n => n.toLocaleString("ko-KR");

  const sizeLabel = {
    s73x98: "73 x 98 mm", s98x98: "98 x 98 mm", s100x150: "100 x 150 mm",
    s95x210: "95 x 210 mm", s110x170: "110 x 170 mm", s148x210: "148 x 210 mm",
    s135x135: "135 x 135 mm", custom: `${customW} x ${customH} mm`,
  }[size];

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* 상품명 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <h1 style={{ margin: 0, font: "var(--type-h1)", fontSize: "var(--text-2xl)", letterSpacing: "var(--tracking-tight)", color: "var(--text-heading)" }}>
          디지털인쇄 상품명
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

      {/* 사이즈 — 7종, 3열, 100×150 추천 */}
      <OptionField label="사이즈">
        <OptionButtonGroup columns={3} value={size} onChange={setSize}
          options={[
            { value: "s73x98",   label: "73 x 98 mm" },
            { value: "s98x98",   label: "98 x 98 mm" },
            { value: "s100x150", label: "100 x 150 mm", badge: <Badge tone="brand" size="sm">추천</Badge> },
            { value: "s95x210",  label: "95 x 210 mm" },
            { value: "s110x170", label: "110 x 170 mm" },
            { value: "s148x210", label: "148 x 210 mm" },
            { value: "s135x135", label: "135 x 135 mm" },
          ]} />

      </OptionField>

      {/* 종이 */}
      <OptionField label="종이" info>
        <SelectBox value={paper} onChange={setPaper}
          badge={paper === "montblanc" ? <Badge tone="brand" size="md">추천</Badge> : null}
          options={[
            { value: "montblanc",  label: "몽블랑 190g" },
            { value: "rendezvous", label: "랑데뷰 250g (+5,000원)" },
            { value: "misty",      label: "미스티 크림 250g (+6,000원)" },
            { value: "popset",     label: "팝셋 250g (+4,000원)" },
            { value: "art",        label: "아트지 230g (+3,000원)" },
          ]} />
      </OptionField>

      {/* 인쇄 */}
      <OptionField label="인쇄">
        <OptionButtonGroup columns={2} value={print} onChange={setPrint}
          options={[
            { value: "single", label: "단면" },
            { value: "double", label: "양면" },
          ]} />
      </OptionField>

      {/* 별색인쇄 5종 — 없음, 단면, 양면 순 */}
      <OptionField label="별색인쇄 (화이트)">
        <OptionButtonGroup columns={3} value={spotWhite} onChange={setSpotWhite} options={spotOpts("화이트인쇄")} />
      </OptionField>

      <OptionField label="별색인쇄 (클리어)">
        <OptionButtonGroup columns={3} value={spotClear} onChange={setSpotClear} options={spotOpts("클리어인쇄")} />
      </OptionField>

      <OptionField label="별색인쇄 (핑크)">
        <OptionButtonGroup columns={3} value={spotPink} onChange={setSpotPink} options={spotOpts("핑크인쇄")} />
      </OptionField>

      <OptionField label="별색인쇄 (금색)">
        <OptionButtonGroup columns={3} value={spotGold} onChange={setSpotGold} options={spotOpts("금색인쇄")} />
      </OptionField>

      <OptionField label="별색인쇄 (은색)">
        <OptionButtonGroup columns={3} value={spotSilver} onChange={setSpotSilver} options={spotOpts("은색인쇄")} />
      </OptionField>

      {/* 코팅 (커팅보다 먼저) */}
      <OptionField label="코팅">
        <OptionButtonGroup columns={3} value={coat} onChange={setCoat}
          options={[
            { value: "none",        label: "코팅없음" },
            { value: "mattSingle",  label: "무광코팅(단면)" },
            { value: "mattDouble",  label: "무광코팅(양면)" },
            { value: "glossDouble", label: "유광코팅(양면)" },
            { value: "glossSingle", label: "유광코팅(단면)" },
          ]} />
      </OptionField>

      {/* 커팅 (코팅 다음, 모두 info 아이콘) */}
      <OptionField label="커팅">
        <OptionButtonGroup columns={3} value={cut} onChange={setCut}
          options={[
            { value: "oneRound", label: "한쪽라운딩", info: true },
            { value: "leaf",     label: "나뭇잎",     info: true },
            { value: "bigRound", label: "큰라운딩",   info: true },
            { value: "classic",  label: "클래식",     info: true },
          ]} />
      </OptionField>

      {/* 접지 — 없음 없음, 3가지만 */}
      <OptionField label="접지">
        <OptionButtonGroup columns={3} value={fold} onChange={setFold}
          options={[
            { value: "h2", label: "2단 가로접지", info: true },
            { value: "v2", label: "2단 세로접지", info: true },
            { value: "h3", label: "3단 가로접지", info: true },
          ]} />
      </OptionField>

      {/* 건수 */}
      <OptionField label="건수">
        <QuantityStepper value={batches} min={1} step={1} max={100} onChange={setBatches} />
      </OptionField>

      {/* 제작수량 */}
      <OptionField label="제작수량">
        <QuantityStepper value={qty} min={10} step={10} max={2000} onChange={setQty} />
      </OptionField>

      <Divider />

      {/* ── 후가공 ── */}
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
              { value: "none", label: "없음" }, { value: "1", label: "1개" },
              { value: "2",    label: "2개" },  { value: "3", label: "3개" },
            ]} />
        </OptionField>

        <OptionField label="미싱" info>
          <OptionButtonGroup columns={4} value={perf} onChange={setPerf}
            options={[
              { value: "none", label: "없음" }, { value: "1", label: "1개" },
              { value: "2",    label: "2개" },  { value: "3", label: "3개" },
            ]} />
        </OptionField>

        <OptionField label="가변인쇄 (텍스트)" info>
          <OptionButtonGroup columns={4} value={varText} onChange={setVarText}
            options={[
              { value: "none", label: "없음" }, { value: "1", label: "1개" },
              { value: "2",    label: "2개" },  { value: "3", label: "3개" },
            ]} />
        </OptionField>

        {/* 가변인쇄(이미지) — 상태→이미지로 변경 */}
        <OptionField label="가변인쇄 (이미지)" info>
          <OptionButtonGroup columns={4} value={varImg} onChange={setVarImg}
            options={[
              { value: "none", label: "없음" }, { value: "1", label: "1개" },
              { value: "2",    label: "2개" },  { value: "3", label: "3개" },
            ]} />
        </OptionField>
      </FinishSection>

      {/* ── 박,형압 가공 (별도 섹션) ── */}
      <FinishSection title="박,형압 가공" open={foilOpen} onToggle={setFoilOpen}>

        {/* 박(앞면) */}
        <OptionField label="박(앞면)">
          <OptionButtonGroup columns={2} value={foilFrontOn} onChange={setFoilFrontOn}
            options={[
              { value: "on",  label: "박있음" },
              { value: "off", label: "박없음" },
            ]} />
        </OptionField>

        {foilFrontOn === "on" && (
          <>
            <OptionField label="박(앞면) 크기 직접입력" info>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <TextField value={foilFrontW} onChange={setFoilFrontW} placeholder="가로크기" suffix="mm" align="center" />
                <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
                <TextField value={foilFrontH} onChange={setFoilFrontH} placeholder="세로크기" suffix="mm" align="center" />
              </div>
              <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
                가로 30 ~ 125 mm / 세로 30 ~ 170 mm
              </p>
            </OptionField>

            <OptionField label="박(앞면) 칼라">
              <div style={{ display: "flex", gap: 16, paddingTop: 6, flexWrap: "wrap" }}>
                {foilColors.map(c => (
                  <ColorChip key={c.id} color={c.color} label={c.label}
                    selected={foilFront === c.id} onClick={() => setFoilFront(c.id)} />
                ))}
              </div>
            </OptionField>
          </>
        )}

        <Divider />

        {/* 박(뒷면) */}
        <OptionField label="박(뒷면)">
          <OptionButtonGroup columns={2} value={foilBackOn} onChange={setFoilBackOn}
            options={[
              { value: "on",  label: "박있음" },
              { value: "off", label: "박없음" },
            ]} />
        </OptionField>

        {foilBackOn === "on" && (
          <>
            <OptionField label="박(뒷면) 크기 직접입력" info>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <TextField value={foilBackW} onChange={setFoilBackW} placeholder="가로크기" suffix="mm" align="center" />
                <span style={{ color: "var(--text-secondary)", flexShrink: 0 }}>X</span>
                <TextField value={foilBackH} onChange={setFoilBackH} placeholder="세로크기" suffix="mm" align="center" />
              </div>
              <p style={{ margin: "6px 0 0", fontSize: "var(--text-sm)", color: "var(--text-secondary)" }}>
                가로 30 ~ 80 mm / 세로 30 ~ 40 mm
              </p>
            </OptionField>

            <OptionField label="박(뒷면) 칼라">
              <div style={{ display: "flex", gap: 16, paddingTop: 6, flexWrap: "wrap" }}>
                {foilColorsBack.map(c => (
                  <ColorChip key={c.id} color={c.color} label={c.label}
                    selected={foilBack === c.id} onClick={() => setFoilBack(c.id)} />
                ))}
              </div>
            </OptionField>
          </>
        )}

        <Divider />

        {/* 형압 */}
        <OptionField label="형압" info>
          <OptionButtonGroup columns={3} value={stamp} onChange={setStamp}
            options={[
              { value: "none",    label: "없음" },
              { value: "yangak",  label: "양각" },
              { value: "eumak",   label: "음각" },
            ]} />
        </OptionField>

        <OptionField label="형압크기 직접입력">
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

      {/* 엽서봉투 — SelectBox만 사용 */}
      <OptionField label="엽서봉투">
        <SelectBox value={envelope} onChange={setEnvelope}
          options={[
            { value: "none",      label: "없음" },
            { value: "opp110",    label: "OPP비접착봉투 110 x 160 mm 50장 (+1,100원)" },
            { value: "opp150",    label: "OPP비접착봉투 150 x 150 mm 50장 (+1,150원)" },
            { value: "cardWhite", label: "카드봉투 화이트 165 x 115 mm 10장 (+1,100원)" },
            { value: "cardBlack", label: "카드봉투 블랙 165 x 115 mm 10장 (+1,100원)" },
          ]} />
      </OptionField>

      {/* 수량 */}
      <SelectBox value={envQty} onChange={setEnvQty}
        options={[
          { value: "",  label: "수량" },
          { value: "1", label: "1개" },
          { value: "2", label: "2개" },
          { value: "3", label: "3개" },
          { value: "5", label: "5개" },
        ]} />

      <Divider />

      {/* 가격 요약 */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        {/* 항목별 금액 */}
        {[
          {
            label: `인쇄비 : ${sizeLabel}, 몽블랑 190, ${print === "single" ? "단면" : "양면"}, ${qty}ea`,
            amount: printCost,
          },
          ...(finishOpen ? [{
            label: `후가공 : 귀돌이 (${corner === "square" ? "직각모서리" : "둥근모서리"}), 오시(${crease === "none" ? "없음" : crease + "개"})`,
            amount: finishCost,
          }] : []),
          ...(envelope !== "none" ? [{
            label: "추가상품 : " + {
              opp110: "OPP비접착봉투 110 x 160 mm 50장묶음",
              opp150: "OPP비접착봉투 150 x 150 mm 50장묶음",
              cardWhite: "카드봉투 화이트 165 x 115 mm 10장",
              cardBlack: "카드봉투 블랙 165 x 115 mm 10장",
            }[envelope],
            amount: envCost,
          }] : []),
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
          marginTop: 12, paddingTop: 0,
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

window.PrintConfigurator = Configurator;
