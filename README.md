```sh
repo init -u https://github.com/PerfectLaugh/android-kernel.git -m $DEVICE/default.xml && repo sync -j8
sh ./modify_aosp.sh
"./build_$DEVICE.sh" --kernel_package=@//aosp --config=no_download_gki --config=no_download_gki_fips140
```

Final products in `out/$DEVICE/dist`