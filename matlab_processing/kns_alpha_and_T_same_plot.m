%temperature and alpha on same plot

load("./kns_evolution_data.mat");

##fh = figure();
##[ax, h1, h2] = plotyy(T_timestamp/3600, T_out, all_times/3600, all_alphas);
##set(h1, "linestyle", "--");
##set(h2, "linestyle", "none");
##set(h2, "marker", "*");
##title("Thermal diffusivity and temperature over time");
##xlabel("Time (hrs)");
##ylabel(ax(1), "Temperature (C)");
##ylabel(ax(2), "Thermal diffusivity");
##
##print("-dpsc", "~/strand/plots/alpha_T_same_plot");
##print("-dpdflatex", "~/strand/plots/alpha_T_same_plot");
##print("-dpdf", "~/strand/plots/alpha_T_same_plot");
##print("-dpng", "~/strand/plots/alpha_T_same_plot");


figure()

hax_temp = subplot(3, 1, 1);
plt_temp = plot(T_timestamp/3600-10, T_out, "--k");
ylabel("Temperature (C)");
text(1.9, 240, "Annealing stage (280 C)", "color", "k");
text(-1.6,mean(ylim()),"(a)", "fontsize", 16);


hax_pres = subplot(3,1,2);
pressure = [10,0,12;11,13,12;11,32,30; 11, 35, 14; 11, 45, 10; ...
12, 0, 9; 14, 31, 8;15, 0, 7e5; 15, 9, 7e5; 15, 15, 25; ...
15, 30, 10; 16, 0, 8; 19, 0,8; 20, 0, 8 ];
pressure_sec = [pressure(:,1)*3600 + pressure(:,2)*60 - 36000, pressure(:,3)];
pressure_hrs = [pressure_sec(:,1)/3600, pressure_sec(:,2)];
plt_pres = plot(pressure_hrs(:,1), pressure_hrs(:,2), "--k");
ylim([0,60]);
ylabel("Pressure (mTorr)");
text(5.55, 48, "<= Return from atmospheric pressure");
text(-1.6,mean(ylim()),"(b)", "fontsize", 16);


hax_alph = subplot(3,1,3);
plt_alph = plot(all_times/3600-10, all_alphas .* 1e5, ".k");
ylabel("Thermal diffusivity 10^{-5} (m^2/s)");
xlabel("Time (hours)");
text(-1.6,mean(ylim()),"(c)", "fontsize", 16);
refresh();


filename = "~/strand/plots/T_P_alpha_subplots";
print("-dpdflatex", filename);
print("-dpsc", filename);
print("-depsc", filename);
print("-dsvg", filename);
print("-dpdf", filename);
print("-dpng", filename);
