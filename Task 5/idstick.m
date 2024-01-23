% ID Stick class definition
classdef idstick
    properties
        SerialNumber
        Status
        Participant
        Course
        Timestamps
    end

    methods
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
            id.Status = "Ready";
            signal(id,true)
        end
    end

end