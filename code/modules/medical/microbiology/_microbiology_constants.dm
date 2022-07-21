// Generation
#define MICROBIO_SHAPES list("stringy", "snake", "blob", "spherical", \
"tetrahedral", "star shaped", "tesselated")

#define MICROBIO_NAMINGLIST list("Disease", "Strain", "Plague", "Syndrome", \
"Bacteria", "Virions", "Parasites", "Contagion", "Scourge")

#ifdef RP_MODE
	// RP may have longer, drawn-out illnesses because RP is excluded from damaging and transmissible effects.
	// Consideration for the pace of RP
	#define MICROBIO_LOWERDURATIONVALUE 900		//seconds
	#define MICROBIO_UPPERDURATIONVALUE 1200	//seconds
#else
	#define MICROBIO_LOWERDURATIONVALUE 600		//seconds
	#define MICROBIO_UPPERDURATIONVALUE 900		//seconds
#endif

// Probability Factors
#define MICROBIO_MAXIMUMPROBABILITY 5 //between 1 and 5

// Effect-Adjusted Probability Factors
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_RARE 0.2
#define MICROBIO_EFFECT_PROBABILITY_FACTOR_UNCOMMON 0.5

// Transmission Types
#define MICROBIO_TRANSMISSION_TYPE_PHYSICAL "Physical"	//sweating
#define MICROBIO_TRANSMISSION_TYPE_AEROBIC "Aerobic"	//cough, congestion, beesneeze

// Transmission Alert Messages
#define MICROBIO_TRANSMISSION_GENERIC_MSG "<span class='alert'>You're starting to feel unwell. Maybe you should get a checkup.</span>"
#define MICROBIO_TRANSMISSION_TYPE_PHYSICAL_MSG "<span class='alert'>Ew, their hands feel really gross and sweaty!</span>"
#define MICROBIO_TRANSMISSION_TYPE_AEROBIC_MSG "<span class='alert'>A drop of saliva lands on your face.</span>"

// To limit microtesting:
#define MB_REACTION_MINIMUM 1

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
