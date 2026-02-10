function y = SimpleMutation(x)

nVar = numel(x);
j = randi(nVar);
y = x;
y(j) = 1 - y(j);

end
