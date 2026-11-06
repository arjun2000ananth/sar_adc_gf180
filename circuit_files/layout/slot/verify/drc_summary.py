#!/usr/bin/env python3
"""summarise the KLayout DRC report of the v2 top: geometric violations vs whole-die density rules"""
import collections, json, sys, xml.etree.ElementTree as ET
from pathlib import Path
H = Path(__file__).resolve().parent
rep = sys.argv[1] if len(sys.argv) > 1 else "drc_klayout.lyrdb"
t = ET.parse(H / rep).getroot()
cnt = collections.Counter(i.find("category").text.strip("'") for i in t.find("items"))
DENS = {"DCF.1b", "PL.8", "M1.4", "M2.4", "M3.4", "M4.4", "M5.4", "MT.3", "COMP.11", "PL.12"}
geo = {k: v for k, v in cnt.items() if k not in DENS}
den = {k: v for k, v in cnt.items() if k in DENS}
(H / (Path(rep).stem + "_summary.json")).write_text(json.dumps(dict(geometric=geo, density_chip_level=den), indent=1))
print("klayout DRC: geometric violations", sum(geo.values()), geo, "| whole-die density flags", den)
