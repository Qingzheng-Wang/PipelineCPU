重新建一个工程，重新生成ROM RAM ，把自己写的SCPU放进去，

WEA 哪一位为1，写哪一个字节

总线过来的写信号丢掉，从SCPU来写信号，4位

写两级之间的寄存器

将级内期间组合成一个模块，组合电路

顶层文件就是将寄存器与模块连线

IF_ID: instruction, PC+4, 

![image-20220623155826862](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220623155826862.png)

寄存器

1. 要有写使能信号，留给后续考虑冒险时用
2. 要有flush清除信号
3. 时钟同步
4. 输入32位数据，输出32位数据

![image-20220623165646735](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220623165646735.png)

![image-20220623170811778](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220623170811778.png)

ID_EXE: 

- input: RegWrite,  [4:0] ALUOp, [2:0] NPCOp, ALUSrc, [3:0] mem_w, [1:0] WDSel, rs1, rs2, wregnum, immgen, PCPLUS4
- output: 

<img src="C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220623171558507.png" alt="image-20220623171558507" style="zoom:200%;" />

数据库彭智勇，不要刘斌

EXE_MEM:

- input: RegWrite, [3:0] mem_w, [1:0] WDSel, [31:0] ALU_result, [31:0] rs2, [4:0] wregnum, 

MEM_WB:

- input: RegWrite,[1:0] WDSel, [31:0] ALU_result, [31:0] dout. [4:0] wregnum

pipereg 32

pipereg 5

pipereg 3

pipe reg 4

pipe reg 1

pipereg 2

现有器件

1. alu
2. ctrl
3. ext: 立即数扩展
4. NPC: 包含，PC加4，通过NPCOp选择PC的值
5. PC： 更像一个寄存器，保存NPC的值
6. RF：寄存器堆
7. 

现在要做的是;

1. 将PC+imm<<1改到EXE阶段
2. 写一个多路选择器，WB和EXE都要用

一步一步写每个阶段

## IF

原先单周期用的NPC综合了太多不该要的东西，最麻烦的是它将PC+imm包含其中，所以我决定不用NPC，重写

![image-20220624155755619](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624155755619.png)

PC加4是一个单独的加法器，加完之后将PC+4送到NPC，NPC是一个四路选择器，NPC选完之后，得到此阶段真正需要的PC值，将真正需要的PC值送到PC寄存器内，PC寄存器保存再将PC值送给I_mem，I_mem根据PC值得到指令。

多路选择器：

![image-20220624164116612](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624164116612.png)

![image-20220624164126507](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624164126507.png)

![image-20220624164134907](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624164134907.png)

![image-20220624171210925](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624171210925.png)

![image-20220624171230500](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624171230500.png)

IF_stage:

- input:[31:0] PC, [31:0]PC_b, [31:0]PC_jal, [31:0]PC_jalr, [2:0] NPCOp
- output: [31:0] NPC(select之后的NPC)，[31:0] PCPLUS4,[31:0] instr

把PC寄存器与IF_stage分离，即当作一个流水线寄存器

![image-20220624202429487](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624202429487.png)

ID——stage:

- input: 
  - EXT: [31:0] instr_in
  - RF: clk, rst, RegWrite, [31:0] instr_in, [31:0] WD
  - ctrl:  [31:0] instr_in

注意wo'za

## **别忘了在EXE阶段加一个和module，因为我把ctrl里面的Zero删了**

EX_stage:

- input: ![image-20220624220150270](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624220150270.png)
- [31:0] ImmGen, [31:0] PCPLUS4, 

​	output: RegWrite,[1:0] WDSel, [3:0] mem_w, [2:0] NPCOp_new, [31:0] ALU_result, [31:0] WriteData, [31:0] BranchAddr, 

流水线冒险要用旁路，控制冒险要静态冒险

低电平亮，高电平暗

MEM：

- input: [3:0] mem_w, ALU_result, [31:0] WriteData(实际上是rs2的值)
- output: [31:0] ReadData 

<img src="C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220624171230500.png" alt="image-20220624171230500" style="zoom: 25%;" />

top:

- input: Clk_CPU, clk_100mhz, rst, INT(似乎没有什么作用，写上吧)，MIO_ready
- output: ![image-20220625094628059](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220625094628059.png) 

​								其实这四个output 没啥用，只是为了给总线留个接口

​								![image-20220625095223888](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220625095223888.png)

​								CPU_MIO没啥用

36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 49 4a 4d 4e

**ID阶段进行数据相关检测**

load/use相关不能用前递，在ID阶段检测到load/use相关时，在EX阶段插入一个气泡，

# 一定注意，D_mem的时钟是下降沿，~clk_100mhz

WDSel没写到ID_EXE去

错误原因：在reg中

![image-20220628101822186](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628101822186.png)

去掉posedge clr

![image-20220628115906992](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628115906992.png)

原来我只写了npcop_new[0],要加上后面的，因为jal,jalr跳转也要清除前两个寄存器

但是现在的问题是，jalr，最后不能回到x1的地址

跳转没错

![image-20220628145907535](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628145907535.png)

mux3中加11，这样优先选择ID与EX的数据冲突

错误：加上11，EXE不能读数据，加11是为了在同时有ID和EX、MEM的数据冲突时，优先选择EX，但是问题在于，最开始几条指令，EX阶段和MEM阶段的wregnum都是0，如果我最开始几条指令是addi x1, x0, 0x123此类，这样后面的wregselnum=0(寄存器初始值为0)，而ID段的也等于0（因为是x0），所以rs1_fwd_sel=11，所以默认选择了in1输出，但是此时in1没有值，这就导致后面都计算不出任何东西

![image-20220628153451678](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628153451678.png)

问题：load_use是0

仿真的时候我看错了

# WEA有问题！！！！！

![image-20220628234120187](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628234120187.png)

![image-20220628234246539](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220628234246539.png)

dm的时钟信号要用Clk_CPU取反

mem_w传输正常

发现sw，ALU根本就没有结果

发现ALUSrc_A根本就没有值

问题似乎出现在RF上，WB和ID似乎有冲突，就是我ID要读的WB还没写进去

改进：RF采用下降沿写，顺利解决

寄存器堆的写入控制采用下降沿触发，而所有**流水线寄存器**采用上跳沿触发，这样在一个完整的时钟周期的中间时刻（即下跳沿）可以完成寄存器堆数据的写入，在时钟周期的后半段就可以利用组合逻辑读取寄存器正确的值

一切都正常，还是写不尽D_mem, 试图把D_mem中初始化去掉

还是不行

放弃



国内外研究现状：哪些公司团队在做risc-v

实验环境介绍：用的软件

概要设计：

详细设计：总体结构要把图丢上去，做说明

​					部件设计要把主要代码放上去，不要再放接口

​					关键代码要有注释

测试和结果分析：

​	仿真代码，仿真测试结果

下载测试代码是应用的

实验总结：一定要写，打分时最看这一章

交pdf文档

班级写一个下午班

7/17截止

![image-20220629151010038](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220629151010038.png)

听从胡瑞的建议，把RAM从PPCPU剥离出来，按照原来的连接方式，通过总线和PPCPU相连

![image-20220629151643389](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220629151643389.png)

改了之后，RAM有输出了-CPU_data4bus，CPU数据有输出CPU_data2bus，CPU存储地址有输出addr_bus, ROM指令inst_in没有输出

0001

1111

0011

重写所有流水线寄存器，不再嵌套模块

![image-20220629203232542](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220629203232542.png)

再试一次，希望能成

还是不行，在考虑把wea和mem_w分开

下板子试不行，今天的工作是再次仿真，看我的CPU哪里有问题

我把wea和mem_w分开，仿真的时候写到dmem上了

细细想来，它变正确的原因有可能如下，

![image-20220630114251718](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630114251718.png)

原来我ADDR输入的是alu_result[9:0], 这就导致我在d_mem里面取数据或者写数据时，要写成dmem[ADDR[9:2]],有可能是这个数据的问题，改成alu_result[11:2]输入后，就只需dmem[ADDR]

![image-20220630121531748](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630121531748.png)

仿真上式发现一处错误，就是sw 存的值不对

错误原因是EXE_MEM里应存的是ALUSrc_B而非直接存rs2，因为上式发生数据冲突，必须在exe_mem里存经过前递选择之后的值。

![image-20220630123206823](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630123206823.png)

```
addi x1, x0, 0x123
addi x2, x0, 0x4
addi x3, x0, 0x789
slli x1, x1, 0x14
addi x4, x0, 0x222
slli x3, x3, 0x8
addi x5, x0, 0x88
addi x6, x0, 0x99
addi x10, x0, 0x23
add x1, x1, x5
addi x11, x0, 0x90
addi x12, x0, 0x43
add x1, x1, x3
sb  x1, 0(x2)
lw x1, 0(x2)
0x12300093
0x00400113
0x78900193
0x01409093
0x22200213
0x00819193
0x08800293
0x09900313
0x02300513
0x005080B3
0x09000593
0x04300613
0x003080B3
0x00110023
0x00012083
```

```assembly
addi x7, x0, 0x7 #x7 = 0x7
srli x3, x7, 0x1 # x3 = 0x3
addi x1, x0, 0x123 #x1 = 0x123
addi x2, x0,0x4 # x2 = 0x4
sw x1, 0x4(x2) # dmem[2] = 0x123
lw x5, 0x4(x2) # x5 = 0x123
add x6, x5, x7 # x6 = 0x12a
sub x1, x2, x3 # x1 = 0x1
or x7, x6, x7 # x7 = 0x12f
and x9, x7, x6 # x9 = 0x12a
```

```assembly
# 分支跳转测试，带冒险
addi x7, x0, 0x7 #x7 = 0x7
srli x3, x7, 0x1 # x3 = 0x3
addi x1, x0, 0x123 #x1 = 0x123
addi x2, x0,0x4 # x2 = 0x4
sw x1, 0x4(x2) # dmem[2] = 0x123
lw x5, 0x4(x2) # x5 = 0x123
add x6, x5, x7 # x6 = 0x12a
sub x1, x2, x3 # x1 = 0x1
or x7, x6, x7 # x7 = 0x12f
and x9, x7, x6 # x9 = 0x12a
add x7, x1, x7 # x7 = 0x130 
sub x9, x9, x1 # x9 = 0x129
bge x7, x9, _L1
add x1, x7, x1 # x1 = 0x25a
add x3, x2, x6
_L1:
	add x1, x9, x1 # x1 = 0x12a
```

bge 跳转不对

![image-20220630153750307](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630153750307.png)

最后猜测是跳转地址的问题

具体问题是，EXT中，

![image-20220630171427366](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630171427366.png)

应改为

![image-20220630171554636](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630171554636.png)

移位操作应留到EXE中做

load_use没问题

下一步测试j型指令

跳没问题

PC+4没有写到rd去，现在检查pcplus4是否传到WB

PCPLUS4传到WB去了，现在检查WDsel信号

WDSel_WB错了

原来是我忘了换指令数据，我是傻逼

现在试一下jalr

```assembly
addi x7, x0, 0x7 #x7 = 0x7
srli x3, x7, 0x1 # x3 = 0x3
addi x1, x0, 0x123 #x1 = 0x123
addi x2, x0,0x4 # x2 = 0x4
sw x1, 0x4(x2) # dmem[2] = 0x123
lw x5, 0x4(x2) # x5 = 0x123
add x6, x5, x7 # x6 = 0x12a
sub x1, x2, x3 # x1 = 0x1
or x7, x6, x7 # x7 = 0x12f
and x9, x7, x6 # x9 = 0x12a
add x7, x1, x7 # x7 = 0x130 
sub x9, x9, x1 # x9 = 0x129
jalr x2,x3,0x9
add x1, x7, x1 # x1 = 0x25a
add x3, x2, x6
_L1:
	add x1, x9, x1 # x1 = 0x12a
```

jalr没有问题

lui和auipc有问题

![image-20220630193826263](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630193826263.png)

![image-20220630193848551](C:\Users\10314\AppData\Roaming\Typora\typora-user-images\image-20220630193848551.png)

EXT和ALU都移位了

<img src="E:\TimDownloads\QQ图片20220630195154.jpg" style="zoom:150%;" />

有一个冒险有问题

发现在发生双重冒险时，

```assembly
addi x1, x0, 0x123
addi x2, x0, 0x345
addi x3, x0, 0xAB
addi x4, x0, 0
addi x5, x0, 0
# double hazard
add x1, x2, x2 # x1 = 0x68a
add x1, x1, x2 # x1 = 0x9cf
sub x1, x1, x3 # x1 = 0x924
```

sub x1, x1, x3,要是x1放在rs2的位置就出错

检查了一遍，发现是我看错指令了，我是傻逼

PipelineTop用Light文件夹下面的！1!

# 2022年6月30日21：35，成功啦！！！

（介绍你的CPU的总体情况，单周期还是流水线，流水线阶段数，各个阶段的大致功能，支持的指令等）
