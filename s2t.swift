func startRecording() {
    
    if recognitionTask != nil {
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
    } catch {
        print("audioSession properties weren't set because of an error.")
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    guard let inputNode = audioEngine.inputNode else {
        fatalError("Audio engine has no input node")
    }
    
    guard let recognitionRequest = recognitionRequest else {
        fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in 
        
        var isFinal = false
        
        if result != nil {
            
            self.textView.text = result?.bestTranscription.formattedString
            isFinal = (result?.isFinal)!
        }
        
        if error != nil || isFinal {
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            self.microphoneButton.isEnabled = true
        }
    })
    
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
        self.recognitionRequest?.append(buffer)
    }
    
    audioEngine.prepare()
    
    do {
        try audioEngine.start()
    } catch {
        print("audioEngine couldn't start because of an error.")
    }
    
    textView.text = "Say something, I'm listening!"
    
}
