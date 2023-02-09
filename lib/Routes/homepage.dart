import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/bookmodels.dart';
import 'bookdetails.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final TextEditingController _controller = TextEditingController();
  String _searchText = 'flower';
  bool _isSearching = false;

  void _onSearch() {
    setState(() {
      _searchText = _controller.text;
      _isSearching = true;
    });
  }

  void _onCancelSearch() {
    setState(() {
      _controller.clear();
      _searchText = _searchText;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _controller,
                onSubmitted: (_) => _onSearch(),
                decoration: InputDecoration(
                  hintText: "Search book here...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: _onCancelSearch,
                  ),
                  border: InputBorder.none,
                ),
              )
            : const Text("BookSearch"),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _fetchBooks(_searchText),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Book>? books = snapshot.data;
            // print(books?.length);
            return ListView.builder(
              itemCount: books?.length,
              itemBuilder: (context, index) {
                Book book = books![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(book.thumbnail.toString()),
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.author.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 45, 17, 17),
                          ),
                        ),
                        Text(
                          book.publisher.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 45, 17, 17),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetails(book: book),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        },
      ),
    );
  }
}

//BookDetails

//Api call
Future<List<Book>> _fetchBooks(String query) async {
  final response = await http.get(Uri.parse(
      "https://www.googleapis.com/books/v1/volumes?q=$query&startIndex=1"));
  if (response.statusCode == 200) {
    List books = json.decode(response.body)['items'];
    return books.map((book) => Book.fromJson(book)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}
