function denoisedData = denoise(net,noisyInput)
    
% Signal framing

frame_size = net.Layers(1).InputSize(1);
Framed_Signal = frame_sig_new( noisyInput, frame_size)';

denoisedData = double(squeeze(predict(net,permute(Framed_Signal,[ 1 3 4 2 ]))));
denoisedData = denoisedData(:);