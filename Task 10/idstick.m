% ID Stick class tanımladık
classdef idstick
    properties
        SerialNumber (1,1) uint32
        Status (1,1) string
        Participant (1,1) string
        Course course
        Timestamps (:,1) datetime
    end

    methods
        function id = idstick(snum)
            arguments
                snum {mustBeNumeric, mustBePositive, mustBeInteger}
            end
            id.SerialNumber = snum;
        end

        function disp(id)
            % Start building display string
            str = "ID stick #" + id.SerialNumber;
            % Add participant info, if applicable
            if (id.Participant == "")
                str = str + "henüz kayıtlı değil";
                disp(str)
            else
                str = str + " is registered to " + id.Participant + " who is ";
                % Use status to get the correct wording
                switch id.Status
                    case "Ready"
                        str = str + "ready to run";
                    case "Running"
                        str = str + "running";
                    case "Done"
                        str = str + "finished with";
                end
                % Display the string, then display the course details
                disp(str)
                disp(id.Course)
            end
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
            % Get the course object
            c = id.Course;
            % Check and update ID stick status
            % Check that this waypoint is on this course
            [id,ok,n] = updateStatus(id,wayptnum);
            % If the waypoint is valid, the ID stick status is ok, and the
            % waypoint is not the start, use the course method to check
            % this waypoint according to the rules of the course. (If this
            % waypoint is the start, there's nothing more to check.)
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
            % Şu anki ID Stickin durumu nedir?
            if (id.Status == "Error") || (id.Status == "Done")
                % Leave status alone, this check-in is a fail
                ok = false;
            elseif (id.Status == "Ready")
                % Başlamaya hazır. Bu ara noktanın başlangıç ​​olup olmadığını kontrol edin
                if (idx == 1)
                    % Alright, let's go!
                    id.Status = "Running";
                    ok = true;
                else
                    % Checking in at a later waypoint before starting
                    ok = false;
                end
            else
                % In progress. Check that this waypoint is on this course
                ok = ~isempty(idx);
                % If this waypoint is the end, we're done
                if (idx == numel(wplist))
                    id.Status = "Done";
                end
            end
        end
    end

end