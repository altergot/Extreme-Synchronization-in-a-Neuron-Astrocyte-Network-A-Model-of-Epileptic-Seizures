function [A1, D] = make_connections()
params = model_parameters();

if params.topology == 1
    %% 1 SF
    load SF_1000_3_3.mat
    A1 = A100;
elseif params.topology == 2
    %% 2 SW
    [h,s,t] = WattsStrogatz(params.N_neurons,200,0.02);
    A1=zeros(params.N_neurons,params.N_neurons);
    for i=1:params.N_neurons
        for j= 1:200
            A1(s(i,j),t(i,j)) = 1;
        end
    end
    A1 = A1';
elseif params.topology == 3
    %% 3 RANDOM
    N_c_full = 10000;
    A1= zeros(params.N_neurons, params.N_neurons);
    A2 = rand(N_c_full,1);
    A2 = fix(A2 .* params.N_neurons .* params.N_neurons);
    A1 = A1(:);
    A2(A2==0)=[];
    A1(A2,1) = 1;
    A1 = reshape(A1, params.N_neurons, params.N_neurons);
elseif params.topology == 4
    %% 4 FULL
    A1= zeros(params.N_neurons, params.N_neurons);
    A1(:,:) = 1;
    for qw1 = 1:params.N_neurons
        for qw2 = 1:params.N_neurons
            if qw1 == qw2
                A1(qw1,qw2) = 0;
            end
        end
    end
elseif params.topology == 5
    %% 5 SF odnonapravlen
    %load SF_1000_6_6.mat
    load A.mat
    %A1 = A100;
    A1 = A;

    % for i=2:params.N_neurons
    %     k=i;
    %     m=1;
    %     for j=1:params.N_neurons
    %         if (m>params.N_neurons) || (k>params.N_neurons)
    %             break;
    %         end
    %         if (A1(m,k)==1)
    %             K = rand(1,1)<0.5;
    %             if (K==1)
    %                 A1(m,k)=0;
    %             else
    %                 A1(k,m)=0;
    %             end
    %         end
    %         m=m+1;
    %         k=k+1;
    %     end
    % end

end
%%
D = sum(A1,2);
end

function [h,s,t] = WattsStrogatz(N,K,beta)
% nodes, N*K edges, mean node degree 2*K, and rewiring probability beta.
% beta = 0 is a ring lattice, and beta = 1 is a random graph.
% Connect each node to its K next and previous neighbors. This constructs
% indices for a ring lattice.
s = repelem((1:N)',1,K);
t = s + repmat(1:K,N,1);
t = mod(t-1,N)+1; % Rewire the target node of each edge with probability beta
for source=1:N
    switchEdge = rand(K, 1) < beta;
    newTargets = rand(N, 1);
    newTargets(source) = 0;
    newTargets(s(t==source)) = 0;
    newTargets(t(source, ~switchEdge)) = 0;
    [~, ind] = sort(newTargets, 'descend');
    t(source, switchEdge) = ind(1:nnz(switchEdge));
end
h = graph(s,t);
end