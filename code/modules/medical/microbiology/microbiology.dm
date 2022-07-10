/datum/microbe

	var/name = ""
	var/uid = ""
	var/desc = ""

	var/hexcolors = ""

	var/creation_time = null

	var/mob/infected = list()
	var/mob/infectedhistory = list()
	var/mob/immune = list()

	var/infectioncount = 0
	var/infectiontotal = 0
	var/durationtotal = 0

	var/datum/suppressant/suppressant = null

	var/list/datum/microbioeffects/effects = list()
	var/list/effectdata = list()

	var/artificial = FALSE
	var/reported = FALSE

	var/goodeffectcount = 0
	var/neutraleffectcount = 0
	var/badeffectcount = 0

	//idk if this is necessary nor why if it is
	New()
		..()
		creation_time = round(world.time*0.1)

// PROCS AND FUNCTIONS FOR GENERATION

	proc/generate_name()
		src.name = "[capitalize(pick_string_autokey("names/last.txt"))]'s [pick(MICROBIO_NAMINGLIST)]"
		return

	proc/set_uid()
		src.uid = "[microbio_controls.next_uid]"
		microbio_controls.next_uid++

	//Unfiltered random
	proc/generate_effects()
		for (var/i in 1 to 3)
			var/check = 0
			do
				check = add_symptom(pick(microbio_controls.effects))
			while (!check)

	proc/generate_cure()
		src.suppressant = pick(microbio_controls.cures)

	proc/generate_attributes()
		var/shape = pick("stringy", "snake", "blob", "spherical", "tetrahedral", "star shaped", "tesselated")
		src.desc = "[suppressant.color] [shape] microbes" //color determined by average of cure reagent and assigned-effect colors
		src.hexcolors = random_hex()
		src.durationtotal = rand(MICROBIO_LOWERDURATIONVALUE,MICROBIO_UPPERDURATIONVALUE) SECONDS
		src.infectioncount = rand(6,18)
		src.infectiontotal = src.infectioncount
		src.artificial = 0
		src.reported = 0

	proc/randomize()
		generate_name()
		set_uid()
		generate_effects()
		generate_cure()
		generate_attributes()
		logTheThing("pathology", null, null, "Microbe culture [name] created by randomization.")
		microbio_controls.add_to_cultures(src)
		return

	proc/clear()
		src.name = ""
		src.remove_symptom(null, all = TRUE)
		src.suppressant = null
		src.infectiontotal = 0
		src.durationtotal = 0

	proc/add_symptom(var/datum/microbioeffects/E)
		if (!(E in effects))
			if (istype(E,/datum/microbioeffects/benevolent))
				src.goodeffectcount++

			else if (istype(E,/datum/microbioeffects/neutral))
				src.neutraleffectcount++

			else if (istype(E,/datum/microbioeffects/malevolent))
				src.badeffectcount++

			effects += E
			E.onadd(src)
			return 1
		else return 0

	proc/remove_symptom(var/datum/microbioeffects/E, var/all = FALSE)
		if (all)
			while (E in src.effects)
				src.effects -= E
			src.effectdata = list()
			src.goodeffectcount = 0
			src.neutraleffectcount = 0
			src.badeffectcount = 0
			return 1

		else
			if (!(E in src.effects))
				return 0

			if (istype(E,/datum/microbioeffects/benevolent))
				src.goodeffectcount--
				src.effects -= E

			else if (istype(E,/datum/microbioeffects/neutral))
				src.neutraleffectcount--
				src.effects -= E

			else if (istype(E,/datum/microbioeffects/malevolent))
				src.badeffectcount--
				src.effects -= E

			return 1


ABSTRACT_TYPE(/datum/microbeplayerdata)
/datum/microbeplayerdata
	var/datum/microbe/master = null
	var/tmp/mob/living/affected_mob = null
	var/duration
	var/probability
	var/ticked
	var/iscured
	var/tickmult

	New()
		..()
		duration = null
		probability = null
		ticked = FALSE
		iscured = FALSE

	//There is likely a better way to do this.
	proc/process(var/mult)
		if (ticked)
			ticked = FALSE
			tickmult = mult

	proc/progress_pathogen(var/mob/M, var/datum/microbeplayerdata/P)
		ticked = TRUE
		if (!(P.duration))
			M.cured(P)
			return

		if (iscured)
			P.duration = ceil(P.duration/2) - 1 SECONDS
			return

		var/B = MICROBIO_MAXIMUMPROBABILITY*4/P.master.durationtotal
		var/A = B/P.master.durationtotal
		if (!(tickmult))
			tickmult = 1
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			P.probability = tickmult*(ceil(-A*P.duration**2+B*P.duration))/(MICROBIO_MICROBEWEIGHTEDPROBABILITYDIVIDEND*H.microbes.len)
		else
			P.probability = tickmult*(ceil(-A*P.duration**2+B*P.duration))/MICROBIO_DEFAULTPROBABILITYDIVIDEND

		iscured = P.master.suppressant.suppress_act(P)

		P.duration -= tickmult ? tickmult SECONDS : 1 SECONDS

	proc/mob_act(var/mob/M, var/datum/microbeplayerdata/S)
		for (var/datum/microbioeffects/effect in S.master.effects)
			effect.mob_act(M,S)
		progress_pathogen(M,S)

	// it's like mob_act, but for dead people!
	proc/mob_act_dead(var/mob/M, var/datum/microbeplayerdata/S)
		for (var/datum/microbioeffects/effect in S.master.effects)
			effect.mob_act_dead(M,S)
		progress_pathogen(M,S)


/mob/living/carbon/human/infected(var/datum/microbe/P)
	if (!(P.infectioncount)) //If the microbe has already infected to capacity, return
		return 0
	if (isdead(src))
		return 0
	if (ischangeling(src) || isvampire(src)) // Vampires were missing here. They're immune to old-style diseases too (Convair880).
		return 0
	if ((src in P.immune) || (src in P.infected))
		return 0
	if (src.totalimmunity)
		return 0
	if (src.microbes.len >= MICROBIO_INDIVIDUALMICROBELIMIT)
		return 0
	if (!(src in P.infected))
		P.infected += src
		P.infectedhistory += src
		P.infectioncount--
		microbio_controls.push_to_upstream(P, src)	// Put in earliest possible order so as to prevent a "merge conflict"
		// These go after the push to avoid redundancies
		var/datum/microbeplayerdata/Q = new /datum/microbeplayerdata
		src.microbes[P.uid] = Q
		Q.master = P
		Q.affected_mob = src
		Q.duration = P.durationtotal--
		Q.probability = 0
		logTheThing("pathology", src, null, "is infected by [Q.master.name] (uid: [P.uid]).")
		return 1
	else
		return 0

/mob/living/carbon/human/cured(var/datum/microbeplayerdata/S)
	if (!istype(S) || !S.master)
		return 0
	S.master.infected -= src
	S.master.immune += src
	src.microbes[S.master.uid] = null	//put in disposing() ?
	src.microbes -= S.master.uid
	var/datum/microbe/P = S.master					// Might be unnecessary, but explicitly defines the input type
	microbio_controls.push_to_upstream(P)
	logTheThing("pathology", src, null, "is cured of and gains immunity to [P.name] (uid: [P.uid]).")
	qdel(S)
	boutput(src, "<span class='notice'>You feel that the disease has passed.</span>")
	return 1
