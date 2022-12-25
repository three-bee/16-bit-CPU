# 16-bit-CPU
Custom 16-bit ISA with multi-cycle CPU, written in Verilog.

Covers the last two lab experiments of Middle East Technical University, Electrical and Electronics Engineering Department, EE446 Computer Architecture 2 course. 

### General Information
* Suitable hardware for this ISA contains:
  * Von-Neumann architecture memory of 64 words, each word is of W=8 bits (byte-addressable memory). 6 of 8 bits are required for addressing the memory.
  * 8 general purpose registers of size 8 bits. 3 of 8 bits are required for addressing the registers.
  * PC (R7) and LR (R6) of size 8 bits are inside the general-purpose registers.
  
<table class="tg">
<thead>
  <tr>
    <th class="tg-c3ow">Addresses</th>
    <th class="tg-c3ow">Content</th>
    <th class="tg-c3ow"></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-c3ow"></td>
    <td class="tg-c3ow"></td>
    <td class="tg-c3ow"></td>
  </tr>
  <tr>
    <td class="tg-c3ow">0x22</td>
    <td class="tg-c3ow">0xC4</td>
    <td class="tg-c3ow">Some data</td>
  </tr>
  <tr>
    <td class="tg-c3ow">..</td>
    <td class="tg-c3ow"></td>
    <td class="tg-c3ow"></td>
  </tr>
  <tr>
    <td class="tg-c3ow">..</td>
    <td class="tg-c3ow">0xB2</td>
    <td class="tg-c3ow" rowspan="2">Instruction #1</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0x02</td>
    <td class="tg-c3ow">0x01</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0x01</td>
    <td class="tg-c3ow">0x03</td>
    <td class="tg-c3ow" rowspan="2">Instruction #0</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0x00</td>
    <td class="tg-c3ow">0x71</td>
  </tr>
</tbody>
</table>

### Opcodes 

Examples are given in ARM mnemonic.

#### OP = 00 (Arithmetic operations)
<table class="tg">
<thead>
  <tr>
    <th class="tg-mqa1">15</th>
    <th class="tg-mqa1">14</th>
    <th class="tg-mqa1">13</th>
    <th class="tg-mqa1">12</th>
    <th class="tg-mqa1">11</th>
    <th class="tg-mqa1">10</th>
    <th class="tg-mqa1">9</th>
    <th class="tg-mqa1">8</th>
    <th class="tg-mqa1">7</th>
    <th class="tg-mqa1">6</th>
    <th class="tg-mqa1">5</th>
    <th class="tg-mqa1">4</th>
    <th class="tg-mqa1">3</th>
    <th class="tg-mqa1">2</th>
    <th class="tg-mqa1">1</th>
    <th class="tg-mqa1">0</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-wp8o" colspan="2">OP</td>
    <td class="tg-wp8o" colspan="2">CMD</td>
    <td class="tg-wp8o">I</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">00</td>
    <td class="tg-wp8o" colspan="2">CMD</td>
    <td class="tg-wp8o">0</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o" colspan="3">Rn</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o" colspan="3">Rm</td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">00</td>
    <td class="tg-wp8o" colspan="2">CMD</td>
    <td class="tg-wp8o">1</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o" colspan="3">rot</td>
    <td class="tg-wp8o" colspan="5">imm5</td>
  </tr>
</tbody>
</table>

<table class="tg">
<thead>
  <tr>
    <th class="tg-baqh">CMD</th>
    <th class="tg-baqh">function</th>
    <th class="tg-baqh">pseudo instructions</th>
    <th class="tg-baqh">examples</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-baqh">00</td>
    <td class="tg-baqh">ADD</td>
    <td class="tg-baqh" rowspan="2">Rd &lt;-- Rn CMD Rm if I = 0<br>Rd &lt;-- Rd CMD (extimm5 ROL rot) if I = 1</td>
    <td class="tg-baqh" rowspan="4">CMD R5,R3,R0<br>CMD R4,#20 (imm5=20, rot=0)<br>CMD R2,#80 (imm5=20, rot=2)</td>
  </tr>
  <tr>
    <td class="tg-baqh">01</td>
    <td class="tg-baqh">SUB</td>
  </tr>
  <tr>
    <td class="tg-baqh">10</td>
    <td class="tg-baqh">CMP</td>
    <td class="tg-baqh">X &lt;-- Rn SUB Rm if I = 0<br>X &lt;-- Rd SUB (extimm5 ROL rot) if I = 1</td>
  </tr>
  <tr>
    <td class="tg-baqh">11</td>
    <td class="tg-baqh">MOV</td>
    <td class="tg-baqh">Rd &lt;-- (extimm5 ROL rot) and I = 1</td>
  </tr>
</tbody>
</table>


#### OP = 01 (Logic operations and shifting)

* 3-bit shamt (0-7) can move the extended 5-bit immediate value to all possible locations in the 8-bit register. ROR is handled by ROL (ROR(x)=ROL(8-x)).

<table class="tg">
<thead>
  <tr>
    <th class="tg-mqa1">15</th>
    <th class="tg-mqa1">14</th>
    <th class="tg-mqa1">13</th>
    <th class="tg-mqa1">12</th>
    <th class="tg-mqa1">11</th>
    <th class="tg-mqa1">10</th>
    <th class="tg-mqa1">9</th>
    <th class="tg-mqa1">8</th>
    <th class="tg-mqa1">7</th>
    <th class="tg-mqa1">6</th>
    <th class="tg-mqa1">5</th>
    <th class="tg-mqa1">4</th>
    <th class="tg-mqa1">3</th>
    <th class="tg-mqa1">2</th>
    <th class="tg-mqa1">1</th>
    <th class="tg-mqa1">0</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-wp8o" colspan="2">OP</td>
    <td class="tg-wp8o" colspan="3">CMD</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
    <td class="tg-wp8o"></td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">01</td>
    <td class="tg-wp8o" colspan="3">CMD</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o" colspan="3">Rn</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o" colspan="3">Rm</td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">01</td>
    <td class="tg-wp8o" colspan="3">CMD</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o" colspan="3">rot</td>
    <td class="tg-wp8o" colspan="5">imm5</td>
  </tr>
</tbody>
</table>



<table class="tg">
<thead>
  <tr>
    <th class="tg-c3ow">CMD</th>
    <th class="tg-c3ow">function</th>
    <th class="tg-c3ow">pseudo instructions</th>
    <th class="tg-c3ow">examples</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-c3ow">000</td>
    <td class="tg-c3ow">ADD</td>
    <td class="tg-c3ow" rowspan="3">Rd &lt;-- Rn CMD Rm</td>
    <td class="tg-c3ow" rowspan="8">AND R5,R3,R0<br>LSL R4,#2 (rot=x, imm5=2)<br>ROL R3,#6<br>ROR R3,#2 (imm5=8-2=6)</td>
  </tr>
  <tr>
    <td class="tg-c3ow">001</td>
    <td class="tg-c3ow">OR</td>
  </tr>
  <tr>
    <td class="tg-c3ow">010</td>
    <td class="tg-c3ow">XOR</td>
  </tr>
  <tr>
    <td class="tg-c3ow">011</td>
    <td class="tg-c3ow">ROL</td>
    <td class="tg-c3ow" rowspan="5">Rd &lt;-- Rd CMD extimm5</td>
  </tr>
  <tr>
    <td class="tg-baqh">100</td>
    <td class="tg-baqh">ROR</td>
  </tr>
  <tr>
    <td class="tg-baqh">101</td>
    <td class="tg-baqh">LSL</td>
  </tr>
  <tr>
    <td class="tg-baqh">110</td>
    <td class="tg-baqh">LSR</td>
  </tr>
  <tr>
    <td class="tg-baqh">111</td>
    <td class="tg-baqh">ASR</td>
  </tr>
</tbody>
</table>

#### OP = 10 (Memory operations)

* H determines which half of the memory to be addressed. Normally, addr/offset should allocate 6 bits. However, to keep the bit positions of Rn and Rd in the same place for all instruction types, immediate value is considered to have 5 bits. The most significant bit is H, being the 6th bit.
* H is handled in the extender module.

<table class="tg">
<thead>
  <tr>
    <th class="tg-mqa1">15</th>
    <th class="tg-mqa1">14</th>
    <th class="tg-mqa1">13</th>
    <th class="tg-mqa1">12</th>
    <th class="tg-mqa1">11</th>
    <th class="tg-mqa1">10</th>
    <th class="tg-mqa1">9</th>
    <th class="tg-mqa1">8</th>
    <th class="tg-mqa1">7</th>
    <th class="tg-mqa1">6</th>
    <th class="tg-mqa1">5</th>
    <th class="tg-mqa1">4</th>
    <th class="tg-mqa1">3</th>
    <th class="tg-mqa1">2</th>
    <th class="tg-mqa1">1</th>
    <th class="tg-mqa1">0</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-wp8o" colspan="2">OP</td>
    <td class="tg-wp8o">L</td>
    <td class="tg-wp8o">I</td>
    <td class="tg-wp8o">H</td>
    <td class="tg-wp8o" colspan="3">Rd</td>
    <td class="tg-wp8o" colspan="3">Rn</td>
    <td class="tg-wp8o" colspan="5">addr5/offset5</td>
  </tr>
</tbody>
</table>

<table class="tg">
<thead>
  <tr>
    <th class="tg-baqh">L</th>
    <th class="tg-baqh">function</th>
    <th class="tg-baqh">pseudo instructions</th>
    <th class="tg-baqh">examples</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-baqh">1</td>
    <td class="tg-baqh">LDR</td>
    <td class="tg-baqh">Rd &lt;-- MEM[Rn + {H, offset5}] if I = 0<br>Rd &lt;-- MEM[{H, addr5}] if I = 1</td>
    <td class="tg-baqh" rowspan="2">LDR R0, [R1,#3]<br>LDR R0,#63 (offset5=31, H=1)<br>STR R1, [R0]<br>STR R0,#2</td>
  </tr>
  <tr>
    <td class="tg-baqh">0</td>
    <td class="tg-baqh">STR</td>
    <td class="tg-baqh">Rd --&gt; MEM[Rn + {H, offset5}] if I = 0<br>Rd --&gt; MEM[{H, addr5}] if I = 1</td>
  </tr>
</tbody>
</table>

#### OP = 11 (Branching)

* Each instruction is 2 bytes. The memory is byte addressable. Due to the architecture's 3-stage pipeline, branch target address is laoded to PC + 2 instructions ahead = PC + 2.
* Rd=R6 needs to be set for BL, hence INSR[10:8] = 110.

<table class="tg">
<thead>
  <tr>
    <th class="tg-mqa1">15</th>
    <th class="tg-mqa1">14</th>
    <th class="tg-mqa1">13</th>
    <th class="tg-mqa1">12</th>
    <th class="tg-mqa1">11</th>
    <th class="tg-mqa1">10</th>
    <th class="tg-mqa1">9</th>
    <th class="tg-mqa1">8</th>
    <th class="tg-mqa1">7</th>
    <th class="tg-mqa1">6</th>
    <th class="tg-mqa1">5</th>
    <th class="tg-mqa1">4</th>
    <th class="tg-mqa1">3</th>
    <th class="tg-mqa1">2</th>
    <th class="tg-mqa1">1</th>
    <th class="tg-mqa1">0</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-wp8o" colspan="2">OP</td>
    <td class="tg-wp8o" colspan="2">type</td>
    <td class="tg-wp8o" colspan="2">flag</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o" colspan="6">addr6</td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">01</td>
    <td class="tg-wp8o" colspan="2">x0</td>
    <td class="tg-wp8o" colspan="2">xx</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o" colspan="6">addr6</td>
  </tr>
  <tr>
    <td class="tg-wp8o" colspan="2">01</td>
    <td class="tg-wp8o" colspan="2">01</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">1</td>
    <td class="tg-wp8o">1</td>
    <td class="tg-wp8o">0</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o">x</td>
    <td class="tg-wp8o" colspan="6">addr6</td>
  </tr>
</tbody>
</table>

<table class="tg">
<thead>
  <tr>
    <th class="tg-c3ow">type</th>
    <th class="tg-c3ow">flag</th>
    <th class="tg-c3ow">function</th>
    <th class="tg-c3ow">explanation</th>
    <th class="tg-c3ow">pseudo instructions</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-c3ow">00</td>
    <td class="tg-c3ow">x</td>
    <td class="tg-c3ow">B</td>
    <td class="tg-c3ow">branch</td>
    <td class="tg-c3ow">PC + 2 &lt;-- addr6</td>
  </tr>
  <tr>
    <td class="tg-c3ow">01</td>
    <td class="tg-c3ow">x</td>
    <td class="tg-c3ow">BL</td>
    <td class="tg-c3ow">branch with link</td>
    <td class="tg-c3ow">LR(R6) &lt;-- PC<br>PC + 2 &lt;-- addr6</td>
  </tr>
  <tr>
    <td class="tg-c3ow">10</td>
    <td class="tg-c3ow">x</td>
    <td class="tg-c3ow">BI</td>
    <td class="tg-c3ow">branch indirect</td>
    <td class="tg-c3ow">PC + 2 &lt;-- MEM[addr6]</td>
  </tr>
  <tr>
    <td class="tg-c3ow">11</td>
    <td class="tg-c3ow">00</td>
    <td class="tg-c3ow">BEQ</td>
    <td class="tg-c3ow">branch if zero</td>
    <td class="tg-c3ow" rowspan="4">B if condition satisfied</td>
  </tr>
  <tr>
    <td class="tg-c3ow">11</td>
    <td class="tg-c3ow">01</td>
    <td class="tg-c3ow">BNE</td>
    <td class="tg-c3ow">branch if not zero</td>
  </tr>
  <tr>
    <td class="tg-c3ow">11</td>
    <td class="tg-c3ow">10</td>
    <td class="tg-c3ow">BHS/BCS</td>
    <td class="tg-c3ow">branch if carry</td>
  </tr>
  <tr>
    <td class="tg-c3ow">11</td>
    <td class="tg-c3ow">11</td>
    <td class="tg-c3ow">BLO/BCC</td>
    <td class="tg-c3ow">branch if not carry</td>
  </tr>
</tbody>
</table>

### Datapath 
* As the baseline, Harris & Harris' multicycle ARM datapath design is taken and modified extensively.
* For more details and the datapath architecture, please refer to the project report.

### Controller
* A finite state machine in Verilog is written for the controller. Minimum number of states is not seeked, hence the available states can be reduced.
* For more details and the state diagram, please refer to the project report.

### Example programs
* Please refer to the project report and memory file in the repository.
