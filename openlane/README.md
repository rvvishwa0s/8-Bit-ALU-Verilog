# OpenLane / SKY130A physical-design stage

This repository deliberately keeps physical implementation setup separate from RTL simulation and Yosys synthesis because OpenLane configuration differs by release.

## Target

- PDK: `sky130A`
- Standard-cell library: `sky130_fd_sc_hd`
- Top module: `alu8`
- Design type: combinational (no clock port and no sequential pipeline registers)

## Before running

1. Install a supported Linux environment and Docker.
2. Install/configure the SKY130A PDK using the instructions for your selected OpenLane release.
3. Select OpenLane 1 or OpenLane 2 and follow that release's official design configuration format.
4. Point the flow to `rtl/alu8.v` and set `alu8` as the top module.
5. Run the flow and inspect the generated logs and reports.

Do not use an OpenLane 1 Tcl configuration with OpenLane 2. This project does not claim that a physical-design run has already completed.

## Expected flow stages

Floorplanning → power distribution network → placement → timing optimization → global routing → detailed routing → parasitic extraction → physical verification → GDSII export.

Because the design is combinational, clock-tree synthesis is not required.

## Evidence to save in the repository

After a successful run, add a `results/` folder containing selected reports and screenshots, subject to tool license and output-size constraints. Record the exact tool versions, PDK revision, DRC/LVS/antenna status, cell area and timing metrics.
