# Congressional Record Processing

Run on any reasonably modern Apple machine:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install pdftohtml ruby git

git clone http://github.com/c4lliope/unpdf_congress.git
cd unpdf_congress

gem install bundler
bundle
```

```
mkdir compiled
# - - - run pdftohtml - - -
ruby process_records.rb
```
