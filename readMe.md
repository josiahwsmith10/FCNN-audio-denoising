## Instructions

Main File: FCNN_Audio_Denoising_ML_DSP.m
- Execute each section of code independently

Section 1: Real-Time Data Collection and Denoising
- This portion of code initializes the audio reader to collect data from your machine and then captures the data and denoises it uses a specified network
- deviceSelectionStr may need to be changed to suit your system and read from the correct microphone
    - To see what devices you have available if you do need to change deviceSelectionStr, call the following function and set deviceSelectionStr equal to the string describing the hardware you wish to use: getAudioDevices(deviceReader)

- captureTimeSeconds is the number of seconds you wish to perform real-time denoising
- netUnderTest is the FCNN that you desire to use to perform real-time denoising. You must either replace this variable name in the argument of the realTimeAudioCaptureAndDenoise() function with the desired network you wish to use, or change the name of the network you wish to use to "netUnderTest"

Section 2: Train an FCNN using the Stereo Noisy Data
- This portion of code trains your own FCNN using noisy stereo data captured by a mid-side microphone
- stereoNoisyTrainingData must be a matrix of size [N,2] consisting of stereo time domain audio samples
    -You must provide stereoNoisyTraningData
    -stereoNoisyTrainingData should be sampled at the sample rate at which you wish for the real-time applciation to use. It is not downsampled in the trainDenoisingNetwork() function

Section 3: Playback Machinery Denoised Signal
- This portion of code loads our pretrained network and a noisy sample, denoises the sample using the network, and plays the noisy sample followed by the denoised sample
- For this test case, we have provided a sampling frequency of 44.1kHz, the sample rate of the raw noisy signal as well as the training data used for this network

Section 4: Playback Babble Denoised Signal
- This portion of code loads our pretrained network and a noisy sample, denoises the sample using the network, and plays the noisy sample followed by the denoised sample
- For this test case, we have provided a sampling frequency of 44.1kHz, the sample rate of the raw noisy signal as well as the training data used for this network

## User-Defined Functions 

frame_sig_new(signal, frame_len)
- frame_sig_new accepts a signal vector of length Nx1 and a scalar frame_len
- signal is reshaped to size [frame_len,n_frames], where frame_len is the length of each frame, and n_frames is the total number of frames
- if signal cannot be directly reshaped to this form, it is zeropadded and then reshaped
- frame_sig_new outputs a matrix of size [frame_len,n_frames] containing the framed signal
- note: there is no hamming or hanning windowing or overlap done with this framing method


denoise(net, noisyInput)
- denoise accepts a SeriesNetwork called net and a signal vector called noisyInput
- noisyInput is first framed using frame_sig_new to the proper frame size
- the framed signal is denoised using the built-in predict function
- the denoised frames are reconstructed into a single vector
- denoise outputs a vector of the same size as noisyInput that has been denoised by net

setupAudio(deviceSelectionStr, fs, samplesPerFrame)
- setupAudio accepts a string called deviceSelectionSTR, a scalar called fs, and a scalar called samplesPerFrame
- deviceSelectionStr specifies which recording device the script will assign
- using the provided parameters, setupAudio outputs a mono audioDeviceReader

realTimeAudioCaptureAndDenoise(deviceReader, captureTimeSeconds, fs, samplesPerFrame, net)
- realTimeAudioCaptureAndDenoise accepts an audioDeviceReader called deviceReader, scalars captureTimeSeconds, fs, and samplesPerFrame, and a SeriesNetwork called net
- captureTimeSeconds is the total desired capture time
- fs is the sampling frequency
- samplesPerFrame is the number of samples for each frame
- realTimeAudioCaptureAndDenoise outputs two vectors, the first being the raw captured audio data and the second being this same audio data denoised by net

trainDenoisingNetwork(trainingData)
- trainDenoisedNetwork accepts a matrix called trainingData of size [N,2], where N is the number of time domain samples
- trainingData is framed, fed into a VAD for selection of only the voice frames only
- the two channels of trainingData are used to train the fully convolutional neural network
- trainDenoisedNetwork outputs a SerialNetwork,TrainingOptionsADAM,Layers

## Files
babbleDenoiseNets.mat
- babbleDenosieNets.mat contains 5 networks trained with differrent parameters, the sampling frequency, a noisy sample (note that the sampling rate of these networks is 16kHz)

| Network Name                         | Number of Convolutional Triples | Number of Epochs |
| ------------------------------------ | ------------------------------- | ---------------- |
| babbleDenoiseNet10ConvTrip20Epochs   | 10                              | 20               |
| babbleDenoiseNet1ConvTrip50Epochs    |  1                              | 50               |
| babbleDenoiseNet1ConvTrip100Epochs   |  1                              | 100              |
| babbleDenoiseNet3ConvTrip50Epochs    |  3                              | 50               |
| babbleDenoiseNet3ConvTrip100Epochs   |  3                              | 90               |

- to denoise the babbleNoisySig sample, simply call the following denoise() function, replacing netUnderTest with any of the above networks: babbleDenoisedSig = denoise(netUnderTest,babbleNoisySig);

denoiseNets.mat
- denoiseNets.mat contains the two final networks in one file along with the sampling rate used for the training and testing of these networks (note that the sampling rate of these networks is 44.1kHz)
    
| Network Name         | Number of Convolutional Triples | Number of Epochs |
| -------------------- | ------------------------------- | ---------------- |
| babbleDenoiseNet     |  5                              | 50               |
| machineryDenoiseNet  |  5                              | 50               |

denoisingNet_Babble.mat
- denoisingNet_Babble.mat contains the babble denoising network

denoisingNet_Machinery.mat
- denoisingNet_Machinery.mat contains the machinery denoising network

fanDenoiseNets.mat
- fanDenoiseNets.mat contains the 3 fan denoising networks generated and discussed in the report along with corresponding noisy samples at each specified input SNR (note that the sampling rate of these networks is 16kHz)
    
| Network Name         | Number of Convolutional Triples | Number of Epochs |
| -------------------- | ------------------------------- | ---------------- |
| fanDenoiseNet10dB    |  5                              | 75               |
| fanDenoiseNet3dB     |  5                              | 75               |
| fanDenoiseNet5dB     |  5                              | 75               |

- to denoise one of the noisy samples, simply call the following denoise() function, replacing fanDenoiseNet5dB with any of the above networks: babbleDenoisedSig = denoise(fanDenoiseNet5dB,fanNoisySig5dB);

NoisyTestSignal_Babble.mat
- NoisyTestSignal_Babble.mat contains the raw noisy babble sample for denoising as well as the corresponding sampling rate

NoisyTestSignal_Machinery.mat
- NoisyTestSignal_Machinery.mat contains the raw noisy machinery sample for denoising as well as the corresponding sampling rate

Audio Files:
- This folder contains the noise and voice + noise data used for training and testing

### Publication and Citation
If you appreciate our work and would like to use it in your research, please cite one of the papers using extensions of this project:
- Deep Learning-Based Multiband Signal Fusion for 3-D SAR Super-Resolution ([arXiv](https://arxiv.org/abs/2305.02017), [DOI](https://doi.org/10.1109/TAES.2023.3270111))
- Efficient CNN-based Super Resolution Algorithms for mmWave Mobile Radar Imaging ([arXiv](https://arxiv.org/abs/2305.02092), [DOI](https://doi.org/10.1109/ICIP46576.2022.9897190))
- A Vision Transformer Approach for Efficient Near-Field Irregular SAR Super-Resolution ([arXiv](https://arxiv.org/abs/2305.02074), [DOI](https://doi.org/10.1109/WMCS55582.2022.9866326))
- An FCNN-Based Super-Resolution mmWave Radar Framework for Contactless Musical Instrument Interface ([arXiv](https://arxiv.org/abs/2305.01995), [DOI](https://doi.org/10.1109/TMM.2021.3079695))
```
@article{smith2023deep,
	title        = {Deep Learning-Based Multiband Signal Fusion for 3-D SAR Super-Resolution},
	author       = {Smith, J. W. and Torlak, M.},
	year         = 2023,
	month        = apr,
	journal      = {IEEE Trans. Aerosp. Electron. Syst.},
	pages        = {1--17}
}
@inproceedings{smith2022vision,
	title        = {A Vision Transformer Approach for Efficient Near-Field {SAR} Super-Resolution under Array Perturbation},
	author       = {Smith, J. W. and Alimam, Y. and Vedula, G. and Torlak, M.}
	year         = 2022,
	month        = apr,
	booktitle    = {Proc. IEEE Tex. Symp. Wirel. Microw. Circuits Syst. (WMCS)},
	address      = {Waco, TX, USA},
	pages        = {1--6}
}
@inproceedings{vasileiou2022efficient,
	title        = {Efficient {CNN}-Based Super Resolution Algorithms for {mmWave} Mobile Radar Imaging},
	author       = {Vasileiou, C. and Smith, J. W. and Thiagarajan, S. and Nigh, M. and Makris, Y. and Torlak, M.},
	year         = 2022,
	month        = oct,
	booktitle    = {Proc. IEEE Int. Conf. Image Process. (ICIP)},
	address      = {Bordeaux, France},
	pages        = {3803--3807}
}
@article{smith2021fcnn,
	title        = {An {FCNN}-Based Super-Resolution {mmWave} Radar Framework for Contactless Musical Instrument Interface},
	author       = {Smith, J. W. and Furxhi, O. and Torlak, M.},
	year         = 2021,
	month        = may,
	journal      = {IEEE Trans. Multimedia},
	volume       = 24,
	pages        = {2315--2328}
}
```
