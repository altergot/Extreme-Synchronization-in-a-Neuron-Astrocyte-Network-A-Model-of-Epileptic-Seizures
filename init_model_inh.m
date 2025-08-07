function [model, indices] = init_model_inh(frac_inh, N_astro_zone)
model = struct;
params = model_parameters_inh();
V_0 = -65 + 20*randn(params.N_neurons,1);
model.V = V_0 .* ones(params.N_neurons,1);
model.U = zeros(params.N_neurons,1);
model.spike1 = [];
model.X = zeros(params.N_neurons,1);

N_astro = fix(params.N_neurons ./ N_astro_zone);
model.Ca = zeros(N_astro,1);
model.H = zeros(N_astro,1);
model.IP3 = zeros(N_astro,1);
model.Ca(:,1) = params.ca_0;
model.H(:,1) = params.h_0;
model.IP3(:,1) = params.ip3_0;

model.I_EPSCs = ones(params.N_neurons,1);
model.I_EPSCs = params.I_EPSCs0 .* model.I_EPSCs;

%% count online correlation
% model.spike2 = zeros(params.N_neurons,2);
% model.S = zeros(params.n,1);

%% online puasson
model.pause_counter = zeros(params.N_neurons,1);
model.imp_counter = zeros(params.N_neurons,1);

%%
model.Esyn_arr = zeros(params.N_neurons,1);
N_inh = fix(frac_inh .* params.N_neurons);
indices = randperm(params.N_neurons, N_inh);
model.Esyn_arr(indices) = params.Esyn0_inh;
end