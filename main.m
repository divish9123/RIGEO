clc
clear all
close all

[vio2,vio,alllb,alleng,comptime,tw,tfog,time,rond,tkh,ttkh1,works,fog,iter,npop,runtime,allcost,allVio] = utils.InitializeParameters();

maxload = 100;
olgo = zeros(200, tfog);
[olgo] = utils.GenerateTrafficPattern(tfog, maxload, olgo);
olgo = olgo';

meanload = median(mean(olgo(:,1:end-1), 2));

traffic_labels = zeros(tfog, 1);
for i = 1:tfog
    if mean(olgo(i,1:end-1)) > meanload
        traffic_labels(i) = 1;
    else
        traffic_labels(i) = 0;
    end
end

works3 = works;
prob = zeros(tfog, tfog);

for i = 1:tfog
    for j = 1:i
        if i ~= j
            prob(i,j) = rand;
            prob(j,i) = prob(i,j);
        else
            prob(i,j) = 0;
        end
    end
end

numAlgos = 8;
allcost = zeros(numAlgos, tkh);
alleng = zeros(numAlgos, tkh);
runtime = zeros(numAlgos, tkh);
comptime = zeros(numAlgos, tkh);
allvio = zeros(numAlgos, tkh);
allVio = zeros(numAlgos, tkh);
alllb = zeros(numAlgos, tkh);
vio = zeros(numAlgos, tkh);

for bb = 1:tkh
    fprintf('Task load: %d\n', ttkh1(1,bb));
    tw = ttkh1(1,bb);
    works = works3;
    [works, fog] = utils.GenerateTaskTable(tw, works, time, fog, tfog);
    works2 = works(1:tw,:);
    fog(:,5) = 0.003;

    all_deadlines = works2(:,3);
    deadline_threshold = prctile(all_deadlines, 25);

    fog2 = fog;

    for th = 1:numAlgos
        fog = fog2;
        works = works2;
        tic
        noww = zeros(1, tfog);
        sumvio = 0;

        for ff = 1:time
            curtask = find(works(:,4) == ff);
            works0 = works(curtask,:);
            tw1 = size(curtask, 1);

            if tw1 > 0
                if th == 1
                    [BestCost, BestSolution] = PSO(npop, rond, works0, fog, tw1, tfog, noww);
                    x = BestSolution;
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 2
                    maxiter = rond;
                    [gsol, bestSoFar] = GWO(npop, maxiter, works0, fog, tw1, tfog, noww);
                    x = gsol;
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 3
                    nvars = tw1;
                    lb = 1;
                    ub = tfog;
                    maxiter = rond;
                    fun = @fitness.FitnessMultiObjective;
                    [x, ConvergenceCurve] = GEO(fun, nvars, lb, ub, npop, maxiter, works0, fog, tw1, tfog, noww, bb, ff);
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 4
                    dimension = tw1;
                    lowerbound = 1;
                    upperbound = tfog;
                    fobj = @fitness.FitnessMultiObjective;
                    [Score, Position, Convergence] = SOA(npop, rond, lowerbound, upperbound, dimension, fobj, works0, fog, tw1, tfog, noww);
                    x = Position;
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 5
                    [GlobalBest] = NSGA(rond, npop, works0, fog, tw1, tfog, noww);
                    x = GlobalBest;
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 6
                    [x, cost, eng, noww, fog, sumvio] = WCLAGA(works0, fog, tfog, noww, prob, npop, rond);
                    allcost(th, bb) = allcost(th, bb) + cost;
                    alleng(th, bb) = alleng(th, bb) + eng;
                    perVio = 100 - ((nnz(works0(:,11)) / tw1) * 100);

                elseif th == 7
                    [x] = ETFC(npop, rond, works0, fog, tw1, tfog, noww);
                    [allcost, alleng, noww, fog, sumvio, perVio] = utils.CalculateMetrics(x, works0, fog, tw1, allcost, alleng, th, bb, noww, tkh);

                elseif th == 8
                    [x, cost, eng, noww, fog, sumvio] = RIGEO(works0, fog, tfog, noww, npop, rond, traffic_labels, deadline_threshold, prob);
                    allcost(th, bb) = allcost(th, bb) + cost;
                    alleng(th, bb) = alleng(th, bb) + eng;
                    perVio = 100 - ((nnz(works0(:,11)) / tw1) * 100);
                end
            end
        end

        runtime(th, bb) = max(noww);
        alllb(th, bb) = (max(fog(:,2)) - min(fog(:,2))) / (sum(fog(:,2)) / tfog);
        comptime(th, bb) = toc;
        allvio(th, bb) = sumvio;
        allVio(th, bb) = perVio;
        vio(th, bb) = (sum(noww .* fog(:,1)')) / sum(max(noww) * fog(:,1)) * 100;
    end

    iter(1, bb) = ttkh1(1, bb);
end

figure
bar(iter, runtime')
xlabel('Number of Tasks')
ylabel('Response Time (ms)')
title('Average Total Response Time')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, alleng')
xlabel('Number of Tasks')
ylabel('Energy Consumption (J)')
title('Average Total Energy Consumption')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, allvio')
xlabel('Number of Tasks')
ylabel('Deadline Violation Time (ms)')
title('Average Deadline Violation Time')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, allcost')
xlabel('Number of Tasks')
ylabel('Cost ($)')
title('Total Cost')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, comptime')
xlabel('Number of Tasks')
ylabel('Computational Overhead (s)')
title('Computational Overhead')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, allVio')
xlabel('Number of Tasks')
ylabel('Tasks Meeting Deadline (%)')
title('Percentage of Tasks Meeting Deadline')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, alllb')
xlabel('Number of Tasks')
ylabel('DI')
title('Degree of Imbalancing')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');

figure
bar(iter, vio')
xlabel('Number of Tasks')
ylabel('Utility (%)')
title('Utility of Fog Nodes')
legend('PSO', 'GWO', 'GEO', 'SOA', 'NSGA', 'WCLA+GA', 'ETFC', 'RIGEO', 'Location', 'NorthWest');
