<script>
    import { onMount } from 'svelte';
    import { get_url_params } from '$lib/scripts/urls';

    let params = {};
    let json_data = {};

    onMount(() => {
        params = get_url_params();
        console.log("Params:", params);

        if (params.json) {
            fetch(params.json)
                .then(r => r.json())
                .then(data => {
                    json_data = data;
                    console.log("JSON data fetched:", json_data);
                })
                .catch(err => console.error("Error fetching JSON:", err));
        } else {
            console.log("No json found");
        }
    });
</script>

<pre>{JSON.stringify(params, null, 2)}</pre>
<pre>{JSON.stringify(json_data, null, 2)}</pre>