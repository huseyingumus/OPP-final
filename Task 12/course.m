% Course class tanımladık
classdef course
    properties
        Name (1,1) string
        Level (1,1) string {mustBeMember(Level,["White","Yellow","Green","Orange","Red"])} = "White"
        Waypoints (:,1) double {mustBePositive, mustBeInteger}
    end

    methods
        function c = course(name,lvl,waypts)
            if (nargin == 3)
                c.Name = name;
                c.Level = lvl;
                c.Waypoints = waypts;
            end
        end

        function ok = checkWaypoint(c,id,wayptidx)
            % Bulunan önceki ara noktanın indeksini alın
            [~,prevwpidx] = max(id.Timestamps);
            % Mevcut geçiş noktası bir sonraki nokta olmalıdır
            ok = (wayptidx == (1+prevwpidx));
        end

%         function disp(c)
%             str = c.Level + " course '" + c.Name + "' with " + ...
%                 numel(c.Waypoints) + " waypoints:";
%             disp(str)
%             disp(c.Waypoints')
%         end
    end

end