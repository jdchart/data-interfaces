import { browser } from '$app/environment';

export function get_url_params(page){
    if(browser){return Object.fromEntries($page.url.searchParams.entries());};
};