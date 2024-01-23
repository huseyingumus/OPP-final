% ID Stick sınıf tanımı
classdef idstick
    properties
        SerialNumber
        Status
        Participant
        Course
        Timestamps
    end

    methods
        function id = idstick(snum)
            id.SerialNumber = snum;
        end
        
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
            % Course objesini çağırır
            c = id.Course;
            % ID Stick öğesini kontrol eder ve günceller
            % Waypoint bu course nesnesinde varmı diye kontrol eder
            [id,ok,n] = updateStatus(id,wayptnum);
            % Waypoint öğesi bulunursa, ID stick durumunu var olarak değiştirir , ve the
            % waypoint eğer başlamazsa , course methodunu kotnrol için çağırıp
            % wayppoint kuralların göre başlar. (Waypoint eğer başlarsa
            % , kontrol edecek daha fazla birşey yoktur.)
            if ok && (n > 1)
                ok = checkWaypoint(c,id,n);
            end
            % Waypointin ara noktasını günceller.
            id.Timestamps(n) = datetime("now");
            % Kullanıcıya ne işlemi aktarır
            signal(id,ok)
        end

        function [id,ok,idx] = updateStatus(id,wayptnum)
            % Bu nesnedeki waypoint öğesini bulur
            wplist = id.Course.Waypoints;
            idx = find(wayptnum == wplist,1,"first");
            % anlık Id'in ne olduğunu verir.
            if (id.Status == "Error") || (id.Status == "Done")
                % Durumu aynı bırakır eğer koşullar geçerli ise
                ok = false;
            elseif (id.Status == "Ready")
                % Waypoint başlamaya hazır.
                if (idx == 1)
                    % Waypoint başladı
                    id.Status = "Running";
                    ok = true;
                else
                    % waypoint başlamadan önce kontrol eder.
                    ok = false;
                end
            else
                %  Çalışma esnasında waypointin olup olmadıgına bakar
                ok = ~isempty(idx);
                % Waypoint bittiyse iş bitti demektir.
                if (idx == numel(wplist))
                    id.Status = "Done";
                end
            end
        end
    end

end
