// Huni printing — product detail tabs (notice / shipping / reviews). Plain-babel module.
function DetailTabs({ Tabs, Pagination, Badge }) {
  const [tab, setTab] = React.useState("review");
  const [page, setPage] = React.useState(1);

  return (
    <section style={{ marginTop: 56 }}>
      <Tabs value={tab} onChange={setTab}
        tabs={[{ value: "notice", label: "유의사항" }, { value: "ship", label: "포장/배송" }, { value: "review", label: "상품리뷰" }]} />

      <div style={{ paddingTop: 32 }}>
        {tab === "notice" && <NoticeBody />}
        {tab === "ship" && <ShipBody />}
        {tab === "review" && <ReviewBody Badge={Badge} page={page} setPage={setPage} Pagination={Pagination} />}
      </div>
    </section>
  );
}

function NoticeBody() {
  const items = [
    ["모니터 환경에 따른 색상 차이", "모니터·기기의 색 표현 차이로 실제 인쇄물과 화면상 색상이 다를 수 있습니다. 중요한 색상은 별색(Pantone) 지정을 권장합니다."],
    ["재단 오차 안내", "기계 작업 특성상 ±1mm 내외의 재단 오차가 발생할 수 있습니다. 칼선 안쪽 3mm 여백을 확보해 주세요."],
    ["파일 규격", "PDF / AI (CMYK, 300dpi, 외곽 3mm 도련 포함) 파일을 업로드해 주세요."],
  ];
  return (
    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 18 }}>
      {items.map(([t, d], i) => (
        <article key={i} style={{
          border: "1px solid var(--huni-gray-100)", borderRadius: "var(--radius-lg)",
          padding: 22, background: "var(--huni-white)",
        }}>
          <h4 style={{ font: "var(--type-title)", fontSize: "var(--text-md)", marginBottom: 8 }}>{t}</h4>
          <p style={{ margin: 0, font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)", lineHeight: "var(--leading-normal)" }}>{d}</p>
        </article>
      ))}
    </div>
  );
}

function ShipBody() {
  const rows = [
    ["인쇄 제작", "영업일 기준 2~3일"],
    ["후가공 포함 시", "영업일 기준 +1~2일"],
    ["배송 방법", "택배 (CJ대한통운) · 3,000원 / 5만원 이상 무료"],
    ["퀵·방문수령", "서울/경기 일부 지역 당일 수령 가능"],
  ];
  return (
    <div style={{ maxWidth: 720, border: "1px solid var(--huni-gray-100)", borderRadius: "var(--radius-lg)", overflow: "hidden" }}>
      {rows.map(([k, v], i) => (
        <div key={i} style={{
          display: "grid", gridTemplateColumns: "200px 1fr", gap: 16, padding: "16px 22px",
          borderTop: i ? "1px solid var(--huni-gray-100)" : "none",
        }}>
          <span style={{ font: "var(--type-body-strong)", fontSize: "var(--text-base)", color: "var(--text-heading)" }}>{k}</span>
          <span style={{ font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)" }}>{v}</span>
        </div>
      ))}
    </div>
  );
}

function ReviewBody({ Badge, page, setPage, Pagination }) {
  const all = [
    ["김*은", "도무송 칼선이 진짜 깔끔하게 나왔어요. 방수도 잘 되고 재구매 의사 있습니다!", "BEST", 5],
    ["printlover", "홀로그램 박이 생각보다 화려해서 굿즈로 딱이에요.", "NEW", 5],
    ["스튜디오 호", "색감이 화면이랑 거의 동일하게 나왔습니다. 가이드 친절해요.", null, 4],
    ["min_design", "수량 대비 가격이 합리적이라 대량으로 또 주문했어요.", null, 5],
  ];
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
      {all.map(([name, body, tag, score], i) => (
        <article key={i} style={{
          display: "flex", gap: 18, padding: 20, border: "1px solid var(--huni-gray-100)",
          borderRadius: "var(--radius-lg)", background: "var(--huni-white)",
        }}>
          <div style={{
            width: 44, height: 44, flex: "none", borderRadius: "var(--radius-full)",
            background: "var(--huni-purple-50)", display: "flex", alignItems: "center", justifyContent: "center",
            font: "var(--type-title)", fontWeight: "var(--weight-bold)", color: "var(--huni-purple-600)",
          }}>{name[0]}</div>
          <div style={{ flex: 1 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 6 }}>
              <span style={{ font: "var(--type-body-strong)", fontSize: "var(--text-base)", color: "var(--text-heading)" }}>{name}</span>
              <span style={{ display: "inline-flex", gap: 1 }}>
                {[0,1,2,3,4].map((s) => (
                  <svg key={s} width="13" height="13" viewBox="0 0 24 24" fill={s < score ? "var(--huni-amber)" : "var(--huni-gray-200)"}>
                    <path d="M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.8 5.9 20.4l1.4-6.8L2.2 9l6.9-.7L12 2z"/>
                  </svg>
                ))}
              </span>
              {tag && <Badge tone={tag === "BEST" ? "best" : "new"} size="md">{tag}</Badge>}
            </div>
            <p style={{ margin: 0, font: "var(--type-body)", fontSize: "var(--text-base)", color: "var(--text-secondary)", lineHeight: "var(--leading-normal)" }}>{body}</p>
          </div>
        </article>
      ))}
      <div style={{ display: "flex", justifyContent: "center", marginTop: 12 }}>
        <Pagination page={page} count={5} onChange={setPage} />
      </div>
    </div>
  );
}

window.DetailTabs = DetailTabs;
