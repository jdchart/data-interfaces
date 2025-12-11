import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
	prerender: {
		entries: ['*']
	},
    adapter: adapter(),
    paths: {
      base: process.env.NODE_ENV === "production" ? "/data-interfaces" : ""
    }
  }
};