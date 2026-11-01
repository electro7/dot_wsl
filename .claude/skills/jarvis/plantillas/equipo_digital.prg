/*
 * INSTALACION  : <obra>
 * DESCRIPCION  : <Equipo> con mando y retorno por entradas/salidas digitales
 *
 * Plantilla skill jarvis. Sustituir EQ/eq por el prefijo del equipo.
 * Requiere: misc.prg (TUBE, ZONE, USE), INTERVAL_CHECK, MSG_MODBUS.
 */

#ifndef N_EQ
#pragma error "[EQ] - Falta definir el numero de equipos (N_EQ).";
#endif

// Estados
// ------------------------------------------------------------------
enum EQ
{
    EQ_OFF,                     // Apagado automatico
    EQ_ON,                      // Encendido automatico
    EQ_MAN_OFF,                 // Apagado manual
    EQ_MAN_ON,                  // Encendido manual
    EQ_LOCAL_OFF,               // Apagado local
    EQ_LOCAL_ON,                // Encendido local
    EQ_HOT,                     // Averia
    EQ_FAIL                     // Retornos incongruentes
};

// Equipo
// ------------------------------------------------------------------
autom A_EQ
{
    TUBE tube;                  // Localizacion (init.prg)
    ZONE zone_ini, zone_fin;
    bool manual;                // Ultima orden manual
    bool pending_write;         // Orden en curso
    EQ auto persistent cmd;     // Ultima orden

    // Hardware
    bool input in_on, in_local, in_hot;
    bool volatile output out_on;

    // CAS
    EQ cas;

    // Contador de uso
    USE use;

    // Retornos -> estado
    EQ read()
    {
        if (in_hot) return EQ_HOT;
        else if (!in_local) return in_on ? EQ_LOCAL_ON : EQ_LOCAL_OFF;
        else if (manual) return in_on ? EQ_MAN_ON : EQ_MAN_OFF;
        else return in_on ? EQ_ON : EQ_OFF;
    }

    // Chequeo de retornos contra la orden
    void check()
    {
        cas = read();
        if (!in_local || in_hot) {
            if (cas.trapped()) cas.trap(false);
        }
        else if (cas != cmd) cas.trap(true);
        else if (cas.trapped()) cas.trap(false);
        cas.validate();

        if (in_on) use.start();
        else use.stop();
    }

    // Escritura con comprobacion
    void write(EQ c)
    {
        // Sin return en void: cadena if/else, como en fan.prg
        if (!cas.enabled()) {
            ? cas.desc(), " -- no comandado, desactivado!\n";
        }
        else if (in_hot || !in_local) {
            ? cas.desc(), " -- no comandado, averia/local!\n";
            cmd = EQ_OFF;
            check();
        }
        else {
            manual = (c == EQ_MAN_ON || c == EQ_MAN_OFF);
            cmd = c;
            pending_write = true;
            out_on = (c == EQ_ON || c == EQ_MAN_ON);
            out_on.validate();
            ontime (INTERVAL_CHECK) {
                pending_write = false;
                check();
            }
        }
    }

    // Interfaz con automatismos
    bool ready(TUBE t)
    {
        return cas == EQ_OFF && cas.enabled() && !cas.trapped()
            && !pending_write && tube == t;
    }

    void cmd_auto(EQ c)
    {
        log cas.desc(), " -- orden desde automatismo = ", c, "\n";
        cas = c;
        write(c);
    }

    // Comunicaciones MODBUS
    msg MSG_MODBUS (st)
    {
        switch (st) {
        case 0: cas.enable(false); -> init; break;
        case 1: break;
        case 2:
            cas.enable(true);
            ontime (1) {
                write(cmd);
                -> base;
            }
            break;
        }
    }

    // Inicial
    stat init
    {
#ifdef SIM
        in_local = true;
        cas.enable(true);
        -> base;
#endif
    }

    // Funcionamiento
    stat base
    {
        // Orden desde SCADA
        when cas {
            ? cas.desc(), " -- orden SCADA = ", cas, "\n";
            write(cas);
        }

        // Local / averia
        when in_hot, in_local {
            if (!in_local || in_hot) {
                cmd = EQ_OFF;
                out_on = false;
                out_on.validate();
            }
            pending_write = false;
            check();
        }

        // Retornos
        when in_on if (!pending_write) check();
    }
};

/*
 * type.dev (codigos @ libres en la obra):
 *
 * EQ                  <i|eq.bmp>Equipo @NNN
 * {
 *     EQ_OFF          <m>Apagado automatico
 *     EQ_ON           Encendido automatico
 *     EQ_MAN_OFF      <m>Apagado manual
 *     EQ_MAN_ON       <m>Encendido manual
 *     EQ_LOCAL_OFF    Apagado local
 *     EQ_LOCAL_ON     Encendido local
 *     EQ_HOT          <T0>Averia
 *     EQ_FAIL         <T1>Retornos incongruentes
 * }
 *
 * init.prg:   A_EQ eq[N_EQ];   eq[0].tube = TUBE1; ...
 * cas.dev:    .cas Equipos NNNN  /  eq[*].cas <r>Equipo *+
 * mb_x.dev:   eq[0].in_on %IX096.0  /  eq[0].out_on %QX096.0
 */

/* vim: set et ts=4 sw=4 sts=4: */
