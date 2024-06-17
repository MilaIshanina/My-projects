import { defineStore } from "pinia";
import data1 from "../json/kinopoisk-1.json";
import {ref, computed, watch} from "vue";

export const useMovieStore = defineStore("movieStore", () => {
  const movies = ref(data1.docs);
  const moviesInLS = ref([]);
  const isSelected = ref(false);
  const ratingUser = ref(0);
  const moviesInLocalStorage = localStorage.getItem('moviesInLS');
  if (moviesInLocalStorage) {
		moviesInLS.value = JSON.parse(moviesInLocalStorage)._value
	}
  watch(
		() => moviesInLS,
		state => {
			localStorage.setItem('moviesInLS', JSON.stringify(state))
		},
		{ deep: true }
	)
  const selectedMovies = computed(() => {
    return moviesInLS.value.filter(el => el.isSelected)
  });
  const ratingMovies = computed(() =>  {
    return moviesInLS.value.filter(el => el.ratingUser)
  });
  const favouritesMovies = computed (() => {
    return moviesInLS.value.filter(el => el.isSelected || el.ratingUser)
  })
  const similarMovies = (id, year) => {
    return movies.value.filter((el) => (el.id !== id && (el.year === year || el.year === (year+1))));
  }
  const totalCountMovies = computed(() => {
    return movies.value.length;
  });
  const toggleRating = (id, score) => {
    const movie = movies.value.find((el) => el.id === id);
    if (!moviesInLS.value.find(el => el.id === id)){
          movie.ratingUser = score
          moviesInLS.value.push(movie)
					console.log(moviesInLS)
    }
    else{
      const movie = moviesInLS.value.find(el => el.id === id)
			movie.ratingUser = score
    }
  };
  const toggleSelected = (id) => {
    const movie = movies.value.find((el) => el.id === id);
    if (!moviesInLS.value.find(el => el.id === id)) {
      movie.isSelected = !movie.isSelected
			moviesInLS.value.push(movie)
			console.log(moviesInLS)
		} else {
			const movie = moviesInLS.value.find(el => el.id === id)
			movie.isSelected = !movie.isSelected
		}
  };
  const searchMovie = (id) => {
    const movie = moviesInLS.value.filter(el => el.isSelected || el.ratingUser)
    console.log(movie.find(el => Number(el.id) === Number(id)))
    if (movie.find(el => Number(el.id) === Number(id))) {
			return moviesInLS.value.find(function (item) {
				return Number(item.id) === Number(id)
			})
		} else {
			return movies.value.find(function (item) {
				return Number(item.id) === Number(id)
			})
		}
  };
  const nextPage = (state, movieInp) => {
    if (state.page.value !== Math.ceil(state.data.length / state.perPage)) {
      if (state.page.value !== Math.ceil(state.data.filter((m) => m.name.toUpperCase().indexOf(movieInp) !== -1).length / state.perPage))
        return state.page.value += 1;
    }
  };
  const backPage = (state) => {
    if (state.page.value !== 1) {
      return state.page.value -= 1;
    }
  };
  const goToPage = (state, numPage) => {
    return state.page.value = numPage;
  };
  const sortedList = (state, flag) => {
    switch (flag) {
      case "rating_max":
        return state.data.sort(ratingMaxComparator);
      case "year_max":
        return state.data.sort(yearMaxComparator);
      case "length_min":
        return state.data.sort(lengthMinComparator);
      case "length_max":
        return state.data.sort(lengthMaxComparator);
    }
  };
  const yearMaxComparator = (d1, d2) => d2.year - d1.year;
  const ratingMaxComparator = (d1, d2) => d2.rating.kp - d1.rating.kp;
  const lengthMinComparator = (d1, d2) => d1.movieLength - d2.movieLength;
  const lengthMaxComparator = (d1, d2) => d2.movieLength - d1.movieLength;
  return{
    movies, moviesInLS, isSelected, ratingUser, selectedMovies, ratingMovies,  totalCountMovies,
    toggleRating, toggleSelected, searchMovie, favouritesMovies, similarMovies, nextPage, backPage, goToPage, sortedList
  }
})