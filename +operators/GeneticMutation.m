function y = GeneticMutation(x,mu,VarMin,VarMax)

nVar = numel(x);
nmu = ceil(mu * nVar);
j = randsample(nVar, nmu);
sigma = 0.1 * (VarMax - VarMin);
y = x;

if size(x,2) ~= 0 && size(x,1) ~= 0
    for uu = 1:size(j,1)
        jj = j(uu, 1);
        y(jj) = x(jj) + sigma * randn;
    end
    y = max(y, VarMin);
    y = min(y, VarMax);
else
    y = VarMin;
end

end
