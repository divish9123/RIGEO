function [GlobalBest] = NSGA(rond,npop,works0,fog,tw1,tfog,noww)

CostFunction = @fitness.FitnessCostMakespan;
nVar = tw1;
VarSize = [1 nVar];
lb = ones(VarSize);
ub = (tfog)*ones(VarSize);
MaxIt = rond;
VarMin = lb;
VarMax = ub;

nPop = npop;
pCrossover = 0.8;
nCrossover = round(pCrossover*nPop/2)*2;
pMutation = 0.3;
nMutation = round(pMutation*nPop);
gamma = 0.05;
mu = 0.1;

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.CrowdingDistance = [];
empty_individual.DominatedCount = [];
empty_individual.DominationSet = [];

pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
    pop(i).Position = max(1, fix(unifrnd(VarMin, VarMax, VarSize)));
    pop(i).Cost = CostFunction(pop(i).Position, works0, fog, tw1, noww);
end

[pop F] = nsga.NonDominatedSorting(pop);
pop = nsga.CalcCrowdingDistance(pop, F);

for it = 1:MaxIt

    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        i1 = operators.TournamentSelection(pop);
        i2 = operators.TournamentSelection(pop);
        [popc(k,1).Position popc(k,2).Position] = operators.GeneticCrossover(pop(i1).Position, pop(i2).Position, gamma, VarMin, VarMax);
        popc(k,1).Position = max(1, fix(popc(k,1).Position));
        popc(k,2).Position = max(1, fix(popc(k,2).Position));
        popc(k,1).Cost = CostFunction(popc(k,1).Position, works0, fog, tw1, noww);
        popc(k,2).Cost = CostFunction(popc(k,2).Position, works0, fog, tw1, noww);
    end
    popc = popc(:);

    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        i = operators.TournamentSelection(pop);
        popm(k).Position = operators.SimpleMutation(pop(i).Position);
        popm(k).Position = max(1, fix(popm(k).Position));
        popm(k).Cost = CostFunction(popm(k).Position, works0, fog, tw1, noww);
    end

    pop = [pop; popc; popm];

    [pop F] = nsga.NonDominatedSorting(pop);
    pop = nsga.CalcCrowdingDistance(pop, F);
    pop = nsga.SortPopulation(pop);
    pop = pop(1:nPop);

    [pop F] = nsga.NonDominatedSorting(pop);
    pop = nsga.CalcCrowdingDistance(pop, F);

    PF = pop(F{1});
    PFCosts = [PF.Cost];
end

GlobalBest = PF(1).Position;
end
