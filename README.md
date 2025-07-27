```sh
repo init -u https://github.com/PerfectLaugh/android-kernel.git -m $DEVICE/default.xml && repo sync -j8
sh ./modify_aosp.sh
```

and build artifacts with

```sh
"./build_$DEVICE.sh" --kernel_package=@//aosp --config=no_download_gki --config=no_download_gki_fips140
```

or 

```sh
"./build_$DEVICE".sh --config=use_source_tree_aosp
```

Final products in `out/$DEVICE/dist`
