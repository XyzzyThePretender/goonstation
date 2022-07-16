// Neutral effects are not designed to cause harm.
// Neutral effects use the emote system to inform infected players
// There are currently 10 neutral effects.
// Neutral effects could exploit the facets of neurochemicals and neurotransmitters for ideas.
ABSTRACT_TYPE(/datum/microbioeffects/neutral)
/datum/microbioeffects/neutral
	name = "Neutral Effects"

/datum/microbioeffects/neutral/hiccups
	name = "Hiccups"
	desc = "The microbes send involuntary signals to the infected individual's diaphragm."
	reactionlist = list("ethanol")
	reactionmessage = "The microbes appear to be violently... hiccuping?"

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("hiccup")

/datum/microbioeffects/neutral/sunglass
	name = "Sunglass Glands"
	desc = "The infected grew sunglass glands."
	reactionlist = list("flashpowder")
	reactionmessage = "The microbes appear to be wearing sunglasses."
	must_unlock = TRUE

	proc/glasses(var/mob/living/carbon/human/M)
		var/obj/item/clothing/glasses/G = M.glasses
		var/obj/item/clothing/glasses/N = new/obj/item/clothing/glasses/sunglasses()
		M.show_message({"<span class='notice'>[pick("You feel cooler!", "You find yourself wearing sunglasses.", \
		"A pair of sunglasses grow onto your face.")][G?" But you were already wearing glasses!":""]</span>"})
		if (G)
			N.set_loc(M.loc)
			var/turf/T = get_edge_target_turf(M, pick(alldirs))
			N.throw_at(T,rand(0,5),1)
		else
			N.set_loc(M)
			N.layer = M.layer
			N.master = M
			M.glasses = N

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (!ishuman(M))
			return
		var/mob/living/carbon/human/H = M
		//case 1: player has no glasses and succeeds roll
		//OR case 2: player has glasses and succeeds halved roll
		if ((!(H.glasses) && prob(origin.probability)) || (!(istype(H.glasses, /obj/item/clothing/glasses/sunglasses)) && prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON)))
			glasses(M)
			M.update_clothing()

/datum/microbioeffects/neutral/deathgasping
	name = "Deathgasping"
	desc = "The microbes cause the user's brain to believe the body is dying."
	reactionlist = MB_BRAINDAMAGE_REAGENTS
	reactionmessage = "The microbes appear to be.. sort of dead?"
	must_unlock = TRUE

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability*MICROBIO_EFFECT_PROBABILITY_FACTOR_OHGODHELP))	//No spam plox
			M.emote("deathgasp")

/datum/microbioeffects/neutral/hoarseness
	name = "Hoarseness"
	desc = "The microbes cause dry throat, leading to hoarse speech."
	reactionlist = list("water")
	reactionmessage = MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("wheeze", "cough", "grumble"))

/datum/microbioeffects/neutral/malaise
	name = "Malaise"
	desc = "The pathogen causes inconsequential fatigue to its host."
	reactionlist = MB_SEDATIVES_CATAGORY
	reactionmessage = MICROBIO_INSPECT_LIKES_GENERIC

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("yawn", "cough", "stretch"))

//Possibility of incorporating other neurotransmitters here?

/datum/microbioeffects/neutral/acetylcholine
	name = "Acetylcholine Production"
	desc = "A gland on the microbe produces acetylcholine, causing an infected host to experience involuntary convulsions."
	reactionlist = list("atropine")	//atropine is a receptor antagonist (blocks ACh)

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("twitch", "twitch_v", "blink", "blink_r"))

/datum/microbioeffects/neutral/norepinepherine
	name = "Norepinepherine Production"
	desc = "The microbes generate norepinepherine, stimulating the host's fight-flight response."
	reactionlist = list("haloperidol")	//antagonists (not game antags, technical nomenclature!) include antipsychotics
	reactionmessage = "The microbes move less erratically through the reagent."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("twitch", "twitch_v", "flinch"))

/datum/microbioeffects/neutral/tearyeyed
	name = "Overactive Eye Glands"
	desc = "The microbes cause the host's lacrimal glands to overproduce tears."
	reactionlist = list("saline", "oculine", "water")
	reactionmessage = "The microbes seem to disappear into the solution."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("blink", "blink_r", "cry"))

/datum/microbioeffects/neutral/atosiban
	name = "Atosiban Production"
	desc = "The microbes produce atosiban, inhibiting oxytocin receptors."
	reactionlist = list("THC", "sugar", "hugs")	//What makes dopamine?
	reactionmessage = "The microbes start to move in a strangely cheerful manner."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote(pick("frown", "scowl", "grimace"))

/datum/microbioeffects/neutral/farts
	name = "Farts"
	desc = "The infected individual occasionally farts."
	reactionlist = list("saline", "oil", "sugar", "water")	//Look into what chemicals go into laxatives
	reactionmessage = "The microbes appear to produce a large volume of gas. The smell is horrendous."

	mob_act(var/mob/M, var/datum/microbeplayerdata/origin)
		if (prob(origin.probability))
			M.emote("fart")

