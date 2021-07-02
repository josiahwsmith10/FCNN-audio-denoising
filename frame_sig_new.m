function frames = frame_sig_new(signal, frame_len)
%function win_frames = frame_sig(signal, frame_len, frame_step)
% takes a 1 by N signal, and breaks it up into frames. Each frame starts
% frame_step samples after the start of the previous frame.

if size(signal,1) ~= 1
    signal = signal';
end
 
signal_len = length(signal);
if signal_len <= frame_len  % if very short frame, pad it to frame_len
    num_frames = 1;
else
    num_frames = 1 + ceil((signal_len - frame_len)/frame_len);
end
padded_len = num_frames*frame_len;
% make sure signal is exactly divisible into N frames
pad_signal = [signal, zeros(1,padded_len - signal_len)];


% build array of indices
indices = repmat(1:frame_len, num_frames, 1) + ...
    repmat((0: frame_len: num_frames*frame_len-1)', 1, frame_len);
frames = pad_signal(indices);

end