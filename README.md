# Tunepal

Tunepal is an app for finding the names of Tunes and organizing Tunes for learning purposes. It was developed by Bryan Duggan and others. 

This goal of this project is to create a new, modern Tunepal that solves a number of problems with the original, while providing a platform for future development and research.

The plan is to rebuild Tunepal from the ground up using Godot for its cross platform capabilities and and support for extensions in different languages.

The new Tunepal:

- One project for all platforms: Android, IOS and Web
- Support for different screen sizes including tablets
- Fast, off-line searches, running on device
- Better accuracy
- Updated corpus with the latest available transcriptions to ABC of the classic sources.
- Interactive music scores with playback, repeat sections and slowdown
- Support for full range of instruments, sessions and recordings
- Import new sources
- Europeana sounds integration - connection to the Comhaltas archive, ITMA and other sources
- Backup Tunebooks in the cloud and share across devices
- Share Tunes and sets with other users
- Integration with thesession.org
- Platform for future research and development
- Free and open-source

The current prototype:

- sqlite.db database of tunes embedded into the app
- EditDistance is in C++ as a GDExtension
- Search by playing works but is slow
- Compiles for Windows

These are the broad tasks!

- Searching by playing performance improvements. Needs to take a few seconds max
- Score visualization. Probably this will use ABCJS. We will need a way to render a local html page in Godot via a "WebView" type of node.
- Playback. This can use abc2midi and [Godot MIDI Player](https://godotengine.org/asset-library/asset/1667)
- Local tune management