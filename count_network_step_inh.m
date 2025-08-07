function [model, Count_Iastro_neuron] = count_network_step_inh(params,i, model, Count_Iastro_neuron, indices, N_astro_zone)
spiked = false(params.N_neurons,1);
spiked( model.V == 30 ) = true;
Nospiked = find(spiked);
model.spike1 = [model.spike1; i+0*Nospiked Nospiked];

%% Poisson noise
num = find(model.pause_counter == 0);
if (length(num)>0)
    for q = 1: length(num)
        model.pause_counter(num(q),1) = 10 * poissrnd(params.lambda,1,1);
        model.imp_counter(num(q),1) = params.t_imp;
    end
end
Ipuass = zeros(params.N_neurons,1);
Ipuass(model.imp_counter > 0) = 1;

%%
model.X = model.X - params.step .* (params.alpha_x0 .* model.X - params.k00 .* spiked) ./ 1000;
model.X = model.X .* model.Inh; % inhibitory neurons do not release glutamate

arr_I_neuro = zeros(params.N_neurons,1);
arr_I_neuro_astro = zeros(fix(params.N_neurons ./ N_astro_zone),1);
Az = find(model.X >= params.thr_X);

arr_I_neuro(Az, 1) = model.X(Az, 1);

B = reshape(arr_I_neuro, N_astro_zone, fix(params.N_neurons ./ N_astro_zone));   %
B = (sum(B, 1))';
Az2 = find(B >= (params.thr_X .* 2));
arr_I_neuro_astro(Az2, 1) = params.impact_X  .* B(Az2, 1) ./ 3;


Iastro_neuron = zeros(fix(params.N_neurons ./ N_astro_zone),1);

c0 = 2.0; c1 = 0.185;
v1 = 6.0; v2 = 0.11; v3 = 2.2; v4 = 0.3; v6 = 0.2;
k1 = 0.5; k2 = 1.0; k3 = 0.1; k4 = 1.1;
d1 = 0.13; d2 = 1.049; d3 = 0.9434; d5 = 0.082;
IP3s = 0.16;
Tr = 0.14;
a = 0.8; a2 = 0.14;

M = model.IP3 ./ (model.IP3 + d1);
NM = model.Ca ./ (model.Ca + d5);
Ier = c1 .* v1 .* (M .^ 3) .* (NM .^ 3) .* (model.H .^ 3) .* (((c0 - model.Ca) ./ c1) - model.Ca);
Ileak = c1 .* v2 .* (((c0 - model.Ca) ./ c1) - model.Ca);
Ipump = v3 .* (model.Ca .^ 2) ./ (model.Ca .^ 2 + k3 .^ 2);
Iin = v6 .* (model.IP3 .^ 2 ./ (k2 .^ 2 + model.IP3 .^ 2));
Iout = k1 .* model.Ca;
Q2 = d2 .* ((model.IP3 + d1) ./ (model.IP3 + d3));
h = Q2 ./ (Q2 + model.Ca);
Tn = 1.0 ./ (a2 .* (Q2 + model.Ca));
Iplc = v4 .* ((model.Ca + (1.0 - a) .* k4) ./ (model.Ca + k4));

model.Ca = model.Ca + params.step .*  (Ier - Ipump + Ileak + Iin - Iout) ./ 1000;
model.H = model.H + params.step .* ((h - model.H) ./ Tn) ./1000;
model.IP3 = model.IP3 + params.step .* ((IP3s - model.IP3) * Tr + Iplc + arr_I_neuro_astro) ./1000;

Az = find(model.Ca >= params.threshold_Ca);
Count_Iastro_neuron (Az,1) = 50000;
Iastro_neuron(Count_Iastro_neuron > 0,1) = 1;
Iastro_neuron = repelem(Iastro_neuron, N_astro_zone);
Ca = repelem(model.Ca, N_astro_zone);

model.I_EPSCs = model.I_EPSCs + params.step .*  (params.alpha_I *(params.I_EPSCs0 - model.I_EPSCs) - params.impact_Ca .* max(Ca,params.threshold_Ca)  .* Iastro_neuron);
model.I_EPSCs = model.I_EPSCs .* model.Inh; % astrocyte does not affect the weight of inhibitory connections;
model.I_EPSCs(model.Inh == 0) = 3;

S1 = 1 ./ (1 + exp((-model.V ./ params.ksyn)));
Isyn = sum(model.A1.*S1', 2) .*(model.Esyn_arr - model.V) .* model.I_EPSCs ./ model.D;
Isyn(model.D == 0) = 0;

%% Izhikevich
fired = find(model.V >= params.neuron_fired_thr);
model.V(fired) = params.c;
model.U(fired) =  model.U(fired) + params.d;

model.V = model.V + params.step * (0.04*model.V.^2 + 5*model.V + 140 + Isyn + params.Iapp + params.Amp .* Ipuass - model.U);

model.U = model.U + params.step * params.aa * (params.b1 * model.V - model.U);
model.V = min(model.V, params.neuron_fired_thr);

model.pause_counter = model.pause_counter - 1;
model.imp_counter = model.imp_counter - 1;

end