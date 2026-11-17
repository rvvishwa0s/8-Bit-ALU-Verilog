SHELL := /bin/bash

RTL := rtl/alu8.v
TB  := tb/alu8_tb.v
SIM := build/alu8_sim

.PHONY: all sim wave synth clean tools

all: sim synth

tools:
	@command -v iverilog >/dev/null || (echo "Install iverilog"; exit 1)
	@command -v vvp >/dev/null || (echo "Install vvp (iverilog package)"; exit 1)
	@command -v yosys >/dev/null || (echo "Install yosys"; exit 1)

build:
	mkdir -p build

sim: build
	iverilog -g2012 -Wall -o $(SIM) $(RTL) $(TB)
	vvp $(SIM)

wave: sim
	gtkwave build/alu8.vcd

synth: build
	yosys -s scripts/synth.ys

clean:
	rm -rf build
