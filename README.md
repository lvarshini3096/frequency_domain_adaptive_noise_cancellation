# Frequency Domain Adaptive Noise Cancellation (FDAF)

A **MATLAB implementation** of Frequency Domain Adaptive Noise Cancellation (ANC), utilizing the **Least Mean Square (LMS)** algorithm to effectively reduce background noise from a primary speech signal.

---

## Overview

This project implements an **Adaptive Noise Cancellation (ANC)** system based on the principles of **Frequency Domain Adaptive Filtering (FDAF)**, as described in the paper:

> *"Frequency-Domain and Multirate Adaptive Filtering"* — John J. Shynk

![Diagram](https://user-images.githubusercontent.com/78391474/107889434-8b13ea80-6ee0-11eb-93be-bfaecebc55f3.jpg)

The system processes two input signals:

- **Primary Input (`d(n)` — `mic1.wav`)**: The desired speech signal contaminated with background noise (e.g., *speech + noise*).  
- **Secondary Input (`x(n)` — `mic2.wav`)**: A reference signal that is highly correlated with the noise in the primary input (ideally, just the noise).

The algorithm uses an **adaptive filter in the frequency domain** to model the path between the secondary input and the primary input's noise component.  
By dynamically adjusting its coefficients (weights **B**) to minimize the **Mean Squared Error (MSE)**, the filter estimates the noise, which is then subtracted from the primary input to yield a **cleaner output signal** `e(n)`.

---

## Implementation Details

### Algorithm

The core of the system is the **Normalized Frequency Domain LMS (NLMS)** algorithm, implemented through the following steps:

1. **Framing and FFT**  
   Both input signals (`d(n)` and `x(n)`) are divided into non-overlapping blocks of **N** samples and transformed into the frequency domain using the **Fast Fourier Transform (FFT)**, yielding `D(K)` and `X(K)`.

2. **Noise Estimation**  
   The frequency-domain adaptive filter weights B are used to estimate the noise component:

   **Ď_noise(K) = X_diag(K) · B**

3. **Error Calculation**  
   The filtered output (error signal) is computed as:

   **E(K) = D(K) − Ď_noise(K)**

4. **Weight Update**  
   The adaptive filter weights are updated using a gradient descent (LMS/NLMS) approach to minimize the power of the error:

   **B_new = B_old + 2 × μ × X_diag(K)\* × E(K)**


5. **Time Domain Conversion**  
   The frequency-domain error `E(K)` is transformed back to the time domain using the **Inverse FFT (IFFT)** to obtain the final clean output signal `e(n)`.

---

### Key Parameters

The performance of the FDAF depends on two key manually configurable parameters in the MATLAB code:

| **Parameter** | **Description** | **Code Variable** | **Example Value** |
|----------------|-----------------|-------------------|-------------------|
| **Frame Size** | Number of samples per processing block. Determines the filter’s length and computational load. | `N` | `256` |
| **Step Size** | Controls adaptation speed and stability. A larger μ means faster but potentially unstable convergence. | `mu` | `0.002973` |

---

## How to Use

### Prerequisites
- MATLAB (tested with standard configurations)

---

### Running the Project

1. Place the provided MATLAB script and your `.wav` audio files (`mic1.wav`, `mic2.wav`, and optionally `cleanspeech.wav`) in the same directory.  
2. Open the script in MATLAB.  
3. Adjust parameters:
   - `N` → Frame size  
   - `mu` → Step size  
4. Run the script.

---

### Outputs

| **Output Type** | **Description** |
|------------------|-----------------|
| **Audio Output** | The final noise-cancelled audio (`e(n)`) is played back via `sound(rs)`. |
| **Command Window Output** | Displays **Signal-to-Noise Ratio (SNR) Improvement** in dB. |
| **Figure 1 — Error Convergence** | Plots the magnitude of the error signal (‖E‖² in dB) vs. frame number. Should show clear convergence. |
| **Figure 2 — Filter Weights (for N=128)** | 3D mesh plot of adaptive weights `B(i, K)` across frame number `i` and frequency `K`, visualizing adaptation dynamics. |

---

## Optimizing Performance

The optimal values for **N** and **μ** depend on the input audio signals.  
To tune performance:

- **Observe SNR Improvement**: Aim for the highest positive value.  
- **Analyze Error Convergence Plot**: Choose a μ that yields a *rapid and stable decrease* in error magnitude — indicating fast and stable convergence.

---

## References

- Shynk, J. J. (1992). *Frequency-Domain and Multirate Adaptive Filtering*. **IEEE Signal Processing Magazine**, 9(1), 14–37.  
- Haykin, S. (2002). *Adaptive Filter Theory* (4th Edition). **Prentice Hall**.

---
