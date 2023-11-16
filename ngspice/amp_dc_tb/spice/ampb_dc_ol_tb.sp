* Amplifier B open-loop DC testbench

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

vx  x  cm 0
bin in cm v = {v(x,cm)*v(x,cm)*v(x,cm)}
eip ip cm in cm -0.5
eim im cm in cm  0.5

* bias
xref  ref            vreg    vss ref
xbias ref iq0 vdd gp vreg bp vss bias
xvreg iq  gp  vdd            vss sbcs_vreg
vq iq iq0 0
ecm cm vss xbias.q vss 1 

* dut
xdut im ip o vdd gp vreg bp vss ampb
cl o cm 10p

.param dx = 1m
.param k  = 100
.dc vx {-pow(dx,1/3)} {pow(dx,1/3)} {pow(dx,1/3)/k}

.option gmin=1e-15
.control

	run
	
	let vi = ip-im
	let vo = o-cm

	let av = db(abs(deriv(vo)/deriv(vi)))
	
	plot vo vs vi
	plot av vs vo
	
	wrdata ./data/ampb_dc_ol_tb.dat vi vo av
*	exit
.endc

