function totalcost = totcost(gencost, Pg)
%TOTCOST    Computes total cost for generators at given output level.
%   totalcost = totcost(gencost, Pg) computes total cost for generators given
%   a matrix in gencost format and a column vector or matrix of generation
%   levels. The return value has the same dimensions as Pg. Each row
%   of gencost is used to evaluate the cost at the points specified in the
%   corresponding row of Pg.

%   MATPOWER
%   $Id$
%   by Ray Zimmerman, PSERC Cornell
%   & Carlos E. Murillo-Sanchez, PSERC Cornell & Universidad Autonoma de Manizales
%   Copyright (c) 1996-2004 by Power System Engineering Research Center (PSERC)
%   See http://www.pserc.cornell.edu/matpower/ for more info.

[PW_LINEAR, POLYNOMIAL, MODEL, STARTUP, SHUTDOWN, N, COST] = idx_cost;

[ng, m] = size(gencost);
totalcost = zeros(ng, size(Pg, 2));

if ~isempty(gencost)
  ipwl = find(gencost(:, MODEL) == PW_LINEAR);
  ipol = find(gencost(:, MODEL) == POLYNOMIAL);
  if ~isempty(ipwl)
    x = gencost(:, COST:2:(m-1));
    y = gencost(:, (COST+1):2:m);
    for i = ipwl'
      if gencost(i, N) > 0
        j1 = 1:(gencost(i, N) - 1);    j2 = 2:gencost(i, N);
        pp = mkpp(x(i, 1:gencost(i, N))', [(y(i,j2) - y(i,j1)) ./ (x(i,j2) - x(i,j1));  y(i,j1)]');
        totalcost(i,:) = ppval(pp, Pg(i,:));
      end
    end
  end
  for i = ipol'
    totalcost(i,:)= polyval(gencost(i, COST:(COST+gencost(i, N)-1) ), Pg(i,:) );
  end
end

return;

