function trace = get_random_trace(roomLength, roomWidth, t)
%getRandomTrace: get a random trace of an object in a room
    path_length = zeros(t, 1) + normrnd(0.6, 0.05);
    path_angle = rand(t, 1) * 2 * pi;
    sigma_angle = 10;
    trace = zeros(t, 2);
    trace(1, :) = [randi(roomLength - 1), randi(roomWidth - 1)];
    for i = 2 : t
        trace(i, 1) = trace(i - 1, 1) + path_length(i - 1) .* cos(path_angle(i - 1));
        trace(i, 2) = trace(i - 1, 2) + path_length(i - 1) .* sin(path_angle(i - 1));
        while (trace(i, 1) < 1 || trace(i, 1) > roomLength - 1 || trace(i, 2) < 1 || (trace(i, 2) > roomWidth - 1))
            path_angle(i - 1) = rand() * 2 * pi;
            trace(i, 1) = trace(i - 1, 1) + path_length(i - 1) .* cos(path_angle(i - 1));
            trace(i, 2) = trace(i - 1, 2) + path_length(i - 1) .* sin(path_angle(i - 1));
        end
        path_angle(i) = path_angle(i - 1) + normrnd(0, sigma_angle * pi / 180);
    end
end

