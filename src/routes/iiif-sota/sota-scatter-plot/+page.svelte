<script>
    import ScatterPlot from '$lib/components/scatter_plot/ScatterPlot.svelte';
    import { base } from '$app/paths';

    import { onMount } from 'svelte';
    import { get_url_params } from '$lib/scripts/urls';

    let unique_selected_agregate = [];

    let params = {};
    let json_data = {};
    let scaller_el;
    //let plot_data = base + "/data/iiif-sota/academic_field-embeddings.json"
    let plot_data = "";
    let page_title = "IIIF SOTA";
    update_title();

    function update_title(){
        if(plot_data != ""){
            let split = plot_data.split("/data/iiif-sota/")[1].split("-embeddings.json")[0];

            let strings = split.split("_")
            let fin = ""
            strings.forEach(item => {
                fin = fin + item.toUpperCase() + " "
            })

            page_title = "IIIF SOTA | " + String(fin)
        };
    }

    onMount(async () => {
        params = get_url_params();
        console.log("Params:", params);

        if(params.plot){
            plot_data = params.plot;
            await scaller_el.update_data(plot_data);
            update_title();
        };
    });

    let selectedPoints = [];

    async function handleSelection(points) {
        selectedPoints = points;
        //console.log("Selected points:", points);
        
        unique_selected_agregate = [];
        selectedPoints.forEach(point => {
            point.uuids.forEach(uuid => {
                if(unique_selected_agregate.includes(uuid) == false){
                    unique_selected_agregate.push(uuid);
                };
            });
        });
        console.log(unique_selected_agregate);
    }
</script>

<svelte:head>
    <title>{page_title}</title>
</svelte:head>

<div class="main_wrapper">
    <div class="scatter_wrapper">
        <ScatterPlot 
            dataUrl={plot_data}
            onSelect={handleSelection}
            bind:this={scaller_el}
        />
    </div>
    
    <div class="controls_row">
        <div class="control_wrapper cw_l">
            <h2>Selection</h2>
            <p>Number of unique selected items: {unique_selected_agregate.length}</p>
            <ul>
            {#each selectedPoints as p}
                <li>- {p.word} (count: {p.count})</li>
            {/each}
            </ul>
        </div>

        <div class="control_wrapper cw_r">
            <h2>Inspection</h2>
            <ul>
            {#each selectedPoints as p}
                <li class="inspection_element">
                    <h3>{p.word} ({p.count})</h3>
                    <div class="items_list">
                        {#each p.manifest_urls as man_url}
                            <li class="items_list_element"><a target="_blank" href="{man_url.url}">{man_url.label}</a></li>
                        {/each}
                    </div>
                </li>
            {/each}
            </ul>
        </div>
    </div>
</div>

<style>
    .main_wrapper{
        /* box-sizing: border-box;
        width: fit-content;
        height: 94vh;

        margin: 2vh auto;

        display: flex;
        flex-direction: column;
        overflow: hidden; */

        box-sizing: border-box;
        width: 100%;
        max-width: 800px;
        height: 94vh;

        margin: 2vh auto;

        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    .scatter_wrapper{
        /* border: solid 1px black;
        background-color: rgb(249, 249, 249);
        width: 100%; */

         border: solid 1px black;
        background-color: rgb(249, 249, 249);
        width: 100%;
        flex: 0 0 auto;
    }

    .controls_row {
        width: 100%;
        margin-top: 0.5em;
        flex: 1;
        display: flex;
        gap: 0.5em;
        overflow: hidden;

        min-height: 0;  
    }

    .control_wrapper {
        flex: 0 0 50%;
        max-width: 50%;
        min-width: 0;
        overflow-y: auto;
        overflow-x: hidden;

        min-height: 0;
    }

    .cw_r{
        padding-right: 0.5em;
    }

    .control_wrapper h2{
        font-size: 0.5em;
    }

    .control_wrapper h3{
        font-size: 1em;
        margin-bottom: 0.5em;
    }


    .control_wrapper ul{
        margin-top: 0.3em;
        line-height: 0.5em;

        /* margin: 0.3em 0;
        padding-left: 1em;
        line-height: 0.5em; */
    }

    .control_wrapper li{
        font-size: 0.4em;
        color: var(--secondary-text);
    }
    .control_wrapper p{
        font-size: 0.4em;
        padding-top: 0.5em;
    }

    .items_list{
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        gap: 0.5em;
        overflow-wrap: anywhere;
    }


    .items_list a {
        word-break: break-word;
        font-size: 2em;
        background-color: rgb(123, 171, 212);
        color: white;
        text-decoration: none;
        padding-top: 0.1em;
        padding-bottom: 0.1em;
        padding-left: 0.3em;
        padding-right: 0.3em;
        border-radius: 5px;
    }

    .items_list a:hover{
        cursor: pointer;
        background-color: rgb(175, 202, 225);
    }

    .items_list_element {
        margin-top: 0.5em;
        margin-bottom: 0.5em;
    }

    .inspection_element{
        margin-top: 1em;
    }
</style>