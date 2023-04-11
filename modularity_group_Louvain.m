%% ========================================================================
% Communnity detection at the group level 
function [Ci_group,Q] = modularity_group_Louvain(Ci)

   agree = agreement(Ci);
   agree = agree./length(Ci);
   tau = 0.5;
   reps = 100;
   [Ci_group,Q] = consensus_adapted_louvain(agree,tau,reps);
      
end