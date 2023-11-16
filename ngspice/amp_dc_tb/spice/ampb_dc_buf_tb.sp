* Amplifier B buffer DC testbench

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
.include ../../netlists/ampb.spice

vdd vdd 0 {pvdd}
vss vss 0 0
vin  in cm 0

* bias
xref  ref            vreg    vss ref
xbias ref iq0 vdd gp vreg bp vss bias
xvreg iq  gp  vdd            vss sbcs_vreg
vo iq iq0 0
ecm cm vss xbias.q vss 1 

* dut
vs0 vs0 vss 0
xdut o in o vdd gp vreg bp vs0 ampb

.param delta=1
.param k = 1001
.dc vin {-delta} {delta} {delta/(k+1)}

.option gmin=1e-15
.control

	run
	
	let vi = in-cm
	let vo = o-cm

	let av = db(abs(deriv(vo)/deriv(vi)))
	
	plot vo vs vi
	plot av vs vi
	
	wrdata ./data/ampb_dc_buf_tb.dat vi vo av
*	exit
.endc

