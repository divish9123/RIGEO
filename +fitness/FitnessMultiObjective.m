function [k] = FitnessMultiObjective(par,works0,fog,tw1,tfog,noww)

c1_weight = 0.3;
c2_weight = 0.3;
c3_weight = 0.3;

fog22 = fog;
for ii = 1:tw1
    c1 = works0(ii, 1);
    m1 = works0(ii, 2);
    f0 = par(1, ii);
    fc1 = fog22(f0, 1);
    harvest = fog22(f0, 5);
    fcost = fog22(f0, 3);
    ceng = fog22(f0, 7);

    fog22(f0, 2) = fog22(f0, 2) + (c1/(fc1+1));
    noww(1, f0) = noww(1, f0) + (c1/(fc1+1));
    works0(ii, 9) = (c1/(fc1+1)) * fcost;
    works0(ii, 10) = (c1/(fc1+1)) * (ceng - harvest);

    fog22(f0, 1) = fog22(f0, 1) - c1;
    fog22(f0, 4) = fog22(f0, 4) - m1;
end

eng1 = sum(works0(:, 10));
cost1 = sum(works0(:, 9));
lb = (max(fog22(:, 2)) - min(fog22(:, 2))) / ((sum(fog22(:, 2))+1) / tfog);
k = (c1_weight * eng1) + (c2_weight * cost1) + (c3_weight * lb);
end
