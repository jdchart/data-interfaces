<script>
    let audioFile;
    let audioContext;
    let audioBuffer;
    let sourceNode;
    let isPlaying = false;
    let startTime = 0;
    let pauseTime = 0;
    let currentTime = 0;
    let duration = 0;

    export const load_audio = async (input) => {
        stop();
        let arrayBuffer;

        // --- Case 1: File or Blob ---
        if (input instanceof File || input instanceof Blob) {
            arrayBuffer = await input.arrayBuffer();
        }

        // --- Case 2: URL string (local OR remote) ---
        else if (typeof input === 'string') {
            try {
                const response = await fetch(input, {
                    mode: "cors",   // allow remote files (if server permits)
                });

                if (!response.ok) {
                    throw new Error(`Fetch failed with status ${response.status}`);
                }

                arrayBuffer = await response.arrayBuffer();
            } catch (error) {
                console.error("Audio load failed:", error);
                throw new Error(
                    `Unable to load audio from URL "${input}". ` +
                    `If this is a remote file, ensure the server enables CORS.`
                );
            }
        }

        else {
            throw new Error("load_audio expects a File, Blob, or URL string");
        }

        // --- Decode into Web Audio API ---
        audioContext = new AudioContext();
        audioBuffer = await audioContext.decodeAudioData(arrayBuffer);

        duration = audioBuffer.duration;
        currentTime = 0;
        pauseTime = 0;

        return audioBuffer;
    };

    // Start playback at precise offset
    function play() {        
        if (!audioBuffer) return;

        let offset = Number(pauseTime);
        if (!Number.isFinite(offset)) offset = 0;

        sourceNode = audioContext.createBufferSource();
        sourceNode.buffer = audioBuffer;
        sourceNode.connect(audioContext.destination);
        sourceNode.start(0, offset);

        startTime = audioContext.currentTime - offset;
        isPlaying = true;

        updateTime();
        }

    function pause() {
        if (sourceNode) {
            sourceNode.stop();
            pauseTime = currentTime;
            isPlaying = false;
        };
    };

    function stop() {
        if (sourceNode) sourceNode.stop();
        isPlaying = false;
        pauseTime = 0;
        currentTime = 0;
    }

    // Seek to precise time (seconds)
    function seek(time) {
        pause();
        currentTime = pauseTime = Math.min(Math.max(time, 0), duration);
        if (isPlaying) play(currentTime);
    }

    // Play a precise segment in seconds
    function playSegment(start, end) {
        pause();
        const segmentLength = end - start;
        if (segmentLength <= 0) return;
        sourceNode = audioContext.createBufferSource();
        sourceNode.buffer = audioBuffer;
        sourceNode.connect(audioContext.destination);
        sourceNode.start(0, start, segmentLength);
        startTime = audioContext.currentTime - start;
        isPlaying = true;

        sourceNode.onended = () => {
        isPlaying = false;
        currentTime = end;
        pauseTime = end;
        };

        updateTime();
    }

    // Update currentTime for UI
    function updateTime() {
        if (!isPlaying) return;
        currentTime = audioContext.currentTime - startTime;
        if (currentTime >= duration) {
        currentTime = duration;
        isPlaying = false;
        return;
        }
        requestAnimationFrame(updateTime);
    }
</script>

<div>
    <button on:click={play} disabled={isPlaying}>Play</button>
    <button on:click={pause} disabled={!isPlaying}>Pause</button>
    <button on:click={stop}>Stop</button>
</div>

<input type="range" min="0" max={duration} step="0.001" bind:value={currentTime} on:input={(e) => seek(+e.target.value)} />

<p>Time: {currentTime.toFixed(3)} / {duration.toFixed(3)} s</p>

<div>
    <button on:click={() => playSegment(1.234, 2.567)}>Play 1.234s → 2.567s</button>
</div>
