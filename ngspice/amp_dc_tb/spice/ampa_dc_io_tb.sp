* Amplifier A buffer DC current load sweep testbench

*** header
* corner list
.include ../../models/design.ngspice
.lib ../../models/sm141064.ngspice typical
.lib ../../models/sm141064.ngspice mimcap_typical
.param pvdd = 2.5
.temp 25

* no monte carlo
.param
+  sw_stat_global = 0
+  sw_stat_mismatch = 0

.include ../../netlists/ref.spice
.include ../../netlists/bias.spice
.include ../../netlists/sbcs_vreg.spice
.include ../../netlists/ampa.spice

vdd vdd 0 {pvdd}
vss vss 0 0
vin  in cm 0

* bias
xref  ref            vreg    vss ref
xbias ref iq0 vdd gp vreg bp vss bias
xvreg iq  gp  vdd            vss sbcs_vreg
vq iq iq0 0
ecm cm vss xbias.q vss 1 

* dut
xdut o cm o vdd gp vreg bp vss ampa
cl o cm 10p
vo o cm 0

.param delta = 200m
.param k     = 1001
.dc vo {-delta/2} {delta/2} {delta/k}

.option gmin=1e-15
.control
	run
	
	let io = i(vo)
	let vo = o-cm

	let ro = abs(deriv(vo)/deriv(io))
	
*	plot vo vs io
*	plot ro vs io ylog
	
	wrdata ./data/ampa_dc_io_tb.dat io vo ro
*	exit
.endc

