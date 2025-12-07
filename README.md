# Tunepal

Tunepal is an app for finding the names of Tunes and organizing Tunes for learning purposes.

## Original Author & Acknowledgments

**Tunepal was created by [Dr. Bryan Duggan](https://bryanduggan.org/)**, a lecturer in Computer Science at TU Dublin, flute player, and inventor. Tunepal was his PhD research topic and has served the traditional Irish music community faithfully since 2009, with around 100,000 lifetime users who have performed millions of tune searches.

This Godot-based rebuild (Tunepal Nua) represents Bryan's vision for a modern, cross-platform, open-source version of Tunepal that works offline and is free for all traditional musicians.

### A Note from a Fellow Trad Musician

As a traditional musician myself, I want to express my deep gratitude to Bryan for creating Tunepal. This tool has helped countless musicians—including me—identify tunes heard at sessions, learn new repertoire, and connect with our musical heritage. This contribution is a labor of love for both Bryan's original vision and for the traditional music community that Tunepal has served so well.

*Go raibh míle maith agat, Bryan!*

### Contributors

- **Bryan Duggan** ([@skooter500](https://github.com/skooter500)) - Original creator and lead developer
- DevinDaley
- masonhill920
- Lukas

### Resources

- **Bryan's Blog**: [Tunepal being rebuilt in Godot](https://bryanduggan.org/2024/04/01/new-tunepal-using-godot/)
- **Tunepal Nua Announcement**: [Launch at Willie Clancy 2025](https://bryanduggan.org/2025/03/31/tunepal-nua-to-launch-this-summer/)
- **Upstream Repository**: [github.com/skooter500/TunepalGodot](https://github.com/skooter500/TunepalGodot)
- **Original Tunepal**: [tunepal.org](https://tunepal.org) | [App Store](https://apps.apple.com/ie/app/tunepal/id356935033)
- **The Session Discussion**: [Tunepal on The Session](https://thesession.org/discussions/49580)

--- 

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

## Development Status

### What's Working

| Feature | Status | Notes |
|---------|--------|-------|
| Audio recording | ✅ Working | Real-time microphone capture |
| Frequency analysis | ✅ Working | Spectrum analysis for note detection |
| Note recognition | ✅ Working | 68-frequency range (B123-B880 Hz) |
| ABC string generation | ✅ Working | Converts detected notes to searchable pattern |
| Edit distance search | ✅ Working | C++ GDExtension for fast substring matching |
| Multi-threaded search | ✅ Working | Uses all available CPU cores |
| Keyword search | ✅ Working | Text-based tune filtering |
| SQLite database | ✅ Working | 48MB embedded tune database |
| Menu navigation | ✅ Working | Record, Keywords, My Tunes, Preferences |

### What's In Progress

| Feature | Status | Notes |
|---------|--------|-------|
| iOS build | 🔧 Ready | GDExtension configured, needs macOS to compile |
| Score visualization | ❌ Not started | Planned: ABCJS integration |
| Playback | ❌ Not started | MIDI addon included but not wired up |
| My Tunes persistence | ❌ Not started | UI exists, needs local storage |
| Cloud sync | ❌ Not started | Future feature |

### Platform Support

| Platform | Extension | Export | Tested |
|----------|-----------|--------|--------|
| iOS (arm64) | ✅ Configured | ✅ Template ready | ❌ Needs TestFlight |
| Android (arm64) | ✅ Built | ✅ Template ready | ⚠️ Partially |
| Windows (x64) | ✅ Built | ✅ Works | ✅ Yes |
| macOS | ✅ Configured | ✅ Configured | ❌ Needs testing |
| Linux (x64) | ✅ Built | ✅ Works | ✅ Yes |
| Web (WASM) | ✅ Configured | ❌ Not tested | ❌ |

### Recent Additions (This Fork)

This fork adds infrastructure to support iOS development as the MVP target:

- **iOS Configuration**: Added iOS entries to `tunepal.gdextension` and export presets with microphone permissions
- **CI/CD Pipeline**: GitHub Actions workflow builds for all platforms (Linux, Windows, macOS, iOS, Android)
- **Test Infrastructure**: GDScript test suite for the edit distance algorithm with CI integration
- **Documentation**: Enhanced README, added CONTRIBUTING.md, LICENSE file
- **SessionStart Hook**: Auto-installs Godot 4.3 for Claude Code development sessions

### Test Coverage

The project includes automated tests that run in CI on every push and pull request.

#### What's Tested

| Component | Coverage | Test File |
|-----------|----------|-----------|
| Edit distance algorithm | ✅ Tested | `Scripts/test_tunepal.gd` |
| Exact substring match | ✅ Tested | 13 test cases |
| Insertion/deletion/substitution | ✅ Tested | Edge cases covered |
| Empty string handling | ✅ Tested | Both pattern and text |
| ABC notation patterns | ✅ Tested | Real tune-style patterns |

#### Not Yet Tested (Integration Tests Needed)

| Component | Priority | Notes |
|-----------|----------|-------|
| Audio recording | High | Requires device/mock |
| Frequency analysis | High | Signal processing logic |
| Note recognition | High | `record.gd:110-204` |
| Note grouping | Medium | `record.gd:304-333` |
| ABC string generation | Medium | `record.gd:335-344` |
| Multi-threaded search | Medium | `record.gd:346-355` |
| SQLite queries | Low | Database operations |
| Menu navigation | Low | UI logic |

#### Running Tests

**In Godot Editor:**
```bash
# Open test scene and press F6
TunepalGodot/Scenes/test_tunepal.tscn
```

**Command Line (headless):**
```bash
cd TunepalGodot
godot --headless --script Scripts/test_tunepal.gd --quit
```

**CI Pipeline:**
Tests run automatically via GitHub Actions on Linux after building the extension.

### Building

```bash
# Initialize submodules (required first time)
git submodule update --init --recursive

# Build for your platform
scons platform=linux target=template_debug -j4
scons platform=ios target=template_debug arch=arm64 -j4  # Requires macOS
scons platform=android target=template_debug arch=arm64 -j4
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed setup instructions.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

The MIT License was chosen to align with Bryan Duggan's stated intent for Tunepal Nua to be "free and open-source" and to match the permissive licensing of the project's dependencies.