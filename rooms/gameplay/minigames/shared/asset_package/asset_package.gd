class_name AssetPackage
extends Node


func get_asset(idx: int) -> Texture2D:
	return get_child(idx).texture
