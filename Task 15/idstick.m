% ID Stick class tanımladık
classdef idstick
    properties (SetAccess = immutable)
        SerialNumber (1,1) uint32
    end
    properties (Access = private)
        Status (1,1) string
    end
    properties (SetAccess = private)
        Participant (1,1) string
        Course (1,1) course
        Timestamps (:,1) datetime
    end

    methods
        function id = idstick(snum)
            if (nargin > 0)
                % Verilen seri numaralarının özelliklerini kontrol edin
                mustBeNumeric(snum)
                mustBeInteger(snum)
                mustBePositive(snum)
                % Nesne dizisi oluştur
                for k = 1:numel(snum)
                    id(k).SerialNumber = snum(k);
                end
            end
        end

        function disp(id)
            for k = 1:numel(id)
                % Görüntüleme dizesi oluşturmaya başlayın
                str = "ID stick #" + id(k).SerialNumber;
                % Varsa katılımcı bilgilerini ekleyin
                if (id(k).Participant == "")
                    str = str + " which is not yet registered";
                    disp(str)
                else
                    str = str + " is registered to " + id(k).Participant + " who is ";
                    % Doğru ifadeyi bulmak için durumu kullanın
                    switch id(k).Status
                        case "Ready"
                            str = str + "ready to run";
                        case "Running"
                            str = str + "running";
                        case "Done"
                            str = str + "finished with";
                    end
                    % Dizeyi görüntüleyin, ardından kurs ayrıntılarını görüntüleyin
                    disp(str)
                    disp(id(k).Course)
                end
            end
        end

        function id = register(id,name,c)
            arguments
                id (1,1) idstick
                name (1,1) string
                c (1,1) course
            end
            id.Participant = name;
            id.Course = c;
            id.Timestamps = NaT(size(c.Waypoints));
            id.Status = "Ready";
            signal(id,true)
        end

        function id = checkWaypoint(id,wayptnum)
            arguments
                id (1,1) idstick
                wayptnum (1,1) double
            end
            % Kurs nesnesini alın
            c = id.Course;
            % Kimlik çubuğu durumunu kontrol edin ve güncelleyin
            % Bu ara noktanın bu rota üzerinde olup olmadığını kontrol edin

            [id,ok,n] = updateStatus(id,wayptnum);
            
            if ok && (n > 1)
                ok = checkWaypoint(c,id,n);
            end
            % Bu ara noktanın zaman damgasını güncelleyin
            id.Timestamps(n) = datetime("now");
            % Katılımcıya ne olduğunu anlatın
            signal(id,ok)
        end

    end
    
    methods (Access = private)
        function signal(id,ok)
            if ok
                if (id.Status == "Ready") || (id.Status == "Done")
                    disp("Beep beep")
                else
                    disp("Beep")
                end
            else
                disp("Buzz")
            end
        end

        function [id,ok,idx] = updateStatus(id,wayptnum)
            % Find the given waypoint in the list for this course
            wplist = id.Course.Waypoints;
            idx = find(wayptnum == wplist,1,"first");
            % Şu anki ID Stick'in durumu nedir?
            if (id.Status == "Error") || (id.Status == "Done")
                % Durumu bir kenara bırakın, bu check-in başarısız oldu
                ok = false;
            elseif (id.Status == "Ready")
                % Başlamaya hazır. Bu ara noktanın başlangıç ​​olup olmadığını kontrol edin
                if (idx == 1)
                    % Tamam, hadi gidelim!
                    id.Status = "Running";
                    ok = true;
                else
                    % Başlamadan önce daha sonraki bir geçiş noktasında check-in yapmak
                    ok = false;
                end
            else
                % Devam etmekte. Bu ara noktanın bu rotada olup olmadığını kontrol edin
                ok = ~isempty(idx);
                % Eğer bu ara nokta sonsa, işimiz bitti
                if (idx == numel(wplist))
                    id.Status = "Done";
                end
            end
        end
    end

end