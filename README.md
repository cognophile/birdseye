# Birdseye
Sometimes it's a pain to have to run a multitude of git commands before working to get an overview of the repository state. I wrote this script to give me a birdseye view of a repository.

![Birdseye tool](https://srcnote.files.wordpress.com/2019/04/screenshot-2019-04-04-at-23.31.33.png?w=2484)

## How do I use it?
- Download the script and store it where you please. I recommend adding it to a location on your `$PATH` for maximum accessibility.
- Make sure you grant your user execution permission: `chmod u+x birdseye.sh`
- All that's left is to run the script from within a valid git repository!

## Runtime options
- `birdseye.sh [ -h | --help ]`: display the help message
- `birdseye.sh [ -i | --info ]`: display the informational message
- `birdseye.sh [ -v | --version ]`: display the current version

## Contributing
Check out [the contribution guidelines](https://github.com/cognophile/birdseye/blob/master/CONTRIBUTING.md).
