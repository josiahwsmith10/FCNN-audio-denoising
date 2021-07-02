%% EESC6364 Fall 2019 Project
% Written by Sherief Helwa and Josiah Smith
% 11-22-19

%% Real-Time Data Collection and Denoising

fs = 16e3;
samplesPerFrame = 320;
deviceSelectionStr = "Primary Sound Capture Driver";
captureTimeSeconds = 5;

deviceReader = setupAudio(deviceSelectionStr,fs,samplesPerFrame);

[noisySig,denoisedSig] = realTimeAudioCaptureAndDenoise(deviceReader,captureTimeSeconds,fs,samplesPerFrame,netUnderTest);

%% Train an FCNN using the Stereo Noisy Data

trainedNet = trainDenoisingNetwork(stereoNoisyTrainingData);

%% Playback Machinery Denoised Signal

load('NoisyTestSignal_Machinery')
load('DenoisingNet_Machinery')

machineryDenoisedSig = denoise(machineryDenoiseNet,NoisySignal_Machinery);

disp("Playing Raw Noisy Signal")
sound(NoisySignal_Machinery,fs)
pause(23)
disp("Playing Denoised Signal")
sound(machineryDenoisedSig,fs)

%% Playback Babble Denoised Signal

load('NoisyTestSignal_Babble')
load('DenoisingNet_Babble')

babbleDenoisedSig = denoise(babbleDenoiseNet,NoisySignal_Babble);
return;
disp("Playing Raw Noisy Signal")
sound(NoisySignal_Babble,fs)
pause(23)
disp("Playing Denoised Signal")
sound(babbleDenoisedSig,fs)