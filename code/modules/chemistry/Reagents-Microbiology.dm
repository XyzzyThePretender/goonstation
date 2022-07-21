ABSTRACT_TYPE(/datum/reagent/microbiology)

datum
	reagent
		microbiology/
			name = "oh no!"
			id = "anyway"

			/// The ID of the precursor reagent
			data = null

			/// Stop microdosing
			var/minimum_required_volume = 4.5
			reaction_obj(var/obj/O, var/volume)
				if (volume < src.minimum_required_volume)
					return

		/* Tiime to think big:

			Mycology
				Barman
				Med + Chems
					Fungus on the machine
					Fuel on the machine
					Yeast done

					EMAG: Malignant Spores (CDDA lose arms scream agony things) on the machine

				Chef

			Examiners
				Forensics (look this shit needs a complete overhaul.)
				T of Death
				Significant injuries
				Clue in perp

			Biotech
				Electrical (rechargers, cyborgchargers, solar) machine
				Thermal (cryo, egg incu, chef stuff, TEG) machine
				Radioemmissive (UV, singulo, nuclear, PTL) machine
				no emag yet

		*/


		// UV/generally emissive stuff

		// Hydro UV
		// Solar/Nuclear/Singulo
		// Forensics?
		// Rancher (incubator?)

		microbiology/bioelectrical
			name = "bioelectric cells"
			id = "bioelectrical"
			description = "A slurry of various microorganisms: these ones seems to improve the properties of electrical equipment."
			fluid_r = 200
			fluid_b = 5
			fluid_g = 120
			transparency = 120
			value = 4	//1 2 1 	//Take value of egg = 1
			data = "copper"

			reaction_obj(var/obj/O, var/volume)
				..()

				//Solar Panels
				if (istype(O,/obj/machinery/power/solar))
					var/obj/machinery/power/solar/S = O
					// Credit to Convair800's silicate code implementation as a reference
					var/max_improve = 2
					if (S.improve >= max_improve)
						return
					var/do_improve = 0.5
					if ((S.improve + do_improve) > max_improve)
						do_improve = max(0, (max_improve - S.improve))
					S.improve += do_improve
					boutput(usr, "<span class='notice'>The solar panel seems less reflective.</span>")	//It's absorbing more light -> more energy

			//Tool Chargers, Borg Chargers, Cell Chargers
			#define CHARGER_MAX_CHARGE_RATE 1000	//2-3 times faster charge for cells, borgs!
				else if (istype(O, /obj/machinery/recharger))	//Tool charger
					var/obj/machinery/recharger/R = O
					if (R.secondarymult <= 2)
						R.secondarymult = 2
						boutput(usr, "<span class='notice'>The lights on the [R.name] seem more intense.</span>")

				else if (istype(O, /obj/machinery/cell_charger))	//Cell charger
					var/obj/machinery/cell_charger/R = O
					if (R.chargerate < CHARGER_MAX_CHARGE_RATE)
						R.chargerate += 250
						boutput(usr, "<span class='notice'>The lights on the [R.name] seem more intense.</span>")

				else if (istype(O, /obj/machinery/recharge_station))	//Borg docking station
					var/obj/machinery/recharge_station/R = O
					if (R.chargerate < CHARGER_MAX_CHARGE_RATE)
						R.chargerate += 300
						boutput(usr, "<span class='notice'>The lights on the [R.name] seem more intense.</span>")
			#undef CHARGER_MAX_CHARGE_RATE


		microbiology/biothermal
			name = "biothermal cells"
			id = "biothermal"
			description = "A slurry of various microorganisms: these ones seems to improve the properties of thermal equipment."
			fluid_r = 210
			fluid_g = 100
			fluid_b = 100
			transparency = 200
			data = "teporone"

				//(egg incu, chef stuff?, TEG, things that warm up)

			reaction_obj(var/obj/O, var/volume)
				..()

				if (istype(O, /obj/machinery/power/furnace/thermo))
					var/obj/machinery/power/furnace/thermo/F = O
					F.bio_bonus += volume * 0.1

				//else if (istype(O, /obj/machinery/chef_oven))
					//If only the recipes didnt depend on time as pointers

				//else if (istype(O, /obj/submachine/chicken_incubator))
					//I sure wish this was actually developed.

				//else if Nuclear?

		microbiology/bioemissive
			name = "bioemissive cells"
			id = "bioemissive"
			description = "A slurry of various microorganisms: these ones seems to improve the properties of emissive equipment."
			fluid_r = 120
			fluid_b = 5
			fluid_g = 200
			transparency = 120
			value = 4	//1 2 1
			//data = nuclear? radium?


			reaction_obj(var/obj/O, var/volume)
				..()
				// UV growlamps: improve speed buff
				if (istype(O, /obj/machinery/hydro_growlamp))
					var/obj/machinery/hydro_growlamp/HGL = O
					HGL.biochemupgrade = 2
					boutput(usr, "<span class='notice'>The radiation from the [HGL.name] feels stronger.</span>")
					return
				// radcollectors: increase energy collected
				if (istype(O, /obj/machinery/power/collector_control))
					var/obj/machinery/power/collector_control/cc = O
					cc.bio_bonus += volume
					return
				// Nuclear stuff?

				// PTL: increase money made
				if (istype(O, /obj/machinery/power/pt_laser))
					var/obj/machinery/power/pt_laser/ptl = O
					ptl.bio_bonus += volume
