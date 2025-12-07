# Audio Playback Setup

Tunepal uses SoundFont (.sf2) files for MIDI playback through the Godot MIDI Player addon.

## Current Status

The MIDI playback infrastructure exists but is not yet wired up:
- **Godot MIDI Player addon**: Installed at `TunepalGodot/addons/midi/`
- **SoundFont support**: Full SF2 loading and playback capability
- **Database MIDI data**: Tunes include `midi_sequence` fields for playback
- **SoundFont files**: Not yet included (this document explains how to add them)

## Recommended SoundFonts

Target size: ~25 MB total for all instruments

### Required Downloads

| Instrument | SoundFont | Size | License | Download |
|------------|-----------|------|---------|----------|
| Tin Whistle, Bodhrán, Celtic Harp | Ancient Instruments of the World | ~7 MB | Free | [Polyphone.io](https://www.polyphone.io/en/soundfonts/soundscapes/530-ancient-instruments-of-the-world) |
| Bombarde, Biniou, Bagpipes | celtix.sf2 | ~2 MB | Public Domain | [Musical Artifacts](https://musical-artifacts.com/artifacts/369) |
| Acoustic Guitar | FS Seagull Steel String | ~5 MB | GPL v3 | [FreePats](https://freepats.zenvoid.org/Guitar/steel-acoustic-guitar.html) |
| Piano | GrandP_Eur | ~6 MB | Free | [Soundfonts4U](https://sites.google.com/site/soundfonts4u/) |
| Violin (placeholder) | Arianna's Violin | ~3 MB | Free | [Polyphone.io](https://www.polyphone.io/en/soundfonts/bowed-strings/434-arianna-s-violin) |
| Banjo | FS Kay 5-String | ~2 MB | Free | [FlameStudios](http://flamestudios.org) |

### Installation

1. Create the soundfonts directory:
   ```bash
   mkdir -p TunepalGodot/data/soundfonts
   ```

2. Download each SoundFont from the links above

3. Place the `.sf2` files in `TunepalGodot/data/soundfonts/`:
   ```
   TunepalGodot/data/soundfonts/
   ├── ancient_instruments.sf2
   ├── celtix.sf2
   ├── guitar_steel.sf2
   ├── piano.sf2
   ├── violin.sf2
   └── banjo.sf2
   ```

## Known Limitations

### Instruments That Need Better Samples

| Instrument | Issue | Ideal Solution |
|------------|-------|----------------|
| **Irish Fiddle** | No Celtic/folk fiddle SF2 exists; using classical violin as placeholder | Record real Irish fiddle samples |
| **Irish Flute** | No wooden transverse flute SF2; tin whistle is closest available | Record real Irish flute samples |
| **Button Accordion** | Only basic diatonic options available | Record real Irish button accordion |

These instruments sound "classical" rather than having the characteristic ornamentation and tone of Irish traditional music. The tin whistle sample is authentic, but fiddle and flute will need custom samples for proper traditional sound.

### Creating Custom Samples

If you have recording equipment and can play the instrument:

1. Record single sustained notes across the full range (at least every minor third)
2. Record at multiple velocity levels (soft, medium, loud)
3. Use a tool like [Polyphone](https://www.polyphone.io/) to create an SF2
4. Consider contributing back to the open source SoundFont community!

## Wiring Up Playback (TODO)

The playback system needs to be implemented:

1. Load SoundFont on app startup
2. Convert ABC notation or MIDI sequence to playable format
3. Add play/pause/stop controls to tune display
4. Support tempo adjustment and looping sections

See `TunepalGodot/addons/midi/readme.md` for the MIDI Player API documentation.

## File Size Considerations

The app already includes a 48 MB tune database. Adding 25 MB of SoundFonts brings the total to ~75 MB, which is acceptable for a mobile app with offline functionality.

For comparison:
- FluidR3 GM (full General MIDI): 148 MB - too large
- Our curated set: ~25 MB - good balance of quality and size
