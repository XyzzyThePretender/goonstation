/obj/item/reagent_containers/bloodslide
	name = "blood slide"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "slide0"
	desc = "An item used by scientists and serial killers operating in the Miami area to store blood samples."
	flags = NOSPLASH
	//rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	initial_volume = 5

	// giving it reagent_container will cause a bunch of funky interactions.
	// find and fix
	on_reagent_change()
		..()
		src.reagents.maximum_volume = src.reagents.total_volume
		//Technically there should be a separate cover slip item, but that seems too un-gamey.
		if (OPENCONTAINER in src.flags)
			boutput(usr, "<span class='notice'>You seal the sample in the [src].</span>")
			src.flags -= OPENCONTAINER	// This should make the blood slide... permanent.
		src.desc = "The blood slide contains [src.reagents.get_master_reagent_name()]."
		src.UpdateIcon()

	// This will need spritework
	// Could this be changed to account for non-blood samples
	update_icon()
		if (src.reagents.total_volume)
			src.icon_state = "slide1"

/obj/item/reagent_containers/glass/petridish
	name = "petri dish"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "petri0"
	desc = "A dish tailored hold microbial cultures."
	flags = NOSPLASH
	//rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	initial_volume = 40

	afterattack(obj/target, mob/user, flag)
		if (istype(target, /obj/machinery/microscope))
			return

	update_icon()
		if (src.reagents.total_volume)
			icon_state = "petri1"
		else
			icon_state = "petri0"

/obj/item/reagent_containers/glass/vial
	name = "vial"
	desc = "A vial. Can hold up to 5 units."
	// Recheck the vial sprites
	icon = 'icons/obj/pathology.dmi'
	icon_state = "vial0"
	item_state = "vial"
	initial_volume = 5
	//rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO

	update_icon()
		if (!src.reagents.total_volume)
			icon_state = "vial0"
		else
			icon_state = "vial1"

/obj/item/reagent_containers/glass/vial/plastic
	name = "plastic vial"
	desc = "A 3D-printed vial. Can hold up to 5 units. Barely."
	can_recycle = FALSE

	New()
		. = ..()
		AddComponent(/datum/component/biodegradable)

/obj/item/reagent_containers/glass/vial/prepared
	name = "Totally Safe(tm) <s>pathogen</s> sample"
	desc = "A vial. Can hold up to 5 units."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "vial0"
	item_state = "vial"

	New()
		..()
		SPAWN(2 SECONDS)
			#ifdef CREATE_PATHOGENS // PATHOLOGY REMOVAL
			add_random_custom_disease(src.reagents, src.initial_volume)
			#else
			var/datum/reagents/RE = src.reagents
			RE.add_reagent("water", src.initial_volume)
			#endif

// First ask if a box would be OK instead of a special rack
// Get some help for this if so
/*
/obj/item/testtuberack
	name = "test tube rack"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "rubber_chicken"	//gotta have it.
	var/list/obj/item/reagent_containers/glass/vial/vials[6]
	var/count = 0

	examine()
		. = ..()
		if (src.vials.len)
			. += "There are [src.count ? src.count : "no"] vials in the rack."

	attackby(obj/item/W, mob/user)
		if (!istype(W, /obj/item/reagent_containers/glass/vial))
			boutput(user, "<span class='alert'>The [W] won't fit into the [src.name]!</span>")
			return
		if (src.contents.len >= 6)
			boutput(user, "<span class='notice'>The test tube rack is full!</span>")
			return
		if(istype(W, /obj/item/reagent_containers/glass/vial))
			boutput(user, "<span class='notice'>You insert the [W] into the test tube rack.</span>")
			user.u_equip(W)
			for (var/i in 1 to 6)
				if (vials[i])
					continue
				src.vials[i] = W
				src.count++

	attack_hand(mob/user)
		var/obj/item/the_rack_jonson = locate(/obj/item/testtuberack) in src
		if (the_rack_jonson)
			user.put_in_hand_or_drop(the_rack_jonson)
		else if(!src.count)
			boutput(user, "<span class='notice'>There are no test tubes in the rack.</span>")
			return
		var/obj/item/reagent_containers/glass/vial/V = vials[count + 1]
		src.vials[count + 1] = null
		src.count--
		boutput(user, "<span class='notice'>You slide the [V] carefully out of the rack.</span>")
*/

//Ok marq.
//Moved here from an unincluded file, vials.dm. Probably to be deleted.
//If there is anything worth salvaging from the below code, it would likely go in this file.

//NOTE:
//This file contains the worst code ive ever written.
//I dont fucking care. It looks pretty awesome.
/*
//////////////////////////////////////////////////////////
/obj/dummy/liquid
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	invisibility = INVIS_ALWAYS
	var/canmove = 1
	density = 0
	anchored = 1
//
/*
/obj/item/reagent_containers/glass/vial

	name = "glass test tube"
	icon = 'icons/obj/chemical.dmi'
	desc = "an incredibly fragile glass test tube"
	icon_state = "vial0"
	item_state = "vial"
	throwforce = 3.0
	throw_speed = 1
	throw_range = 8
	force = 3.0
	w_class = W_CLASS_TINY
	initial_volume = 30

	amount_per_transfer_from_this = 5
	flags = FPRINT | TABLEPASS | OPENCONTAINER

	var/contained = null

/obj/item/reagent_containers/glass/vial/green
	name = "glass test tube"
	icon = 'icons/obj/chemical.dmi'
	desc = "a glass vial filled with a strange green liquid"
	icon_state = "vialgreen"
	item_state = "vialgreen"
	contained = /datum/ailment/disease/gbs


/obj/item/reagent_containers/glass/blue
	name = "glass test tube"
	icon = 'icons/obj/chemical.dmi'
	desc = "a glass vial filled with a shimmering blue liquid"
	icon_state = "vialblue"
	item_state = "vialblue"
//This isn't a disease! I should make it one
//	contained = new
//////////////////////////////////////////////////////////
*/
///////////////////////////////////////////////////////***
/obj/item/reagent_containers/glass/vial/throw_impact(atom/hit_atom, datum/thrown_thing/thr)
	..(hit_atom)
	src.shatter()

////////////////////////////////////////////////////////////////Generic Vial Shatter

/obj/item/reagent_containers/glass/vial/proc/shatter()
	var/A = src

	var/atom/sourceloc = get_turf(src.loc)
	qdel(A)
	var/obj/overlay/O = new /obj/overlay( sourceloc )
	var/obj/overlay/O2 = new /obj/overlay( sourceloc )
	O.name = "green liquid"
	O.set_density(0)
	O.anchored = 1
	O.icon = 'icons/effects/effects.dmi'
	O.icon_state = "greenshatter"
	O2.name = "broken bits of glass"
	O2.set_density(0)
	O2.anchored = 1
	O2.icon = 'icons/obj/objects.dmi'
	O2.icon_state = "shards"

	if(istype(src.contained,/datum/ailment/))
		for(var/mob/living/carbon/H in view(5, sourceloc))
			H.contract_disease(src.contained,null,null,0)
		var/i
		for(i=0, i<5, i++)
			for(var/mob/living/carbon/H in view(5, sourceloc))
				H.contract_disease(src.contained,null,null,0)
			sleep(2 SECONDS)

	flick("greenshatter2",O)
	O.icon_state = "nothing"
	sleep(0.5 SECONDS)
	qdel(O)
	return
/*
//Generic Vial Drink
/obj/item/reagent_containers/glass/vial/proc/drink(user)
	var/A = src
	qdel(A)
	if(istype(src.contained,/datum/ailment/))
		var/mob/living/M = user
		switch(pick(1,2))
			if(1)
				M.weakened += 5
				M.contract_disease(src.contained,null,null,1)
			if(2)
				SPAWN(20 SECONDS)
					M.contract_disease(src.contained,null,null,1)
	return

/obj/item/reagent_containers/glass/vial/blue/drink(user)
	var/A = src
	var/atom/sourceloc = get_turf(src.loc)
	qdel(A)

	var/obj/overlay/O = new /obj/overlay( sourceloc )
	var/obj/overlay/O2 = new /obj/overlay( sourceloc )

	O.name = "green liquid"
	O.set_density(0)
	O.anchored = 1
	O.icon = 'icons/effects/effects.dmi'
	O.icon_state = "blueshatter"
	O2.name = "broken bits of glass"
	O2.set_density(0)
	O2.anchored = 1
	O2.icon = 'icons/obj/objects.dmi'
	O2.icon_state = "shards"

	liquify(user)

	sleep(2 SECONDS)
	flick("blueshatter2",O)
	O.icon_state = "nothing"
	sleep(0.5 SECONDS)
	qdel(O)

/obj/item/reagent_containers/glass/vial/blue/shatter()

	var/A = src
	var/atom/sourceloc = get_turf(src.loc)
	qdel(A)

	var/obj/overlay/O = new /obj/overlay( sourceloc )
	var/obj/overlay/O2 = new /obj/overlay( sourceloc )

	O.name = "green liquid"
	O.set_density(0)
	O.anchored = 1
	O.icon = 'icons/effects/effects.dmi'
	O.icon_state = "blueshatter"
	O2.name = "broken bits of glass"
	O2.set_density(0)
	O2.anchored = 1
	O2.icon = 'icons/obj/objects.dmi'
	O2.icon_state = "shards"

	for(var/mob/living/carbon/human/H in view(1, sourceloc))
		liquify(H)

	sleep(2 SECONDS)
	flick("blueshatter2",O)
	O.icon_state = "nothing"
	sleep(0.5 SECONDS)

	qdel(O)
*/
/mob/proc/drop_vial()
	var/obj/item/reagent_containers/glass/vial/W = src.equipped()
	if (W)
		u_equip(W)
		if (W)
			W.set_loc(src.loc)
//			W.dropped(src)			Get rid of this as it would smash a vial
			if (W)
				W.layer = initial(W.layer)
		var/turf/T = get_turf(src.loc)
		T.Entered(W)
	return

/proc/liquify(var/mob/H, time = 150)

	if(H.stat) return
	SPAWN(0)
		var/mobloc = get_turf(H.loc)
		var/obj/dummy/liquid/holder = new /obj/dummy/liquid( mobloc )
		var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
		animation.name = "water"
		animation.set_density(0)
		animation.anchored = 1
		animation.icon = 'icons/mob/mob.dmi'
		animation.icon_state = "liquify"
		animation.layer = MOB_EFFECT_LAYER
		animation.master = holder
		flick("liquify",animation)
		H.canmove = 0
		sleep(0.4 SECONDS)
		H.set_loc(holder)
		H.canmove = 1
		SPAWN(0)
			var/i
			for(i=0, i<10, i++)
				SPAWN(0)
					var/obj/effects/water/water1 = new /obj/effects/water( mobloc )
					var/direction = pick(alldirs)
					water1.name = "water"
					water1.set_density(0)
					water1.icon = 'icons/effects/water.dmi'
					water1.icon_state = "extinguish"
					for(i=0, i<pick(1,2,3), i++)
						sleep(0.5 SECONDS)
						step(water1,direction)
					SPAWN(2 SECONDS)
						qdel(water1)

		sleep(time)
		H.canmove = 0
		mobloc = get_turf(H.loc)
		animation.set_loc(mobloc)
		var/b
		for(b=0, b<10, b++)
			SPAWN(0)
				var/turf = mobloc
				var/direction = pick(alldirs)
				var/c
				for(c=0, c<pick(1,2,3), c++)
					turf = get_step(turf,direction)
				var/obj/effects/water/water2 = new /obj/effects/water( turf )
				water2.name = "water"
				water2.icon = 'icons/effects/water.dmi'
				water2.icon_state = "extinguish"
				walk_to(water2,mobloc,-1,5)
				sleep(2 SECONDS)
				qdel(water2)

		sleep(2 SECONDS)
		flick("reappear",animation)
		sleep(0.5 SECONDS)
		H.set_loc(mobloc)
		H.canmove = 1
		qdel(animation)
		qdel(holder)


/obj/dummy/liquid/relaymove(var/mob/user, direction)
	if (!src.canmove) return
	//writing my own movement because step is broken.
	switch(direction)
		if(NORTH)
			src.y++
		if(SOUTH)
			src.y--
		if(EAST)
			src.x++
		if(WEST)
			src.x--
		if(NORTHEAST)
			src.y++
			src.x++
		if(NORTHWEST)
			src.y++
			src.x--
		if(SOUTHEAST)
			src.y--
			src.x++
		if(SOUTHWEST)
			src.y--
			src.x--
	src.canmove = 0
	SPAWN(2 SECONDS) canmove = 1

/obj/dummy/liquid/ex_act(blah)
	return
/obj/dummy/liquid/bullet_act(blah,blah)
	return


///atom/relaymove - change to obj to restore

/obj/relaymove(var/mob/user, direction) //testing something
	//if(anchored) return
	//step(src, direction)


/////////////////////////////////////////////////////blue

*/
