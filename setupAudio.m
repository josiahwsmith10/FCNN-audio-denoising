function deviceReader = setupAudio(deviceSelectionStr,fs,samplesPerFrame)

deviceReader = audioDeviceReader;

deviceReader.NumChannels = 1;
devicerReader.channelMappingSource = 'auto';
deviceReader.Device = deviceSelectionStr;
deviceReader.SampleRate = fs;
deviceReader.SamplesPerFrame = samplesPerFrame;

