<script>
    import TopNav from '$lib/components/general_ui/top_nav/TopNav.svelte';
    import Footer from '$lib/components/general_ui/Footer.svelte';
    import { base } from '$app/paths';
</script>

<svelte:head>
    <title>Tests</title>
</svelte:head>

<TopNav />

<div class="cont">
    <h1>Tests</h1>
    <p>Tests and demos of various components.</p>
    <a href="{base}/tests/audio-player">Audio player</a>
    <a href="{base}/tests/url-params">URL parameters</a>
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
        margin-bottom: 0.5em;
    }

    a{
        font-size: smaller;
        margin-bottom: 0.5;
    }
</style>