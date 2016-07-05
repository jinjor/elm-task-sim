module AudioContext exposing (..)

import TaskEmulator.PortTask as PortTask exposing (PortTask)
import TaskEmulator.PortCmd as PortCmd exposing (PortCmd)
import TaskEmulator.Util.Script as Script

import String
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import ScriptUtil


type alias AudioContext = Types.AudioContext


newAudioContext : PortTask x AudioContext
newAudioContext =
  ScriptUtil.new decodeContext "AudioContext" []

--

currentTime : AudioContext -> PortTask x Float
currentTime = getFloat "currentTime"


destination : AudioContext -> PortTask x AudioNode
destination = getNode "destination"


-- listener : AudioContext -> PortTask x AudioListener
-- listener (AudioContext context) =
--   ScriptUtil.get decodeListener context [ "listener" ]


sampleRate : AudioContext -> PortTask x Float
sampleRate = getFloat "sampleRate"


state : AudioContext -> PortTask x String
state = getString "state"

--

close : AudioContext -> PortTask x ()
close context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].close().then(function() { succeed(); }, function(e) { fail(e); } )"


decodeAudioData : ArrayBuffer -> AudioContext -> PortTask x AudioBuffer
decodeAudioData buffer context =
  Script.successful decodeBuffer [ encodeContext context, encodeArrayBuffer buffer ]
    "args[0].decodeAudioData(args[1]).then(function(decodedData) { succeed(decodedData); }, function(e) { fail(e); } )"


resume : AudioContext -> PortTask x ()
resume context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].resume().then(function() { succeed(); }, function(e) { fail(e); } )"


suspend : AudioContext -> PortTask x ()
suspend context =
  Script.successful decodeUnit [ encodeContext context ]
    "args[0].suspend().then(function() { succeed(); }, function(e) { throw e; } )"


--

createBufferSource : AudioContext -> PortTask x AudioNode
createBufferSource = create "BufferSource"


-- Is it a good idea to createAudioNode from DOM nodes?
-- createMediaElementSource : HTMLMediaElement -> AudioContext -> PortTask x AudioNode
-- createMediaElementSource = create "MediaElementSource"


createMediaStreamSource : MediaStream -> AudioContext -> PortTask x AudioNode
createMediaStreamSource = create1 "MediaStreamSource" encodeMediaStream


createMediaStreamDestination : AudioContext -> PortTask x AudioNode
createMediaStreamDestination = create "MediaStreamDestination"


createScriptProcessor : AudioContext -> PortTask x AudioNode
createScriptProcessor = create "ScriptProcessor"


createStereoPanner : AudioContext -> PortTask x AudioNode
createStereoPanner = create "StereoPanner"


createAnalyzer : AudioContext -> PortTask x AudioNode
createAnalyzer = create "Analyzer"


createBiquadFilter : AudioContext -> PortTask x AudioNode
createBiquadFilter = create "BiquadFilter"


createChannerlMerger : AudioContext -> PortTask x AudioNode
createChannerlMerger = create "ChannerlMerger"


createChannerlSplitter : AudioContext -> PortTask x AudioNode
createChannerlSplitter = create "ChannerlSplitter"


createConvolver : AudioContext -> PortTask x AudioNode
createConvolver = create "Convolver"


createDelay : AudioContext -> PortTask x AudioNode
createDelay = create "Delay"


createDynamicsCompressor : AudioContext -> PortTask x AudioNode
createDynamicsCompressor = create "DynamicsCompressor"


createGain : AudioContext -> PortTask x AudioNode
createGain = create "Gain"


createIIRFilter : AudioContext -> PortTask x AudioNode
createIIRFilter = create "IIRFilter"


createOscillator : AudioContext -> PortTask x AudioNode
createOscillator = create "Oscillator"


createPanner : AudioContext -> PortTask x AudioNode
createPanner = create "Panner"


createWaveShaper : AudioContext -> PortTask x AudioNode
createWaveShaper = create "WaveShaper"


create : String -> AudioContext -> PortTask x AudioNode
create nodeName =
  ScriptUtil.f0 encodeContext ("create" ++ nodeName) decodeNode


create1 : String -> (a -> Json) -> (a -> AudioContext -> PortTask x AudioNode)
create1 nodeName encode =
  ScriptUtil.f1 encodeContext ("create" ++ nodeName) encode decodeNode

--

get : Decoder a -> String -> AudioContext -> PortTask x a
get decoder at context =
  ScriptUtil.get decoder (encodeContext context) at


-- getInt : String -> AudioContext -> PortTask x Int
-- getInt = get decodeInt
--
--
getFloat : String -> AudioContext -> PortTask x Float
getFloat = get Decode.float


getString : String -> AudioContext -> PortTask x String
getString = get Decode.string


getNode : String -> AudioContext -> PortTask x AudioNode
getNode = get decodeNode
