<script>
    import Timeline from '$lib/components/audio_player/Timeline.svelte';

    export let display_ui = true;

    let audioFile;
    let audioContext;
    let audioBuffer;
    let sourceNode;
    let isPlaying = false;
    let startTime = 0;
    let pauseTime = 0;
    let currentTime = 0;
    let duration = 0;

    let timeline_el;

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
        if(isPlaying == false){
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
        }else{
            pause();
        };
    };

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
    export const  playSegment = (start, end) => {
        stop();
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
    };

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
        timeline_el.render();
    };
</script>

{#if display_ui === true}
    <div class="cont">
        <button on:click={play} class="icon-btn" title="playpause">
            {#if isPlaying}
                <!-- Pause -->
                <svg viewBox="6 -1 24 24">
                    <rect x="5" y="4" width="4" height="16" />
                    <rect x="15" y="4" width="4" height="16" />
                </svg>
            {:else}
                <!-- Play -->
                <svg viewBox="6 -1 24 24">
                    <polygon points="5,3 19,12 5,21" />
                </svg>
            {/if}
        </button>

        <button on:click={stop} class="icon-btn" title="stop">
            <svg viewBox="6 -1 24 24">
                <rect x="5" y="5" width="14" height="14" />
            </svg>
        </button>

        <button on:click={stop} class="icon-btn" title="stop">
            <svg viewBox="6 -1 24 24">
                <path d="M17 1l4 4-4 4V6H7a4 4 0 0 0 0 8h1v2H7a6 6 0 0 1 0-12h10V1z"/>
                <path d="M7 23l-4-4 4-4v3h10a4 4 0 0 0 0-8h-1V8h1a6 6 0 0 1 0 12H7v3z"/>
            </svg>
        </button>

        <!-- <input type="range" min="0" max={duration} step="0.001" bind:value={currentTime} on:input={(e) => seek(+e.target.value)} /> -->

        <Timeline 
            bind:this={timeline_el}
            audioBuffer={audioBuffer}
            currentTime={currentTime}
            duration={duration}
            on:seek={(e) => {seek(e.detail.seek_to)}}
        />

        <p>{currentTime.toFixed(3)}/{duration.toFixed(3)}</p>
    </div>
{/if}

<style>
    .cont{
        width: 100%;
        display: flex;
        align-items: center;
        gap: 0.3em;
        font-size: 0.75em;
        box-sizing: border-box;
    }

    p{
        font-size: small;
    }

    .icon-btn svg {
        width: 16px;
        height: 16px;
        fill: #333;
    }

    button{
        width: 24px;
        height: 24px;
        align-items: center;
    }
    svg{
        overflow: visible;
    }

    .icon-btn:hover svg {
        fill: #007aff;
    }
</style>