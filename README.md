# MIPS_pipline_CPU
Design and synthesis of a MIPS pipeline CPU....

SW[0]: 暂停、运行。=1, 运行；=0，暂停。
SW[1]: 复位。=1，归0；=0，正常运行。
SW[2]: 改变频率。上升沿时，频率=频率/2，有四种频率：1HZ, 0.5HZ, 0.25HZ, 0.125HZ，继续拨动会回调至1HZ
SW[5:3]: display_op[2:0]，显示内容控制
SW[15:6]: ram_display_addr[15:6]，显示信息的ram地址
