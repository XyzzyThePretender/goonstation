ABSTRACT_TYPE(/datum/suppressant)
/datum/suppressant
	var/name = "CONFUTATIS"
	var/desc = "MALEDICTIS"
	var/color = "transparent"
	/// Which general catagory the cure belongs to.
	var/therapy = "YOU SHOULD NOT BE SEEING THIS"
	/// A concise description of what the cure requires.
	var/exactcure = "YOU SHOULD NOT BE SEEING THIS"
	/// A list of reagent IDs that will trigger the curing condition.
	var/list/cure_synthesis = list()
	/// How many units of reagent(s) must be present to trigger the cure.
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
		src.color = pick(named_colors)

// MEDICATIONS
/datum/suppressant/brutemeds
	name = "Brute Medicine"
	desc = "The microbes are suppressed by brute medicine."
	therapy = "Medications"
	exactcure = "Brute Medications"
	cure_synthesis = list("analgesic", "omnizine", "saline", "styptic_powder", "synthflesh")

/datum/suppressant/burnmeds
	name = "Burn Medicine"
	desc = "The microbes are suppressed by burn medicine."
	therapy = "Medications"
	exactcure = "Burn Medications"
	cure_synthesis = list("menthol", "omnizine", "silver_sulfadiazine", "saline", "synthflesh")

/datum/suppressant/antitox
	name = "Anti-Toxins"
	desc = "The microbes are suppressed by anti-toxins."
	therapy = "Medications"
	exactcure = "Anti-Toxin Medications"
	cure_synthesis = list("anti_rad", "antihol", "charcoal", "cocktail_citrus", "omnizine", "penteticacid")

/datum/suppressant/oxymeds
	name = "Oxygen Medicine"
	desc = "The microbes are suppressed by oxygen medicine."
	therapy = "Medications"
	exactcure = "Oxygen Medications"
	cure_synthesis = list("atropine", "epinephrine", "iron", "omnizine", "perfluorodecalin", "salbutamol")

// DRUGS
/datum/suppressant/sedatives
	name = "Sedatives"
	desc = "The microbes are suppressed by disrupting muscle function."
	therapy = "Drugs"
	exactcure = "Sedatives"
	cure_synthesis = list("cold_medicine", "ethanol", "ether", "haloperidol", "ketamine", "krokodil", \
"lithium", "morphine", "neurodepressant")

/datum/suppressant/stimulants
	name = "Stimulants"
	desc = "The microbes are suppressed by facilitating muscle function."
	therapy = "Drugs"
	exactcure = "Stimulants"
	cure_synthesis = list("coffee", "coffee_fresh", "ephedrine", "epinephrine", "methamphetamine", "nicotine", \
"smelling_salt", "sugar", "synaptizine", "synd_methamphetamine", "triplemeth")

/datum/suppressant/hallucinogens
	name = "Hallucinogenics"
	desc = "The microbes are suppressed by hallucinogens."
	therapy = "Drugs"
	exactcure = "Hallucinogenics"
	cure_synthesis = list("CBD", "cold_medicine", "lysergic acid diethylamide", "psilocybin", "space drugs", "THC")

// THERAPIES
/datum/suppressant/heat
	name = "Heat"
	desc = "The microbes are suppressed by a high body temperature."
	therapy = "Therapy"
	exactcure = "Hyperthermia therapy"
	cure_synthesis = list("coffee", "coffee_fresh", "pyrosium", "nicotine", "sangria")

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
	cure_synthesis = list("cryostylane", "cryoxadone", "krokodil", "mintjulep")

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
	cure_synthesis = list("epinephrine", "menthol", "saline", "synthflesh", "water")

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
