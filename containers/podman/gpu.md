# GPU container access

## Prerequisites

- NVIDIA Graphics Card (Pascal or later)

## Procedure

1. Install the latest NVIDIA GPU Driver for your OS.

2. Follow the instructions on installing the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) in relation to your Linux distribution.

3. Generate the CDI Specification file for Podman:

This file is saved either to /etc/cdi or /var/run/cdi on your Linux distribution and is used for Podman to detect your GPU(s).

Generate the CDI file:

```sh
$ sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
```

Check the list of generated devices:

```sh
$ nvidia-ctk cdi list
```

More information as well as troubleshooting tips can be found on the official [NVIDIA CDI guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html).

4. Configure SELinux (if applicable)

On SELinux-enabled OSes, such as OSs from the Fedora family, the default policy usually disallows containers to have direct access to devices. We make sure it's allowed.

Check whether SELinux is installed and enabled:

```sh
$ getenforce
```

- If getenforce is not found or its output is `Permissive` or `Disabled`, no action is needed.

- If the output is `Enforcing`, configure SELinux to enable device access for containers:

```sh
$ sudo setsebool -P container_use_devices true
```

Verification

To verify that containers created can access the GPU, you can use nvidia-smi from within a container with NVIDIA drivers installed.

Run the following official NVIDIA container on your host machine:

```sh
#test
#Nvidia
podman run --rm --device nvidia.com/gpu=all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi

podman run -itd --device /dev/kfd --device /dev/dri --net=host --security-opt=no-new-privileges --cap-drop=ALL docker.io/rocm/pytorch:latest python3

podman run -itd --rm --device /dev/kfd --device /dev/dri --name windows -p 8006:8006 --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN -v "${PWD:-.}/storage:/storage:Z" --stop-timeout 120 dockurr/windows:10

```
