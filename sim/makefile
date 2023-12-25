vcs:
	vcs -full64 +v2k -R -timescale=1ns/10ps -f filelist.f -fsdb -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -l vcs.log -cm line+tgl+cond+fsm \
	-cm_dir ./vcs_coverage -cm_name case1 
dve:
	dve -cov -dir ./vcs_coverage.vdb -full64

verdi:
	verdi  -sv -f filelist.f &


clean:
	@rm -rf csrc DVEfiles simv simv.daidir ucli.key novas* VCS* *dat *vdb dpkg simv.vdb *.log cm.log verdiLo
