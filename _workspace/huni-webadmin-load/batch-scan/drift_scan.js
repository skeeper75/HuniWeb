// 드리프트 전수 스캐너 (drift-scan v1) — 상품 등록 base코드 ≠ 가격 적재 base코드 탐지.
// v4 배치 스캐너는 "기본조합 1개 final>0"만 봐서 일부 조합만 되는 드리프트를 놓친다.
// 이 스캐너는 ①양호 baseline 조합 확립 후 ②가격키 차원(use_dims) 값을 하나씩 스윕해
// "상품은 제공하나 가격 그리드에 행이 없는 값"(final=0)을 커버리지 diff로 적발한다.
// PRDS 상수(gen_drift.py가 임베드) 사용. top-level await. 읽기전용(계산 API만).
const csrf=(document.cookie.match('(^|;)\\s*csrftoken\\s*=\\s*([^;]+)')||[]).pop()||'';
async function meta(prd){const r=await fetch(`/admin/price-viewer/${prd}/sim-meta/`,{headers:{'X-Requested-With':'XMLHttpRequest'}});if(!r.ok)return null;try{return await r.json();}catch(e){return null;}}
async function sim(prd,sel,qty,procs){const b={selections:sel,qty};if(procs&&procs.length)b.procs=procs;const r=await fetch(`/admin/price-viewer/${prd}/simulate/`,{method:'POST',headers:{'Content-Type':'application/json','X-CSRFToken':csrf,'X-Requested-With':'XMLHttpRequest'},body:JSON.stringify(b)});const ct=r.headers.get('content-type')||'';if(!ct.includes('json'))return{__http:r.status};return await r.json();}
// min_qty=수량(별도)·proc_cd=공정(procs 경유·스윕 제외). 나머지 선택차원만 스윕.
const NON_SWEEP=new Set(['min_qty','proc_cd']);
const out=[];
for(const p of PRDS){
  const rec={prd_cd:p.prd_cd,nm:p.nm,typ:p.typ};
  try{
    const m=await meta(p.prd_cd);
    if(!m){rec.status='META_FAIL';out.push(rec);continue;}
    rec.is_set=!!m.is_set;rec.frm=m.frm?(m.frm.frm_cd||m.frm):null;
    // 기성/반제품은 견적 대상 아님(v4 버킷과 동일) — 스킵
    if(p.typ==='PRD_TYPE.03'){rec.status='SKIP_기성';out.push(rec);continue;}

    // ── 1) baseline: v4와 동일 로직(dflt 선택 → 수량 재시도 → 조합 재시도)으로 양호 조합 확립 ──
    const sel={};
    const procDim=(m.prod_dims||[]).find(d=>d.name==='proc_cd');
    for(const d of (m.prod_dims||[])){
      if(d.name==='proc_cd') continue;
      const o=d.options||[];if(!o.length)continue;const pk=o.find(x=>x.dflt)||o[0];sel[d.name]=pk.v;
    }
    const proc_sels=[];
    if(procDim){
      const byGrp={};
      for(const o of (procDim.options||[])){const g=o.grp_cd||'_';(byGrp[g]=byGrp[g]||[]).push(o);}
      for(const g in byGrp){ if(byGrp[g].length===1){ proc_sels.push({proc_cd:byGrp[g][0].v, detail:{}}); } }
    }
    let qty=(m.qty_rule&&(m.qty_rule.dflt||m.qty_rule.min))||1;
    let good={...sel};
    let j=await sim(p.prd_cd,good,qty,proc_sels);
    function hasBelowMin(res){return ((res.base&&res.base.components)||[]).some(c=>!c.included&&(c.error||c.reason||'').includes('below_min'));}
    if(!j.__http && hasBelowMin(j)){
      const hi=Math.min((m.qty_rule&&m.qty_rule.max)||10000, 5000);
      const inc=(m.qty_rule&&m.qty_rule.incr)||1; const q2=Math.ceil(hi/inc)*inc;
      const j2=await sim(p.prd_cd,good,q2,proc_sels);
      if(!j2.__http){ j=j2; qty=q2; }
    }
    if(!j.__http && !(j.final_price>0)){
      const dims=(m.prod_dims||[]).filter(d=>d.name!=='proc_cd' && (d.options||[]).length>1);
      let combos=[{...sel}];
      for(const d of dims){const nc=[];for(const c of combos){for(const o of (d.options||[]).slice(0,6)){nc.push({...c,[d.name]:o.v});}}combos=nc.slice(0,30);}
      for(const cs of combos.slice(0,30)){
        const jr=await sim(p.prd_cd,cs,qty,proc_sels);
        if(!jr.__http && jr.final_price>0){ j=jr; good={...cs}; break; }
      }
    }
    rec.qty=qty;
    if(j.__http){rec.status='SIM_HTTP_'+j.__http;out.push(rec);continue;}
    rec.baseline_final=j.final_price;
    // ── 구조적 드리프트: base 구성요소가 요구하는 스칼라 차원(use_dims)이 상품 prod_dims에 미등록? ──
    // (가격 그리드는 print_opt_cd 등으로 키잉되나 상품이 그 차원을 선택지로 노출 안 함 = 셀프견적 불가)
    const dimNames=new Set((m.prod_dims||[]).map(d=>d.name));
    const SKIP_UD=new Set(['min_qty','proc_cd']);
    const reqScalar=new Set();
    for(const c of ((j.base&&j.base.components)||[])){
      for(const ud of (c.use_dims||[])){
        if(SKIP_UD.has(ud)||ud.includes(':')) continue; // grp 토큰(opt_grp:/proc_grp:)·수량·공정 제외
        reqScalar.add(ud);
      }
    }
    const missing_dims=[...reqScalar].filter(x=>!dimNames.has(x));
    if(missing_dims.length) rec.missing_dims=missing_dims;
    if(!(j.final_price>0)){
      // baseline 0원: 미등록 차원 있으면 구조 드리프트, 아니면 전면 미배선/무공식.
      rec.status = missing_dims.length ? 'MISSING_DIM_DRIFT' : (rec.frm ? 'FULL_DRIFT_0원' : 'NO_FORMULA');
      out.push(rec);continue;
    }
    // ── 2) 가격키 차원 확정: baseline base 구성요소 use_dims 합집합(가격에 실제 관여) ──
    const baseComps=(j.base&&j.base.components)||[];
    rec.anchor_comps=baseComps.filter(c=>c.included).map(c=>c.comp_cd);
    const priceDims=new Set();
    for(const c of baseComps){ for(const ud of (c.use_dims||[])){ if(!NON_SWEEP.has(ud)) priceDims.add(ud); } }
    // 스윕 대상 = prod_dims 중 가격키 차원이면서 옵션 존재(단일값도 포함=full-code 드리프트 확인)
    const sweepDims=(m.prod_dims||[]).filter(d=>d.name!=='proc_cd' && priceDims.has(d.name) && (d.options||[]).length);
    rec.swept_dims=sweepDims.map(d=>d.name);
    rec.proc_unswept = !!procDim; // 공정 커버리지는 후속(procs 경유)

    // ── 3) 차원별 값 스윕: 다른 차원은 baseline 고정, 대상 차원만 값 치환 → final>0 여부 ──
    const drift=[];
    let cov=0, unc=0;
    for(const d of sweepDims){
      for(const o of (d.options||[])){
        const sel2={...good,[d.name]:o.v};
        const jr=await sim(p.prd_cd,sel2,qty,proc_sels);
        if(jr.__http){ drift.push({dim:d.name,v:o.v,t:o.t,reason:'SIM_HTTP_'+jr.__http}); unc++; continue; }
        if(jr.final_price>0){ cov++; }
        else{
          // 미커버: 상품은 이 값을 제공하나 가격 그리드에 매칭 행 없음
          const bc=(jr.base&&jr.base.components)||[];
          const lost=bc.filter(c=>!c.included).map(c=>c.comp_cd+':'+(c.error||c.reason||'no_match'));
          drift.push({dim:d.name,v:o.v,t:o.t,reason:lost.join('|')||'final0'});
          unc++;
        }
      }
    }
    rec.covered=cov; rec.uncovered=unc; rec.drift=drift;
    rec.status = unc>0 ? 'DRIFT' : 'CLEAN';
  }catch(e){rec.status='EXC';rec.err=String(e).slice(0,120);}
  out.push(rec);
}
return JSON.stringify(out);
