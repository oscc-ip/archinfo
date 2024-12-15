
comp-smoke:
	make -c dv/smoke

run-smoke: comp-smoke
	cd build && ./simv -l run-smoke.log ${RUN_ARGS}

wave-smoke:
	${VERDI_TOOL} -ssf build/$(SIM_TOP).fsdb &

clean :
	rm -rf build

.PHONY : wave-smoke clean