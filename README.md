<div align="center">
    <h1>
    PipelineCPU
    </h1>
    <p>
        A five-stage pipeline CPU based on RISC-V.
    </p>
    <p>
        2022 WHU 计算机系统综合设计 基于RISCV的五级流水线CPU
    </p>
    <a href="https://github.com/Qingzheng-Wang/PipelineCPU/"><img src="https://img.shields.io/badge/Platform-Xilinx ISE-lightgrey" alt="version"></a>
    <a href="https://github.com/Qingzheng-Wang/PipelineCPU/"><img src="https://img.shields.io/badge/FPGA-SWORD 4.0-lightgrey" alt="version"></a>
    <a href="https://github.com/Qingzheng-Wang/PipelineCPU/"><img src="https://img.shields.io/badge/Simulation-ModelSim-lightgrey" alt="version"></a>
        <a href="https://github.com/Qingzheng-Wang/PipelineCPU/"><img src="https://img.shields.io/badge/Language-Verilog HDL-lightgrey" alt="version"></a>
    <a href="https://github.com/Qingzheng-Wang/PipelineCPU/"><img src="https://img.shields.io/github/stars/Qingzheng-Wang/PipelineCPU?color=yellow&amp;label=PipelineCPU&amp;logo=github" alt="Generic badge"></a>
    <a href="https://github.com/Qingzheng-Wang/PipelineCPU/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-GPL-yellow.svg" alt="gpl"></a>
</div>


<br>



<div align = "center">
	<img src="https://github.com/Qingzheng-Wang/PipelineCPU/blob/main/doc/soc_top_map.png?raw=true" alt="device_place" width="500" />
  <p><b>SOC Top Map</b></p>
	<br>
	<img src="https://github.com/Qingzheng-Wang/PipelineCPU/blob/main/doc/cpu.jpg?raw=true" alt="device_place" width="600" />

<p>
	CPU Architecture
</p>
</div>







## Documents

- [Manual](https://github.com/Qingzheng-Wang/PipelineCPU/wiki)
- [SOC Top Map](https://github.com/Qingzheng-Wang/PipelineCPU/blob/main/doc/top_map.pdf)
- [CPU Architecture](https://github.com/Qingzheng-Wang/PipelineCPU/blob/main/doc/cpu.jpg)
- [Development Log](https://github.com/Qingzheng-Wang/PipelineCPU/blob/main/doc/dev_log.md)

## Design

| Feature         | RISC-V CPU                                                   |
| --------------- | ------------------------------------------------------------ |
| ISA             | RISC-V ([RV32I subset](https://github.com/Evensgn/RISC-V-CPU/blob/master/doc/inst-supported.md)) |
| Pipelining      | 5 stages                                                     |
| Data forwarding | √                                                            |

## References

[1] 谭志虎，秦磊华，吴非，肖亮. 计算机组成原理：微课版[**M**]. 北京：人民邮电出版社，2021.

[2] 戴维·A. 帕特森，约翰·L. 亨尼斯. 计算机组成与设计硬件/软件接口(原书第5版)[M]. 王党辉，译. 北京：机械工业出版社，2015

[3] 李亚民. 计算机原理与设计：Verilog HDL版[M]. 北京：清华大学出版社，2011
