// jarvis.prg minimo para compilar un modulo de obra suelto con probar.sh.
// Copiar a la carpeta de prueba junto con misc.prg y el modulo; ajustar defines e instancias.
#pragma size dev 16000
#pragma size string 65000
#pragma size code 96000
#define AUTOM_VERSION "1a"
string ver = "prueba";
#define INTERVAL_STADISTICS     10
#define INTERVAL_IO             5
#define INTERVAL_ANALOG         3
#define INTERVAL_CHECK          3
msg_t MSG_MODBUS;
msg_t MSG_ETHRAW;
msg_t MSG_JETIO;
#include "misc.prg"
CTRL ctrl;
// Modulo a probar: sus N_XXX antes del include, sus instancias y configuracion despues
#define N_CO 2
#include "fan_meters.prg"
A_CO co[N_CO];
co[0].tp = ANA_JETIO;
