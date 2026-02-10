function newPos = UpdatePosition(AlphaGray,GreyWolf,a)

for j = 1:size(AlphaGray.Position, 2)
    r1 = rand();
    r2 = rand();
    A1 = 2*a*r1 - a;
    C1 = 2*r2;
    D = abs(C1*AlphaGray.Position(:,j) - GreyWolf.Position(:,j));
    newPos(:,j) = fix(AlphaGray.Position(:,j) - A1*D);
end

end
