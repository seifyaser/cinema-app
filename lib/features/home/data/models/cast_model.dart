class CastModel {
  final String image;
  final String name;
  final String role;

  CastModel({required this.image, required this.name, required this.role});
}

final List<CastModel> mockCast = [
  CastModel(
    image:
        "https://assets.voxcinemas.com/posters/P_HO00013128_1778076059712.jpg",
    name: "Brad Pitt",
    role: "Sonny Hayes",
  ),
  CastModel(
    image:
        "https://assets.voxcinemas.com/posters/P_HO00013128_1778076059712.jpg",
    name: "Kerry Condon",
    role: "Kate",
  ),
  CastModel(
    image:
        "https://assets.voxcinemas.com/posters/P_HO00013128_1778076059712.jpg",
    name: "Damson Idris",
    role: "Joshua",
  ),
];
