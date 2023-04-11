%% ========================================================================
function Eglob = GT_metrics(W,regions_id)

    % global efficieny
    if length(regions_id) == size(W,1)
        G = graph(tril(W),'lower');
    else
        G = graph(tril(W(regions_id,regions_id)),'lower');
    end
    source_node = 1:length(regions_id);
    Eglob = 0;
    while isempty(source_node) == 0
        
        for target_node = source_node(2:end)
    
            [~,d] = shortestpath(G,source_node(1),target_node);
             Eglob = Eglob + 1/d;
    
        end
        source_node(1) = [];
    
    end
    Eglob = Eglob/(length(regions_id)*(length(regions_id)-1));

end
