// Spread flags. Determines what slots are taken into account during a permeability scan.
#define SPREAD_FACE 1
#define SPREAD_BODY 2
#define SPREAD_HANDS 4
#define SPREAD_AIR 8


//Generation

#define MICROBIO_NAMINGLIST list("Disease", "Strain", "Plague", "Syndrome", "Virions")

#define MICROBIO_LOWERDURATIONVALUE 240	//seconds
#define MICROBIO_UPPERDURATIONVALUE 480	//seconds

#define MICROBIO_INDIVIDUALMICROBELIMIT 3

// Probability Handling
#define MICROBIO_DEFAULTPROBABILITYDIVIDEND 5
#define MICROBIO_MAXIMUMPROBABILITY 5
#define MICROBIO_MICROBEWEIGHTEDPROBABILITYDIVIDEND 2


// More Probability Factors, effectively the old rarity system
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_OHGODHELP 0.01
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_HORRIFYING 0.1
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE 0.2
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON 0.5


// Transmission Types
#define MICROBIO_TRANSMISSION_TYPE_PHYSICAL "Physical"
#define MICROBIO_TRANSMISSION_TYPE_AEROBIC "Aerobic"

// EFFECT STRINGS

#define MICROBIO_SWEATING_EFFECT_MESSAGES list("<span class='alert'>You feel a bit warm.</span>", \
"<span class='alert'>You feel rather warm.</span>", \
"<span class='alert'>You're sweating heavily.</span>", \
"<span class='alert'>You're soaked in your own sweat.</span>")

// CURE-RELATED DEFINES
#define REAGENT_CURE_THRESHOLD 10

#define MICROBIO_CURE_PROBABILITY_FACTOR 100

//Reagent Catagories

#define MB_BRUTE_MEDS_CATAGORY list("styptic_powder", "synthflesh", "analgesic")
#define MB_BURN_MEDS_CATAGORY list("silver_sulfadiazine", "synthflesh", "menthol")
#define MB_TOX_MEDS_CATAGORY list("anti_rad", "penteticacid", "charcoal", "antihol")
#define MB_OXY_MEDS_CATAGORY list("iron", "salbutamol", "epinephrine", "atropine", "perfluorodecalin")

#define MB_SEDATIVES_CATAGORY list("haloperidol", "morphine", "neurotoxin", "ethanol", "lithium", "ether", "ketamine")
#define MB_STIMULANTS_CATAGORY list("smelling_salt", "epinephrine", "sugar", "ephedrine", "synaptizine", "methamphetamine")

#define MB_HOT_REAGENTS list("phlogiston", "infernite")
#define MB_COLD_REAGENTS list("cryostylane", "cryoxadone")

#define MB_ACID_REAGENTS list("acid", "clacid", "pacid")
//yoinked from the artifact injector code
#define MB_TOXINS_REAGENTS list("chlorine","fluorine","lithium","mercury","plasma","radium","uranium","strange_reagent",\
"amanitin","coniine","cyanide","curare","formaldehyde","lipolicide","initropidril","cholesterol","itching","pancuronium","polonium",\
"sodium_thiopental","ketamine","sulfonal","toxin","venom","neurotoxin","mutagen","wolfsbane","toxic_slurry","histamine","sarin")

#define MB_BRAINDAMAGE_REAGENTS list("mercury","neurotoxin","haloperidol","sarin")

// MACHINE DEFINES

// Synthomatic

#define BIOCHEMISTRY_PRODUCTION_LOWER_BOUND 5
#define BIOCHEMISTRY_PRODUCTION_UPPER_BOUND 8

// Inspection Responses



#define MICROBIO_INSPECT_LIKES_GENERIC "The microbes are moving towards the area affected by the reagent!"

#define MICROBIO_INSPECT_LIKES_POWERFUL_EFFECT "The microbes are rapidly encircling the reagent!"

#define MICROBIO_INSPECT_DISLIKES_GENERIC "The microbes seem to shut down in the presence of the solution!"

#define MICROBIO_INSPECT_DISLIKES_POWERFUL_EFFECT "The microbes are attemping to escape from the area affected by the reagent!"


#define MICROBIO_INSPECT_HIT_CURE "The microbes in the test reagent are rapidly withering away!"

// Other constants
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
