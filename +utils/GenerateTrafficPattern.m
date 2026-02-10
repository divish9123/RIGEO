function [olgo] = GenerateTrafficPattern(bst,maxload,olgo)

for jj = 1:200
    for ii = 1:bst
        olgo(jj, ii) = randi(maxload);
    end
end

end
