<script>
    import { base } from '$app/paths';
</script>

<div class="cont">
    <a href="{base}/"><h1>Data<br>Interfaces</h1></a>
    <a href="{base}/tests">Tests</a>
</div>
<div id="top_nav_gapper"></div>

<style>
    #top_nav_gapper{
        width: 100%;
        height: 50px;
    }

    .cont{
        width: 100%;
        background-color: var(--background-color-2); 
        border-bottom: 1px solid var(--primary-text);
        height: 50px;
        align-items: center;
        align-content: center;
        padding-top: 0.5em;
        padding-bottom: 0.5em;
        padding-left: 2em;
        padding-right: 2em;
        display: flex;
        gap: 0.5em;
        position: fixed;
        z-index: 1000;
    }

    a{
        text-decoration: none;
        color: var(--primary-text);
        font-size: 0.5em;
        font-family: 'Input-Mono-Narrow-Thin', monospace;
        line-height: 1.5em;
        transition-duration: 100ms;
    }

    a:hover{
        text-decoration: underline;
        color: var(--secondary-text);
    }

    h1{
        font-family: 'Input-Mono-Narrow-Thin', monospace;
        margin-right: 1em;
    }
</style>