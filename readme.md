# move

```bash
SOURCE_DIR=/Volumes/GoogleDrive-109131417520020270154/マイドライブ/family_photos/2015

SOURCE_DIR=~/work/tmp_org
be ruby change_20_files.rb ${SOURCE_DIR}

find ${SOURCE_DIR} -name .DS_Store

find ${SOURCE_DIR} -name .DS_Store | xargs --no-run-if-empty rm

find ${SOURCE_DIR} -name .DS_Store
```

# copy to tmp dir

```bash
mkdir -p ~/work/tmp
pushd ~/work/tmp

rm -f *.*
rm -f .DS_Store

find ${SOURCE_DIR} -type f -print0 | xargs -0 cp -i -t ./

popd
```

# change timestamp

```bash
be ruby chtime_by_fname.rb ~/work/tmp
```

# diff Check

diff -r {/Volumes/GoogleDrive-109131417520020270154/マイドライブ/family_docs/,~/Dropbox/data/doc/}2014_family_docs

diff -r {/Volumes/GoogleDrive-109131417520020270154/マイドライブ/family_photos/,~/Dropbox/Photo/}2016

# for movies

```bash
mkdir -p ~/work/movies_tmp
cd ~/work/movies_tmp

rm -f '*.*'
rm -f .DS_Store


find ~/work/movies -name .DS_Store | xargs --no-run-if-empty rm
find ~/work/movies -name .HashTable.xml | xargs --no-run-if-empty rm
find ~/work/movies -type f -print0 | xargs -0 cp -p -i -t ./

```
