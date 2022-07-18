ABSTRACT_TYPE(/datum/suppressant)
/datum/suppressant
	var/name = "CONFUTATIS"
	var/desc = "MALEDICTIS"
	var/color = "transparent"

	/// Which general catagory the cure belongs to.
	var/therapy = "YOU SHOULD NOT BE SEEING THIS"

	/// A concise description of what the cure requires.
	var/exactcure = "YOU SHOULD NOT BE SEEING THIS"

	/// A list of reagent IDs which can be designated as the cure and will cause a reaction.
	var/list/cure_synthesis = list()

	/// The message sent on using a correct reagent
	var/reactionmessage = "The microbes in the test reagent are rapidly withering away!"

	/// How many units of reagent must be present to trigger the cure
	var/reagent_cure_threshold = 10

	proc/suppress_act(var/datum/microbeplayerdata/origin)
		var/total = 0
		for (var/R in src.cure_synthesis)
			if (!(origin.affected_mob.reagents.has_reagent(R, src.reagent_cure_threshold)))
				continue
			total += origin.affected_mob.reagents.get_reagent_amount(R)
			if (!(origin.iscured) && total >= src.reagent_cure_threshold)
				origin.affected_mob.show_message("<span class='notice'>You think your illness is beginning to recede.</span>")
				return TRUE
		return FALSE

	New()
		..()
		color = pick(named_colors)

// MEDICATIONS

/datum/suppressant/brutemeds
	name = "Brute Medicine"
	desc = "The microbes are suppressed by brute medicine."
	therapy = "Medications"
	exactcure = "Brute Medications"
	cure_synthesis = MB_BRUTE_MEDS_CATAGORY

/datum/suppressant/burnmeds
	name = "Burn Medicine"
	desc = "The microbes are suppressed by burn medicine."
	therapy = "Medications"
	exactcure = "Burn Medications"
	cure_synthesis = MB_BURN_MEDS_CATAGORY

/datum/suppressant/antitox
	name = "Anti-Toxins"
	desc = "The microbes are suppressed by anti-toxins."
	therapy = "Medications"
	exactcure = "Anti-Toxin Medications"
	cure_synthesis = MB_TOX_MEDS_CATAGORY

/datum/suppressant/oxymeds
	name = "Oxygen Medicine"
	desc = "The microbes are suppressed by oxygen medicine."
	therapy = "Medications"
	exactcure = "Oxygen Medications"
	cure_synthesis = MB_OXY_MEDS_CATAGORY

// DRUGS

/datum/suppressant/sedatives
	name = "Sedatives"
	desc = "The microbes are suppressed by disrupting muscle function."
	therapy = "Drugs"
	exactcure = "Sedatives"
	cure_synthesis = MB_SEDATIVES_CATAGORY

/datum/suppressant/stimulants
	name = "Stimulants"
	desc = "The microbes are suppressed by facilitating muscle function."
	therapy = "Drugs"
	exactcure = "Stimulants"
	cure_synthesis = MB_STIMULANTS_CATAGORY

/datum/suppressant/hallucinogens
	name = "Hallucinogenics"
	desc = "The microbes are suppressed by hallucinogens."
	therapy = "Drugs"
	exactcure = "Hallucinogenics"
	cure_synthesis = MB_HALLUCINOGENICS_CATAGORY

// THERAPIES

/datum/suppressant/heat
	name = "Heat"
	desc = "The microbes are suppressed by a high body temperature."
	therapy = "Therapy"
	exactcure = "Hyperthermia therapy"
	cure_synthesis = MB_HOT_REAGENTS

	suppress_act(var/datum/microbeplayerdata/origin)
		if (origin.affected_mob.bodytemperature < (320 + origin.duration * 0.01))	//Base temp is 273 + 37 = 310. Add 10 to avoid natural variance.
			return FALSE
		else if (!(origin.iscured) || (origin.affected_mob.bioHolder && origin.affected_mob.bioHolder.HasEffect("fire_resist")))
			origin.affected_mob.show_message("<span class='notice'>You feel better.</span>")
			return TRUE
		..()

/datum/suppressant/cold
	name = "Cold"
	desc = "The microbes are suppressed by a low body temperature."
	therapy = "Therapy"
	exactcure = "Cryogenic therapy"
	cure_synthesis = MB_COLD_REAGENTS

	suppress_act(var/datum/microbeplayerdata/origin)
		if (!(origin.affected_mob.bodytemperature < (300 - origin.duration * 0.01))) // Same idea as for heat, but inverse.
			return FALSE
		else if (!(origin.iscured) || (origin.affected_mob.bioHolder && origin.affected_mob.bioHolder.HasEffect("cold_resist")))
			origin.affected_mob.show_message("<span class='notice'>You feel better.</span>")
			return TRUE
		..()

/datum/suppressant/exercise
	name = "Exercise"
	desc = "The microbes are suppressed by intense exercise."
	therapy = "Therapy"
	exactcure = "Exercise"
	cure_synthesis = MB_EXERCISE_REAGENTS

	// include athletic trait?
	// same pitfall of 'blow up place to deny cure'
	// needs to expand fitness (dumbbells, workout mats, exercise equip. from cargo, etc.)
	suppress_act(var/datum/microbeplayerdata/origin)
		if (!(origin.affected_mob.hasStatus("fitness_stam_regen") || origin.affected_mob.hasStatus("fitness_stam_max")))
			return FALSE
		else if (!(origin.iscured) || (origin.affected_mob.bioHolder && origin.affected_mob.bioHolder.HasEffect("fitness_buff")))
			origin.affected_mob.show_message("<span class='notice'>You feel better.</span>")
			return TRUE
		..()


// Potential ideas

//datum/suppressant/radiotherapy
	//Awaiting new radiation system

//datum/suppressant/environmental
	//Be somewhere for a period of time
	//Chapel?
	//Courtroom?
	//Owlery?
	//Observatory?
	//Public Garden?
	//Public places

//datum/suppressant/shrink
	//Implying permanent psychologist/therapist job
	//Absolutely no idea what this may entail
	//Keywords?
	//Being in a therapy office?
	//Proximity to a therapist?
	//Duration?
