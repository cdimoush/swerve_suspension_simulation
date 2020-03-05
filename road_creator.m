function ob = road_creator(type, ob_start, ob_end, amp, period)
    res = 100; 
    dist = ob_end - ob_start;
    freq = 1/(period*res);
    
    ob = zeros(dist*res +1, 2);
    
    if type == 1 %Sine
        for i = 0:dist*res
            ob(i+1, 1) = i/res + ob_start;
            ob(i+1, 2) = sin(i*freq*2*pi)* amp;
        end
    elseif type == 2 %Pot Hole (Sine < 0)
        for i = 1:dist*res
            ob(i+1, 1) = i/res + ob_start;
            ob(i+1, 2) = sin(i*freq*2*pi)* amp;
            if y < 0
                ob(i, 2) = y;
            else
                ob(i, 2) = 0;
            end
        end
    elseif type == 3 %ramps
        count = 0;
        m = amp/period;
        for i = 1:dist*res+1
            if i/(res*period) - count > 1
                count = count +1; 
            end
            ob(i+1, 1) = i/res + ob_start;
            ob(i+1, 2) = (ob(i+1, 1) - ob_start - count*period) * m;
        end  
    end
end
