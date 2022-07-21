ABSTRACT_TYPE(/datum/microbioeffects)
/datum/microbioeffects
	var/name = "You shouldn't be seeing this!"
	var/desc = "You shouldn't be seeing this!"

	/// What reagent (id) is used to make this effect?
	var/associated_reagent = "water"

	/**
	 * This is the center of the custom disease effect.
	 * On every Life() tick, this will be called for every effect attached to the culture.
	 * OVERRIDE: A subclass (direct or otherwise) is expected to override this.
	*/
	proc/mob_act(var/mob/M, var/datum/microbeplayerdata/origin)

	/**
	 * This is the proc that handles direct transmission from one mob to another.
	 * When overriding any of these events, use ..() to keep this behaviour.
	 * OVERRIDE: Generally, you do not need to override this.
	*/
	proc/infect_direct(var/mob/target, var/datum/microbeplayerdata/origin, contact_type = MICROBIO_TRANSMISSION_TYPE_AEROBIC)
		if (!(ishuman(origin.affected_mob)))	// If in the future we want to generalize the system to include critters, review this
			return
		var/mob/living/carbon/human/H1 = origin.affected_mob
		if (contact_type == MICROBIO_TRANSMISSION_TYPE_AEROBIC && H1.wear_mask)
			return	// If the source mob is masked, don't infect!
		if (contact_type == MICROBIO_TRANSMISSION_TYPE_PHYSICAL && H1.gloves)
			return 	// If the source mob is wearing gloves, don't infect!
		if (!(ishuman(target)))
			return	// If the target isn't human, it does not have the code infrastructure to hold an infection.
		var/mob/living/carbon/human/H2 = target
		if (prob(H2.get_disease_protection()))
			return	// The target succeeded in the protect roll
		if (H2.infected(microbio_controls.pull_from_upstream(origin.master.uid)))	//Make sure we are sending the most updated culture.
			if (contact_type == MICROBIO_TRANSMISSION_TYPE_AEROBIC)
				boutput(target, MICROBIO_TRANSMISSION_TYPE_AEROBIC_MSG)
			else if (contact_type == MICROBIO_TRANSMISSION_TYPE_PHYSICAL)
				boutput(target, MICROBIO_TRANSMISSION_TYPE_PHYSICAL_MSG)
			else
				boutput(target, MICROBIO_TRANSMISSION_GENERIC_MSG)
			logTheThing("pathology", H1, target, "infects [constructTarget(H2, "pathology")] with [origin.master.name] (uid: [origin.master.uid]) through direct contact ([contact_type]).")
			return 1

	// this should give people better feedback about who is infected and how to avoid it
	/// creates a non-infective cloud
	proc/make_cloud(var/mob/M, var/hex)
		var/turf/T = get_turf(M)
		var/obj/decal/cleanable/pathogen_cloud/D = make_cleanable(/obj/decal/cleanable/pathogen_cloud, T)
		D.color = hex

	// this should give people better feedback about who is infected and how to avoid it
	/// creates a non-infective puddle
	proc/make_puddle(var/mob/M, var/hex)
		var/turf/T = get_turf(M)
		var/obj/decal/cleanable/pathogen_sweat/D = make_cleanable(/obj/decal/cleanable/pathogen_sweat, T)
		D.color = hex