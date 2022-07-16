// Generation

#define MICROBIO_SHAPES list("stringy", "snake", "blob", "spherical", \
"tetrahedral", "star shaped", "tesselated")

#define MICROBIO_NAMINGLIST list("Disease", "Strain", "Plague", "Syndrome", \
"Bacteria", "Virions", "Fungi", "Parasites", "Contagion", "Scourge")

#ifdef RP_MODE
	#define MICROBIO_LOWERDURATIONVALUE 900		//seconds
	#define MICROBIO_UPPERDURATIONVALUE 1200	//seconds
#else
	#define MICROBIO_LOWERDURATIONVALUE 600		//seconds
	#define MICROBIO_UPPERDURATIONVALUE 900		//seconds
#endif

// Could be a var in human.dm
#define MICROBIO_INDIVIDUALMICROBELIMIT 3

// Probability Factors

#define MICROBIO_MAXIMUMPROBABILITY 3 //between 1 and 5

// Effect-Specific Probability Factors, effectively the old rarity system

#define MICROBIO_EFFECT_PROBABILITY_FACTOR_OHGODHELP 0.01
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_HORRIFYING 0.1
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE 0.2
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON 0.5

// Transmission Types

#define MICROBIO_TRANSMISSION_TYPE_PHYSICAL "Physical"	//sweating
#define MICROBIO_TRANSMISSION_TYPE_AEROBIC "Aerobic"	//cough, sneeze, beesneeze

// Transmission Alert Messages

#define MICROBIO_TRANSMISSION_GENERIC_MSG "<span class='alert'>You're starting to feel unwell. Maybe you should get a checkup.</span>"
#define MICROBIO_TRANSMISSION_TYPE_PHYSICAL_MSG "<span class='alert'>Ew, their hands feel really gross and sweaty!</span>"
#define MICROBIO_TRANSMISSION_TYPE_AEROBIC_MSG "<span class='alert'>A drop of saliva lands on your face.</span>"

// Cure Defines

// Cure Reagent Catagories
// Be mindful of allergies.

// Big Four: Medications
#define MB_BRUTE_MEDS_CATAGORY list("analgesic", "omnizine", "styptic_powder", "saline", "synthflesh")
#define MB_BURN_MEDS_CATAGORY list("menthol", "omnizine", "silver_sulfadiazine", "saline", "synthflesh")
#define MB_TOX_MEDS_CATAGORY list("anti_rad", "antihol", "charcoal",  "omnizine", "penteticacid", "cocktail_citrus")
#define MB_OXY_MEDS_CATAGORY list("atropine", "epinephrine", "iron", "omnizine", "perfluorodecalin", "salbutamol")

// Drugs
#define MB_SEDATIVES_CATAGORY list("capulettium", "capulettium_plus", "ethanol", "ether", "haloperidol", \
"ketamine", "lithium", "morphine", "neurodepressant")
#define MB_STIMULANTS_CATAGORY list("smelling_salt", "ephedrine", "epinephrine", "methamphetamine", "sugar", \
"synaptizine", "synd_methamphetamine", "triplemeth")
// Because botany almost always makes weed...
#define MB_HALLUCINOGENICS_CATAGORY list("cold_medicine", "lysergic acid diethylamide", "psilocybin", "space drugs", "THC")

// Therapies
#define MB_HOT_REAGENTS list("phlogiston", "infernite")
#define MB_COLD_REAGENTS list("cryostylane", "cryoxadone")

// Inspection Groups
// NEVER use these for cures!

#define MB_ACID_REAGENTS list("acetic_acid", "acid", "clacid", "pacid")

#define MB_METABOLISM_REAGENTS list("antihol", "calomel", "charcoal", "haloperidol", "hunchback", "insulin", "penteticacid", \
"smelling_salt", "water")

#define MB_TOXINS_REAGENTS list("chlorine", "fluorine", "lithium", "mercury", "plasma", "cyanide", \
"formaldehyde", "sulfonal", "histamine")

#define MB_BRAINDAMAGE_REAGENTS list("capulettium", "capulettium_plus", "haloperidol", "mercury", "neurotoxin", "sarin")

// Inspection Responses

#define MICROBIO_INSPECT_LIKES_GENERIC "The microbes are moving towards the area affected by the reagent!"

#define MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT "The microbes are rapidly encircling the reagent!"

#define MICROBIO_INSPECT_DISLIKES_GENERIC "The microbes seem to shut down in the presence of the solution!"

//unused
#define MICROBIO_INSPECT_DISLIKES_POWERFUL_EFFECT "The microbes are attemping to escape from the area affected by the reagent!"

#define MICROBIO_INSPECT_HIT_CURE "The microbes in the test reagent are rapidly withering away!"

// Machine Defines

// Synthomatic

#define BIOCHEMISTRY_PRODUCTION_LOWER_BOUND 5
#define BIOCHEMISTRY_PRODUCTION_UPPER_BOUND 8

// Unused
#define MICROBIO_SHAKESPEARE list("Expectation is the root of all heartache.",\
"A fool thinks himself to be wise, but a wise man knows himself to be a fool.",\
"Love all, trust a few, do wrong to none.",\
"Hell is empty and all the devils are here.",\
"Better a witty fool than a foolish wit.",\
"The course of true love never did run smooth.",\
"Come, gentlemen, I hope we shall drink down all unkindness.",\
"Suspicion always haunts the guilty mind.",\
"No legacy is so rich as honesty.",\
"Alas, I am a woman friendless, hopeless!",\
"The empty vessel makes the loudest sound.",\
"Words without thoughts never to heaven go.",\
"This above all; to thine own self be true.",\
"An overflow of good converts to bad.",\
"It is a wise father that knows his own child.",\
"Listen to many, speak to a few.",\
"Boldness be my friend.",\
"Speak low, if you speak love.",\
"Give thy thoughts no tongue.",\
"The devil can cite Scripture for his purpose.",\
"In time we hate that which we often fear.",\
"The lady doth protest too much, methinks.")
