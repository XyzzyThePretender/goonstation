// Benevolent effects are mostly modernized from the old _benevolent stuff
// There are 8 beneficial effects, 4 must be unlocked

ABSTRACT_TYPE(/datum/microbioeffects/benevolent)
/datum/microbioeffects/benevolent
	name = "Medical Probiotics"

/datum/microbioeffects/benevolent/mending
	name = "Wound Mending"
	desc = "Slow paced brute damage healing."
	reactionlist = MB_BRUTE_MEDS_CATAGORY
	reactionmessage = MICROBIO_INSPECT_LIKES_GENERIC

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability))
			M.HealDamage("All", P.probability, 0)

/datum/microbioeffects/benevolent/healing
	name = "Burn Healing"
	desc = "Slow paced burn damage healing."
	reactionlist = MB_HOT_REAGENTS
	reactionmessage = "The microbes repel the scalding hot chemical and quickly repair any damage caused by it to organic tissue."

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability))
			M.HealDamage("All", 0, P.probability)

/datum/microbioeffects/benevolent/fleshrestructuring
	name = "Flesh Restructuring"
	desc = "Fast paced general healing."
	reactionlist = MB_ACID_REAGENTS
	reactionmessage = "The microbes become agitated and work to repair the damage caused by the acid."
	must_discover = TRUE

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE))
			M.HealDamage("All", P.probability, P.probability)
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
	must_discover = TRUE

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability) && M.get_toxin_damage())
			M.take_toxin_damage(-P.probability)
			if (prob(P.probability))
				M.show_message("<span class='notice'>You feel cleansed.</span>")

//Need a sprite change (status effect icon)
/datum/microbioeffects/benevolent/haste
	name = "Haste"
	desc = "The microbes improve respiratory efficiency, allowing the host to move slightly faster."
	reactionlist = MB_METABOLISM_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT
	must_discover = TRUE

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		var/mob/living/carbon/C = M
		if (!C.hasStatus("hastened"))
			C.setStatus("hastened", duration = (P.duration - 1 SECONDS))

/datum/microbioeffects/benevolent/neuronrestoration
	name = "Neuron Restoration"
	desc = "Infection slowly repairs nerve cells in the brain."
	reactionlist = MB_BRAINDAMAGE_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_GENERIC

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE))
			M.take_brain_damage(-P.probability)

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
	must_discover = TRUE
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
					origin.iscured = TRUE 	// the microbe sacrifices itself to try to buy you a little more time
