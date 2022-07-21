/obj/machinery/centrifuge
	name = "Centrifuge"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "centrifuge0"
	desc = "A large machine that can be used to separate a pathogen sample from a blood sample."
	anchored = TRUE
	density = TRUE
	flags = NOSPLASH
	var/obj/item/reagent_containers/glass/petridish/dish = null
	// Is the machine in operation?
	var/active = FALSE
	// How many process cycles
	var/counter = 8
	// uid of selected culture
	var/selected_culture = null

	examine()
		. = ..()
		if (!isalive(usr) || iswraith(usr))
			return
		. += "<br>There is [src.dish ? "a petri dish" : "nothing"] loaded in the [src]."
		if (!src.dish.reagents.total_volume)
			. += "<br>The [src.dish] is empty."

	update_icon()
		if (src.active)
			src.icon_state = "centrifuge1"
		else
			icon_state = "centrifuge0"

	verb/eject()
		set name = "Eject"
		set src in oview(1)
		set category = "Local"

		if (!isalive(usr) || iswraith(usr))
			return
		if (!src.dish)
			boutput(usr, "<span class='alert'>There is nothing loaded in the [src].</span>")
			return
		if (src.active)
			boutput(usr, "<span class='alert'>Not while the [src] is on.</span>")
			return

		boutput(usr, "<span class='notice'>You remove the [src.dish] from the [src].</span>")
		add_fingerprint(usr)
		usr.put_in_hand_or_eject(src.dish)
		src.dish = null
		src.UpdateIcon()
		return

	process()
		if (!src.active)
			return
		src.counter--
		if (!src.counter)
			processing_items.Remove(src)
			src.visible_message("<span class='notice'>The [src] beeps as it shuts down normally.</span>", \
			"<span class='notice'>You hear a machine powering down.</span>")
			var/list/microbeuids = src.dish.reagents.aggregate_pathogens()
			for (var/uid as anything in microbeuids)
				// 5u to a blood slide
				var/obj/item/reagent_containers/bloodslide/slide = new /obj/item/reagent_containers/bloodslide
				slide.reagents.add_reagent("pathogen", 5)
				slide.flags -= OPENCONTAINER
				var/datum/reagent/blood/pathogen/P = slide.reagents.get_reagent("pathogen")
				P.microbes += uid

			src.dish.reagents.clear_reagents()
			src.active = FALSE
			src.UpdateIcon()
			src.counter = 8

	attack_hand(mob/user)
		..()
		if (src.active && (tgui_alert(src, "Are you sure you want stop the centrifuge?", "Confirm", list("Yes", "No")) == "Yes"))
			src.visible_message("<span class='alert'>The [src] grinds to a sudden halt. The [src.dish] flies off the supports and shatters somewhere inside the machine.</span>", \
			"<span class='alert'>You hear a grinding noise, followed by something shattering.</span>")
			src.active = FALSE
			src.dish = null
			src.counter = 8
			processing_items.Remove(src)
			src.UpdateIcon()
			return
		if (!src.dish)
			boutput(user, "<span class='alert'>There isn't a petri dish loaded in the [src]!")
			return
		else if (!src.dish.reagents.total_volume)
			boutput(user, "<span class='alert'>The petri dish loaded in the [src] is empty!")
			return
		else if (!src.active)
			src.active = TRUE
			src.visible_message("<span class='notice'>The centrifuge powers up and begins the isolation process.</span>", \
			"<span class='notice'>You hear a machine powering up.</span>")
			processing_items.Add(src)
			src.UpdateIcon()
			return

	attackby(var/obj/item/O, var/mob/user)
		if (istype(O, /obj/item/reagent_containers/glass/petridish))
			var/obj/item/reagent_containers/glass/petridish/Pdish = O
			// Grab inserting stuff from the chemdispenser
			var/ejected_dish = null
			if (src.dish?.loc == src)
				ejected_dish = src.dish
				user.put_in_hand_or_drop(ejected_dish)
			src.dish = Pdish
			if (!Pdish.cant_drop)
				user.drop_item()
				if (!Pdish.qdeled)
					Pdish.set_loc(src)
			if (Pdish.qdeled)
				Pdish = null
			else
				if (ejected_dish)
					boutput(user, "You swap the [ejected_dish] with the [src.dish] already loaded into the machine.")
				else
					boutput(user, "You insert the [O.name] into the machine.")
			src.UpdateIcon()
			tgui_process.update_uis(src)

/obj/machinery/microscope
	name = "Microscope"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "microscope0"
	desc = "A device which provides a magnified view of blood samples in a blood slide or cultures in a petri dish."
	var/obj/item/target = null
	var/zoom = FALSE
	anchored = TRUE

	examine()
		. = ..()
		if (!isalive(usr) || iswraith(usr))
			return
		. += "<br>The microscope is zoomed [src.zoom ? "in" : "out"]."

		var/list/microbelist = src.target.reagents.aggregate_pathogens()
		for (var/uid as anything in microbelist)
			var/datum/microbe/index = microbio_controls.pull_from_upstream(uid)
			. += ("<br>You see [index.desc].")
			if (index.goodeffectcount)
				. += ("<br>This culture has <span style='color: rgb(0, [200], 0)'>[index.goodeffectcount]</span> good effects.")
			if (index.neutraleffectcount)
				. += ("<br>This culture has <span style='color: rgb(0, 0, [200])'>[index.neutraleffectcount]</span> neutral effects.")
			if (index.badeffectcount)
				. += ("<br>This culture has <span style='color: rgb([200], 0, 0)'>[index.badeffectcount]</span> bad effects.")
		return

	verb/eject()
		set name = "Eject"
		set src in oview(1)
		set category = "Local"

		if (!isalive(usr) || iswraith(usr))
			return
		if (!src.target)
			boutput(usr, "<span class='alert'>There is nothing loaded under the [src].</span>")
			return
		if (src.zoom)
			boutput(usr, "<span class='alert'>The [src] is still zoomed in. Readjust it before removing the [src.target].</span>")
			return

		boutput(usr, "<span class='notice'>You remove the [src.target] from the [src].</span>")
		add_fingerprint(usr)
		usr.put_in_hand_or_eject(src.target)
		src.target = null
		src.UpdateIcon()
		return

	update_icon()
		if (src.target)
			icon_state = src.zoom ? "microscope3" : "microscope1"
		else
			icon_state = src.zoom ? "microscope2" : "microscope0"

	proc/zoom(mob/user)
		src.zoom = !src.zoom
		playsound(src.loc, "sound/items/Screwdriver2.ogg", 25, -3)
		//Actionbar marco bugs out the boutput after interrupts so this goes here
		boutput(user, "The microscope is now zoomed [src.zoom ? "in" : "out"].")
		src.UpdateIcon()

	attack_hand(mob/user)
		boutput(user, "You start adjusting the microscope...")
		playsound(src.loc, "sound/items/Screwdriver.ogg", 25, -3)
		add_fingerprint(usr)
		SETUP_GENERIC_PRIVATE_ACTIONBAR(user, src, 3 SECONDS, .proc/zoom, user, null, null, \
		null, INTERRUPT_ACTION | INTERRUPT_MOVE | INTERRUPT_STUNNED | INTERRUPT_ACT)

	attackby(var/obj/item/O, var/mob/user)
		if (istype(O, /obj/item/reagent_containers/glass/petridish) || istype(O, /obj/item/reagent_containers/bloodslide))
			if (src.target)
				boutput(user, "<span class='alert'>There is already a [src.target] on the [src].</span>")
				return
			if (src.zoom)
				boutput(user, "There isn't enough clearance to insert the [O] while the [src] is zoomed in.")
				return
			src.target = O
			user.u_equip(O)
			boutput(user, "You place the [O] under the [src].")
			src.UpdateIcon()
			return

		else if (istype(O, /obj/item/reagent_containers/dropper))
			if (!src.target)
				boutput(user, "<span class='alert'>There's nothing under the [src]!</span>")
				return

			if (!istype(src.target, /obj/item/reagent_containers/glass/petridish))
				boutput(user, "<span class='alert'>The [src.target] won't contain the test reagent!</span>")
				return

			if (!O.reagents.total_volume)
				boutput(user, "<span class='alert'>The [src.target] is empty!</span>")
				return

			user.visible_message("[user] drips some of the contents of the dropper into the [src.target].", \
			"You drip some of the contents of the dropper into the [src.target].")

			var/list/path_list = src.target.reagents.aggregate_pathogens()
			for (var/rid as anything in O.reagents.reagent_list)
				var/datum/reagent/R = O.reagents.reagent_list[rid]
				for (var/uid as anything in path_list)
					var/datum/microbe/P = microbio_controls.pull_from_upstream(uid)
					if (R in P.suppressant.cure_synthesis && (R.volume > MB_REACTION_MINIMUM))
						boutput(user, "<span class='notice'>The microbes in the test reagent are rapidly withering away!</span>")


/obj/machinery/computer/microbiology
	name = "Microbiology Research"
	icon = 'icons/obj/computer.dmi'
	icon_state = "pathology"
	desc = "A bulky machine used to control the pathogen manipulator."
	flags = FPRINT

	var/obj/item/reagent_containers/glass/vial/sampleconsole = null

	//TGUI


	/*

	proc/serialize(datum/microbe/micro)

		. = list(
			"uid" = micro.uid,
			"name" = micro.name,
			"curename" = micro.suppressant.name,
			"curemethod" = micro.suppressant.exactcure,
			"durtot" = micro.durationtotal,
			"inftot" = micro.infectiontotal,
			"artificial" = micro.artificial
			)

		for (var/index in micro.effects)
			.["effects"]["indexeffect"] = micro.effects[index]

	ui_interact(mob/user, datum/tgui/ui)
		ui = tgui_process.try_update_ui(user, src, ui)
		if(!ui)
			ui = new(user, src, "MicrobiologyResearch")
			ui.open()

	ui_data(mob/user)

	// Reports

		var/list/reportList = list()

		for (var/key in microbio_controls.cultures)
			if (!microbio_controls.cultures[key].reported)
				continue
			reportList += src.serialize(microbio_controls.cultures[key])

		.["reports"] = reportList

	// Sample

		var/list/sampleContents = list()

		if(src.sampleconsole)
			for (var/datum/reagent/aff_reag as anything in microbio_controls.pathogen_affected_reagents)
				if (!src.sampleconsole.reagents.has_reagent(aff_reag))
					continue
				var/datum/reagent/blood/R = src.sampleconsole.reagents.get_reagent(aff_reag)
				for (var/index in R.microbes)
					var/datum/microbe/importing = microbio_controls.pull_from_upstream(index)
					bloodslideContents.Add(list(list(
						uid = index,
						name = importing.name,
						goodeff = importing.goodeffectcount,
						neuteff = importing.neutraleffectcount,
						badeff = importing.badeffectcount
					)))

		.["testsample"] = sampleContents

	// Designer Holder

	// Analysis

	// Market/Shopping

	ui_act(action, params)
		. = ..()
		if (.)
			return

	*/

/obj/machinery/pathogen_manipulator
	name = "Pathogen Manipulator"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "manipulator"
	desc = "A large, softly humming machine."
	density = 1
	anchored = 1
	flags = FPRINT

	var/obj/item/reagent_containers/glass/vial/samplemanip = null

	//Just hold my vial please.

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

// Biochemistry
/obj/machinery/synthomatic
	name = "Synth-O-Matic 6.5.535"
	desc = "The leading technological assistant in synthesizing useful biochemicals."
	icon = 'icons/obj/pathology.dmi'
	icon_state = "synth1"
	density = TRUE
	anchored = TRUE
	flags = NOSPLASH

	var/list/obj/item/reagent_containers/glass/vial/vials[3]
	var/obj/item/beaker = null
	var/obj/item/bloodbag = null
	var/datum/reagent/selectedresult = null
	var/emagged = FALSE
	var/delay = 5
	var/maintainance = FALSE
	//Is it working on something
	var/machine_state = FALSE
	//Index of whic vial
	var/sel_vial = 0
	var/const/synthesize_cost = 100 // used to used to be 2000
	var/production_amount = 7 // Balance so that you don't need to drain the budget to get a big surplus

	attack_hand(var/mob/user)
		if(status & (BROKEN|NOPOWER))
			return
		..()
		show_interface(user)

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (src.machine_state)
			boutput(user, "<span class='notice'>Not while the machine is running.</span>")
			return

		src.emagged = !src.emagged
		boutput(user, "<span class='notice'>You switch [src.emagged ? "on" : "off"] the overclocking components and reroute the integrated budget directory.</span>")

	attackby(var/obj/item/O, var/mob/user)
		if(status & (BROKEN|NOPOWER))
			boutput(user,  "<span class='alert'>You can't insert things while the machine is out of power!</span>")
			return
		if (istype(O, /obj/item/reagent_containers/glass/vial))
			var/done = FALSE
			if (O.reagents.reagent_list.len > 1 || O.reagents.total_volume < 5)	//full, pure-reagent vials only
				boutput(user, "<span class='alert'>The machine can only process full vials of pure reagent.</span>")
				return
			for (var/i in 1 to 3)
				if (!(src.vials[i]))
					done = TRUE
					src.vials[i] = O
					user.u_equip(O)
					O.set_loc(src)
					user.client.screen -= O
					break
			if (!done)
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
			if (src.machine_state)
				boutput(user, "<span class='alert'>You cannot do that while the machine is working.</span>")
				return
			if (src.maintainance)
				src.icon_state = "synth1"
				boutput(user, "<span class='notice'>You close the maintenance panel on the Synth-O-Matic.</span>")
			else
				src.icon_state = "synthp"
				boutput(user, "<span class='notice'>You open the maintenance panel on the Synth-O-Matic.</span>")
			src.maintainance = !src.maintainance
			return
		..(O, user)


	//To TGUI

	//Interact
	/*
		if (!(usr in range(1)))
			return
		if (src.machine_state)
			show_interface(usr)
			return
		if (src.maintainance)
			show_interface(usr)
			return
	*/


	//Data, Staticdata

	//var/list/obj/item/reagent_containers/glass/vial/vials[3]
	//var/obj/item/beaker = null
	//var/obj/item/bloodbag = null
	//var/datum/reagent/selectedresult = null
	//var/emagged = FALSE
	//var/delay = 5
	//var/maintainance = FALSE
	//var/machine_state = FALSE
	//var/sel_vial = 0
	//var/const/synthesize_cost = 100 // used to used to be 2000
	//var/production_amount = 7 // Balance so that you don't need to drain the budget to get a big surplus

	//Act
	/*
			if (href_list["eject"])
				var/index = text2num_safe(href_list["eject"])
				//Arrays start at 0 -Byand
				if(index > 0 && index <= src.vials.len)
					if (src.vials[index])
						var/obj/item/reagent_containers/glass/vial/V = src.vials[index]
						src.vials[index] = null
						V.set_loc(src.loc)
						usr.put_in_hand_or_eject(V) // try to eject it into the users hand, if we can
						V.master = null
						if (src.sel_vial == index)
							src.sel_vial = 0
				show_interface(usr)
			else if (href_list["ejectanti"])
				if (src.beaker)
					src.beaker.set_loc(src.loc)
					src.beaker.master = null
					src.beaker = null
				show_interface(usr)
			else if (href_list["ejectsupp"])
				if (src.bloodbag)
					src.bloodbag.set_loc(src.loc)
					src.bloodbag.master = null
					src.bloodbag = null
				show_interface(usr)
			else if (href_list["vial"])
				var/index = text2num_safe(href_list["vial"])
				if(index > 0 && index <= src.vials.len)
					if (src.vials[index])
						src.sel_vial = index

			else if (href_list["buymats"])
				if (!src.machine_state && (usr in range(1)))
					if (!src.bloodbag)
						boutput(usr, "<span class='alert'>No blood reservoir detected.</span>")
					else if (!beaker)
						boutput(usr, "<span class='alert'>No egg reservoir detected.</span>")
					if (src.bloodbag && src.beaker)
						var/BL = src.bloodbag.reagents.get_reagent_amount("blood")
						var/EG = src.beaker.reagents.get_reagent_amount("egg")
						if (EG < 5)
							boutput(usr, "<span class='alert'>Insufficient egg reservoir (5 units needed).</span>")
						else if (BL < 25)
							boutput(usr, "<span class='alert'>Insufficient blood reservoir (25 units needed).</span>")
						else if (synthesize_cost > wagesystem.research_budget && !src.emagged)
							boutput(usr, "<span class='alert'>Insufficient research budget to make that transaction.</span>")
						else
							boutput(usr, "<span class='notice'>Transaction successful.</span>")
							src.machine_state = TRUE
							src.icon_state = "synth2"
							show_interface(usr)
							src.visible_message("The [src.name] bubbles and begins synthesis.", "You hear a bubbling noise.")
							src.beaker.reagents.remove_reagent("egg", 5)
							src.bloodbag.reagents.remove_reagent("blood", 25)
							if (src.emagged)
								src.delay = 3
							else
								src.delay = 5
								wagesystem.research_budget -= synthesize_cost
						SPAWN(src.delay SECONDS)
							src.production_amount = rand(BIOCHEMISTRY_PRODUCTION_LOWER_BOUND, BIOCHEMISTRY_PRODUCTION_UPPER_BOUND)
							for (var/mob/C in viewers(src))
								C.show_message("The [src.name] ejects [src.production_amount] biochemical sample[src.production_amount ? "s." : "."]", 3)
							for (var/i in 1 to src.production_amount)
								var/obj/item/reagent_containers/glass/vial/plastic/V = new /obj/item/reagent_containers/glass/vial/plastic(src.loc)
								V.reagents.add_reagent(src.selectedresult.id, 5)
							src.machine_state = FALSE
							src.icon_state = "synth1"
	*/

	//State?

	//Frontend!

	proc/show_interface(var/mob/user)
		. = ""
		. += "<b>SYNTH-O-MATIC 6.5.535</b><br>"
		. += "<i>\"Introducing the future in safe and controlled <s>pathology science</s> biochemistry.\"</i><br><br>"

		if (src.machine_state)
			. += "The machine is currently working. Please wait."
		else if (src.maintainance)
			. += "<b>Maintenance panel open.</b><br>"
		else
			. += "<b>Active vial:</b><br>"
			if (src.sel_vial && src.vials[src.sel_vial])
				var/obj/item/reagent_containers/glass/vial/V = src.vials[src.sel_vial]
				var/rid = V.reagents.get_master_reagent()
				var/rname = V.reagents.get_master_reagent_name()
				. += "Vial #[src.sel_vial]: [rname]<br>"
				for (var/R in concrete_typesof(/datum/reagent/microbiology))
					var/datum/reagent/RE = new R()
					if (RE.data == rid)
						src.selectedresult = RE
						. += "Valid precursor: <a href='?src=\ref[src];buymats=1'>Synthesize for [src.synthesize_cost] credits</a><br>"
						break
			else
				. += "None<br><br>"
			if (src.emagged)
				. += "<b>Research Budget:</b> <b>$!ND!_(@+E999999999999999999999</b> Credits<br><br>"
			else
				. += "<b>Research Budget:</b> [wagesystem.research_budget] Credits<br><br>"

			. += "<b>Inserted vials:</b><br>"
			for (var/i in 1 to 3)
				if (src.vials[i])
					var/obj/item/reagent_containers/glass/vial/V = src.vials[i]
					var/chemname = V.reagents.get_master_reagent_name()
					. += "Vial #[i]: <a href='?src=\ref[src];vial=[i]'>[chemname]</a> <a href='?src=\ref[src];eject=[i]'>\[eject\]</a><br>"
				else
					. += "#[i] Empty slot<br>"
			. += "<br><b>Egg reservoir: </b>"
			if (src.beaker)
				. += "[src.beaker] <a href='?src=\ref[src];ejectanti=1'>\[eject\]</a><br><br>"
				. += "<b>Contents:</b><br>"
				if (src.beaker.reagents.reagent_list.len)
					for (var/reagent in src.beaker.reagents.reagent_list)
						var/datum/reagent/R = src.beaker.reagents.reagent_list[reagent]
						. += "[R.volume] units of [R.name]<br><br>"
				else
					. += "Empty.<br><br>"
			else
				. += "No beaker detected.<br><br>"
			. += "<br><b>Blood Supply: </b>"
			if (src.bloodbag)
				. += "[src.bloodbag] <a href='?src=\ref[src];ejectsupp=1'>\[eject\]</a><br><br>"
				. += "<b>Contents:</b><br>"
				if (src.bloodbag.reagents.reagent_list.len)
					for (var/reagent in src.bloodbag.reagents.reagent_list)
						var/datum/reagent/R = src.bloodbag.reagents.reagent_list[reagent]
						. += "[R.volume] units of [R.name]<br><br>"
				else
					. += "Empty.<br><br>"
			else
				. += "No blood bag detected.<br><br>"

		user.Browse(., "window=synthomatic;size=800x600")

	Topic(href, href_list)
		if (!(usr in range(1)))
			return
		if (src.machine_state)
			show_interface(usr)
			return
		if (src.maintainance)
			show_interface(usr)
			return
		else
			if (href_list["eject"])
				var/index = text2num_safe(href_list["eject"])
				//Arrays start at 0 -Byand
				if(index > 0 && index <= src.vials.len)
					if (src.vials[index])
						var/obj/item/reagent_containers/glass/vial/V = src.vials[index]
						src.vials[index] = null
						V.set_loc(src.loc)
						usr.put_in_hand_or_eject(V) // try to eject it into the users hand, if we can
						V.master = null
						if (src.sel_vial == index)
							src.sel_vial = 0
				show_interface(usr)
			else if (href_list["ejectanti"])
				if (src.beaker)
					src.beaker.set_loc(src.loc)
					src.beaker.master = null
					src.beaker = null
				show_interface(usr)
			else if (href_list["ejectsupp"])
				if (src.bloodbag)
					src.bloodbag.set_loc(src.loc)
					src.bloodbag.master = null
					src.bloodbag = null
				show_interface(usr)
			else if (href_list["vial"])
				var/index = text2num_safe(href_list["vial"])
				if(index > 0 && index <= src.vials.len)
					if (src.vials[index])
						src.sel_vial = index

			else if (href_list["buymats"])
				if (!src.machine_state && (usr in range(1)))
					if (!src.bloodbag)
						boutput(usr, "<span class='alert'>No blood reservoir detected.</span>")
					else if (!beaker)
						boutput(usr, "<span class='alert'>No egg reservoir detected.</span>")
					if (src.bloodbag && src.beaker)
						var/BL = src.bloodbag.reagents.get_reagent_amount("blood")
						var/EG = src.beaker.reagents.get_reagent_amount("egg")
						if (EG < 5)
							boutput(usr, "<span class='alert'>Insufficient egg reservoir (5 units needed).</span>")
						else if (BL < 25)
							boutput(usr, "<span class='alert'>Insufficient blood reservoir (25 units needed).</span>")
						else if (synthesize_cost > wagesystem.research_budget && !src.emagged)
							boutput(usr, "<span class='alert'>Insufficient research budget to make that transaction.</span>")
						else
							boutput(usr, "<span class='notice'>Transaction successful.</span>")
							src.machine_state = TRUE
							src.icon_state = "synth2"
							show_interface(usr)
							src.visible_message("The [src.name] bubbles and begins synthesis.", "You hear a bubbling noise.")
							src.beaker.reagents.remove_reagent("egg", 5)
							src.bloodbag.reagents.remove_reagent("blood", 25)
							if (src.emagged)
								src.delay = 3
							else
								src.delay = 5
								wagesystem.research_budget -= synthesize_cost
						SPAWN(src.delay SECONDS)
							src.production_amount = rand(5, 7)
							for (var/mob/C in viewers(src))
								C.show_message("The [src.name] ejects [src.production_amount] biochemical sample[src.production_amount ? "s." : "."]", 3)
							for (var/i in 1 to src.production_amount)
								var/obj/item/reagent_containers/glass/vial/plastic/V = new /obj/item/reagent_containers/glass/vial/plastic(src.loc)
								V.reagents.add_reagent(src.selectedresult.id, 5)
							src.machine_state = FALSE
							src.icon_state = "synth1"
		show_interface(usr)

// Mycology? (might be a partial implement of a bigger thing)
/obj/machinery/incubator
	name = "Incubator"
	icon = 'icons/obj/pathology.dmi'
	icon_state = "incubator"
	var/static/image/icon_beaker = image('icons/obj/chemical.dmi', "heater-beaker")
	desc = "A machine that can automatically provide a petri dish with nutrients. It can also directly fill vials with a sample of the pathogen inside."
	anchored = TRUE
	density = TRUE
	flags = NOSPLASH
	var/obj/item/reagent_containers/glass/beaker/beaker = null
	var/medium = null

	update_icon()
		if (src.beaker)
			src.icon_state = "incubator_on"
		else
			src.icon_state = "incubator"

	attackby(var/obj/item/O, mob/user)
		if (istype(O, /obj/item/reagent_containers/glass/beaker))
			var/obj/item/reagent_containers/C = O

			if (user.equipped() != O)
				return

			if (!(user in range(1)))
				boutput(user, "<span class='alert'>You must be near the machine to do that.</span>")
				return

			if (!C.reagents.has_reagent("space_fungus"))
				boutput(user, "<span class='alert'>The [C.name] doesn't have any space fungus to cultivate!</span>")
				return

			if (src.beaker)
				user.put_in_hand_or_drop(src.beaker)
				boutput(user, "You swap [src.beaker] out of [src].")
				src.beaker = C
				if (C.loc == user)
					user.u_equip(C)
				return

			else
				src.beaker = C
				user.u_equip(C)
				boutput(user, "<span class='notice'>You insert the beaker into the machine.</span>")

// Send this to vending.dm?
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
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/bloodslide, 50)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/vial, 25)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/petridish, 10)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/beaker/egg, 20)
		product_list += new/datum/data/vending_product(/obj/item/reagent_containers/glass/beaker/spaceacillin, 10)
		product_list += new/datum/data/vending_product(/obj/item/device/analyzer/healthanalyzer, 4)
