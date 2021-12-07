function [Pk_s,Pk_ind,Cef,mk,fk_max,fk_low,fr_u] = power_input_function(number_of_processors)
format long;
% static power consumed by processor k (in our example is equal for every
% processor )
Pk_s = 0.03*ones(1,number_of_processors);
 
% frequency-independent dynamic power consumed by processor k 
%(in our example is equal for every processor )
Pk_ind =0.05*ones(1,number_of_processors);

%the lowest energy-efficient frequency fk;low for each processor according
%to Eq. (2).

fk_low=0.26*ones(1,number_of_processors);

%maximum frequency fk_max for each processor is 1 frequency precision is set at 0.01
fk_max = ones(1,number_of_processors);


%frequency matrix for every processor

for i=1:1:number_of_processors
fr_u(i,:)=0.26:0.01:1;
end


 
%---------------------- sample and real-life automata module-------------
% Cef represents the effective switching capacitance (in our example is
% diffrent for every processor

Cef=[0.8 0.7 1];


%mrepresents the dynamic power exponent, which should be no smaller than 2
mk=[2.9 2.5 2.5];


%{
% ------------------ for random generated module--------------------------
Cef=[0.8 0.7 1 0.8 0.7 1 0.8 0.7 1 1];
mk=[2.9 2.5 2.5 2.9 2.5 2.5 2.9 2.5 2.5 2.9];
%}




end