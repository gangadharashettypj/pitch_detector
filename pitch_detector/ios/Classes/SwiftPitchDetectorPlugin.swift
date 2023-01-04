import Flutter
import UIKit
import Pitchy
import Beethoven
import AVFoundation
import EZAudioClone


public class SwiftPitchDetectorPlugin: NSObject, FlutterPlugin {
    public static var channel: FlutterMethodChannel?
    public static var eventChannel: FlutterEventChannel?
    public var eventSink: FlutterEventSink?
    public var pitchController: PitchController?
    public var microphone: EZMicrophone?
    public var fft: EZAudioFFTRolling?
    //    let FFTViewControllerFFTWindowSize:vDSP_Length = 4096
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        channel = FlutterMethodChannel(name: "pitch_detector", binaryMessenger: registrar.messenger())
        let instance = SwiftPitchDetectorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
        
        eventChannel = FlutterEventChannel(name: "pitch_detector_event_channel", binaryMessenger: registrar.messenger())
        eventChannel!.setStreamHandler(instance)
    }
    
    public func initAudio(){
        let session:AVAudioSession! = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setActive(true)
            microphone = EZMicrophone(delegate: self)
            fft = EZAudioFFTRolling.fft(
                withWindowSize: 4096,
                sampleRate: Float(microphone!.audioStreamBasicDescription().mSampleRate),
                delegate:self
            )
        } catch {
            print(error)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch(MethodChannelNames(rawValue: call.method)) {
        case .getPlatformVersion:
            result("iOS " + UIDevice.current.systemVersion)
        case .initialize:
            initAudio()
            result("initialized")
        case .isInitialized:
            result(true)
        case .startRecording:
            //            pitchController?.startRecording()
            microphone?.startFetchingAudio()
            result("Recording started")
        case .stopRecording:
            //            pitchController?.stopRecording()
            microphone?.stopFetchingAudio()
            result("Recording Stopped")
        default:
            result(true)
        }
    }
    
}


public class PitchController {
    let eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self.eventSink = eventSink
    }
    
    lazy var pitchEngine: PitchEngine = { [weak self] in
        let config = Config(estimationStrategy: .yin)
        let pitchEngine = PitchEngine(config: config,delegate: self)
        return pitchEngine
    }()
    
    public func startRecording() {
        pitchEngine.start()
    }
    public func stopRecording() {
        pitchEngine.stop()
    }
}

extension SwiftPitchDetectorPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        //        pitchController = PitchController(eventSink: events)
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}


extension PitchController: PitchEngineDelegate {
    public func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        let data: [String: Any] = [
            "frequency" : pitch.frequency,
            "noteFrequency" : pitch.note.frequency,
            "noteLetter" : pitch.note.letter.rawValue,
            "noteOctave" : pitch.note.octave,
            "noteIndex" : pitch.note.index,
            "type" : "PITCH_DATA"
        ]
        eventSink(data)
    }
    
    public func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(">>>>>")
        print(error)
        //        eventSink([
        //            "error" : error,
        //            "type" : "PITCH_ERROR"
        //        ])
    }
    
    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        //        print("Below level threshold")
    }
}


extension SwiftPitchDetectorPlugin: EZAudioFFTDelegate {
    public func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>!, bufferSize: vDSP_Length) {
        let maxFrequency:Float = fft.maxFrequency
        let noteName:String = EZAudioUtilities.noteNameString(
            forFrequency: maxFrequency,
            includeOctave:false
        )
        let noteOctave:String = EZAudioUtilities.noteNameString(
            forFrequency: maxFrequency,
            includeOctave:true
        ).replacingOccurrences(of: noteName, with: "")
        
        let data: [String: Any] = [
            "frequency" :  fft.maxFrequency,
            "noteFrequency" : fft.maxFrequency,
            "noteLetter" : noteName,
            "noteOctave" : noteOctave,
            "noteIndex" : fft.maxFrequencyIndex,
            "type" : "PITCH_DATA"
        ]
        if(eventSink != nil){
            eventSink!(data)
        }
    }
}

extension SwiftPitchDetectorPlugin: EZMicrophoneDelegate {
    
    func convert(count: Int, data: UnsafePointer<Float>) -> [Float] {
        let buffer = UnsafeBufferPointer(start: data, count: count);
        return Array(buffer)
    }
    
    public func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if( eventSink != nil){
            let data: [String: Any] = [
                "data" : convert(count: Int(bufferSize), data: buffer[0]!),
                "type" : "PITCH_RAW_DATA"
            ]
            eventSink!(data)
        }
        fft?.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize)
    }
}


public enum MethodChannelNames: String {
    case startRecording
    case stopRecording
    case getPlatformVersion
    case initialize
    case isInitialized
}
