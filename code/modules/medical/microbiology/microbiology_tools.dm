// A blood slide, used by the centrifuge.
/obj/item/bloodslide
	name = "Blood Slide"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "slide0"
	desc = "An item used by scientists and serial killers operating in the Miami area to store blood samples."

	var/datum/reagent/blood/blood = null

	flags = TABLEPASS | CONDUCT | FPRINT | NOSPLASH | OPENCONTAINER

	New()
		..()
		var/datum/reagents/R = new /datum/reagents(5)
		src.reagents = R

	attackby(obj/item/I, mob/user)
		return

	on_reagent_change()
		..()
		reagents.maximum_volume = reagents.total_volume // This should make the blood slide... permanent.
		if (reagents.has_reagent("blood") || reagents.has_reagent("bloodc"))
			icon_state = "slide1"
			desc = "The blood slide contains a drop of blood."
			if (reagents.has_reagent("blood"))
				blood = reagents.get_reagent("blood")
			else if (reagents.has_reagent("bloodc"))
				blood = reagents.get_reagent("bloodc")
			if (blood == null)
				boutput(usr, "<span class='alert'>Blood slides are not working. This is an error message, please page 1-800-555-MARQUESAS.</span>")
				return
		else
			desc = "This blood slide is contaminated and useless."

/obj/item/reagent_containers/glass/petridish
	name = "Petri Dish"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "petri0"
	desc = "A dish tailored hold pathogen cultures."
	initial_volume = 40
	flags = TABLEPASS | CONDUCT | FPRINT | OPENCONTAINER

	examine()
		. = list("This is [src]<br/>")
		if (src.reagents.reagent_list["pathogen"])
			var/datum/reagent/blood/pathogen/P = src.reagents.reagent_list["pathogen"]
			. += "<span class='notice'>It contains [P.volume] unit\s of harvestable pathogen.</span><br/>"

	afterattack(obj/target, mob/user, flag)
		if (istype(target, /obj/machinery/microscope))
			return
		var/amount = src.reagents.total_volume
		..(target, user, flag)
		if (amount && !src.reagents.total_volume)
			processing_items.Remove(src)
			reagents.clear_reagents()

	proc/update_dish_icon()
		if (src.reagents && src.reagents.total_volume)
			icon_state = "petri1"
		else
			icon_state = "petri0"

/obj/item/reagent_containers/glass/vial
	name = "vial"
	desc = "A vial. Can hold up to 5 units."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "vial0"
	item_state = "vial"
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO

	on_reagent_change()
		..()
		if (reagents.total_volume < 0.05)
			icon_state = "vial0"
		else
			icon_state = "vial1"

	New()
		var/datum/reagents/R = new /datum/reagents(5)
		R.my_atom = src
		src.reagents = R
		..()

/obj/item/reagent_containers/glass/vial/plastic
	name = "plastic vial"
	desc = "A 3D-printed vial. Can hold up to 5 units. Barely."
	can_recycle = FALSE

	New()
		. = ..()
		AddComponent(/datum/component/biodegradable)

/obj/item/reagent_containers/glass/vial/prepared
	name = "Totally Safe(tm) pathogen sample"
	desc = "A vial. Can hold up to 5 units."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "vial0"
	item_state = "vial"

	New()
		..()
		SPAWN(2 SECONDS)
			#ifdef CREATE_PATHOGENS // PATHOLOGY REMOVAL
			add_random_custom_disease(src.reagents, 5)
			#else
			var/datum/reagents/RE = src.reagents
			RE.add_reagent("water", 5)
			#endif

/obj/item/reagent_containers/glass/beaker/egg
	name = "Beaker of Eggs"
	desc = "Eggs; fertile ground for some microbes."

	icon_state = "beaker"

	New()
		..()
		src.reagents.add_reagent("egg", 50)

/obj/item/reagent_containers/glass/beaker/spaceacillin
	name = "Beaker of Spaceacillin"
	desc = "It's penicillin in space."

	icon_state = "beaker"

	New()
		..()
		src.reagents.add_reagent("spaceacillin", 50)

/obj/item/reagent_containers/glass/beaker/stablemut
	name = "Beaker of Stable Mutagen"
	desc = "Stable Mutagen; fertile ground for some microbes."

	icon_state = "beaker"

	New()
		..()
		src.reagents.add_reagent("dna_mutagen", 50)
