/obj/machinery/centrifuge
	name = "Centrifuge"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "centrifuge0"
	desc = "A large machine that can be used to separate a pathogen sample from a blood sample."
	anchored = 1
	density = 1
	flags = NOSPLASH

	var/obj/item/bloodslide/sample = null
	var/obj/item/reagent_containers/glass/petridish/dish = null
	var/datum/microbe/isolated = null

	var/active = FALSE
	var/counter = 8

/obj/machinery/centrifuge/ui_interact(mob/user, datum/tgui/ui)
	ui = tgui_process.try_update_ui(user, src, ui)
	//if(!ui)
    	//ui = new(user, src, "Centrifuge")
    	//ui.open()

/obj/machinery/centrifuge/ui_data(mob/user)
	. = list(
		"active" = active,
		"sample" = list(),
		"petridish" = list(),
		"isolated" = isolated,
	)

	//Petri Dish
	if (src.dish.reagents.has_reagent("pathogen"))
		for (var/uid in src.dish.reagents.reagent_list["pathogen"].microbes)
			.["petridish"] += list(list(uid, microbio_controls.pull_from_upstream(uid).name))
	else
		.["petridish"] = null

	//Bloodslide
	if (!(sample.blood))
		.["sample"] = null
		return

	var/datum/reagent/blood/B = src.sample.reagents.reagent_list["blood"]
	if (!B.microbes.len)
		.["sample"] = null
		return

	for (var/uid in B.microbes)
		.["sample"] += list(list(uid, microbio_controls.pull_from_upstream(uid).name))


/obj/machinery/centrifuge/ui_act(action, params)
	. = ..()
	if (.)
		return

	switch (action)

		if ("shutdown")
			src.active = FALSE
			src.icon_state = "centrifuge0"
			src.visible_message("<span class='alert'>The centrifuge grinds to a sudden halt. The blood slide flies off the supports and shatters somewhere inside the machine.</span>", \
			"<span class='alert'>You hear a grinding noise, followed by something shattering.</span>")
			qdel(src.sample)
			src.sample = null
			src.isolated = null
			counter = 8
			processing_items.Remove(src)
			. = TRUE

		if ("ejectsample")
			src.sample.master = null
			src.sample.set_loc(src.loc)
			src.contents -= src.sample
			src.sample.layer = initial(src.sample.layer)
			src.sample = null
			src.isolated = null
			. = TRUE

		if ("ejectdish")
			src.dish.master = null
			src.dish.set_loc(src.loc)
			src.contents -= src.dish
			src.dish.layer = initial(src.dish.layer)
			src.dish = null
			. = TRUE

		if ("isolate")
			src.active = TRUE
			src.icon_state = "centrifuge1"
			processing_items |= src
			. = TRUE
/*
	attackby(var/obj/item/O, var/mob/user)
		//Early returns
		if (istype(O, /obj/item/bloodslide) && src.sample)


		if (istype(O, /obj/item/reagent_containers/glass/petridish) && src.dish)
			boutput(user, "<span class='alert'>There is already a petri dish in the machine.</span>")
			return

		//valid inserts
		if (istype(O, /obj/item/bloodslide))
			if (src.sample)
				boutput(user, "<span class='alert'>There is already a blood slide in the machine.</span>")
				return
			if (!O.blood)
				boutput(user, "<span class='alert'>There is no blood on the bloodslide.</span>")
				return
			if (!O.blood.microbes.len)
				boutput(user, "<span class='alert'>The [O] contains no microbes.</span>")

			src.sample = O
			O.set_loc(src)
			O.master = src
			O.layer = src.layer
			src.contents += O
			if (user.client)
				user.client.screen -= O
			user.u_equip(O)
			boutput(user, "You insert the blood slide into the machine.")

		else if (istype(O, /obj/item/reagent_containers/glass/petridish))
			src.dish = O
			O.set_loc(src)
			O.master = src
			O.layer = src.layer
			src.contents += O
			if (user.client)
				user.client.screen -= O
			user.u_equip(O)
			boutput(user, "You insert the petri dish into the machine.")

	attack_hand(mob/user)
		if ()

		var/output_text = "<B>Centrifuge</B><BR><BR>"

			if (src.source)
				output_text += "The centrifuge currently contains a [src.source]. <a href='?src=\ref[src];ejectsrc=1'>Eject</a><br><br>"
			else
				output_text += "The centrifuge's source slot is empty.<br><br>"
			if (src.source)
				if (istype(src.source, /obj/item/bloodslide))
					if (!src.source.reagents.has_reagent("blood"))
						output_text += "The [src.source] contains no viable sample.<BR><BR>"
					else
						var/datum/reagent/blood/B = src.source.reagents.reagent_list["blood"]
						if (B.volume && B.microbes.len)
							if (B.microbes.len > 1)
								output_text += "The centrifuge is calibrated to isolate a sample of [src.isolated ? src.isolated.name : "all pathogens"].<br><br>"
								output_text += "The blood in the [src.source] contains multiple pathogens. Calibrate to isolate a sample of:<br>"
								output_text += "<a href='?src=\ref[src];all=1'>All</a><BR>"
								for (var/uid in B.microbes)
									var/datum/microbe/P = microbio_controls.pull_from_upstream(uid)
									output_text += "<a href='?src=\ref[src];isolate=\ref[P]'>[P.name]</a><br>"
								output_text += "<BR>"
							else
								for (var/uid in B.microbes)
									var/datum/microbe/P = microbio_controls.pull_from_upstream(uid)
									output_text += "The centrifuge will isolate the single sample of [P.name].<br><br>"
						else
							output_text += "The [src.source] contains no viable sample.<BR><BR>"
			else
				output_text += "There is no isolation source inserted into the centrifuge.<br><br>"
			if (src.target)
				output_text += "There is a petri dish inserted into the machine. <a href='?src=\ref[src];ejectdish=1'>Eject</a><br><br>"
			else
				output_text += "There is no petri dish inserted into the machine.<br><br>"
			output_text += "<a href='?src=\ref[src];begin=1'>Begin isolation process</a>"

		user.Browse("<HEAD><TITLE>Centrifuge</TITLE></HEAD><BODY>[output_text]</BODY>", "window=centrifuge")
		onclose(user, "centrifuge")
		return

	Topic(href, href_list)
		if (..())
			return




		else if (href_list["begin"])
			var/maybegin = 1
			if (!src.on)
				if (!src.source)
					boutput(usr, "<span class='alert'>You cannot begin isolation without a source container.</span>")
					maybegin = 0
				else if (!src.source.reagents.has_reagent("blood"))
					boutput(usr, "<span class='alert'>You cannot begin isolation without a source blood sample.</span>")
					maybegin = 0
				else
					var/datum/reagent/blood/B = src.source.reagents.reagent_list["blood"]
					if (!B.microbes.len)
						boutput(usr, "<span class='alert'>The inserted blood sample is clean, there is nothing to isolate.</span>")
						maybegin = 0
					else if (!src.target)
						boutput(usr, "<span class='alert'>You cannot begin isolation without a target receptacle.</span>")
						maybegin = 0
				if (maybegin)
					src.visible_message("<span class='notice'>The centrifuge powers up and begins the isolation process.</span>", "<span class='notice'>You hear a machine powering up.</span>")
					src.on = 1
					src.icon_state = "centrifuge1"
					var/obj/item/bloodslide/S = src.source
					var/datum/reagent/blood/pathogen/P = new
					var/datum/reagent/blood/B = src.source.reagents.reagent_list["blood"]
					if (src.isolated)
						P.microbes = list(src.isolated)
					else
						P.microbes = B.microbes.Copy()
					P.volume = 5
					processing_items |= src
					src.process_pathogen = P
					src.process_source = S
					counter = 12
		src.Attackhand(usr)

	process()
		if (!src.active)
			return
		counter--
		if (counter <= 0)
			processing_items.Remove(src)
			var/datum/reagent/blood/pathogen/P = src.process_pathogen
			src.visible_message("<span class='notice'>The centrifuge beeps and discards the disfigured bloodslide.</span>", "<span class='notice'>You hear a machine powering down.</span>")
			if (src.target.reagents.has_reagent("pathogen"))
				var/datum/reagent/blood/pathogen/Q = src.target.reagents.reagent_list["pathogen"]
				for (var/uid in P.microbes)
					Q.microbes += uid
			else
				src.target.reagents.reagent_list += "pathogen"
				src.target.reagents.reagent_list["pathogen"] = P
				P.holder = src.target.reagents
				src.target.reagents.update_total()
			src.target.icon_state = "petri1"
			del(src.source)
			src.source = null
			src.isolated = null
			src.on = 0
			src.icon_state = "centrifuge0"
*/
/obj/machinery/microscope
	name = "Microscope"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "microscope0"
	desc = "A device which provides a magnified view of a culture in a petri dish."
	var/obj/item/target = null
	var/zoom = 0
	anchored = 1

	attack_hand(mob/user)
		if (!(src.target))
			boutput(user, "There is nothing loaded under the microscope.")
			return
		var/action = input("What would you like to do with the microscope?", "Microscope", "View [target]") in list("View [target]", "[src.zoom ? "Zoom Out" : "Zoom In"]", "Remove [target]", "Cancel")
		if (BOUNDS_DIST(user.loc, src.loc) == 0)
			if (action == "View [target]")
				if ((!zoom))
					boutput(user, "<span class='alert>You can't see much while the microscope is zoomed out!</span>")
					return
				var/list/microbelist = target.reagents.aggregate_pathogens()
				for (var/uid in microbelist)
					var/datum/microbe/M = microbio_controls.pull_from_upstream(uid)
					user.show_message("You see [M.desc].")
				return
			if (action == "Zoom Out")
				if (!zoom)
					boutput(user,"The microscope is already zoomed out.")
					return
				zoom = 0
				icon_state = target ? "microscope1" : "microscope0"
				user.show_message("The microscope is now zoomed out.")
			if (action == "Zoom In")
				if (zoom)
					boutput(user,"The microscope is already zoomed in.")
					return
				zoom = 1
				icon_state = target ? "microscope3" : "microscope1"
				user.show_message("The microscope is now zoomed in.")
			if (action == "Remove [target]")
				if (zoom)
					boutput(user, "The microscope is still zoomed in. Readjust it before removing the [target].")
					return
				user.show_message("<span class='notice'>You remove the [target] from the microscope.</span>")
				src.target.set_loc(src.loc)
				src.target.master = null
				icon_state = "microscope0"
				src.contents -= src.target
				src.target = null

	attackby(var/obj/item/O, var/mob/user)
		if (istype(O, /obj/item/reagent_containers/glass/petridish) || istype(O, /obj/item/bloodslide))
			if (src.target)
				boutput(user, "<span class='alert'>There is already a [target] on the microscope.</span>")
				return
			src.target = O
			O.set_loc(src)
			O.master = src
			O.layer = src.layer
			src.contents += O
			if (user.client)
				user.client.screen -= O
			user.u_equip(O)
			if (zoom)
				boutput(user, "There isn't enough clearance to insert the [O] while the microscope is zoomed in.")
				return
			src.icon_state = "microscope1"
			boutput(user, "You insert the [O] into the microscope.")

		else if (istype(O, /obj/item/reagent_containers/dropper))
			if (src.target && istype(src.target, /obj/item/reagent_containers/glass/petridish) && O.reagents.total_volume > 0)
				user.visible_message("[user] drips some of the contents of the dropper into the petri dish.", "You drip some of the contents of the dropper into the petri dish.")
				var/list/path_list = src.target.reagents.aggregate_pathogens()
				for (var/rid in O.reagents.reagent_list)
					var/datum/reagent/R = O.reagents.reagent_list[rid]
					if (R.volume < 1)
						continue
					for (var/uid in path_list)
						var/datum/microbe/P = microbio_controls.pull_from_upstream(uid)
						if (R in P.suppressant.reactionlist)
							boutput(user, P.suppressant.reactionmessage)
						for (var/key in P.effects)
							if (R in P.effects[key])
								boutput(user, P.effects[key].reactionmessage)


/obj/machinery/computer/microbiology
	name = "Microbiology Research"
	icon = 'icons/obj/computer.dmi'
	icon_state = "pathology"
	desc = "A bulky machine used to control the pathogen manipulator."


/obj/machinery/pathogen_manipulator
	name = "Pathogen Manipulator"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "manipulator"
	desc = "A large, softly humming machine."
	density = 1
	anchored = 1

/obj/item/synthmodule
	name = "Synth-O-Matic module"
	desc = "A module that integrates with a Synth-O-Matic machine."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "synthmodule"

/obj/item/synthmodule/vaccine
	name = "Synth-O-Matic Vaccine module"
	desc = "A module that allows the Synth-O-Matic machine to create vaccines."

/obj/item/synthmodule/upgrader
	name = "Synth-O-Matic Efficiency module"
	desc = "A module that allows the Synth-O-Matic machine to synthesize more anti-pathogenic agents from a single sample."

/obj/item/synthmodule/assistant
	name = "Synth-O-Matic Assistant module"
	desc = "A module that assists in creating cure for pathogens for the Synth-O-Matic machine."

/obj/item/synthmodule/synthesizer
	name = "Synth-O-Matic Antiagent module"
	desc = "A module which allows the Synth-O-Matic to synthesize an anti-pathogen agent on the fly."

/obj/item/synthmodule/virii
	name = "Synth-O-Matic Virii module"
	desc = "A module that allows the Synth-O-Matic to internally generate cures to virii."

/obj/item/synthmodule/bacteria
	name = "Synth-O-Matic Bacteria module"
	desc = "A module that allows the Synth-O-Matic to internally generate cures to bacteria."

/obj/item/synthmodule/fungi
	name = "Synth-O-Matic Fungi module"
	desc = "A module that allows the Synth-O-Matic to internally generate cures to fungi."

/obj/item/synthmodule/parasite
	name = "Synth-O-Matic Parasite module"
	desc = "A module that allows the Synth-O-Matic to internally generate cures to parasitic diseases, using biocides."

/obj/item/synthmodule/gmcell
	name = "Synth-O-Matic Mutatis module"
	desc = "A module that allows the Synth-O-Matic to internally generate cures to great mutatis cell diseases."

/obj/item/synthmodule/radiation
	name = "Synth-O-Matic Irradiation module"
	desc = "A module that allows the Synth-O-Matic to generate cure through irradiation, instead of chemicals."

/obj/machinery/synthomatic
	name = "Synth-O-Matic 6.5.535"
	desc = "The leading technological assistant in synthesizing useful biochemicals."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "synth1"
	density = 1
	anchored = 1
	flags = NOSPLASH

	var/list/obj/item/reagent_containers/glass/vial/vials[3]
	var/obj/item/beaker = null
	var/obj/item/bloodbag = null
	var/datum/reagent/selectedresult = null
	var/emagged = FALSE
	var/delay = 5
	var/maintainance = FALSE
	var/machine_state = 0
	var/sel_vial = 0
	var/const/synthesize_cost = 100 // used to used to be 2000
	var/production_amount = 7 // Balance so that you don't need to drain the budget to get a big surplus

	attack_hand(var/mob/user)
		if(status & (BROKEN|NOPOWER))
			return
		..()
		show_interface(user)

	attackby(var/obj/item/O, var/mob/user)
		if(status & (BROKEN|NOPOWER))
			boutput(user,  "<span class='alert'>You can't insert things while the machine is out of power!</span>")
			return

		if (istype(O,/obj/item/card/emag))
			emagged = !emagged
			boutput(user, "<span class='notice'>You switch [emagged ? "on" : "off"] the overclocking components and reroute the integrated budget directory.</span>")
			return

		if (istype(O, /obj/item/reagent_containers/glass/vial))
			var/done = FALSE
			if (O.reagents.reagent_list.len > 1 || O.reagents.total_volume < 5)	//full, pure-reagent vials only
				boutput(user, "<span class='alert'>The machine can only process full vials of pure reagent.</span>")
				return
			for (var/i in 1 to 3)
				if (!(vials[i]))
					done = TRUE
					vials[i] = O
					user.u_equip(O)
					O.set_loc(src)
					user.client.screen -= O
					break
			if (done == FALSE)
				boutput(user, "<span class='alert'>The machine cannot hold any more vials.</span>")
				return
			else
				boutput(user, "<span class='notice'>You insert the vial into the machine.</span>")
				return

		if (istype(O, /obj/item/reagent_containers/iv_drip))
			if (!(user in range(1)))
				boutput(user, "<span class='alert'>You must be near the machine to do that.</span>")
				return
			if (user.equipped() != O)
				return
			if (src.bloodbag)
				boutput(user, "<span class='alert'>A blood bag is already loaded into the machine.</span>")
				return
			if (O.reagents.reagent_list.len > 1 || !(O.reagents.has_reagent("blood")))	// pure-reagent only
				boutput(user, "<span class='alert'>Foreign contaminants detected in the blood bag.</span>")
				return
			if (!(O.reagents.reagent_list.len))
				boutput(user, "<span class='alert'>The blood bag is empty.</span>")
				return
			else
				src.bloodbag = O
				user.u_equip(O)
				O.set_loc(src)
				O.master = src
				user.client.screen -= O
				boutput(user, "<span class='notice'>You insert the blood bag into the machine.</span>")
				return

		if (istype(O, /obj/item/reagent_containers/glass/beaker))
			if (!(user in range(1)))
				boutput(user, "<span class='alert'>You must be near the machine to do that.</span>")
				return
			if (user.equipped() != O)
				return
			if (src.beaker)
				boutput(user, "<span class='alert'>An egg reservoir beaker is already loaded into the machine.</span>")
				return
			if (O.reagents.reagent_list.len > 1)	// pure-reagent only
				boutput(user, "<span class='alert'>Please isolate the egg in the beaker.</span>")
				return
			if (!(O.reagents.has_reagent("egg")))
				boutput(user, "<span class='alert'>Egg substance not detected.</span>")
				return
			else
				src.beaker = O
				user.u_equip(O)
				O.set_loc(src)
				O.master = src
				user.client.screen -= O
				boutput(user, "<span class='notice'>You insert the beaker into the machine.</span>")
				return

		if (isscrewingtool(O))
			if (machine_state)
				boutput(user, "<span class='alert'>You cannot do that while the machine is working.</span>")
				return
			if (maintainance)
				icon_state = "synth1"
				boutput(user, "<span class='notice'>You close the maintenance panel on the Synth-O-Matic.</span>")
			else
				icon_state = "synthp"
				boutput(user, "<span class='notice'>You open the maintenance panel on the Synth-O-Matic.</span>")
			maintainance = !maintainance
			return
		..(O, user)

	proc/show_interface(var/mob/user)
		. = ""
		. += "<b>SYNTH-O-MATIC 6.5.535</b><br>"
		. += "<i>\"Introducing the future in safe and controlled <s>pathology science</s> biochemistry.\"</i><br><br>"

		if (machine_state)
			. += "The machine is currently working. Please wait."
		else if (maintainance)
			. += "<b>Maintenance panel open.</b><br>"
		else
			. += "<b>Active vial:</b><br>"
			if (sel_vial && vials[sel_vial])
				var/obj/item/reagent_containers/glass/vial/V = vials[sel_vial]
				var/rid = V.reagents.get_master_reagent()
				var/rname = V.reagents.get_master_reagent_name()
				. += "Vial #[sel_vial]: [rname]<br>"
				for (var/R in concrete_typesof(/datum/reagent/microbiology))
					var/datum/reagent/RE = new R()
					if (RE.data == rid)
						src.selectedresult = RE
						. += "Valid precursor: <a href='?src=\ref[src];buymats=1'>Synthesize for [synthesize_cost] credits</a><br>"
						break
			else
				. += "None<br><br>"
			if (emagged)
				. += "<b>Research Budget:</b> <b>$!ND!_(@+E999999999999999999999</b> Credits<br><br>"
			else
				. += "<b>Research Budget:</b> [wagesystem.research_budget] Credits<br><br>"

			. += "<b>Inserted vials:</b><br>"
			for (var/i in 1 to 3)
				if (vials[i])
					var/obj/item/reagent_containers/glass/vial/V = vials[i]
					var/chemname = V.reagents.get_master_reagent_name()
					. += "Vial #[i]: <a href='?src=\ref[src];vial=[i]'>[chemname]</a> <a href='?src=\ref[src];eject=[i]'>\[eject\]</a><br>"
				else
					. += "#[i] Empty slot<br>"
			. += "<br><b>Egg reservoir: </b>"
			if (beaker)
				. += "[beaker] <a href='?src=\ref[src];ejectanti=1'>\[eject\]</a><br><br>"
				. += "<b>Contents:</b><br>"
				if (beaker.reagents.reagent_list.len)
					for (var/reagent in beaker.reagents.reagent_list)
						var/datum/reagent/R = beaker.reagents.reagent_list[reagent]
						. += "[R.volume] units of [R.name]<br><br>"
				else
					. += "Empty.<br><br>"
			else
				. += "No beaker detected.<br><br>"
			. += "<br><b>Blood Supply: </b>"
			if (bloodbag)
				. += "[bloodbag] <a href='?src=\ref[src];ejectsupp=1'>\[eject\]</a><br><br>"
				. += "<b>Contents:</b><br>"
				if (bloodbag.reagents.reagent_list.len)
					for (var/reagent in bloodbag.reagents.reagent_list)
						var/datum/reagent/R = bloodbag.reagents.reagent_list[reagent]
						. += "[R.volume] units of [R.name]<br><br>"
				else
					. += "Empty.<br><br>"
			else
				. += "No blood bag detected.<br><br>"

		user.Browse(., "window=synthomatic;size=800x600")

	Topic(href, href_list)
		if (!(usr in range(1)))
			return
		if (machine_state)
			show_interface(usr)
			return
		if (maintainance)
			show_interface(usr)
			return
		else
			if (href_list["eject"])
				var/index = text2num_safe(href_list["eject"])
				//Arrays start at 0 -Byand
				if(index > 0 && index <= vials.len)
					if (vials[index])
						var/obj/item/reagent_containers/glass/vial/V = vials[index]
						vials[index] = null
						V.set_loc(src.loc)
						usr.put_in_hand_or_eject(V) // try to eject it into the users hand, if we can
						V.master = null
						if (sel_vial == index)
							sel_vial = 0
				show_interface(usr)
			else if (href_list["ejectanti"])
				if (beaker)
					beaker.set_loc(src.loc)
					beaker.master = null
					beaker = null
				show_interface(usr)
			else if (href_list["ejectsupp"])
				if (bloodbag)
					bloodbag.set_loc(src.loc)
					bloodbag.master = null
					bloodbag = null
				show_interface(usr)
			else if (href_list["vial"])
				var/index = text2num_safe(href_list["vial"])
				if(index > 0 && index <= vials.len)
					if (vials[index])
						sel_vial = index

			else if (href_list["buymats"])
				if (machine_state == 0 && (usr in range(1)))
					if (!bloodbag)
						boutput(usr, "<span class='alert'>No blood reservoir detected.</span>")
					else if (!beaker)
						boutput(usr, "<span class='alert'>No egg reservoir detected.</span>")
					if (bloodbag && beaker)
						var/BL = bloodbag.reagents.get_reagent_amount("blood")
						var/EG = beaker.reagents.get_reagent_amount("egg")
						if (EG < 5)
							boutput(usr, "<span class='alert'>Insufficient egg reservoir (5 units needed).</span>")
						else if (BL < 25)
							boutput(usr, "<span class='alert'>Insufficient blood reservoir (25 units needed).</span>")
						else if (synthesize_cost > wagesystem.research_budget && !emagged)
							boutput(usr, "<span class='alert'>Insufficient research budget to make that transaction.</span>")
						else
							boutput(usr, "<span class='notice'>Transaction successful.</span>")
							machine_state = 1
							icon_state = "synth2"
							show_interface(usr)
							src.visible_message("The [src.name] bubbles and begins synthesis.", "You hear a bubbling noise.")
							beaker.reagents.remove_reagent("egg", 5)
							bloodbag.reagents.remove_reagent("blood", 25)
							if (emagged)
								delay = 3
							else
								delay = 5
								wagesystem.research_budget -= synthesize_cost
						SPAWN(delay SECONDS)
							for (var/mob/C in viewers(src))
								C.show_message("The [src.name] ejects [production_amount] biochemical sample[production_amount? "s." : "."]", 3)
							production_amount = rand(BIOCHEMISTRY_PRODUCTION_LOWER_BOUND, BIOCHEMISTRY_PRODUCTION_UPPER_BOUND)
							for (var/i in 1 to production_amount)
								var/obj/item/reagent_containers/glass/vial/plastic/V = new /obj/item/reagent_containers/glass/vial/plastic(src.loc)
								V.reagents.add_reagent(src.selectedresult.id, 5)
							machine_state = 0
							icon_state = "synth1"
		show_interface(usr)


/obj/machinery/autoclave
	name = "Autoclave"
	desc = "A bulky machine used for sanitizing pathogen growth equipment."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "autoclave"
	density = 1
	anchored = 1

/obj/machinery/vending/microbiology
	name = "Path-o-Matic"
	desc = "Microbiology equipment dispenser."
	icon_state = "path"
	icon_panel = "standard-panel"
	icon_deny = "path-deny"
	icon_off = "med-off"
	icon_broken = "med-broken"
	icon_fallen = "med-fallen"

	New()
		..()
		//Products
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/syringe, 12)
		product_list += new/datum/data/vending_product(/obj/item/bloodslide, 50)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/vial, 25)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/petridish, 8)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/beaker/egg, 20)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/beaker/spaceacillin, 20)
		product_list += new/datum/data/vending_product(/obj/item/device/analyzer/healthanalyzer, 4)

/obj/machinery/incubator
	name = "Incubator"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "incubator"
	var/static/image/icon_beaker = image('icons/obj/chemical.dmi', "heater-beaker")
	desc = "A machine that can automatically provide a petri dish with nutrients. It can also directly fill vials with a sample of the pathogen inside."
	anchored = 1
	density = 1
