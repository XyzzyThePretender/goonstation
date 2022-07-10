// Malevolent effects are capable of causing harm.
// Transmission-enabling effects are always malevolent.
// There are 8 malevolent effects, of which 4 cause transmission

ABSTRACT_TYPE(/datum/microbioeffects/malevolent)
/datum/microbioeffects/malevolent
	name = "The Specter of Pathology"

/datum/microbioeffects/malevolent/indigestion
	name = "Indigestion"
	desc = "A bad case of indigestion which occasionally cramps the infected."
	//review
	reactionlist = list("cold_medicine", "magnesium", "aluminum")	//general meds and antacids (milk of magnesia)

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_toxin_damage() <= 25))
			M.take_toxin_damage(1)
			M.show_message("<span class='alert'>Your stomach hurts.</span>")

/datum/microbioeffects/malevolent/muscleache
	name = "Muscle Ache"
	desc = "The infected feels a slight, constant aching of muscles."
	//review
	reactionlist = list("water", "haloperidol", "morphine")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_brute_damage() <= 25))
			M.show_message("<span class='alert'>Your muscles ache.</span>")
			M.TakeDamage("All", 1, 0)

/datum/microbioeffects/malevolent/fever
	name = "Fever"
	desc = "The body temperature of the infected individual slightly increases."
	//review
	reactionlist = MB_COLD_REAGENTS

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_burn_damage() <= 25))
			M.bodytemperature += 4
			M.TakeDamage("chest", 0, 1)
			M.show_message("<span class='alert'>You feel hot.</span>")

/datum/microbioeffects/malevolent/chills
	name = "Common Chills"
	desc = "The infected feels the sensation of lowered body temperature."
	reactionlist = MB_HOT_REAGENTS

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_burn_damage() <= 25))
			M.bodytemperature -= 8
			M.show_message("<span class='alert'>You feel cold.</span>")
			M.emote("shiver")
		if (M.bodytemperature < 0)
			M.bodytemperature = 0

//
// TRANSMISSION-ENABLING EFFECTS
//

/datum/microbioeffects/malevolent/beesneeze
	name = "Projectile Bee Egg Sneezing"
	desc = "The infected sneezes bee eggs frequently."
	//review
	reactionlist = list("sugar")	//This effect is very obvious.
	reactionmessage = "The microbes appear to convert the sugar into a viscous fluid."

	proc/sneeze(var/mob/M, var/datum/microbeplayerdata/origin)

		if (!M || !origin)
			return

		var/turf/T = get_turf(M)
		var/flyroll = rand(10)
		var/turf/target = locate(M.x,M.y,M.z)
		var/chosen_phrase = pick("<B><span class='alert'>W</span><span class='notice'>H</span>A<span class='alert'>T</span><span class='notice'>.</span></B>",\
		"<span class='alert'><B>What the [pick("hell","fuck","christ","shit")]?!</B></span>",\
		"<span class='alert'><B>Uhhhh. Uhhhhhhhhhhhhhhhhhhhh.</B></span>",\
		"<span class='alert'><B>Oh [pick("no","dear","god","dear god","sweet merciful [pick("neptune","poseidon")]")]!</B></span>")

		switch (M.dir)
			if (NORTH)
				target = locate(M.x, M.y+flyroll, M.z)
			if (SOUTH)
				target = locate(M.x, M.y-flyroll, M.z)
			if (EAST)
				target = locate(M.x+flyroll, M.y, M.z)
			if (WEST)
				target = locate(M.x-flyroll, M.y, M.z)

		var/obj/item/reagent_containers/food/snacks/ingredient/egg/bee/toThrow = new /obj/item/reagent_containers/food/snacks/ingredient/egg/bee(T)

		M.visible_message("<span class='alert'>[M] sneezes out a space bee egg!</span> [chosen_phrase]", \
		"<span class='alert'>You sneeze out a bee egg!</span> [chosen_phrase]", \
		"<span class='alert'>You hear someone sneezing.</span>")

		toThrow.throw_at(target, 6, 1)

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_HORRIFYING))	// Divide by 10, less bee spam!
			sneeze(M, origin)
			make_cloud(M, origin.master.hexcolors)
			for (var/mob/neighbor in range(1))
				infect_direct(neighbor, origin, MICROBIO_TRANSMISSION_TYPE_AEROBIC)

/datum/microbioeffects/malevolent/sneezing
	name = "Sneezing"
	desc = "The infected sneezes frequently."
	//definitely revisit
	reactionlist = list("pepper", "antihistamine", "smelling_salt")
	reactionmessage = "The microbes violently discharge fluids when coming in contact with the reagent."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON))

			M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze.</span>", \
			"<span class='alert'>You hear someone sneezing.</span>")

			make_cloud(M, origin.master.hexcolors)
			for (var/mob/neighbor in range(1))
				infect_direct(neighbor, origin, MICROBIO_TRANSMISSION_TYPE_AEROBIC)

/datum/microbioeffects/malevolent/coughing
	name = "Coughing"
	desc = "Violent coughing occasionally plagues the infected."
	reactionlist = list("cold_medicine", "spaceacillin")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON))
			M.show_message("<span class='alert'>You cough.</span>")
			make_cloud(M, origin.master.hexcolors)
			for (var/mob/neighbor in range(1))
				infect_direct(neighbor, origin, MICROBIO_TRANSMISSION_TYPE_AEROBIC)

/datum/microbioeffects/malevolent/sweating
	name = "Sweating"
	desc = "The infected person sweats like a pig."
	reactionlist = MB_COLD_REAGENTS
	reactionmessage = MICROBIO_INSPECT_DISLIKES_GENERIC

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON))
			make_puddle(M, origin.master.hexcolors)
			M.show_message(pick(MICROBIO_SWEATING_EFFECT_MESSAGES))
			for (var/mob/neighbor in range(1))
				infect_direct(neighbor, origin, MICROBIO_TRANSMISSION_TYPE_PHYSICAL)
