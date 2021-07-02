function [noisySig,denoisedSig] = realTimeAudioCaptureAndDenoise(deviceReader,captureTimeSeconds,fs,samplesPerFrame,net)

noisySig = zeros(captureTimeSeconds*fs,1);
denoisedSig = zeros(captureTimeSeconds*fs,1);

% Clear Transient Response
for ii = 1:500
    frame = deviceReader();
    frame = frame(:,1);
%     denoisedFrame = denoise(net,frame);
    denoisedFrame = predict(net,frame);
end

disp("Capturing " + captureTimeSeconds + "s of Audio")

ii = 1;
while ii <= size(noisySig,1)/samplesPerFrame
    frame = deviceReader();
    tic
    denoisedFrame = predict(net,frame);
    toc
    noisySig( (ii-1)*samplesPerFrame + 1 : ii*samplesPerFrame) = frame;
    denoisedSig( (ii-1)*samplesPerFrame + 1 : ii*samplesPerFrame) = denoisedFrame;
    ii = ii + 1;
end

noisySig = double(noisySig);
denoisedSig = double(denoisedSig);

release(deviceReader)

t = linspace(0,5,length(noisySig));
figure
plot(t,noisySig,t,denoisedSig)
xlabel("Time (s)")
title("Noisy and Denoised Signal")
legend("Noisy","Denoised")