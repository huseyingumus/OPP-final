% Course sınıfı tanımı
classdef course
    properties
        Name
        Level
        Waypoints
    end

    methods
    
    % Course.m sınıf tanımı dosyasına, ad level ve points girdisi veriyoruz.
    
        function c = course(name,lvl,waypts)
            c.Name = name;
            c.Level = lvl;
            c.Waypoints = waypts;
        end
    end
end
