import constants

def convert_value_to_string(value):
	if isinstance(value, str):
		return value
	elif isinstance(value, int):
		return str(value)
	elif isinstance(value, float):
		return str(value)
	elif isinstance(value, list):
		string = ''
		for index, v in enumerate(value):
			if(index < len(value)-1):
				string += str(v) + constants.MESSAGE_ARR_DATA_DELIMITER
			else:
				string += str(v)
		return string
	else:
		 raise TypeError("Unsupported type")

