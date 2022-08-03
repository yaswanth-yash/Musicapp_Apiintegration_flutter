// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/BLoC/internet_bloc/internet_bloc.dart';
import 'package:musicapp/BLoC/internet_bloc/internet_state.dart';
import 'package:musicapp/widgets/text.dart';

import '../BLoC/music_cubit_states.dart';
import '../BLoC/music_cubits.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<InternetBloc, InternetState>(
        listener: ((context, state) {
          if (state is InternetLostState) {
            print("connection lost");
          }
        }),
        builder: (context, state) {
          if (state is InternetLostState) {
            return Center(child: Text("No Internet Connection.."));
          } else if (state is InternetGainedState) {
            return MainScreen();
          } else {
            return Center(child: Text("Loading.."));
          }
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubits, CubitStates>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadedState) {
          return const TrendingScreen();
        }
        if (state is DetailState) {
          return DetailsScreen();
        } else {
          return Center(child: Text("Something went to wrong."));
        }
      },
    );
  }
}

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: 60,
            color: Colors.white,
            child: AppBar(
              elevation: 6.0,
              centerTitle: true,
              title: AppText(
                color: Colors.white,
                text: "Trending",
                size: 22,
                isBold: true,
              ),
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: BlocBuilder<MusicCubits, CubitStates>(
              builder: (context, state) {
                if (state is LoadedState) {
                  var info = state.tracks;
                  return ListView.builder(
                      itemCount: info.length.toInt(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<MusicCubits>(context)
                                .detailScreen(info[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10),
                            child: Container(
                              // color: Colors.greenAccent,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.greenAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.music_note_sharp,
                                      color: Colors.brown,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppText(
                                                text: info[index].track_name ??
                                                    " ",
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              AppText(
                                                  text:
                                                      info[index].album_name ??
                                                          " ",
                                                  size: 12),
                                            ],
                                          )),
                                      Container(
                                          width: 80,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppText(
                                                  text:
                                                      info[index].artist_name ??
                                                          "Hounds of Love",
                                                  size: 14),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              AppText(
                                                  text:
                                                      "Rating: ${info[index].track_rating.toString()}",
                                                  size: 14),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                      child: Text(
                    "Something is wrong...",
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
