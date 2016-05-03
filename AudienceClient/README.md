# MSL Audience Client

## Dependency List

All dependencies can be downloaded from 

```
libqt4-dev
libvtk5-qt4-dev
libqjson-dev
libxerces-c-dev
xsdcxx
```

## Building

```
cd build
cmake ..
make
```

## Running

Environment variable `LC_NUMERIC` must be set to `C` in order for OBJ models to load correctly.

```
LC_NUMERIC=C ./audienceClient
```

