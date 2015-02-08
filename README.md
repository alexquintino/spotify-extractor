spotify-extractor
=================

Simple utility to extract/backup a user's playlist tracks into plain text using Spotify's API.
It currently works for public playlists only

Usage
-----

After giving execution permissions to **spotify-extractor** with:
```bash
chmod +x bin/spotify-extractor
```

###Simple
```bash
./bin/spotify-extractor -u "[user_id]" --clientid "[client_id]" --clientsecret "[client_secret]"
```

###Artists only
```bash
./bin/spotify-extractor -u "[user_id]" --clientid "[client_id]" --clientsecret "[client_secret] --artists"
```

###JSON format
```bash
./bin/spotify-extractor -u "[user_id]" --clientid "[client_id]" --clientsecret "[client_secret] --artists"
```

Output
------
**spotify-extractor** will create a file in a folder *output* for each playlist.

Get your client_id and client_secret at [Spotify Developer](https://developer.spotify.com/my-applications)

(Work in Progress)
