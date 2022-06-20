# Automatically anonymously download your albums
Installs and configures headphones, tribler, picard (and beets) to make sure your albums are downloaded anonymously and automatically.

## Usage
Clone this repository, cd into it with terminal and type:
```
chmod +x setup.sh
./setup.sh --config --install --runboot --beets --headphones --picard --tribler
```
to install, configure and run the 4 services automatically when you boot up your device.
Then in browser goto: http://localhost:8181/ and select your open source albums.

## Description
Headphones stores torrent to:`target_blackhole`.
Tribler monitors the black hole/watch folder: `target_blackhole` and loads each torrent that comes in there.
Once Tribler completes a download it is stored into: `~/Downloads/TriblerDownloads`.
TODO: Make tribler copy a download to: `~/Music/TriblerOutput` once it is done downloading.
TODO: Make tribler remove a download from: `~/Downloads/TriblerDownloads` once a sufficient seeding ratio is reached.
Verify: Headphones monitors `~/Downloads/TriblerDownloads` for complete downloads.
TODO: Headphones does recognise the album in `Manage>scan directory` but it did not find it by itself automatically. Ensure it does find it automatically.
TODO: Use the `Config>Advanced Settings>Post Processing Temporary Directory` to: `/home/name/Music/Library/Headphones/PostProcessing`.
TODO: Headphones - Change move into copy by selecting: "Settings>Quality & Post Porcessing" Keep original folder".
Verify: Once Headphones detects a completed download, it should COPY it to: `/home/name/Music/Library/Headphones`.
Verify: Once Headphones detects a completed download, it should COPY it to: `/home/name/Music/Library/Headphones/lossless`.
TODO: Once Headphones detects a completed download, it should COPY it to: `~/Music/HeadphonesOutput`
Verify: Make picard monitor: `/home/name/Music/Library/Headphones` and post-process the outptu to: `/home/name/Music/Library/Picard`
(Note this only works manually, because the user has to click: "save")
Also, after deleting the picard.db and the album X files from picard, it seems like it remembers it already has the meta data of some album X.
Approximate command:
```
picard ~/Music/Library/Headphones/
```
TODO: Automatically run beets on the Headphones output dir. (TODO: change to Picard output dir)
beet import --write --autotag --quiet ~/Music/Library/Headphones/
#beet import --write --autotag  ~/Music/Library/Headphones/




