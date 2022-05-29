datum/pathogeneffects/neutral
	name = "Neutral"
	rarity = THREAT_NEUTRAL

datum/pathogeneffects/neutral/brewery
	name = "Auto-Brewery"
	desc = "The pathogen aids the host body in metabolizing chemicals into ethanol."
	rarity = THREAT_NEUTRAL
	beneficial = 0

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		var/times = 1
		if (origin.stage > 3)
			times++
		if (origin.stage > 4)
			times++
		var/met = 0
		for (var/rid in M.reagents.reagent_list)
			var/datum/reagent/R = M.reagents.reagent_list[rid]
			if (!(rid == "ethanol" || istype(R, /datum/reagent/fooddrink/alcoholic)))
				met = 1
				for (var/i = 1, i <= times, i++)
					if (R) //Wire: Fix for Cannot execute null.on mob life().
						R.on_mob_life()
					if (!R || R.disposed)
						break
				if (R && !R.disposed)
					var/amt = R.depletion_rate * times
					M.reagents.remove_reagent(rid, amt)
					M.reagents.add_reagent("ethanol", amt)
		if (met)
			M.reagents.update_total()

	react_to(var/R, var/zoom)
		if (!(R == "ethanol"))
			return "The pathogen appears to have entirely metabolized all chemical agents in the dish into... ethanol."

	may_react_to()
		return "The pathogen appears to react with anything but a pure intoxicant."

datum/pathogeneffects/neutral/hiccups
	name = "Hiccups"
	desc = "The pathogen sends involuntary signals to the infected individual's diaphragm."
	infect_type = INFECT_NONE
	rarity = THREAT_NEUTRAL
	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(1))
					M:emote("hiccup")

			if (2)
				if (prob(2))
					M:emote("hiccup")

			if (3)
				if (prob(4))
					M:emote("hiccup")

			if (4)
				if (prob(8))
					M:emote("hiccup")

			if (5)
				if (prob(16))
					M:emote("hiccup")

	may_react_to()
		return "The pathogen appears to be violently... hiccuping?"

/*datum/pathogeneffects/benevolent/oxytocinproduction
	name = "Oxytocin Production"
	desc = "The pathogen produces Pure Love within the infected."
	infect_type = INFECT_TOUCH
	rarity = THREAT_BENETYPE2
	spread = SPREAD_BODY | SPREAD_HANDS
	infect_message = "<span style=\"color:pink\">You can't help but feel loved.</span>"
	infect_attempt_message = "Their touch is suspiciously soft..."

	onemote(mob/M as mob, act, voluntary, param, datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (act != "hug" && act != "sidehug")  // not a hug
			return
		if (param == null) // weirdo is just hugging themselves
			return
		for (var/mob/living/carbon/human/H in view(1, M))
			if (ckey(param) == ckey(H.name) && prob(origin.spread*2))
				SPAWN(0.5)
					infect_direct(H, origin, "hug")
				return

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		var/check_amount = M.reagents.get_reagent_amount("love")
		if (!check_amount || check_amount < 5)
			M.reagents.add_reagent("love", origin.stage / 3)

	may_react_to()
		return "The pathogen's cells appear to be... hugging each other?"
*/

datum/pathogeneffects/neutral/sunglass
	name = "Sunglass Glands"
	desc = "The infected grew sunglass glands."
	infect_type = INFECT_NONE
	rarity = THREAT_NEUTRAL

	proc/glasses(var/mob/living/carbon/human/M as mob)
		var/obj/item/clothing/glasses/G = M.glasses
		var/obj/item/clothing/glasses/N = new/obj/item/clothing/glasses/sunglasses()
		M.show_message({"<span class='notice'>[pick("You feel cooler!", "You find yourself wearing sunglasses.", "A pair of sunglasses grow onto your face.")][G?" But you were already wearing glasses!":""]</span>"})
		if (G)
			N.set_loc(M.loc)
			var/turf/T = get_edge_target_turf(M, pick(alldirs))
			N.throw_at(T,rand(0,5),1)
		else
			N.set_loc(M)
			N.layer = M.layer
			N.master = M
			M.glasses = N
			M.update_clothing()

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (!(H.glasses) || (!(istype(H.glasses, /obj/item/clothing/glasses/sunglasses)) && prob(50)))
				switch(origin.stage)
					if (2 to 4)
						if (prob(15))
							glasses(M)
					if (5)
						if (prob(25))
							glasses(M)

	may_react_to()
		return "The pathogen appears to be sensitive to sudden flashes of light."

	react_to(var/R, var/zoom)
		if (R == "flashpowder")
			if (zoom)
				return "The individual microbodies appear to be wearing sunglasses."
			else
				return "The pathogen appears to have developed a resistance to the flash powder."

datum/pathogeneffects/neutral/deathgasping
	name = "Deathgasping"
	desc = "The pathogen causes the user's brain to believe the body is dying."
	infect_type = INFECT_NONE
	rarity = THREAT_NEUTRAL
	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					M:emote("deathgasp")

			if (2)
				if (prob(12))
					M:emote("deathgasp")

			if (3)
				if (prob(14))
					M:emote("deathgasp")

			if (4)
				if (prob(16))
					M:emote("deathgasp")

			if (5)
				if (prob(18))
					M:emote("deathgasp")

	may_react_to()
		return "The pathogen appears to be.. sort of dead?"

datum/pathogeneffects/neutral/shakespeare
	name = "Shakespeare"
	desc = "The infected has an urge to begin reciting shakespearean poetry."
	infect_type = INFECT_NONE
	rarity = THREAT_NEUTRAL
	var/static/list/shk = list("Expectation is the root of all heartache.",
"A fool thinks himself to be wise, but a wise man knows himself to be a fool.",
"Love all, trust a few, do wrong to none.",
"Hell is empty and all the devils are here.",
"Better a witty fool than a foolish wit.",
"The course of true love never did run smooth.",
"Come, gentlemen, I hope we shall drink down all unkindness.",
"Suspicion always haunts the guilty mind.",
"No legacy is so rich as honesty.",
"Alas, I am a woman friendless, hopeless!",
"The empty vessel makes the loudest sound.",
"Words without thoughts never to heaven go.",
"This above all; to thine own self be true.",
"An overflow of good converts to bad.",
"It is a wise father that knows his own child.",
"Listen to many, speak to a few.",
"Boldness be my friend.",
"Speak low, if you speak love.",
"Give thy thoughts no tongue.",
"The devil can cite Scripture for his purpose.",
"In time we hate that which we often fear.",
"The lady doth protest too much, methinks.")

	onsay(var/mob/M as mob, message, var/datum/pathogen/origin)
		if (!(message in shk))
			return shakespearify(message)

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(origin.stage)) // 3. holy shit shut up shUT UP
			M.say(pick(shk))

	may_react_to()
		return "The culture appears to be quite dramatic."

datum/pathogeneffects/neutral/hoarseness
	name = "Hoarseness"
	desc = "The pathogen causes dry throat, leading to hoarse speech."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(10))
			M:emote("wheeze")
		else if (prob(5))
			M:emote("cough")
		else if (prob(5))
			M:emote("grumble")

	may_react_to()
		return "The pathogen appears to be rapidly breaking down certain materials around it."

datum/pathogeneffects/neutral/exclusiveimmunity
	name = "Exclusive Immunity"
	desc = "The pathogen occupies almost all possible routes of infection, preventing other diseases from entering."
	rarity = THREAT_BENETYPE2

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		//if (other pathogens detected)
			//grab their in_remission
			//set their vals to 1

	may_react_to()
		return "The pathogen appears to have the ability to bond with organic tissue."

datum/pathogeneffects/neutral/malaise
	name = "Malaise"
	desc = "The pathogen causes very mild, inconsequential fatigue to its host."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(10))
			M:emote("yawn")
		else if (prob(5))
			M:emote("cough")
		else if (prob(5))
			M:emote("stretch")

	may_react_to()
		return "The pathogen appears to have a gland that may affect neural functions."

datum/pathogeneffects/neutral/hyperactive
	name = "Psychomotor Agitation"
	desc = "Also known as restlessness, the infected individual is prone to involuntary motions and tics."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(8))
			M:emote("gesticulate")
		else if (prob(5))
			M:emote("blink_r")
		else if (prob(5))
			M:emote("twitch")

	may_react_to()
		return "The pathogen appears to be wilder than usual, perhaps sedatives or psychoactive substances might affect its behaviour."\

datum/pathogeneffects/neutral/bloodcolors
	name = "Blood Pigmenting"
	desc = "The pathogen attaches to the kidneys and adds a harmless pigment to the host's blood cells, causing their blood to have an unusual color."
	rarity = THREAT_NEUTRAL

	//var/bloodcolor =

	//randomly select blood color

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		//if bleeding
			//change blood color to bloodcolor

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

datum/pathogeneffects/neutral/startleresponse
	name = "Exagerrated Startle Reflex"
	desc = "The pathogen generates synaptic signals that amplify the host's startle reflex."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(8))
			M:emote("quiver")
		else if (prob(5))
			M:emote("flinch")
		else if (prob(5))
			M:emote("tremble")

	may_react_to()
		return "The pathogen appears to have a gland that may affect neural functions."

datum/pathogeneffects/neutral/tearyeyed
	name = "Overactive Eye Glands"
	desc = "The pathogen causes the host's lacrimal glands to overproduce tears."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(8))
			M:emote("blink")
		else if (prob(5))
			M:emote("cry")
		else if (prob(5))
			M:emote("sob")

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

datum/pathogeneffects/neutral/restingface
	name = "Grumpy Cat Syndrome"
	desc = "The pathogen causes the host's facial muscles to frown at rest."
	rarity = THREAT_NEUTRAL

	disease_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(8))
			M:emote("frown")
		else if (prob(5))
			M:emote("scowl")
		else if (prob(5))
			M:emote("grimace")

	may_react_to()
		return "The pathogen appears to react to hydrating agents."
