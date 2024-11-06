# SHYLUMPS (Simple Hydrological LUMPed-model System)
---

## Overview

SHYLUMPS (Simple Hydrological LUMPed-model System) is a Fortran-based hydrological modeling tool designed for educational and research purposes. This model simulates rainfall-runoff processes and estimates streamflow using a simplified lumped conceptual approach.

SHYLUMPS aims to provide a clear and accessible example of hydrological modeling, making it suitable for teaching, research, and preliminary watershed analyses. Eventually, the hope is SHYLUMPS can be used for simple watershed calibration experiments.

**At the moment, SHYLUMPS tends to accumulate water, likely due to oversimplifications of the snow and snow melt processes.**

---

## Features

- **Rainfall and Snow Partitioning**: Distinguishes between rain and snow based on temperature thresholds.
- **Snowmelt Calculation**: Incorporates a temperature-based snowmelt algorithm.
- **Quickflow and Baseflow Separation**: Simulates fast-response runoff and slower groundwater contributions to streamflow.
- **Customizable Parameters**: Supports user-defined coefficients and initial storage values for flexible model setups.
- **Streamflow Calculation**: Outputs streamflow in m³/s, converted from daily totals.
- **Fortran Codebase**: Demonstrates efficient and structured hydrological modeling in Fortran.

For now, the only accepted climate forcings are **Precipitation**, **Average Temperature**, and **Evapotranspiration** input in millimeters per day, except temperature, which is in degrees celsius. The code is hardcoded to run on **daily timesteps**.

---

## Requirements

### Fortran Compiler

Ensure you have a Fortran compiler installed (e.g., `gfortran` or Intel Fortran Compiler).

### Visual Studio with the Intel Fortran Compiler (Optional)

Visual Studio 2022 Project files are provided with the project. To use them, download and install the [latest version of Visual Studio](https://visualstudio.microsoft.com/vs/) (the community version is free). Then download and install the [Intel Fortran Compiler](https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html#fortran).

## Running SHYLUMPS

SHYLUMPS is run from the command line. It requires one argument: The name of the main input file. An example set of model files is provided within the [Test/CoastForkWillamette](./Test/CoastForkWillamette/) directory. With this folder open in the command line, the following command would run the model:
```bash
SHYLUMPS CFWillamette.lump
```

## Model Files
### Main Input File
The main input file (*.lump) is an ASCII text file with text descriptions followed by values. It is required to follow this exact format:
```
# SHYLUMPS INPUT FILE

Name: [string]
Area: [real, km^2]
Days: [integer]

# Coefficients
rain_temp:         [real, degC]
snow_temp:         [real, degC]
melt_low_temp:     [real, degC]
melt_high_temp:    [real, degC]
precip_correction: [real]
et_correction:     [real]
quickflow_coef:    [real]
recharge_coef:     [real]
baseflow_coef:     [real]
gw_loss_coef:      [real]

# Initial Storage Values
init_snow: [real, mm]
init_soil: [real, mm]
init_gw:   [real, mm]

# Input Files
Forcings: [string]
```
where bracketed items [ ] need to be replaced with data of the type listed in the bracket. Units are given where necessary. See [Test/CoastForkWillamette/CFWillamette.lump](./Test/CoastForkWillamette/CFWillamette.lump) for an example.

### Forcings Input File
The forcing file consists of a header line and then rows (matching the number of days given in the main input file) consisting of 4 values: **Date**, **Precipitation**, **Average Temperature**, and **Evapotranspiration** input in millimeters per day, except temperature, which is in degrees celsius.
Here is the first couple lines from [Test/CoastForkWillamette/forcings.dat](./Test/CoastForkWillamette/forcings.dat):
```
Date          precip_mm   temp_avg_c        et_mm
1950-10-01  0.000000000  7.227500115  0.000000000
1950-10-02  13.259166800  7.622500030  0.303380000
1950-10-03  27.274166430  8.112916640  0.307362000
1950-10-04  31.460000040  10.574583390  0.313303000
1950-10-05  37.114166420  11.654583435  0.365045000
1950-10-06  11.979999960  9.861250025  0.382860000
1950-10-07  2.444166710  14.054166655  0.335000000
1950-10-08  10.724166830  14.915833335  0.421080000
1950-10-09  8.248333340  11.145833290  0.431380000
1950-10-10  0.036666670  12.671249870  0.342720000
1950-10-11  0.000000000  13.786666490  0.367490000
1950-10-12  0.000000000  14.932083350  0.382700000
1950-10-13  0.025000000  15.088333405  0.397630000
1950-10-14  8.310000120  12.202083310  0.392400000
1950-10-15  4.067499980  7.282916665  0.328940000
...
```
Note that the date is simply stored as a string to be written in the output file: no date processing is done within the program.

### Output File
Streamflow (in m^3/s) is currently the only state variable written to an output file. It is written to the shylumps.out file:
```
  Step        Date    streamflow_m3s
     1  1950-10-01       1.50032E+01
     2  1950-10-02       1.85774E+01
     3  1950-10-03       1.99817E+01
     4  1950-10-04       2.12141E+01
     5  1950-10-05       2.26052E+01
     6  1950-10-06       2.33036E+01
     7  1950-10-07       2.35635E+01
     8  1950-10-08       2.39084E+01
     9  1950-10-09       2.42124E+01
    10  1950-10-10       2.42815E+01
    11  1950-10-11       2.42910E+01
    12  1950-10-12       2.42929E+01
    13  1950-10-13       2.42933E+01
    14  1950-10-14       2.45043E+01
...
```

## Contributing
Contributions are welcome and encouraged! Please fork the repository, create a new branch, and submit a pull request. For major changes, open an issue first to discuss your proposed changes.

A great tutorial on contributing with git/GitHub is provided [here](https://github.com/firstcontributions/first-contributions), although many GUIs also exist for git, simplifying this process.

## Disclaimer
This project was created as a learning tool for the "Pydros" group with the U.C. Davis Hydrologic Sciences Graduate Group. There is no reason to believe any result that comes out of SHYLUMPS and no guarantee of accuracy is suggested or implied. Use at your own risk.
