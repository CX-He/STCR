This set of files contains Matlab demos for the HySime algorithm introduced in the paper

José M. B. Dias and José M. P. Nascimento,
"Hyperspectral Subspace	identification"
 IEEE Trans. Geosci. Remote Sensing, vol. 46, no. 8, pp. .-., 2008

Files:
                     readme.txt - this file
                HySime_demo.m   - simulated data demo
      Hysime_demo_real_data.m   - real data demo
                     hysime.m   - HySime algorithm
                   estNoise.m   - Estimates the noise of the hyperspectral data set
generate_hyperspectral_data.m   - Generates a  hyperspectral mixture
              dirichlet_rnd.m   - Generates abundance fractions with Dirichlet statistics                                  distributions
                  USGS_1995.mat - Data file with a set of mineral signatures
                                  extracted from USGS spectral library.

Getting started:

1-

To run different demos, set in the HySime_demo.m file the parameters:
p = 5;              % number of endmembers
N = 10^4;           % number of pixels
SNR = 25;           % signal-to-noise ratio (in dB)

%eta = 0;           % white noise
%or
eta > 0;            % Gaussian shaped (w.r.t the freqiency) noise with variance
                      1/eta

%noise_type = 'poisson'; % Poisson noise
%or
noise_type = 'additive'; % Gaussian noise

then Run the HySime_demo.m script Matlab file

2- Running HySime on real data set

After choosing data_set = 'cuprite'or data_set = 'indian_pine'
run the script Matlab file Hysime_demo_real_data.m
