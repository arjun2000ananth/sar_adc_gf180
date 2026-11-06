import sys, re, collections, xml.etree.ElementTree as ET
t = ET.parse(sys.argv[1]).getroot()
out = collections.defaultdict(list)
for it in t.find("items"):
    cat = it.find("category").text.strip("'")
    v = it.find("values")
    txt = " ".join(x.text for x in v) if v is not None else ""
    nums = [float(x) for x in re.findall(r"-?\d+\.\d+|-?\d+", txt)]
    if len(nums) >= 2:
        xs, ys = nums[0::2], nums[1::2]
        out[cat].append((round(sum(xs) / len(xs), 2), round(sum(ys) / len(ys), 2)))
for c, l in out.items():
    if c in sys.argv[2:] or len(sys.argv) == 2:
        print(c, len(l), sorted(l)[:60])
