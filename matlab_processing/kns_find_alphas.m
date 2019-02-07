% find alphas

% loop through preanneal files

% BGU_Th-22-7-16-APT_high_Th-04.80um-post_anneal_00-FIX-10.txt
% for pre-anneal, five pos, five neg, five fix

% for post-anneal, there's 00 and 01
% for post-anneal 01, there's five pos, neg and fix
% for post-anneal 00, there's 1-90 pos, neg, and fix

% [freq_final,freq_error,speed,diffusivity,diffusivity_err,tau]
grating = 4.818417202723469; % from calibration

alphas.pre_anneal = zeros(5,1);

% pre-anneal
for ii = 1:5
    sii = num2str(ii);
    posfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'pre_anneal_00-POS-', sii, '.txt');

    negfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'pre_anneal_00-NEG-', sii, '.txt');

    fixfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'pre_anneal_00-FIX-', sii, '.txt');

    [freq_final,freq_error,speed,diffusivity,diffusivity_err,tau] ... 
    = TGS_phase_analysis(posfile, negfile, grating, 2);

   alphas.pre_anneal(ii,1) = diffusivity; 
end

% post-anneal 01
alphas.post_anneal01 = zeros(5, 1);
for ii = 1:5
    sii = num2str(ii);
    posfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_01-POS-', sii, '.txt');

    negfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_01-NEG-', sii, '.txt');

    fixfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_01-FIX-', sii, '.txt');

    [freq_final,freq_error,speed,diffusivity,diffusivity_err,tau] ... 
    = TGS_phase_analysis(posfile, negfile, grating, 2);

   alphas.post_anneal01(ii,1) = diffusivity; 
end



% post-anneal 00
alphas.post_anneal00 = zeros(90,1);
for ii = 1:90
    sii = num2str(ii);
    posfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_00-POS-', sii, '.txt');

    negfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_00-NEG-', sii, '.txt');

    fixfile = strcat('BGU_Th-22-7-16-APT_high_Th-04.80um-', ...
    'post_anneal_00-FIX-', sii, '.txt');

    [freq_final,freq_error,speed,diffusivity,diffusivity_err,tau] ... 
    = TGS_phase_analysis(posfile, negfile, grating, 2);

   alphas.post_anneal00(ii,1) = diffusivity; 
end

%SAW_c_tungsten = 2665.9; % This is the value that Prof. Short used in his demo
% But, I have similar (but not identical values for which I have citations)

%wavelengths = SAW_c_tungsten ./ (freqs .* 1e-6)


