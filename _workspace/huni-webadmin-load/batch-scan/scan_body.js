// 배치 진단 스캐너 (v2) — 오탐 저감: 필수 공정(단일 공정그룹) 자동선택 추가.
// PRDS 상수(gen_scan.py가 임베드) 사용. top-level await. 읽기전용(계산 API만).
const csrf=(document.cookie.match('(^|;)\\s*csrftoken\\s*=\\s*([^;]+)')||[]).pop()||'';
async function meta(prd){const r=await fetch(`/admin/price-viewer/${prd}/sim-meta/`,{headers:{'X-Requested-With':'XMLHttpRequest'}});if(!r.ok)return null;try{return await r.json();}catch(e){return null;}}
async function sim(prd,sel,qty,procs){const b={selections:sel,qty};if(procs&&procs.length)b.procs=procs;const r=await fetch(`/admin/price-viewer/${prd}/simulate/`,{method:'POST',headers:{'Content-Type':'application/json','X-CSRFToken':csrf,'X-Requested-With':'XMLHttpRequest'},body:JSON.stringify(b)});const ct=r.headers.get('content-type')||'';if(!ct.includes('json'))return{__http:r.status};return await r.json();}
const out=[];
for(const p of PRDS){
  const rec={prd_cd:p.prd_cd,nm:p.nm,typ:p.typ};
  try{
    const m=await meta(p.prd_cd);
    if(!m){rec.status='META_FAIL';out.push(rec);continue;}
    rec.is_set=!!m.is_set;rec.frm=m.frm?(m.frm.frm_cd||m.frm):null;rec.ncomp=(m.components||[]).length;
    // 기본 차원선택: prod_dims 비공정 차원의 dflt(없으면 첫)
    const sel={};
    const procDim=(m.prod_dims||[]).find(d=>d.name==='proc_cd');
    for(const d of (m.prod_dims||[])){
      if(d.name==='proc_cd') continue;
      const o=d.options||[];if(!o.length)continue;const pk=o.find(x=>x.dflt)||o[0];sel[d.name]=pk.v;
    }
    // ★필수 공정 자동선택: 상품이 그룹당 1개만 제공하는 공정그룹(=필수·제본류)을 빈 detail로 선택
    const proc_sels=[];
    if(procDim){
      const byGrp={};
      for(const o of (procDim.options||[])){const g=o.grp_cd||'_';(byGrp[g]=byGrp[g]||[]).push(o);}
      for(const g in byGrp){ if(byGrp[g].length===1){ proc_sels.push({proc_cd:byGrp[g][0].v, detail:{}}); } }
    }
    rec.autoproc=proc_sels.map(x=>x.proc_cd);
    let qty=(m.qty_rule&&(m.qty_rule.dflt||m.qty_rule.min))||1;
    let j=await sim(p.prd_cd,sel,qty,proc_sels);
    // ★수량 재시도: below_min_qty(단가행 최소미달)면 높은 수량으로 재시도(스캔한계 저감)
    function hasBelowMin(res){return ((res.base&&res.base.components)||[]).some(c=>!c.included&&(c.error||c.reason||'').includes('below_min'));}
    if(!j.__http && hasBelowMin(j)){
      const hi=Math.min((m.qty_rule&&m.qty_rule.max)||10000, 5000);
      const inc=(m.qty_rule&&m.qty_rule.incr)||1; const q2=Math.ceil(hi/inc)*inc;
      const j2=await sim(p.prd_cd,sel,q2,proc_sels);
      if(!j2.__http){ j=j2; qty=q2; rec.qty_retry=true; }
    }
    // ★조합 재시도: 기본옵션 조합이 0원이면 대체 옵션조합 시도(폼보드류=기본 mat에 단가행 없음 저감)
    if(!j.__http && !(j.final_price>0)){
      const dims=(m.prod_dims||[]).filter(d=>d.name!=='proc_cd' && (d.options||[]).length>1);
      let combos=[{...sel}];
      for(const d of dims){const nc=[];for(const c of combos){for(const o of (d.options||[]).slice(0,6)){nc.push({...c,[d.name]:o.v});}}combos=nc.slice(0,30);}
      for(const cs of combos.slice(0,30)){
        const jr=await sim(p.prd_cd,cs,qty,proc_sels);
        if(!jr.__http && jr.final_price>0){ j=jr; rec.combo_retry=true; break; }
      }
    }
    rec.qty=qty;
    if(j.__http){rec.status='SIM_HTTP_'+j.__http;out.push(rec);continue;}
    rec.ok=j.ok;rec.final=j.final_price;
    const comps=(j.base&&j.base.components)||[];
    rec.incl=comps.filter(c=>c.included).length;
    rec.excl=comps.filter(c=>!c.included).length;
    rec.excl_comps=comps.filter(c=>!c.included).map(c=>c.comp_cd+':'+(c.error||c.reason||'?'));
    // 분류: 최종가>0=상품이 견적됨(base 정상·제외는 옵션). 0/null=진짜 결함.
    if(rec.final==null){rec.status='NO_PRICE';}
    else if(rec.final>0){rec.status='OK';}       // 가격 산출됨(옵션 제외는 정상)
    else{rec.status='ZERO_PRICE';}               // final===0 = base 안나옴
  }catch(e){rec.status='EXC';rec.err=String(e).slice(0,100);}
  out.push(rec);
}
return JSON.stringify(out);
