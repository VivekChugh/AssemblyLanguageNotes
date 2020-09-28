
/*
int main(){
	int a=1, b=2;
	if(a == b){
		return 1;
	}
	if(a > b){
		return 2;
	}
	if(a < b){
		return 3;
	}
	return 0xdefea7;
}
 */

// ===================================================================

//int main() {
main:
00401010  push        ebp
00401011  mov         ebp,esp
00401013  sub         esp,8

// int a=1, b=2;
00401016  mov         dword ptr [ebp-4],1
0040101D  mov         dword ptr [ebp-8],2
00401024  mov         eax,dword ptr [ebp-4]

// 	if(a == b) {
00401027  cmp         eax,dword ptr [ebp-8]
0040102A  jne         00401033

//  return 1;
0040102C  mov         eax,1
00401031  jmp         00401056              # JUMP at end 

00401033  mov         ecx,dword ptr [ebp-4] # being naive and reading same variables again from stack

// 	if(a > b) {       # if a <= b skip statements below
00401036  cmp         ecx,dword ptr [ebp-8] 
00401039  jle         00401042              

//  return 2;
0040103B  mov         eax,2
00401040  jmp         00401056              # JUMP at end

00401042  mov         edx,dword ptr [ebp-4] # being naive and reading same variables again from stack

// 	if(a < b){        # if a >= b skip statements below  
00401045  cmp         edx,dword ptr [ebp-8] 
00401048  jge         00401051

//  return 3;
0040104A  mov         eax,3
0040104F  jmp         00401056              # JUMP at end

// return 0xdefea7;
00401051  mov         eax,0DEFEA7h
00401056  mov         esp,ebp
00401058  pop         ebp
00401059  ret 
