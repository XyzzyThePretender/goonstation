// Benevolent effects are mostly modernized from the old _benevolent stuff
// There are 9 beneficial effects, but 2 are possibly untenable (oxy storage, oxy gen)

ABSTRACT_TYPE(/datum/microbioeffects/benevolent)
/datum/microbioeffects/benevolent
	name = "Medical Probiotics"

/datum/microbioeffects/benevolent/mending
	name = "Wound Mending"
	desc = "Slow paced brute damage healing."
	reactionlist = list("synthflesh")
	reactionmessage = "Microscopic damage on the synthetic flesh appears to be mended by the microbes."

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability))
			M.HealDamage("All", 2, 0)

/datum/microbioeffects/benevolent/healing
	name = "Burn Healing"
	desc = "Slow paced burn damage healing."
	reactionlist = MB_HOT_REAGENTS
	reactionmessage = "The microbes repel the scalding hot chemical and quickly repair any damage caused by it to organic tissue."

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability))
			M.HealDamage("All", 0, 2)

/datum/microbioeffects/benevolent/fleshrestructuring
	name = "Flesh Restructuring"
	desc = "Fast paced general healing."
	reactionlist = MB_ACID_REAGENTS
	reactionmessage = "The microbes become agitated and work to repair the damage caused by the acid."
	must_unlock = TRUE

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE))
			M.HealDamage("All", 2, 2)
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

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability) && M.get_toxin_damage())
			M.take_toxin_damage(-1)
			if (prob(P.probability))
				M.show_message("<span class='notice'>You feel cleansed.</span>")

/*
//Both of the commented effects are likely to be deleted.
//Genetics has anaerobic resp, which renders these obsolete
//Hesitant to delete the spritework. Maybe something can be salvaged from it?
//Associated code found in movement_modifiers.dm, statusEffects.dm, statussystem.dmi

//PROBLEM: This effect can kill someone.
//Solution: set a limit on brute for functioning (too much brute -> effect stops working)
/datum/microbioeffects/benevolent/oxygenconversion
	name = "Oxygen Conversion"
	desc = "The microbes convert organic tissue into oxygen when required by the host."
	reactionlist = list("synthflesh")
	reactionmessage = "The microbes consume the synthflesh, converting it into oxygen."

	onadd(var/datum/microbe/origin)
		origin.effectdata += "Oxy Conversion"

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		var/mob/living/carbon/C = M
		if (C.get_oxygen_deprivation())
			C.setStatus("patho_oxy_speed_bad", duration = INFINITE_STATUS, optional = 10)	//optional is "efficiency" in statusEffects

//Both of these may need a sprite brushup (status effect icon)
/datum/microbioeffects/benevolent/oxygenstorage
	name = "Oxygen Storage"
	desc = "The microbes store oxygen and releases it when needed by the host."
	reactionlist = MB_OXY_MEDS_CATAGORY
	reactionmessage = "The microbes appear to generate bubbles of oxygen around the reagent."

	onadd(var/datum/microbe/origin)
		origin.effectdata += "Oxy Storage"

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if(!P.master.effectdata["oxygen_storage"]) // if not yet set, initialize
			P.master.effectdata["oxygen_storage"] = 0

		var/mob/living/carbon/C = M
		if (C.get_oxygen_deprivation())
			if(P.master.effectdata["oxygen_storage"] > 10)
				C.setStatus("patho_oxy_speed", duration = INFINITE_STATUS, optional = P.master.effectdata["oxygen_storage"])
				P.master.effectdata["oxygen_storage"] = 0
		else
			// faster reserve replenishment at higher stages
			P.master.effectdata["oxygen_storage"] = min(100, P.master.effectdata["oxygen_storage"] + 2)
*/

/datum/microbioeffects/benevolent/neuronrestoration
	name = "Neuron Restoration"
	desc = "Infection slowly repairs nerve cells in the brain."
	reactionlist = MB_BRAINDAMAGE_REAGENTS
	reactionmessage = "The microbes release a chemical in an attempt to counteract the effects of the test reagent."

	mob_act(var/mob/M, var/datum/microbeplayerdata/P)
		if (prob(P.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE))
			M.take_brain_damage(-1)

/datum/microbioeffects/benevolent/metabolisis
	name = "Accelerated Metabolisis"
	desc = "The pathogen accelerates the metabolisis of all chemicals present in the host body."
	reactionlist = MB_METABOLISM_REAGENTS
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT

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
