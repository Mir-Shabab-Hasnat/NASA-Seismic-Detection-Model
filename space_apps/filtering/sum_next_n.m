
function result = sum_next_n(signal, n)

    result = zeros(size(signal));
    len = length(signal);
    for i = 1:len
        result(i) = sum(signal(i:min(i+n-1, len)));
    end
end

