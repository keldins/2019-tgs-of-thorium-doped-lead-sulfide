% speeds

load("./kns_evolution_data.mat");

figure();
plot(squezd_times_hrs, all_speeds, "*m" );
hold on;
x = [0,0];
y = ylim();
plot(x,y, "r");
title("SAW speeds in sample over entire experiment")
xlabel("Time (hrs)");
ylabel("SAW speed (m/s)");
text(.2, 2390, "<= annealing stage", "color", "r");
hold off;

filename = "~/strand/plots/SAW_speeds";
print("-dpdflatex", filename);
print("-dpsc", filename);
print("-depsc", filename);
print("-dsvg", filename);
print("-dpdf", filename);
print("-dpng", filename);