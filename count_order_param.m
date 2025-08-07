function [S] = count_order_param(spike1, N_neurons, n)

fi = zeros(N_neurons,n);
S = zeros(n, 1);

for j = 1:N_neurons
    k = spike1(spike1(:,2)==j,1);
    k = uint32(k);
    if ~isempty(k)
        m = 1;
        for i = k(1):k(end)-1
            fi(j,i) = (single(i) - single(k(m))) / (single(k(m+1)) - single(k(m)));
            if i == k(m+1)
                m = m+1;
            end
        end
    end
end
fi = 2*pi*fi;

%% 1
% Sq = exp(1j * fi);
% S = abs(real(sum(Sq)/1000));

%% 2
for i = 1 : n
    S(i,1) = sum( cos( pdist(fi(:,i),'minkowski',1) ) );
end
S = 0.5 + S / N_neurons / (N_neurons-1);

end