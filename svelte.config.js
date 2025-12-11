import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
	prerender: {
		entries: ['*']
	},
	adapter: adapter({
			fallback: 'index.html' // may differ from host to host
	}),
    paths: {
      base: process.env.NODE_ENV === "production" ? "/data-interfaces" : ""
    }
  }
};