function [BestCost,BestSolution] = PSO(npop,rond,works0,fog,tw1,tfog,noww)

CostFunction = @fitness.FitnessEnergy;
nPop = npop;
MaxIt = rond;
VarMin = 1;
VarMax = tfog;
nVar = tw1;
VarSize = [1,nVar];

phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2/(phi-2+sqrt(phi^2-4*phi));
w = chi;
wdamp = 1;
c1 = chi*phi1;
c2 = chi*phi2;

VelMax = 0.1*(VarMax-VarMin);
VelMin = -VelMax;

empty_particle.Position = [];
empty_particle.Cost = [];
empty_particle.Velocity = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

particle = repmat(empty_particle, nPop, 1);
GlobalBest.Cost = inf;
GlobalBest.Position = [];

for i = 1:nPop
    particle(i).Position = max(1, fix(unifrnd(VarMin, VarMax, VarSize)));
    particle(i).Velocity = zeros(VarSize);
    particle(i).Cost = CostFunction(particle(i).Position, works0, fog, tw1, noww);
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost = particle(i).Cost;

    if particle(i).Best.Cost < GlobalBest.Cost
        GlobalBest = particle(i).Best;
    end
end

BestCost = zeros(MaxIt, 1);

for it = 1:MaxIt
    for i = 1:nPop
        if size(GlobalBest.Position,2) ~= size(particle(i).Position,2)
            GlobalBest.Position = particle(i).Best.Position;
        end

        particle(i).Velocity = w*particle(i).Velocity ...
            + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position) ...
            + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

        particle(i).Velocity = max(particle(i).Velocity, VelMin);
        particle(i).Velocity = min(particle(i).Velocity, VelMax);

        particle(i).Position = particle(i).Position + particle(i).Velocity;

        IsOutside = (particle(i).Position < VarMin | particle(i).Position > VarMax);
        particle(i).Velocity(IsOutside) = -particle(i).Velocity(IsOutside);

        particle(i).Position = max(particle(i).Position, VarMin);
        particle(i).Position = min(particle(i).Position, VarMax);
        particle(i).Position = max(1, fix(particle(i).Position));

        particle(i).Cost = CostFunction(particle(i).Position, works0, fog, tw1, noww);

        if particle(i).Cost < particle(i).Best.Cost
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = particle(i).Cost;

            if particle(i).Best.Cost < GlobalBest.Cost
                GlobalBest = particle(i).Best;
            end
        end
    end

    BestCost(it) = GlobalBest.Cost;
    w = w * wdamp;
end

BestSolution = GlobalBest.Position;
end
