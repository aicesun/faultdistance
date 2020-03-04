function  PT = locate(x,xx)

% finds j such that xx(j) < x <= xx(j+1)
% EXCEPT if x = xx(1), then j = 1 (logically it would be 0 from
% the above relation, but this is the same returned value of j
% for a point out of range).
% Also, if x = xx(n), j = n-1, which is OK
% Note that j = 0 or j = n indicates that x is out of range.

PT = 0;
n = length(xx);
ju = n;
jl = 1;

if x >= xx(n)
    PT = n;
elseif x <= xx(1)
    PT=1;
else
    m = find( xx < x);
    PT = max(m);
end
