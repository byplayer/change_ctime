# copy to tmp dir

```bash
mkdir -p ~/work/tmp
cd ~/work/tmp

find /Volumes/GoogleDrive-109131417520020270154/マイドライブ/family_photos/2001 -type f -print0 | xargs -0 cp -i -t ./
```

# change timestamp

```bash
ruby chtime_by_fname.rb ~/work/tmp
```
