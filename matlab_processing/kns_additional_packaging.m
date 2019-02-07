load("./kns_evolution_data.mat");

clear ans diffusivity diffusivity_err freq_error freq_final speed tau;
clear ii sii T_file fixfile negfile posfile;

% Package everything into vectors for convenience in plotting
all_times       = [times.pre_anneal; times.post_anneal00; times.post_anneal01];
all_Ts          = [Ts.pre_anneal; Ts.post_anneal00; Ts.post_anneal01];

all_alphas      = [alphas.pre_anneal; alphas.post_anneal00;...
alphas.post_anneal01];
all_alpha_errs  = [alpha_errs.pre_anneal; alpha_errs.post_anneal00; ...
alpha_errs.post_anneal01];

all_freqs       = [freqs.pre_anneal; freqs.post_anneal00; freqs.post_anneal01];
all_freq_errs   = [freq_errs.pre_anneal; freq_errs.post_anneal00; ...
freq_errs.post_anneal01];

all_speeds      = [speeds.pre_anneal; speeds.post_anneal00; ...
speeds.post_anneal01];
all_taus        = [taus.pre_anneal; taus.post_anneal00; taus.post_anneal01];

% anneal starts at about 5000, ends at about 18000 seconds
% let's eliminate the time in between to compress the graph horizontally
squezd_times = [times.pre_anneal-5000; times.post_anneal00-18000; times.post_anneal01-18000] - 36000;
squezd_times_hrs = squezd_times ./ 3600;


save("./kns_evolution_data.mat");
