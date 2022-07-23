/atom/proc/calculate_smithing_stats(grade)
	return

/obj/item/pickaxe/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 8
			throwforce = 3
			toolspeed = 1.2
		if(2)
			force = 12
			throwforce = 5
			toolspeed = 1
		if(3)
			force = 13
			throwforce = 7
			toolspeed = 0.8
		if(4)
			force = 14
			throwforce = 8
			toolspeed = 0.6
		if(5)
			force = 15
			throwforce = 9
			toolspeed = 0.4
		if(6)
			force = 20
			throwforce = 10
			toolspeed = 0.2

/obj/item/blacksmith/zwei/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 15
			throwforce = 8
			block_chance = 2
		if(2)
			force = 20
			throwforce = 10
			block_chance = 3
		if(3)
			force = 25
			throwforce = 13
			block_chance = 4
		if(4)
			force = 30
			throwforce = 15
			block_chance = 6
		if(5)
			force = 40
			throwforce = 20
			block_chance = 7
		if(6)
			force = 50
			throwforce = 18
			block_chance = 10

/obj/item/blacksmith/flail/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 9
			throwforce = 8
			block_chance = 0
		if(2)
			force = 10
			throwforce = 10
			block_chance = 0
		if(3)
			force = 15
			throwforce = 15
			block_chance = 0
		if(4)
			force = 20
			throwforce = 20
			block_chance = 0
		if(5)
			force = 25
			throwforce = 25
			block_chance = 0
		if(6)
			force = 30
			throwforce = 30
			block_chance = 0

/obj/item/blacksmith/dagger/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 3
			throwforce = 2
			block_chance = 0
		if(2)
			force = 5
			throwforce = 3
			block_chance = 0
		if(3)
			force = 7
			throwforce = 5
			block_chance = 0
		if(4)
			force = 9
			throwforce = 7
			block_chance = 0
		if(5)
			force = 13
			throwforce = 8
			block_chance = 0
		if(6)
			force = 18
			throwforce = 10
			block_chance = 0

/obj/item/blacksmith/sword/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			force = 15
			throwforce = 12
			block_chance = 0
		if(2)
			force = 17
			throwforce = 16
			block_chance = 5
		if(3)
			force = 23
			throwforce = 19
			block_chance = 10
		if(4)
			force = 28
			throwforce = 23
			block_chance = 15
		if(5)
			force = 35
			throwforce = 28
			block_chance = 20
		if(6)
			force = 40
			throwforce = 34
			block_chance = 25

/obj/item/clothing/suit/armor/light_plate/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=20, PIERCE=15, BLUNT=10, FIRE=10, ACID=15, WOUND=30)
		if(2)
			armor = list(SHARP=25, PIERCE=20, BLUNT=15, FIRE=15, ACID=20, WOUND=35)
		if(3)
			armor = list(SHARP=30, PIERCE=25, BLUNT=20, FIRE=20, ACID=25, WOUND=40)
		if(4)
			armor = list(SHARP=35, PIERCE=30, BLUNT=25, FIRE=25, ACID=30, WOUND=45)
		if(5)
			armor = list(SHARP=40, PIERCE=35, BLUNT=30, FIRE=30, ACID=35, WOUND=50)
		if(6)
			armor = list(SHARP=45, PIERCE=40, BLUNT=35, FIRE=35, ACID=40, WOUND=55)

/obj/item/clothing/suit/armor/heavy_plate/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=35, PIERCE=30, BLUNT=15, FIRE=20, ACID=20, WOUND=45)
		if(2)
			armor = list(SHARP=40, PIERCE=35, BLUNT=20, FIRE=25, ACID=25, WOUND=50)
		if(3)
			armor = list(SHARP=45, PIERCE=40, BLUNT=25, FIRE=30, ACID=30, WOUND=55)
		if(4)
			armor = list(SHARP=50, PIERCE=45, BLUNT=30, FIRE=35, ACID=35, WOUND=60)
		if(5)
			armor = list(SHARP=60, PIERCE=60, BLUNT=40, FIRE=45, ACID=45, WOUND=70)
		if(6)
			armor = list(SHARP=65, PIERCE=65, BLUNT=45, FIRE=50, ACID=50, WOUND=75)

/obj/item/clothing/under/chainmail/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=10, PIERCE=5, BLUNT=0, FIRE=0, ACID=0, WOUND=20)
		if(2)
			armor = list(SHARP=15, PIERCE=10, BLUNT=0, FIRE=0, ACID=0, WOUND=25)
		if(3)
			armor = list(SHARP=20, PIERCE=15, BLUNT=0, FIRE=0, ACID=0, WOUND=30)
		if(4)
			armor = list(SHARP=25, PIERCE=20, BLUNT=0, FIRE=0, ACID=0, WOUND=35)
		if(5)
			armor = list(SHARP=35, PIERCE=30, BLUNT=0, FIRE=0, ACID=0, WOUND=45)
		if(6)
			armor = list(SHARP=40, PIERCE=35, BLUNT=0, FIRE=0, ACID=0, WOUND=50)

/obj/item/clothing/head/helmet/plate_helmet/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=10, PIERCE=20, BLUNT=6, FIRE=6, ACID=6, WOUND=30)
		if(2)
			armor = list(SHARP=15, PIERCE=25, BLUNT=9, FIRE=9, ACID=9, WOUND=35)
		if(3)
			armor = list(SHARP=20, PIERCE=30, BLUNT=12, FIRE=12, ACID=12, WOUND=40)
		if(4)
			armor = list(SHARP=25, PIERCE=35, BLUNT=15, FIRE=15, ACID=15, WOUND=45)
		if(5)
			armor = list(SHARP=35, PIERCE=45, BLUNT=25, FIRE=25, ACID=25, WOUND=55)
		if(6)
			armor = list(SHARP=40, PIERCE=50, BLUNT=30, FIRE=30, ACID=30, WOUND=60)

/obj/item/clothing/gloves/plate_gloves/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=10, PIERCE=5, BLUNT=0, FIRE=6, ACID=5, WOUND=5)
		if(2)
			armor = list(SHARP=15, PIERCE=10, BLUNT=6, FIRE=10, ACID=8, WOUND=10)
		if(3)
			armor = list(SHARP=20, PIERCE=15, BLUNT=8, FIRE=12, ACID=10, WOUND=14)
		if(4)
			armor = list(SHARP=25, PIERCE=20, BLUNT=10, FIRE=14, ACID=13, WOUND=18)
		if(5)
			armor = list(SHARP=35, PIERCE=30, BLUNT=20, FIRE=25, ACID=25, WOUND=35)
		if(6)
			armor = list(SHARP=40, PIERCE=35, BLUNT=25, FIRE=30, ACID=30, WOUND=40)

/obj/item/clothing/shoes/jackboots/plate_boots/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=10, PIERCE=5, BLUNT=0, FIRE=0, ACID=0, WOUND=10)
		if(2)
			armor = list(SHARP=15, PIERCE=10, BLUNT=4, FIRE=5, ACID=5, WOUND=12)
		if(3)
			armor = list(SHARP=20, PIERCE=15, BLUNT=6, FIRE=10, ACID=10, WOUND=16)
		if(4)
			armor = list(SHARP=25, PIERCE=20, BLUNT=10, FIRE=15, ACID=15, WOUND=19)
		if(5)
			armor = list(SHARP=30, PIERCE=25, BLUNT=12, FIRE=20, ACID=20, WOUND=25)
		if(6)
			armor = list(SHARP=35, PIERCE=30, BLUNT=15, FIRE=25, ACID=25, WOUND=30)

/obj/item/clothing/head/helmet/dwarf_crown/calculate_smithing_stats(grade)
	switch(grade)
		if(1)
			armor = list(SHARP=5, PIERCE=5, BLUNT=5, FIRE=10, ACID=10, WOUND=20)
		if(2)
			armor = list(SHARP=10, PIERCE=10, BLUNT=10, FIRE=20, ACID=20,WOUND=25)
		if(3)
			armor = list(SHARP=15, PIERCE=15, BLUNT=15, FIRE=30, ACID=30, WOUND=30)
		if(4)
			armor = list(SHARP=20, PIERCE=20, BLUNT=20, FIRE=40, ACID=40, WOUND=35)
		if(5)
			armor = list(SHARP=30, PIERCE=30, BLUNT=30, FIRE=80, ACID=80, WOUND=45)
		if(6)
			armor = list(SHARP=35, PIERCE=35, BLUNT=35, FIRE=100, ACID=100, WOUND=50)
