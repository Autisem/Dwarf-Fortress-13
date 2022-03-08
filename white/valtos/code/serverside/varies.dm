/proc/get_num_string(amount, type = "cr")
	amount = text2num(copytext("[amount]", -2))
	if(amount >= 20)
		amount = text2num(copytext("[amount]", -1))
	switch(type)
		if("cr")
			switch(amount)
				if(0, 5 to 20)
					return "ов"
				if(1)
					return ""
				if(2 to 4)
					return "а"
