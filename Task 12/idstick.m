% ID Stick class tanımladık
classdef idstick
    properties
        SerialNumber (1,1) uint32
        Status (1,1) string
        Participant (1,1) string
        Course (1,1) course
        Timestamps (:,1) datetime
    end

    methods
        function id = idstick(snum)
            id.SerialNumber = snum;
        end

%         function disp(id)
%             % Görüntüleme dizesi oluşturmaya başlayın
%             str = "ID stick #" + id.SerialNumber;
%             % Varsa katılımcı bilgilerini ekleyin
%             if (id.Participant == "")
%                 str = str + " which is not yet registered";
%                 disp(str)
%             else
%                 str = str + " is registered to " + id.Participant + " who is ";
%                 % Doğru ifadeyi bulmak için durumu kullanın
%                 switch id.Status
%                     case "Ready"
%                         str = str + "ready to run";
%                     case "Running"
%                         str = str + "running";
%                     case "Done"
%                         str = str + "finished with";
%                 end
%                 % Dizeyi görüntüleyin, ardından kurs ayrıntılarını görüntüleyin
%                 disp(str)
%                 disp(id.Course)
%             end
%         end

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

        function id = register(id,name,course)
            id.Participant = name;
            id.Course = course;
            id.Timestamps = NaT(size(course.Waypoints));
            id.Status = "Ready";
            signal(id,true)
        end

        function id = checkWaypoint(id,wayptnum)
            % Get the course object
            c = id.Course;
            % Check and update ID stick status
            % Check that this waypoint is on this course
            [id,ok,n] = updateStatus(id,wayptnum);
            % Ara nokta geçerliyse, kimlik çubuğunun durumu iyidir ve Ara nokta 
            %'si başlangıç ​​değil, kontrol etmek için rota yöntemini kullanın Parkurun kurallarına göre bu geçiş noktasının %'si. (Eğer bu
            % yol noktası başlangıçtır, kontrol edilecek başka bir şey yoktur.)
            if ok && (n > 1)
                ok = checkWaypoint(c,id,n);
            end
            % Bu ara noktanın zaman damgasını güncelleyin
            id.Timestamps(n) = datetime("now");
            % Katılımcıya ne olduğunu anlatın
            signal(id,ok)
        end

        function [id,ok,idx] = updateStatus(id,wayptnum)
            % Bu kurs için listede verilen ara noktayı bulun
            wplist = id.Course.Waypoints;
            idx = find(wayptnum == wplist,1,"first");
            % Şu anki ID Stick'in durumu nedir?
            if (id.Status == "Error") || (id.Status == "Done")
                % Durumu bir kenara bırakın, bu check-in başarısız oldu
                ok = false;
            elseif (id.Status == "Ready")
                % Başlamaya hazır. Bu ara noktanın başlangıç ​​olup olmadığını kontrol edin
                if (idx == 1)
                    % Tamam, hadi başla!
                    id.Status = "Running";
                    ok = true;
                else
                    %Başlamadan önce daha sonraki bir geçiş noktasında check-in yapmak
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