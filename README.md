# 2018-DH-TGS-InSitu-NIMB
Data repository for 2018 NIMB submitted manuscript on an in situ DH-TGS beamline facilit

This is the information file for the data package associated with the manuscript entitled "Real-time 
thermomechanical property monitoring during ion beam irradiation using in situ transient grating spectroscopy" 
by Cody A. Dennett and Michael P. Short of MIT and Khalid Hattar and Daniel L. Buller of Sandia National 
Laboratories. For questions about the contents of this package or their execution in Matlab please contact 
C.A. Dennett at cdennett@mit.edu.

This data package contains six subdirectories:
 - /bpm_current_record/
 - /images/
 - /matlab_processing/
 - /RAW_TGS_data/
 - /SRIM_profiles/
 - /temperature_records/

each of which is further sub-divided into directories for the four relevant experiments carried out for this 
manuscript, namely, "angular_calibration_Ni", "temp_steps_Ni", "3.7MeV_He_in_W", and "31MeV_Ni_in_Ni". In 
addition, the "matlab_processing" directory contains a sub_directory "SRIM_depth_plot" which contains the 
routine to generate the plot of the SRIM damage profiles versus depth for Figure 7 as well as "general" which 
contains sub-routines used by the other data analysis scripts. All directories besides the "matlab_processing" 
directory contain raw data which must be processed using the routines in that directory. The form of each raw 
data file is either straightforward, or the interpretation can be gleaned from the corresponding processing 
file, so only those processing files will be described in detail. The only populated directory in "images" 
contains a file note.txt which contains details about the FIB milling and SEM imaging parameters.

In "general"

- This directory contains the master analysis scripts used for processing TGS data from its raw form. As each 
TGS measurement is a total of two independent channels recorded with heterodyne phases 180 degrees offset from 
each other, each measurement has two associated data files which end in "...POS-XXX.txt" and "...NEG-XXX.txt" 
where XXX is the number of the measurement in that run. All raw data files also contain a "...FIX-XXX.txt" 
file which is the difference of the two raw recorded traces, however for processing, the difference is taken 
after adjustment from the POS and NEG files directly. The master analysis protocol is TGS_phase_analysis(), 
whose input and output argument set are:

[SAW_frequency, SAW_frequency_err, SAW_speed, diffusivity, diffusivity_error, 
time_constant]=TGS_phase_analysis(positive_file_name, negative_file_name, grating_spacing, start_phase, 
two_mode?, end_time)

Sub-routines used by this main processing function include:
 - TGS_phase_fft()
 - lorentzian_peak_fit()
 - find_start_phase()

The details of the operation of this analysis code will not be described here, but can be found in the 
reference [Dennett and Short. J. Appl. Phys. 123 (21) (2018) 211106 https://doi.org/10.1063/1.5026429].

- Also included in this directory is the routine find_meas_time(file), which scrapes the time at which a TGS 
measurement was recorded from the file header if given an appropriate data file.

- The function read_watlow_data will take in a temperature record file and output the data as two vectors and 
plot the data if so desired. The argument structure is

[timestamp_out, temp_out]=read_watlow_data(temp_history_file, plotty?)

- Finally, this directory also includes a routine read_SRIM_vac() which takes the structure

[peak_depth, dose_dpa, depth_um]=read_SRIM_vac(file_name, grating_spacing, plotty?)

and provides, based on the information in a SRIM-generated VACANCY.txt file, two vectors of the dose (in dpa) 
over the applied fluence and the depth at which those values occur as the 2nd and 3rd output. The first output 
is a scalar value of the peak swelling depth and is not used in any of the other routines presented here.

In "angular_calibration_Ni"

- Ni_cal_process_2017_11_16_both.m is a script that, when placed in the directory where the TGS data files are 
stored for this run, will process the angular calibration data taken at 3.4 and 5.2um as a function of surface 
polarization on {001} oriented Ni and spit out the corresponding multi-point grating calibration based on 
those data. The routine also needs the library file Ni_SAW_speeds.mat, which contains the 
previously-calculated SAW speeds on Ni at room temperature as a function of surface angle. It is loaded 
automatically by the script.

In "temp_steps_Ni"

- calibrate_angle_2018_01_28.m will take the room temperature TGS data from this static high temperature test 
to orient the acoustic polarization based on SAW speed measurements. This script needs to be run from the 
directory where the associated data files are stored and also have access to the routine get_SAW() and its 
dependencies. The output should be 8 degrees, the polarization of the acoustic wave with respect to the <100> 
direction on this surface.

- get_SAW() is a routine which calculates the SAW speed as a function of crystal orientation for an 
anisotropic crystal with a given set of elastic constants and symmetry operations based on the method of [Du 
and Zhao. npj Comput. Mater. 3 (2017) 17 https://doi.org/10.1038/s41524-017-0019-x]. These methods have been 
provided to by the authors of that work and further questions should be directed to the point of contact 
listed for that publication. The argument structure looks like

[velocity, index, intensity]=get_SAW(elastic_constants, density, surface_orientation, surface_polarization, 
sampling, psaw?, variable_argument)

and has the following dependencies:
 - C_modifi()
 - H_L_peak()

and uses the following constructor files:
 - getCijkl()
 - getDensity()

- The function get_Ni_constants() describes the process of calculating temperature-dependent fourth-order 
elastic constants from Equation 5 in the manuscript. The argument structure is

[c11, c12, c44, rho]=get_Ni_constants(temp, plotty?)

- The script Ni_beamline_process_2018_01_28.m, when placed in the directory, or given access to via the 
switching commands in-file, both the raw TGS data from these measurements as well as the library file 
Ni_SAW_v_temp_8.0deg.mat will plot the measured SAW speed versus temperature as well as the calculated speed 
versus temperature at this angle based on values of elastic constants from get_Ni_constants(), generating 
Figure 8(a).

- Note the temperature profile plotted in Figure 8(b) is read and plotted directly from the function 
read_watlow_data() with the associated record Ni_temp_steps_2018_01_28.txt

in "3.7MeV_He_in_W"

- process_He_in_W_2018_02_01.m, when placed in the directory containing the raw TGS data files for this 
experiment, will process through the in situ TGS data (all ~900 measurements, so it will likely take a while). 
It will output the library file He_in_W_data_w_therm_new.mat (also provided here, to remove need of 
re-processing). That library file contains the timestamp, SAW frequency, SAW speed, thermal diffusivity, and 
diffusivity fitting error for each individual measurement. It will also plot both speed and diffusivity as a 
function timestamp upon completion.

- He_in_W_v_dose.m is the master file for reading in and plotting TGS data and the recorded experiment 
temperature as a function of applied dose to the sample during this experiment, considering the average beam 
current measured over the course of the experiment measured on a Faraday cup periodically through the 
experiment. This file needs both the library file He_in_W_data_w_therm_new.mat and the temperature log file 
temp_log_3.7MeV_He_in_W_2018_02_01.txt to run and produce the plots for Figure 9 and Figure 10.

in "31MeV_Ni_in_Ni"

- process_Ni_in_Ni_2018_02_02.m serves the same purpose as the other processing data file. Namely, when placed 
in a directory with the raw TGS data, it will process each measurement and output the timestamp, SAW 
frequency, SAW speed, thermal diffusivity, and diffusivity fitting error in a library file 
(Ni_in_Ni_data_w_therm_new.mat) which will later be used for processing. It will also plot both speed and 
diffusivity as a function timestamp upon completion.

- Ni_in_Ni_v_dose.m is the maser file for reading in the plotting TGS data, the recorded experimental 
temperature, and the measured beam current on the BPM during this experiment. All applied doses are calculated 
based on the total accumulated charge from the continuously-recorded beam current. This script needs access to 
the library file He_in_W_data_w_therm_new.mat, the temperature record file 
temp_log_31MeV_Ni_in_Ni_2018_02_02_002.txt, and the beam current file beam_current_1.csv from the appropriate 
directories to run. In addition, the helper function read_current_data_2018_02_02() is needed to read in and 
calibrate the bpm measured charge to Faraday cup current measurements made before the after the exposure 
finished. This script will generate Figure 11 and Figure 12 from the manuscript.
