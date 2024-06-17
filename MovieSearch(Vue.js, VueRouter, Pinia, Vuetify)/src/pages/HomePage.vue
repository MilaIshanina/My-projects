<template>
	<HeaderWidget :is-home="true" :state="state">
		<form @submit.prevent="pagDat">
			<v-text-field
				type="text"
				placeholder="Поиск"
				v-model="movieInput"
				class="input"
			/>
		</form>
	</HeaderWidget>
	<div class="container movies">
		<Movie
			v-for="item in pagDat()" 
			:key="item.id"
			:movie="item"
			@click="router.push({ name: 'moviecard', params: { id: item.id } })"
		/>
	</div>
	<div class="btn-bottom">
			<v-btn 
				class="btn" 
				@click="onClickBack()"
			> 
				Назад 
			</v-btn>
			<v-btn
				v-for="item in countPageFunction()"
				:key="item"
				class="btn"
				@click="onClickGoPage(item)"
			>
				{{ item }}
			</v-btn>
			<v-btn 
				class="btn" 
				@click="onClickNext()"
			> 
				Вперед 
			</v-btn>
	</div>
</template>

<script setup>
import { useMovieStore } from "../stores/MovieStore"
import { ref } from "vue"
import { useRouter } from "vue-router"
import Movie from "../components/Movie.vue"
import HeaderWidget from "../components/HeaderWidget.vue"

const movieStore = useMovieStore()
const router = useRouter()
const movieInput = ref("")
let state = {
	data: movieStore.movies,
	paginatedData: movieStore.movies,
	page: ref(1),
	perPage: 25,
	lastSearch: "",
}
const countPageFunction = () => {
	if (movieInput.value) {
		if (state.lastSearch !== movieInput.value) {
			state.page.value = 1
		}
		const search = movieInput.value
		const cur = state.data.filter(
			m => m.name.toUpperCase().indexOf(search.toUpperCase()) !== -1
		)
		if (cur.length <= 25) {
			return 1
		}
		return Math.ceil(cur.length / state.perPage)
	}
	return Math.ceil(state.data.length / state.perPage)
}
const pagDat = () => {
	state.paginatedData = state.data.slice(
		(state.page.value - 1) * state.perPage,
		state.page.value * state.perPage
	)
	const search = movieInput.value
	if (search) {
		if (state.lastSearch !== search) {
			state.page.value = 1
			state.lastSearch = search
			state.data = movieStore.movies
		}
		const cs = state.data.filter(
			m => m.name.toUpperCase().indexOf(movieInput.value.toUpperCase()) !== -1
		)
		state.paginatedData = cs.slice(
			(state.page.value - 1) * state.perPage,
			state.page.value * state.perPage
		)
		return state.paginatedData.filter(
			m => m.name.toUpperCase().indexOf(search.toUpperCase()) !== -1
		)
	} else if (search === '') {
		state.data = movieStore.movies
		state.paginatedData = state.data.slice(
			(state.page.value - 1) * state.perPage,
			state.page.value * state.perPage
		)
	}
	return state.paginatedData
}

const onClickNext = () => {
	movieStore.nextPage(state, movieInput.value.toUpperCase())
  	window.scrollTo({ top: 0, behavior: "smooth" })

}
const onClickBack = () => {
	movieStore.backPage(state)
  	window.scrollTo({ top: 0, behavior: "smooth" })
}
const onClickGoPage = item => {
	movieStore.goToPage(state, item)
  	window.scrollTo({ top: 0, behavior: "smooth" })
}
</script>

<style scoped lang="sass">
@import "../assets/main.sass"
</style>
