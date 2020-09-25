import os
import sys
import cadquery as cq
from typing import Tuple, cast

_ctx = None


def set_ctx(ctx) -> None:
    """
    Call setCtx() with globals() prior to using
    show or dbg methods when using cq-editor.
    """
    global _ctx
    _ctx = ctx


if "cq_editor" in sys.modules:
    # from __main__ import self as _cq_editor
    from logbook import info as _cq_log

    def show(o: object, name=None):
        if _ctx is None:
            raise ValueError("utils.setCtx was not called")
        if _ctx["show_object"] is None:
            raise ValueError("_ctx['show_object'] is not available")
        _ctx["show_object"](o, name=name)
        # _cq_editor.components["object_tree"].addObject(o) # Does not work

    def dbg(*args):
        _cq_log(*args)


else:

    def show(o: object, name=None):
        if name is None:
            name = str(id(o))
        if o is None:
            dbg(f"{name}: o=None")
        elif isinstance(o, cq.Workplane):
            wp: cq.Workplane = o
            if isinstance(wp.val(), cq.Shape):
                dbg(f"{name}: valid={cast(cq.Shape, wp.val()).isValid()} {vars(o)}")
            else:
                dbg(f"{name}: vars(o))")
        else:
            dbg(f"{name}: {o}")

    def dbg(*args):
        print(*args)


def scale_tuple(t: Tuple[float, ...], v: float) -> Tuple[float, ...]:
    """Scale the elements of the tuple by v"""
    # dbg(f'scaleTuple: t={t} v={v}')
    return tuple(i for i in map(lambda p: p * v, t))


def dbg_circle(x, y, radius, name=None) -> None:
    c = cq.Workplane("XY", origin=(x, y, 0)).circle(radius, forConstruction=True)
    show(c, name)


# TODO: Need to inject into workplane?
def lineTo_scaled(wp: cq.Workplane, x, y, v) -> cq.Workplane:
    return wp.lineTo(x * v, y * v)

