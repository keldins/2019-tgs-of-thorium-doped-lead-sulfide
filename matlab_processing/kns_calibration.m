
% Perform calibration on all files


% Loop over files in calibration directory

cal_files = ls();

%for ii = 1:size(cal_files)(1)
%
%end

%Tungsten_Calibration-2018-11-07-04.80um-spot00-FIX-1.txt

freqs = zeros(6,1);

for ii = 0:5
    sii = num2str(ii);
    posfile = strcat('Tungsten_Calibration-2018-11-07-04.80um-spot0', sii, ...
    '-POS-1.txt');
	negfile = strcat('Tungsten_Calibration-2018-11-07-04.80um-spot0',sii, ...
    '-NEG-1.txt');
	fixfile = strcat('Tungsten_Calibration-2018-11-07-04.80um-spot0',sii, ...
    '-FIX-1.txt');

    freqs(ii+1,1) = TGS_phase_analysis(posfile, negfile, 4.8, 2);
end

SAW_c_tungsten = 2665.9; % This is the value that Prof. Short used in his demo
% But, I have similar (but not identical values for which I have citations)

wavelengths = SAW_c_tungsten ./ (freqs .* 1e-6)

