import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/controller/book_Controller.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final BookController bookController = Get.find();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedGenre;

  File? _coverImage;
  File? _bookFile;

  final List<String> genres = [
    "Love",
    "Action",
    "Adventure",
    "Horror",
    "Fantasy",
    "Other",
  ];

  Future<void> _pickCoverImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image, 
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        if (await file.exists()) {
          setState(() {
            _coverImage = file;
          });
        } else {
          Get.snackbar("Error", "Selected file is not accessible");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to select image: $e");
    }
  }

  Future<void> _pickBookFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        if (await file.exists()) {
          setState(() {
            _bookFile = file;
          });
        } else {
          Get.snackbar("Error", "Selected file is not accessible");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to select PDF: $e");
    }
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      if (_coverImage == null || _bookFile == null) {
        Get.snackbar("Error", "Please select a cover image and a book file");
        return;
      }

   
      final success = await bookController.addBook(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        genre: _selectedGenre!,
        coverImage: _coverImage!,
        bookFile: _bookFile!,
      );

      if (success) {
        Navigator.pop(context); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
        backgroundColor: const Color(0xffF25C2B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Book Title",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Enter book title"
                              : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Enter description"
                              : null,
                ),
                const SizedBox(height: 16),

                // Genre Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  items:
                      genres
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() {
                        _selectedGenre = value;
                      }),
                  decoration: const InputDecoration(
                    labelText: "Genre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? "Select a genre" : null,
                ),
                const SizedBox(height: 16),

                // Cover Image Picker with error handling
                GestureDetector(
                  onTap: _pickCoverImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        _coverImage == null
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tap to add cover image",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _coverImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error, color: Colors.red),
                                        Text(
                                          "Image preview error",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),

                // Book File Picker
                ElevatedButton.icon(
                  onPressed: _pickBookFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(
                    _bookFile == null
                        ? "Upload Book (PDF)"
                        : "File: ${_bookFile!.path.split('/').last}",
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF25C2B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed:
                          bookController.isLoading.value ? null : _saveBook,
                      child:
                          bookController.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                              : const Text(
                                "Add Book",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
