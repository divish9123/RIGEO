function [x,ConvergenceCurve] = IGEO(fun,nvars,lb,ub,npop,maxiter,works0,fog,tw1,tfog,noww)

AttackPropensity = [0.5, 2];
CruisePropensity = [1, 0.5];
PopulationSize = npop;
MaxIterations = maxiter;
x = zeros(PopulationSize, nvars);
ConvergenceCurve = zeros(1, MaxIterations);

for i = 1:PopulationSize
    x(i,:) = fix(lb + (rand(1,nvars) * (ub-lb)));
end

FitnessScores = zeros(1, PopulationSize);
for i = 1:PopulationSize
    FitnessScores(i) = fun(x(i,:), works0, fog, tw1, tfog, noww);
end

FlockMemoryF = FitnessScores;
FlockMemoryX = x;

AttackPropensity = linspace(AttackPropensity(1), AttackPropensity(2), MaxIterations);
CruisePropensity = linspace(CruisePropensity(1), CruisePropensity(2), MaxIterations);

for CurrentIteration = 1:MaxIterations

    DestinationEagle = randperm(PopulationSize)';
    AttackVectorInitial = FlockMemoryX(DestinationEagle,:) - x;
    Radius = utils.VectorNorm(AttackVectorInitial, 2, 2);
    ConvergedEagles = sum(Radius,2) == 0;
    UnconvergedEagles = ~ConvergedEagles;
    CruiseVectorInitial = 2 .* rand(PopulationSize, nvars) - 1;

    for i1 = 1:PopulationSize
        if UnconvergedEagles(i1)
            vConstrained = false([1, nvars]);
            idx = datasample(find(AttackVectorInitial(i1,:)), 1, 2);
            vConstrained(idx) = 1;
            vFree = ~vConstrained;
            CruiseVectorInitial(i1,idx) = -sum(AttackVectorInitial(i1,vFree).*CruiseVectorInitial(i1,vFree),2) ./ (AttackVectorInitial(i1,vConstrained)+1);
        end
    end

    StepVector = zeros(PopulationSize, nvars);
    for uu = 1:nvars
        AttackVectorUnit = AttackVectorInitial(:,uu) ./ (utils.VectorNorm(AttackVectorInitial, 2, 2)+1);
        CruiseVectorUnit = CruiseVectorInitial(:,uu) ./ (utils.VectorNorm(CruiseVectorInitial, 2, 2)+1);
        AttackVector = rand(PopulationSize, 1) .* AttackPropensity(CurrentIteration) .* Radius .* AttackVectorUnit;
        CruiseVector = rand(PopulationSize, 1) .* CruisePropensity(CurrentIteration) .* Radius .* CruiseVectorUnit;
        StepVector(:,uu) = AttackVector + CruiseVector;
    end

    [~, bestIdx] = min(FlockMemoryF);
    x_best = FlockMemoryX(bestIdx, :);

    for i1 = 1:PopulationSize
        r = rand;
        x_t = x(i1, :);

        if sum(StepVector(i1,:)) < 0
            if r >= 0.5
                x(i1,:) = operators.GeneticMutation(x_best, 0.1, lb, ub);
            else
                x(i1,:) = operators.GeneticMutation(x_t, 0.1, lb, ub);
            end
        else
            if r >= 0.5
                cutpoint = randi([1, nvars-1]);
                x(i1,:) = [x_best(1:cutpoint), x_t(cutpoint+1:end)];
            else
                points = sort(randperm(nvars, 2));
                x(i1,:) = x_t;
                x(i1,points(1):points(2)) = x_best(points(1):points(2));
            end
        end

        Flag4Upper_bound = x(i1,:) > ub;
        Flag4Lower_bound = x(i1,:) < lb;
        x(i1,:) = (x(i1,:).*(~(Flag4Upper_bound+Flag4Lower_bound))) + ub.*Flag4Upper_bound + lb.*Flag4Lower_bound;
        x(i1,:) = max(1, fix(x(i1,:)));
    end

    for i = 1:PopulationSize
        FitnessScores(i) = fun(x(i,:), works0, fog, tw1, tfog, noww);
    end

    UpdateMask = FitnessScores < FlockMemoryF;
    FlockMemoryF(UpdateMask) = FitnessScores(UpdateMask);
    FlockMemoryX(UpdateMask,:) = x(UpdateMask,:);
    ConvergenceCurve(CurrentIteration) = min(FlockMemoryF);
end

[fval, fvalIndex] = min(FlockMemoryF);
x = FlockMemoryX(fvalIndex, :);
end
