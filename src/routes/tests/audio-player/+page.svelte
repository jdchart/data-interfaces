<script>
    import AudioPlayer from '$lib/components/audio_player/AudioPlayer.svelte';
    import { onMount } from 'svelte';
    import { base } from '$app/paths';

    onMount(async () => {
        await player_comp.load_audio(base + "/sound/test-audio.wav");
        // await player_comp.load_audio("https://raw.githubusercontent.com/ARVEST-APP/arvest-workshops/refs/heads/main/resources/audio/o-let-me-weep.wav");
        // await player_comp.load_audio("https://upload.wikimedia.org/wikipedia/commons/b/b2/03a_rodzaje_sygnalow_alarmowych.wav");
    });

    let player_comp;
    let text_val = "";
</script>

<AudioPlayer
    bind:this={player_comp}
/>

<br>
<input type="file" on:change={(e) => player_comp.load_audio(e.target.files[0])} />
<br>
<input type="text" bind:value={text_val} />
<button on:click={(e) => player_comp.load_audio(text_val)}>Load from text</button>
<h2>Examples to load:</h2>
<p>https://raw.githubusercontent.com/ARVEST-APP/arvest-workshops/refs/heads/main/resources/audio/o-let-me-weep.wav</p>
<p>https://upload.wikimedia.org/wikipedia/commons/b/b2/03a_rodzaje_sygnalow_alarmowych.wav</p>