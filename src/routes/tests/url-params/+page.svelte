<script>
	import { page } from '$app/stores';
	import { browser } from '$app/environment';

	// Only evaluate in the browser, never during prerender
	$: params = browser
		? Object.fromEntries($page.url.searchParams.entries())
		: {};

    console.log(params)
</script>

<pre>{JSON.stringify(params, null, 2)}</pre>