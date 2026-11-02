/*
 * INSTALACION  : <obra>
 * DESCRIPCION  : Integracion de <equipo> por TCP (driver ethraw), polling
 *
 * Plantilla skill jarvis basada en fire_apsensing.prg (islares/hoz).
 * Requiere: MSG_ETHRAW declarado y #driver "ethraw -m MSG_ETHRAW".
 */

#define XX_TIMEOUT      3       // Espera de respuesta (s)
#define XX_POLL         3       // Pausa entre ciclos de lectura (s)
#define XX_RETRY        5       // Reintentos antes de dar fallo

// Estado de la comunicacion
enum XX_CTRL
{
    XXC_INIT,                   // Iniciando
    XXC_CORRECT,                // Correcto
    XXC_FAIL                    // Fallo comunicacion
};

// Pasos de lectura
enum XX_READ
{
    XXR_STATUS,
    XXR_DATA,
    XXR_TOTAL
};

struct XX_REGISTER
{
    XX_READ read;               // Paso
    int fun;                    // Funcion
    int addr;                   // Direccion
    int cnt;                    // Cantidad
};

XX_REGISTER xx_reg[XXR_TOTAL] = {
    { XXR_STATUS,   3,  0,      1 },
    { XXR_DATA,     3,  100,    10 },
};

#define XXWORD(n) (int) ((in[9+(n)*2] << 8) | in[10+(n)*2])

autom A_XXCOM
{
    // Hardware
    string output volatile out;
    char input in[256];
    bool eth;

    // Proceso
    XX_READ step;
    int r_comm, trans;

    // CAS
    XX_CTRL cas;

    // Peticion (ejemplo: Modbus TCP hecho a mano)
    void ask()
    {
        int w;
        w = 0;
        out[w++] = trans >> 8;          // Transaccion
        out[w++] = trans;
        trans++;
        out[w++] = 0;                   // Protocolo
        out[w++] = 0;
        out[w++] = 0;                   // Longitud
        out[w++] = 6;
        out[w++] = 1;                   // Id
        out[w++] = xx_reg[step].fun;
        out[w++] = xx_reg[step].addr >> 8;
        out[w++] = xx_reg[step].addr & 0xFF;
        out[w++] = xx_reg[step].cnt >> 8;
        out[w++] = xx_reg[step].cnt;
        out.setlength(w);
        if (eth) out.validate();
    }

    // Validacion de respuesta
    bool chk()
    {
        return in[6] == 1 && in[7] == xx_reg[step].fun;
    }

    // Decodificacion segun paso
    void decode()
    {
        switch (step) {
        case XXR_STATUS:
            break;
        case XXR_DATA:
            break;
        }
    }

    // Conexion ETHRAW
    msg MSG_ETHRAW (st)
    {
#ifndef SIM
        eth = st;
        if (!st) {
            log cas.desc(), " -- ethraw desconectado\n";
            if (cas != XXC_FAIL) cas = XXC_FAIL;
        }
#endif
    }

    stat init
    {
#ifdef SIM
        cas = XXC_CORRECT;
        cas.validate();
#else
        ontime (XX_POLL) -> run;
#endif
    }

    stat run
    {
        ontime (XX_POLL) {
            step = -1;
            -> poll;
        }
    }

    stat poll
    {
        if (++step >= XXR_TOTAL) -> run;
        else -> query;
    }

    stat query
    {
        ask();

        ontime (XX_TIMEOUT) {
            if (cas != XXC_FAIL && r_comm++ > XX_RETRY) {
                warning cas.desc(), " -- Fallo comunicacion!\n";
                cas = XXC_FAIL;
            }
            -> run;
        }

        when in {
            if (chk()) {
                r_comm = 0;
                if (cas != XXC_CORRECT) cas = XXC_CORRECT;
                decode();
            }
            -> poll;
        }
    }
};

/*
 * jarvis.dev:
 *
 * .ethraw 192.168.0.90:502,tcp,silent=30
 * xxcom.in
 * xxcom.out
 * .ethraw
 *
 * IMPORTANTE: poner siempre silent=N (30-120 s en las obras). Sin el, ethraw corta la conexion a los 5 s
 * sin datos recibidos y el primer sondeo (a los XX_POLL*2 s) nunca llega a hacerse.
 */

/* vim: set et ts=4 sw=4 sts=4: */
