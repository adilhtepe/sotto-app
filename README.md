# sotto

Plays a VBAN stream on any sound device, or sends any sound device as a VBAN stream, on Windows,
macOS and Linux. It is part of the **Sotto** project and uses `sotto-sdk` as a submodule. On macOS and
Windows, the Sotto virtual sound cards (`sotto-macos`, `sotto-windows`) appear as ordinary devices
to pick with `-d`.

```bash
git clone --recursive <url of sotto-app>
cmake -S sotto-app -B build && cmake --build build
build/sotto devices                                    # list devices
build/sotto play -n Mix -d "Speakers"                  # VBAN -> a device
build/sotto send -i 192.168.2.1 -n Desk -d "Sotto Out" # a device -> VBAN
build/sotto play -n Mix --hub studio.example.net --ca ca.crt --cert me.crt --key me.key   # secure, over the internet
```
Options: `-n` stream name, `-p` port, `-d` device (part of its name), `-c` channels, `-l` initial
buffering (ms), `-r`, `-b`, `-f` for sending, `--null` for a silent paced device, `--seconds n` to
stop after n seconds. For secure VBAN, add `--ca`, `--cert`, `--key` and optionally `--hub`.

**How it works.** Audio runs in the device callback:
- `play` pulls from the SDK's lock-free jitter buffer (no lock, no allocation);
- `send` pushes into a lock-free ring that the network thread drains every millisecond.

Sockets and encryption never run on the audio thread. Devices come from
[miniaudio](https://miniaud.io): WASAPI, CoreAudio, ALSA, PulseAudio and JACK.

**Tests.**
- `smoke.sh` runs on every OS in CI: null device, real UDP.
- `vm-test.sh` plays and records real-time ALSA devices (`snd-aloop`) in a throwaway VM. Both
  directions carry a clean 440 Hz tone.

## Thanks
This is part of **Sotto** (the `sotto` repository links all of its repositories). VBAN is the
protocol of VB-Audio Software; Sotto is an independent implementation, not affiliated with
VB-Audio. The full list of sources and thanks (reference implementations, Monocypher, miniaudio,
Scream, Noise, the cacophony test vectors and the tools) is in the `sotto` repository's
ACKNOWLEDGEMENTS.md.
