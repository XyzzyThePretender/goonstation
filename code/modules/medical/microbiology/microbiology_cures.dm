ABSTRACT_TYPE(/datum/suppressant)
/datum/suppressant
	var/name = "Suppressant"
	var/color = "transparent"
	var/desc = "The pathogen is not suppressed by any external effects."
	var/therapy = "unknown"
	var/exactcure = "unknown"
	// A list of reagent IDs which can be designated as the cure.
	var/list/cure_synthesis = list()
	var/reactionlist = list()
	var/reactionmessage = MICROBIO_INSPECT_HIT_CURE

	proc/suppress_act(var/datum/microbeplayerdata/P)
		for (var/R in cure_synthesis)
			if (!(P.affected_mob.reagents.has_reagent(R, REAGENT_CURE_THRESHOLD)))
				continue
			if (!(P.iscured))
				P.affected_mob.show_message("<span class='notice'>You feel better.</span>")
				return TRUE
		return FALSE

	New()
		..()
		color = pick(named_colors)

/datum/suppressant/heat
	name = "Heat"
	desc = "The pathogen is suppressed by a high body temperature."
	therapy = "Therapy"
	exactcure = "Controlled hyperthermia therapy"
	cure_synthesis = MB_HOT_REAGENTS
	reactionlist = MB_COLD_REAGENTS

	suppress_act(var/datum/microbeplayerdata/P)
		if (!(P.affected_mob.bodytemperature > 320 + P.duration))	//Base temp is 273 + 37 = 310. Add 10 to avoid natural variance.
			return FALSE
		else if (!(P.iscured))
			P.affected_mob.show_message("<span class='notice'>You feel better.</span>")
			return TRUE
		..()

/datum/suppressant/cold
	name = "Cold"
	desc = "The pathogen is suppressed by a low body temperature."
	therapy = "Therapy"
	exactcure = "Cryogenic therapy"
	cure_synthesis = MB_COLD_REAGENTS
	reactionlist = MB_HOT_REAGENTS

	suppress_act(var/datum/microbeplayerdata/P)
		if (!(P.affected_mob.bodytemperature < 300 - P.duration)) // Same idea as for heat, but inverse.
			return FALSE
		else if (!(P.iscured))
			P.affected_mob.show_message("<span class='notice'>You feel better.</span>")
			return TRUE
		..()

/datum/suppressant/brutemeds
	name = "Brute Medicine"
	desc = "The pathogen is suppressed by brute medicine."
	therapy = "Medications"
	exactcure = "Brute Medications"
	cure_synthesis = MB_BRUTE_MEDS_CATAGORY
	reactionlist = MB_BRUTE_MEDS_CATAGORY

/datum/suppressant/burnmeds
	name = "Burn Medicine"
	desc = "The pathogen is suppressed by burn medicine."
	therapy = "Medications"
	exactcure = "Burn Medications"
	cure_synthesis = MB_BURN_MEDS_CATAGORY
	reactionlist = MB_BURN_MEDS_CATAGORY

/datum/suppressant/antitox
	name = "Anti-Toxins"
	desc = "The pathogen is suppressed by anti-toxins."
	therapy = "Medications"
	exactcure = "Anti-Toxin Medications"
	cure_synthesis = MB_TOX_MEDS_CATAGORY
	reactionlist = MB_TOX_MEDS_CATAGORY

/datum/suppressant/oxymeds
	name = "Oxygen Medicine"
	desc = "The pathogen is suppressed by oxygen medicine."
	therapy = "Medications"
	exactcure = "Oxygen Medications"
	cure_synthesis = MB_OXY_MEDS_CATAGORY
	reactionlist = MB_OXY_MEDS_CATAGORY

/datum/suppressant/sedatives
	name = "Sedative"
	desc = "The pathogen is suppressed by disrupting muscle function."
	therapy = "Drugs"
	exactcure = "Sedatives"
	cure_synthesis = MB_SEDATIVES_CATAGORY
	reactionlist = MB_SEDATIVES_CATAGORY

/datum/suppressant/stimulants
	name = "Stimulants"
	desc = "The pathogen is suppressed by facilitating muscle function."
	therapy = "Drugs"
	exactcure = "Stimulants"
	cure_synthesis = MB_STIMULANTS_CATAGORY
	reactionlist = MB_STIMULANTS_CATAGORY

/datum/suppressant/spaceacillin
	name = "Spaceacillin"
	desc = "The culture is suppressed by spaceacillin."
	therapy = "Drugs"
	exactcure = "Spaceacillin"
	cure_synthesis = list("spaceacillin")
	reactionlist = list("spaceacillin")
