# vmbin

General setup scripts for VMs.

- `install-docker.sh` — installs Docker Engine via the official APT repo (Ubuntu/Debian).
- `install-pwntools.sh` — installs Python/build deps, `uv`, and `pwntools`; intended for CTF VMs.
- `vmware-mount-shared.sh` — mounts a VMware Fusion/Workstation shared folder at `~/shares` via `vmhgfs-fuse`.

Run the script you need directly, e.g. `./install-docker.sh`.
