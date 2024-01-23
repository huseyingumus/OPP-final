% Course class tanımladık
classdef course
    properties (SetAccess = private)
        Name (1,1) string
        Level (1,1) string {mustBeMember(Level,["White","Yellow","Green","Orange","Red"])} = "White"
        Waypoints (:,1) double {mustBePositive, mustBeInteger}
    end

    methods
        function c = course(name,lvl,waypts)
            if (nargin == 3)
                % Verilen girdiler -> bunları kontrol edin
                % Ad metin olmalıdır
                name = convertCharsToStrings(name);
                if isstring(name)
                    c.Name = name;
                else
                    error("Name must be text")
                end
                % Seviye (özellikler bloğu tarafından kontrol edilen değerler)
                c.Level = lvl;
                % Yol noktaları sayısal olmalıdır
                if isnumeric(waypts)
                    c.Waypoints = waypts;
                else
                    error("Waypoints must be numeric")
                end
            elseif (nargin > 0)
                % Girdiler verildi ancak verilmedi == 3
                error("You need to provide 3 inputs: name, level, and a list of waypoints")
            end
        end

        function ok = checkWaypoint(c,id,wayptidx)
            % Bulunan önceki ara noktanın indeksini alın
            [~,prevwpidx] = max(id.Timestamps);
            % Mevcut geçiş noktası bir sonraki nokta olmalıdır
            ok = (wayptidx == (1+prevwpidx));
        end

        function disp(c)
            n = numel(c);
            isarray = (n > 1);
            % Dizi hakkında bilgi ekleyin (eğer skaler değilse)
            if isarray
                disp("Array of "+n+" courses"+newline)
            end
            for k = 1:n
                % Eleman numarasıyla başlayın (eğer skaler değilse)
                if isarray
                    str = string(k)+") ";
                else
                    str = "";
                end
                % Her öğe için görüntüleme dizesi yapın
                if isempty(c(k).Waypoints)
                    str = str + "Empty course";
                    disp(str)
                else
                    % Kurs bilgileriyle dizenin geri kalanını oluşturun
                    str = str + c(k).Level + " course '" + c(k).Name + ...
                        "' with " + numel(c(k).Waypoints) + " waypoints:";
                    disp(str)
                    disp(c(k).Waypoints')
                end
            end
        end
    end

end