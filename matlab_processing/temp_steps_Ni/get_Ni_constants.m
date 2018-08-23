function [c11,c12,c44,rho]=get_Ni_constants(temp,plotty)
% Use literature data to grab the fourth order elastic constants of pure Ni
% as a function of temperature (in celcius)
%NOTE data only goes up to 487C

%Calibration elastic constants are from Epstein and Carlson Acta. Metal.
%(1965)
cal_c11=248.1; %in GPa at 25C
cal_c12=154.9; %in GPa at 25C
cal_c44=124.2; %in GPa at 25C

%Constant v temp information is from Alers, Neighbours, and Sato J. Phys. Chem.
%Solids (1960)

if nargin<2
    plotty=0;
end

temp=temp+273;

if temp>1670
    display('Temp too high')
    c11=0;
    c12=0;
    c44=0;
    rho=0;
else
    
    %In Kelvin
    ref_temp=[0 20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760];
    %in 10^12 dyne/cm^2
    ref_c11=[2.612 2.612 2.610 2.605 2.601 2.595 2.587 2.578 2.569 2.562 2.553 2.545 2.535 2.526 2.516 2.508 2.497 2.488 2.477 2.466 2.454 2.443 2.431 2.419 2.407 2.396 2.381 2.369 2.352 2.337 2.322 2.309 2.295 2.282 2.270 2.261 2.250 2.241 2.232];
    ref_c12=[1.508 1.508 1.508 1.507 1.507 1.507 1.505 1.504 1.503 1.502 1.501 1.501 1.501 1.500 1.500 1.500 1.499 1.500 1.499 1.498 1.496 1.495 1.493 1.493 1.491 1.490 1.487 1.487 1.484 1.481 1.478 1.479 1.479 1.478 1.476 1.473 1.470 1.467 1.464];
    ref_c44=[1.317 1.317 1.316 1.314 1.309 1.304 1.298 1.291 1.284 1.277 1.270 1.263 1.256 1.249 1.242 1.235 1.228 1.220 1.213 1.205 1.198 1.190 1.183 1.175 1.167 1.159 1.152 1.143 1.135 1.126 1.118 1.109 1.100 1.093 1.086 1.079 1.072 1.065 1.058];
    
    [min_diff,ind]=min(abs(ref_temp-temp));
    
    %Use a linear interpolation for points that fall within the data range for
    %the elastic constants, but if given temp is above 760K, use a linear fit
    %to data above 300K   
    [~,ind_300]=min(abs(ref_temp-250));
    ref_temp_fit=ref_temp(ind_300:end);
    ref_c11_fit=ref_c11(ind_300:end);
    ref_c12_fit=ref_c12(ind_300:end);
    ref_c44_fit=ref_c44(ind_300:end);
    
    f_c11=fit(ref_temp_fit',ref_c11_fit','poly1');
    f_c12=fit(ref_temp_fit',ref_c12_fit','poly1');
    f_c44=fit(ref_temp_fit',ref_c44_fit','poly1');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Calibration value block %%%
    cal_temp=25+273;

    cal_dat_c11=interpolate_general(cal_temp,ref_temp,ref_c11);
    cal_dat_c12=interpolate_general(cal_temp,ref_temp,ref_c12);
    cal_dat_c44=interpolate_general(cal_temp,ref_temp,ref_c44);
    
    cal_dat_c11=cal_dat_c11*100; %put in GPa as output
    cal_dat_c12=cal_dat_c12*100; %put in GPa as output
    cal_dat_c44=cal_dat_c44*100; %put in GPa as output
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%Calculate calibration factor%%%
    c11_factor=cal_c11/cal_dat_c11;
    c12_factor=cal_c12/cal_dat_c12;
    c44_factor=cal_c44/cal_dat_c44;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if min_diff==0
        c11=ref_c11(ind)*100;
        c12=ref_c12(ind)*100;
        c44=ref_c44(ind)*100;
    elseif temp<=250 %should be 760 to match data       
        c11=interpolate_general(temp,ref_temp,ref_c11);
        c12=interpolate_general(temp,ref_temp,ref_c12);
        c44=interpolate_general(temp,ref_temp,ref_c44);
        
        c11=c11*100; %put in GPa as output
        c12=c12*100; %put in GPa as output
        c44=c44*100; %put in GPa as output
    else
        c11=f_c11(temp)*100;
        c12=f_c12(temp)*100;
        c44=f_c44(temp)*100;
    end
    
    %%Calibrate%%
    c11=c11*c11_factor;
    c12=c12*c12_factor;
    c44=c44*c44_factor;
    %%%%%%%%%%%%%
    
    %density bloc
    %used to determine the density of Ni as a function of temperature in
    %celcius benchmarked by the x-ray lattice parameter vs. temp data in Suh
    %(1988) J. Mat. Sci.
    
    RT_density=8.908; %in g/cm^3
    
    d_data=[0.3524 0.3524 0.3538 0.3542 0.3544 0.3548 0.3552 0.3562 0.3563 0.3570 0.3571 0.3578 0.3581 0.3587 0.3590 0.3595 0.3604 0.3603 0.3614 0.3615]; %in nm
    d_temp=[293 293 578 629 676 754 825 976 1007 1107 1123 1225 1256 1345 1383 1433 1543 1553 1671 1676]; %in K
    
    quad_fit=fit(d_temp',d_data','poly2');
    lattice_out=quad_fit(temp);
    
    RT_lattice=0.3524; %in nm from two data points from paper
    rho=(RT_lattice/lattice_out)^3*RT_density;
    
    if plotty
        fit_temps=760:20:1300;
        figure()
        plot(ref_temp-273,(ref_c11*100)*c11_factor,'r--')
        hold on
        plot(ref_temp-273,(ref_c12*100)*c12_factor,'b--')
        hold on
        plot(ref_temp-273,(ref_c44*100)*c44_factor,'m--')
        hold on
        plot(fit_temps-273,(f_c11(fit_temps)*100)*c11_factor,'r--')
        hold on
        plot(fit_temps-273,(f_c12(fit_temps)*100)*c12_factor,'b--')
        hold on
        plot(fit_temps-273,(f_c44(fit_temps)*100)*c44_factor,'m--')
        hold on
        plot([temp temp temp]-273,[c11 c12 c44],'kd','MarkerSize',8,'MarkerFaceColor','k');
        hold on
        legend({'C_{11}','C_{12}','C_{44}'});
        xlim([-273 1000])
        set(gca,...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',16,...
            'FontName','Helvetica',...
            'LineWidth',1.25)
        ylabel({'Elastic Constants [GPa]'},...
            'FontUnits','points',...
            'FontSize',20,...
            'FontName','Helvetica')
        xlabel({'Temp. [C]'},...
            'FontUnits','points',...
            'FontSize',20,...
            'FontName','Helvetica')
        
        figure()
        plot((200:20:1800)-273,(RT_lattice./quad_fit(200:20:1800)).^3*RT_density,'k-');
        hold on
        plot(d_temp-273,(RT_lattice./d_data).^3*RT_density,'bd','MarkerFaceColor','b')
        hold on
        plot(temp-273,rho,'rx','MarkerSize',16,'LineWidth',2)
        xlim([0 1000])
        set(gca,...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',16,...
            'FontName','Helvetica',...
            'LineWidth',1.25)
        ylabel({'Density [g/cm^3]'},...
            'FontUnits','points',...
            'FontSize',20,...
            'FontName','Helvetica')
        xlabel({'Temp. [C]'},...
            'FontUnits','points',...
            'FontSize',20,...
            'FontName','Helvetica')
    end
end

end

