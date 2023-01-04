import Flutter
import UIKit
import EZAudioClone

public class SwiftPitchDetectorPlusPlugin: NSObject, FlutterPlugin {
    public static var channel: FlutterMethodChannel?
    public static var eventChannel: FlutterEventChannel?
    public var eventSink: FlutterEventSink?
    public var microphone: EZMicrophone?
    public var fft: EZAudioFFTRolling?
    private var bufferSize = 1024
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        channel = FlutterMethodChannel(name: "pitch_detector", binaryMessenger: registrar.messenger())
        let instance = SwiftPitchDetectorPlusPlugin()
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
                withWindowSize: vDSP_Length(bufferSize * 4),
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
            let data: [String: Any] = [
                "sampleRate" : Int(microphone!.audioStreamBasicDescription().mSampleRate),
                "bufferSize" : bufferSize
            ]
            result(data)
        case .isInitialized:
            result(true)
        case .startRecording:
            microphone?.startFetchingAudio()
            result("Recording started")
        case .stopRecording:
            microphone?.stopFetchingAudio()
            result("Recording Stopped")
        default:
            result(true)
        }
    }
    
}

extension SwiftPitchDetectorPlusPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

extension SwiftPitchDetectorPlusPlugin: EZAudioFFTDelegate {
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

extension SwiftPitchDetectorPlusPlugin: EZMicrophoneDelegate {
    
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
