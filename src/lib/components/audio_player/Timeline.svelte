<script>
    import { onMount, createEventDispatcher } from "svelte";
    let canvas;
    let ctx;

    const dispatch = createEventDispatcher();

    onMount(async () => {
        ctx = canvas.getContext("2d");
        
        compute_resize();
        window.addEventListener('resize', resizeCanvas);
    });

    function compute_resize(){
        let computed_width = Math.floor(canvas.getBoundingClientRect().width);
        canvas.width = computed_width;
        render();
    };

    export let mode = 'slider';
    export let audioBuffer;
    export let currentTime = 0;
    export let duration = 0;

    function timeToX(t) {
        return (t / duration) * canvas.width;
    }

    function xToTime(x) {
        return (x / canvas.width) * duration;
    }

    function clear() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }

    function drawPlayhead() {
        // const x = timeToX(currentTime);
        // ctx.strokeStyle = 'red';
        // ctx.beginPath();
        // ctx.moveTo(x, 0);
        // ctx.lineTo(x, canvas.height);
        // ctx.stroke();
    }

    export const render = () => {
        if (!ctx) return;
        clear();

        if (mode === 'slider') drawSlider();
        if (mode === 'waveform') drawWaveform();
        if (mode === 'spectrogram') drawSpectrogram();

        drawPlayhead();
    };

    function drawSlider() {
        const y = canvas.height / 2;

        ctx.strokeStyle = '#ccc';
        //ctx.strokeStyle = 'black';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, y);
        ctx.lineTo(canvas.width, y);
        ctx.stroke();

        ctx.fillStyle = '#007aff';
        //ctx.fillStyle = 'red';
        ctx.beginPath();
        ctx.arc(timeToX(currentTime), y, 6, 0, Math.PI * 2);
        ctx.fill();
    };

    function onPointer(e) {
        const rect = canvas.getBoundingClientRect();
        const x = Math.max(0, Math.min(e.clientX - rect.left, rect.width));
        
        dispatch('seek', {
            seek_to: xToTime(x)
        });
        render();
    };
</script>

<canvas 
    bind:this={canvas}
    width="800" 
    height="24"
    on:pointerdown={onPointer}
    on:pointermove={(e) => e.buttons && onPointer(e)}
></canvas>

<style>
    canvas {
        flex: 1;
        cursor: pointer;
        box-sizing: border-box;
    }
</style>