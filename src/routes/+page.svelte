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
</style>