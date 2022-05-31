// Effects for nuclear bio-operator diseases and natural illnesses go here
/datum/microbioeffects/malevolent
	name = "Malevolent"

// The following lines are the probably undocumented (well at least my part - Marq) hell of the default symptoms.
/datum/microbioeffects/malevolent/coughing
	name = "Coughing"
	desc = "Violent coughing occasionally plagues the infected."

	mob_act(var/mob/M as mob, var/datum/microbe/origin)
		if (prob(0.06))
			M.show_message("<span class='alert'>You cough.</span>")

	onadd(var/datum/microbe/origin)
		origin.effectdata += "cough"

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

/*datum/pathogeneffects/malevolent/indigestion
	name = "Indigestion"
	desc = "A bad case of indigestion which occasionally cramps the infected."
	rarity = THREAT_TYPE2

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1 to 3)
				if (prob(5))
					M.show_message("<span class='alert'>Your stomach hurts.</span>")
			if (4 to 5)
				if (prob(8))
					M.take_toxin_damage(origin.stage-3)
					M.show_message("<span class='alert'>Your stomach hurts really bad!</span>")

	react_to(var/R, var/zoom)
		if (R == "saline")
			if (zoom)
				return "One of the glands of the pathogen seems to shut down in the presence of the solution."

	may_react_to()
		return "The pathogen appears to react to hydrating agents."

datum/pathogeneffects/malevolent/muscleache
	name = "Muscle Ache"
	desc = "The infected feels a slight, constant aching of muscles."
	rarity = THREAT_TYPE1

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1 to 3)
				if (prob(5))
					M.show_message("<span class='alert'>Your muscles ache.</span>")
			if (4 to 5)
				if (prob(8))
					M.show_message("<span class='alert'>Your muscles ache!</span>")
				if (prob(15))
					M.show_message("<span class='alert'>Your muscles ache!</span>")
					M.TakeDamage("All", origin.stage-3, 0)

	react_to(var/R, var/zoom)
		if (R == "saline")
			if (zoom)
				return "One of the glands of the pathogen seems to shut down in the presence of the solution."

	may_react_to()
		return "The pathogen appears to react to hydrating agents."

datum/pathogeneffects/malevolent/sneezing
	name = "Sneezing"
	desc = "The infected sneezes frequently."
	rarity = THREAT_TYPE2

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(0.08*origin.spread))
					M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze.</span>", "<span class='alert'>You hear someone sneezing.</span>")
					src.infect_cloud(M, origin)
			if (2)
				if (prob(0.1*origin.spread))
					M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze.</span>", "<span class='alert'>You hear someone sneezing.</span>")
					src.infect_cloud(M, origin)
			if (3)
				if (prob(0.15*origin.spread))
					M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze.</span>", "<span class='alert'>You hear someone sneezing.</span>")
					src.infect_cloud(M, origin)
			if (4)
				if (prob(0.2*origin.spread))
					M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze!</span>", "<span class='alert'>You hear someone sneezing!</span>")
					src.infect_cloud(M, origin)
			if (5)
				if (prob(0.2*origin.spread))
					M.visible_message("<span class='alert'>[M] sneezes!</span>", "<span class='alert'>You sneeze!</span>", "<span class='alert'>You hear someone sneezing!</span>")
					src.infect_cloud(M, origin)

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

	react_to(var/R, var/zoom)
		if (R == "pepper")
			return "The pathogen violently discharges fluids when coming in contact with pepper."

datum/pathogeneffects/malevolent/gasping
	name = "Gasping"
	desc = "The infected has trouble breathing."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE3 //Superceded by pulmonary oedema (4) and internal haemorrhaging (5), stronger than cough (2) and chest pain (1)
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(3))
					M.emote("gasp")
			if (2)
				if (prob(5))
					M.emote("gasp")
			if (3)
				if (prob(7))
					M.emote("gasp")
			if (4)
				if (prob(10))
					M.emote("gasp")
					M.take_oxygen_deprivation(1)
			if (5)
				if (prob(10))
					M.emote("gasp")
					M.take_oxygen_deprivation(1)
					M.losebreath += 1

	may_react_to()
		return "The pathogen appears to create bubbles of vacuum around its affected area."

/*datum/pathogeneffects/malevolent/moaning
	name = "Moaning"
	desc = "This is literally pointless."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE1
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					M:emote("moan")

			if (2)
				if (prob(12))
					M:emote("moan")

			if (3)
				if (prob(14))
					M:emote("moan")

			if (4)
				if (prob(16))
					M:emote("moan")

			if (5)
				if (prob(18))
					M:emote("moan")

	may_react_to()
		return "The pathogen appears to be rather displeased."
*/

datum/pathogeneffects/malevolent/shivering
	name = "Shivering"
	desc = "The pathogen slightly raises the homeostatic set point of the infected."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE2
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					M:emote("shiver")

			if (2)
				if (prob(12))
					M:emote("shiver")

			if (3)
				if (prob(14))
					M:emote("shiver")

			if (4)
				if (prob(16))
					M:emote("shiver")

			if (5)
				if (prob(18))
					M:emote("shiver")

	may_react_to()
		return "The pathogen appears to be shivering."

datum/pathogeneffects/malevolent/sweating
	name = "Sweating"
	desc = "The infected person sweats like a pig."
	infect_type = INFECT_TOUCH
	rarity = THREAT_TYPE2
	spread = SPREAD_HANDS | SPREAD_BODY
	infect_attempt_message = "Ew, their hands feel really gross and sweaty!"
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(5))
					M.show_message("<span class='alert'>You feel a bit warm.</span>")
				if (prob(40))
					src.infect_puddle(M, origin)

			if (2)
				if (prob(5))
					M.show_message("<span class='alert'>You feel rather warm.</span>")
				if (prob(40))
					src.infect_puddle(M, origin)

			if (3)
				if (prob(5))
					M.show_message("<span class='alert'>You're sweating heavily.</span>")
				if (prob(40))
					src.infect_puddle(M, origin)

			if (4)
				if (prob(5))
					M.show_message("<span class='alert'>You're soaked in your own sweat.</span>")
				if (prob(40))
					src.infect_puddle(M, origin)

			if (5)
				if (prob(5))
					M.show_message("<span class='alert'>You're soaked in your own sweat.</span>")
				if (prob(40))
					src.infect_puddle(M, origin)

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

	react_to(var/R, zoom)
		if (R == "cryostylane")
			return "The cold substance appears to affect the fluid generation of the pathogen."

datum/pathogeneffects/malevolent/disorientation
	name = "Disorientation"
	desc = "The infected occasionally gets disoriented."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE3
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					boutput(M, "<span class='alert'>You feel a bit disoriented.</span>")
					M.change_misstep_chance(10)

			if (2)
				if (prob(12))
					boutput(M, "<span class='alert'>You feel a bit disoriented.</span>")
					M.change_misstep_chance(10)

			if (3)
				if (prob(14))
					boutput(M, "<span class='alert'>You feel a bit disoriented.</span>")
					M.change_misstep_chance(20)

			if (4)
				if (prob(16))
					boutput(M, "<span class='alert'>You feel rather disoriented.</span>")
					M.change_misstep_chance(20)

			if (5)
				if (prob(18))
					boutput(M, "<span class='alert'>You feel rather disoriented.</span>")
					M.change_misstep_chance(30)
					M.take_brain_damage(1)
	may_react_to()
		return "A glimpse at the pathogen's exterior indicates it could affect the central nervous system. "

	react_to(var/R, zoom)
		if (R == "mannitol")
			return "The pathogen appears to have trouble cultivating in the areas affected by the mannitol."

obj/hallucinated_item
	icon = null
	icon_state = null
	name = ""
	desc = ""
	anchored = 1
	density = 0
	opacity = 0
	var/mob/owner = null

	New(myloc, myowner, var/obj/prototype)
		..()
		myowner = owner
		name = prototype?.name || "something unknown"
		desc = prototype?.desc

	attack_hand(var/mob/M)
		if (M == owner)
			M.show_message("<span class='alert'>[src] slips through your hands!</span>")
			if (prob(10))
				M.show_message("<span class='alert'>[src] disappears!</span>")
				qdel(src)

datum/pathogeneffects/malevolent/serious_paranoia
	name = "Insanity"
	desc = "The infected has entered a psychotic state and is having trouble distinguishing between reality and fiction."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5
	var/static/list/hallucinated_images = list(/obj/item/sword, /obj/item/card/emag, /obj/item/cloaking_device)
	var/static/list/traitor_items = list("cyalume saber", "Electromagnetic Card", "pen", "mini rad-poison crossbow", "cloaking device", "revolver", "butcher's knife", "amplified vuvuzela", "power gloves", "signal jammer")

	proc/trader(var/mob/M as mob, var/mob/living/O as mob)
		var/action = "says"
		if (issilicon(O))
			action = "states"
		var/what = pick("I am the traitor.", "I will kill you.", "You will die, [M].")
		if (prob(50))
			boutput(M, "<B>[O]</B> points at [M].")
			make_point(get_turf(M))
		boutput(M, "<B>[O]</B> [action], \"[what]\"")

	proc/backpack(var/mob/M, var/mob/living/O)
		var/item = pick(traitor_items)
		boutput(M, "<span class='notice'>[O] has added the [item] to the backpack!</span>")
		logTheThing("pathology", M, O, "saw a fake message about an [constructTarget(O,"pathology")] adding [item] to their backpacks due to Serious Paranoia symptom.")

	proc/acidspit(var/mob/M, var/mob/living/O, var/mob/living/O2)
		if (O2)
			boutput(M, "<span class='alert'><B>[O] spits acid at [O2]!</B></span>")
		else
			boutput(M, "<span class='alert'><B>[O] spits acid at you!</B></span>")
		logTheThing("pathology", M, O, "saw a fake message about an [constructTarget(O,"pathology")] spitting acid due to Serious Paranoia symptom.")

	proc/vampirebite(var/mob/M, var/mob/living/O, var/mob/living/O2)
		if (O2)
			boutput(M, "<span class='alert'><B>[O] bites [O2]!</B></span>")
		else
			boutput(M, "<span class='alert'><B>[O] bites you!</B></span>")
		logTheThing("pathology", M, O, "saw a fake message about an [constructTarget(O,"pathology")] biting someone due to Serious Paranoia symptom.")

	proc/floor_in_view(var/mob/M)
		var/list/ret = list()
		for (var/turf/simulated/floor/T in view(M, 7))
			ret += T
		return ret

	proc/hallucinate_item(var/mob/M)
		var/item = pick(hallucinated_images)
		var/obj/item_inst = new item()
		var/list/LF = floor_in_view(M)
		if(!LF.len) return
		var/obj/hallucinated_item/H = new /obj/hallucinated_item(pick(floor_in_view(M)), M, item_inst)
		var/image/hallucinated_image = image(item_inst, H)
		M << hallucinated_image

	may_react_to()
		return "The pathogen appears to be wilder than usual, perhaps sedatives or psychoactive substances might affect its behaviour."

	react_to(var/R, var/zoom)
		if (zoom == 1)
			if (R == "morphine" || R == "ketamine")
				return "The pathogens near the sedative appear to be in stasis."
		if (R == "LSD")
			return "The pathogen appears to be strangely unaffected by the LSD."

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					for (var/mob/living/O in oview(7, M))
						trader(M, O)
						return

			if (2)
				if (prob(12))
					for (var/mob/living/O in oview(7, M))
						if (prob(50))
							trader(M, O)
						else
							boutput(M, "<span class='notice'>[O] has added the suspicious item to the backpack!</span>")
						return

			if (3)
				if (prob(14))
					for (var/mob/living/O in oview(7, M))
						if (prob(50))
							trader(M, O)
						else
							backpack(M, O)
						return

			if (4)
				if (prob(16))
					var/list/mob/living/OL = list()
					for (var/mob/living/O in oview(7, M))
						OL += O
					if (OL.len == 0)
						return
					var/event = pick(list(1, 2, 3, 4, 5, 6))
					switch (event)
						if (1)
							trader(M, pick(OL))
						if (2)
							backpack(M, pick(OL))
						if (3)
							var/M1 = pick(OL)
							OL -= M1
							if (OL.len)
								acidspit(M, M1, pick(OL))
							else
								acidspit(M, M1, null)
						if (4)
							var/M1 = pick(OL)
							OL -= M1
							if (OL.len)
								vampirebite(M, M1, pick(OL))
							else
								vampirebite(M, M1, null)
						if (5)
							hallucinate_item(M)
						if (6)
							M.flash(3 SECONDS)
							var/sound/S = sound(pick('sound/effects/Explosion1.ogg','sound/effects/Explosion1.ogg'), repeat=0, wait=0, volume=50)
							S.frequency = rand(32000, 55000)
							M << S
					return

			if (5)
				if (prob(18))
					var/list/mob/living/OL = list()
					for (var/mob/living/O in oview(7, M))
						OL += O
					if (OL.len == 0)
						return
					var/event = pick(list(1, 2, 3, 4, 5, 6))
					switch (event)
						if (1)
							trader(M, pick(OL))
						if (2)
							backpack(M, pick(OL))
						if (3)
							var/M1 = pick(OL)
							OL -= M1
							if (OL.len)
								acidspit(M, M1, pick(OL))
							else
								acidspit(M, M1, null)
						if (4)
							var/M1 = pick(OL)
							OL -= M1
							if (OL.len)
								vampirebite(M, M1, pick(OL))
							else
								vampirebite(M, M1, null)
						if (5)
							hallucinate_item(M)
						if (6)
							M.flash(3 SECONDS)
							var/sound/S = sound(pick('sound/effects/Explosion1.ogg','sound/effects/Explosion1.ogg'), repeat=0, wait=0, volume=50)
							S.frequency = rand(32000, 55000)
							M << S
					return

datum/pathogeneffects/malevolent/serious_paranoia/mild
	name = "Paranoia"
	desc = "The infected is suspicious of others, to the point where they might see others do traitorous things."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE4

	may_react_to()
		return "The pathogen appears to be wilder than usual, perhaps sedatives or psychoactive substances might affect its behaviour."

	react_to(var/R, var/zoom)
		if (zoom == 1)
			if (R == "morphine" || R == "ketamine")
				return "The pathogens near the sedative appear to be in stasis."
		if (R == "LSD")
			return "The pathogen appears to be barely affected by the LSD."

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					for (var/mob/living/O in oview(7, M))
						trader(M, O)
						return

			if (2)
				if (prob(12))
					for (var/mob/living/O in oview(7, M))
						if (prob(50))
							trader(M, O)
						else
							boutput(M, "<span class='notice'>[O] has added the suspicious item to the backpack!</span>")
						return

			if (3)
				if (prob(14))
					for (var/mob/living/O in oview(7, M))
						if (prob(50))
							trader(M, O)
						else
							backpack(M, O)
						return

			if (4)
				if (prob(16))
					var/list/mob/living/OL = list()
					for (var/mob/living/O in oview(7, M))
						OL += O
					if (OL.len == 0)
						return
					var/event = pick(list(1, 2, 3))
					switch (event)
						if (1)
							trader(M, pick(OL))
						if (2)
							backpack(M, pick(OL))
						if (3)
							hallucinate_item(M)
					return

			if (5)
				if (prob(18))
					var/list/mob/living/OL = list()
					for (var/mob/living/O in oview(7, M))
						OL += O
					if (OL.len == 0)
						return
					var/event = pick(list(1, 2, 3))
					switch (event)
						if (1)
							trader(M, pick(OL))
						if (2)
							backpack(M, pick(OL))
						if (3)
							hallucinate_item(M)
					return

datum/pathogeneffects/malevolent/teleportation
	name = "Teleportation"
	desc = "The infected exists in a twisted spacetime."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE4
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (origin.stage >= 3)
			if (isrestrictedz(M.z))
				return
		switch (origin.stage)
			if (1)
				if (prob(6))
					M.show_message("<span class='alert'>You feel space warping around you.</span>")

			if (2)
				if (prob(6))
					M.show_message("<span class='alert'>You feel space warping around you.</span>")

			if (3)
				if (prob(8))
					M.show_message("<span class='alert'>You are suddenly zapped elsewhere!</span>")
					var/turf/T = pick(orange(7, M.loc))
					do_teleport(M, T, 1)

			if (4)
				if (prob(10))
					M.show_message("<span class='alert'>You are suddenly zapped elsewhere!</span>")
					var/turf/T = pick(orange(11, M.loc))
					do_teleport(M, T, 2)

			if (5)
				if (prob(15))
					M.show_message("<span class='alert'>You are suddenly zapped elsewhere!</span>")
					var/turf/T = pick(orange(15, M.loc))
					do_teleport(M, T, 3)

	may_react_to()
		return "A glimpse at an irregular nerve center of the pathogen indicates that it might react to psychoactive substances."

	react_to(var/R, var/zoom)
		if (R == "LSD")
			if (zoom)
				return "Upon closer examination, the pathogens appear to be shifting through space, instantly disappearing and reappearing."
			else
				return "The pathogens appear to be rapidly moving around the LSD-filled dish."
		else return null

datum/pathogeneffects/malevolent/gibbing
	name = "Gibbing"
	desc = "The infected person may spontaneously gib."
	rarity = THREAT_TYPE5
	spread = SPREAD_FACE | SPREAD_HANDS | SPREAD_AIR | SPREAD_BODY
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(5))
					M.show_message("<span class='alert'>Your body feels a bit tight.</span>")

			if (2)
				if (prob(5))
					M.show_message("<span class='alert'>Your body feels a bit tight.</span>")

			if (3)
				if (prob(10))
					M.show_message("<span class='alert'>Your body feels too tight to hold your organs inside.</span>")

			if (4)
				if (prob(20))
					M.show_message("<span class='alert'>Your body feels too tight to hold your organs inside.</span>")
				else if (prob(20))
					M.show_message("<span class='alert'>You feel like you could explode at any time.</span>")

			if (5)
				if (prob(1))
					if (ishuman(M))
						// it's funnier if their organs actually do burst out.
						var/mob/living/carbon/human/H = M
						H.dump_contents_chance = 100
					M.show_message("<span class='alert'>Your organs burst out of your body!</span>")
					src.infect_cloud(M, origin, origin.spread) // boof
					logTheThing("pathology", M, null, "gibbed due to Gibbing symptom in [origin].")
					M.gib()
				else if (prob(30))
					M.show_message("<span class='alert'>Your body feels too tight to hold your organs inside.</span>")
				else if (prob(30))
					M.show_message("<span class='alert'>You feel like you could explode at any time.</span>")

	may_react_to()
		return "The culture appears to process proteins at an irregular speed."

	react_to(var/R, var/zoom)
		if (R == "synthflesh")
			if (zoom)
				return "There are stray synthflesh pieces all over the dish."
			else
				return "Pathogens appear to be storming the synthflesh chunks and through an extreme conversion of energy, bursting them into smaller, more processible chunks."
		else return null

datum/pathogeneffects/malevolent/fluent
	name = "Fluent Speech"
	desc = "The infection has a serious excess of saliva."
	infect_type = INFECT_AREA
	spread = SPREAD_FACE
	infect_message = "<span class='alert'>A drop of saliva lands on your face.</span>"
	rarity = THREAT_TYPE3
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		return

	onsay(var/mob/M as mob, message, var/datum/pathogen/origin)
		if (origin.in_remission)
			return message
		switch (origin.stage)
			if (1 to 3)
				if (prob(origin.stage * origin.spread * 0.16))
					src.infect_cloud(M, origin)

			if (4 to 5)
				if (prob(origin.stage * origin.spread * 0.4))
					src.infect_cloud(M, origin)
		return message

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids."

	react_to(var/R, var/zoom)
		if (R == "salt")
			return "The pathogen stops generating fluids when coming in contact with salt."

datum/pathogeneffects/malevolent/liverdamage
	name = "Hepatomegaly"
	desc = "The infected has an inflamed liver."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(4) && M.reagents.has_reagent("ethanol"))
					M.show_message("<span class='alert'>You feel a slight burning in your gut.</span>")
			if (2)
				if (prob(6) && M.reagents.has_reagent("ethanol"))
					M.show_message("<span class='alert'>You feel a burning sensation in your gut.</span>")
			if (3)
				if (prob(8) && M.reagents.has_reagent("ethanol"))
					M.visible_message("[M] clutches their chest in pain!","<span class='alert'>You feel a searing pain in your chest!</span>")
					M.take_toxin_damage(6)
					M.changeStatus("stunned", 2 SECONDS)
			if (4)
				if (prob(10) && M.reagents.has_reagent("ethanol"))
					M.visible_message("[M] clutches their chest in pain!","<span class='alert'>You feel a horrible pain in your chest!</span>")
					M.take_toxin_damage(8)
					M.changeStatus("stunned", 2 SECONDS)
			if (5)
				if (prob(12) && M.reagents.has_reagent("ethanol"))
					M.visible_message("[M] falls to the ground, clutching their chest!", "<span class='alert'>The pain overwhelms you!</span>", "<span class='alert'>You hear someone fall.</span>")
					M.take_toxin_damage(5)
					M.changeStatus("weakened", 40 SECONDS)

	may_react_to()
		return "The pathogen appears to be capable of processing certain beverages."

	react_to(var/R, var/zoom)
		var/alcoholic = 0
		if (R == "ethanol")
			alcoholic = "ethanol"
		else
			var/datum/reagents/H = new /datum/reagents(5)
			H.add_reagent(R, 5)
			var/RE = H.get_reagent(R)
			if (istype(RE, /datum/reagent/fooddrink/alcoholic))
				alcoholic = RE:name
		if (alcoholic)
			return "The pathogen appears to react violently to the [alcoholic]."

datum/pathogeneffects/malevolent/fever
	name = "Fever"
	desc = "The body temperature of the infected individual slightly increases."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE3

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1 to 3)
				if (prob(2 * origin.stage + 3))
					M.bodytemperature += origin.stage
					M.show_message("<span class='alert'>You feel a bit hot.</span>")
			if (4)
				if (prob(11))
					M.bodytemperature += 4
					M.TakeDamage("chest", 0, 1)
					M.show_message("<span class='alert'>You feel hot.</span>")
			if (4)
				if (prob(13))
					M.bodytemperature += 6
					M.TakeDamage("chest", 0, 1)
					if (prob(40))
						M.take_toxin_damage(1)
					M.show_message("<span class='alert'>You feel hot.</span>")


	may_react_to()
		return "The pathogen appears to be creating a constant field of radiating heat. The relevant membranes look like they might be affected by painkillers."

	react_to(var/R, var/zoom)
		if (R == "salicylic_acid")
			return "The heat emission of the pathogen is completely shut down by the painkillers."

datum/pathogeneffects/malevolent/acutefever
	name = "Acute Fever"
	desc = "The body temperature of the infected individual seriously increases and may spontaneously combust."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE4

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		var/mob/living/carbon/human/H = M
		switch (origin.stage)
			if (1 to 3)
				if (prob(2 * origin.stage + 3))
					M.bodytemperature += origin.stage * 2
					M.show_message("<span class='alert'>You feel a bit hot.</span>")
			if (4)
				if (prob(11))
					M.bodytemperature += 11
					M.TakeDamage("chest", 0, 1)
					M.show_message("<span class='alert'>You feel terribly hot!</span>")
				if (prob(2))
					H.update_burning(15)
					M.show_message("<span class='alert'>You spontaneously combust!</span>")
					if (istype(M.loc, /obj/icecube))
						var/IC = M.loc
						M.set_loc(get_turf(M))
						qdel(IC)

			if (5)
				if (prob(15))
					M.bodytemperature += 17
					M.TakeDamage("chest", 0, 2)
					M.show_message("<span class='alert'>You feel like you're burning alive!</span>")
				if (prob(3))
					H.update_burning(25)
					M.show_message("<span class='alert'>You spontaneously combust!</span>")
					if (istype(M.loc, /obj/icecube))
						var/IC = M.loc
						M.set_loc(get_turf(M))
						qdel(IC)

	may_react_to()
		return "The pathogen appears to be creating a constant field of radiating heat. The relevant membranes look like they might be affected by painkillers."

	react_to(var/R, var/zoom)
		if (R == "salicylic_acid")
			return "The heat emission of the pathogen is barely affected by the painkillers."

datum/pathogeneffects/malevolent/ultimatefever
	name = "Dragon Fever"
	desc = "The body temperature of the infected individual seriously increases and may spontaneously combust. Or worse."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		var/mob/living/carbon/human/H = M
		switch (origin.stage)
			if (1 to 3)
				if (prob(4 * origin.stage))
					M.bodytemperature += origin.stage * 4
					M.show_message("<span class='alert'>You feel [pick("a bit ", "rather ", "")]hot.</span>")
			if (4)
				if (prob(12))
					M.bodytemperature += 20
					M.TakeDamage("chest", 0, 2)
					M.show_message("<span class='alert'>You feel extremely hot.</span>")
				if (prob(5))
					H.update_burning(25)
					M.show_message("<span class='alert'>You spontaneously combust!</span>")
					if (istype(M.loc, /obj/icecube))
						var/IC = M.loc
						M.set_loc(get_turf(M))
						qdel(IC)

			if (5)
				if (prob(17))
					M.bodytemperature += 25
					M.TakeDamage("chest", 0, 2)
					M.show_message("<span class='alert'>You feel your blood boiling!</span>")
				if (prob(5))
					H.update_burning(35)
					M.show_message("<span class='alert'>You spontaneously combust!</span>")
					if (istype(M.loc, /obj/icecube))
						var/IC = M.loc
						M.set_loc(get_turf(M))
						qdel(IC)
				if (prob(1) && !M.bioHolder.HasOneOfTheseEffects("fire_resist","thermal_resist"))
					M.show_message("<span class='alert'>You completely burn up!</span>")
					logTheThing("pathology", M, null, " is firegibbed due to symptom [src].")
					M.firegib()

	may_react_to()
		return "The pathogen appears to be creating a constant field of radiating heat. The relevant membranes look like they might be affected by painkillers."

	react_to(var/R, var/zoom)
		if (R == "salicylic_acid")
			return "The heat emission of the pathogen is completely unaffected by the painkillers and continues to radiate heat at an intense rate."

datum/pathogeneffects/malevolent/chills
	name = "Chills"
	desc = "The pathogen significantly increases the infected individual's set point, causing them to feel abnormally cold."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE3
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(5))
					M.bodytemperature -= 1
					M.show_message("<span class='alert'>You feel a little cold.</span>")
			if (2)
				if (prob(9))
					M.bodytemperature -= 2
					M.show_message("<span class='alert'>You feel cold.</span>")
			if (3)
				if (prob(11))
					M.bodytemperature -= 4
					M.show_message("<span class='alert'>You feel cold.</span>")
					M.emote("shiver")
			if (4)
				if (prob(13))
					M.bodytemperature -= 8
					M.show_message("<span class='alert'>You feel cold.</span>")
					M.emote("shiver")
			if (5)
				if (prob(15))
					M.bodytemperature -= 12
					M.show_message("<span class='alert'>You feel rather cold.</span>")
					M.emote("shiver")
		if (M.bodytemperature < 0)
			M.bodytemperature = 0

	may_react_to()
		return "The pathogen is producing a trail of ice. Perhaps something hot might affect it."

	react_to(var/R, var/zoom)
		if (R == "phlogiston" || R == "infernite")
			return "The hot reagent melts the trail of ice completely."

datum/pathogeneffects/malevolent/seriouschills
	name = "Rigors"
	desc = "The infected feels the sensation of seriously lowered body temperature."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE4

	proc/create_icing(var/mob/M)
		var/obj/decal/icefloor/I = new /obj/decal/icefloor
		I.set_loc(get_turf(M))
		SPAWN(30 SECONDS)
			qdel(I)

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(5))
					M.bodytemperature -= 2
					M.show_message("<span class='alert'>You feel a little cold.</span>")
			if (2)
				if (prob(9))
					M.bodytemperature -= 4
					M.show_message("<span class='alert'>You feel cold.</span>")
			if (3)
				if (prob(11))
					M.bodytemperature -= 12
					M.show_message("<span class='alert'>You feel rather cold.</span>")
					M.emote("shiver")
				if (prob(1) && isturf(M.loc))
					M.show_message("<span class='alert'>You spontaneously freeze!</span>")
					M.bodytemperature -= 16
					new /obj/icecube(get_turf(M), M)
			if (4)
				if (prob(50))
					create_icing(M)
				if (prob(13))
					if (prob(15) && isturf(M.loc))
						M.delStatus("burning")
						M.show_message("<span class='alert'>You spontaneously freeze!</span>")
						M.bodytemperature -= 20
						new /obj/icecube(get_turf(M), M)
					else
						M.bodytemperature -= 20
						M.show_message("<span class='alert'>You feel pretty damn cold.</span>")
						M.changeStatus("stunned", 1 SECOND)
						M.emote("shiver")

			if (5)
				if (prob(50))
					create_icing(M)
				if (prob(15))
					if (prob(25) && isturf(M.loc))
						M.delStatus("burning")
						M.show_message("<span class='alert'>You spontaneously freeze!</span>")
						M.bodytemperature -= 23
						new /obj/icecube(get_turf(M), M)
					else
						M.bodytemperature -= 23
						M.show_message("<span class='alert'>You're freezing!</span>")
						M.changeStatus("stunned", 2 SECONDS)
						M.emote("shiver")
		if (M.bodytemperature < 0)
			M.bodytemperature = 0

	may_react_to()
		return "The pathogen is producing a trail of ice. Perhaps something hot might affect it."

	react_to(var/R, var/zoom)
		if (R == "phlogiston" || R == "infernite")
			return "The hot reagent barely melts the trail of ice."

datum/pathogeneffects/malevolent/seriouschills/ultimate
	name = "Arctic Chills"
	desc = "The infected feels the sensation of seriously lowered body temperature. And might spontaneously become an ice statue."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1 to 3)
				if (prob(origin.stage * 4))
					M.bodytemperature -= rand(origin.stage * 5)
					M.show_message("<span class='alert'>You feel [pick("a little ", "a bit ", "rather ", "")] cold.</span>")
				if (prob(origin.stage - 1) && isturf(M.loc))
					M.show_message("<span class='alert'>You spontaneously freeze!</span>")
					M.bodytemperature -= 25
					new /obj/icecube(get_turf(M), M)
			if (4)
				if (prob(50))
					create_icing(M)
				if (prob(13))
					if (prob(15) && isturf(M.loc))
						M.delStatus("burning")
						M.show_message("<span class='alert'>You spontaneously freeze!</span>")
						M.bodytemperature -= 30
						new /obj/icecube(get_turf(M), M)
					else
						M.bodytemperature -= 30
						M.show_message("<span class='alert'>You pretty damn cold.</span>")
						M.changeStatus("stunned", 1 SECOND)
						M.emote("shiver")

			if (5)
				if (prob(50))
					create_icing(M)
				if (prob(15))
					if (prob(25) && isturf(M.loc))
						M.delStatus("burning")
						M.show_message("<span class='alert'>You spontaneously freeze!</span>")
						M.bodytemperature -= 30
						new /obj/icecube(get_turf(M), M)
					else
						M.bodytemperature -= 50
						M.show_message("<span class='alert'>[pick("You're freezing!", "You're getting cold...", "So very cold...", "You feel your skin turning into ice...")]</span>")
						M.changeStatus("stunned", 3 SECONDS)
						M.emote("shiver")
				if (prob(1) && !M.bioHolder.HasOneOfTheseEffects("cold_resist","thermal_resist"))
					M.show_message("<span class='alert'>You freeze completely!</span>")
					logTheThing("pathology", usr, null, "was ice statuified by symptom [src].")
					M.become_statue_ice()
		if (M.bodytemperature < 0)
			M.bodytemperature = 0

	may_react_to()
		return "The pathogen is producing a trail of ice. Perhaps something hot might affect it."

	react_to(var/R, var/zoom)
		if (R == "phlogiston" || R == "infernite")
			return "The hot reagent doesn't affect the trail of ice at all!"

datum/pathogeneffects/malevolent/leprosy
	name = "Leprosy"
	desc = "The infected individual is losing limbs."
	rarity = THREAT_TYPE5

	mob_act(var/mob/living/carbon/human/M, var/datum/pathogen/origin)
		if (origin.stage < 3 || !!origin.in_remission)
			return
		switch (origin.stage)
			if (3)
				if (prob(15))
					M.show_message(pick("<span class='alert'>You feel a bit loose...</span>", "<span class='alert'>You feel like you're falling apart.</span>"))
			if (4 to 5)
				if (prob(2 + origin.stage))
					var/limb_name = pick("l_arm","r_arm","l_leg","r_leg")
					var/obj/item/parts/limb = M.limbs.vars[limb_name]
					if (istype(limb))
						if (limb.remove_stage < 2)
							limb.remove_stage = 2
							M.show_message("<span class='alert'>Your [limb] comes loose!</span>")
							SPAWN(rand(150, 200))
								if (limb.remove_stage == 2)
									limb.remove(0)
	may_react_to()
		return "The pathogen appears to be rapidly breaking down certain materials around it."

datum/pathogeneffects/malevolent/senility
	name = "Senility"
	desc = "Infection damages nerve cells in the host's brain."
	rarity = THREAT_TYPE4
	infect_type = INFECT_NONE
	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(10))
					M.show_message("<span class='alert'>You feel a little confused.</span>")
			if (2)
				if (prob(5))
					M.show_message("<span class='alert'>Your head hurts. You're not sure what's going on.</span>")
			if (3)
				if (prob(40))
					M.emote("drool")
				if (prob(20))
					M.show_message("<span class='alert'>... huh?</span>")
					M.take_brain_damage(1)
			if (4)
				if (prob(30))
					M.emote("drool")
				else if (prob(30))
					M.emote("nosepick")
				if (prob(20))
					M.show_message("<span class='alert'>You feel... unsmart.</span>")
					M.take_brain_damage(2)
			if (5)
				if (prob(10))
					M.show_message("<span class='alert'>You completely forget what you were doing.</span>")
					M.drop_item()
					M.take_brain_damage(3)
	may_react_to()
		return "The pathogen appears to have a gland that may affect neural functions."

datum/pathogeneffects/malevolent/beesneeze
	name = "Projectile Bee Egg Sneezing"
	desc = "The infected sneezes bee eggs frequently."
	rarity = THREAT_TYPE3
	proc/sneeze(var/mob/M, var/datum/pathogen/origin)
		if (!M || !origin)
			return
		var/turf/T = get_turf(M)
		var/flyroll = rand(10)
		var/turf/target = locate(M.x,M.y,M.z)
		var/chosen_phrase = pick("<B><span class='alert'>W</span><span class='notice'>H</span>A<span class='alert'>T</span><span class='notice'>.</span></B>","<span class='alert'><B>What the [pick("hell","fuck","christ","shit")]?!</B></span>","<span class='alert'><B>Uhhhh. Uhhhhhhhhhhhhhhhhhhhh.</B></span>","<span class='alert'><B>Oh [pick("no","dear","god","dear god","sweet merciful [pick("neptune","poseidon")]")]!</B></span>")
		switch (M.dir)
			if (NORTH)
				target = locate(M.x, M.y+flyroll, M.z)
			if (SOUTH)
				target = locate(M.x, M.y-flyroll, M.z)
			if (EAST)
				target = locate(M.x+flyroll, M.y, M.z)
			if (WEST)
				target = locate(M.x-flyroll, M.y, M.z)
		var/obj/item/reagent_containers/food/snacks/ingredient/egg/bee/toThrow = new /obj/item/reagent_containers/food/snacks/ingredient/egg/bee(T)
		M.visible_message("<span class='alert'>[M] sneezes out a space bee egg!</span> [chosen_phrase]", "<span class='alert'>You sneeze out a bee egg!</span> [chosen_phrase]", "<span class='alert'>You hear someone sneezing.</span>")
		toThrow.throw_at(target, 6, 1)
		src.infect_cloud(M, origin, origin.spread) // TODO: at some point I want the bees to spread this instead

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1)
				if (prob(4))
					sneeze(M, origin)
			if (2)
				if (prob(6))
					sneeze(M, origin)
			if (3)
				if (prob(8))
					sneeze(M, origin)
			if (4)
				if (prob(10))
					sneeze(M, origin)
			if (5)
				if (prob(12))
					sneeze(M, origin)

	may_react_to()
		return "The pathogen appears to generate a high amount of fluids. Honey, to be more specific."

	react_to(var/R, var/zoom)
		if (R == "pepper")
			return "The pathogen violently discharges honey when coming in contact with pepper."

datum/pathogeneffects/malevolent/mutation
	name = "Random Mutations"
	desc = "The infected individual occasionally mutates wildly!"
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5

	//multiply origin.stage by this number to get the percent probability of a mutation occurring per mob_act
	//please keep it between 1 and 20, inclusive, if possible.
	var/mut_prob_mult = 4

	//this sets the kind of mutations we can pick from: "good" for good mutations, "bad" for bad mutations, "either" for both
	var/mutation_type = "either"

	//set this to 1 to pick mutations weighted by their rarities, set it to 0 to pick with equal weighting
	var/respect_probability = 1

	//probability in percent form (1-100) of a chromosome being applied to a mutation
	var/chrom_prob = 50

	//list of valid chromosome types to pick from. In this case, all extant ones except the weakener
	var/list/chrom_types = list(/datum/dna_chromosome, /datum/dna_chromosome/anti_mutadone, /datum/dna_chromosome/stealth, /datum/dna_chromosome/power_enhancer, /datum/dna_chromosome/cooldown_reducer, /datum/dna_chromosome/safety)

	proc/mutate(var/mob/M, var/datum/pathogen/origin)
		if (M.bioHolder)
			if(prob(chrom_prob))
				var/type_to_make = pick(chrom_types)
				var/datum/dna_chromosome/C = new type_to_make()
				M.bioHolder.RandomEffect(mutation_type, respect_probability, C)
			else
				M.bioHolder.RandomEffect(mutation_type, respect_probability)

	mob_act(var/mob/M, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(origin.stage * mut_prob_mult))
			mutate(M, origin)

	may_react_to()
		return "The pathogen appears to be shifting and distorting its genetic structure rapidly."

	react_to(var/R, var/zoom)
		if (R == "mutadone")
			if (zoom)
				return "Approximately 82.7% of the individual microbodies appear to have returned to genetic normalcy."
			else
				return "The pathogen appears to have settled down significantly in the presence of the mutadone."

datum/pathogeneffects/malevolent/mutation/reinforced
	name = "Random Reinforced Mutations"
	desc = "The infected individual occasionally mutates wildly and permanently!"
	mut_prob_mult = 3
	chrom_prob = 100 //guaranteed chromosome application
	chrom_types = list(/datum/dna_chromosome/anti_mutadone) //reinforcer chromosome

	react_to(var/R, var/zoom)
		if (R == "mutadone")
			if (zoom)
				return "Approximately 0.00% of the individual microbodies appear to have returned to genetic normalcy."
			else
				return "The pathogen seems to have developed a resistance to the mutadone."

//Technically, this SHOULD be under datum/pathogeneffects/benevolent, but doing it this way avoids duplicating code.
//Plus, it's not exactly unprecedented for a malevolent effect to actually be beneficial.
//Just look at the sunglass gland symptom
datum/pathogeneffects/malevolent/mutation/beneficial
	name = "Random Good and Stable Mutations"
	desc = "The infected individual occasionally mutates wildly and beneficially!"
	mut_prob_mult = 3
	mutation_type = "good"
	chrom_prob = 100 //guranteed chromosome application
	chrom_types = list(/datum/dna_chromosome) //stabilizer, no instability caused
	//beneficial = 1

	react_to(var/R, var/zoom)
		if (R == "mutadone")
			if (zoom)
				return "Approximately 99.82% of the individual microbodies appear to have returned to genetic normalcy. Approximately 100.00% of the individual microbodies appear disappointed about that."
			else
				return "The pathogen seems to have reluctantly settled down in the presence of the mutadone."

datum/pathogeneffects/malevolent/radiation
	name = "Radioactive Infection"
	desc = "Infection irradiates the host's cells."
	infect_type = INFECT_NONE
	rarity = THREAT_TYPE5

	mob_act(var/mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		switch (origin.stage)
			if (1 to 3)
				if (prob(5 * origin.stage + 3))
					M.changeStatus("radiation", origin.stage)
					boutput(M,"<span class='alert'>You feel sick.</span>")
			if (4)
				if (prob(13))
					M.changeStatus("radiation", 3 SECONDS)
					boutput(M,"<span class='alert'>You feel very sick!</span>")
				else if (prob(26))
					M.changeStatus("radiation", 2 SECONDS)
					boutput(M,"<span class='alert'>You feel sick.</span>")
			if (5)
				if (prob(15))
					M.changeStatus("radiation", rand(2,4) SECONDS)
					boutput(M,"<span class='alert'>You feel extremely sick!!</span>")
				else if (prob(20))
					M.changeStatus("radiation", 3 SECONDS)
					boutput(M,"<span class='alert'>You feel very sick!</span>")
				else if (prob(40))
					M.changeStatus("radiation", 2 SECONDS)
					boutput(M,"<span class='alert'>You feel sick.</span>")


	may_react_to()
		return "A curiously shaped gland on the pathogen is emitting an unearthly blue glow." //Cherenkov radiation

	react_to(var/R, var/zoom)
		if (R == "silver")
			return "The silver appears to be moderating the reaction within the pathogen's gland." //neutron capture

datum/pathogeneffects/malevolent/snaps
	name = "Snaps"
	desc = "The infection forces its host's fingers to occasionally snap."
	infect_type = INFECT_AREA
	spread = SPREAD_FACE | SPREAD_HANDS | SPREAD_AIR | SPREAD_BODY
	infect_message = "<span class='alert'>That's a pretty catchy groove...</span>" //you might even say it's infectious
	rarity = THREAT_TYPE3

	proc/snap(var/mob/M, var/datum/pathogen/origin)
		M.emote("snap")
		if(prob(20))  // an infectious sou- wait fuck someone made that joke already 5 lines above
			src.infect_snap(M, origin)

	mob_act(var/mob/M, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob(origin.stage * 2))
			snap(M, origin)

	may_react_to()
		return "The pathogen seems like it might respond to strong sonic impulses."

	react_to(var/R, var/zoom)
		if (R == "sonicpowder")
			if (zoom)
				return "The individual microbodies appear to be forming a very simplistic rhythm with their explosive snaps."
			else
				return "The pathogen appears to be using the powder granules as microscopic musical instruments."

datum/pathogeneffects/malevolent/snaps/jazz
	name = "Jazz Snaps"
	desc = "The infection forces its host's fingers to occasionally snap. Also, it transforms the host into a jazz musician."
	rarity = THREAT_TYPE4

	proc/jazz(var/mob/living/carbon/human/H as mob)
		H.show_message("<span class='notice'>[pick("You feel cooler!", "You feel smooth and laid-back!", "You feel jazzy!", "A sudden soulfulness fills your spirit!")]</span>")
		if (!(H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under/misc/syndicate)))
			var/obj/item/clothing/under/misc/syndicate/T = new /obj/item/clothing/under/misc/syndicate(H)
			T.name = "Jazzy Turtleneck"
			if (H.w_uniform)
				var/obj/item/I = H.w_uniform
				H.u_equip(I)
				I.set_loc(H.loc)
			H.equip_if_possible(T, H.slot_w_uniform)
		if (!(H.head && istype(H.head, /obj/item/clothing/head/flatcap)))
			var/obj/item/clothing/head/flatcap/F = new /obj/item/clothing/head/flatcap(H)
			if (H.head)
				var/obj/item/I = H.head
				H.u_equip(I)
				I.set_loc(H.loc)
			H.equip_if_possible(F, H.slot_head)

		if (!H.find_type_in_hand(/obj/item/instrument/saxophone))
			var/obj/item/instrument/saxophone/D = new /obj/item/instrument/saxophone(H)
			if(!(H.put_in_hand(D) == 1))
				var/drophand = (H.hand == 0 ? H.slot_r_hand : H.slot_l_hand) //basically works like a derringer
				H.drop_item()
				D.set_loc(H)
				H.equip_if_possible(D, drophand)
		H.set_clothing_icon_dirty()

	snap(var/mob/M, var/datum/pathogen/origin)
		..()
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.find_type_in_hand(/obj/item/instrument/saxophone))
				var/obj/item/instrument/saxophone/sax = H.find_type_in_hand(/obj/item/instrument/saxophone)
				sax.play_note(rand(1,sax.sounds_instrument.len), user = H)


	mob_act(var/mob/M, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if(prob(origin.stage*5))
			switch(origin.stage)
				if (1 to 2)
					snap(M, origin)
				if (3 to 5)
					if (prob(origin.stage*3)) // jazz first so we can jam right away
						if (ishuman(M))
							var/mob/living/carbon/human/H = M
							jazz(H)
					snap(M, origin)

	may_react_to()
		return "The pathogen seems like it might respond to strong sonic impulses."

	react_to(var/R, var/zoom)
		if (R == "sonicpowder")
			if (zoom)
				return "The individual microbodies appear to be playing smooth jazz."
			else
				return "The pathogen appears to be using the powder granules to make microscopic... saxophones???"

datum/pathogeneffects/malevolent/snaps/wild
	name = "Wild Snaps"
	desc = "The infection forces its host's fingers to constantly and painfully snap. Highly contagious."
	rarity = THREAT_TYPE5


	proc/snap_arm(var/mob/M, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M

			var/list/possible_limbs = list()

			if (H.limbs.l_arm)
				possible_limbs += H.limbs.l_arm
			if (H.limbs.r_arm)
				possible_limbs += H.limbs.r_arm

			if (possible_limbs.len)
				var/obj/item/parts/P = pick(possible_limbs)
				H.visible_message("<span class='alert'>[H.name] violently swings [his_or_her(H)] [initial(P.name)] to provide the necessary energy for producing a thunderously loud finger snap!</span>", "<span class='alert'>You violently swing your [initial(P.name)] to provide the necessary energy for producing a thunderously loud finger snap!</span>")
				playsound(H.loc, H.sound_snap, 200, 1, 5910) //5910 is approximately the same extra range from which you could hear a max-power artifact bomb
				playsound(H.loc, "explosion", 200, 1, 5910)
				P.sever()
				random_brute_damage(H, 40) //makes it equivalent to damage from 2 excessive fingersnap triggers

	snap(var/mob/M, var/datum/pathogen/origin)
		if(prob((origin.stage-3)*3))
			snap_arm(M, origin)
			src.infect_snap(M, origin, 9)
			return
		else
			// no fuck this we are not snapping 25 times, it kills people's byond and eardrums
			// TODO: make cool echo snap sound?
			M.emote("snap")
			playsound(M.loc, 'sound/effects/fingersnap_echo.ogg', 150, 1, 2000)
			src.infect_snap(M, origin, 9)

	mob_act(var/mob/M, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		if (prob((origin.stage * origin.stage)+5))
			snap(M, origin)

	may_react_to()
		return "The pathogen seems like it might respond to strong sonic impulses."

	react_to(var/R, var/zoom)
		if (R == "sonicpowder")
			if (zoom)
				return "The individual microbodies appear to be playing some form of freeform jazz. They are clearly off-key."
			else
				return "The pathogen appears to be using the powder granules to make microscopic... saxophones???"


datum/pathogeneffects/malevolent/detonation
	name = "Necrotic Detonation"
	desc = "The pathogen will cause you to violently explode upon death."
	rarity = THREAT_TYPE5

	may_react_to()
		return "Some of the pathogen's dead cells seem to remain active."

	ondeath(mob/M as mob, var/datum/pathogen/origin)
		if (origin.in_remission)
			return
		explosion_new(M, get_turf(M), origin.stage*5, origin.stage/2.5)

	react_to(var/R, var/zoom)
		if (R == "synthflesh")
			return "There are stray synthflesh pieces all over the dish."
*/
