#!/usr/bin/env python3
"""Asset conversion for DTM. Requires Blender 4.x (with OpenUSD for track)."""
import bpy
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def clear_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def convert_car():
    clear_scene()
    fbx = os.path.join(ROOT, "assets/car/source/2004 Audi TT-R #8 Team ABT Sportsline.fbx")
    if not os.path.exists(fbx):
        print("Car FBX not found, skipping")
        return
    bpy.ops.import_scene.fbx(filepath=fbx)
    out = os.path.join(ROOT, "assets/car/car.glb")
    bpy.ops.export_scene.gltf(filepath=out, export_format='GLB', export_apply=True, export_materials='EXPORT', export_texcoords=True, export_normals=True)
    print(f"Car exported: {out}")

def convert_track():
    clear_scene()
    usd = os.path.join(ROOT, "assets/track/scene.usdc")
    if not os.path.exists(usd):
        print("Track USDC not found, skipping")
        return
    try:
        bpy.ops.wm.usd_import(filepath=usd)
    except Exception as e:
        print(f"USD import failed: {e}")
        return
    out = os.path.join(ROOT, "assets/track/suzuka.glb")
    bpy.ops.export_scene.gltf(filepath=out, export_format='GLB', export_apply=True, export_materials='EXPORT')
    print(f"Track exported: {out}")

if __name__ == "__main__":
    convert_car()
    convert_track()
    print("Done")
