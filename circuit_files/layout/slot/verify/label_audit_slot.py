# klayout -b -r verify/label_audit_slot.py : every top-level text of sar_adc_r4_slot sits on metal of its own layer
# (flattened, all hierarchy) and on the macro boundary; the text set equals the slot-8 pin set used by the design
import json, pya
H = __import__("os").path.dirname(__import__("os").path.abspath(__file__)) + "/../"
ly = pya.Layout(); ly.read(H + "gds/sar_adc_r4_slot.gds")
top = ly.top_cell()
MET = {34: "M1", 36: "M2", 42: "M3", 46: "M4", 81: "M5"}
reg = {}
for ln in MET:
    li = ly.find_layer(ln, 0)
    reg[ln] = pya.Region(top.begin_shapes_rec(li)) if li is not None else pya.Region()
bb = top.dbbox()
texts, bad, offedge = [], [], []
for li in ly.layer_indexes():
    info = ly.get_info(li)
    for s in top.shapes(li).each():
        if not s.is_text():
            continue
        t = s.text; x, y = t.x * ly.dbu, t.y * ly.dbu
        texts.append(t.string)
        ln = info.layer
        p = pya.Box(t.x - 5, t.y - 5, t.x + 5, t.y + 5)
        if ln not in reg or reg[ln].interacting(pya.Region(p)).is_empty():
            bad.append([t.string, ln, round(x, 3), round(y, 3)])
        if min(abs(x - bb.left), abs(x - bb.right), abs(y - bb.bottom), abs(y - bb.top)) > 1.0:
            offedge.append([t.string, round(x, 3), round(y, 3)])
exp = (["clk", "enable", "reset", "analog_bus0", "analog_bus1", "analog_bus3", "s8_an[0]", "vdd_3v3", "vss_3v3"]
       + [f"dig_in[{k}]" for k in range(24)] + [f"dig_out[{k}]" for k in range(12)])
res = dict(n_texts=len(texts), names=sorted(set(texts)), missing=sorted(set(exp) - set(texts)),
           extra=sorted(set(texts) - set(exp)), not_on_metal=bad, not_on_boundary=offedge,
           multi={n: texts.count(n) for n in set(texts) if texts.count(n) > 1})
res["result"] = "PASS" if not (res["missing"] or res["extra"] or bad or offedge) else "FAIL"
json.dump(res, open(H + "verify/label_audit.json", "w"), indent=1)
print(json.dumps({k: v for k, v in res.items() if k != "names"}))
