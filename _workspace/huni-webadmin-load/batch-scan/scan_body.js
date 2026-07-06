const csrf=(document.cookie.match('(^|;)\\s*csrftoken\\s*=\\s*([^;]+)')||[]).pop()||'';
async function meta(prd){const r=await fetch(`/admin/price-viewer/${prd}/sim-meta/`,{headers:{'X-Requested-With':'XMLHttpRequest'}});if(!r.ok)return null;try{return await r.json();}catch(e){return null;}}
async function sim(prd,sel,qty){const r=await fetch(`/admin/price-viewer/${prd}/simulate/`,{method:'POST',headers:{'Content-Type':'application/json','X-CSRFToken':csrf,'X-Requested-With':'XMLHttpRequest'},body:JSON.stringify({selections:sel,qty})});const ct=r.headers.get('content-type')||'';if(!ct.includes('json'))return{__http:r.status};return await r.json();}
const out=[];
for(const p of PRDS){
  const rec={prd_cd:p.prd_cd,nm:p.nm,typ:p.typ};
  try{
    const m=await meta(p.prd_cd);
    if(!m){rec.status='META_FAIL';out.push(rec);continue;}
    rec.is_set=!!m.is_set;rec.frm=m.frm?(m.frm.frm_cd||m.frm):null;rec.ncomp=(m.components||[]).length;
    const sel={};
    for(const d of (m.prod_dims||[])){const o=d.options||[];if(!o.length)continue;const pk=o.find(x=>x.dflt)||o[0];sel[d.name]=pk.v;}
    const qty=(m.qty_rule&&(m.qty_rule.dflt||m.qty_rule.min))||1;
    rec.qty=qty;
    const j=await sim(p.prd_cd,sel,qty);
    if(j.__http){rec.status='SIM_HTTP_'+j.__http;out.push(rec);continue;}
    rec.ok=j.ok;rec.final=j.final_price;
    const comps=(j.base&&j.base.components)||[];
    rec.incl=comps.filter(c=>c.included).length;
    rec.excl=comps.filter(c=>!c.included).length;
    rec.excl_comps=comps.filter(c=>!c.included).map(c=>c.comp_cd+':'+(c.error||c.reason||'?'));
    if(rec.final==null){rec.status='NO_PRICE';}
    else if(rec.excl>0){rec.status='HAS_EXCLUDED';}
    else if(rec.final===0){rec.status='ZERO_PRICE';}
    else{rec.status='OK';}
  }catch(e){rec.status='EXC';rec.err=String(e).slice(0,100);}
  out.push(rec);
}
return JSON.stringify(out);
