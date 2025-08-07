function [params] = model_parameters_inh()

params = struct;

params.step = 0.1;
params.t_end = 100;
params.n = fix( 1000*params.t_end / params.step );
params.N_neurons = 1000;

params.topology = 5; %1 -SF %2 - SW %3-random %4 - full %5 -SF однонаправленный

params.I_EPSCs0 = 4.05; %%%%%3.8;

params.ca_0 = 0.072495;
params.h_0 = 0.886314;
params.ip3_0 = 0.820204;

params.aa = 0.02;
params.b1 = 0.2;
params.c = -65;
params.d = 8;

params.Iapp = 2.5;
params.Amp = 7;
params.t_imp = 30;
params.lambda = 100;

params.neuron_fired_thr = 30;
params.alpha_I = 0.01; %%%%%
params.ksyn = 0.2;
params.threshold_Ca = 0.2;

params.alpha_x0 = 10;
params.k00 = 100;
params.thr_X = 0.022;
params.impact_X = 500; %%%%%
params.impact_Ca = 0.02; %%%%%

params.Esyn0_ex = 0; %%%%%
params.Esyn0_inh = -90; %%%%%

end