## Host Info: rasp3b

**rasp3b** is a [Raspberry Pi 3 Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) system.

- [System info](#user-content-sys)
- [CPU info](#user-content-cpu)
- [OS info](#user-content-os)
- [Available Data](#user-content-data)

### <a id="sys">System Info</a>

| Attribute   | Value |
| ----------- | ----- |
| vendor      | [Raspberry Pi Trading Ltd](https://www.raspberrypi.org/) |
| product     | [Raspberry Pi 3 Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) |

### <a id="cpu">CPU Info</a>

| Attribute | Value |
| --------- | ----- |
| model name       | ARMv8 _(see Note)_ |
| CPU implementer  | 0x41 (ARM) |
| CPU architecture | 7 |
| CPU variant      | 0x0 |
| CPU part         | 0xd03 (Cortex-A53) |
| CPU revision     | 4 |
| Hardware         | BCM2837 _(see Note)_ |
| Revision         | a02082 |
| cores            | 4 |
| threads/core     | 1 |
| cpu min clock    | 600.0 MHz |
| cpu max clock    | 1200.0 MHz |
| bogomips         | 76.80 |
| Cortex-A53 specs | [at infocenter.arm.com](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0500g/BABFEABI.html) |

**Note**: `lscpu` wrongly reports some CPU parameters, supposedly because so
far the OS run in 32 bit mode, not yet exploiting the 64 bit Cortex-A53 core
- Model: `ARMv7 (v7l)` instead of `ARMv8`
- Hardware: `BCM2835` instead of what is written in the ASIC: `BCM2837`

### <a id="os">OS Info</a>

| Attribute | Value |
| --------- | ----- |
| Host OS      | Raspbian GNU/Linux 9 (Stretch) |
| Host kernel  | 4.14.34-v7+ (dated 2018-04-16) |

### <a id="data">Available Data</a>

| Case narrative | Comment |
| -------------- | ------- |
| [2018-05-06_rasp3b](2018-05-06_rasp3b.md) |  |
