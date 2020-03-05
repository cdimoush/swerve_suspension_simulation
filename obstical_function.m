function y = obstical_function(x, ob)
    x1 = 0;
    y1 = 0;
    for i = 1:length(ob)
        if x < ob(i, 1)
            x2 = ob(i, 1);
            y2 = ob(i, 2);
            
            y = (y2-y1)/(x2-x1) * (x-x1) + y1; 
            break;
        elseif i == length(ob)
            y = ob(i, 2);
            break;
        end
        x1 = ob(i, 1);
        y1 = ob(i, 2);
    end
end
