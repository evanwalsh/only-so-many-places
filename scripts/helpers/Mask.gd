class_name Mask
extends Object


static func for_layers(layers: Array) -> int:
	var mask := 0

	for layer in layers:
		mask += int(pow(2, layer - 1))

	return mask
