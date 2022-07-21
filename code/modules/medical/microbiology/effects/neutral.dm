// Neutral effects are not designed to cause harm.
// Neutral effects use the emote system to inform infected players
// There are 6 neutral effects.

ABSTRACT_TYPE(/datum/microbioeffects/neutral)
/datum/microbioeffects/neutral
	name = "Neutral Effects"

/datum/microbioeffects/neutral/farts
	name = "Farts"
	desc = "The infected individual occasionally farts."
	associated_reagent = "anti_fart"

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("fart")
			make_cloud(M, origin.master.hexcolors)

/datum/microbioeffects/neutral/fluent
	name = "Fluent"
	desc = "The microbes cause the host to overproduce saliva and tears."
	associated_reagent = "water"

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("cry", "drool", "gurgle"))
			make_puddle(M, origin.master.hexcolors)
			boutput(M, "<span class='alert'>Eugh, you feel kinda gross...</span>")

// Neurotransmitters

// Just focused on the muscular function - ACh does a LOT of other things too
/datum/microbioeffects/neutral/acetylcholine
	name = "Acetylcholine Production"
	desc = "The microbes produce acetylcholine, stimulating the host's muscular system."
	associated_reagent = "atropine"	//antagonist (not game antags, technical nomenclature!) is atropine

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("flex", "flexmuscles", "crackknuckles", "blink_r"))
			boutput(M, "<span class='notice'>[pick("You feel energetic.", "Some exercise would be nice.", "You're pumped up!")]</span>")

/datum/microbioeffects/neutral/norepinephrine
	name = "Norepinephrine Production"
	desc = "The microbes produce norepinephrine, stimulating the host's fight-flight response."
	associated_reagent = "haloperidol" //antagonists include antipsychotics

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("twitch", "twitch_v", "flinch"))
			boutput(M, "<span class='alert'>You feel [pick("on edge", "anxious", "worried")].</span>")

/datum/microbioeffects/neutral/serotonin
	name = "Serotonin Production"
	desc = "The microbes produce serotonin, improving the host's mood."
	associated_reagent = "THC"	// Agonist: activates receptors like the original neurotransmitter

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("grin", "smile", "laugh", "chuckle"))

/datum/microbioeffects/neutral/gaba
	name = "GABA Production"
	desc = "The microbes produce GABA, calming the host."
	associated_reagent = "ethanol"	//Agonist

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("yawn", "stretch"))
