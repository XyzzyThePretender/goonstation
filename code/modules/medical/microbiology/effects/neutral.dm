// Neutral effects are not designed to cause harm.
// Neutral effects use the emote system to inform infected players
// There are 7 neutral effects.

ABSTRACT_TYPE(/datum/microbioeffects/neutral)
/datum/microbioeffects/neutral
	name = "Neutral Effects"
	/// A list of messages a player gets in conjunction with an emote/visual proc
	var/personal_messages = ""

/datum/microbioeffects/neutral/farts
	name = "Farts"
	desc = "The infected individual occasionally farts."
	associated_reagent = "anti_fart"

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("fart")
			make_cloud(M, origin.master.hexcolors)

/datum/microbioeffects/neutral/hoarseness
	name = "Hoarseness"
	desc = "The microbes cause dry throat, leading to hoarse speech."
	associated_reagent = "salt"
	personal_messages = list("... so dry...", "You REALLY could use a drink.", "You feel parched.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("wheeze", "grumble"))
			boutput(M, "<span class='alert'>[pick(personal_messages)]</span>")

/datum/microbioeffects/neutral/fluent
	name = "Fluent"
	desc = "The microbes cause the host to overproduce saliva and tears."
	associated_reagent = "water"
	personal_messages = list("You feel a little dehydrated...", "Ugh, this is gross.", "You feel icky.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("cry", "drool", "gurgle"))
			make_puddle(M, origin.master.hexcolors)
			boutput(M, "<span class='alert'>[pick(personal_messages)]</span>")

// Neurotransmitters

// Just focused on the muscular function - ACh does a LOT of other things too
/datum/microbioeffects/neutral/acetylcholine
	name = "Acetylcholine Production"
	desc = "The microbes produce acetylcholine, stimulating the host's muscular system."
	associated_reagent = "atropine"	//antagonist (not game antags, technical nomenclature!) is atropine
	personal_messages = list("You feel energetic!", "A workout would be nice...", "You feel the need to exercise.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("flex", "flexmuscles", "crackknuckles", "blink_r"))
			boutput(M, "<span class='notice'>[pick(personal_messages)]</span>")

/datum/microbioeffects/neutral/norepinephrine
	name = "Norepinephrine Production"
	desc = "The microbes produce norepinephrine, stimulating the host's fight-flight response."
	associated_reagent = "haloperidol" //antagonists include antipsychotics
	personal_messages = list("You're on your toes.", "You feel on edge.", "You feel a little anxious.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("twitch", "twitch_v", "flinch"))
			boutput(M, "<span class='notice'>[pick(personal_messages)]</span>")

/datum/microbioeffects/neutral/serotonin
	name = "Serotonin Production"
	desc = "The microbes produce serotonin, improving the host's mood."
	associated_reagent = "THC"	// Agonist: activates receptors like the original neurotransmitter
	personal_messages = list("Feels good man...", "You're in a good mood.", "Life is good.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("grin", "smile", "laugh", "chuckle"))
			boutput(M, "<span class='notice'>[pick(personal_messages)]</span>")
		// Increase mood sim for RP?

/datum/microbioeffects/neutral/gaba
	name = "GABA Production"
	desc = "The microbes produce GABA, calming the host."
	associated_reagent = "ethanol"	//Agonist
	personal_messages = list("You feel relaxed.", "You're chilled out.", "You feel calmed.")

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("yawn", "stretch"))
			boutput(M, "<span class='notice'>[pick(personal_messages)]</span>")
