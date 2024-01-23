% Course sınıfı tanımı
classdef course
    properties
        Name (1,1) string
        Level (1,1) string {mustBeMember(Level,["White","Yellow","Green","Orange","Red"])} = "White"
        Waypoints (:,1) double {mustBePositive, mustBeInteger}
    end

    methods
        function c = course(name,lvl,waypts)
            c.Name = name;
            c.Level = lvl;
            c.Waypoints = waypts;
        end

        function ok = checkWaypoint(c,id,wayptidx)
            % Get the index of the previous waypoint found
            [~,prevwpidx] = max(id.Timestamps);
            % Current waypoint should be the next one
            ok = (wayptidx == (1+prevwpidx));
        end

        function disp(c)
            str = c.Level + " course '" + c.Name + "' with " + ...
                numel(c.Waypoints) + " waypoints:";
            disp(str)
            disp(c.Waypoints)
        end
    end

end