function [Score,Position,Convergence] = SOA(SearchAgents,Maxiterations,lowerbound,upperbound,dimension,fobj,works0,fog,tw1,tfog,noww)

Score = inf;
Position = zeros(1, dimension);
Positions = fix(lowerbound + rand(SearchAgents, dimension) * (upperbound - lowerbound));
Convergence = zeros(1, Maxiterations);

l = 0;
while l < Maxiterations
    for i = 1:size(Positions,1)
        Flag4Upper_bound = Positions(i,:) > upperbound;
        Flag4Lower_bound = Positions(i,:) < lowerbound;
        Positions(i,:) = max(1, fix((Positions(i,:).*(~(Flag4Upper_bound+Flag4Lower_bound))) + upperbound.*Flag4Upper_bound + lowerbound.*Flag4Lower_bound));

        fitness = fobj(Positions(i,:), works0, fog, tw1, tfog, noww);

        if fitness < Score
            Score = fitness;
            Position = Positions(i,:);
        end
    end

    Fc = 2 - l*((2)/Maxiterations);

    for i = 1:size(Positions,1)
        for j = 1:size(Positions,2)
            r1 = rand();
            r2 = rand();
            A1 = 2*Fc*r1 - Fc;
            C1 = 2*r2;
            b = 1;
            ll = (Fc-1)*rand() + 1;
            D_alphs = Fc*Positions(i,j) + A1*((Position(1,j) - Positions(i,j)));
            X1 = D_alphs*exp(b.*ll).*cos(ll.*2*pi) + Position(1,j);
            Positions(i,j) = abs(fix(X1));
        end
    end

    l = l + 1;
    Convergence(l) = Score;
end
end
