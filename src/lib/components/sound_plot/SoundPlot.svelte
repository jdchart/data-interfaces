<script>
  import * as d3 from "d3";
  import { onMount } from "svelte";

  import AudioPlayer from '$lib/components/audio_player/AudioPlayer.svelte';

  let width = 1420;
  let height = 650;
  let current_label = "Click on a sound...";

  let svg;
  let json_getter;
  let audio_getter;

  function handle_json_click(){
    json_getter.click();
  };
  function handle_audio_click(){
    audio_getter.click();
  };

  function handleFileUpload(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        try {
          const jsonData = JSON.parse(e.target.result);
          console.log(jsonData)
          // Do stuff with json
        } catch (error) {
          console.error('Error parsing JSON:', error);
        }
      };
      reader.readAsText(file);
    }
  };

  function handleFileUploadAudio(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = async function(e) {
        try {
          const audioData = e.target.result;
          // await loadAudio(audioData);
          // Dow stuff with audio
        } catch (error) {
          console.error('Error loading audio:', error);
        }
      };
      reader.readAsArrayBuffer(file);
    }
  };

  // let currentSource;

  // let container;
  // let audioCtx;
  // let currentTransform = d3.zoomIdentity;

  // async function playAudio(event, d) {
  //   const startSec = d.start_ms / 1000;
  //   const duration = (d.end_ms - d.start_ms) / 1000;

  //   if (!isFinite(startSec) || !isFinite(duration) || duration <= 0) {
  //     console.error("Invalid audio segment:", { startSec, duration });
  //     return;
  //   }

  //   // 🔇 Stop previous playback
  //   if (currentSource) {
  //     try {
  //       currentSource.stop();
  //     } catch (e) {
  //       console.warn("Tried to stop an already stopped source.");
  //     }
  //     currentSource = null;
  //   }

  //   try {
  //     const res = await fetch(`/audio/${d.audio_file}`);
  //     const arrayBuffer = await res.arrayBuffer();
  //     const audioBuffer = await audioCtx.decodeAudioData(arrayBuffer);

  //     const source = audioCtx.createBufferSource();
  //     source.buffer = audioBuffer;
  //     source.connect(audioCtx.destination);
  //     source.start(0, startSec, duration);

  //     currentSource = source; // 🔄 Save the current source

  //     current_label = d.audio_file;
  //   } catch (err) {
  //     console.error("Failed to play audio:", err);
  //   }
  // }

  // onMount(() => {
  //   audioCtx = new (window.AudioContext || window.webkitAudioContext)();

  //   const xScale = d3.scaleLinear()
  //     .domain(d3.extent(data, d => d.x))
  //     .range([0, width]);

  //   const yScale = d3.scaleLinear()
  //     .domain(d3.extent(data, d => d.y))
  //     .range([height, 0]);

  //   const svgEl = d3.select(svg);
  //   container = svgEl.append("g");

  //   // Render circles for each data point
  //   container.selectAll("circle")
  //     .data(data)
  //     .enter()
  //       .append("circle")
  //       .attr("cx", d => xScale(d.x))
  //       .attr("cy", d => yScale(d.y))
  //       .attr("r", 1)
  //       .attr("fill", d => {
  //         if(d.classification === "music"){
  //          return  "green"
  //         }else if (d.classification === "speech"){
  //           return "red"
  //         }
  //         else{
  //           return "blue"
  //         }
  //       } )
  //       .on("click", (event, d) => {
  //         event.stopPropagation(); // So it doesn't trigger the background click
  //         playAudio(event, d);
  //       });

  //   // Setup zoom behavior
  //   svgEl.call(
  //     d3.zoom()
  //       .scaleExtent([0.5, 20])
  //       .on("zoom", (event) => {
  //         currentTransform = event.transform;
  //         container.attr("transform", currentTransform);
  //       })
  //   );

  //   // Add click listener for background (to play nearest point)
  //   svgEl.on("click", (event) => {
  //     const [mouseX, mouseY] = d3.pointer(event);
  //     const invX = currentTransform.invertX(mouseX);
  //     const invY = currentTransform.invertY(mouseY);

  //     // Find nearest point
  //     let nearest = null;
  //     let minDist = Infinity;

  //     for (const d of data) {
  //       const dx = xScale(d.x) - invX;
  //       const dy = yScale(d.y) - invY;
  //       const dist = dx * dx + dy * dy;
  //       if (dist < minDist) {
  //         minDist = dist;
  //         nearest = d;
  //       }
  //     }

  //     if (nearest) {
  //       playAudio(event, nearest);
  //     }
  //   });
  // });
</script>

<svg bind:this={svg} width={width} height={height} style="border: 1px solid #ccc; background-color: white;"></svg>

<p>{current_label}</p>

<div class="buttons">
    <div class="input">
        <button on:click={() => handle_json_click()}>json</button>
        <input bind:this={json_getter} type="file" accept=".json" on:change={handleFileUpload} />
    </div>

    <div class="input">
      <button on:click={() => handle_audio_click()}>audio</button>
        <input bind:this={audio_getter} type="file" accept=".mp3, .wav" on:change={handleFileUploadAudio} />
    </div>
</div>

<AudioPlayer />

<style>
  svg{
    margin: 0.5em;
  }
  p{
    margin-top: 0.3em;
    margin-left: 0.5em;
  }
  p, button{
    font-size: 0.75em;
    font-family: 'Input-Mono-Narrow-Thin', monospace;
  }

  .buttons{
    width: 500px;
    background-color: grey;
  }

  input{
    display: none;
  }

  .input{
    display: grid;
    grid-template-columns: 1fr 3fr;
    align-items: center;
    gap: 1em;
  }
</style>