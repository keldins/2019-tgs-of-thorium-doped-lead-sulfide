
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

fh = figure();
errorbar(squezd_times_hrs, all_alphas, all_alpha_errs, "+m");
hold on;
x = [0, 0];
y = ylim();
plot(x,y,"r");
title("Thermal diffusivity before and after annealing");
xlabel("Time (hrs)");
ylabel("Thermal diffusivity (m^2/s)");
xlim([-.5,4.6]);
text(.2, 2.3e-5, "<= annealing stage", "color", "r");
filename = "~/strand/plots/thermal_diffusivity_pre_post";
print("-dpdflatex", filename);
print("-dpsc", filename);
print("-depsc", filename);
print("-dsvg", filename);
print("-dpdf", filename);
print("-dpng", filename);
hold off;


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


%
%title("");
%xlabel("");
%ylabel("");
%filename = "~/strand/plots/";
%print("-dpdflatex", filename);
%print("-dpsc", filename);


