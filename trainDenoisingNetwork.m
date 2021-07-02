function [trainedNet,options,layers] = trainDenoisingNetwork(trainingData)
if size(trainingData,2) ~= 2
    
    disp("Error in trainingData: incorrect size")
    trainedNet = 0;
    options = 0;
    layers = 0;
    return;
    
end

fsN          = 48000;
overlap_size = 0.01*fsN; % 10 ms overlap
frame_size   = 2*overlap_size; % 20 ms frame size
fs2 = fsN/3;

ch1 = trainingData(:,1);
ch2 = trainingData(:,2);

ch1 = ch1 ./ max(ch1(1/4*end:3/4*end));
ch2 = ch2 ./ max(ch2(1/4*end:3/4*end));

frames_ch1 = frame_sig_new(ch1,frame_size/3)';
frames_ch2 = frame_sig_new(ch2,frame_size/3)';

clear noisy_sig ch1 ch2

% Voice Activity Detection 
% Initialize VAD parameters
VAD_cst_param = vadInitCstParams;
VAD_cst_param.Fs        = fs2;
VAD_cst_param.L_WINDOW  = fs2;
VAD_cst_param.L_NEXT    = overlap_size/3;
VAD_cst_param.L_FRAME   = frame_size/3;
VAD_cst_param.hamwindow = hanning((frame_size));           % size= 3*frame_size
VAD_cst_param.L_WINDOW  = length(VAD_cst_param.hamwindow); % size = 3*frame_size

clear  frame_size overlap_size fsN fs2

decision = zeros(1,size(frames_ch1,2));
for i = 1:size(frames_ch1,2)
    clear vadG729
    decision(i) = vadG729(frames_ch1(:,i), VAD_cst_param); % should feed frame-base
    disp(i)
end

indx_NS = find (decision == 1);
frames_ch1_NSonly = frames_ch1(:,indx_NS);
frames_ch2_NSonly = frames_ch2(:,indx_NS);

clear decision VAD_cst_param

%% Create Total Training Tensors

XTrain = permute(frames_ch1_NSonly,[1 3 4 2]);
YTrain = permute(frames_ch2_NSonly,[1 3 4 2]);

%% Declare Options and Layers

miniBatchSize = 128;
options = trainingOptions("adam", ...
    "MaxEpochs",50, ...
    "InitialLearnRate",1e-2,...
    "MiniBatchSize",miniBatchSize, ...
    "Shuffle","every-epoch", ...
    "Plots","training-progress", ...
    "Verbose",true, ...
    "LearnRateSchedule","piecewise", ...
    "LearnRateDropFactor",0.5, ...
    "LearnRateDropPeriod",10);

layers = [ ...
    imageInputLayer(size(XTrain(:,:,:,1)))
    
    repmat([convolution2dLayer([30 1],55,"Padding","same")
    batchNormalizationLayer
    leakyReluLayer],5,1)    
    
    convolution2dLayer([1 1],1,"Padding","same")
    
    regressionLayer
    ];

% Train Fully Convolutional Network

trainedNet = trainNetwork(YTrain,XTrain,layers,options);