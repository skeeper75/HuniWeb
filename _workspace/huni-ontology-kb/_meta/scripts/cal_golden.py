import sys,pathlib
sys.path.insert(0,'.')
import lib_huni as H
H.load_env()
sim=H.HuniSim()
# choose a sensible paper mat per product (avoid 삼각대/링 contamination for COMP_PAPER)
PAPER={"PRD_000108":"MAT_000090","PRD_000109":"MAT_000090","PRD_000110":"MAT_000090",
       "PRD_000111":"MAT_000074","PRD_000112":"MAT_000093"}
BINDPROC={"PRD_000108":"PROC_000100","PRD_000109":"PROC_000102","PRD_000110":None,
          "PRD_000111":"PROC_000099","PRD_000112":"PROC_000099"}
for prd in ["PRD_000108","PRD_000109","PRD_000110","PRD_000111","PRD_000112"]:
    m=sim.sim_meta(prd)
    sel={}
    for d in m.get("prod_dims",[]):
        nm=d["name"]; opts=d.get("options",[])
        if nm=="mat_cd":
            sel["mat_cd"]=PAPER[prd]; continue
        if d.get("kind")=="proc": continue
        dfl=[o for o in opts if o.get("dflt")] or opts
        if dfl: sel[nm]=dfl[0]["v"]
    procs=[{"proc_cd":"PROC_000004"}]
    if BINDPROC[prd]: procs.append({"proc_cd":BINDPROC[prd]})
    try:
        r=sim.simulate(prd, sel, 100, procs=procs)
        p=H.price_of(r)
        comps=[(cn,sub) for cc,cn,sub,pa,ok in H.components_of(r)]
        print(prd, m["frm"]["frm_cd"], "final=",p, sel, comps)
    except Exception as e:
        print(prd,"ERR",repr(e)[:150])
