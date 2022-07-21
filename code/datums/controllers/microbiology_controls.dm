var/datum/microbiology_controller/microbio_controls

/datum/microbiology_controller

	// Don't add ling blood until ling code is redone. No point in accepting an incomplete interaction.
	var/list/pathogen_affected_reagents = list("blood", "pathogen")

	/// Increments on every generated microbe.
	var/next_uid = 1

	/**
	 * The controller holds a list of all created microbe datums.
	 * This centralized list is used for logging and pushing updates.
	 * Equivalent in function to the upstream of a GitHub repo. By design, this list is ALWAYS up to date.
	 * Associative list: key = microbe uid, data = microbe datum
	 */
	var/list/datum/microbe/cultures = list()

	//Normally static after New unless admins try to hotcode something in.
	var/list/datum/microbioeffects/effects = list()

	//Normally static after New unless admins try to hotcode something in.
	var/list/datum/suppressant/cures = list()

	//Preloaded list of chems used to screen for valid chems when building cultures.
	var/list/datum/reagent/effectreagents = list()

	New()	//Initialize effect and cure paths.
		..()
		for (var/X as anything in concrete_typesof(/datum/microbioeffects))
			var/datum/microbioeffects/E = new X
			src.effects += E
			src.effectreagents += E.associated_reagent

		for (var/X as anything in concrete_typesof(/datum/suppressant))
			var/datum/suppressant/C = new X
			src.cures += C

/*
I have no idea what the formal OOP design name would be for the following procs.
Basically, this controller acts as the databank for all microbes.
External code uses the procs to add or modify indexed microbe data.
The controller intrinsically updates active (infected) instances on any modification.

Benefits:
Unaffected by future additions/deletions of datum/microbe vars (except for uid)
Unifies admin logging with current game information
Reduces memory redundancies: Reagents only need to have the uid numbers to know which cultures are present.

Shortcomings:
Limited optimization (can't just change the one var across different instances)
For loop redundancy (cultures list doubles as the admin tool/log, so can't just qdel to save time/space)
Potentially stack-space intensive

*/

	/// Called when microbe data is needed. Argument is a microbe uid. Scans the cultures list and returns the microbe data.
	proc/pull_from_upstream(var/inputuid)
		for (var/uid as anything in microbio_controls.cultures)
			if (uid == inputuid)
				return microbio_controls.cultures[uid]

	/**
	 * Called on successful infections and immunizations.
	 * Runs a for loop pushing the update to all relevant (infected) players.
	 */
	proc/push_to_upstream(var/datum/microbe/P)
		if (!P)
			return
		cultures[P.uid] = P
		for (var/mob/living/carbon/human/H as anything in P.infected)
			push_to_players(H, P)

	///Pushes microbe data to players.
	proc/push_to_players(var/mob/living/carbon/human/H, var/datum/microbe/P)
		if (!H.microbes.len)	//If the listed mob does not have any microbes return early
			return
		for (var/uid as anything in H.microbes)
			if (P.uid == uid)
				H.microbes[uid].master = P

	///Adds a microbe datum to the cultures list.
	proc/add_to_cultures(var/datum/microbe/P)
		if (!P)
			logTheThing("debug", null, null, "<b>pathology:</b> Attempted to add null microbe to cultures")
			return
		microbio_controls.cultures[P.uid] = P

////////////////////////////////////////////////

	//Associative list: ckey is key, data is tab
	var/list/cdc_state = list()

	/// Associative list: key is ckey, data is /datum/microbe
	var/list/datum/microbe/cdc_creator = list()

	//Defines href action states
	var/static/list/states = list("strains", "symptoms", "suppressants", "pathogen creator")

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

		//Local client Tabs
		var/state = 1
		if (usr.ckey in cdc_state)
			state = cdc_state[usr.ckey]
		else
			src.cdc_state += usr.ckey
			src.cdc_state[usr.ckey] = 1

		//Setup the table
		var/stylesheet = {"<style>
.pathology-table { width: 100%; text-align: left; border-spacing: 0; border-collapse: collapse; }
.pathology-table thead th { background-color: #000066; color: white; font-weight: bold; border: none; }
.pathology-table td { border: none; border-bottom: 1px solid black; }
.pathology-table .small { font-size: 0.75em; }
.pathology-table .name { font-weight: bold; }
		</style>"}


		var/output = "<html><title>Center for Disease Control</title><head>[stylesheet]</head><body><h2>Center for Disease Control</h2>"

		//Building tabs
		for (var/i in 1 to src.states.len)
			if (i != 1)
				output += " - "
			if (state != i)
				output += "<a href='?src=\ref[src];action=setstate;state=[i];topic_holder=\ref[topic_holder]'>[states[i]]</a>"
			else
				output += "<span style='color:#dd0000; font-weight:bold'>[states[i]]</span>"
		output += "<br>"

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
					output += "<td><center>[round(CDC.creation_time / (1 MINUTE))]:[((CDC.creation_time % (1 MINUTE)) < (10 SECONDS)) ? 0 : null][(CDC.creation_time % (1 MINUTE))*0.1]</center></td>"
					output += "<td class='name'><center>[CDC.name]</center></td>"
					output += "<td><center>[CDC.uid]</center></td>"

					// Add an action to go to the playerpanel
					// Playerpanel: integrate (cure/show data)
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
					output += "<td><center>[round(CDC.durationtotal / (1 MINUTE))]:[((CDC.durationtotal % (1 MINUTE)) < (10 SECONDS)) ? 0 : null][(CDC.durationtotal % (1 MINUTE))*0.1]</center></td>"

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
				// Name - Catagory - Description - Precursor Reagents
				output += "<table class='pathology-table'><thead><tr><th>Name</th><th>Description</th><th>Precursor Reagents</th></thead><tbody>"
				for (var/datum/microbioeffects/EF as anything in src.effects)
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

					output += "<td>[EF.associated_reagent]</td>"

					output += "</tr>"

			//List of cures
			if ("suppressants")

				//Name - Color - Description - Cure Type - Exact Cure - Cure Reagents
				output += "<table class='pathology-table'><thead><tr><th>Name</th><th>Color</th><th>Description</th><th>Cure Type</th><th>Exact Cure</th><<th>Suppression reagents</th></thead><tbody>"
				for (var/var/datum/suppressant/S as anything in src.cures)

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

					//Reagent Cures
					if (!(S.cure_synthesis.len))
						output += "<td> - </td>"
					else
						output += "<td>"
						for (var/R as anything in S.cure_synthesis)
							output += "[R], "
						output += "</td>"

					output += "</tr>"


			if ("pathogen creator")
				//give a blank datum or return to an autosave
				if (!(usr.ckey in src.cdc_creator))
					var/datum/microbe/P = new /datum/microbe
					src.cdc_creator[usr.ckey] = P

				var/datum/microbe/P = src.cdc_creator[usr.ckey]

				output += "<h3>Microbe Creator</h3><br>"

				// Time Created - Name - UID - Players Infected - Players Immune/Cured
				// Actions: (Cure One) (Cure All) (Infect) (Spawn Vial) (Logs)

				// UID
				output += "<b>UID: </b>[P.uid]<br><br>"

				// Name
				output += "<b>Name: </b><a href='?src=\ref[src];action=pathogen_creator;do=rename;topic_holder=\ref[topic_holder]'>[P.name]</a><br>"
				output += "<a href='?src=\ref[src];action=pathogen_creator;do=randomname;topic_holder=\ref[topic_holder]'>(Random Name)</a><br><br>"

				// Description
				if (P.suppressant)
					output += "<b>Description: </b> <a href='?src=\ref[src];action=pathogen_creator;do=desc;topic_holder=\ref[topic_holder]'>[P.desc]</a><br><br>"

				//add, remove effects
				output += "<b>Effects: </b><br>"
				if (P.effects.len)
					for (var/datum/microbioeffects/EF as anything in P.effects)
						output += "- [EF] <a href='?src=\ref[src];action=pathogen_creator;do=remove;which=\ref[EF];topic_holder=\ref[topic_holder]'>(remove)</a><br>"
				else
					output += " -- None -- <br>"
				if (P.effects.len < 3)
					output += "<a href='?src=\ref[src];action=pathogen_creator;do=add;topic_holder=\ref[topic_holder]'>Add effect</a><br><br>"

				//add, change suppressant
				if (P.suppressant)
					output += "<b>Suppressant: </b>[P.suppressant]<br>"
				output += "<a href='?src=\ref[src];action=pathogen_creator;do=suppressant;topic_holder=\ref[topic_holder]'>Assign suppressant</a><br><br>"

				//adjust infection total
				output += "<b>Infection Total:</b> <a href='?src=\ref[src];action=pathogen_creator;do=infectiontotal;topic_holder=\ref[topic_holder]'>[P.infectiontotal]</a><br>"


				//adjust duration total
				output += "<b>Duration Total:</b> <a href='?src=\ref[src];action=pathogen_creator;do=durationtotal;topic_holder=\ref[topic_holder]'>[P.durationtotal]</a><br>"

				//set artificial boolean
				output += "<b>Artificial?</b> <a href='?src=\ref[src];action=pathogen_creator;do=artificial;topic_holder=\ref[topic_holder]'>[P.artificial ? "Yes" : "No"]</a><br>"

				//set reported boolean
				output += "<b>Reported?</b> <a href='?src=\ref[src];action=pathogen_creator;do=reported;topic_holder=\ref[topic_holder]'>[P.reported ? "Yes" : "No"]</a><br>"

				//Button to finalize
				if (P.effects.len && P.suppressant && P.infectiontotal && P.durationtotal)
					output += "<a href='?src=\ref[src];action=pathogen_creator;do=create;topic_holder=\ref[topic_holder]'>Create</a><br><br>"

				//Button to reset
				output += "<a href='?src=\ref[src];action=pathogen_creator;do=reset;topic_holder=\ref[topic_holder]'>Reset</a>"

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

			// Tabs
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

				for (var/mob/living/carbon/human/H as anything in CDC.infected)
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

			if ("pathogen_creator")
				var/datum/microbe/P = src.cdc_creator[usr.ckey]
				switch (href_list["do"])
					if ("reset")
						P.clear()

					if ("rename")
						var/name2sanitize = input("New Name: ", "Rename") as null|text
						if (!isnull(name2sanitize))
							P.name = name2sanitize

					if ("randomname")
						P.generate_name()

					if ("desc")
						var/desc2sanitize = input("New Description: ", "Description") as null|text
						if (!isnull(desc2sanitize))
							P.desc = desc2sanitize

					if ("suppressant")
						var/list/types = list()
						for (var/datum/suppressant/S as anything in src.cures)
							types[S.name] = S
						var/chosen = input("Which suppressant?", "Suppressant", types[1]) in types
						P.suppressant = types[chosen]
						P.desc = "[P.suppressant.color] hyperfractal microbes"

					if ("add")
						var/list/types = list()
						for (var/datum/microbioeffects/EF as anything in src.effects)
							types[EF.name] = EF
						var/chosen = input("Which symptom?", "Add new symptom", types[1]) in types
						if (!(types[chosen] in P.effects))
							P.effects += types[chosen]

					if ("remove")
						var/datum/microbioeffects/EF = locate(href_list["which"])
						if (EF in P.effects)
							P.effects -= EF

					if ("infectiontotal")
						var/inftot = input("New Infection Total: ", "Infection Total") as null|num
						if (!isnull(inftot))
							P.infectiontotal = inftot

					if ("durationtotal")
						var/durtot = input("New Duration Total in seconds: ", "Duration Total") as null|num
						if (!isnull(durtot))
							P.durationtotal = durtot

					if ("artificial")
						P.artificial = !P.artificial

					if ("reported")
						P.reported = !P.reported

					if ("create")
						if (!(P.uid in src.cultures))
							microbio_controls.add_to_cultures(P)
							message_admins("[key_name(usr)] created a new microbial culture ([P]) via the creator. (uid = [P.uid])")
							P = new /datum/microbe
						else
							alert("Attempted to create a microbial culture with an already existing UID.")


				src.cdc_creator[usr.ckey] = P
		cdc_main(th)
