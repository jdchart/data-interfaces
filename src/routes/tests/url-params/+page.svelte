<script>
	import { page } from '$app/stores';
	import { browser } from '$app/environment';


    let params = {}
    $: if(browser){
        params = Object.fromEntries($page.url.searchParams.entries());
        console.log(params);

        // Load the json:
        if (params) {
            fetch(params["json"])
            .then(r => r.json())
            .then(data => {
                console.log(data);
            });
        }
    };
</script>

<pre>{JSON.stringify(params, null, 2)}</pre>