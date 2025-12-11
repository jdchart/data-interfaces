<script>
    import { page } from '$app/stores';

    // automatically update when query params change
    $: params = Object.fromEntries($page.url.searchParams.entries());

    console.log(params)
</script>

<pre>{JSON.stringify(params, null, 2)}</pre>