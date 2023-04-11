%% ========================================================================
% Community detection at the individual level 
function [Ci,agree] = modularity_individual_Louvain(W,gamma)

   sum_c = cell(100,1);
   for iter = 1:100
       [ci, ~] = community_louvain(W,gamma);
       sum_c{iter} = ci;
   end

   agree = agreement(sum_c)/100;
   tau = 0.5;
   reps = 100;
   Ci = consensus_und(agree,tau,reps);
   
end