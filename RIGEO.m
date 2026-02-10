function [x_final, allcost, alleng, noww, fog, sumvio] = RIGEO(works0, fog, tfog, noww, npop, maxiter, traffic_labels, deadline_threshold, prob_matrix)

tw1 = size(works0, 1);
x_final = zeros(1, tw1);
sumvio = 0;
allcost = 0;
alleng = 0;

short_deadline_idx = find(works0(:,3) < deadline_threshold);
long_deadline_idx = find(works0(:,3) >= deadline_threshold);

low_traffic_nodes = find(traffic_labels == 0);
high_traffic_nodes = find(traffic_labels == 1);

if isempty(low_traffic_nodes)
    low_traffic_nodes = 1:tfog;
end
if isempty(high_traffic_nodes)
    high_traffic_nodes = 1:tfog;
end

if ~isempty(short_deadline_idx)
    short_tasks = works0(short_deadline_idx, :);
    tw_short = length(short_deadline_idx);

    nvars = tw_short;
    lb = 1;
    ub = length(low_traffic_nodes);
    fun = @fitness.FitnessMultiObjective;

    [x_short, ~] = IGEO(fun, nvars, lb, ub, npop, maxiter, short_tasks, fog, tw_short, tfog, noww);

    for ii = 1:tw_short
        x_final(short_deadline_idx(ii)) = low_traffic_nodes(x_short(ii));
    end
end

if ~isempty(long_deadline_idx)
    long_tasks = works0(long_deadline_idx, :);
    tw_long = length(long_deadline_idx);

    state = high_traffic_nodes(randi(length(high_traffic_nodes)));
    prob = prob_matrix;

    for ii = 1:tw_long
        prob_high = prob(state, high_traffic_nodes);
        [~, max_idx] = max(prob_high);
        f0 = high_traffic_nodes(max_idx);

        x_final(long_deadline_idx(ii)) = f0;

        c1 = long_tasks(ii, 1);
        m1 = long_tasks(ii, 2);
        dead1 = long_tasks(ii, 3);
        fc1 = fog(f0, 1);
        fm1 = fog(f0, 4);
        harvest = fog(f0, 5);
        fcost = fog(f0, 3);
        ceng = fog(f0, 7);

        if fc1 >= c1 && fm1 >= m1
            fog(f0, 2) = fog(f0, 2) + (c1/(fc1+1));
            noww(1, f0) = noww(1, f0) + (c1/(fc1+1));
            long_tasks(ii, 9) = (c1/(fc1+1)) * fcost;
            if ceng > harvest
                long_tasks(ii, 10) = (c1/(fc1+1)) * (ceng - harvest);
            else
                long_tasks(ii, 10) = (c1/(fc1+1)) * ceng;
            end
            fog(f0, 1) = fog(f0, 1) - c1;
            fog(f0, 4) = fog(f0, 4) - m1;
            allcost = allcost + long_tasks(ii, 9);
            alleng = alleng + long_tasks(ii, 10);
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
end

end
