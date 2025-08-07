clearvars
rng('shuffle');

tic
params = model_parameters_inh();

frac_inh = 0.1; % frac of inh neurons
N_astro_zone = 5; %number of neurons interacting with one astrocyte

load E.mat
EE = model.Esyn_arr;
[model, indices] = init_model_inh(frac_inh, N_astro_zone);
[model.A1, model.D] = make_connections();
model.Esyn_arr = EE;

model.Inh = ones(length(EE),1);
model.Inh(EE<0) = 0;


%% cycle
Count_Iastro_neuron = zeros(params.N_neurons,1);
for i = 1:params.n

    [model, Count_Iastro_neuron] = count_network_step_inh(params, i, model, Count_Iastro_neuron, indices, N_astro_zone);
    Count_Iastro_neuron = Count_Iastro_neuron -1;

end
toc;

[S] = count_order_param(model.spike1, params.N_neurons, params.n);