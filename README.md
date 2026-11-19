# 8-Bit ALU — Open-Source RTL-to-GDSII Project

A synthesizable 8-bit Arithmetic Logic Unit written in Verilog HDL, with a self-checking testbench and a starter synthesis flow. This repository follows the supplied project synopsis and is intended as an educational ASIC/VLSI mini-project.

## Features

- 8-bit operands `A` and `B`
- 3-bit operation selector `OP`
- Eight operations: ADD, SUB, AND, OR, XOR, NOT, logical left shift, logical right shift
- Four status flags: ZERO, CARRY, OVERFLOW, NEGATIVE
- Self-checking simulation testbench
- Yosys synthesis script
- OpenLane/SKY130A physical-design preparation notes

## Repository structure

```text
alu8-asic-github/
├── .github/workflows/rtl-ci.yml
├── docs/architecture.md
├── openlane/README.md
├── rtl/alu8.v
├── scripts/run.sh
├── scripts/synth.ys
├── tb/alu8_tb.v
├── .gitignore
├── LICENSE
├── Makefile
└── README.md
```

## 1. Requirements

For RTL simulation and synthesis:

- Icarus Verilog (`iverilog`, `vvp`)
- GTKWave (optional, for waveform viewing)
- Yosys

Ubuntu/Debian installation:

```bash
sudo apt update
sudo apt install -y git make iverilog gtkwave yosys
```

## 2. Run simulation

Clone the repository, then run:

```bash
git clone https://github.com/rvvishwa0s/alu8-asic-github.git
cd alu8-asic-github
make sim
```

The testbench checks arithmetic, logical, shift and flag behavior. It prints a final pass/fail summary and writes `build/alu8.vcd`.

Open the waveform:

```bash
make wave
```

## 3. Run synthesis

```bash
make synth
```

Yosys creates:

- `build/alu8_netlist.v` — synthesized gate-level Verilog
- `build/alu8_netlist.json` — synthesized netlist in JSON format
- synthesis statistics in the terminal

The exact cell count and area depend on the synthesis script, mapping library and tool versions. Report only measurements from your own run.

## 4. ASIC physical design

The intended technology is the SkyWater SKY130A process with the `sky130_fd_sc_hd` standard-cell library. OpenLane/OpenROAD can be used for floorplanning, placement, routing, physical verification and GDSII generation.

See [`openlane/README.md`](openlane/README.md) before running the physical-design flow. OpenLane versions have different configuration formats; use a configuration matching the installed version.

## 5. ALU operation and flag definitions

See [`docs/architecture.md`](docs/architecture.md) for the complete interface, operation table and flag conventions.

Important conventions:
- ADD: `CARRY` is unsigned carry-out.
- SUB: `CARRY` means borrow (`A < B`), matching the synopsis.
- Shifts: `CARRY` is the bit shifted out.
- `OVERFLOW` indicates signed two's-complement overflow for ADD/SUB.
- `ZERO` is high when RESULT is zero.
- `NEGATIVE` equals RESULT[7].

## 6. Project workflow

1. Understand the ALU architecture and operation encoding.
2. Simulate RTL with Icarus Verilog.
3. Inspect VCD waveforms using GTKWave.
4. Synthesize RTL using Yosys.
5. Configure the SKY130A PDK and OpenLane environment.
6. Run physical implementation.
7. Inspect DRC/LVS/antenna reports.
8. Open the generated GDSII in KLayout.

## 7. Results and academic integrity

This repository contains RTL and a testbench, not a pre-verified physical chip. Do not claim DRC, LVS, antenna checks, timing, power, area, or GDSII generation have passed until you have run the physical-design flow and retained its reports. Add your measured results and screenshots to this README after completing those steps.

## License

MIT. See [`LICENSE`](LICENSE).
