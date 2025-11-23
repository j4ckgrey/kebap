import 'package:kebap/models/item_base_model.dart';

class FavouritesModel {
  final bool loading;
  final Map<KebapItemType, List<ItemBaseModel>> favourites;
  final List<ItemBaseModel> people;

  FavouritesModel({
    this.loading = false,
    this.favourites = const {},
    this.people = const [],
  });

  FavouritesModel copyWith({
    bool? loading,
    String? searchQuery,
    Map<KebapItemType, List<ItemBaseModel>>? favourites,
    List<ItemBaseModel>? people,
  }) {
    return FavouritesModel(
      loading: loading ?? this.loading,
      favourites: favourites ?? this.favourites,
      people: people ?? this.people,
    );
  }
}
