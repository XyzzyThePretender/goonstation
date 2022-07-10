/proc/shakespearify(var/string)
	string = replacetext(string, "your ", "[pick("thy", "thine")] ")
	string = replacetext(string, " your", " [pick("thy", "thine")]")
	string = replacetext(string, " is ", " be ")
	string = replacetext(string, "you ", "thou ")
	string = replacetext(string, " you", " thou")
	string = replacetext(string, "are ", "art ")
	string = replacetext(string, " are", " art")
	string = replacetext(string, "do ", "doth ")
	string = replacetext(string, " do", " doth")
	string = replacetext(string, "does ", "doth ")
	string = replacetext(string, " does", " doth")
	string = replacetext(string, "she ", "the lady ")
	string = replacetext(string, " she", " the lady")
	string = replacetext(string, "i think", "methinks")
	return string

/obj/statue
	anchored = 0
	density = 1
	layer = MOB_LAYER
	var/mob/mob_inside

	Exited(atom/movable/AM, atom/newloc)
		. = ..()
		if(AM == src.mob_inside)
			boutput(src.mob_inside, "<span class='alert'>Some kind of force rips your statue-bound body apart.</span>")
			src.mob_inside.remove()
			src.mob_inside = null

	ex_act(severity)
		if(severity == 1)
			var/mob/M = src.mob_inside
			if(M)
				src.mob_inside = null
				M.emote("scream")
				M.emote("faint")
			src.visible_message("<span class='alert'><b>[src] shatters into a million tiny pieces!</b></span>")
			dothepixelthing(src)

/mob/proc/become_statue(var/datum/material/M, var/newDesc = null, survive=FALSE)
	var/obj/statue/statueperson = new /obj/statue(get_turf(src))
	src.pixel_x = 0
	src.pixel_y = 0
	src.set_loc(statueperson)
	statueperson.appearance = src.appearance
	statueperson.real_name = "statue of [src.name]"
	statueperson.name = statueperson.real_name
	if(newDesc)
		statueperson.real_desc = newDesc
	else
		statueperson.real_desc = src.get_desc()
	statueperson.desc = statueperson.real_desc
	statueperson.setMaterial(M)
	statueperson.set_dir(src.dir)
	if(!survive)
		src.remove()
	else
		statueperson.mob_inside = src
	return statueperson

/mob/proc/become_statue_ice()
	become_statue(getMaterial("ice"), "We here at Space Station 13 believe in the transparency of our employees. It doesn't look like a functioning human can be retrieved from this.")

/mob/proc/become_statue_rock()
	become_statue(getMaterial("rock"), "Its not too uncommon for our employees to be stoned at work but this is just ridiculous!")

/proc/add_random_custom_disease(var/datum/reagents/reagents, var/volume)
	var/datum/microbe/P = new /datum/microbe
	P.randomize()
	reagents.add_reagent("pathogen", volume)
	var/datum/reagent/blood/pathogen/R = reagents.get_reagent("pathogen")
	R.microbes[P.uid] = P
