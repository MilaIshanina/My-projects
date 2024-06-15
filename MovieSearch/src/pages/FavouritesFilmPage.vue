<template>
	<HeaderWidget 
		:is-home="false" 
		:state="state"
	/>
	<div class="container movies">
		<Movie
			v-for="movie of movieStore.favouritesMovies"
			:key="movie.id"
			:movie="movie"
			:is-favourite="true"
		/>
	</div>
</template>

<script setup>
import { useMovieStore } from "../stores/MovieStore"
import Movie from "../components/Movie.vue"
import HeaderWidget from "../components/HeaderWidget.vue"

const movieStore = useMovieStore()
let state = {
	data: movieStore.moviesInLS,
}
</script>

<style scoped lang="sass">
@import "../assets/main.sass"
</style>
