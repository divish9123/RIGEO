function [allcost,alleng,noww,fog,sumvio,perVio] = CalculateMetrics(x,works0,fog,tw1,allcost,alleng,th,bb,noww,tkh)

sumvio = 0;
perVio = 0;
Koltask = tw1;
tr = rand/tkh;

for ii = 1:tw1
    c1 = works0(ii, 1);
    m1 = works0(ii, 2);
    dead1 = works0(ii, 3);
    qos1 = works0(ii, 5);
    pd = th;
    re = rand;
    f0 = x(1, ii);
    fc1 = fog(f0, 1);
    fm1 = fog(f0, 4);
    harvest = fog(f0, 5);
    fcost = fog(f0, 3);
    thr = fog(f0, 6);
    ceng = fog(f0, 7);
    need = 0;

    if fc1 < c1 || fm1 < m1
        need = 1;
    elseif thr < qos1
        need = 2;
    end

    if need == 0
        st = noww(1, f0);
        fog(f0, 2) = fog(f0, 2) + (c1/(fc1+1));
        works0(ii, 7) = st;
        noww(1, f0) = noww(1, f0) + (c1/(fc1+1));
        works0(ii, 8) = noww(1, f0);
        works0(ii, 9) = (c1/(fc1+1)) * fcost;

        if ceng > harvest
            works0(ii, 10) = (c1/(fc1+1)) * (ceng - harvest);
        else
            works0(ii, 10) = (c1/(fc1+1)) * ceng;
        end

        fog(f0, 1) = fog(f0, 1) - c1;
        fog(f0, 4) = fog(f0, 4) - m1;
    end

    works0(ii, 11) = (c1/(fc1+1)) - dead1;
    if works0(ii, 11) < 0
        works0(ii, 11) = 0;
    else
        sumvio = sumvio + works0(ii, 11);
    end
end

alleng(th, bb) = alleng(th, bb) + sum(works0(:, 10));
allcost(th, bb) = allcost(th, bb) + sum(works0(:, 9));
sumvio = sumvio * (1 + ((5-pd) * tr));
perVio = 100 - ((nnz(works0(:, 11)) / Koltask) * 100);

end
