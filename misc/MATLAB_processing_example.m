% this file is an example of how to use the matlab formatted output file
% generated by https://github.com/greysAcademicCode/batch-iv-analysis

clear variables

% load the .mat file generated by batch-iv-analysis.py
fileName = 'output.mat';
allTheThings = load(fileName);

% we'll need some constants
% calculate values for our model's constants now
cellTemp = 29; %degC all analysis is done assuming the cell is at 29 degC
T = 273.15 + cellTemp; %cell temp in K
K = 1.3806488e-23; %boltzman constant
q = 1.60217657e-19; %electron charge
Vth = K*T/q; %thermal voltage ~26mv

% here we define the non-ideal charactaristic equation for the current
% through a solar cell, given its voltage, Rs, Rsh, I0, Iph and n
charEqn = @(V,Rs,Rsh,I0,Iph,n) (Rs*(I0*Rsh + Iph*Rsh - V) - Vth*n*(Rs + Rsh)*lambertw(I0*Rs*Rsh*exp((Rs*(I0*Rsh + Iph*Rsh - V)/(Rs + Rsh) + V)/(Vth*n))/(Vth*n*(Rs + Rsh))))/(Rs*(Rs + Rsh));

thingNames = fieldnames(allTheThings);
nThings = numel(thingNames);

for index = 1:nThings
    thisThing = allTheThings.(thingNames{index});
    
    i = thisThing.i;
    v = thisThing.v;
    Rs_fit = thisThing.rs;
    Rsh_fit = thisThing.rsh;
    I0_fit = thisThing.i0;
    Iph_fit = thisThing.iph;
    n_fit = thisThing.n;
    
    vMin = min(v);
    vMax = max(v);
    
    % let's define the voltage values to use when plotting the characteristic
    % equation
    nv = 1000;
    vv = linspace(vMin,vMax,nv);
    
    % calculate the char. eqn. current values
    ii = charEqn(vv,Rs_fit,Rsh_fit,I0_fit,Iph_fit,n_fit);
    
    % plot the fit along with the raw data
    figure
    plot(v,i,'.',vv,ii)
    title(thisThing.file,'interpreter','none')
    xlabel('Voltage [V]')
    ylabel('Current [A]')
    grid('on')
end
