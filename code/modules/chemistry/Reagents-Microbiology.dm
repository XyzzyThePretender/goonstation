ABSTRACT_TYPE(/datum/reagent/microbiology)

datum
	reagent
		microbiology/
			name = "germs"
			id = "germs"
			data = null
			var/minimum_required_volume = 4.5

			reaction_obj(var/obj/O, var/volume)
				if (src.volume < minimum_required_volume)
					return

		microbiology/exclusiveimmunity
			name = "Toggleable Immunizers"
			id = "exlusiveimmunity"
			description = "A culture of germs: this one allows a person to choose if they wish to interact with custom microbes. Works on ingestion."
			taste = "sharp"
			fluid_r = 7
			fluid_b = 7
			fluid_g = 7
			transparency = 7
			value = 6	// 3 2 1
			data = "spaceacillin"
			var/special_chem_processed = FALSE

			reaction_mob(var/mob/M, var/method=INGEST, var/volume_passed)
				if (!(istype(M, /mob/living/carbon/human)))
					return
				var/mob/living/carbon/human/H = M
				if (!(H.totalimmunity) && !(special_chem_processed))
					H.totalimmunity = TRUE
					boutput(M, "<span class='notice'>You feel protected from weird germs.</span>")
				else
					H.totalimmunity = FALSE
					boutput(M, "<span class='alert'>You no longer feel protected from weird germs.</span>")
				special_chem_processed = TRUE
				..()

		microbiology/photovoltaic
			name = "photovoltaic cyanobacteria"
			id = "photovoltaic"
			description = "A culture of germs: this one seems to improve the performance of solar panels."
			taste = "sandy"
			fluid_r = 50
			fluid_b = 150
			fluid_g = 180
			transparency = 50
			value = 4 			//1 2 1 	//Take value of egg = 1
			data = "silicate"

			reaction_obj(var/obj/O, var/volume)
				..()
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

				if (istype(O, /obj/machinery/hydro_growlamp))
					var/obj/machinery/hydro_growlamp/HGL = O
					HGL.biochemupgrade = 2
					boutput(usr, "<span class='notice'>The radiation from the [HGL.name] feels stronger.</span>")

		microbiology/meatspikehelper
			name = "swill-reclaiming parasites"
			id = "meatspikehelper"
			description = "A culture of parasites: this one seems to facilitate meat extraction. It seems to require the presence of meat."
			taste = "greasy"
			fluid_r = 120
			fluid_b = 15
			fluid_g = 20
			transparency = 100
			value = 12		//9 2 1
			data = "synthflesh"

			reaction_obj(var/obj/O, var/volume)
				..()
				if (istype(O,/obj/kitchenspike))
					var/obj/kitchenspike/K = O
					if (K.meat <= 1)
						return
					if (!K.occupied)
						return
					boutput(usr, "<span class='notice'>You think you can extract a little more meat from the spike.</span>")
					K.meat += 3

		microbiology/plainarmor
			name = "regenerative synthreads"
			id = "plainarmor"
			description = "A culture of germs: this one seems to improve the defensive qualities of large clothing."
			fluid_r = 20
			fluid_b = 20
			fluid_g = 20
			transparency = 10
			value = 7	// 4 2 1
			data = "carpet"

			reaction_obj(var/obj/O, var/volume)
			#define HEADGEAR_MAX_MELEE_UPGRADE 5		//nukie knight 6, slowdown (EOD, swat, etc.) 7+
			#define HEADGEAR_MELEE_INCREMENT 1			//hats average 0-2 prot
			#define GLOVES_MAX_CONDUCTIVITY_UPGRADE 0.3	//Scaled multiplier: 0-1, affects shock damage. 0 is insulated
			#define GLOVES_CONDUCTIVITY_DECREMENT 0.1	//approx. 50-35-15 dist. uninsul-partial-insul
			#define GENERAL_MELEE_INCREMENT 1
			#define GENERAL_MAX_MELEE_UPGRADE 5			//suits and coats avg around 3-4, proper armor avg around 6-8
			#define MAX_EXPLO_UPGRADE 5					//0-100 scale, 100 being immunity. Very few clothes offer exploprot.
			#define EXPLO_INCREMENT 1
			#define RANGED_INCREMENT 0.25				//numeric scale, 1->inf. Most clothes with rangedprot do not go past 1.
			#define MAX_RANGED_UPGRADE 0.5				//Assume someone tries to minmax shoes, uniform, outer layer, and hat. Give 2 total.
				..()
				if (!(istype(O, /obj/item/clothing)))
					return
				if (istype(O, /obj/item/clothing/glasses) || istype(O,/obj/item/clothing/mask))
					boutput(usr, "<span class='alert'>The [O.name] is too small to support the regenerative synthreads...</span>")
					return
				if (istype(O, /obj/item/clothing/head/helmet))	//head melee + explo + ranged
					var/obj/item/clothing/head/helmet/C = O
					var/melee = C.getProperty("meleeprot_head")	//unnecessary, but it's easier to comprehend the code this way
					if (melee <= HEADGEAR_MAX_MELEE_UPGRADE)
						melee = min(melee + HEADGEAR_MELEE_INCREMENT, HEADGEAR_MAX_MELEE_UPGRADE)
						C.setProperty("meleeprot_head", melee)

					var/explo = C.getProperty("exploprot")
					if (explo <= MAX_EXPLO_UPGRADE)
						explo = min(explo + EXPLO_INCREMENT, MAX_EXPLO_UPGRADE)
						C.setProperty("exploprot", explo)

					var/ranged = C.getProperty("rangedprot")
					if (ranged <= MAX_RANGED_UPGRADE)
						ranged = min(ranged + RANGED_INCREMENT, MAX_RANGED_UPGRADE)
						C.setProperty("rangedprot", ranged)

				else if (istype(O, /obj/item/clothing/head)) //head melee + ranged
					var/obj/item/clothing/head/C = O
					var/melee = C.getProperty("meleeprot_head")
					if (melee <= HEADGEAR_MAX_MELEE_UPGRADE)
						melee = min(melee + HEADGEAR_MELEE_INCREMENT, HEADGEAR_MAX_MELEE_UPGRADE)
						C.setProperty("meleeprot_head", melee)

					var/ranged = C.getProperty("rangedprot")
					if (ranged <= MAX_RANGED_UPGRADE)
						ranged = min(ranged + RANGED_INCREMENT, MAX_RANGED_UPGRADE)
						C.setProperty("rangedprot", ranged)

				else if (istype(O, /obj/item/clothing/gloves))	//conductivity
					var/obj/item/clothing/gloves/C = O
					var/conductivity = C.getProperty("conductivity")
					if (conductivity >= GLOVES_MAX_CONDUCTIVITY_UPGRADE)
						conductivity = min(conductivity - GLOVES_CONDUCTIVITY_DECREMENT, GLOVES_MAX_CONDUCTIVITY_UPGRADE)
						C.setProperty("conductivity", conductivity)

				else	//regular melee + explo + ranged
					var/obj/item/clothing/C = O
					var/melee = C.getProperty("meleeprot")
					if (melee <= GENERAL_MAX_MELEE_UPGRADE)
						melee = min(melee + GENERAL_MELEE_INCREMENT, GENERAL_MAX_MELEE_UPGRADE)
						C.setProperty("meleeprot", melee)

					var/explo = C.getProperty("exploprot")
					if (explo <= MAX_EXPLO_UPGRADE)
						explo = min(explo + EXPLO_INCREMENT, MAX_EXPLO_UPGRADE)
						C.setProperty("exploprot", explo)

					var/ranged = C.getProperty("rangedprot")
					if (ranged <= MAX_RANGED_UPGRADE)
						ranged = min(ranged + RANGED_INCREMENT, MAX_RANGED_UPGRADE)
						C.setProperty("rangedprot", ranged)

				boutput(usr, "<span class='notice'>The [O.name] looks much sturdier.</span>")
			#undef HEADGEAR_MAX_MELEE_UPGRADE
			#undef HEADGEAR_MELEE_INCREMENT
			#undef GLOVES_MAX_CONDUCTIVITY_UPGRADE
			#undef GLOVES_CONDUCTIVITY_DECREMENT
			#undef GENERAL_MELEE_INCREMENT
			#undef GENERAL_MAX_MELEE_UPGRADE
			#undef MAX_EXPLO_UPGRADE
			#undef EXPLO_INCREMENT
			#undef RANGED_INCREMENT
			#undef MAX_RANGED_UPGRADE

		microbiology/rcdregen
			name = "dense matter autotrophes"
			id = "rcdregen"
			description = "A culture of germs: this one seems to improve the efficiency of an RCD."
			taste = "heavy"
			fluid_r = 25
			fluid_b = 100
			fluid_g = 200
			transparency = 240
			value = 9	// 6 2 1
			data = "ldmatter"

			reaction_obj(var/obj/O, var/volume)
				..()
				if (istype(O, /obj/item/rcd))
					var/obj/item/rcd/R = O
					/* construction cost and time */
					R.matter_create_wall = max(1, R.matter_create_wall--)
					R.time_create_wall = max(3, R.time_create_wall--) SECONDS
					R.matter_reinforce_wall = max(1, R.matter_reinforce_wall--)
					R.time_reinforce_wall = max(4, R.time_reinforce_wall--) SECONDS
					R.time_create_wall_girder = 1 SECONDS
					R.matter_create_door = max(2, R.matter_create_door--)
					R.time_create_door = max(3, R.time_create_door--) SECONDS
					R.matter_create_window = 1
					R.time_create_window = 1 SECONDS
					R.matter_create_light_fixture = max(0.5, R.matter_create_light_fixture--)
					R.time_create_light_fixture = max(0.5, R.time_create_light_fixture--) SECONDS
					//No deconstruction buffs because the big grief potential (spacing air + delimbing)
					boutput(usr, "<span class='notice'>The RCD feels lighter, but the ammo indicator hasn't changed.</span>")

		microbiology/bioopamp
			name = "operational-bioamplifiers"
			id = "bioopamp"
			description = "A culture of germs: this one seems to boost the electrical current in rechargers."
			taste = "fizzy"
			fluid_r = 200
			fluid_b = 5
			fluid_g = 120
			transparency = 120
			value = 4	//1 2 1
			data = "copper"

			reaction_obj(var/obj/O, var/volume)
			#define CHARGER_MAX_CHARGE_RATE 1000	//2-3 times faster charge for cells, borgs!
				..()
				if (istype(O, /obj/machinery/recharger))	//Tool charger
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

		microbiology/drycleaner
			name = "organic sanitizer"
			id = "drycleaner"
			description = "A culture of germs: this one seems to live on fabrics and feeds off of filth."
			taste = "slimy"
			fluid_r = 130
			fluid_b = 170
			fluid_g = 115
			transparency = 125
			value = 7	//4 2 1
			data = "cleaner"

			reaction_obj(var/obj/O, var/volume)
				..()
				if(!(istype(O,/obj/item/clothing)))
					return
				var/obj/item/clothing/C = O
				if (C.can_stain)
					C.can_stain = 0
					boutput(usr, "<span class='notice'>You see some stains fading from the [C]. A washing would help.</span>")
