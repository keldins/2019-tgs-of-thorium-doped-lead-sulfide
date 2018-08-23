function [peak_depth,dose,depth]=read_SRIM_vac(file_name,grat,plotty)
%reference number densities
% Ni - 9.14*10^22 in 1/cm^3 (RT)
% Ni - 8.926*10^22 in 1/cm^3 (at 550C)
% Cu - 8.491*10^22 in 1/cm^3
% Cu - 8.314*10^22 in 1/cm^3 (at 400C)
% Al - 6.026*10^22 in 1/cm^3
% Si - 4.996*10^22 in 1/cm^3
% W  - 6.306*10^22 in 1/cm^3

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read in the SRIM VACANCY.txt files to calculate the dose over fluence from a given SRIM run.
%If you run the function as it is called from the processing scripts used here, it will spit out what you need.
%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3
    plotty=1;
    plot_grat=1;
end

number_elements=1;

elementary_charge=1.6021766e-19;

beam_current=1000e-9; %in amps
charge_state=5; %in integers of e
q=charge_state*elementary_charge; %in C
spot_size=pi*(0.3/2)^2; %in cm^2
% spot_size=0.1;

if nargin<2
    plot_grat=0;
else
    plot_grat=1;
end

vac_file_whole=textscan(fopen(file_name),'%s');
n_density=str2double(vac_file_whole{1}{65});
% n_density=str2double(vac_file_whole{1}{63});
fclose('all');

vac_data=dlmread(file_name,'',[27+number_elements-1 0 126+number_elements-1 2]);
depth=vac_data(:,1)/(10^4); %depth in um
total_vac=vac_data(:,2)+vac_data(:,3); %in #/angstrom*ion
total_vac_cm=total_vac*10^8; %in #/cm*ion

[peak_dose,peak_location]=max(total_vac_cm);
peak_depth=depth(peak_location);

dpa_over_fluence=total_vac_cm/n_density;
peak_dpa_over_fluence=peak_dose/n_density;

dose=dpa_over_fluence;

if plotty
    figure()
    plot(depth,dpa_over_fluence,'k-','LineWidth',1.25)
    if plot_grat
        hold on
        y_lims=ylim;
        plot([grat grat],[y_lims(1) y_lims(2)],'b--','LineWidth',1.25)
        hold on
        plot([grat/pi grat/pi],[y_lims(1) y_lims(2)],'r--','LineWidth',1.25);
    end
    hold on
    set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25)
    ylabel({'DPA/fluence [cm^2/ion]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel(['Depth [' 956 'm]'],...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
end

end