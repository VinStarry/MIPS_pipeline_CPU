# MIPS_Pipeline_CPU
设计并用FPGA实现了一个利用实地址运行的MIPS CPU。

## MIPS 单周期CPU
单周期的核心是所有的指令是相同的指令周期。
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
因为单周期MIPS CPU的时延受最长的指令时间的影响，将指令执行分成5个阶段，使得同一时间内可以有5条指令在CPU通路中。
5段流水基本思想:  

![phases](./images/phases.jpg)

分支气泡+数据重定向流水Logisim
结构冲突利用时钟下降沿控制先写后读的方式解决。
控制冲突用插入气泡的方法解决。
数据冲突用重定向数据的方法解决。
![img3](./images/img3.jpg)

FPGA主函数

![img1](./images/img5.jpg)

CPU内部数据通路

![img4](./images/img4.jpg)

## 分支预测和多级中断详情请见Logisim电路
分支预测是一种典型的减少控制冲突带来气泡的方法。
