function i = TournamentSelection(pop)

ii = randperm(numel(pop));

i1 = ii(1);
i2 = ii(2);

if pop(i1).Rank < pop(i2).Rank
    i = i1;
elseif pop(i2).Rank < pop(i1).Rank
    i = i2;
else
    if pop(i1).CrowdingDistance > pop(i2).CrowdingDistance
        i = i1;
    else
        i = i2;
    end
end

end
