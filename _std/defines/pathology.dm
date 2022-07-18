//PATHOLOGY REMOVAL
#define CREATE_PATHOGENS 1

// Uncomment to enable negative effects
// Use the shell to enable negative effects only for Classic
 #ifdef RP_MODE
 #else
 #define NEGATIVE_EFFECTS 2
 #endif

// Uncomment to stop natural diseases from showing the exact cure
#define REPORT_AND_DENATURALIZE_MICROBES 3

// Uncomment to set the default totalimmunity to FALSE
#define DEFAULT_TOTALIMMUNITY 4

// Uncomment to enable the Microbiologist job as an option
#define OPEN_MICROBIO_JOB 5
