var/datum/microbiology_controller/microbio_controls
//Does this go here? Should it be in the main microbiology folder?
/datum/microbiology_controller

	// Don't add ling blood until ling code is redone. No point in accepting an incomplete interaction.
	// Besides, the ling test is much more accessible. No one in their right mind would resort to distilled microbes to test!
	var/list/pathogen_affected_reagents = list("blood", "pathogen")

	///Increments on every generated microbe.
	var/next_uid = 1

	/**
	 * Equivalent in function to the upstream of a GitHub repo. By design, this list is ALWAYS up to date.
	 * Associative list: key = microbe uid, data = microbe datum
	 */
	var/list/datum/microbe/cultures = list()

	//Normally static after New unless admins try to hotcode something in.
	var/list/datum/microbioeffects/effects = list()

	//Normally static after New unless admins try to hotcode something in.
	var/list/datum/suppressant/cures = list()

	New()	//Initialize effect and cure paths.
		..()
		for (var/X in concrete_typesof(/datum/microbioeffects))
			var/datum/microbioeffects/E = new X
			effects += E

		for (var/X in concrete_typesof(/datum/suppressant))
			var/datum/suppressant/C = new X
			cures += C

/*
I have no idea what the formal OOP design name would be for the following procs.
Basically, this controller acts as the databank for all microbes.
External code uses the procs to add or modify indexed microbe data.
The controller intrinsically updates active (infected) instance on any modification.

Benefits:
Unaffected by code changes to microbe var definitions (except for uid)
Meta

Shortcomings:
Limited optimization (can't just change the one var)
For loop redundancy (cultures list doubles as the admin tool/log, so can't just qdel to save time)
Possible stack overlap leading to 'merge conflicts'? (idk the exact details of how runtime/stack works for DM)
DOES NOT NEED TO BE Associative list (necessary for indefinite datums)
*/

	///Called when microbe data is needed. Argument is a microbe uid. Scans the cultures list and returns the microbe data.
	proc/pull_from_upstream(var/inputuid)
		for (var/uid in cultures)
			if (uid == inputuid)
				return cultures[uid]

	/**
	 * Called on successful infections and immunizations.
	 * Runs a for loop pushing the update to all relevant (infected) players.
	 */
	proc/push_to_upstream(var/datum/microbe/P)
		if (!P)
			return
		cultures[P.uid] = P
		for (var/mob/living/carbon/human/H in P.infected)
			push_to_players(H,P)

	///Pushes microbe data to players.
	proc/push_to_players(var/mob/living/carbon/human/H, var/datum/microbe/P)
		if (!H.microbes.len)	//If the listed mob does not have any microbes return early
			return
		for (var/uid in H.microbes)
			if (P.uid == uid)
				H.microbes[uid].master = P

	///Adds a microbe datum to the cultures list.
	proc/add_to_cultures(var/datum/microbe/P)
		if (!P)
			logTheThing("debug", null, null, "<b>pathology:</b> Attempted to add null microbe to cultures")
			return
		cultures[P.uid] = P

////////////////////////////////////////////////

	//Dunno
	var/list/cdc_state = list()


	//Defines href action states
	var/static/list/states = list("strains", "symptoms", "suppressants"/*, "pathogen creator"*/)

	proc/cdc_main(var/topic_holder)

		//Client checks
		if (!usr || !usr.client)
			return
		if (!usr.client.holder)
			boutput(usr, "<span class='alert'>Visitors of the CDC are not allowed to interact with the equipment!</span>")
			return
		if (usr.client.holder.level < LEVEL_SA)
			boutput(usr, "<span class='alert'>I'm sorry, you require a security clearance of Primary Researcher to go in there. Protocol and all. You know.</span>")
			return

		//Ckey shenanigans for logging I think?
		//Why is this an associative list?
		var/state = 1
		if (usr.ckey in cdc_state)
			state = cdc_state[usr.ckey]
		else
			cdc_state += usr.ckey
			cdc_state[usr.ckey] = 1

		//Setup the table
		var/stylesheet = {"<style>
.pathology-table { width: 100%; text-align: left; border-spacing: 0; border-collapse: collapse; }
.pathology-table thead th { background-color: #000066; color: white; font-weight: bold; border: none; }
.pathology-table td { border: none; border-bottom: 1px solid black; }
.pathology-table .small { font-size: 0.75em; }
.pathology-table .name { font-weight: bold; }
		</style>"}


		var/output = "<html><title>Center for Disease Control</title><head>[stylesheet]</head><body><h2>Center for Disease Control</h2>"

		//State Control
		for (var/i in 1 to src.states.len)
			if (i != 1)
				output += " - "
			if (state != i)
				output += "<a href='?src=\ref[src];action=setstate;state=[i];topic_holder=\ref[topic_holder]'>[states[i]]</a>"
			else
				output += "<span style='color:#dd0000; font-weight:bold'>[states[i]]</span>"
		output += "<br>"

		//SWEET MERCIFUL CRAP
		switch (states[state])
			//General Overview
			if ("strains")
				// Time Created - Name - UID - Players Infected - Players Immune/Cured - Remaining Infection Potential -
				// Total Duration - Cure - Effects
				// Actions: (Cure One) (Cure All) (Infect) (Spawn Vial) (Logs)
				output += "<table class='pathology-table'><thead><tr><th>Created</th><th>Name</th><th>UID</th><th>Infected</th><th>Immune</th><th>Infections: Rem/Total</th><th>Total Duration</th><th>Cure</th><th>Effects</th><th>Logs</th><th>Actions</th></thead><tbody>"
				for (var/uid as anything in src.cultures)
					var/datum/microbe/CDC = src.cultures[uid]
					output += "<tr>"

					output += "<td><center>[round(CDC.creation_time / 60)]:[((CDC.creation_time % 60) < 10) ? 0 : null][(CDC.creation_time % 60)]</center></td>"
					output += "<td class='name'><center>[CDC.name]</center></td>"
					output += "<td><center>[CDC.uid]</center></td>"

					//Infected
					if (CDC.infected)
						output += "<td><center>"
						for (var/poor_sod as anything in CDC.infected)
							output += "[poor_sod], "
						output += "</center></td>"
					else
						output += "<td><center>N/A</center></td>"

					//Immune
					if (CDC.immune)
						output += "<td>"
						for (var/cured as anything in CDC.immune)
							output += "[cured], "
						output += "</td>"
					else
						output += "<td><center>N/A</center></td>"

					//Remaining / Total
					output += "<td><center>[CDC.infectioncount] / [CDC.infectiontotal]</center></td>"

					//Duration
					output += "<td><center>[round(CDC.durationtotal / 60)]:[((CDC.durationtotal % 60) < 10) ? 0 : null][CDC.durationtotal % 60]</center></td>"

					//Cure
					output += "<td><center>[CDC.suppressant]</center></td>"

					//Effects
					output += "<td><center>"
					for (var/effectindex as anything in CDC.effects)
						//Duped, possibly crunchable
						//Color-coded naming: RED = malevolent, BLUE = neutral, GREEN = benevolent
						if (istype(effectindex, /datum/microbioeffects/benevolent))
							output += "<span style='color: rgb(0, [200], 0)'>[effectindex], </span>"
						else if (istype(effectindex, /datum/microbioeffects/neutral))
							output += "<span style='color: rgb(0, 0, [200])'>[effectindex], </span>"
						else if (istype(effectindex, /datum/microbioeffects/malevolent))
							output += "<span style='color: rgb([200], 0, 0)'>[effectindex], </span>"
						else
							output += "[effectindex], "

					output += "</center></td>"
					//Logs
					output += "<td><center><a href='?src=\ref[topic_holder];action=view_logs_pathology_strain;presearch=[CDC.name]'>(LOGS)</a></center></td>"

					//Actions
					output += "<td><center>"
					output += "<a href='?src=\ref[src];action=cure_one;strain=[uid];topic_holder=\ref[topic_holder]'>(CURE ONE) </a>"
					output += "<a href='?src=\ref[src];action=cure_all;strain=[uid];topic_holder=\ref[topic_holder]'>(CURE ALL) </a>"
					output += "<a href='?src=\ref[src];action=infect;strain=[uid];topic_holder=\ref[topic_holder]'>(INFECT) </a>"
					output += "<a href='?src=\ref[src];action=spawnvial;strain=[uid];topic_holder=\ref[topic_holder]'>(SPAWN VIAL)</a>"
					output += "</td></center>"

					output += "</tr>"
				output += "</tbody></table>"

			//List of effects
			if ("symptoms")
				// Name - Catagory - Description - Act. Reagents
				output += "<table class='pathology-table'><thead><tr><th>Name</th><th>Description</th><th>Activator Reagents</th></thead><tbody>"
				for (var/effectindex as anything in src.effects)
					var/datum/microbioeffects/EF = effectindex
					output += "<tr>"

					//Color-coded naming: RED = malevolent, BLUE = neutral, GREEN = benevolent
					if (istype(EF, /datum/microbioeffects/benevolent))
						output += "<td><span style='color: rgb(0, [200], 0)'>[EF.name]</span></td>"
					else if (istype(EF, /datum/microbioeffects/neutral))
						output += "<td><span style='color: rgb(0, 0, [200])'>[EF.name]</span></td>"
					else if (istype(EF, /datum/microbioeffects/malevolent))
						output += "<td><span style='color: rgb([200], 0, 0)'>[EF.name]</span></td>"
					else
						output += "<td>[EF.name]</td>"

					//Description
					output += "<td>[EF.desc]</td>"

					output += "<td>"
					for (var/reagent as anything in EF.reactionlist)
						output += "[reagent], "
					output += "</td>"

					output += "</tr>"

			//List of cures
			if ("suppressants")

				//Name - Color - Description - Cure Type - Exact Cure - Reaction Reagents - Cure Reagents (if applicable)
				output += "<table class='pathology-table'><thead><tr><th>Name</th><th>Color</th><th>Description</th><th>Cure Type</th><th>Exact Cure</th><th>Activator reagents</th><<th>Suppression reagents</th></thead><tbody>"
				for (var/cureindex as anything in src.cures)
					var/datum/suppressant/S = cureindex

					output += "<tr>"

					//Name
					output += "<td>[S.name]</td>"

					//Color
					output += "<td>[S.color]</td>"

					//Desc
					output += "<td>[S.desc]</td>"

					//Cure
					output += "<td>[S.therapy]</td>"

					//Exact Cure
					output += "<td>[S.exactcure]</td>"

					//Activator Reagents
					output += "<td>"
					for (var/R as anything in S.reactionlist)
						output += "[R], "
					output += "</td>"

					//Reagent Cures
					if (!(S.cure_synthesis.len))
						output += "<td> - </td>"
					else
						output += "<td>"
						for (var/R as anything in S.cure_synthesis)
							output += "[R], "
						output += "</td>"

					output += "</tr>"

//This waits until the core structure is OK
	/*
			if ("pathogen creator")

				//give a blank datum
				var/datum/microbe/P = new /datum/microbe

				output += "<h3>Microbe Creator</h3>"

				// Time Created - Name - UID - Players Infected - Players Immune/Cured
				// Actions: (Cure One) (Cure All) (Infect) (Spawn Vial) (Logs)

				output += "<b>UID: </b> [P.uid]<br>"

				//rename
				output += "<b>Name: </b> [P.name]<br>"

				//add, remove effects

				//add, change suppressant

				//adjust infection total

				//adjust duration total

				//set artificial boolean

				//set reported boolean

				//Button to finalize

				//Button to completely reset ?


				if (P.suppressant)
					output += "<b>Description: </b> [P.desc]<br>"

				if (!P.body_type)
					output += "<a href='?src=\ref[src];action=pathogen_creator;do=body_type;topic_holder=\ref[topic_holder]'>Assign microbody</a><br>"
				else
					output += "<b>Microbody:</b> [P.body_type]<br>"
					output += "<b>Stages:</b> <a href='?src=\ref[src];action=pathogen_creator;do=stages;topic_holder=\ref[topic_holder]'>[P.stages]</a><br>"
					output += "<b>Advance speed:</b> <a href='?src=\ref[src];action=pathogen_creator;do=advance_speed;topic_holder=\ref[topic_holder]'>[P.advance_speed]</a><br>"
					output += "<b>Symptomatic:</b> <a href='?src=\ref[src];action=pathogen_creator;do=symptomatic;topic_holder=\ref[topic_holder]'>[P.symptomatic ? "Yes" : "No"]</a><br>"
					output += "<b>Suppression threshold:</b> <a href='?src=\ref[src];action=pathogen_creator;do=suppression_threshold;topic_holder=\ref[topic_holder]'>[P.suppression_threshold]</a><br>"
					output += "<b>Spread:</b> <a href='?src=\ref[src];action=pathogen_creator;do=spread;topic_holder=\ref[topic_holder]'>[P.spread]</a><br>"
					if (!P.suppressant)
						output += "<a href='?src=\ref[src];action=pathogen_creator;do=suppressant;topic_holder=\ref[topic_holder]'>Assign suppressant</a><br>"
					else
						output += "<b>Suppressant: </b>[P.suppressant]<br><br>"
						output += "<b>Effects: </b><br>"
						if (P.effects.len)
							for (var/datum/pathogeneffects/EF in P.effects)
								output += "- [EF] <a href='?src=\ref[src];action=pathogen_creator;do=remove;which=\ref[EF];topic_holder=\ref[topic_holder]'>(remove)</a><br>"
						else
							output += " -- None -- <br>"
						output += "<a href='?src=\ref[src];action=pathogen_creator;do=add;topic_holder=\ref[topic_holder]'>Add effect</a><br><br>"
				output += "<a href='?src=\ref[src];action=pathogen_creator;do=reset;topic_holder=\ref[topic_holder]'>Reset pathogen</a>"
				if (P.body_type && P.suppressant && length(P.effects))
					output += " -- <a href='?src=\ref[src];action=pathogen_creator;do=create;topic_holder=\ref[topic_holder]'>Create pathogen</a>"
	*/
			else
				output += "<h1>NOTHING TO SEE HERE YET</h1>"
		output += "</body></html>"
		usr.Browse(output, "window=cdc;size=1600x900")

///////// HTML Backend
	Topic(href, href_list)
		USR_ADMIN_ONLY
		var/key = usr.ckey
		var/th = locate(href_list["topic_holder"])

		switch(href_list["action"])

			// Uhh...
			if ("setstate")
				cdc_state[key] = text2num_safe(href_list["state"])

			// Cure all
			if ("cure_one")
				var/datum/microbe/CDC = pull_from_upstream(href_list["strain"])

				if (isnull(CDC))
					boutput(usr, "<span class='alert'>ERROR: href sent a null uid to Topic.</span>")
					return

				else if (!(CDC.infected))
					boutput(usr, "<span class='alert'>This culture has no hosts to cure.</span>")

				else
					var/mob/living/carbon/human/target = input("Who would you like to cure?", "Cure") as anything in CDC.infected
					//target nulls if no one to cure
					if (isnull(target))
						boutput(usr, "<span class='alert'>No mobs infected with [CDC.name].</span>")
						return

					target.cured(target.microbes[CDC.uid])

					message_admins("[key_name(usr)] cured [target] from strain [CDC.name] (uid: [CDC.uid]).")

			if ("cure_all")
				var/datum/microbe/CDC = pull_from_upstream(href_list["strain"])

				for (var/mob/living/carbon/human/H in CDC.infected)
					LAGCHECK(LAG_LOW)
					if (CDC.uid in H.microbes)
						H.cured(H.microbes[CDC.uid])

				message_admins("[key_name(usr)] cured all possible humans from strain [CDC.name] (uid: [CDC.uid]).")

			if ("infect")
				var/datum/microbe/CDC = pull_from_upstream(href_list["strain"])

				var/mob/living/carbon/human/target = input("Who would you like to infect with this mutation?", "Infect") as mob in mobs//world

				if (!istype(target))
					boutput(usr, "<span class='alert'>Cannot infect that. Must be human.</span>")
				else if (target in CDC.infected)
					boutput(usr, "<span class='alert'>Player is already infected with [CDC.name].</span>")
				else if (target in CDC.immune)
					boutput(usr, "<span class='alert'>[target] already has immunity to [CDC.name].</span>")
				else if (target.totalimmunity)
					boutput(usr, "<span class='alert'>[target] has total immunity to all microbes.</span>")
				else if (target.infected(CDC))
					message_admins("[key_name(usr)] infected [target] with [CDC.name].")

			if ("spawnvial")
				var/uid = href_list["strain"]

				var/obj/item/reagent_containers/glass/vial/V = new /obj/item/reagent_containers/glass/vial(get_turf(usr))
				var/datum/reagent/blood/pathogen/RE = new /datum/reagent/blood/pathogen
				RE.volume = 5
				RE.microbes += uid
				RE.holder = V.reagents
				V.reagents.reagent_list += RE.id
				V.reagents.reagent_list[RE.id] = RE
				V.reagents.update_total()

/*
			if ("pathogen_creator")
				var/datum/pathogen/P = src.cdc_creator[usr.ckey]
				switch (href_list["do"])
					if ("reset")
						//P.clear()
						src.gen_empty(usr.ckey)

					if ("suppressant")
						var/list/types = list()
						for (var/spath in src.path_to_suppressant)
							var/datum/suppressant/S = src.path_to_suppressant[spath]
							types += S.name
							types[S.name] = S
						var/chosen = input("Which suppressant?", "Suppressant", types[1]) in types
						P.suppressant = types[chosen]
						P.desc = "[P.suppressant.color] dodecahedrical [P.body_type.plural]"

					if ("add")
						var/list/types = list()
						for (var/efpath in src.path_to_symptom)
							var/datum/pathogeneffects/EF = src.path_to_symptom[efpath]
							types += EF.name
							types[EF.name] = EF
						var/chosen = input("Which symptom?", "Add new symptom", types[1]) in types
						if (!(types[chosen] in P.effects))
							P.effects += types[chosen]
							var/datum/pathogeneffects/EF = types[chosen]
							EF.onadd(P)

					if ("remove")
						var/datum/pathogeneffects/EF = locate(href_list["which"])
						if (EF in P.effects)
							P.effects -= EF

					if ("create")
						P.dnasample = new/datum/pathogendna(P)
						P.pathogen_uid = "p[next_uid]"
						next_uid++

						pathogen_trees += P.name_base
						var/datum/pathogen_cdc/CDC = new /datum/pathogen_cdc(P.pathogen_uid)
						pathogen_trees[P.name_base] = CDC
						next_mutation[P.pathogen_uid] = P.mutation + 1
						CDC.microbody_type = "[P.body_type]"
						CDC.mutations += P.name
						CDC.mutations[P.name] = P

						message_admins("[key_name(usr)] created a new pathogen ([P]) via the creator.")
						src.gen_empty(usr.ckey)
*/
		cdc_main(th)
