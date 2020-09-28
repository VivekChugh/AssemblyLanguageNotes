
* Control Flow
    * Unconditional - calls, goto, exceptions, interrupts
    * conditional - if, switch, loop
    

* Intel Syntax (used by Windows)
    * MOV dst src
    * [base + index*scale + disp]

* AT&T Syntax (Used by Linux)
    * % = register $ = immediate
    * MOV %dst %src
    * add $0x04 %dst
    * disp(base, index, scale)
    * movb, movw and movd is available as equivalent of MOV BYTE, MOV WORD, MOV DWORD. 

* Examples:
    call   DWORD PTR [ebx+esi*4-0xe8]
    call   *-0xe8(%ebx,%esi,4)

    mov    eax, DWORD PTR [ebp+0x8]
    mov    0x8(%ebp), %eax

    lea    eax, [ebx-0xe8]
    lea    -0xe8(%ebx), %eax

* Useful Linux Commands:
    * gcc -ggdb -o Example1 Example1.c // compile with debug symbols
    * Disassemble file - convert binary to assembly
        * objdump -d Example1              // AT&T Format 
        * objdump -d -M intel Example1     // Assembly Format
        * hexdump Example1     // contents of binary in hex format (with addresses)
        * hexdump -C Example1  // Canonical view = hex view, each byte separated & ASCII view
        
    * Edit binary manually:
        * xxd Example1 > Example1.dump // dump file in Canonical view
        * <Edit bytes in Example1.dump>
        * xxd -r Example1.dump > Example1

    * GDB Commands:
        * gdb Example1 -x <command file> // cmds to run at each breakpoint
        * run <argv>           // Args for executable.
        * cmd /FMT EXP         // command, format and expression
            * FMT:
                * i - display as asm instruction
                * x or d - display as hex or decimal
                * b or h or w - display as byte, halfword (2 bytes), word (4 bytes - as opposed to intel calling that a double word. Confusing!)
                * s - character string 
                    * will just keep reading till it hits a null character
                * <number> - display <number> worth of things 
                    * (instructions, bytes, words, strings, etc)

        * display/FMT EXP : prints out a statement every time the debugger stops
        * x/FMT EXP : x for “Examine memory” at expression
            * assumes the given value is a memory address and dereferences it to look at the value at that memory address
        * print/FMT EXP : print the value of an expression
        * Example:
            (gdb) print/x $ebp
            $2 = 0xbffbcb78             // contents of ebp
            (gdb) x/x $ebp
            0xbffbcb78:     0xbffbcbe8  // Val at 0xbffbcb78(ebp) = 0xbffbcbe8


        
