<template>
	<div>
		<Movie
			:movie="movieStore.searchMovie($route.params.id)"
			:is-only-card="true"
		/>
	</div>
</template>

<script setup>
import { useMovieStore } from "../stores/MovieStore"
import Movie from "../components/Movie.vue"

const movieStore = useMovieStore()
</script>

<style lang="sass" scoped>
@import "../assets/main.sass"
</style>
