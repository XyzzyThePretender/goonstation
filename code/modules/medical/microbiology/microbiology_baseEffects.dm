ABSTRACT_TYPE(/datum/microbioeffects)
/datum/microbioeffects
	var/name = "You shouldn't be seeing this!"
	var/desc = "You shouldn't be seeing this!"
	var/infect_message = null // shown to person when they are infected from a transmission
	var/reactionlist = list()
	var/reactionmessage = MICROBIO_INSPECT_DISLIKES_GENERIC

	///Boolean: FALSE default. On TRUE, the effect must be discovered through analysis before showing up on the designer.
	var/must_unlock = FALSE

	// mob_act(mob, datum/pathogen) : void
	// This is the center of pathogen symptoms.
	// On every Life() tick, this will be called for every symptom attached to the pathogen. Most pathogens should express their malevolence here, unless they are specifically tailored
	// to only work on events like human interaction or external effects. A symptom therefore should override this proc.
	// mob_act is also responsible for handling the symptom's ability to suppress the pathogen. Check the documentation on suppression in pathogen.dm.
	// OVERRIDE: A subclass (direct or otherwise) is expected to override this.
	proc/mob_act(var/mob/M, var/datum/microbeplayerdata/origin)

	// mob_act_dead(mob, datum/pathogen) : void
	// This functions identically to mob_act, except it is only called when the mob is dead. (mob_act is not called if that is the case.)
	// OVERRIDE: Only override this if if it needed for the symptom.
	proc/mob_act_dead(var/mob/M, var/datum/microbeplayerdata/origin)

	// infect_direct(mob, datum/microbeplayerdata) : void
	// This is the proc that handles direct transmission of the pathogen from one mob to another. This should be called in particular infection scenarios. For example, a sweating person
	// gets his bodily fluids onto another when they directly disarm, punch, or grab a person.
	// For INFECT_TOUCH diseases this is automatically called on a successful disarm, punch or grab. When overriding any of these events, use ..() to keep this behaviour.
	// OVERRIDE: Generally, you do not need to override this.
	proc/infect_direct(var/mob/target, var/datum/microbeplayerdata/S, contact_type = MICROBIO_TRANSMISSION_TYPE_AEROBIC)
		if (!(ishuman(S.affected_mob)))	// If in the future we want to generalize the system to include critters, review this
			return
		var/mob/living/carbon/human/H1 = S.affected_mob
		if (contact_type == MICROBIO_TRANSMISSION_TYPE_AEROBIC && H1.wear_mask)
			return	//If the source mob is masked, don't infect!
		if (contact_type == MICROBIO_TRANSMISSION_TYPE_PHYSICAL && H1.gloves)
			return 	//If the source mob is wearing gloves, don't infect!
		if (!(ishuman(target)))
			return	//If the target isn't human, it does not have the code infrastructure to hold an infection.
		var/mob/living/carbon/human/H2 = target
		if (!(prob(100-H2.get_disease_protection())))
			return	// The target succeeded in the protect roll
		if (H2.infected(microbio_controls.pull_from_upstream(S.master.name)))
			if (infect_message)
				target.show_message(infect_message)
			logTheThing("pathology", H1, target, "infects [constructTarget(H2,"pathology")] with [S.master.name] due to effect [name] through direct contact ([contact_type]).")
			return 1

	// creates a non-infective cloud
	// this should give people better feedback about who is infected and how to avoid it
	proc/make_cloud(var/mob/M, var/hex)
		var/turf/T = get_turf(M)
		var/obj/decal/cleanable/pathogen_cloud/D = make_cleanable(/obj/decal/cleanable/pathogen_cloud,T)
		D.color = hex

	// creates a non-infective puddle
	// this should give people better feedback about who is infected and how to avoid it
	proc/make_puddle(var/mob/M, var/hex)
		var/turf/T = get_turf(M)
		var/obj/decal/cleanable/pathogen_sweat/D = make_cleanable(/obj/decal/cleanable/pathogen_sweat,T)
		D.color = hex

	proc/onadd(var/datum/microbe/P)
		return
