# Portable SCG-ECG Dual Signal Acquisition System

This repository contains the data acquisition code, signal processing code, and a 
representative sample recording for the study "Design and Development of a Portable 
SCG-ECG Dual Signal Acquisition System."

The system simultaneously records electrocardiogram (ECG) and seismocardiogram (SCG) 
signals using a low-cost MEMS accelerometer (MPU-9250) and a DFRobot heart-rate 
sensor, interfaced through an Arduino Uno and processed in MATLAB.

## Repository Contents

| File | Description |
|------|-------------|
| `acquisition.m` | Arduino-based MATLAB script for synchronized ECG and SCG data capture |
| `Preprocessing.m` | Signal processing and analysis script (filtering, peak detection, heart-rate and interval computation) |
| `sample_recording_subject01.mat` | Representative single-subject recording (raw ECG and SCG-Z) |
| `LICENSE` | MIT License |

## Hardware

- MPU-9250 MEMS accelerometer (SCG), read over the I2C interface
- DFRobot Heart Rate Monitor Sensor (ECG), read on analog input A3
- Arduino Uno microcontroller (host serial bridge, baud rate 500000)
- Host computer running MATLAB

## Data Format

`sample_recording_subject01.mat` contains a single variable `just`, an N x 2 matrix:
- Column 1: raw SCG signal (accelerometer Z-axis)
- Column 2: raw reference ECG signal
- Sampling rate: 500 Hz

## Signal Processing Pipeline

ECG: zero-mean/unit-variance normalization → frequency-domain low-frequency removal 
→ 4th-order Butterworth low-pass filter (20 Hz) → R-peak detection.

SCG: amplitude normalization → 3-point moving average → frequency-domain low-frequency 
removal → 5th-order Butterworth low-pass filter (35 Hz) → AO-peak detection.

Heart rate is computed from successive R-R (ECG) and AO-AO (SCG) intervals.

## Data Availability Note

The study recorded ten healthy adult volunteers. A representative single-subject 
recording is provided here to allow reproduction of the processing pipeline. The 
complete per-subject dataset from the original study is not available in its original 
form. The code provided reproduces the full analysis pipeline on the included sample.

## Citation

If you use this code or data, please cite the associated paper. [Add full citation 
once published.]

## Contact
Name: Ferdous Wahid Anik; Email: ferdous.1495@gmail.com
