import React, { useState, useRef } from "react";
import axios from "axios";
import { Upload, Play, Pause, StopCircle, Volume2 } from "lucide-react";
import { useAccuracy } from "./context/AccuracyContext";

function App() {
  const [text, setText] = useState<string>("");
  const [isPlaying, setIsPlaying] = useState(false);
  const [selectedVoice, setSelectedVoice] =
    useState<SpeechSynthesisVoice | null>(null);
  const [voices, setVoices] = useState<SpeechSynthesisVoice[]>([]);
  const [loading, setLoading] = useState(false);
  const speechSynthesis = window.speechSynthesis;
  const utteranceRef = useRef<SpeechSynthesisUtterance | null>(null);
  const [speed, setSpeed] = useState(1);
  const accuracy = useAccuracy();

  React.useEffect(() => {
    const loadVoices = () => {
      const availableVoices = speechSynthesis.getVoices();
      setVoices(availableVoices);
      setSelectedVoice(availableVoices[0]);
    };

    loadVoices();
    if (speechSynthesis.onvoiceschanged !== undefined) {
      speechSynthesis.onvoiceschanged = loadVoices;
    }

    return () => {
      if (utteranceRef.current) {
        speechSynthesis.cancel();
      }
    };
  }, []);

  const handleFileUpload = async (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setLoading(true);
    const formData = new FormData();
    formData.append("file", file);

    try {
      const response = await axios.post(
        "http://localhost:5000/upload",
        formData
      );
      setText(response.data.text);
    } catch (error) {
      console.error("Error uploading file:", error);
      alert("Error uploading file");
    } finally {
      setLoading(false);
    }
  };

  const speak = () => {
    if (!text || !selectedVoice) return;

    if (utteranceRef.current) {
      speechSynthesis.cancel();
    }

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.voice = selectedVoice;
    utteranceRef.current = utterance;
    utterance.rate = speed;

    utterance.onend = () => {
      setIsPlaying(false);
    };

    speechSynthesis.speak(utterance);
    setIsPlaying(true);
  };

  const pause = () => {
    speechSynthesis.pause();
    setIsPlaying(false);
  };

  const resume = () => {
    speechSynthesis.resume();
    setIsPlaying(true);
  };

  const stop = () => {
    speechSynthesis.cancel();
    setIsPlaying(false);
    utteranceRef.current = null;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-xl shadow-lg p-8">
          <h1 className="text-3xl font-bold text-gray-800 mb-8 flex items-center gap-2">
            <Volume2 className="w-8 h-8 text-indigo-600" />
            SpeechSync
          </h1>

          <div className="space-y-6">
            {/* File Upload */}
            <div className="flex items-center justify-center w-full">
              <label className="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                <div className="flex flex-col items-center justify-center pt-5 pb-6">
                  <Upload className="w-8 h-8 mb-3 text-gray-400" />
                  <p className="mb-2 text-sm text-gray-500">
                    <span className="font-semibold">Click to upload</span> or
                    drag and drop
                  </p>
                  <p className="text-xs text-gray-500">PNG, JPG</p>
                </div>
                <input
                  type="file"
                  className="hidden"
                  accept=".png,.jpg"
                  onChange={handleFileUpload}
                />
              </label>
            </div>

            {/* Voice Selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Select Voice
              </label>
              <select
                className="w-full p-2 border border-gray-300 rounded-md"
                value={selectedVoice?.name || ""}
                onChange={(e) => {
                  const voice = voices.find((v) => v.name === e.target.value);
                  setSelectedVoice(voice || null);
                }}
              >
                {voices.map((voice) => (
                  <option key={voice.name} value={voice.name}>
                    {voice.name} ({voice.lang})
                  </option>
                ))}
              </select>
            </div>

            {/* Text Display */}
            {text && (
              <div className="mt-4">
                <h2 className="text-lg font-semibold mb-2">Extracted Text:</h2>
                <div className="p-4 bg-gray-50 rounded-lg max-h-60 overflow-y-auto">
                  {text}
                </div>
              </div>
            )}

            {/* Playback Controls */}
            {text && (
              <div className="flex justify-center gap-4 items-center">
                {isPlaying ? (
                  <button
                    onClick={pause}
                    className="flex items-center gap-2 px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600"
                  >
                    <Pause className="w-5 h-5" />
                    Pause
                  </button>
                ) : (
                  <button
                    onClick={utteranceRef.current ? resume : speak}
                    className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600"
                  >
                    <Play className="w-5 h-5" />
                    {utteranceRef.current ? "Resume" : "Play"}
                  </button>
                )}
                <button
                  onClick={stop}
                  className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600"
                >
                  <StopCircle className="w-5 h-5" />
                  Stop
                </button>
                <>
                  <label>Speed: {speed.toFixed(1)}</label>
                  <input
                    type="range"
                    min="0.5"
                    max="2"
                    step="0.1"
                    value={speed}
                    onChange={(e) => setSpeed(parseFloat(e.target.value))}
                  />
                </>
              </div>
            )}

            {/* Loading State */}
            {loading && (
              <div className="text-center text-gray-600">
                Processing document...
              </div>
            )}
          </div>
          <div className="w-full text-center my-6">
            {text && <p>This output is generated with Accuracy: {accuracy}</p>}
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
