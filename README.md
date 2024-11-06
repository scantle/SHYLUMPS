# SHYLUMPS (Simple Hydrological LUMPed-model System)
---

## Overview

SHYLUMPS (Simple Hydrological LUMPed-model System) is a Fortran-based hydrological modeling tool designed for educational and research purposes. This model simulates rainfall-runoff processes and estimates streamflow using a simplified lumped conceptual approach.

SHYLUMPS aims to provide a clear and accessible example of hydrological modeling, making it suitable for teaching, research, and preliminary watershed analyses.

---

## Features

- **Rainfall and Snow Partitioning**: Distinguishes between rain and snow based on temperature thresholds.
- **Snowmelt Calculation**: Incorporates a temperature-based snowmelt algorithm.
- **Quickflow and Baseflow Separation**: Simulates fast-response runoff and slower groundwater contributions to streamflow.
- **Customizable Parameters**: Supports user-defined coefficients and initial storage values for flexible model setups.
- **Streamflow Calculation**: Outputs streamflow in m³/s, converted from daily totals.
- **Fortran Codebase**: Demonstrates efficient and structured hydrological modeling in Fortran.

---

## Requirements

### Fortran Compiler

Ensure you have a Fortran compiler installed (e.g., `gfortran` or Intel Fortran Compiler).

### Visual Studio with the Intel Fortran Compiler (Optional)

Visual Studio 2022 Project files are provided with the project. To use them, download and install the [latest version of Visual Studio](https://visualstudio.microsoft.com/vs/) (the community version is free). Then download and install the [Intel Fortran Compiler](https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#fortran).
