// Malevolent effects are capable of causing harm.
// Transmission-enabling effects are always malevolent.
// There are 8 malevolent effects, of which 4 cause transmission.

ABSTRACT_TYPE(/datum/microbioeffects/malevolent)
/datum/microbioeffects/malevolent
	name = "The Specter of Pathology"
	var/damage_cap = 15	// 45% to crit for 100 damage crit

#ifdef NEGATIVE_EFFECTS
/datum/microbioeffects/malevolent/indigestion
	name = "Indigestion"
	desc = "A bad case of indigestion which occasionally cramps the infected."
	reactionlist = list("cold_medicine", "magnesium", "aluminum", "milk")	//general meds and antacids (milk of magnesia)

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_toxin_damage() <= damage_cap))
			M.take_toxin_damage(2)
			M.show_message("<span class='alert'>Your stomach hurts.</span>")

/datum/microbioeffects/malevolent/muscleache
	name = "Muscle Ache"
	desc = "The infected feels a slight, constant aching of muscles."
	reactionlist = list("water", "haloperidol", "menthol", "morphine", "salicylic_acid")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_brute_damage() <= damage_cap))
			M.show_message("<span class='alert'>Your muscles ache.</span>")
			M.TakeDamage("All", 2, 0)

/datum/microbioeffects/malevolent/fever
	name = "Fever"
	desc = "The body temperature of the infected individual increases."
	reactionlist = MB_COLD_REAGENTS

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_burn_damage() <= damage_cap))
			M.bodytemperature += 4
			M.TakeDamage("chest", 0, origin.probability)
			M.show_message("<span class='alert'>You feel hot.</span>")

/datum/microbioeffects/malevolent/chills
	name = "Chills"
	desc = "The body temperature of the infected individual decreases."
	reactionlist = MB_HOT_REAGENTS

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && (M.get_burn_damage() <= damage_cap))
			M.bodytemperature -= 8
			M.show_message("<span class='alert'>You feel cold.</span>")
			M.TakeDamage("chest", 0, origin.probability)
			M.emote("shiver")
		if (M.bodytemperature < 0)
			M.bodytemperature = 0

//
// TRANSMISSION-ENABLING EFFECTS
//

/datum/microbioeffects/malevolent/beesneeze
	name = "Projectile Bee Egg Sneezing"
	desc = "The infected sneezes bee eggs frequently."
	reactionlist = list("sugar")
	reactionmessage = "The microbes appear to convert the sugar into a viscous fluid."

	proc/sneeze(var/mob/M, var/datum/microbeplayerdata/origin)
		if (!M || !origin)
			return

		var/turf/T = get_turf(M)
		var/flyroll = rand(10)
		var/turf/target = locate(M.x,M.y,M.z)
		var/chosen_phrase = pick(
		"<B><span class='alert'>W</span><span class='notice'>H</span>A<span class='alert'>T</span><span class='notice'>.</span></B>",\
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

/datum/microbioeffects/malevolent/congestion
	name = "Congestion"
	desc = "The infected sneezes frequently."
	reactionlist = list("pepper", "histamine", "smelling_salt", "saline")
	reactionmessage = "The microbes violently discharge fluids when contacting with the reagent."

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
	reactionmessage = "The microbes stop producing droplets of liquid."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON))
			make_puddle(M, origin.master.hexcolors)
			M.show_message(pick("<span class='alert'>You feel rather warm.</span>", \
			"<span class='alert'>You're sweating heavily.</span>", \
			"<span class='alert'>You're soaked in your own sweat.</span>"))
			for (var/mob/neighbor in range(1))
				infect_direct(neighbor, origin, MICROBIO_TRANSMISSION_TYPE_PHYSICAL)
#endif
