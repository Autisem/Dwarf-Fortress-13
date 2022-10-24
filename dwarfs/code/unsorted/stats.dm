/obj/proc/apply_grade(grade)
	src.grade = grade
	var/grd_name = grade_name(grade)
	name = "[grd_name][initial(name)][grd_name]"

/proc/grade_name(grade)
	var/list/grades = list("*", "-", "+", "≡", "☼", "☼☼")
	return grades[grade]

/*******************************************************************************************************************/


/obj/item/zwei/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 20
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=8, PIERCE=4, BLUNT=2, FIRE=0, WOUND=0)
        if(2)
            force = 27
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=8, PIERCE=4, BLUNT=4, FIRE=0, WOUND=0)
        if(3)
            force = 33
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=9, PIERCE=5, BLUNT=5, FIRE=0, WOUND=0)
        if(4)
            force = 38
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=11, PIERCE=6, BLUNT=5, FIRE=0, WOUND=0)
        if(5)
            force = 42
            throwforce = 36
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=13, PIERCE=7, BLUNT=6, FIRE=0, WOUND=0)
        if(6)
            force = 45
            throwforce = 40
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=15, PIERCE=8, BLUNT=8, FIRE=0, WOUND=0)

/obj/item/flail/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 9
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=2, BLUNT=2, FIRE=0, WOUND=0)
        if(2)
            force = 12
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=3, BLUNT=4, FIRE=0, WOUND=0)
        if(3)
            force = 16
            throwforce = 14
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=1, PIERCE=3, BLUNT=6, FIRE=0, WOUND=0)
        if(4)
            force = 21
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=2, PIERCE=5, BLUNT=8, FIRE=0, WOUND=0)
        if(5)
            force = 25
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=3, PIERCE=5, BLUNT=9, FIRE=0, WOUND=0)
        if(6)
            force = 30
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=4, PIERCE=6, BLUNT=10, FIRE=0, WOUND=0)

/obj/item/dagger/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=4, PIERCE=5, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=5, PIERCE=7, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 9
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=7, PIERCE=8, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=8, PIERCE=9, BLUNT=1, FIRE=0, WOUND=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=9, PIERCE=11, BLUNT=2, FIRE=0, WOUND=0)
        if(6)
            force = 18
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=10, PIERCE=13, BLUNT=3, FIRE=0, WOUND=0)

/obj/item/sword/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 10
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=5, PIERCE=3, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 15
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=7, PIERCE=3, BLUNT=1, FIRE=0, WOUND=0)
        if(3)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=9, PIERCE=5, BLUNT=2, FIRE=0, WOUND=0)
        if(4)
            force = 23
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=11, PIERCE=6, BLUNT=3, FIRE=0, WOUND=0)
        if(5)
            force = 26
            throwforce = 21
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=12, PIERCE=7, BLUNT=4, FIRE=0, WOUND=0)
        if(6)
            force = 31
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=14, PIERCE=8, BLUNT=5, FIRE=0, WOUND=0)

/obj/item/spear/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=2, PIERCE=7, BLUNT=2, FIRE=0, WOUND=0)
        if(2)
            force = 16
            throwforce = 16
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=3, PIERCE=7, BLUNT=2, FIRE=0, WOUND=0)
        if(3)
            force = 23
            throwforce = 20
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=5, PIERCE=9, BLUNT=3, FIRE=0, WOUND=0)
        if(4)
            force = 26
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=5, PIERCE=11, BLUNT=5, FIRE=0, WOUND=0)
        if(5)
            force = 30
            throwforce = 28
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=7, PIERCE=13, BLUNT=6, FIRE=0, WOUND=0)
        if(6)
            force = 34
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=8, PIERCE=14, BLUNT=7, FIRE=0, WOUND=0)

/obj/item/warhammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=5, FIRE=0, WOUND=0)
        if(2)
            force = 19
            throwforce = 17
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=1, PIERCE=2, BLUNT=7, FIRE=0, WOUND=0)
        if(3)
            force = 23
            throwforce = 24
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=2, PIERCE=3, BLUNT=9, FIRE=0, WOUND=0)
        if(4)
            force = 28
            throwforce = 29
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=3, PIERCE=5, BLUNT=11, FIRE=0, WOUND=0)
        if(5)
            force = 32
            throwforce = 35
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=3, PIERCE=5, BLUNT=12, FIRE=0, WOUND=0)
        if(6)
            force = 36
            throwforce = 45
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=4, PIERCE=6, BLUNT=13, FIRE=0, WOUND=0)

/obj/item/halberd/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=3, PIERCE=4, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 17
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=5, PIERCE=5, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 18
            throwforce = 13
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=7, PIERCE=8, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=10, PIERCE=12, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 24
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=15, PIERCE=14, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 28
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=18, PIERCE=18, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/scepter/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=1, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=2, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=4, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=5, FIRE=0, WOUND=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=6, FIRE=0, WOUND=0)

/obj/item/pickaxe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.8
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/axe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 15
            throwforce = 17
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/hoe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 11
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 14
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 10
            throwforce = 16
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/shovel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 6
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 10
            throwforce = 18
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/chisel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 2
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 4
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 5
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/builder_hammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 12
            throwforce = 14
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/smithing_hammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/tongs/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/trowel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/kitchen/knife/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 3
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)


/*******************************************************************************************************************/

/obj/item/clothing/suit/armor/light_plate/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=6, PIERCE=2, BLUNT=0, FIRE=4, WOUND=15)
        if(2)
            armor = list(SHARP=9, PIERCE=4, BLUNT=3, FIRE=5, WOUND=20)
        if(3)
            armor = list(SHARP=12, PIERCE=8, BLUNT=5, FIRE=6, WOUND=25)
        if(4)
            armor = list(SHARP=16, PIERCE=10, BLUNT=7, FIRE=7, WOUND=30)
        if(5)
            armor = list(SHARP=19, PIERCE=12, BLUNT=9, FIRE=8, WOUND=35)
        if(6)
            armor = list(SHARP=23, PIERCE=15, BLUNT=14, FIRE=9, WOUND=40)

/obj/item/clothing/suit/armor/heavy_plate/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=9, PIERCE=3, BLUNT=2, FIRE=6, WOUND=20)
        if(2)
            armor = list(SHARP=12, PIERCE=5, BLUNT=5, FIRE=7, WOUND=25)
        if(3)
            armor = list(SHARP=15, PIERCE=9, BLUNT=8, FIRE=8, WOUND=30)
        if(4)
            armor = list(SHARP=18, PIERCE=12, BLUNT=11, FIRE=9, WOUND=40)
        if(5)
            armor = list(SHARP=24, PIERCE=14, BLUNT=14, FIRE=10, WOUND=45)
        if(6)
            armor = list(SHARP=30, PIERCE=17, BLUNT=18, FIRE=11, WOUND=50)

/obj/item/clothing/under/chainmail/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=5, PIERCE=0, BLUNT=2, FIRE=5, WOUND=10)
        if(2)
            armor = list(SHARP=8, PIERCE=3, BLUNT=5, FIRE=6, WOUND=15)
        if(3)
            armor = list(SHARP=11, PIERCE=6, BLUNT=7, FIRE=7, WOUND=20)
        if(4)
            armor = list(SHARP=14, PIERCE=9, BLUNT=10, FIRE=8, WOUND=25)
        if(5)
            armor = list(SHARP=17, PIERCE=12, BLUNT=12, FIRE=9, WOUND=30)
        if(6)
            armor = list(SHARP=20, PIERCE=14, BLUNT=15, FIRE=10, WOUND=35)

/obj/item/clothing/head/helmet/plate_helmet/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=5, PIERCE=3, BLUNT=2, FIRE=5, WOUND=15)
        if(2)
            armor = list(SHARP=9, PIERCE=5, BLUNT=4, FIRE=6, WOUND=20)
        if(3)
            armor = list(SHARP=13, PIERCE=8, BLUNT=7, FIRE=7, WOUND=25)
        if(4)
            armor = list(SHARP=17, PIERCE=11, BLUNT=9, FIRE=8, WOUND=30)
        if(5)
            armor = list(SHARP=20, PIERCE=13, BLUNT=12, FIRE=9, WOUND=35)
        if(6)
            armor = list(SHARP=23, PIERCE=16, BLUNT=15, FIRE=10, WOUND=40)

/obj/item/clothing/gloves/plate_gloves/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=5, PIERCE=3, BLUNT=2, FIRE=5, WOUND=15)
        if(2)
            armor = list(SHARP=9, PIERCE=5, BLUNT=4, FIRE=6, WOUND=20)
        if(3)
            armor = list(SHARP=13, PIERCE=8, BLUNT=7, FIRE=7, WOUND=25)
        if(4)
            armor = list(SHARP=17, PIERCE=11, BLUNT=9, FIRE=8, WOUND=30)
        if(5)
            armor = list(SHARP=20, PIERCE=13, BLUNT=12, FIRE=9, WOUND=35)
        if(6)
            armor = list(SHARP=23, PIERCE=16, BLUNT=15, FIRE=10, WOUND=40)

/obj/item/clothing/shoes/jackboots/plate_boots/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=5, PIERCE=3, BLUNT=2, FIRE=5, WOUND=15)
        if(2)
            armor = list(SHARP=9, PIERCE=5, BLUNT=4, FIRE=6, WOUND=20)
        if(3)
            armor = list(SHARP=13, PIERCE=8, BLUNT=7, FIRE=7, WOUND=25)
        if(4)
            armor = list(SHARP=17, PIERCE=11, BLUNT=9, FIRE=8, WOUND=30)
        if(5)
            armor = list(SHARP=20, PIERCE=13, BLUNT=12, FIRE=9, WOUND=35)
        if(6)
            armor = list(SHARP=23, PIERCE=16, BLUNT=15, FIRE=10, WOUND=40)

/obj/item/clothing/head/helmet/dwarf_crown/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=2, PIERCE=0, BLUNT=0, FIRE=5, WOUND=0)
        if(2)
            armor = list(SHARP=4, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            armor = list(SHARP=6, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            armor = list(SHARP=8, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            armor = list(SHARP=9, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            armor = list(SHARP=10, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/clothing/shoes/boots/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=1, PIERCE=0, BLUNT=0, FIRE=5, WOUND=0)
        if(2)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/clothing/under/tunic/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=1, PIERCE=0, BLUNT=0, FIRE=5, WOUND=0)
        if(2)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(3)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(4)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(5)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)
        if(6)
            armor = list(SHARP=0, PIERCE=0, BLUNT=0, FIRE=0, WOUND=0)

/obj/item/clothing/head/helmet/light_helmet/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor = list(SHARP=3, PIERCE=2, BLUNT=2, FIRE=4, WOUND=10)
        if(2)
            armor = list(SHARP=5, PIERCE=4, BLUNT=3, FIRE=5, WOUND=15)
        if(3)
            armor = list(SHARP=8, PIERCE=7, BLUNT=5, FIRE=6, WOUND=20)
        if(4)
            armor = list(SHARP=11, PIERCE=9, BLUNT=7, FIRE=7, WOUND=25)
        if(5)
            armor = list(SHARP=14, PIERCE=12, BLUNT=9, FIRE=8, WOUND=30)
        if(6)
            armor = list(SHARP=18, PIERCE=14, BLUNT=12, FIRE=9, WOUND=35)

