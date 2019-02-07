
% plot data and save so that files can be transferred from cluster to local
% machine and then viewed

load("./kns_evolution_data.mat");

% T_timestamp, which is the time from the heating element,
% starts at 39752.61500 seconds
% all_times, which are all the timestamps from the TGS unit,
% start at 39907 seconds
% These numbers seem arcane, but they are actually just clock
% time in seconds.
% We subtract off 10 hrs = 36000 seconds to make time axis
% labels less confusing.
T_timestamp = T_timestamp - 36000;
all_times = all_times - 36000;


fmt1 = "m";     % solid violet line
fmt2 = "*m";    % violet data points (scatter plot)
fmt3 = "--m";   % dashed violet line


plot(times.post_anneal00, Ts.post_anneal00, fmt1);
title("Temperature change over time after annealing sample");
xlabel("Time (s)");
ylabel("Temperature (C)");
print("-dpdflatex", "~/strand/plots/T_over_time_post_anneal00");
print("-dpsc", "~/strand/plots/T_over_time_post_anneal00");
print("-depsc", "~/strand/plots/T_over_time_post_anneal00");
print("-dsvg", "~/strand/plots/T_over_time_post_anneal00");
print("-dpdf", "~/strand/plots/T_over_time_post_anneal00");
print("-dpng", "~/strand/plots/T_over_time_post_anneal00");



plot(Ts.post_anneal00, alphas.post_anneal00, fmt2);
title("Thermal diffusivity as a function of temperature after annealing sample");
xlabel("Temperature (C)");
ylabel("Thermal diffusivity (m^2/s)");
print("-dpdflatex", "~/strand/plots/alpha_vs_T_post_anneal00");
print("-dpsc", "~/strand/plots/alpha_vs_T_post_anneal00");
print("-depsc", "~/strand/plots/alpha_vs_T_post_anneal00");
print("-dsvg", "~/strand/plots/alpha_vs_T_post_anneal00");
print("-dpdf", "~/strand/plots/alpha_vs_T_post_anneal00");
print("-dpng", "~/strand/plots/alpha_vs_T_post_anneal00");



plot(times.post_anneal00, alphas.post_anneal00, fmt2); 
title("Thermal diffusivity as a function of time after annealing sample");
xlabel("Time (s)");
ylabel("Thermal diffusivity (m^2/s)");
print("-dpdflatex", "~/strand/plots/alpha_vs_time_post_anneal00");
print("-dpsc", "~/strand/plots/alpha_vs_time_post_anneal00");
print("-depsc", "~/strand/plots/alpha_vs_time_post_anneal00");
print("-dsvg", "~/strand/plots/alpha_vs_time_post_anneal00");
print("-dpdf", "~/strand/plots/alpha_vs_time_post_anneal00");
print("-dpng", "~/strand/plots/alpha_vs_time_post_anneal00");






plot(all_times, all_alphas, fmt2);
title("Thermal diffusivity over time for entire experiment");
xlabel("Time (s)");
ylabel("Thermal diffusivity (m^2/s)");
print("-dpdflatex", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dpsc", "~/strand/plots/alphas_vs_time_all_seconds");
print("-depsc", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dsvg", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dpdf", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dpng", "~/strand/plots/alphas_vs_time_all_seconds");



plot(all_times/3600, all_alphas, fmt2);
title("Thermal diffusivity over time for entire experiment");
xlabel("Time (hrs)");
ylabel("Thermal diffusivity (m^2/s)");
print("-dpdflatex", "~/strand/plots/alphas_vs_time_all_hours");
print("-dpsc", "~/strand/plots/alphas_vs_time_all_hours");
print("-depsc", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dpdf", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dsvg", "~/strand/plots/alphas_vs_time_all_seconds");
print("-dpng", "~/strand/plots/alphas_vs_time_all_seconds");


plot(all_times, all_Ts, fmt3);
title("Temperature of sample for duration of experiment");
xlabel("Time (s)");
ylabel("Temperature (C)");
print("-dpdflatex", "~/strand/plots/Ts_vs_time_all_seconds");
print("-dpsc", "~/strand/plots/Ts_vs_time_all_seconds");
print("-depsc", "~/strand/plots/Ts_vs_time_all_seconds");
print("-dpdf", "~/strand/plots/Ts_vs_time_all_seconds");
print("-dsvg", "~/strand/plots/Ts_vs_time_all_seconds");
print("-dpng", "~/strand/plots/Ts_vs_time_all_seconds");



plot(all_times/3600, all_Ts, fmt3);
title("Temperature of sample for duration of experiment");
xlabel("Time (hrs)");
ylabel("Temperature (C)");
print("-dpdflatex", "~/strand/plots/Ts_vs_time_all_hours");
print("-dpsc", "~/strand/plots/Ts_vs_time_all_hours");
print("-depsc", "~/strand/plots/Ts_vs_time_all_hours");
print("-dpdf", "~/strand/plots/Ts_vs_time_all_hours");
print("-dpng", "~/strand/plots/Ts_vs_time_all_hours");
print("-dsvg", "~/strand/plots/Ts_vs_time_all_hours");



plot(all_Ts, all_alphas, fmt2);
title("Thermal diffusivity as a function of temperature for the entire experiment");
xlabel("Temperature (C)");
ylabel("Thermal diffusivity (m^2/s)");
print("-dpdflatex", "~/strand/plots/alphas_vs_Ts_all");
print("-dpsc", "~/strand/plots/alphas_vs_Ts_all");
print("-depsc", "~/strand/plots/alphas_vs_Ts_all");
print("-dpdf", "~/strand/plots/alphas_vs_Ts_all");
print("-dpng", "~/strand/plots/alphas_vs_Ts_all");
print("-dsvg", "~/strand/plots/alphas_vs_Ts_all");



plot(T_timestamp, T_out, fmt1);
title("Temperature of sample over time");
xlabel("Time (s)");
ylabel("Temperature (C)");
print("-dpdflatex", "~/strand/plots/T_vs_time_omega_all");
print("-dpsc", "~/strand/plots/T_vs_time_omega_all");
print("-depsc", "~/strand/plots/T_vs_time_omega_all");
print("-dpdf", "~/strand/plots/T_vs_time_omega_all");
print("-dpng", "~/strand/plots/T_vs_time_omega_all");
print("-dsvg", "~/strand/plots/T_vs_time_omega_all");

plot(T_timestamp/3600, T_out, fmt1);
title("Temperature of sample over time");
xlabel("Time (hrs)");
ylabel("Temperature (C)");
print("-dpdflatex", "~/strand/plots/T_vs_time_omega_all_hours");
print("-dpsc", "~/strand/plots/T_vs_time_omega_all_hours");
print("-depsc", "~/strand/plots/T_vs_time_omega_all_hours");
print("-dpdf", "~/strand/plots/T_vs_time_omega_all_hours");
print("-dpng", "~/strand/plots/T_vs_time_omega_all_hours");
print("-dsvg", "~/strand/plots/T_vs_time_omega_all_hours");


%
%title("");
%xlabel("");
%ylabel("");
%print("-dpdflatex", "~/strand/plots/");
%print("-dpsc", "~/strand/plots/");


