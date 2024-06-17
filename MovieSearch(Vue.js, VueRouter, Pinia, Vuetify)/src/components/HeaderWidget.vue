<template>
	<header class="container">
		<div class="content">
			<div v-if="isHome">
				<p class="header-logo">
					ПоискКино
				</p>
			</div>
			<p 
				v-if="!isHome" 
				class="header-logo"
			>
				Избранное
			</p>
			<v-btn 
				v-if="!isHome"
				class="btn"
				@click="onClickToReturn()"
			> 
				Вернуться 
			</v-btn>
			<v-btn 
				class="btn" 
				@click="onClickSort('rating_max', state)"
			>
				По рейтингу
			</v-btn>
			<v-btn 
				class="btn" 
				@click="onClickSort('year_max', state)"
			>
				По дате выхода
			</v-btn>
			<v-btn 
				class="btn" 
				@click="onClickSort('length_max', state)"
			>
				По &#8595; длительности
			</v-btn>
			<v-btn 
				class="btn" 
				@click="onClickSort('length_min', state)"
			>
				По &#8593; длительности
			</v-btn>
			<v-btn
				v-if="isHome"
				class="btn"
				@click="onClickToFavorites()"
			>
				Перейти в избранные
			</v-btn>
			<slot v-if="isHome" />
		</div>
		<slot v-if="!isHome" />
	</header>
</template>

<script setup>
import { useMovieStore } from "../stores/MovieStore"
import { useRouter } from "vue-router"

const router = useRouter()
const movieStore = useMovieStore()
const props = defineProps({
	isHome: {
		type: Boolean,
		required: true,
		default: true,
	},
	state: {
		type: Object,
		required: true,
		default: () => {},
	},
})
const onClickSort = (flag, state) => {
	movieStore.sortedList(state, flag)
}
const onClickToReturn = () => {
	router.push({ name: 'home' })
}
const onClickToFavorites = () => {
	router.push({ name: 'favourites' })
}
</script>

<style scoped lang="sass">
@import "../assets/main.sass"
</style>
