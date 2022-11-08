extends Reference

class_name Arr

static func array_to_csv_string(arr: Array) -> String:
	var s : String = ""
	for i in range(arr.size()):
		var el = arr[i]
		var el_type = typeof(el)
		# if the argument is array of arrays
		if(el_type == 19): # array type
			var sub_s : String = ""
			for sub_i in range(el.size()):
				var sub_el = el[sub_i]
				# don't add comma to the last sub element
				if(sub_i == el.size()-1):
					sub_s = sub_s + str(sub_el)
				else:
					sub_s = sub_s + str(sub_el) + ","
			if(i != arr.size()-1):
				sub_s = sub_s + "\n" #newline 
			# add substring to the returned string
			s = s + sub_s
		else:
			# don't add comma to the last element			
			if(i == arr.size()-1):
				s = s + str(el)
			else:
				s = s + str(el) + ","
	return s
	


