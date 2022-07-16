/**
 * No tracking?
 *
 * I don't know if START_TRACKING/STOP_TRACKING should be used here.
 *
 * The controller holds a perfect list of all created microbe datums.
 * This centralized list is used for logging and pushing updates
 *
 */
/datum/microbe
	/// String-Num. Should not be changed in-game under any circumstances. Used as the key in associative lists.
	var/uid = ""

	var/name = ""
	var/desc = ""

	/// String-Hex. Used to color clouds on a successful aerobic transmission effect call.
	var/hexcolors = ""
	/// Number. Should not be changed in-game. Holds the time in seconds when the datum was created.
	var/creation_time = null

	/// Indexes mobs who are currently infected.
	var/mob/infected = list()

	/// Preserves the order of infection. Used for logging/investigation. Add to this list when a new mob is infected.
	var/mob/infectedhistory = list()
	/// Indexes mobs who no longer have this culture.
	var/mob/immune = list()

	/// Number. Counts how many more mobs the culture can infect. Prevents new infections at zero.
	var/infectioncount = 0
	/// Number. Holds the total number of potential infections. Only increase this when no active infections exist.
	var/infectiontotal = 0

	//Double check the implementation of the process() overall and ensure proper modernization
	/// Number. Holds the total duration in deciseconds (as manipulated by SECONDS).
	var/durationtotal = 0
	/// Datum-type. Holds the suppressant data.
	var/datum/suppressant/suppressant = null

	/// Datum-type non-associative list. Holds the effect datums in a list.
	var/list/datum/microbioeffects/effects = list()

	#ifdef REPORT_AND_DENATURALIZE_MICROBES
	var/artificial = TRUE
	var/reported = TRUE
	#else
	/// Boolean, default = FALSE. TRUE if the culture is synthesized with a machine. Safe to manipulate.
	var/artificial = FALSE

	/// Boolean, default = FALSE. TRUE if the culture is artificial OR a natural culture is successfully reported. Safe to manipulate.
	var/reported = FALSE
	#endif

	/// Set variables for counting effect types are more efficient than repetitive typechecks on demand.
	var/goodeffectcount = 0
	var/neutraleffectcount = 0
	var/badeffectcount = 0

	New()
		..()
		creation_time = round(world.time)		//deciseconds

// PROCS FOR GENERATION

	/// Atomized for disjointed creation methods (randomgen/TGUI/admincreator). Remember: never allow code to override a uid!
	proc/set_uid()
		src.uid = "[microbio_controls.next_uid]"
		microbio_controls.next_uid++

	/// Atomized for a 'reroll name' operation in TGUI/admincreator
	proc/generate_name()
		src.name = "[capitalize(pick_string_autokey("names/last.txt"))]'s [pick(MICROBIO_NAMINGLIST)]"
		return

	/// Atomized for rerolling convenience in admincreator
	proc/generate_effects()
		for (var/i in 1 to 3)
			var/check = FALSE
			do
				check = add_symptom(pick(microbio_controls.effects))
			while (!check)

	/// Atomized for rerolling in TGUI/admincreator
	proc/generate_cure()
		src.suppressant = pick(microbio_controls.cures)
		src.desc = "[suppressant.color] [pick(MICROBIO_SHAPES)] microbes"

	//Organizing this proc WIP
	proc/generate_attributes()
		src.hexcolors = random_hex()
		src.durationtotal = rand(MICROBIO_LOWERDURATIONVALUE, MICROBIO_UPPERDURATIONVALUE) SECONDS

		//Natural infection potentials should be determined by the number of living minds at the time of creation.
		//No idea how to do that yet.
		src.infectioncount = rand(6, 18)
		src.infectiontotal = src.infectioncount
		//Crew shortages could/should set natural cultures as fully reported.


	/// Called for naturally generated cultures.
	proc/randomize()
		set_uid()
		generate_name()
		generate_effects()
		generate_cure()
		generate_attributes()
		logTheThing("pathology", null, null, "Microbe culture [src.name] created by randomization.")
		microbio_controls.add_to_cultures(src)
		return

	/// Atomized for a full-reset operation by TGUI/admincreator. Never use this on existing cultures.
	proc/clear()
		src.name = ""
		src.desc = ""
		src.remove_symptom(null, all = TRUE)
		src.suppressant = null
		src.infectioncount = 0
		src.infectiontotal = 0
		src.durationtotal = 0

	/// Increments the corresponding catagory var, then adds the effect and applies effect_data.
	proc/add_symptom(var/datum/microbioeffects/E)
		if (!(E in effects))
			if (istype(E, /datum/microbioeffects/benevolent))
				src.goodeffectcount++

			else if (istype(E, /datum/microbioeffects/neutral))
				src.neutraleffectcount++

			else if (istype(E, /datum/microbioeffects/malevolent))
				src.badeffectcount++
			effects += E
			return TRUE
		else return FALSE

	/// if all is TRUE, removes all effects and zeroes the effect counters.
	proc/remove_symptom(var/datum/microbioeffects/E, var/all = FALSE)
		if (all)
			while (E in src.effects)
				src.effects -= E
			src.goodeffectcount = 0
			src.neutraleffectcount = 0
			src.badeffectcount = 0
			return TRUE

		else
			if (!(E in src.effects))
				return FALSE

			if (istype(E, /datum/microbioeffects/benevolent))
				src.goodeffectcount--
				src.effects -= E

			else if (istype(E, /datum/microbioeffects/neutral))
				src.neutraleffectcount--
				src.effects -= E

			else if (istype(E, /datum/microbioeffects/malevolent))
				src.badeffectcount--
				src.effects -= E

			return TRUE

ABSTRACT_TYPE(/datum/microbeplayerdata)
/datum/microbeplayerdata
	/// Holds the microbe datum. Receives updates through function push_to_players.
	var/datum/microbe/master = null
	/// Holds the infected mob.
	var/tmp/mob/living/affected_mob = null
	/// Number. Stores the running duration of the infection. Natural curing occurs when duration hits 0 or lower.
	var/duration = null
	/// Number. Stores the lag-adjusted probability calculated after effects are executed.
	var/probability = 0
	/// Boolean, default = FALSE. Set to TRUE when the cure criteria is met.
	var/iscured = FALSE

//!!! Get some help for this. !!!///

	//Double check the implementation of the process() overall and ensure proper modernization
	var/ticked = FALSE
	//Double check the implementation of the process() overall and ensure proper modernization
	var/tickmult = 1

	//Double check the implementation of the process() overall and ensure proper modernization
	//There is likely a better way to do this.
	proc/process(var/mult)
		if (ticked)
			ticked = FALSE
			tickmult = mult

	//Double check the implementation of the process() overall and ensure proper modernization
	proc/progress_pathogen(var/mob/M, var/datum/microbeplayerdata/P)
		ticked = TRUE

		if (!(P.duration))
			M.cured(P)
			return

		if (P.iscured)
			P.duration = 0.5 * P.duration - 1 SECONDS
			return

		var/B = MICROBIO_MAXIMUMPROBABILITY * 4 / P.master.durationtotal SECONDS	//seconds^-1
		var/A = B / P.master.durationtotal SECONDS	//seconds^-2
		var/X = P.duration * 0.1	//seconds

		if (!(P.tickmult))
			P.tickmult = 1

		// If we don't want 6 decimal places use ceil or round. ceil is more aggressive than round
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			P.probability = percentmult((-A * X**2 + B * X) / H.microbes.len, tickmult)
		else
			P.probability = percentmult(-A * X**2 + B * X, tickmult)

		P.iscured = P.master.suppressant.suppress_act(P)

		P.duration -= (P.tickmult ? P.tickmult : 1) SECONDS


	/// for loop through effects list in the master var, then progresses
	proc/mob_act(var/mob/M, var/datum/microbeplayerdata/S)
		for (var/datum/microbioeffects/effect in S.master.effects)
			effect.mob_act(M, S)
		progress_pathogen(M, S)

	/// it's like mob_act, but for dead people!
	proc/mob_act_dead(var/mob/M, var/datum/microbeplayerdata/S)
		for (var/datum/microbioeffects/effect in S.master.effects)
			effect.mob_act_dead(M, S)
		progress_pathogen(M, S)

///return FALSE on failure, TRUE after success
/mob/living/carbon/human/infected(var/datum/microbe/P)
	if (!(P.infectioncount))	//If the microbe has already infected to capacity, return
		return FALSE
	if (isdead(src))	//Don't infect dead people
		return FALSE
	if (ischangeling(src) || isvampire(src))	// Vampires were missing here. They're immune to old-style diseases too (Convair880).
		return FALSE
	if (src.totalimmunity)	//Has the player opted out of the system?
		return FALSE
	if (src.microbes.len >= MICROBIO_INDIVIDUALMICROBELIMIT)	//Is the player completely saturated with cultures?
		return FALSE
	if (src in P.immune)	//Is the player listed as immune to this specific culture?
		return FALSE
	if (!(src in P.infected))	//If the player isn't already infected by this culture...
		P.infected += src
		P.infectedhistory += src
		P.infectioncount--
		microbio_controls.push_to_upstream(P, src)	// Put in earliest possible order
		// These go after the push to avoid a redundant update
		var/datum/microbeplayerdata/Q = new /datum/microbeplayerdata
		src.microbes[P.uid] = Q
		Q.master = P
		Q.affected_mob = src
		Q.duration = P.durationtotal
		logTheThing("pathology", src, null, "is infected by [Q.master.name] (uid: [P.uid]).")
		return TRUE
	return FALSE

///return FALSE on failure, TRUE after success
/mob/living/carbon/human/cured(var/datum/microbeplayerdata/S)
	if (!istype(S) || !S.master)	//Sanity check the input
		return FALSE
	S.master.infected -= src
	S.master.immune += src
	src.microbes[S.master.uid] = null	//put in disposing() ?
	src.microbes -= S.master.uid
	var/datum/microbe/P = S.master	// Might be unnecessary, but explicitly defines the input type
	microbio_controls.push_to_upstream(P)	//Update elsewhere about cure
	logTheThing("pathology", src, null, "is cured of and gains immunity to [P.name] (uid: [P.uid]).")
	qdel(S)
	boutput(src, "<span class='notice'>You feel that the disease has passed.</span>")
	return TRUE
