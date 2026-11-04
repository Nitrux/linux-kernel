# Building

The build uses the CachyOS kernel source version in `VERSION`, applies the patch list in `patches/series`, and produces Debian packages in `output/`.

On Debian or Ubuntu, run:

```sh
./gh-build.sh
```

- ThinLTO is the local-build default. Set `KERNEL_DEBUG_COMPRESSION=zstd` to reduce build-disk usage while retaining BTF.
  - Set `KERNEL_LTO=none` for a faster, less resource-intensive build, or `KERNEL_LTO=full` for Full LTO.
- The default `KERNEL_VARIANT=x86-64-v3` builds the generic kernel. 
  - To build the AMD Zen 4/Zen 5 variant, set `KERNEL_VARIANT=znver4`; it has a separate `-znver4` package suffix and uses the `MZEN4` kernel configuration.
- Builds use separate variant directories: `work-generic`/`output-generic` and `work-znver4`/`output-znver4`.
- The kernel image in the generated `linux-image-*` package is signed for UEFI Secure Boot.
  - The private key and certificate are supplied through `SECURE_BOOT_KEY` and `SECURE_BOOT_CERT`; they are never generated or stored by the build automatically. Create a local key pair with:

  - These are kernel-only EFI credentials. Keep them separate from the GRUB `SB_KEY`/`SB_CERT` credentials stored in GitHub Actions.

```sh
./scripts/create-secure-boot-keys "$PWD/secure-boot/kernel"
SECURE_BOOT_KEY="$PWD/secure-boot/kernel/db.key" \
SECURE_BOOT_CERT="$PWD/secure-boot/kernel/db.crt" \
./gh-build.sh
```

- To keep kernel module signatures stable across builds, create a persistent module-signing key and pass its PEM bundle through `KERNEL_MODULE_SIGNING_KEY`:

```sh
./scripts/create-module-signing-key "$PWD/secure-boot/modules"
KERNEL_MODULE_SIGNING_KEY="$PWD/secure-boot/modules/module.pem" \
SECURE_BOOT_KEY="$PWD/secure-boot/kernel/db.key" \
SECURE_BOOT_CERT="$PWD/secure-boot/kernel/db.crt" \
./gh-build.sh
```

  - This key signs in-tree modules and can also be used when building matching external modules. It is separate from the EFI image signing key.
- The public kernel certificate is included in each image package at `/usr/share/nitrux/secure-boot/kernel.cer`.
- During a kernel Secure Boot key migration, set `SECURE_BOOT_LEGACY_KEY` and `SECURE_BOOT_LEGACY_CERT` to the old kernel EFI key pair. The packaged kernel receives both signatures until the old certificate is no longer enrolled.

Build the Zen 4/Zen 5 package set with:

```sh
KERNEL_VARIANT=znver4 \
SECURE_BOOT_KEY="$PWD/secure-boot/kernel/db.key" \
SECURE_BOOT_CERT="$PWD/secure-boot/kernel/db.crt" \
./gh-build.sh
```

- Keep `secure-boot/kernel/db.key` and `secure-boot/modules/module.pem` private. Enroll `secure-boot/kernel/db.der` together with the public GRUB certificate from the GRUB package in the target firmware or MOK database.

After installation, both certificates are available on the EFI system partition:

```sh
sudo mokutil --import \
    /boot/efi/EFI/nitrux/nitrux-secure-boot.cer \
    /boot/efi/EFI/nitrux/nitrux-kernel-secure-boot.cer
```

Approve both requests in the MOK manager after reboot.

  - Debian's signed kernel package keeps the normal `linux-image-*` package name; the package payload, rather than its filename, distinguishes it from an unsigned intermediate package.

# Issues

If you find problems with the contents of this repository, please create an issue and use the **🐞 Bug report** template.

## Submitting a bug report

Before submitting a bug, you should look at the [existing bug reports](https://github.com/Nitrux/linux-kernel/issues) to verify that no one has reported the bug already.

©2026 Nitrux Latinoamericana S.C.
