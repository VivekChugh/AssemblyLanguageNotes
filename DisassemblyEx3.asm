/*
#include <stdio.h>
int main(){
   int i;
   for(i = 0; i < 10; i++){
      printf("i = %d\n“, i);
   }
}
*/

// ============================================

// int main() {
main:
00401010  push        ebp                       # push BP to stack 
00401011  mov         ebp,esp                   # update base of stack

// int i;
00401013  push        ecx                       # 

// i = 0
00401014  mov         dword ptr [ebp-4],0 

// For loop starts here 
// First itaration start from 00401026 all others start from 0040101D
0040101B  jmp         00401026 

// i++
0040101D  mov         eax,dword ptr [ebp-4]         // get i's value
00401020  add         eax,1                         // i++
00401023  mov         dword ptr [ebp-4],eax         // update i's value on stack

// i < 10   
00401026  cmp         dword ptr [ebp-4],0Ah         // (exit loop if i >= 10)
0040102A  jge         00401040      

0040102C  mov         ecx,dword ptr [ebp-4]         // get i's value
0040102F  push        ecx                           // push i on stack as parameter
00401030  push        405000h                       // puch char* for string
00401035  call        dword ptr ds:[00406230h]      // call printf
0040103B  add         esp,8                         // clear parameters (char* of string and int i) and return address

0040103E  jmp         0040101D                      // jump back for next iteration

00401040  xor         eax,eax                       // return value 0
00401042  mov         esp,ebp                       // clear local variables
00401044  pop         ebp                           // restore base pointer  
00401045  ret 

/*
    Q1 - Not sure in '0040103B  add esp,8' clear 8 of parameters only or of parameters and return value
    Q2 - in printf call 'dword ptr ds:[00406230h]' what is 00406230h address?
*/