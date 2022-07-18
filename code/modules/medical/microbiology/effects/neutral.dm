// Neutral effects are not designed to cause harm.
// Neutral effects use the emote system to inform infected players
// There are currently 8 neutral effects.

ABSTRACT_TYPE(/datum/microbioeffects/neutral)
/datum/microbioeffects/neutral
	name = "Neutral Effects"

/datum/microbioeffects/neutral/farts
	name = "Farts"
	desc = "The infected individual occasionally farts."
	reactionlist = MB_METABOLISM_REAGENTS
	reactionmessage = "The microbes appear to produce a large volume of gas. The smell is horrendous."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("fart")
			make_cloud(M, origin.master.hexcolors)

/datum/microbioeffects/neutral/hiccups
	name = "Hiccups"
	desc = "The microbes send involuntary signals to the infected individual's diaphragm."
	reactionlist = list("ethanol")
	reactionmessage = "The microbes appear to be violently... hiccuping?"

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("hiccup")
			make_cloud(M, origin.master.hexcolors)

/datum/microbioeffects/neutral/hoarseness
	name = "Hoarseness"
	desc = "The microbes cause dry throat, leading to hoarse speech."
	reactionlist = list("saline", "oculine", "water")
	reactionmessage = MICROBIO_INSPECT_LIKES_GENERIC

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("wheeze", "grumble"))

/datum/microbioeffects/neutral/fluent
	name = "Fluent"
	desc = "The microbes cause the host to overproduce saliva and tears."
	reactionlist = list("saline", "oculine", "water")
	reactionmessage = "The microbes disappear in the solution."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("cry", "drool", "gurgle"))
			make_puddle(M, origin.master.hexcolors)

// Neurotransmitters

/datum/microbioeffects/neutral/acetylcholine
	name = "Acetylcholine Production"
	desc = "The microbes produce acetylcholine, stimulating the host's muscular system."
	reactionlist = list("atropine")	//antagonist (not game antags, technical nomenclature!) is atropine
	reactionmessage = "The microbes move less erratically through the reagent."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("flex", "flexmuscles", "crackknuckles", "blink_r"))

/datum/microbioeffects/neutral/norepinepherine
	name = "Norepinepherine Production"
	desc = "The microbes produce norepinepherine, stimulating the host's fight-flight response."
	reactionlist = list("haloperidol")	//antagonists include antipsychotics
	reactionmessage = "The microbes move less erratically through the reagent."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("twitch", "twitch_v", "flinch"))

/datum/microbioeffects/neutral/serotonin
	name = "Serotonin Production"
	desc = "The microbes produce serotonin, improving the host's mood."
	reactionlist = MB_HALLUCINOGENICS_CATAGORY	// Agonist: makes brain produce more chemical
	reactionmessage = "The microbes start to move in a strangely cheerful manner."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("grin", "smile", "laugh", "chuckle"))

/datum/microbioeffects/neutral/gaba
	name = "GABA Production"
	desc = "The microbes produce GABA, calming the host."
	reactionlist = list("ethanol")	//Agonist
	reactionmessage = "The microbes in the ethanol move sedately."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("yawn", "stretch"))
