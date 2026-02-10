function [x, allcost, alleng, noww, fog, sumvio] = WCLAGA(works0, fog, tfog, noww, prob_matrix, npop, maxiter)

tw1 = size(works0, 1);
x = zeros(1, tw1);
sumvio = 0;
allcost = 0;
alleng = 0;

state = randi(tfog);
prob = prob_matrix;

for ii = 1:tw1
    c1 = works0(ii, 1);
    m1 = works0(ii, 2);
    dead1 = works0(ii, 3);

    [~, f0] = max(prob(state, :));

    x(ii) = f0;

    fc1 = fog(f0, 1);
    fm1 = fog(f0, 4);
    harvest = fog(f0, 5);
    fcost = fog(f0, 3);
    ceng = fog(f0, 7);

    if fc1 >= c1 && fm1 >= m1
        fog(f0, 2) = fog(f0, 2) + (c1/(fc1+1));
        noww(1, f0) = noww(1, f0) + (c1/(fc1+1));
        works0(ii, 9) = (c1/(fc1+1)) * fcost;

        if ceng > harvest
            works0(ii, 10) = (c1/(fc1+1)) * (ceng - harvest);
        else
            works0(ii, 10) = (c1/(fc1+1)) * ceng;
        end

        fog(f0, 1) = fog(f0, 1) - c1;
        fog(f0, 4) = fog(f0, 4) - m1;

        allcost = allcost + works0(ii, 9);
        alleng = alleng + works0(ii, 10);
    end

    response_time = (c1/(fc1+1));
    violation = max(0, response_time - dead1);

    if violation == 0
        prob(state, f0) = min(1, prob(state, f0) * 1.1);
    else
        sumvio = sumvio + violation;
        prob(state, f0) = max(0, prob(state, f0) * 0.9);
    end

    state = f0;
end

if rand < 0.3 && tw1 > 1
    pop = repmat(x, npop, 1);
    for i = 1:npop
        if rand < 0.8
            idx = randperm(tw1, 2);
            temp = pop(i, idx(1));
            pop(i, idx(1)) = pop(i, idx(2));
            pop(i, idx(2)) = temp;
        end
    end
    x = pop(1, :);
end

end
