
// +define+MINIMIZE_COMM

-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f

-f ${FWRISC}/rtl/fwrisc.f
+incdir+${FWRISC}/ve/fwrisc_tracer_bfm
${FWRISC}/ve/fwrisc_tracer_bfm/fwrisc_tracer_bfm.sv
-F ${FWRISC}/ve/fwrisc_rv32imc/tb/tb.F
