import { createRouter, createWebHistory } from "vue-router";
import HomePage from '../pages/HomePage.vue'
import MovieCardPage from '../pages/MovieCardPage.vue'
import FavouritesFilmPage from '../pages/FavouritesFilmPage.vue'
const router = createRouter({
	history: createWebHistory(import.meta.env.BASE_URL),
	routes: [
		{
			path: '/',
			name: 'home',
			component: HomePage,
		},
		{
			path: '/moviecard/:id',
			name: 'moviecard',
			component: MovieCardPage,
		},
		{
			path: '/favourites',
			name: 'favourites',
			component: FavouritesFilmPage,
		},
	],
})
export default router
