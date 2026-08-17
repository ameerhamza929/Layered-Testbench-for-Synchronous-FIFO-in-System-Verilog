# Layered Testbench for a Synchronous FIFO (SystemVerilog)

SystemVerilog verification environment for a Synchronous FIFO using a layered architecture (Generator, Driver, Monitor, Scoreboard) with constrained-random testing.

## Table of contents

- Overview
- Architecture
- Features
- Requirements
- Quickstart — run simulations
- Constrained-random testing and seeds
- Adding tests
- Coverage and checking
- License
- Contributing
- Contact

## Overview

This repository contains a layered verification environment for a synchronous FIFO implemented in SystemVerilog. The testbench follows a clear separation of concerns using a Generator (stimulus), Driver (protocol/send to DUT), Monitor (observe DUT behavior), and Scoreboard (check correctness). The environment is designed for constrained-random verification to thoroughly exercise the FIFO across many scenarios.

## Architecture

- Generator
  - Produces stimulus sequences (writes, reads, pauses, backpressure) using constrained-random techniques.

- Driver
  - Converts generated transactions into pin-level or interface-level stimulus to the DUT.

- Monitor
  - Observes DUT inputs/outputs and converts them back into transactions for checking.

- Scoreboard
  - Receives expected transactions (from the Generator or golden-model) and observed transactions from the Monitor and compares them to determine pass/fail.

This layered approach makes the environment modular and easy to extend for additional tests and checks.

## Features

- Layered testbench architecture (Generator, Driver, Monitor, Scoreboard)
- Constrained-random stimulus to discover corner cases
- Self-checking scoreboard
- Support for running multiple seeds for reproducibility
- Documentation and examples for running the testbench with common SystemVerilog simulators

## Requirements

- A SystemVerilog-capable simulator such as:
  - Mentor/Siemens Questa/ModelSim
  - Synopsys VCS
  - Cadence Xcelium

Note: Open-source simulators such as Icarus Verilog have limited SystemVerilog support — they may not run all constructs used in this environment.

A POSIX-compatible shell and basic build tools (make, bash) are helpful for running scripts.

## Quickstart — run simulations

1. Clone the repository

   git clone https://github.com/ameerhamza929/Layered-Testbench-for-Synchronous-FIFO-in-System-Verilog.git
   cd Layered-Testbench-for-Synchronous-FIFO-in-System-Verilog

2. Compile & run with your simulator

- Using Questa (example)

  vlog -sv path/to/src/*.sv path/to/tb/*.sv
  vsim -c tb_top -do "run -all; quit"

- Using Synopsys VCS (example)

  vcs -sverilog -full64 path/to/src/*.sv path/to/tb/*.sv -o simv
  ./simv +UVM_TESTNAME=tb_top +seed=1234

Replace `path/to/src` and `path/to/tb` with the actual source and testbench directories in this repository. If the repository contains provided run scripts (e.g., `run_sim.sh` or a `Makefile`), prefer using those.

## Constrained-random testing and seeds

To reproduce a failing case, capture the random seed printed by the test and re-run the simulation with that seed. Common seed command-line switches depending on the simulator or test harness:

- +seed=<NUMBER>
- +ntb_random_seed=<NUMBER>

Example (run multiple seeds in a loop):

for SEED in 1 2 3 4 5; do
  ./simv +seed=$SEED | tee sim_run_$SEED.log
done

Running many seeds (hundreds or thousands) increases the chance of finding corner-case bugs. Use a script or CI job to sweep seeds and collect failures.

## Writing tests

- Add constrained-random generators or deterministic tests for specific corner cases.
- Implement additional scoreboard checks for extended FIFO properties (underflow/overflow checks, data integrity, ordering, timing constraints).
- Keep tests modular and aim for clear, minimal changes to extend functionality.

## Coverage and checking

If your simulator supports functional coverage, enable it to measure how thoroughly tests exercise the FIFO. Also consider enabling SVA assertions to detect protocol or timing violations early.

## Contributing

Contributions are welcome. To contribute:

1. Fork the repository
2. Create a descriptive branch name (e.g., `feature/add-coverage`) and implement your changes
3. Open a pull request with a clear description of your changes and why they are needed

Please include simulation log excerpts or failing seed information when reporting bugs or regressions.

## License

This repository does not include a license file by default. Add a LICENSE file (for example, MIT or Apache-2.0) if you intend to make the project open source and allow reuse.

## Contact

For questions or support, open an issue in the GitHub repository or contact the repository owner: ameerhamza929.
