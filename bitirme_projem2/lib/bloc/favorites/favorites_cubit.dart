import 'package:flutter_bloc/flutter_bloc.dart';

part "favorites_state.dart";

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(super.initialState);

  addToFavorites(
      {required int id,
      required String photo,
      required String title,
      required String artist}) {
    var suankiMuzikler = state.favoritesMusic;

    if (suankiMuzikler.any((element) => element["id"] == id)) {
      // Zaten ekliyse favorilere tekrar ekleme yapmaması için boş
    } else {
      suankiMuzikler.add({
        "id": id,
        "photo": photo,
        "title": title,
        "artist": artist,
      });
    }

    final newState = FavoritesState(
      favoritesMusic: suankiMuzikler,
    );

    emit(newState);
  }
  
  removeFromFavorites({required int id}) {
    var suankiMuzikler = state.favoritesMusic;

    suankiMuzikler.removeWhere((element) => element["id"] == id);

    final newState = FavoritesState(
      favoritesMusic: suankiMuzikler,
    );

    emit(newState);
  }
}
