import 'dart:async';
import 'dart:io';

import 'package:PhotoFilters/screens/result_screen.dart';
import 'package:PhotoFilters/services/filtered_image_converter.dart';
import 'package:PhotoFilters/services/liquid_swipe_pages.dart';
import 'package:PhotoFilters/utilities/filters.dart';
import 'package:PhotoFilters/utilities/show_error_dialog.dart';
import 'package:PhotoFilters/widgets/circular_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:liquid_swipe/liquid_swipe.dart';

class OriginalSizePhotoScreen extends StatefulWidget {
  final File imageFile;
  OriginalSizePhotoScreen(this.imageFile);
  @override
  _OriginalSizePhotoScreenState createState() =>
      _OriginalSizePhotoScreenState();
}

class _OriginalSizePhotoScreenState extends State<OriginalSizePhotoScreen> {
  final GlobalKey _globalKey = GlobalKey();
  String _filterTitle = '';
  bool _newFilterTitle = false;
  // PageController _pageController = PageController();
  int _selectedFilterIndex = 0;
  bool _isLoading = false;
  LiquidController _liquidController = LiquidController();

  final _formKey = GlobalKey<FormState>();

  Size _screenSize;
  List<Container> _filterPages;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _screenSize = MediaQuery.of(context).size;
      _filterPages = LiquidSwipePagesService.getImageFilteredPaged(
          imageFile: widget.imageFile,
          height: _screenSize.height,
          width: _screenSize.width);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                child: LiquidSwipe(
                  pages: _filterPages,
                  onPageChangeCallback: (value) {
                    setState(() => _selectedFilterIndex = value);
                    _setFilterTitle(value);
                  },
                  waveType: WaveType.liquidReveal,
                  liquidController: _liquidController,
                  ignoreUserGestureWhileAnimating: true,
                  enableLoop: true,
                ),
              ),
            ),
          ),
          if (_newFilterTitle)
            // displays filter title once filtered changed
            _displayStoryTitle(),

          if (_isLoading)
            // desplays circular indicator if posting story
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),

          // displays row of buttons on top of the screen
          if (!_isLoading) _displayEditStoryButtons(),

          // displays post buttons on bottom of the screen
          if (!_isLoading) _displayBottomButtons(),
        ],
      ),
    );
  }

  Align _displayEditStoryButtons() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularIconButton(
              backColor: Colors.black26,
              splashColor: Colors.blue.withOpacity(0.5),
              icon: Icon(
                Icons.close_sharp,
                color: Colors.white,
                size: 22,
              ),
              onTap: () => Navigator.pop(context),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _selectedFilterIndex != 0
                      // if current filter is not the first filter (no filter)
                      ? CircularIconButton(
                          padding: const EdgeInsets.only(right: 8),
                          backColor: _selectedFilterIndex != 0
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.black26,
                          splashColor: _selectedFilterIndex != 0
                              ? Colors.black26
                              : Colors.blue.withOpacity(0.5),
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 22,
                          ),
                          onTap: () {
                            _liquidController.jumpToPage(page: 0);
                          },
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setFilterTitle(title) {
    setState(() {
      _filterTitle = filters[title].name;
      _newFilterTitle = true;
    });
    Timer(Duration(milliseconds: 1000), () {
      if (_filterTitle == filters[title].name) {
        setState(() => _newFilterTitle = false);
      }
    });
  }

  Align _displayBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () => _savePhoto(),
        color: Colors.black26,
        child: Text(
          'Save',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Align _displayStoryTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        _filterTitle,
        style: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  void _savePhoto() async {
    if (!_isLoading && widget.imageFile != null) {
      setState(() => _isLoading = true);
      File imageFile =
          await FilteredImageConverter.convert(globalKey: _globalKey);
      if (imageFile == null) {
        ShowErrorDialog.showAlertDialog(
            errorMessage: 'Could not convert image.', context: context);
        return;
      }

      setState(() => _isLoading == false);

      //navigate
      Navigator.of(_globalKey.currentContext).push(
        MaterialPageRoute(
          builder: (context) => ResultPhotoScreen(
            filterTitle: filters[_selectedFilterIndex].name,
            imageFile: imageFile,
          ),
        ),
      );
    }
  }
}
