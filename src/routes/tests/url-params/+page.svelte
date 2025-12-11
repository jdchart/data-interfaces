<script>
    import { page } from '$app/stores';
    import { get_url_params } from '$lib/scripts/urls';
    $: params = Object.fromEntries($page.url.searchParams.entries());

    console.log(params);
</script>

<h1>URL PARAM TEST</h1>