function [works,fog] = GenerateTaskTable(tw,works,time,fog,tfog)

for jj = 1:tw
    works(jj, 1) = randi(5);
    works(jj, 2) = rand;
    works(jj, 3) = rand;
    works(jj, 4) = randi(time);
    works(jj, 5) = rand;
end

for jj = 1:tfog
    fog(jj, 1) = 80 + randi(20);
    fog(jj, 3) = rand;
    fog(jj, 4) = 4 + randi(12);
    fog(jj, 5) = rand;
    fog(jj, 6) = 0.5 + rand;
    fog(jj, 7) = rand + 2 + randi(3);
end

end
