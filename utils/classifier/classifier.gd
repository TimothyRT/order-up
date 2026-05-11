extends ONNXLoader


func _ready() -> void:
	load_model("utils/classifier/clf_svm_30hz.onnx")


func classify(input_arr: Array) -> int:
	if len(input_arr) < 90:
		return -1
	var output_arr = predict(input_arr)
	print("Input Arr: %s" % str(input_arr))
	print("Output Arr: %s" % str(output_arr))
	if len(output_arr) > 0:
		return output_arr[0]
	return -1
