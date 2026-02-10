function [x] = ETFC(npop, maxiter, works0, fog, tw1, tfog, noww)

nPop = npop;
MaxIt = maxiter;
nVar = tw1;
VarMin = 1;
VarMax = tfog;

pop = zeros(nPop, nVar);
fitness = zeros(nPop, 1);

for i = 1:nPop
    pop(i,:) = fix(VarMin + rand(1, nVar) * (VarMax - VarMin));
    fitness(i) = fitness.FitnessMultiObjective(pop(i,:), works0, fog, tw1, tfog, noww);
end

for it = 1:MaxIt
    [~, best_idx] = min(fitness);
    best_sol = pop(best_idx, :);

    for i = 1:nPop
        if rand < 0.5
            cutpoint = randi([1, nVar-1]);
            pop(i,:) = [best_sol(1:cutpoint), pop(i, cutpoint+1:end)];
        else
            idx = randi(nVar);
            pop(i, idx) = randi([VarMin, VarMax]);
        end

        pop(i,:) = max(VarMin, min(VarMax, fix(pop(i,:))));
        fitness(i) = fitness.FitnessMultiObjective(pop(i,:), works0, fog, tw1, tfog, noww);
    end
end

[~, best_idx] = min(fitness);
x = pop(best_idx, :);
end
