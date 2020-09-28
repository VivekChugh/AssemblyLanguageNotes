
/*
int main(){
	char buf[40];
	buf[39] = 42;
	return 0xb100d;
}
*/

// =======================================================================================

// int main() {
main:
00401010  push        ebp  
00401011  mov         ebp,esp 
//	char buf[40];
00401013  sub         esp,28h 
// 	buf[39] = 42;
00401016  mov         byte ptr [ebp-1],2Ah 
// return 0xb100d;
0040101A  mov         eax,0B100Dh 

0040101F  mov         esp,ebp 
00401021  pop         ebp  
00401022  ret 



// =======================================================================================

/*  Code compiled with flag for "runtime Stack frame sanity" check enabled.
    This flag is used to capture buffer overflows in a function.
    if user defined a buffer of X bytes in a function,
    - Compiler allocates X bytes + padding area of atleast 4 bytes at start and end of the buffer each.
    - Then it sets entire area with 0xCC.
    - then executes the function.
    - before returning the function.
    - compiler calls _RTC_CheckStackVars() which checks contents of padding area.
    - If the contents of any byte of padding area other than 0xCC, there is buffer overflow in function.    
 */
 
// int main(){
main:
00401010  push        ebp  
00401011  mov         ebp,esp 

// char buf[40];
00401013  sub         esp,30h                   // Allocate 48 bytes. (16 byte boundry just bigger than 40 bytes)
00401016  push        edi                       // save contents of edi as it will be overwritten. we'll save back edi after entire operation/
00401017  lea         edi,[ebp-30h]             // destination address to store contents of eax
0040101A  mov         ecx,0Ch                   // counter: repeat it for 0xCC times.
0040101F  mov         eax,0CCCCCCCCh            // contents to set memory block to.    
00401024  rep stos    dword ptr es:[edi]        

// buf[39] = 42;
00401026  mov         byte ptr [ebp-5],2Ah      // 

// return 0xb100d;
0040102A  mov         eax,0B100Dh 

// Call _RTC_CheckStackVars()
0040102F  push        edx  
00401030  mov         ecx,ebp 
00401032  push        eax  
00401033  lea         edx,[ (401048h)] 
00401039  call        _RTC_CheckStackVars (4010B0h) // 

// Restore Registers.
0040103E  pop         eax  
0040103F  pop         edx  
00401040  pop         edi  

// return from main()
00401041  mov         esp,ebp 
00401043  pop         ebp  
00401044  ret 
