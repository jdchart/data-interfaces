import { page } from '$app/stores';
import { browser } from '$app/environment';

export function get_url_params() {
    if(browser){
        let params;
        const unsubscribe = page.subscribe(($page) => {
            params = Object.fromEntries($page.url.searchParams.entries());
        });
        unsubscribe();
        return params;
    }else{
        return {};
    };  
};