* inverter testbench

.include "../../models/design.ngspice"
.lib "../../models/sm141064.ngspice" #mos
.param
+  sw_stat_global = 0
+  sw_stat_mismatch = 0
.temp #temp

.include ../../netlists/ref.spice
.include ../../netlists/bias.spice
.include ../../netlists/sbcs_vreg.spice

.param pvdd_max = 6.0
.param pvdd     = 3.3
vdd vdd 0 {pvdd} pulse(10m {pvdd_max} 1u)
vss vss 0 0

eref  ref vss vreg vss 0.5
xbias ref iq0 vdd gp vreg bp vss bias
xvreg iq  gp  vdd            vss sbcs_vreg
viq   iq  iq0 0

*.ic v(vdd)={pvdd}
.option gmin=1e-11
.option method="Gear"
.control
	dc vdd 6 1 -10m

	let iq  = i(viq)
	let vq  = xbias.q
	let psr = abs(deriv(vreg)/deriv(vdd))

*	plot i(vo) vs vdd ylimit 6u 9u

*	plot vdd  vs vdd vreg vs vdd vq   vs vdd
*	plot psr  vs vdd ylog
	
	meas dc vddmin find vdd  when psr=0.01 rise=1
	meas dc vreg0  find vreg when psr=0.01 rise=1
	meas dc vq0    find vq   when psr=0.01 rise=1
	meas dc iq0    find iq   when psr=0.01 rise=1
	let qerr = (vq0/vreg0-0.5)/0.5
	let drop = vddmin-vreg0
	print qerr drop

	echo "vddmin,vreg0,vq0,qerr,iq0,drop"             >  ./meas/bias_tb.meas#num
	echo "$&vddmin,$&vreg0,$&vq0,$&qerr,$&iq0,$&drop" >> ./meas/bias_tb.meas#num

	
	wrdata ./data/bias_tb.dat#num vdd vreg iq 

.endc
