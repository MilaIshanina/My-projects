<template>
	<div 
		v-if="!isOnlyCard" 
		class="movie"
	>
		<div class="movie-cover-inner">
			<img
				:src="movie.poster.previewUrl"
				:alt="movie.name"
				class="movie-cover"
			>
			<div 
				:class="{ 'movie-cover-darkened': !isFavourite }"
			>
			</div>
		</div>
		<div class="movie-info" :class="{ 'movie-info-fav': isFavourite }">
			<p class="movie-name">
				{{ movie.name }}
			</p>
			<div class="movie-year">
				{{ movie.year }}
			</div>
			<div
				:class="
					'movie-average movie-average--' + getClassByRate(movie.rating.kp)
				"
			>
				{{ movie.rating.kp.toFixed(1) }}
			</div>
			<div v-if="isFavourite">
				<div 
					v-if="movie.ratingUser" 
					class="score"
				>
					Ваша оценка: {{ movie.ratingUser }}
				</div>
				<div v-else class="score">
					Оценка отсутствует
				</div>
				<div class="movie-buttons">
					<v-btn
						v-if="movie.isSelected"
						class="btn btn-special"
						@click="onClickToggleSelected(movie.id)"
					>
						&#10006; избранное
					</v-btn>
					<v-btn
						v-if="movie.ratingUser"
						class="btn btn-special"
						@click="onClickToggleRating(movie.id, 0)"
					>
						&#10006; оценку
					</v-btn>
				</div>
			</div>
		</div>
	</div>
	<div v-else>
		<v-btn 
			class="btn btn-home" 
			@click="router.push({ name: 'home' })"
		>
			Вернуться
		</v-btn>
		<div class="movie-card">
			<img
				:src="movie.poster.previewUrl"
				:alt="movie.name"
				class="movie-card-backdrop"
			>
			<h2>{{ movie.name }} - {{ movie.year }}</h2>
			<ul class="movie-card-info">
				<li>Время: {{ movie.movieLength }} минут</li>
				<li>Описание: {{ movie.description }}</li>
				<p>Ваша оценка:</p>
				<div 
					v-if="movie.ratingUser" 
					class="score"
				>
					{{ movie.ratingUser }}
				</div>
			</ul>
			<form class="movie-card-form">
				<v-radio-group v-model="movieRating" inline class="radio">
					<v-radio
						id="choice1"
						value="1"
						name="score"
						color="red"
						class="one"
					/>
					<v-radio
						id="choice2"
						value="2"
						name="score"
						color="orange"
						class="two"
					/>
					<v-radio
						id="choice3"
						value="3"
						name="score"
						color="yellow"
						class="three"
					/>
					<v-radio
						id="choice4"
						value="4"
						name="score"
						color="#20B2AA"
						class="four"
					/>
					<v-radio
						id="choice5"
						value="5"
						name="score"
						color="success"
						class="five"
					/>
				</v-radio-group>
				<v-btn 
					class="btn" 
					@click="onClickToggleRating(movie.id, movieRating)"
				>
					Добавить оценку
				</v-btn>
				<v-btn
					v-if="movie.ratingUser"
					class="btn"
					@click="onClickToggleRating(movie.id, 0)"
				>
					Удалить оценку
				</v-btn>
				<v-btn
					class="btn" 
					@click="onClickToggleSelected(movie.id)"
				>
					{{ movie.isSelected ? "Удалить избранное" : "В избранное" }}
				</v-btn>
			</form>
			<p class="header-logo" style="font-size: 20px">
				Рекомендуем также посмотреть:
			</p>
			<div class="container movies">
				<div
					v-for="recommendation in movieStore.similarMovies(
						movie.id,
						movie.year
					)"
					:key="recommendation.id"
					style="margin-bottom: 15px; cursor: pointer"
				>
					<div class="movie-cover-inner special-rec">
						<img
							:src="recommendation.poster.previewUrl"
							:alt="recommendation.name"
							class="movie-cover"
							@click="onClickToOtherFilm(recommendation)"
						>
						<div>{{ recommendation.name }}</div>
						<div>({{ recommendation.year }})</div>
					</div>
				</div>
				<div 
					v-if="!movieStore.similarMovies(movie.id, movie.year).length"
				>
					К сожалению, похожие фильмы не нашлись в нашей базе :(
				</div>
			</div>
		</div>
	</div>
</template>

<script setup>
import { useMovieStore } from "../stores/MovieStore"
import { useRouter } from "vue-router"
import { ref } from "vue"

const movieStore = useMovieStore()
const router = useRouter()
const props = defineProps({
	movie: {
		type: Object,
		required: true,
		default: () => {},
	},
	isOnlyCard: {
		type: Boolean,
		required: false,
		default: false,
	},
	isFavourite: {
		type: Boolean,
		required: false,
		default: false,
	},
})

const onClickToOtherFilm = (recommendation) => {
  router.push({
    name: 'moviecard',
    params: { id: recommendation.id },
  });
  window.scrollTo({ top: 0, behavior: "smooth" });
}
const onClickToggleRating = (id, rating) => {
	movieStore.toggleRating(id, rating)
}
const onClickToggleSelected = id => {
	movieStore.toggleSelected(id)
}
const movieRating = ref(props.movie?.ratingUser)
const getClassByRate = vote => {
	if (vote >= 7) {
		return "green"
	} else if (vote > 5) {
		return "orange"
	} else if (vote === null) {
		return "blue"
	} else {
		return "red"
	}
}
</script>

<style scoped lang="sass">
@import "../assets/main.sass"
</style>
