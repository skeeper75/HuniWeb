// Huni printing — product image gallery (left column). Plain-babel module.
function ProductGallery({ Badge }) {
  const [active, setActive] = React.useState(0);
  // Subtle placeholder frames — print-craft tinted, with the CMYK mark watermark.
  const tints = [
    "linear-gradient(135deg,#EEEBF9,#DED7F4)",
    "linear-gradient(135deg,#F6F6F6,#E9E9E9)",
    "linear-gradient(135deg,#DED7F4,#C9C2DF)",
    "linear-gradient(135deg,#F6F6F6,#EEEBF9)",
    "linear-gradient(135deg,#E9E9E9,#F6F6F6)",
    "linear-gradient(135deg,#EEEBF9,#F6F6F6)",
  ];

  const Frame = ({ tint, big }) => (
    <div style={{
      position: "relative", width: "100%", aspectRatio: big ? "1 / 1" : "1 / 1",
      borderRadius: "var(--radius-xs)", background: tint, overflow: "hidden",
      border: "1px solid var(--huni-gray-100)",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}>
      <img src="./cmyk-mark.svg" width={big ? 48 : 20} height={big ? 48 : 20} alt=""
        style={{ opacity: 0.5 }} />
      {big && (
        <span style={{
          position: "absolute", bottom: 14, font: "var(--type-caption)", fontSize: "var(--text-sm)",
          color: "var(--text-secondary)", letterSpacing: "var(--tracking-tight)",
        }}>상품 대표 이미지</span>
      )}
    </div>
  );

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
      <div style={{ position: "relative" }}>
        <div style={{ position: "absolute", top: 12, left: 12, zIndex: 2, display: "flex", gap: 6 }}>
          <Badge tone="best" size="md">BEST</Badge>
          <Badge tone="new" size="md">NEW</Badge>
        </div>
        <Frame tint={tints[active]} big />
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(6, 1fr)", gap: 8 }}>
        {tints.map((t, i) => (
          <button key={i} onClick={() => setActive(i)} style={{
            padding: 0, background: "none", cursor: "pointer", borderRadius: "var(--radius-xs)",
            outline: i === active ? "2px solid var(--huni-purple-600)" : "1px solid var(--huni-gray-200)",
            outlineOffset: i === active ? "-2px" : "-1px", overflow: "hidden",
          }}>
            <Frame tint={t} />
          </button>
        ))}
      </div>
    </div>
  );
}
window.CalendarGallery = ProductGallery;
