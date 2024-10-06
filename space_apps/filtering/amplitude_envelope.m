
function envelope = amplitude_envelope(signal)

    [pks, locs] = findpeaks(abs(signal));

    t = (0:length(signal)-1);
    peak_times = t(locs);

    envelope = interp1(peak_times, pks, t, 'pchip', 'extrap');
end

