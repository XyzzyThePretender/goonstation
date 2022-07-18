// Benevolent effects are mostly modernized from the old _benevolent stuff
// There are 7 beneficial effects.

ABSTRACT_TYPE(/datum/microbioeffects/benevolent)
/datum/microbioeffects/benevolent
	name = "Medical Probiotics"

/datum/microbioeffects/benevolent/fleshrestructuring
	name = "Flesh Restructuring"
	desc = "Fast paced general healing."
	reactionlist = MB_ACID_REAGENTS
	reactionmessage = "The microbes become agitated and work to repair the damage caused by the acid."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE))
			M.HealDamage("All", origin.probability, origin.probability)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.bleeding)
				repair_bleeding_damage(M, 80, 2)
				if (prob(20))
					M.show_message("<span class='notice'>You feel your wounds closing by themselves.</span>")

	//podrickequus's first code, yay

/datum/microbioeffects/benevolent/cleansing
	name = "Cleansing"
	desc = "The microbes clean the body of damage caused by toxins."
	reactionlist = MB_TOXINS_REAGENTS
	reactionmessage = "The microbes appear to have entirely metabolized... all chemical agents in the dish."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability) && M.get_toxin_damage())
			M.take_toxin_damage(-origin.probability)
			if (prob(origin.probability))
				M.show_message("<span class='notice'>You feel cleansed.</span>")

//Need a sprite change (status effect icon)
/datum/microbioeffects/benevolent/haste
	name = "Haste"
	desc = "The microbes improve respiratory efficiency, allowing the host to move slightly faster."
	reactionlist = MB_METABOLISM_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		var/mob/living/carbon/C = M
		if (!C.hasStatus("hastened"))
			C.setStatus("hastened", duration = (origin.duration - 1 SECONDS))

/datum/microbioeffects/benevolent/metabolisis
	name = "Accelerated Metabolisis"
	desc = "The microbes accelerate the metabolisis of all chemicals present in the host body."
	reactionlist = MB_METABOLISM_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_GENERIC

	// Doubling rates of metabolism.
	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		var/met = FALSE
		for (var/rid in M.reagents.reagent_list)
			var/datum/reagent/R = M.reagents.reagent_list[rid]
			met = TRUE
			if (R) //Wire: Fix for Cannot execute null.on mob life().
				R.on_mob_life()
			if (!R || R.disposed)
				break
			if (R && !R.disposed)
				M.reagents.remove_reagent(rid, R.depletion_rate)
		if (met)
			M.reagents.update_total()

/datum/microbioeffects/benevolent/critical
	name = "Systemic Symbiosis"
	desc = "The microbes bind to various parts of the host's body and attempt to keep a critically injured host alive."
	reactionlist = MB_STIMULANTS_CATAGORY
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT
	var/last_losebreath = null

	// Want to try to cure the most lethal complication (severity: shock < heart failure < flatline)
	// Will definitely need balancing work.
	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (!M.incrit)
			src.last_losebreath = null
			return
		// set the first point
		if (isnull(src.last_losebreath))
			src.last_losebreath = M.losebreath
			return
		var/mob/living/living = M
		// attenuate sharp rates of losebreath
		var/current = M.losebreath
		if ((current > src.last_losebreath) && ((current - src.last_losebreath) > 5))
			living.lose_breath(-0.5*(current - src.last_losebreath))

		switch (M.health)
			if (-50 to 0)	//shock
				if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON) && living.find_ailment_by_type(/datum/ailment/malady/shock))
					// simplify?
					living.cure_disease_by_path(/datum/ailment/malady/shock)
			if (-100 to -51)
				if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON) && living.find_ailment_by_type((/datum/ailment/malady/heartfailure)))
					living.cure_disease_by_path(/datum/ailment/malady/heartfailure)
			if (-INFINITY to -100)
				if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON) && living.find_ailment_by_name(/datum/ailment/malady/flatline))
					living.Virus_ShockCure()
					boutput(M, "<span class='notice'>You feel an electrical impulse across your entire body!</span>")
					origin.iscured = TRUE 	// the microbes sacrifice themselves to try to buy you a little more time

// Organs

/datum/microbioeffects/benevolent/neuronrestoration
	name = "Neuron Restoration"
	desc = "The microbes facilitate neuroplasticity, mitigating substantial brain damage."
	reactionlist = MB_BRAINDAMAGE_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE) && M.get_brain_damage() > 60)	// 60 is a magic number for bdamage code
			M.take_brain_damage(-origin.probability)

// This one doesn't update player hud
/datum/microbioeffects/neutral/sunglass
	name = "Sunglass Glands"
	desc = "The infected grew sunglass glands."
	reactionlist = list("flashpowder", "oculine")
	reactionmessage = "The microbes appear to be wearing sunglasses."

	proc/glasses(var/mob/living/carbon/human/H)
		var/obj/item/clothing/glasses/G = H.glasses
		var/obj/item/clothing/glasses/N = new/obj/item/clothing/glasses/sunglasses()
		H.show_message({"<span class='notice'>[pick("You feel cooler!", "You find yourself wearing sunglasses.", \
		"A pair of sunglasses grow onto your face.")][G?" But you were already wearing glasses!":""]</span>"})
		if (G)
			N.set_loc(H.loc)
			var/turf/T = get_edge_target_turf(H, pick(alldirs))
			N.throw_at(T, rand(0, 5), 1)
		else
			H.force_equip(N, H.slot_glasses)

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (!ishuman(M))
			return
		var/mob/living/carbon/human/H = M
		//case 1: player has no glasses and succeeds roll
		//OR case 2: player has glasses and succeeds halved roll
		if ((!(H.glasses) && prob(origin.probability)) || (!(istype(H.glasses, /obj/item/clothing/glasses/sunglasses)) && prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON)))
			glasses(M)
			M.update_clothing()
