<script>
    import TopNav from '$lib/components/general_ui/top_nav/TopNav.svelte';
    import Footer from '$lib/components/general_ui/Footer.svelte';
    import { base } from '$app/paths';
</script>

<svelte:head>
    <title>Data Interfaces</title>
</svelte:head>

<TopNav />

<div class="cont">
    <h1>Data interfaces</h1>
    <p>A collection of live js-driven data visualization interfaces created by Jacob Hart. They can be used as standalone webpages, or embedded within an interface like an ipynb in order to visualize and interact with results of various proceses.</p>

    <div class="interface-links">
        <a href="{base}/sound-plot-single">Single file sound plot</a>
    </div>

    <div class="IIIF-sota-div">
        <h2>IIIF State of the art</h2>
        <ul>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/academic_field-embeddings.json">Academic field</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/access_governance-embeddings.json">Access governance</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/annotation_modalities-embeddings.json">Annotation modalities</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/authors_institutions-embeddings.json">Authors' institutions</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/iiif_usage-embeddings.json">IIIF Usage</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/media_formats-embeddings.json">Media formats</a></li>
            <li><a href="{base}/iiif-sota/sota-scatter-plot?plot={base}/data/iiif-sota/target_audience-embeddings.json">Target audience</a></li>
        </ul>
    </div>
</div>

<Footer />

<style>
    .cont{
        width: 100%;
        height: 100vh;
        padding-top: 2em;
        padding-bottom: 2em;
        padding-left: 2em;
        padding-right: 10em;
    }

    h1{
        margin-bottom: 1em;
    }

    p{
        font-size: smaller;
    }

    .interface-links{
        margin-top: 1em;
    }

    .IIIF-sota-div{
        margin-top: 1em;
    }
    .IIIF-sota-div ul{
        margin-top: 1em;
        margin-left: 1em;
    }
</style>