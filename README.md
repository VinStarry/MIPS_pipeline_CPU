# MIPS_Pipeline_CPU

## MIPS 单周期CPU

顶层通路图:

![total_single_circular](./images/total_single_circular.jpg)

原理通路图:

![](./images/img.jpg)

单周期通路图(Logisim):

![](./images/scCPU_circ.jpg)

FPGA主函数:  

![img1](./images/img1.jpg)

FPGA CPU内部数据s通路:  

![img2](./images/img2.jpg)

# MIPS流水线CPU

5段流水基本思想:  

![phases](./images/phases.jpg)

分支气泡+数据重定向流水Logisim

![img3](./images/img3.jpg)

FPGA主函数

![img1](./images/img5.jpg)

CPU内部数据通路

![img4](./images/img4.jpg)

## 分支预测和中断详情请见Logisim电路