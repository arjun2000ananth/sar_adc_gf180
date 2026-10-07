# 10-bit SAR ADC in GF180MCU

A fully differential 10-bit SAR ADC designed in the open-source GF180MCU process using the `gf180mcuD` PDK.

The current design, `sar_10_bit_split_cal`, uses a redundant split-capacitor DAC, 12 comparisons and a programmable digital decoder. Calibration coefficients are calculated externally and loaded into the controller.

The original binary-CDAC design, `sar_10_bit`, is kept in the repository as a reference.

**Current stage:**  final pre-layout verification is in progress. 
## Team

| Name | Role |
|---|---|
| Arjun Ananth | Lead designer - design and layout |
| Man Yu | design and layout |

## Design overview

The ADC consists of:

- A differential TG input sampler
- A redundant split CDAC with a 2-Cu bridge
- Separate reset switches for the fine-array nodes
- A StrongARM comparator
- 22 bottom-plate switches selecting VCM or VREFP
- A digital controller containing the SAR FSM, decoder and calibration registers

The analog circuits operate at 3.3 V. The controller uses `gf180mcu_fd_sc_mcu7t5v0` standard cells, also powered at 3.3 V.

### Split CDAC

Each side contains:

| Section | Capacitor sizes |
|---|---|
| Main array | 16, 8, 4, 2, 1 Cu |
| Redundant capacitor | 32 Cu |
| Fine array | 16, 8, 4, 2, 1 Cu |
| Dummy | 1 Cu |
| Bridge | 2 Cu |

The unit capacitor is a 5 × 5 µm MIM capacitor, approximately 54.5 fF in the model.

There are 97 units per side, compared with 1,024 in the original binary array. The effective sampling capacitance is approximately 1.8 pF per side.

The nominal conversion steps are:

```text
528, 264, 132, 66, 33 | 32 | 16, 8, 4, 2, 1
```

These are expressed in fine-step units, where:

```text
u = (VREFP − VCM) / 1087
LSB = 2u = 3.036 mV
```

The redundant step provides overlap between the main and fine decisions.

### Sampling and conversion

At a 50 MHz clock, each conversion frame takes 50 cycles:

1. Track the differential input for 26 clocks.
2. Release the fine-node reset one clock before opening the input sampler.
3. Perform 12 comparisons, with one settling clock and one evaluation clock per comparison.
4. Switch one selected bottom plate after each of the first 11 comparisons.
5. Decode the raw decisions while the next frame is sampling.

The final comparison does not switch another capacitor.

Holding `start` high runs conversions continuously at 1 MS/s. The sample-to-output latency is approximately 740 ns.


### Decoder and calibration

The controller uses interval-midpoint decoding. The comparator decisions define an input interval, and the decoder maps its midpoint to a 10-bit output code.

The calibration interface programs 12 weights and an offset. The weights are 16-bit values, and the offset is an 18-bit signed value, using six fractional bits.

Nominal coefficients are available after reset. To use calibrated coefficients:

1. Apply a known input and capture the raw decisions.
2. Calculate the coefficients with the least-squares calibration flow (the fitting scripts belong to the verification framework and are not part of this snapshot).
3. Load the coefficients with `cal_en = 0`, following the documented write protocol.
4. Set `cal_en = 1` to use them.

Coefficient calculation is performed off chip. The ADC stores and applies the coefficients; it does not calibrate itself autonomously.

The decoder arithmetic, a worked example and the programming protocol will be documented in the freeze report, which is published after the verification campaign. The RTL is `circuit_files/src/sar_split_cal/sar_split_cal_recon.v`.

## Specifications

| Parameter | Target / operating point |
|---|---:|
| Resolution | 10 bits |
| Sampling rate | 1 MS/s |
| Conversion clock | 50 MHz |
| Comparisons | 12 |
| Sample-to-output latency | Approximately 740 ns |
| Differential input range | ±1.554 V |
| Input common mode | 1.65 V |
| Output LSB | Approximately 3.036 mV |
| DNL / INL target | ≤ 0.5 LSB |
| SNDR target | ≥ 59 dB |
| Transfer characteristic | Monotonic, with no missing codes in the supported mode |
| Analog and digital supplies | 3.3 V |
| VREFP / VCM | 3.3 V / 1.65 V |

## Interface

These are the ADC core ports. The final harness pin mapping is separate.

### Analog and supply pins

| Pin | Description |
|---|---|
| `ainp`, `ainn` | Differential analog input |
| `vrefp` | CDAC reference, nominally 3.3 V |
| `vcm` | Common-mode reference, nominally 1.65 V |
| `vdda` | Analog supply |
| `vddd` | Digital supply |
| `vss` | Common ground |

### Control inputs

| Pin | Description |
|---|---|
| `clk` | 50 MHz controller clock |
| `rst_n` | Active-low asynchronous reset |
| `start` | Hold high for continuous conversion |
| `cal_en` | Select nominal or programmed coefficients |
| `cal_we` | Calibration write enable |
| `cal_addr[3:0]` | Calibration register address |
| `cal_wdata[17:0]` | Calibration write data |

### Outputs

| Pin | Description |
|---|---|
| `code[9:0]` | Decoded ADC result |
| `valid` | Output-valid pulse |
| `busy` | Conversion status |
| `raw[11:0]` | Raw comparator decisions |
| `raw_stb` | Raw-decision word complete |
| `sat` | Decoder saturation flag |

The raw output is used for calibration and debug. Reset aborts the active conversion and restores the nominal coefficient state.


## Repository structure
TBD

