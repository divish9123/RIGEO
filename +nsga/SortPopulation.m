function pop = SortPopulation(pop)

CD = [pop.CrowdingDistance];
[CD, CDSO] = sort(CD, 'descend');
pop = pop(CDSO);

R = [pop.Rank];
[R, RSO] = sort(R, 'ascend');
pop = pop(RSO);

end
