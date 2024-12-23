import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  XFile? _videoFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _visibility = 'Public';

  Future<void> _pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoFile = video;
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  void _startUpload() {
    setState(() {
      _isUploading = true;
    });
    // Simulate upload progress
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _uploadProgress = 1.0;
        _isUploading = false;
      });
    });
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Center(
          child: _videoFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 50, color: Colors.grey[700]),
                    SizedBox(height: 10),
                    Text(
                      'Drag and drop video files to upload\nYour videos will be private until you publish them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: _pickVideo,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[600]!),
                      ),
                      child: Text('Select files',
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Center(
                      child: Text(
                        "Video Selected",
                        style: TextStyle(color: Colors.grey[800], fontSize: 16),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _videoFile = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Title (required)',
            labelStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 10),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildThumbnailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thumbnail',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            _thumbnailOption('Upload file', Icons.upload_file),
            SizedBox(width: 10),
            _thumbnailOption('Auto-generated', Icons.auto_awesome),
            SizedBox(width: 10),
            _thumbnailOption('Test & compare', Icons.compare),
          ],
        ),
      ],
    );
  }

  Widget _thumbnailOption(String label, IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey[700]),
            SizedBox(height: 5),
            Text(label,
                style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visibility',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          title: Text('Public', style: TextStyle(color: Colors.black)),
          value: 'Public',
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Private', style: TextStyle(color: Colors.black)),
          value: 'Private',
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Unlisted', style: TextStyle(color: Colors.black)),
          value: 'Unlisted',
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        if (_isUploading)
          LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
          ),
        if (_isUploading) SizedBox(height: 10),
        if (_isUploading)
          Text(
            'Uploading ${(_uploadProgress * 100).toInt()}%',
            style: TextStyle(color: Colors.grey[700]),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Video'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadArea(),
            SizedBox(height: 20),
            _buildProgressIndicator(),
            SizedBox(height: 20),
            Text('Details',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildDetailsSection(),
            SizedBox(height: 20),
            _buildThumbnailSection(),
            SizedBox(height: 20),
            _buildVisibilitySection(),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _videoFile != null ? _startUpload : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Upload', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
