all:
	xvlog -sv ./sources_1/new/*.v ./sim_1/new/*.sv
	xelab -top tb -snapshot my_sim_snapshot
	xsim my_sim_snapshot -runall
