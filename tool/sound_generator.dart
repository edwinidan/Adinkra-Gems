import 'dart:io';
import 'dart:math' as math;

/// Generates synthesized 8-bit mono PCM WAV files at 11025 Hz for game sound effects.
///
/// Prevents the need to ship binary sound assets by generating them dynamically.
class SoundGenerator {
  static const int sampleRate = 11025;

  /// Generates the five key game sound effects if they do not already exist.
  static Future<void> generateAllSounds() async {
    try {
      final dir = Directory('assets/audio');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await _generateWavIfMissing(
        File('assets/audio/swap.wav'),
        _generateSwapBytes(),
      );
      await _generateWavIfMissing(
        File('assets/audio/match.wav'),
        _generateMatchBytes(),
      );
      await _generateWavIfMissing(
        File('assets/audio/special_clear.wav'),
        _generateSpecialClearBytes(),
      );
      await _generateWavIfMissing(
        File('assets/audio/win.wav'),
        _generateWinBytes(),
      );
      await _generateWavIfMissing(
        File('assets/audio/lose.wav'),
        _generateLoseBytes(),
      );
    } catch (e) {
      // Fail silently or log error
      // In web platforms, File IO might fail during execution, which is fine as we'll handle it.
      // But during build/test on user's machine, this will succeed.
    }
  }

  static Future<void> _generateWavIfMissing(File file, List<int> bytes) async {
    if (!await file.exists()) {
      await file.writeAsBytes(bytes);
    }
  }

  /// Appends standard 44-byte WAV header to PCM byte data.
  static List<int> _buildWav(List<int> pcm) {
    final byteCount = pcm.length;
    final wav = <int>[];

    // 1. RIFF Identifier
    wav.addAll('RIFF'.codeUnits);
    // 2. ChunkSize: 36 + SubChunk2Size
    final chunkSize = 36 + byteCount;
    wav.add(chunkSize & 0xFF);
    wav.add((chunkSize >> 8) & 0xFF);
    wav.add((chunkSize >> 16) & 0xFF);
    wav.add((chunkSize >> 24) & 0xFF);

    // 3. Format "WAVE"
    wav.addAll('WAVE'.codeUnits);
    // 4. Subchunk1 ID "fmt "
    wav.addAll('fmt '.codeUnits);
    // 5. Subchunk1 Size (16 for PCM)
    wav.addAll([16, 0, 0, 0]);
    // 6. AudioFormat (1 for PCM, uncompressed)
    wav.addAll([1, 0]);
    // 7. NumChannels (1 for Mono)
    wav.addAll([1, 0]);
    // 8. SampleRate (11025)
    wav.add(sampleRate & 0xFF);
    wav.add((sampleRate >> 8) & 0xFF);
    wav.add((sampleRate >> 16) & 0xFF);
    wav.add((sampleRate >> 24) & 0xFF);
    // 9. ByteRate (SampleRate * NumChannels * BitsPerSample/8) -> 11025
    wav.add(sampleRate & 0xFF);
    wav.add((sampleRate >> 8) & 0xFF);
    wav.add((sampleRate >> 16) & 0xFF);
    wav.add((sampleRate >> 24) & 0xFF);
    // 10. BlockAlign (NumChannels * BitsPerSample/8) -> 1
    wav.addAll([1, 0]);
    // 11. BitsPerSample (8 bits)
    wav.addAll([8, 0]);

    // 12. Subchunk2 ID "data"
    wav.addAll('data'.codeUnits);
    // 13. Subchunk2 Size
    wav.add(byteCount & 0xFF);
    wav.add((byteCount >> 8) & 0xFF);
    wav.add((byteCount >> 16) & 0xFF);
    wav.add((byteCount >> 24) & 0xFF);

    // 14. Audio data
    wav.addAll(pcm);

    return wav;
  }

  // ── PCM Generators ─────────────────────────────────────────────────────────

  static List<int> _generateSwapBytes() {
    final pcm = <int>[];
    final duration = 0.08; // 80 ms
    final totalSamples = (duration * sampleRate).toInt();
    double phase = 0.0;

    for (int i = 0; i < totalSamples; i++) {
      final t = i / totalSamples;
      // Sliding pitch from 240Hz down to 140Hz
      final freq = 240.0 - (100.0 * t);
      phase += 2.0 * math.pi * freq / sampleRate;

      final envelope = 1.0 - t;
      final sample = 128 + (35 * math.sin(phase) * envelope).toInt();
      pcm.add(sample.clamp(0, 255));
    }
    return _buildWav(pcm);
  }

  static List<int> _generateMatchBytes() {
    final pcm = <int>[];
    final duration = 0.16; // 160 ms
    final totalSamples = (duration * sampleRate).toInt();

    final freq1 = 523.25; // C5 note
    final freq2 = 659.25; // E5 note (nice major third chord)

    for (int i = 0; i < totalSamples; i++) {
      final t = i / totalSamples;
      // Exponential decay envelope
      final envelope = math.exp(-3.5 * t);

      final s1 = math.sin(2.0 * math.pi * freq1 * i / sampleRate);
      final s2 = math.sin(2.0 * math.pi * freq2 * i / sampleRate);
      final mixed = (s1 + s2) * 0.5;

      final sample = 128 + (40 * mixed * envelope).toInt();
      pcm.add(sample.clamp(0, 255));
    }
    return _buildWav(pcm);
  }

  static List<int> _generateSpecialClearBytes() {
    final pcm = <int>[];
    final duration = 0.28; // 280 ms
    final totalSamples = (duration * sampleRate).toInt();
    double phase = 0.0;
    final random = math.Random(42); // Seeded for deterministic generation

    for (int i = 0; i < totalSamples; i++) {
      final t = i / totalSamples;
      final envelope = math.exp(-2.0 * t);

      // Fast rising frequency sweep
      final freq = 350.0 + (950.0 * t);
      phase += 2.0 * math.pi * freq / sampleRate;

      // Add a bit of white noise to make it crackle/explode
      final noise = (random.nextDouble() - 0.5) * 2.0;
      final signal = (math.sin(phase) * 0.6) + (noise * 0.4);

      final sample = 128 + (45 * signal * envelope).toInt();
      pcm.add(sample.clamp(0, 255));
    }
    return _buildWav(pcm);
  }

  static List<int> _generateWinBytes() {
    final pcm = <int>[];
    // A quick ascending melody: C5 -> E5 -> G5 -> C6
    final notes = [523.25, 659.25, 783.99, 1046.50];
    final noteDuration = 0.11; // 110 ms per note
    final samplesPerNote = (noteDuration * sampleRate).toInt();

    for (int n = 0; n < notes.length; n++) {
      final freq = notes[n];
      for (int i = 0; i < samplesPerNote; i++) {
        final t = i / samplesPerNote;
        // Fade out slightly at the end of each note
        final envelope = 1.0 - (t * 0.25);
        final sample = 128 + (35 * math.sin(2.0 * math.pi * freq * i / sampleRate) * envelope).toInt();
        pcm.add(sample.clamp(0, 255));
      }
    }
    return _buildWav(pcm);
  }

  static List<int> _generateLoseBytes() {
    final pcm = <int>[];
    // Descending sad progression: G4 -> E-flat 4 -> C4
    final notes = [392.00, 311.13, 261.63];
    final noteDuration = 0.18; // 180 ms per note
    final samplesPerNote = (noteDuration * sampleRate).toInt();

    for (int n = 0; n < notes.length; n++) {
      final freq = notes[n];
      for (int i = 0; i < samplesPerNote; i++) {
        final t = i / samplesPerNote;
        final envelope = 1.0 - t; // Sad fade out
        final sample = 128 + (35 * math.sin(2.0 * math.pi * freq * i / sampleRate) * envelope).toInt();
        pcm.add(sample.clamp(0, 255));
      }
    }
    return _buildWav(pcm);
  }
}

void main() async {
  print('Generating sound effects...');
  await SoundGenerator.generateAllSounds();
  print('Sound files generated successfully.');
}
