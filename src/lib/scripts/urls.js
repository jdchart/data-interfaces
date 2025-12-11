export function get_url_params(url) {
    const params = Object.fromEntries(url.searchParams.entries());
    return params;
}

// $: if (jsonUrl) {
//             fetch(jsonUrl)
//             .then(r => r.json())
//             .then(data => {
//                 ret[param_list[i]] = data
//             });
//         }