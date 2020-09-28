
/*

#include <stdio.h>

typedef struct mystruct{
     int var1;
    char var2[4];
} mystruct_t;

int main(){
    mystruct_t a, b;
    a.var1 = 0xFF;
    memcpy(&b, &a, sizeof(mystruct_t)); 
    return 0xAce0Ba5e;
}

*/

// int main() {
main:
00401010  push        ebp  
00401011  mov         ebp,esp 
// mystruct_t a, b;
00401013  sub         esp,10h           // Allocate 16 bytes
// a.var1 = 0xFF;
00401016  mov         dword ptr [ebp-8],0FFh 

// memcpy(&b, &a, sizeof(mystruct_t));
0040101D  push        8                 // sizeof(mystruct_t)
0040101F  lea         eax,[ebp-8]       // &a (Source ptr)
00401022  push        eax  
00401023  lea         ecx,[b]           // &b (destination ptr)
00401026  push        ecx  
00401027  call        memcpy (401042h)  // 401042h is addresss of memcpy 
0040102C  add         esp,0Ch           // cleanup memcopy

// return 0xAce0Ba5e;
0040102F  mov         eax,0ACE0BA5Eh 

00401034  mov         esp,ebp 
00401036  pop         ebp  
00401037  ret



memcpy: 
    push        ebp  
    mov         ebp,esp 
    push        edi	;callee save
    push        esi	;callee save
    mov         esi,dword ptr [ebp+0Ch] ;2nd param - source ptr 
    mov         ecx,dword ptr [ebp+10h] ;3rd param - copy size 
    mov         edi,dword ptr [ebp+8]	;1st param - destination ptr 
    mov         eax,ecx	;copy length to eax
    mov         edx,ecx	;another copy of length for later use
    add         eax,esi	;eax now points to last byte of src copy 
    cmp         edi,esi	;edi (dst) – esi (src) and set flags
    jbe         1026ED30    ;jump if ZF = 1 or CF = 1 
                            ;It will execute different code if the dst == src 
                            ;or if the destination is below (unsigned less than) the source 
                            ;(so jbe is an unsigned edi <= esi check)

    cmp         ecx,100h	;ecx - 0x100 and set flags
    jb          1026ED57	;jump if CF == 1
                            ;Hmmm…since ecx is the length, 
                            ;it appears to do something different based on whether the length is below 0x100 or not.
                            ;We could investigate the alternative path later if we wanted.

    test        edi,3 		;edi AND 0x3 and set flags
    jne         1026ED74 	;jump if ZF == 0
                            ;It is checking if either of the lower 2 bits of the destination address are set. 
                            ;That is, if the address ends in 1, 2, or 3. If both  bits are 0, then the address can be said to be 4-byte-aligned.
                            ; so it’s going to do something different based on whether the  destination is 4-byte-aligned or not.

    shr         ecx,2	    ;divide len by 4
    and         edx,3	    ;edx still contains a copy of ecx
    cmp         ecx,8	    ;ecx >= 8 i.e jump if size to be copied less than 8*4 bytes.
    jb          1026ED94	;jump if CF == 1
                            ;But we currently don’t get to the next instruction 1026ED6A, instead we jump to 1026ED94… :(
    
    rep movs    dword ptr es:[edi],dword ptr [esi] ;we'll reach here only if size to be copied greater than 8*4 bytes. 
                                                   ; es: is segment register prefix. it doesn't mater much 
                                                   ; as in windows, all segement registers does exact same job. 
    jmp         dword ptr [edx*4+1026EE84h]  


/*
Psudo-code of memcopy

memcpy(void * dst, void * src, unsigned int len) {
    if(dst <= src){
	//Path we didn’t take, @ 1026ED28
    }
    if(dst & 3 != 0){
	//Other path we didn’t take, @ 1026ED74 
    }
    if((len / 4) >= 8){
	ecx = len / 4;
	rep movs dword dst, src;
    }
    else{
	//sequence of individual mov instructions
	//as appropriate for the size to be copied
    }
…
}

*/