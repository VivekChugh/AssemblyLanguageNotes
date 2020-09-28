* r/m32 = a 32 bit value from register or memory.
* [] is called 'value at' operator. It says, treat contents of [] as memory address and fetch contents of that location.(except in LEA)
* x86 does not allow memory to memory copy i.e for an instruction, two operands can't have [] . 
* constant numeric value provided as operand is called is called immediate value.

* PUSH instruction : pushes numeric constant or contents of register to stack and decrement ESP by 4

* POP  instruction : gets contents at ESP to register and increments ESP by 4

* CALL instruction : job is to transfer control to a function
    * push contents of IP to stack.
    * load IP with address (absolute or relative to content of IP) provided as argument.
    * Call has implicit PUSH statement. 

* RET instruction :
    * cdel:
        * pop contents of SP to IP
        * stack frame cleanup is already done my caller
        * Hence this instruction do not take any argument.
    * stdcall:
        * pop contents of SP to IP
        * add constant number of bytes to SP
        * This is equivalent to clearing calling information(arguments, sp, register contents)
        * Ex. ret 0x8, ret 0x20 
    * RET has implicit POP statement.    

* MOV instruction : 
    * transfer content between registers, memory and numeric values
    * NEVER Memory to Memory
    * MOV eax, ebx <= Move contents of ebx to eax
    * MOV eax, [ebx] <= treat contents of ebx as memory address, load eax with contents of that location.
    * element of array in memory can be accessed as [baseAddr+(index*elemSize)] 

* LEA instruction: load effective address
    * LEA eax, [ebx+10] <= calculate expression in [] and load eax with it.
    * [] is called 'value at' operator but it's use with LEA instruction is an exception.
    * LEA does NOT fetch VALUE AT i.e does NOT treat operand as memory address and go there to fetch it's contents.

*  ADD/SUB instruction: 
    * take 2nd Operand, Add to or subtract from 1st element and store result in 1st element.

* JMP instruction: Change EIP to given address
    * forms of address
        * Relative: to jump to a nearby address
            * Short relative: jmp with 1 byte displacement
            * Nearby relative: jmp with 4 byte displacement
            * displacement is signed value: can be negative to jmp to lower address
            * jmp -2 : will create a infinite loop
        * Absolute: to jump to a far away address                
            * Direct absolute: Hardcoded address
            * Indirect absolute: address calculated from r/m32 
            * Indirect absolute jmps are used to implement Function pointers

* CMP instruction: compare operands, set zero flag if they are equal.
    * CMP actually is SUB instruction, it keeps the flags and throws the result.

* JCC instructions - Jump if condition is met - It is a SET of instructions
    * JZ/JE: if ZF == 1     (Zero flag)
    * JNZ/JNE: if ZF == 0
    * JLE/JNG: if ZF == 1 or SF != OF (sign flag , overflow flag)
    * JGE/JNL: if SF == OF 
    * JBE: if CF == 1 OR ZF == 1      (carry flag)
    * JB: if CF == 1
        * JB(E) is Jump if below (or equal) 
        * Below is different from lass
        * Below is used for comparison of unsigned data while Less is used for comparing signed data

* Bitwise instructions:
* Bitwise and logical operations are NOT different in Assembly. As they are in C and C++
    * AND - output is 1 only if all input bits are one.
    * OR  - output is 1 if any input bit is one. 
    * XOR - output is 1 if any input bit is different from others.
        * XOR is used to 0 a register by XORing it with itself. it is faster than MOV reg, 0x00
    * NOT - output bit is flipped from input.

* TEST - is AND instruction, but it throws the output and keeps teh flags.

* SHL/SHR - Shift left/Shift Right 
    * first operant     r/m32
    * 2nd operand       number of bits to shift
        * it 1 byte immediate value or lower 1 byte of register (al, bl, cl, al). 
        * in most cases it is cl as it follows intel convention of being counter register.
    * sifted bit places are filled with 0s    
    * SHL:
        * 1st operand is multiplied by 2 for each place the value is shifted. More efficient than a multiply instruction.
        * MSB of (1st operand) register is “shifted into” (set) the carry flag (CF)
    * SHR:
        * 1st operand is divided by 2 for each place the value is shifted. More efficient than a divide instruction.
        * LSB of (1st operand) register is “shifted into” (set) the carry flag (CF)
    
* IMUL - Signed multiply
    * imul r/m32 			            edx:eax = eax * r/m32
    * imul reg, r/m32 		        	reg = reg * r/m32
    * imul reg, r/m32, immediate 		reg = r/m32 * immediate

* DIV - Unsigned Divide
    * if ax is 16 bit:  (DIV ax cx)        ax by r/m8  ==> al  = quotient, ah  = remainder
    * if eax is 32 bit: (DIV eax ecx) edx:eax by r/m32 ==> eax = quotient, edx = remainder (edx is cleared before executing)
    * If the divisor is 0, a divide by zero exception is raised

* STOS - Store String
    * take 1 byte from al (or 4 bytes from eax) and store at [edi]

* rep STOS - repeat Store String
    * rep is NOT an instruction, but can be prefixed to some string instructions to repeat instruction operation.
    * decrementing counter is set in ecx. it is decremented after each cycle until it is 0.
    * edi is incremented (by 1 or by 4) after every cycle.
    * This instruction is used to set each byte of memory block to a specific value.

* MOVS - Move string to string
    * Either move byte at [esi] to byte at [edi] or move dword at [esi] to dword at [edi].
    * **Q: Is it a Memory-to-Memory copy instruction?** 

* rep MOVS - Repeat MOV 
    * decrementing counter is set in ecx. it is decremented after each cycle until it is 0.
    * edi and esi are incremented (by 1 or by 4) after every cycle.
    * This instruction is used to copy each byte of memory block to a specific val

* LEAVE - Set ESP to EBP, then pop EBP.     