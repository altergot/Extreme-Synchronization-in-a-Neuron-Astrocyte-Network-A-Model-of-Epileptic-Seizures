clearvars
rng('shuffle');

tic
params = model_parameters();
[model] = init_model();
[model.A1, model.D] = make_connections();

Ca = zeros(params.N_neurons, params.n);
IP3 = zeros(params.N_neurons, params.n);
V = zeros(params.N_neurons, params.n);
X = zeros(params.N_neurons, params.n);
IPS = zeros(params.N_neurons, params.n);

%% cycle
Count_Iastro_neuron = zeros(params.N_neurons,1);
for i = 1:params.n

    [model, Count_Iastro_neuron] = count_network_step(params, i, model, Count_Iastro_neuron);
    Count_Iastro_neuron = Count_Iastro_neuron -1;
    Ca(:,i) = model.Ca;
    IP3(:,i) = model.IP3;
    V(:,i) = model.V;
    X(:,i) = model.X;
    IPS(:,i) = model.I_EPSCs;

end
toc;


[S] = count_order_param(model.spike1);

figure(1)
clf
h1 = subplot(6,1,1);
plot(0.001 * params.step *(0 : params.n - 1),[smooth(S,5000)]);
h2 = subplot(6,1,2);
plot(0.001 * params.step *(0 : params.n - 1),[V(10,:)]);
h3 = subplot(6,1,3);
plot(0.001 * params.step *(0 : params.n - 1),[X(10,:)]);
h4 = subplot(6,1,4);
plot(0.001 * params.step *(0 : params.n - 1),[IP3(10,:)]);
h5 = subplot(6,1,5);
plot(0.001 * params.step *(0 : params.n - 1),[Ca(10,:)]);
h6 = subplot(6,1,6);
plot(0.001 * params.step *(0 : params.n - 1),[IPS(10,:)]);

figure(2)
clf
h22 = subplot(2,1,1:2);
plot( 0.001*params.step * model.spike1(:,1), model.spike1(:,2), '.k' )
ylabel('raster')
