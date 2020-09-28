

/*
#include <stdlib.h>

int sub( int x, int y) {
    return x+y*2;
}
int main(int argc, char** argv)  {
    int a;
    a = atoi(argv[1]);
    return sub(argc, a);
}
 */

// DISASSEMBLY of C CODE ====================================================

int sub( int x, int y) 
.text:00000000 _sub:           push    ebp              # store BP (base of stack of calling function) on stack
.text:00000001                 mov     ebp, esp         # update BP with current function's SP
.text:00000003                 mov     eax, [ebp+8]     # get argc
.text:00000006                 mov     ecx, [ebp+0Ch]   # get argv

return x+y*2
.text:00000009                 lea     eax, [ecx+eax*2] # calculate ecx+eax*2 and return it in eax
.text:0000000C                 pop     ebp              # restore BP of caller function
.text:0000000D                 retn

int main(int argc, char** argv) 
.text:00000010 _main:          push    ebp              # store BP (base of stack of calling function) on stack 
.text:00000011                 mov     ebp, esp         # update BP with current function's SP

int a;
.text:00000013                 push    ecx              # sub     esp, 32  #making space for local vaibales.

atoi(argv[1]);
.text:00000014                 mov     eax, [ebp+0Ch]   # Get start address of argv
.text:00000017                 mov     ecx, [eax+4]     # Get agrv[1] which char* of a sting 
.text:0000001A                 push    ecx              # push fetched char* stack so that it can be passed into function 
.text:0000001B                 call    dword ptr ds:__imp__atoi 
.text:00000021                 add     esp, 4           # cleaning up the passed char* 
 
 a <= atoi()
.text:00000024                 mov     [ebp-4], eax     # copy returned int in local stack space (int is returned in eax) 

sub(argc, a);
.text:00000027                 mov     edx, [ebp-4]     # fetch a
.text:0000002A                 push    edx              # push to sub() parameter
.text:0000002B                 mov     eax, [ebp+8]     # fetch argc
.text:0000002E                 push    eax              # push to sub() parameter
.text:0000002F                 call    _sub             
.text:00000034                 add     esp, 8           # cleaning up parameters

return
.text:00000037                 mov     esp, ebp         # clearing all local variables at once.
.text:00000039                 pop     ebp              # restore BP of caller function
.text:0000003A                 retn

# IMPOTANT POINTS:
# 1. helpgful tip : [ebp + number] - access function parameter. 
#                   [ebp - number] - access Local variable. 
#
# 2. 3rd last command in _main : mov  esp, ebp : which cleans local variables is not present in _sub. 
#       it is because _sub do not have any local varibales.
# 
# 3. altough main returns int, it do not update eax.
#       it is because we use return sub(argc, a);
#       compiler understands that return value of sub() will be returned by main() as it is.
