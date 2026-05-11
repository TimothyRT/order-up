class_name ItemDicingArea
extends Polygon2D


func random_point_in_polygon() -> Vector2:
	var poly := polygon
	var indices = Geometry2D.triangulate_polygon(poly)

	if indices.is_empty():
		return Vector2.ZERO

	var triangles = []
	var total_area := 0.0

	for i in range(0, indices.size(), 3):
		var a = poly[indices[i]]
		var b = poly[indices[i + 1]]
		var c = poly[indices[i + 2]]

		var area = abs((b - a).cross(c - a)) * 0.5

		total_area += area

		triangles.append({
			"a": a,
			"b": b,
			"c": c,
			"area": area,
		})

	var r = randf() * total_area
	var accum := 0.0

	for tri in triangles:
		accum += tri.area

		if r <= accum:
			return random_point_in_triangle(
				tri.a,
				tri.b,
				tri.c
			)

	return Vector2.ZERO


func random_point_in_triangle(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var r1 = sqrt(randf())
	var r2 = randf()

	return (
		(1.0 - r1) * a +
		(r1 * (1.0 - r2)) * b +
		(r1 * r2) * c
	)
