<p align="center">
  <img src="assets/axionos.png" />
</p>

# AxionOS
## How to build
#### Initiate AxionOS
```bash
mkdir axionos
cd axionos
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs
```
#### Clone the treble manifest
```bash
git clone https://github.com/itisFarzin/treble_manifest .repo/local_manifests -b axionos-16
```
#### Sync
```bash
repo sync -j$(nproc)
```
#### Apply patches
```bash
bash AxionOS_GSI/patches/apply-patches.sh .
```
#### Build
```bash
source build/envsetup.sh
axion gsi userdebug
m -j$(nproc) systemimage
```
## Compression
```bash
xz -vc -T0 out/target/product/tdgsi_arm64_ab/system.img > system.img.xz
```