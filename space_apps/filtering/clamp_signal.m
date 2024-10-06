
function signal_clamped = clamp_signal(signal, threshold_clamp)
    signal_clamped = signal;
    signal_clamped(abs(signal) < threshold_clamp) = 0;
end
