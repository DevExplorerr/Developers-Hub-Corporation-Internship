// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_explorer/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<dynamic> posts = [];
  List<dynamic> users = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? errorMessage;
  final Set<int> likedPosts = {};
  bool showScrollTop = false;

  final int limit = 5;
  int skip = 0;
  int totalPosts = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchPosts();

    _scrollController.addListener(() {
      // show/hide scroll to top button
      if (_scrollController.offset > 300 && !showScrollTop) {
        setState(() {
          showScrollTop = true;
        });
      } else if (_scrollController.offset <= 300 && showScrollTop) {
        setState(() {
          showScrollTop = false;
        });
      }

      //fetch more post
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          posts.length < totalPosts) {
        fetchMorePosts();
      }
    });
  }

  Future<void> fetchUsers() async {
    try {
      final usersUrl = Uri.parse("https://dummyjson.com/users");
      final response = await http.get(usersUrl);

      if (response.statusCode == 200) {
        final usersData = json.decode(response.body);
        setState(() {
          users = usersData["users"];
        });
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);

    try {
      final postsUrl = Uri.parse(
        "https://dummyjson.com/posts?limit=$limit&skip=$skip",
      );
      final response = await http.get(postsUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          posts = data["posts"];
          totalPosts = data["total"];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load posts";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  Future<void> fetchMorePosts() async {
    setState(() => isLoadingMore = true);

    try {
      skip += limit;
      final postsUrl = Uri.parse(
        "https://dummyjson.com/posts?limit=$limit&skip=$skip",
      );
      final response = await http.get(postsUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          posts.addAll(data["posts"]);
        });
      }
    } catch (e) {
      debugPrint("Error fetching more posts: $e");
    }

    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Posts",
          style: GoogleFonts.rubik(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length + (isLoadingMore ? 1 : 0),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),

                  itemBuilder: (context, index) {
                    if (index == posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }
                    final post = posts[index];
                    final userId = post["userId"];
                    final user = users.firstWhere(
                      (u) => u["id"] == userId,
                      orElse: () => null,
                    );
                    final isLiked = likedPosts.contains(post['id']);
                    int likeCount = isLiked
                        ? post['reactions']['likes'] + 1
                        : post['reactions']['likes'];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Info
                            if (user != null)
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                      user["image"],
                                    ),
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${user["firstName"]} ${user["lastName"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            // Post Title
                            Text(
                              post["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Post Body
                            Text(
                              post["body"],
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                color: AppColors.secondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Tags
                            if (post["tags"] != null)
                              Wrap(
                                spacing: 8,
                                children: (post["tags"] as List)
                                    .map(
                                      (tag) => Chip(
                                        label: Text(
                                          tag,
                                          style: GoogleFonts.lato(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                          ),
                                        ),
                                        backgroundColor: AppColors.background,
                                      ),
                                    )
                                    .toList(),
                              ),
                            const Divider(height: 20),

                            // Reactions Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isLiked) {
                                            likedPosts.remove(post['id']);
                                          } else {
                                            likedPosts.add(post['id']);
                                          }
                                        });
                                      },
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_outline_rounded,
                                        size: 18,
                                        color: isLiked
                                            ? Colors.red
                                            : AppColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "$likeCount",
                                      style: GoogleFonts.lato(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.comment,
                                      size: 18,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${post['userId']} Comments",
                                      style: GoogleFonts.lato(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    const Icon(
                                      Icons.visibility,
                                      size: 18,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${post['views']} Views",
                                      style: GoogleFonts.lato(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: showScrollTop
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              },
              child: const Icon(Icons.arrow_upward, color: AppColors.white),
            )
          : null,
    );
  }
}
