function N = VectorNorm(A, p, dim)

N = nthroot(sum(A.^p, dim), p);

end
