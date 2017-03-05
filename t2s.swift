import AVFoundation

let synthesizer = AVSpeechSynthesizer()
let utterance = AVSpeechUtterance(string: "Some text")
utterance.rate = 0.2

utterance.voice = AVSpeechSynthesisVoice(language: "en-IN") //to select language/accent

synthesizer.speak(utterance)