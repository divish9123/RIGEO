function [gsol,bestSoFar] = GWO(npop,maxiter,works0,fog,tw1,tfog,noww)

varNum = tw1;
dim = tw1;
lb = 1;
ub = tfog;
N = npop;
maxLoop = maxiter;
costFunction = @fitness.FitnessEnergy;

solution.Position = [];
solution.Cost = 0;

GreyWolf = repmat(solution, [N,1]);
for i = 1:N
    GreyWolf(i).Position = fix(rand(1,dim)*(ub-lb)+lb);
    GreyWolf(i).Cost = costFunction(GreyWolf(i).Position, works0, fog, tw1, noww);
end

[value,index] = sort([GreyWolf.Cost]);
AlphaGray = GreyWolf(index(1));
BetaGray = GreyWolf(index(2));
DeltaGray = GreyWolf(index(3));
bestSoFar = zeros(1, maxLoop);

for it = 1:maxLoop
    a = 2 - it*((2)/maxLoop);

    for i = 1:N
        newPosA = utils.UpdatePosition(AlphaGray, GreyWolf(i,:), a);
        newPosB = utils.UpdatePosition(BetaGray, GreyWolf(i,:), a);
        newPosD = utils.UpdatePosition(DeltaGray, GreyWolf(i,:), a);

        GreyWolf(i).Position = fix((newPosA + newPosB + newPosD)./3);

        for hh = 1:varNum
            if GreyWolf(i).Position(hh) > ub || GreyWolf(i).Position(hh) < lb
                GreyWolf(i).Position(hh) = randi(tfog);
            end
        end

        GreyWolf(i).Cost = costFunction(GreyWolf(i).Position, works0, fog, tw1, noww);

        if GreyWolf(i).Cost < AlphaGray.Cost
            AlphaGray = GreyWolf(i);
        elseif GreyWolf(i).Cost < BetaGray.Cost
            BetaGray = GreyWolf(i);
        elseif GreyWolf(i).Cost < DeltaGray.Cost
            DeltaGray = GreyWolf(i);
        end
    end
    bestSoFar(it) = AlphaGray.Cost;
end

gsol = AlphaGray.Position;
end
