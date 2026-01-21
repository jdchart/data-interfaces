<script>
    let scrubCanvas;
    let isScrubbing = false;

    function onScrubStart(e) {
        isScrubbing = true;
        scrubTo(e);
        window.addEventListener("pointermove", scrubTo);
        window.addEventListener("pointerup", onScrubEnd);
    };

    function scrubTo(e) {
        const rect = scrubCanvas.getBoundingClientRect();
        const x = Math.max(0, Math.min(e.clientX - rect.left, rect.width));
        const time = (x / rect.width) * duration;
        seek(time);
    };

    function onScrubEnd() {
        isScrubbing = false;
        window.removeEventListener("pointermove", scrubTo);
        window.removeEventListener("pointerup", onScrubEnd);
    };
</script>

<canvas
    bind:this={scrubCanvas}
    width="800"
    height="60"
    on:pointerdown={onScrubStart}
></canvas>

<style>
    canvas {
        cursor: pointer;
    }
</style>