import os
import sys
import cadquery as cq
from typing import Tuple, cast


from utils import show, dbg, dbg_circle, set_ctx, scale_tuple

set_ctx(globals())

thickness = 2
scale = 10
result = (
    cq.Workplane("front")
    .moveTo(1 * scale, -1 * scale)
    .threePointArc(scale_tuple((0.0, 0.0), scale), scale_tuple((1.0, 1.0), scale))
    .lineTo(4.5 * scale, 1 * scale)
    .lineTo(5 * scale, 3 * scale)
    .threePointArc(scale_tuple((6.5, 2.3), scale), scale_tuple((7.0, 1.0), scale))
    .lineTo(7 * scale, -1 * scale)
    .close()
    .extrude(thickness)
)
show(result, "r")

dbg_circle(7, -1, 0.1, name="last pt")

stl_tolerance = 0.001
directory: str = "generated/"
fname = f"t1.stl"
cq.exporters.export(result, os.path.join(directory, fname), tolerance=stl_tolerance)
dbg(f"{fname}")

