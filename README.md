# Enchilada Firmware

This repository holds the latest Firmware for Enchilada devices alongside the scripts and tools used to generate the output folder, designed to be used for Windows.

## Script

- Extract BTFM.bin into extracted\BTFM
- Extract dspso.bin into extracted\dsp
- Extract NON-HLOS.bin into extracted\NON-HLOS
- Extract vendor.img into extracted\vendor
- Copy abl.elf into extracted
- Copy xbl.elf into extracted
- Run build.cmd

```
  _______        __  _____      _                  _
 |  ___\ \      / / | ____|_  _| |_ _ __ __ _  ___| |_ ___  _ __
 | |_   \ \ /\ / /  |  _| \ \/ / __| '__/ _` |/ __| __/ _ \| '__|
 |  _|   \ V  V /   | |___ >  <| |_| | | (_| | (__| || (_) | |
 |_|      \_/\_/    |_____/_/\_\\__|_|  \__,_|\___|\__\___/|_|


Target: Enchilada
SoC   : SDM845
RKH   : DD7C5F2E53176BEE91747B53900CCEC33DD30FA4DED0DFE9BAF9156E6910862F (QUALCOMM Attestation CA)
```