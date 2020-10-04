# Congressional Record Processing

Run on any reasonably modern Apple machine:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install ruby git pdftohtml wget

git clone http://github.com/c4lliope/unpdf_congress.git
cd unpdf_congress

gem install bundler
bundle
```

```
# - - - `wget` a congressional record.
mkdir compiled
pdftohtml -c CREC-2020-10-01.pdf compiled/crec
ruby process_records.rb | less
```
