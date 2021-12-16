
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	pushq  $0x0
        popfq
   4000c:	9d                   	popfq  
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 84 01 00 00       	jmpq   401b1 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	pushq  $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	pushq  $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	pushq  $0x0
        pushq $32
   40038:	6a 20                	pushq  $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	pushq  $0x0
        pushq $48
   4003e:	6a 30                	pushq  $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	pushq  $0x0
        pushq $49
   40044:	6a 31                	pushq  $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	pushq  $0x0
        pushq $50
   4004a:	6a 32                	pushq  $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	pushq  $0x0
        pushq $51
   40050:	6a 33                	pushq  $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	pushq  $0x0
        pushq $52
   40056:	6a 34                	pushq  $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	pushq  $0x0
        pushq $53
   4005c:	6a 35                	pushq  $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	pushq  $0x0
        pushq $54
   40062:	6a 36                	pushq  $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	pushq  $0x0
        pushq $55
   40068:	6a 37                	pushq  $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	pushq  $0x0
        pushq $56
   4006e:	6a 38                	pushq  $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	pushq  $0x0
        pushq $57
   40074:	6a 39                	pushq  $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	pushq  $0x0
        pushq $58
   4007a:	6a 3a                	pushq  $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	pushq  $0x0
        pushq $59
   40080:	6a 3b                	pushq  $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	pushq  $0x0
        pushq $60
   40086:	6a 3c                	pushq  $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	pushq  $0x0
        pushq $61
   4008c:	6a 3d                	pushq  $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	pushq  $0x0
        pushq $62
   40092:	6a 3e                	pushq  $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	pushq  $0x0
        pushq $63
   40098:	6a 3f                	pushq  $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	pushq  $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	pushq  %gs
        pushq %fs
   400a2:	0f a0                	pushq  %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 a3 06 00 00       	callq  40766 <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	popq   %fs
        popq %gs
   400df:	0f a9                	popq   %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq  

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)  
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <unmap>:
    PO_KERNEL = -2              // this page is used by the kernel
} pageowner_t;

static void pageinfo_init(void);

void unmap(int pn) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 08          	sub    $0x8,%rsp
   4016f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    pageinfo[pn].refcount--;
   40172:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40175:	48 98                	cltq   
   40177:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   4017e:	00 
   4017f:	83 e8 01             	sub    $0x1,%eax
   40182:	89 c2                	mov    %eax,%edx
   40184:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40187:	48 98                	cltq   
   40189:	88 94 00 21 4f 05 00 	mov    %dl,0x54f21(%rax,%rax,1)
    if (pageinfo[pn].refcount == 0) {
   40190:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40193:	48 98                	cltq   
   40195:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   4019c:	00 
   4019d:	84 c0                	test   %al,%al
   4019f:	75 0d                	jne    401ae <unmap+0x47>
        pageinfo[pn].owner = PO_FREE;
   401a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401a4:	48 98                	cltq   
   401a6:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   401ad:	00 
    }
}
   401ae:	90                   	nop
   401af:	c9                   	leaveq 
   401b0:	c3                   	retq   

00000000000401b1 <kernel>:

// kernel(command)
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

void kernel(const char* command) {
   401b1:	55                   	push   %rbp
   401b2:	48 89 e5             	mov    %rsp,%rbp
   401b5:	48 83 ec 20          	sub    $0x20,%rsp
   401b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   401bd:	e8 7f 14 00 00       	callq  41641 <hardware_init>
    pageinfo_init();
   401c2:	e8 03 0b 00 00       	callq  40cca <pageinfo_init>
    console_clear();
   401c7:	e8 bc 38 00 00       	callq  43a88 <console_clear>
    timer_init(HZ);
   401cc:	bf 64 00 00 00       	mov    $0x64,%edi
   401d1:	e8 5b 19 00 00       	callq  41b31 <timer_init>

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   401d6:	ba 00 0f 00 00       	mov    $0xf00,%edx
   401db:	be 00 00 00 00       	mov    $0x0,%esi
   401e0:	bf 00 40 05 00       	mov    $0x54000,%edi
   401e5:	e8 b5 2f 00 00       	callq  4319f <memset>
    for (pid_t i = 0; i < NPROC; i++) {
   401ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401f1:	eb 44                	jmp    40237 <kernel+0x86>
        processes[i].p_pid = i;
   401f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401f6:	48 63 d0             	movslq %eax,%rdx
   401f9:	48 89 d0             	mov    %rdx,%rax
   401fc:	48 c1 e0 04          	shl    $0x4,%rax
   40200:	48 29 d0             	sub    %rdx,%rax
   40203:	48 c1 e0 04          	shl    $0x4,%rax
   40207:	48 8d 90 00 40 05 00 	lea    0x54000(%rax),%rdx
   4020e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40211:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   40213:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40216:	48 63 d0             	movslq %eax,%rdx
   40219:	48 89 d0             	mov    %rdx,%rax
   4021c:	48 c1 e0 04          	shl    $0x4,%rax
   40220:	48 29 d0             	sub    %rdx,%rax
   40223:	48 c1 e0 04          	shl    $0x4,%rax
   40227:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   4022d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) {
   40233:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40237:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4023b:	7e b6                	jle    401f3 <kernel+0x42>
    }

    if (command && strcmp(command, "malloc") == 0) {
   4023d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40242:	74 29                	je     4026d <kernel+0xbc>
   40244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40248:	be 06 46 04 00       	mov    $0x44606,%esi
   4024d:	48 89 c7             	mov    %rax,%rdi
   40250:	e8 bb 2f 00 00       	callq  43210 <strcmp>
   40255:	85 c0                	test   %eax,%eax
   40257:	75 14                	jne    4026d <kernel+0xbc>
        process_setup(1, 4);
   40259:	be 04 00 00 00       	mov    $0x4,%esi
   4025e:	bf 01 00 00 00       	mov    $0x1,%edi
   40263:	e8 b8 00 00 00       	callq  40320 <process_setup>
   40268:	e9 a9 00 00 00       	jmpq   40316 <kernel+0x165>
    } else if (command && strcmp(command, "alloctests") == 0) {
   4026d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40272:	74 26                	je     4029a <kernel+0xe9>
   40274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40278:	be 0d 46 04 00       	mov    $0x4460d,%esi
   4027d:	48 89 c7             	mov    %rax,%rdi
   40280:	e8 8b 2f 00 00       	callq  43210 <strcmp>
   40285:	85 c0                	test   %eax,%eax
   40287:	75 11                	jne    4029a <kernel+0xe9>
        process_setup(1, 5);
   40289:	be 05 00 00 00       	mov    $0x5,%esi
   4028e:	bf 01 00 00 00       	mov    $0x1,%edi
   40293:	e8 88 00 00 00       	callq  40320 <process_setup>
   40298:	eb 7c                	jmp    40316 <kernel+0x165>
    } else if (command && strcmp(command, "test") == 0){
   4029a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4029f:	74 26                	je     402c7 <kernel+0x116>
   402a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402a5:	be 18 46 04 00       	mov    $0x44618,%esi
   402aa:	48 89 c7             	mov    %rax,%rdi
   402ad:	e8 5e 2f 00 00       	callq  43210 <strcmp>
   402b2:	85 c0                	test   %eax,%eax
   402b4:	75 11                	jne    402c7 <kernel+0x116>
        process_setup(1, 6);
   402b6:	be 06 00 00 00       	mov    $0x6,%esi
   402bb:	bf 01 00 00 00       	mov    $0x1,%edi
   402c0:	e8 5b 00 00 00       	callq  40320 <process_setup>
   402c5:	eb 4f                	jmp    40316 <kernel+0x165>
    } else if (command && strcmp(command, "test2") == 0) {
   402c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402cc:	74 39                	je     40307 <kernel+0x156>
   402ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402d2:	be 1d 46 04 00       	mov    $0x4461d,%esi
   402d7:	48 89 c7             	mov    %rax,%rdi
   402da:	e8 31 2f 00 00       	callq  43210 <strcmp>
   402df:	85 c0                	test   %eax,%eax
   402e1:	75 24                	jne    40307 <kernel+0x156>
        for (pid_t i = 1; i <= 2; ++i) {
   402e3:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402ea:	eb 13                	jmp    402ff <kernel+0x14e>
            process_setup(i, 6);
   402ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402ef:	be 06 00 00 00       	mov    $0x6,%esi
   402f4:	89 c7                	mov    %eax,%edi
   402f6:	e8 25 00 00 00       	callq  40320 <process_setup>
        for (pid_t i = 1; i <= 2; ++i) {
   402fb:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   402ff:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
   40303:	7e e7                	jle    402ec <kernel+0x13b>
   40305:	eb 0f                	jmp    40316 <kernel+0x165>
        }
    } else {
        process_setup(1, 0);
   40307:	be 00 00 00 00       	mov    $0x0,%esi
   4030c:	bf 01 00 00 00       	mov    $0x1,%edi
   40311:	e8 0a 00 00 00       	callq  40320 <process_setup>
    }

    // Switch to the first process using run()
    run(&processes[1]);
   40316:	bf f0 40 05 00       	mov    $0x540f0,%edi
   4031b:	e8 19 09 00 00       	callq  40c39 <run>

0000000000040320 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   40320:	55                   	push   %rbp
   40321:	48 89 e5             	mov    %rsp,%rbp
   40324:	48 83 ec 10          	sub    $0x10,%rsp
   40328:	89 7d fc             	mov    %edi,-0x4(%rbp)
   4032b:	89 75 f8             	mov    %esi,-0x8(%rbp)
    process_init(&processes[pid], 0);
   4032e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40331:	48 63 d0             	movslq %eax,%rdx
   40334:	48 89 d0             	mov    %rdx,%rax
   40337:	48 c1 e0 04          	shl    $0x4,%rax
   4033b:	48 29 d0             	sub    %rdx,%rax
   4033e:	48 c1 e0 04          	shl    $0x4,%rax
   40342:	48 05 00 40 05 00    	add    $0x54000,%rax
   40348:	be 00 00 00 00       	mov    $0x0,%esi
   4034d:	48 89 c7             	mov    %rax,%rdi
   40350:	e8 6e 1a 00 00       	callq  41dc3 <process_init>
    assert(process_config_tables(pid) == 0);
   40355:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40358:	89 c7                	mov    %eax,%edi
   4035a:	e8 47 3b 00 00       	callq  43ea6 <process_config_tables>
   4035f:	85 c0                	test   %eax,%eax
   40361:	74 14                	je     40377 <process_setup+0x57>
   40363:	ba 28 46 04 00       	mov    $0x44628,%edx
   40368:	be 7f 00 00 00       	mov    $0x7f,%esi
   4036d:	bf 48 46 04 00       	mov    $0x44648,%edi
   40372:	e8 14 22 00 00       	callq  4258b <assert_fail>

    /* Calls program_load in k-loader */
    assert(process_load(&processes[pid], program_number) >= 0);
   40377:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4037a:	48 63 d0             	movslq %eax,%rdx
   4037d:	48 89 d0             	mov    %rdx,%rax
   40380:	48 c1 e0 04          	shl    $0x4,%rax
   40384:	48 29 d0             	sub    %rdx,%rax
   40387:	48 c1 e0 04          	shl    $0x4,%rax
   4038b:	48 8d 90 00 40 05 00 	lea    0x54000(%rax),%rdx
   40392:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40395:	89 c6                	mov    %eax,%esi
   40397:	48 89 d7             	mov    %rdx,%rdi
   4039a:	e8 55 3e 00 00       	callq  441f4 <process_load>
   4039f:	85 c0                	test   %eax,%eax
   403a1:	79 14                	jns    403b7 <process_setup+0x97>
   403a3:	ba 58 46 04 00       	mov    $0x44658,%edx
   403a8:	be 82 00 00 00       	mov    $0x82,%esi
   403ad:	bf 48 46 04 00       	mov    $0x44648,%edi
   403b2:	e8 d4 21 00 00       	callq  4258b <assert_fail>

    process_setup_stack(&processes[pid]);
   403b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
   403ba:	48 63 d0             	movslq %eax,%rdx
   403bd:	48 89 d0             	mov    %rdx,%rax
   403c0:	48 c1 e0 04          	shl    $0x4,%rax
   403c4:	48 29 d0             	sub    %rdx,%rax
   403c7:	48 c1 e0 04          	shl    $0x4,%rax
   403cb:	48 05 00 40 05 00    	add    $0x54000,%rax
   403d1:	48 89 c7             	mov    %rax,%rdi
   403d4:	e8 53 3e 00 00       	callq  4422c <process_setup_stack>

    processes[pid].p_state = P_RUNNABLE;
   403d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   403dc:	48 63 d0             	movslq %eax,%rdx
   403df:	48 89 d0             	mov    %rdx,%rax
   403e2:	48 c1 e0 04          	shl    $0x4,%rax
   403e6:	48 29 d0             	sub    %rdx,%rax
   403e9:	48 c1 e0 04          	shl    $0x4,%rax
   403ed:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   403f3:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
}
   403f9:	90                   	nop
   403fa:	c9                   	leaveq 
   403fb:	c3                   	retq   

00000000000403fc <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   403fc:	55                   	push   %rbp
   403fd:	48 89 e5             	mov    %rsp,%rbp
   40400:	48 83 ec 10          	sub    $0x10,%rsp
   40404:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   40408:	89 f0                	mov    %esi,%eax
   4040a:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   4040d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40411:	25 ff 0f 00 00       	and    $0xfff,%eax
   40416:	48 85 c0             	test   %rax,%rax
   40419:	75 20                	jne    4043b <assign_physical_page+0x3f>
        || addr >= MEMSIZE_PHYSICAL
   4041b:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40422:	00 
   40423:	77 16                	ja     4043b <assign_physical_page+0x3f>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   40425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40429:	48 c1 e8 0c          	shr    $0xc,%rax
   4042d:	48 98                	cltq   
   4042f:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   40436:	00 
   40437:	84 c0                	test   %al,%al
   40439:	74 07                	je     40442 <assign_physical_page+0x46>
        return -1;
   4043b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40440:	eb 2c                	jmp    4046e <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   40442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40446:	48 c1 e8 0c          	shr    $0xc,%rax
   4044a:	48 98                	cltq   
   4044c:	c6 84 00 21 4f 05 00 	movb   $0x1,0x54f21(%rax,%rax,1)
   40453:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40458:	48 c1 e8 0c          	shr    $0xc,%rax
   4045c:	48 98                	cltq   
   4045e:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   40462:	88 94 00 20 4f 05 00 	mov    %dl,0x54f20(%rax,%rax,1)
        return 0;
   40469:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   4046e:	c9                   	leaveq 
   4046f:	c3                   	retq   

0000000000040470 <syscall_fork>:

pid_t syscall_fork() {
   40470:	55                   	push   %rbp
   40471:	48 89 e5             	mov    %rsp,%rbp
    return process_fork(current);
   40474:	48 8b 05 85 4a 01 00 	mov    0x14a85(%rip),%rax        # 54f00 <current>
   4047b:	48 89 c7             	mov    %rax,%rdi
   4047e:	e8 5c 3e 00 00       	callq  442df <process_fork>
}
   40483:	5d                   	pop    %rbp
   40484:	c3                   	retq   

0000000000040485 <syscall_exit>:


void syscall_exit() {
   40485:	55                   	push   %rbp
   40486:	48 89 e5             	mov    %rsp,%rbp
    process_free(current->p_pid);
   40489:	48 8b 05 70 4a 01 00 	mov    0x14a70(%rip),%rax        # 54f00 <current>
   40490:	8b 00                	mov    (%rax),%eax
   40492:	89 c7                	mov    %eax,%edi
   40494:	e8 2b 37 00 00       	callq  43bc4 <process_free>
}
   40499:	90                   	nop
   4049a:	5d                   	pop    %rbp
   4049b:	c3                   	retq   

000000000004049c <syscall_page_alloc>:

int syscall_page_alloc(uintptr_t addr) {
   4049c:	55                   	push   %rbp
   4049d:	48 89 e5             	mov    %rsp,%rbp
   404a0:	48 83 ec 10          	sub    $0x10,%rsp
   404a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return process_page_alloc(current, addr);
   404a8:	48 8b 05 51 4a 01 00 	mov    0x14a51(%rip),%rax        # 54f00 <current>
   404af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   404b3:	48 89 d6             	mov    %rdx,%rsi
   404b6:	48 89 c7             	mov    %rax,%rdi
   404b9:	e8 b3 40 00 00       	callq  44571 <process_page_alloc>
}
   404be:	c9                   	leaveq 
   404bf:	c3                   	retq   

00000000000404c0 <sbrk>:

int sbrk(proc *p, intptr_t difference) {
   404c0:	55                   	push   %rbp
   404c1:	48 89 e5             	mov    %rsp,%rbp
   404c4:	48 83 ec 70          	sub    $0x70,%rsp
   404c8:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
   404cc:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
    uintptr_t new_brk = p->program_break + difference;
   404d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   404d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
   404d8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
   404dc:	48 01 d0             	add    %rdx,%rax
   404df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (new_brk >= MEMSIZE_VIRTUAL - PAGESIZE || new_brk < p->original_break) return -1;
   404e3:	48 81 7d f0 ff ef 2f 	cmpq   $0x2fefff,-0x10(%rbp)
   404ea:	00 
   404eb:	77 0e                	ja     404fb <sbrk+0x3b>
   404ed:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   404f1:	48 8b 40 10          	mov    0x10(%rax),%rax
   404f5:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   404f9:	73 0a                	jae    40505 <sbrk+0x45>
   404fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40500:	e9 e6 00 00 00       	jmpq   405eb <sbrk+0x12b>
    if (difference < 0) {
   40505:	48 83 7d 90 00       	cmpq   $0x0,-0x70(%rbp)
   4050a:	0f 89 bf 00 00 00    	jns    405cf <sbrk+0x10f>
        uintptr_t start = ROUNDUP(new_brk, PAGESIZE), end = ROUNDDOWN(p->program_break, PAGESIZE);
   40510:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
   40517:	00 
   40518:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   4051c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40520:	48 01 d0             	add    %rdx,%rax
   40523:	48 83 e8 01          	sub    $0x1,%rax
   40527:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   4052b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4052f:	ba 00 00 00 00       	mov    $0x0,%edx
   40534:	48 f7 75 e8          	divq   -0x18(%rbp)
   40538:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4053c:	48 29 d0             	sub    %rdx,%rax
   4053f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
   40543:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40547:	48 8b 40 08          	mov    0x8(%rax),%rax
   4054b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
   4054f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40553:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40559:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        vamapping map;
        for (uintptr_t va = start; va <= end; va += PAGESIZE) {
   4055d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40561:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   40565:	eb 5e                	jmp    405c5 <sbrk+0x105>
            map = virtual_memory_lookup(p->p_pagetable, va);
   40567:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4056b:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40572:	48 8d 45 a8          	lea    -0x58(%rbp),%rax
   40576:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4057a:	48 89 ce             	mov    %rcx,%rsi
   4057d:	48 89 c7             	mov    %rax,%rdi
   40580:	e8 c8 26 00 00       	callq  42c4d <virtual_memory_lookup>
            if (map.pn >= 0) {
   40585:	8b 45 a8             	mov    -0x58(%rbp),%eax
   40588:	85 c0                	test   %eax,%eax
   4058a:	78 31                	js     405bd <sbrk+0xfd>
                unmap(map.pn); 
   4058c:	8b 45 a8             	mov    -0x58(%rbp),%eax
   4058f:	89 c7                	mov    %eax,%edi
   40591:	e8 d1 fb ff ff       	callq  40167 <unmap>
                virtual_memory_map(p->p_pagetable, va, 0, PAGESIZE, PTE_W | PTE_U);
   40596:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4059a:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   405a1:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   405a5:	41 b8 06 00 00 00    	mov    $0x6,%r8d
   405ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
   405b0:	ba 00 00 00 00       	mov    $0x0,%edx
   405b5:	48 89 c7             	mov    %rax,%rdi
   405b8:	e8 cd 22 00 00       	callq  4288a <virtual_memory_map>
        for (uintptr_t va = start; va <= end; va += PAGESIZE) {
   405bd:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   405c4:	00 
   405c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   405c9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
   405cd:	76 98                	jbe    40567 <sbrk+0xa7>
            }
        }
        
    }
    uintptr_t ret = p->program_break;
   405cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   405d3:	48 8b 40 08          	mov    0x8(%rax),%rax
   405d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    p->program_break = new_brk;
   405db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   405df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   405e3:	48 89 50 08          	mov    %rdx,0x8(%rax)
    return ret;
   405e7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
}
   405eb:	c9                   	leaveq 
   405ec:	c3                   	retq   

00000000000405ed <brk>:

int brk(proc *p, void *addr) {
   405ed:	55                   	push   %rbp
   405ee:	48 89 e5             	mov    %rsp,%rbp
   405f1:	48 83 ec 10          	sub    $0x10,%rsp
   405f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   405f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    return sbrk(p, (uintptr_t) addr - p->program_break) == -1 ? -1 : 0;
   405fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40605:	48 8b 48 08          	mov    0x8(%rax),%rcx
   40609:	48 89 d0             	mov    %rdx,%rax
   4060c:	48 29 c8             	sub    %rcx,%rax
   4060f:	48 89 c2             	mov    %rax,%rdx
   40612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40616:	48 89 d6             	mov    %rdx,%rsi
   40619:	48 89 c7             	mov    %rax,%rdi
   4061c:	e8 9f fe ff ff       	callq  404c0 <sbrk>
   40621:	83 f8 ff             	cmp    $0xffffffff,%eax
   40624:	75 07                	jne    4062d <brk+0x40>
   40626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4062b:	eb 05                	jmp    40632 <brk+0x45>
   4062d:	b8 00 00 00 00       	mov    $0x0,%eax
}
   40632:	c9                   	leaveq 
   40633:	c3                   	retq   

0000000000040634 <syscall_mapping>:

void syscall_mapping(proc* p){
   40634:	55                   	push   %rbp
   40635:	48 89 e5             	mov    %rsp,%rbp
   40638:	48 83 ec 70          	sub    $0x70,%rsp
   4063c:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)

    uintptr_t mapping_ptr = p->p_registers.reg_rdi;
   40640:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40644:	48 8b 40 48          	mov    0x48(%rax),%rax
   40648:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    uintptr_t ptr = p->p_registers.reg_rsi;
   4064c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40650:	48 8b 40 40          	mov    0x40(%rax),%rax
   40654:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

    //convert to physical address so kernel can write to it
    vamapping map = virtual_memory_lookup(p->p_pagetable, mapping_ptr);
   40658:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4065c:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40663:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   40667:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4066b:	48 89 ce             	mov    %rcx,%rsi
   4066e:	48 89 c7             	mov    %rax,%rdi
   40671:	e8 d7 25 00 00       	callq  42c4d <virtual_memory_lookup>

    // check for write access
    if((map.perm & (PTE_W|PTE_U)) != (PTE_W|PTE_U))
   40676:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40679:	48 98                	cltq   
   4067b:	83 e0 06             	and    $0x6,%eax
   4067e:	48 83 f8 06          	cmp    $0x6,%rax
   40682:	75 73                	jne    406f7 <syscall_mapping+0xc3>
	return;
    uintptr_t endaddr = map.pa + sizeof(vamapping) - 1;
   40684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40688:	48 83 c0 17          	add    $0x17,%rax
   4068c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    // check for write access for end address
    vamapping end_map = virtual_memory_lookup(p->p_pagetable, endaddr);
   40690:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40694:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   4069b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   4069f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   406a3:	48 89 ce             	mov    %rcx,%rsi
   406a6:	48 89 c7             	mov    %rax,%rdi
   406a9:	e8 9f 25 00 00       	callq  42c4d <virtual_memory_lookup>
    if((end_map.perm & (PTE_W|PTE_P)) != (PTE_W|PTE_P))
   406ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
   406b1:	48 98                	cltq   
   406b3:	83 e0 03             	and    $0x3,%eax
   406b6:	48 83 f8 03          	cmp    $0x3,%rax
   406ba:	75 3e                	jne    406fa <syscall_mapping+0xc6>
	return;
    // find the actual mapping now
    vamapping ptr_lookup = virtual_memory_lookup(p->p_pagetable, ptr);
   406bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   406c0:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   406c7:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   406cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   406cf:	48 89 ce             	mov    %rcx,%rsi
   406d2:	48 89 c7             	mov    %rax,%rdi
   406d5:	e8 73 25 00 00       	callq  42c4d <virtual_memory_lookup>
    memcpy((void *)map.pa, &ptr_lookup, sizeof(vamapping));
   406da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   406de:	48 89 c1             	mov    %rax,%rcx
   406e1:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   406e5:	ba 18 00 00 00       	mov    $0x18,%edx
   406ea:	48 89 c6             	mov    %rax,%rsi
   406ed:	48 89 cf             	mov    %rcx,%rdi
   406f0:	e8 41 2a 00 00       	callq  43136 <memcpy>
   406f5:	eb 04                	jmp    406fb <syscall_mapping+0xc7>
	return;
   406f7:	90                   	nop
   406f8:	eb 01                	jmp    406fb <syscall_mapping+0xc7>
	return;
   406fa:	90                   	nop
}
   406fb:	c9                   	leaveq 
   406fc:	c3                   	retq   

00000000000406fd <syscall_mem_tog>:

void syscall_mem_tog(proc* process){
   406fd:	55                   	push   %rbp
   406fe:	48 89 e5             	mov    %rsp,%rbp
   40701:	48 83 ec 18          	sub    $0x18,%rsp
   40705:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

    pid_t p = process->p_registers.reg_rdi;
   40709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4070d:	48 8b 40 48          	mov    0x48(%rax),%rax
   40711:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(p == 0) {
   40714:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   40718:	75 14                	jne    4072e <syscall_mem_tog+0x31>
        disp_global = !disp_global;
   4071a:	0f b6 05 df 58 00 00 	movzbl 0x58df(%rip),%eax        # 46000 <disp_global>
   40721:	84 c0                	test   %al,%al
   40723:	0f 94 c0             	sete   %al
   40726:	88 05 d4 58 00 00    	mov    %al,0x58d4(%rip)        # 46000 <disp_global>
   4072c:	eb 36                	jmp    40764 <syscall_mem_tog+0x67>
    }
    else {
        if(p < 0 || p > NPROC || p != process->p_pid)
   4072e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   40732:	78 2f                	js     40763 <syscall_mem_tog+0x66>
   40734:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   40738:	7f 29                	jg     40763 <syscall_mem_tog+0x66>
   4073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4073e:	8b 00                	mov    (%rax),%eax
   40740:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   40743:	75 1e                	jne    40763 <syscall_mem_tog+0x66>
            return;
        process->display_status = !(process->display_status);
   40745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40749:	0f b6 80 e8 00 00 00 	movzbl 0xe8(%rax),%eax
   40750:	84 c0                	test   %al,%al
   40752:	0f 94 c0             	sete   %al
   40755:	89 c2                	mov    %eax,%edx
   40757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4075b:	88 90 e8 00 00 00    	mov    %dl,0xe8(%rax)
   40761:	eb 01                	jmp    40764 <syscall_mem_tog+0x67>
            return;
   40763:	90                   	nop
    }
}
   40764:	c9                   	leaveq 
   40765:	c3                   	retq   

0000000000040766 <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   40766:	55                   	push   %rbp
   40767:	48 89 e5             	mov    %rsp,%rbp
   4076a:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
   40771:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40778:	48 8b 05 81 47 01 00 	mov    0x14781(%rip),%rax        # 54f00 <current>
   4077f:	48 8b 95 e8 fe ff ff 	mov    -0x118(%rbp),%rdx
   40786:	48 83 c0 18          	add    $0x18,%rax
   4078a:	48 89 d6             	mov    %rdx,%rsi
   4078d:	ba 18 00 00 00       	mov    $0x18,%edx
   40792:	48 89 c7             	mov    %rax,%rdi
   40795:	48 89 d1             	mov    %rdx,%rcx
   40798:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   4079b:	48 8b 05 5e 68 01 00 	mov    0x1685e(%rip),%rax        # 57000 <kernel_pagetable>
   407a2:	48 89 c7             	mov    %rax,%rdi
   407a5:	e8 af 1f 00 00       	callq  42759 <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   407aa:	8b 05 4c 88 07 00    	mov    0x7884c(%rip),%eax        # b8ffc <cursorpos>
   407b0:	89 c7                	mov    %eax,%edi
   407b2:	e8 d6 16 00 00       	callq  41e8d <console_show_cursor>
    if ((reg->reg_intno != INT_PAGEFAULT
   407b7:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   407be:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   407c5:	48 83 f8 0e          	cmp    $0xe,%rax
   407c9:	74 14                	je     407df <exception+0x79>
	    && reg->reg_intno != INT_GPF)
   407cb:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   407d2:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   407d9:	48 83 f8 0d          	cmp    $0xd,%rax
   407dd:	75 16                	jne    407f5 <exception+0x8f>
            || (reg->reg_err & PFERR_USER)) {
   407df:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   407e6:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   407ed:	83 e0 04             	and    $0x4,%eax
   407f0:	48 85 c0             	test   %rax,%rax
   407f3:	74 1a                	je     4080f <exception+0xa9>
        check_virtual_memory();
   407f5:	e8 67 08 00 00       	callq  41061 <check_virtual_memory>
        if(disp_global){
   407fa:	0f b6 05 ff 57 00 00 	movzbl 0x57ff(%rip),%eax        # 46000 <disp_global>
   40801:	84 c0                	test   %al,%al
   40803:	74 0a                	je     4080f <exception+0xa9>
            memshow_physical();
   40805:	e8 cf 09 00 00       	callq  411d9 <memshow_physical>
            memshow_virtual_animate();
   4080a:	e8 f5 0c 00 00       	callq  41504 <memshow_virtual_animate>
        }
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   4080f:	e8 56 1b 00 00       	callq  4236a <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   40814:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   4081b:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40822:	48 83 e8 0e          	sub    $0xe,%rax
   40826:	48 83 f8 2c          	cmp    $0x2c,%rax
   4082a:	0f 87 5c 03 00 00    	ja     40b8c <exception+0x426>
   40830:	48 8b 04 c5 18 47 04 	mov    0x44718(,%rax,8),%rax
   40837:	00 
   40838:	ff e0                	jmpq   *%rax
        case INT_SYS_PANIC:
            {
                // rdi stores pointer for msg string
                {
                    char msg[160];
                    uintptr_t addr = current->p_registers.reg_rdi;
   4083a:	48 8b 05 bf 46 01 00 	mov    0x146bf(%rip),%rax        # 54f00 <current>
   40841:	48 8b 40 48          	mov    0x48(%rax),%rax
   40845:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
                    if((void *)addr == NULL)
   40849:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   4084e:	75 0f                	jne    4085f <exception+0xf9>
                        kernel_panic(NULL);
   40850:	bf 00 00 00 00       	mov    $0x0,%edi
   40855:	b8 00 00 00 00       	mov    $0x0,%eax
   4085a:	e8 4c 1c 00 00       	callq  424ab <kernel_panic>
                    vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   4085f:	48 8b 05 9a 46 01 00 	mov    0x1469a(%rip),%rax        # 54f00 <current>
   40866:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   4086d:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   40871:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   40875:	48 89 ce             	mov    %rcx,%rsi
   40878:	48 89 c7             	mov    %rax,%rdi
   4087b:	e8 cd 23 00 00       	callq  42c4d <virtual_memory_lookup>
                    memcpy(msg, (void *)map.pa, 160);
   40880:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40884:	48 89 c1             	mov    %rax,%rcx
   40887:	48 8d 85 f8 fe ff ff 	lea    -0x108(%rbp),%rax
   4088e:	ba a0 00 00 00       	mov    $0xa0,%edx
   40893:	48 89 ce             	mov    %rcx,%rsi
   40896:	48 89 c7             	mov    %rax,%rdi
   40899:	e8 98 28 00 00       	callq  43136 <memcpy>
                    kernel_panic(msg);
   4089e:	48 8d 85 f8 fe ff ff 	lea    -0x108(%rbp),%rax
   408a5:	48 89 c7             	mov    %rax,%rdi
   408a8:	b8 00 00 00 00       	mov    $0x0,%eax
   408ad:	e8 f9 1b 00 00       	callq  424ab <kernel_panic>
                kernel_panic(NULL);
                break;                  // will not be reached
            }
        case INT_SYS_GETPID:
            {
                current->p_registers.reg_rax = current->p_pid;
   408b2:	48 8b 05 47 46 01 00 	mov    0x14647(%rip),%rax        # 54f00 <current>
   408b9:	8b 10                	mov    (%rax),%edx
   408bb:	48 8b 05 3e 46 01 00 	mov    0x1463e(%rip),%rax        # 54f00 <current>
   408c2:	48 63 d2             	movslq %edx,%rdx
   408c5:	48 89 50 18          	mov    %rdx,0x18(%rax)
                break;
   408c9:	e9 d0 02 00 00       	jmpq   40b9e <exception+0x438>
            }
        case INT_SYS_FORK:
            {
                current->p_registers.reg_rax = syscall_fork();
   408ce:	b8 00 00 00 00       	mov    $0x0,%eax
   408d3:	e8 98 fb ff ff       	callq  40470 <syscall_fork>
   408d8:	89 c2                	mov    %eax,%edx
   408da:	48 8b 05 1f 46 01 00 	mov    0x1461f(%rip),%rax        # 54f00 <current>
   408e1:	48 63 d2             	movslq %edx,%rdx
   408e4:	48 89 50 18          	mov    %rdx,0x18(%rax)
                break;
   408e8:	e9 b1 02 00 00       	jmpq   40b9e <exception+0x438>
            }
        case INT_SYS_MAPPING:
            {
                syscall_mapping(current);
   408ed:	48 8b 05 0c 46 01 00 	mov    0x1460c(%rip),%rax        # 54f00 <current>
   408f4:	48 89 c7             	mov    %rax,%rdi
   408f7:	e8 38 fd ff ff       	callq  40634 <syscall_mapping>
                break;
   408fc:	e9 9d 02 00 00       	jmpq   40b9e <exception+0x438>
            }

        case INT_SYS_EXIT:
            {
                syscall_exit();
   40901:	b8 00 00 00 00       	mov    $0x0,%eax
   40906:	e8 7a fb ff ff       	callq  40485 <syscall_exit>
                schedule();
   4090b:	e8 b7 02 00 00       	callq  40bc7 <schedule>
                break;
   40910:	e9 89 02 00 00       	jmpq   40b9e <exception+0x438>
            }

        case INT_SYS_YIELD:
            {
                schedule();
   40915:	e8 ad 02 00 00       	callq  40bc7 <schedule>
                break;                  /* will not be reached */
   4091a:	e9 7f 02 00 00       	jmpq   40b9e <exception+0x438>
            }

        case INT_SYS_BRK:
            {
                // TODO : Your code here
                void *addr = (void *) reg->reg_rdi;
   4091f:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40926:	48 8b 40 30          	mov    0x30(%rax),%rax
   4092a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                current->p_registers.reg_rax = brk(current, addr); 
   4092e:	48 8b 05 cb 45 01 00 	mov    0x145cb(%rip),%rax        # 54f00 <current>
   40935:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40939:	48 89 d6             	mov    %rdx,%rsi
   4093c:	48 89 c7             	mov    %rax,%rdi
   4093f:	e8 a9 fc ff ff       	callq  405ed <brk>
   40944:	89 c2                	mov    %eax,%edx
   40946:	48 8b 05 b3 45 01 00 	mov    0x145b3(%rip),%rax        # 54f00 <current>
   4094d:	48 63 d2             	movslq %edx,%rdx
   40950:	48 89 50 18          	mov    %rdx,0x18(%rax)
		        break;
   40954:	e9 45 02 00 00       	jmpq   40b9e <exception+0x438>
            }

        case INT_SYS_SBRK:
            {
                // TODO : Your code here
                intptr_t diff = (intptr_t) reg->reg_rdi;
   40959:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40960:	48 8b 40 30          	mov    0x30(%rax),%rax
   40964:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
                current->p_registers.reg_rax = sbrk(current, diff); 
   40968:	48 8b 05 91 45 01 00 	mov    0x14591(%rip),%rax        # 54f00 <current>
   4096f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40973:	48 89 d6             	mov    %rdx,%rsi
   40976:	48 89 c7             	mov    %rax,%rdi
   40979:	e8 42 fb ff ff       	callq  404c0 <sbrk>
   4097e:	89 c2                	mov    %eax,%edx
   40980:	48 8b 05 79 45 01 00 	mov    0x14579(%rip),%rax        # 54f00 <current>
   40987:	48 63 d2             	movslq %edx,%rdx
   4098a:	48 89 50 18          	mov    %rdx,0x18(%rax)
                break;
   4098e:	e9 0b 02 00 00       	jmpq   40b9e <exception+0x438>
            }
	case INT_SYS_PAGE_ALLOC:
	    {
		intptr_t addr = reg->reg_rdi;
   40993:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   4099a:	48 8b 40 30          	mov    0x30(%rax),%rax
   4099e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		syscall_page_alloc(addr);
   409a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   409a6:	48 89 c7             	mov    %rax,%rdi
   409a9:	e8 ee fa ff ff       	callq  4049c <syscall_page_alloc>
		break;
   409ae:	e9 eb 01 00 00       	jmpq   40b9e <exception+0x438>
	    }
        case INT_SYS_MEM_TOG:
            {
                syscall_mem_tog(current);
   409b3:	48 8b 05 46 45 01 00 	mov    0x14546(%rip),%rax        # 54f00 <current>
   409ba:	48 89 c7             	mov    %rax,%rdi
   409bd:	e8 3b fd ff ff       	callq  406fd <syscall_mem_tog>
                break;
   409c2:	e9 d7 01 00 00       	jmpq   40b9e <exception+0x438>
            }

        case INT_TIMER:
            {
                ++ticks;
   409c7:	8b 05 53 49 01 00    	mov    0x14953(%rip),%eax        # 55320 <ticks>
   409cd:	83 c0 01             	add    $0x1,%eax
   409d0:	89 05 4a 49 01 00    	mov    %eax,0x1494a(%rip)        # 55320 <ticks>
                schedule();
   409d6:	e8 ec 01 00 00       	callq  40bc7 <schedule>
                break;                  /* will not be reached */
   409db:	e9 be 01 00 00       	jmpq   40b9e <exception+0x438>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   409e0:	0f 20 d0             	mov    %cr2,%rax
   409e3:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    return val;
   409e7:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
            }

        case INT_PAGEFAULT: 
            {
                // Analyze faulting address and access type.
                uintptr_t addr = rcr2();
   409eb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
                addr &= ~(PAGESIZE - 1);
   409ef:	48 81 65 d8 00 f0 ff 	andq   $0xfffffffffffff000,-0x28(%rbp)
   409f6:	ff 
                int in_heap = addr >= current->original_break && addr <= current->program_break;
   409f7:	48 8b 05 02 45 01 00 	mov    0x14502(%rip),%rax        # 54f00 <current>
   409fe:	48 8b 40 10          	mov    0x10(%rax),%rax
   40a02:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
   40a06:	72 18                	jb     40a20 <exception+0x2ba>
   40a08:	48 8b 05 f1 44 01 00 	mov    0x144f1(%rip),%rax        # 54f00 <current>
   40a0f:	48 8b 40 08          	mov    0x8(%rax),%rax
   40a13:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
   40a17:	77 07                	ja     40a20 <exception+0x2ba>
   40a19:	b8 01 00 00 00       	mov    $0x1,%eax
   40a1e:	eb 05                	jmp    40a25 <exception+0x2bf>
   40a20:	b8 00 00 00 00       	mov    $0x0,%eax
   40a25:	89 45 d4             	mov    %eax,-0x2c(%rbp)
                const char* operation = reg->reg_err & PFERR_WRITE
   40a28:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40a2f:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40a36:	83 e0 02             	and    $0x2,%eax
                    ? "write" : "read";
   40a39:	48 85 c0             	test   %rax,%rax
   40a3c:	74 07                	je     40a45 <exception+0x2df>
   40a3e:	b8 8b 46 04 00       	mov    $0x4468b,%eax
   40a43:	eb 05                	jmp    40a4a <exception+0x2e4>
   40a45:	b8 91 46 04 00       	mov    $0x44691,%eax
                const char* operation = reg->reg_err & PFERR_WRITE
   40a4a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                const char* problem = reg->reg_err & PFERR_PRESENT
   40a4e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40a55:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40a5c:	83 e0 01             	and    $0x1,%eax
                    ? "protection problem" : "missing page";
   40a5f:	48 85 c0             	test   %rax,%rax
   40a62:	74 07                	je     40a6b <exception+0x305>
   40a64:	b8 96 46 04 00       	mov    $0x44696,%eax
   40a69:	eb 05                	jmp    40a70 <exception+0x30a>
   40a6b:	b8 a9 46 04 00       	mov    $0x446a9,%eax
                const char* problem = reg->reg_err & PFERR_PRESENT
   40a70:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

                if (!(reg->reg_err & PFERR_USER)) {
   40a74:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40a7b:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40a82:	83 e0 04             	and    $0x4,%eax
   40a85:	48 85 c0             	test   %rax,%rax
   40a88:	75 2f                	jne    40ab9 <exception+0x353>
                    kernel_panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40a8a:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40a91:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40a98:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   40a9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   40aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40aa4:	49 89 f0             	mov    %rsi,%r8
   40aa7:	48 89 c6             	mov    %rax,%rsi
   40aaa:	bf b8 46 04 00       	mov    $0x446b8,%edi
   40aaf:	b8 00 00 00 00       	mov    $0x0,%eax
   40ab4:	e8 f2 19 00 00       	callq  424ab <kernel_panic>
                            addr, operation, problem, reg->reg_rip);
                }

                if (!in_heap) {
   40ab9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   40abd:	75 63                	jne    40b22 <exception+0x3bc>
                    console_printf(CPOS(24, 0), 0x0C00,
   40abf:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40ac6:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                            "Process %d page fault for %p (%s %s, rip=%p)!\n",
                            current->p_pid, addr, operation, problem, reg->reg_rip);
   40acd:	48 8b 05 2c 44 01 00 	mov    0x1442c(%rip),%rax        # 54f00 <current>
                    console_printf(CPOS(24, 0), 0x0C00,
   40ad4:	8b 00                	mov    (%rax),%eax
   40ad6:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
   40ada:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
   40ade:	52                   	push   %rdx
   40adf:	ff 75 c0             	pushq  -0x40(%rbp)
   40ae2:	49 89 f1             	mov    %rsi,%r9
   40ae5:	49 89 c8             	mov    %rcx,%r8
   40ae8:	89 c1                	mov    %eax,%ecx
   40aea:	ba e8 46 04 00       	mov    $0x446e8,%edx
   40aef:	be 00 0c 00 00       	mov    $0xc00,%esi
   40af4:	bf 80 07 00 00       	mov    $0x780,%edi
   40af9:	b8 00 00 00 00       	mov    $0x0,%eax
   40afe:	e8 d1 2e 00 00       	callq  439d4 <console_printf>
   40b03:	48 83 c4 10          	add    $0x10,%rsp
                    current->p_state = P_BROKEN;
   40b07:	48 8b 05 f2 43 01 00 	mov    0x143f2(%rip),%rax        # 54f00 <current>
   40b0e:	c7 80 d8 00 00 00 03 	movl   $0x3,0xd8(%rax)
   40b15:	00 00 00 
                    syscall_exit();
   40b18:	b8 00 00 00 00       	mov    $0x0,%eax
   40b1d:	e8 63 f9 ff ff       	callq  40485 <syscall_exit>
                }

                if (in_heap && strcmp(problem, "missing page") == 0) {
   40b22:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   40b26:	74 75                	je     40b9d <exception+0x437>
   40b28:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40b2c:	be a9 46 04 00       	mov    $0x446a9,%esi
   40b31:	48 89 c7             	mov    %rax,%rdi
   40b34:	e8 d7 26 00 00       	callq  43210 <strcmp>
   40b39:	85 c0                	test   %eax,%eax
   40b3b:	75 60                	jne    40b9d <exception+0x437>
                    int pa = process_page_alloc(current, addr);
   40b3d:	48 8b 05 bc 43 01 00 	mov    0x143bc(%rip),%rax        # 54f00 <current>
   40b44:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   40b48:	48 89 d6             	mov    %rdx,%rsi
   40b4b:	48 89 c7             	mov    %rax,%rdi
   40b4e:	e8 1e 3a 00 00       	callq  44571 <process_page_alloc>
   40b53:	89 45 bc             	mov    %eax,-0x44(%rbp)
                    if (pa < 0) {
   40b56:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
   40b5a:	79 1d                	jns    40b79 <exception+0x413>
                        current->p_state = P_BROKEN;
   40b5c:	48 8b 05 9d 43 01 00 	mov    0x1439d(%rip),%rax        # 54f00 <current>
   40b63:	c7 80 d8 00 00 00 03 	movl   $0x3,0xd8(%rax)
   40b6a:	00 00 00 
                        syscall_exit();
   40b6d:	b8 00 00 00 00       	mov    $0x0,%eax
   40b72:	e8 0e f9 ff ff       	callq  40485 <syscall_exit>
                    } else current->p_state = P_RUNNABLE;
                }
                
                break;
   40b77:	eb 24                	jmp    40b9d <exception+0x437>
                    } else current->p_state = P_RUNNABLE;
   40b79:	48 8b 05 80 43 01 00 	mov    0x14380(%rip),%rax        # 54f00 <current>
   40b80:	c7 80 d8 00 00 00 01 	movl   $0x1,0xd8(%rax)
   40b87:	00 00 00 
                break;
   40b8a:	eb 11                	jmp    40b9d <exception+0x437>
            }

        default:
            default_exception(current);
   40b8c:	48 8b 05 6d 43 01 00 	mov    0x1436d(%rip),%rax        # 54f00 <current>
   40b93:	48 89 c7             	mov    %rax,%rdi
   40b96:	e8 20 1a 00 00       	callq  425bb <default_exception>
            break;                  /* will not be reached */
   40b9b:	eb 01                	jmp    40b9e <exception+0x438>
                break;
   40b9d:	90                   	nop

    }

    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   40b9e:	48 8b 05 5b 43 01 00 	mov    0x1435b(%rip),%rax        # 54f00 <current>
   40ba5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
   40bab:	83 f8 01             	cmp    $0x1,%eax
   40bae:	75 0f                	jne    40bbf <exception+0x459>
        run(current);
   40bb0:	48 8b 05 49 43 01 00 	mov    0x14349(%rip),%rax        # 54f00 <current>
   40bb7:	48 89 c7             	mov    %rax,%rdi
   40bba:	e8 7a 00 00 00       	callq  40c39 <run>
    } else {
        schedule();
   40bbf:	e8 03 00 00 00       	callq  40bc7 <schedule>
    }
}
   40bc4:	90                   	nop
   40bc5:	c9                   	leaveq 
   40bc6:	c3                   	retq   

0000000000040bc7 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   40bc7:	55                   	push   %rbp
   40bc8:	48 89 e5             	mov    %rsp,%rbp
   40bcb:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   40bcf:	48 8b 05 2a 43 01 00 	mov    0x1432a(%rip),%rax        # 54f00 <current>
   40bd6:	8b 00                	mov    (%rax),%eax
   40bd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   40bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bde:	83 c0 01             	add    $0x1,%eax
   40be1:	99                   	cltd   
   40be2:	c1 ea 1c             	shr    $0x1c,%edx
   40be5:	01 d0                	add    %edx,%eax
   40be7:	83 e0 0f             	and    $0xf,%eax
   40bea:	29 d0                	sub    %edx,%eax
   40bec:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   40bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bf2:	48 63 d0             	movslq %eax,%rdx
   40bf5:	48 89 d0             	mov    %rdx,%rax
   40bf8:	48 c1 e0 04          	shl    $0x4,%rax
   40bfc:	48 29 d0             	sub    %rdx,%rax
   40bff:	48 c1 e0 04          	shl    $0x4,%rax
   40c03:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   40c09:	8b 00                	mov    (%rax),%eax
   40c0b:	83 f8 01             	cmp    $0x1,%eax
   40c0e:	75 22                	jne    40c32 <schedule+0x6b>
            run(&processes[pid]);
   40c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c13:	48 63 d0             	movslq %eax,%rdx
   40c16:	48 89 d0             	mov    %rdx,%rax
   40c19:	48 c1 e0 04          	shl    $0x4,%rax
   40c1d:	48 29 d0             	sub    %rdx,%rax
   40c20:	48 c1 e0 04          	shl    $0x4,%rax
   40c24:	48 05 00 40 05 00    	add    $0x54000,%rax
   40c2a:	48 89 c7             	mov    %rax,%rdi
   40c2d:	e8 07 00 00 00       	callq  40c39 <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   40c32:	e8 33 17 00 00       	callq  4236a <check_keyboard>
        pid = (pid + 1) % NPROC;
   40c37:	eb a2                	jmp    40bdb <schedule+0x14>

0000000000040c39 <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   40c39:	55                   	push   %rbp
   40c3a:	48 89 e5             	mov    %rsp,%rbp
   40c3d:	48 83 ec 10          	sub    $0x10,%rsp
   40c41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   40c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c49:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
   40c4f:	83 f8 01             	cmp    $0x1,%eax
   40c52:	74 14                	je     40c68 <run+0x2f>
   40c54:	ba 80 48 04 00       	mov    $0x44880,%edx
   40c59:	be a4 01 00 00       	mov    $0x1a4,%esi
   40c5e:	bf 48 46 04 00       	mov    $0x44648,%edi
   40c63:	e8 23 19 00 00       	callq  4258b <assert_fail>
    current = p;
   40c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c6c:	48 89 05 8d 42 01 00 	mov    %rax,0x1428d(%rip)        # 54f00 <current>

    // display running process in CONSOLE last value
    console_printf(CPOS(24, 79),
   40c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c77:	8b 10                	mov    (%rax),%edx
            memstate_colors[p->p_pid - PO_KERNEL], "%d", p->p_pid);
   40c79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c7d:	8b 00                	mov    (%rax),%eax
   40c7f:	83 c0 02             	add    $0x2,%eax
   40c82:	48 98                	cltq   
   40c84:	0f b7 84 00 e0 45 04 	movzwl 0x445e0(%rax,%rax,1),%eax
   40c8b:	00 
    console_printf(CPOS(24, 79),
   40c8c:	0f b7 c0             	movzwl %ax,%eax
   40c8f:	89 d1                	mov    %edx,%ecx
   40c91:	ba 99 48 04 00       	mov    $0x44899,%edx
   40c96:	89 c6                	mov    %eax,%esi
   40c98:	bf cf 07 00 00       	mov    $0x7cf,%edi
   40c9d:	b8 00 00 00 00       	mov    $0x0,%eax
   40ca2:	e8 2d 2d 00 00       	callq  439d4 <console_printf>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   40ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40cab:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   40cb2:	48 89 c7             	mov    %rax,%rdi
   40cb5:	e8 9f 1a 00 00       	callq  42759 <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   40cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40cbe:	48 83 c0 18          	add    $0x18,%rax
   40cc2:	48 89 c7             	mov    %rax,%rdi
   40cc5:	e8 f9 f3 ff ff       	callq  400c3 <exception_return>

0000000000040cca <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   40cca:	55                   	push   %rbp
   40ccb:	48 89 e5             	mov    %rsp,%rbp
   40cce:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40cd2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   40cd9:	00 
   40cda:	e9 81 00 00 00       	jmpq   40d60 <pageinfo_init+0x96>
        int owner;
        if (physical_memory_isreserved(addr)) {
   40cdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40ce3:	48 89 c7             	mov    %rax,%rdi
   40ce6:	e8 13 0f 00 00       	callq  41bfe <physical_memory_isreserved>
   40ceb:	85 c0                	test   %eax,%eax
   40ced:	74 09                	je     40cf8 <pageinfo_init+0x2e>
            owner = PO_RESERVED;
   40cef:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   40cf6:	eb 2f                	jmp    40d27 <pageinfo_init+0x5d>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   40cf8:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   40cff:	00 
   40d00:	76 0b                	jbe    40d0d <pageinfo_init+0x43>
   40d02:	b8 10 d0 05 00       	mov    $0x5d010,%eax
   40d07:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40d0b:	72 0a                	jb     40d17 <pageinfo_init+0x4d>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   40d0d:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   40d14:	00 
   40d15:	75 09                	jne    40d20 <pageinfo_init+0x56>
            owner = PO_KERNEL;
   40d17:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   40d1e:	eb 07                	jmp    40d27 <pageinfo_init+0x5d>
        } else {
            owner = PO_FREE;
   40d20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d2b:	48 c1 e8 0c          	shr    $0xc,%rax
   40d2f:	89 c1                	mov    %eax,%ecx
   40d31:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40d34:	89 c2                	mov    %eax,%edx
   40d36:	48 63 c1             	movslq %ecx,%rax
   40d39:	88 94 00 20 4f 05 00 	mov    %dl,0x54f20(%rax,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   40d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   40d44:	0f 95 c2             	setne  %dl
   40d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d4b:	48 c1 e8 0c          	shr    $0xc,%rax
   40d4f:	48 98                	cltq   
   40d51:	88 94 00 21 4f 05 00 	mov    %dl,0x54f21(%rax,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40d58:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40d5f:	00 
   40d60:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40d67:	00 
   40d68:	0f 86 71 ff ff ff    	jbe    40cdf <pageinfo_init+0x15>
    }
}
   40d6e:	90                   	nop
   40d6f:	90                   	nop
   40d70:	c9                   	leaveq 
   40d71:	c3                   	retq   

0000000000040d72 <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   40d72:	55                   	push   %rbp
   40d73:	48 89 e5             	mov    %rsp,%rbp
   40d76:	48 83 ec 50          	sub    $0x50,%rsp
   40d7a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   40d7e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40d82:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40d88:	48 89 c2             	mov    %rax,%rdx
   40d8b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40d8f:	48 39 c2             	cmp    %rax,%rdx
   40d92:	74 14                	je     40da8 <check_page_table_mappings+0x36>
   40d94:	ba a0 48 04 00       	mov    $0x448a0,%edx
   40d99:	be d2 01 00 00       	mov    $0x1d2,%esi
   40d9e:	bf 48 46 04 00       	mov    $0x44648,%edi
   40da3:	e8 e3 17 00 00       	callq  4258b <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40da8:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   40daf:	00 
   40db0:	e9 9a 00 00 00       	jmpq   40e4f <check_page_table_mappings+0xdd>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   40db5:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   40db9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40dbd:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40dc1:	48 89 ce             	mov    %rcx,%rsi
   40dc4:	48 89 c7             	mov    %rax,%rdi
   40dc7:	e8 81 1e 00 00       	callq  42c4d <virtual_memory_lookup>
        if (vam.pa != va) {
   40dcc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40dd0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40dd4:	74 27                	je     40dfd <check_page_table_mappings+0x8b>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   40dd6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   40dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40dde:	49 89 d0             	mov    %rdx,%r8
   40de1:	48 89 c1             	mov    %rax,%rcx
   40de4:	ba bf 48 04 00       	mov    $0x448bf,%edx
   40de9:	be 00 c0 00 00       	mov    $0xc000,%esi
   40dee:	bf e0 06 00 00       	mov    $0x6e0,%edi
   40df3:	b8 00 00 00 00       	mov    $0x0,%eax
   40df8:	e8 d7 2b 00 00       	callq  439d4 <console_printf>
        }
        assert(vam.pa == va);
   40dfd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40e01:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e05:	74 14                	je     40e1b <check_page_table_mappings+0xa9>
   40e07:	ba c9 48 04 00       	mov    $0x448c9,%edx
   40e0c:	be db 01 00 00       	mov    $0x1db,%esi
   40e11:	bf 48 46 04 00       	mov    $0x44648,%edi
   40e16:	e8 70 17 00 00       	callq  4258b <assert_fail>
        if (va >= (uintptr_t) start_data) {
   40e1b:	b8 00 60 04 00       	mov    $0x46000,%eax
   40e20:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e24:	72 21                	jb     40e47 <check_page_table_mappings+0xd5>
            assert(vam.perm & PTE_W);
   40e26:	8b 45 d0             	mov    -0x30(%rbp),%eax
   40e29:	48 98                	cltq   
   40e2b:	83 e0 02             	and    $0x2,%eax
   40e2e:	48 85 c0             	test   %rax,%rax
   40e31:	75 14                	jne    40e47 <check_page_table_mappings+0xd5>
   40e33:	ba d6 48 04 00       	mov    $0x448d6,%edx
   40e38:	be dd 01 00 00       	mov    $0x1dd,%esi
   40e3d:	bf 48 46 04 00       	mov    $0x44648,%edi
   40e42:	e8 44 17 00 00       	callq  4258b <assert_fail>
         va += PAGESIZE) {
   40e47:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40e4e:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40e4f:	b8 10 d0 05 00       	mov    $0x5d010,%eax
   40e54:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e58:	0f 82 57 ff ff ff    	jb     40db5 <check_page_table_mappings+0x43>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   40e5e:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   40e65:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   40e66:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   40e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40e6e:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40e72:	48 89 ce             	mov    %rcx,%rsi
   40e75:	48 89 c7             	mov    %rax,%rdi
   40e78:	e8 d0 1d 00 00       	callq  42c4d <virtual_memory_lookup>
    assert(vam.pa == kstack);
   40e7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40e81:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   40e85:	74 14                	je     40e9b <check_page_table_mappings+0x129>
   40e87:	ba e7 48 04 00       	mov    $0x448e7,%edx
   40e8c:	be e4 01 00 00       	mov    $0x1e4,%esi
   40e91:	bf 48 46 04 00       	mov    $0x44648,%edi
   40e96:	e8 f0 16 00 00       	callq  4258b <assert_fail>
    assert(vam.perm & PTE_W);
   40e9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
   40e9e:	48 98                	cltq   
   40ea0:	83 e0 02             	and    $0x2,%eax
   40ea3:	48 85 c0             	test   %rax,%rax
   40ea6:	75 14                	jne    40ebc <check_page_table_mappings+0x14a>
   40ea8:	ba d6 48 04 00       	mov    $0x448d6,%edx
   40ead:	be e5 01 00 00       	mov    $0x1e5,%esi
   40eb2:	bf 48 46 04 00       	mov    $0x44648,%edi
   40eb7:	e8 cf 16 00 00       	callq  4258b <assert_fail>
}
   40ebc:	90                   	nop
   40ebd:	c9                   	leaveq 
   40ebe:	c3                   	retq   

0000000000040ebf <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   40ebf:	55                   	push   %rbp
   40ec0:	48 89 e5             	mov    %rsp,%rbp
   40ec3:	48 83 ec 20          	sub    $0x20,%rsp
   40ec7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   40ecb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   40ece:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   40ed1:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   40ed4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   40edb:	48 8b 05 1e 61 01 00 	mov    0x1611e(%rip),%rax        # 57000 <kernel_pagetable>
   40ee2:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   40ee6:	75 67                	jne    40f4f <check_page_table_ownership+0x90>
        owner = PO_KERNEL;
   40ee8:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   40eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   40ef6:	eb 51                	jmp    40f49 <check_page_table_ownership+0x8a>
            if (processes[xpid].p_state != P_FREE
   40ef8:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40efb:	48 63 d0             	movslq %eax,%rdx
   40efe:	48 89 d0             	mov    %rdx,%rax
   40f01:	48 c1 e0 04          	shl    $0x4,%rax
   40f05:	48 29 d0             	sub    %rdx,%rax
   40f08:	48 c1 e0 04          	shl    $0x4,%rax
   40f0c:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   40f12:	8b 00                	mov    (%rax),%eax
   40f14:	85 c0                	test   %eax,%eax
   40f16:	74 2d                	je     40f45 <check_page_table_ownership+0x86>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   40f18:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40f1b:	48 63 d0             	movslq %eax,%rdx
   40f1e:	48 89 d0             	mov    %rdx,%rax
   40f21:	48 c1 e0 04          	shl    $0x4,%rax
   40f25:	48 29 d0             	sub    %rdx,%rax
   40f28:	48 c1 e0 04          	shl    $0x4,%rax
   40f2c:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   40f32:	48 8b 10             	mov    (%rax),%rdx
   40f35:	48 8b 05 c4 60 01 00 	mov    0x160c4(%rip),%rax        # 57000 <kernel_pagetable>
   40f3c:	48 39 c2             	cmp    %rax,%rdx
   40f3f:	75 04                	jne    40f45 <check_page_table_ownership+0x86>
                ++expected_refcount;
   40f41:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   40f45:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   40f49:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   40f4d:	7e a9                	jle    40ef8 <check_page_table_ownership+0x39>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   40f4f:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   40f52:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40f59:	be 00 00 00 00       	mov    $0x0,%esi
   40f5e:	48 89 c7             	mov    %rax,%rdi
   40f61:	e8 03 00 00 00       	callq  40f69 <check_page_table_ownership_level>
}
   40f66:	90                   	nop
   40f67:	c9                   	leaveq 
   40f68:	c3                   	retq   

0000000000040f69 <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   40f69:	55                   	push   %rbp
   40f6a:	48 89 e5             	mov    %rsp,%rbp
   40f6d:	48 83 ec 30          	sub    $0x30,%rsp
   40f71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   40f75:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   40f78:	89 55 e0             	mov    %edx,-0x20(%rbp)
   40f7b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   40f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40f82:	48 c1 e8 0c          	shr    $0xc,%rax
   40f86:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   40f8b:	7e 14                	jle    40fa1 <check_page_table_ownership_level+0x38>
   40f8d:	ba f8 48 04 00       	mov    $0x448f8,%edx
   40f92:	be 02 02 00 00       	mov    $0x202,%esi
   40f97:	bf 48 46 04 00       	mov    $0x44648,%edi
   40f9c:	e8 ea 15 00 00       	callq  4258b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   40fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40fa5:	48 c1 e8 0c          	shr    $0xc,%rax
   40fa9:	48 98                	cltq   
   40fab:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   40fb2:	00 
   40fb3:	0f be c0             	movsbl %al,%eax
   40fb6:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   40fb9:	74 14                	je     40fcf <check_page_table_ownership_level+0x66>
   40fbb:	ba 10 49 04 00       	mov    $0x44910,%edx
   40fc0:	be 03 02 00 00       	mov    $0x203,%esi
   40fc5:	bf 48 46 04 00       	mov    $0x44648,%edi
   40fca:	e8 bc 15 00 00       	callq  4258b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   40fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40fd3:	48 c1 e8 0c          	shr    $0xc,%rax
   40fd7:	48 98                	cltq   
   40fd9:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   40fe0:	00 
   40fe1:	0f be c0             	movsbl %al,%eax
   40fe4:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   40fe7:	74 14                	je     40ffd <check_page_table_ownership_level+0x94>
   40fe9:	ba 38 49 04 00       	mov    $0x44938,%edx
   40fee:	be 04 02 00 00       	mov    $0x204,%esi
   40ff3:	bf 48 46 04 00       	mov    $0x44648,%edi
   40ff8:	e8 8e 15 00 00       	callq  4258b <assert_fail>
    if (level < 3) {
   40ffd:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   41001:	7f 5b                	jg     4105e <check_page_table_ownership_level+0xf5>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   41003:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4100a:	eb 49                	jmp    41055 <check_page_table_ownership_level+0xec>
            if (pt->entry[index]) {
   4100c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41010:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41013:	48 63 d2             	movslq %edx,%rdx
   41016:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4101a:	48 85 c0             	test   %rax,%rax
   4101d:	74 32                	je     41051 <check_page_table_ownership_level+0xe8>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   4101f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41023:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41026:	48 63 d2             	movslq %edx,%rdx
   41029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4102d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   41033:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   41037:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4103a:	8d 70 01             	lea    0x1(%rax),%esi
   4103d:	8b 55 e0             	mov    -0x20(%rbp),%edx
   41040:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   41044:	b9 01 00 00 00       	mov    $0x1,%ecx
   41049:	48 89 c7             	mov    %rax,%rdi
   4104c:	e8 18 ff ff ff       	callq  40f69 <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   41051:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41055:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4105c:	7e ae                	jle    4100c <check_page_table_ownership_level+0xa3>
            }
        }
    }
}
   4105e:	90                   	nop
   4105f:	c9                   	leaveq 
   41060:	c3                   	retq   

0000000000041061 <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   41061:	55                   	push   %rbp
   41062:	48 89 e5             	mov    %rsp,%rbp
   41065:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   41069:	8b 05 69 30 01 00    	mov    0x13069(%rip),%eax        # 540d8 <processes+0xd8>
   4106f:	85 c0                	test   %eax,%eax
   41071:	74 14                	je     41087 <check_virtual_memory+0x26>
   41073:	ba 68 49 04 00       	mov    $0x44968,%edx
   41078:	be 17 02 00 00       	mov    $0x217,%esi
   4107d:	bf 48 46 04 00       	mov    $0x44648,%edi
   41082:	e8 04 15 00 00       	callq  4258b <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41087:	48 8b 05 72 5f 01 00 	mov    0x15f72(%rip),%rax        # 57000 <kernel_pagetable>
   4108e:	48 89 c7             	mov    %rax,%rdi
   41091:	e8 dc fc ff ff       	callq  40d72 <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   41096:	48 8b 05 63 5f 01 00 	mov    0x15f63(%rip),%rax        # 57000 <kernel_pagetable>
   4109d:	be ff ff ff ff       	mov    $0xffffffff,%esi
   410a2:	48 89 c7             	mov    %rax,%rdi
   410a5:	e8 15 fe ff ff       	callq  40ebf <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   410aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   410b1:	e9 9c 00 00 00       	jmpq   41152 <check_virtual_memory+0xf1>
        if (processes[pid].p_state != P_FREE
   410b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410b9:	48 63 d0             	movslq %eax,%rdx
   410bc:	48 89 d0             	mov    %rdx,%rax
   410bf:	48 c1 e0 04          	shl    $0x4,%rax
   410c3:	48 29 d0             	sub    %rdx,%rax
   410c6:	48 c1 e0 04          	shl    $0x4,%rax
   410ca:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   410d0:	8b 00                	mov    (%rax),%eax
   410d2:	85 c0                	test   %eax,%eax
   410d4:	74 78                	je     4114e <check_virtual_memory+0xed>
            && processes[pid].p_pagetable != kernel_pagetable) {
   410d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410d9:	48 63 d0             	movslq %eax,%rdx
   410dc:	48 89 d0             	mov    %rdx,%rax
   410df:	48 c1 e0 04          	shl    $0x4,%rax
   410e3:	48 29 d0             	sub    %rdx,%rax
   410e6:	48 c1 e0 04          	shl    $0x4,%rax
   410ea:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   410f0:	48 8b 10             	mov    (%rax),%rdx
   410f3:	48 8b 05 06 5f 01 00 	mov    0x15f06(%rip),%rax        # 57000 <kernel_pagetable>
   410fa:	48 39 c2             	cmp    %rax,%rdx
   410fd:	74 4f                	je     4114e <check_virtual_memory+0xed>
            check_page_table_mappings(processes[pid].p_pagetable);
   410ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41102:	48 63 d0             	movslq %eax,%rdx
   41105:	48 89 d0             	mov    %rdx,%rax
   41108:	48 c1 e0 04          	shl    $0x4,%rax
   4110c:	48 29 d0             	sub    %rdx,%rax
   4110f:	48 c1 e0 04          	shl    $0x4,%rax
   41113:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   41119:	48 8b 00             	mov    (%rax),%rax
   4111c:	48 89 c7             	mov    %rax,%rdi
   4111f:	e8 4e fc ff ff       	callq  40d72 <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   41124:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41127:	48 63 d0             	movslq %eax,%rdx
   4112a:	48 89 d0             	mov    %rdx,%rax
   4112d:	48 c1 e0 04          	shl    $0x4,%rax
   41131:	48 29 d0             	sub    %rdx,%rax
   41134:	48 c1 e0 04          	shl    $0x4,%rax
   41138:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   4113e:	48 8b 00             	mov    (%rax),%rax
   41141:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41144:	89 d6                	mov    %edx,%esi
   41146:	48 89 c7             	mov    %rax,%rdi
   41149:	e8 71 fd ff ff       	callq  40ebf <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   4114e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41152:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   41156:	0f 8e 5a ff ff ff    	jle    410b6 <check_virtual_memory+0x55>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4115c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   41163:	eb 67                	jmp    411cc <check_virtual_memory+0x16b>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   41165:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41168:	48 98                	cltq   
   4116a:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   41171:	00 
   41172:	84 c0                	test   %al,%al
   41174:	7e 52                	jle    411c8 <check_virtual_memory+0x167>
   41176:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41179:	48 98                	cltq   
   4117b:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   41182:	00 
   41183:	84 c0                	test   %al,%al
   41185:	78 41                	js     411c8 <check_virtual_memory+0x167>
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   41187:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4118a:	48 98                	cltq   
   4118c:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   41193:	00 
   41194:	0f be c0             	movsbl %al,%eax
   41197:	48 63 d0             	movslq %eax,%rdx
   4119a:	48 89 d0             	mov    %rdx,%rax
   4119d:	48 c1 e0 04          	shl    $0x4,%rax
   411a1:	48 29 d0             	sub    %rdx,%rax
   411a4:	48 c1 e0 04          	shl    $0x4,%rax
   411a8:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   411ae:	8b 00                	mov    (%rax),%eax
   411b0:	85 c0                	test   %eax,%eax
   411b2:	75 14                	jne    411c8 <check_virtual_memory+0x167>
   411b4:	ba 88 49 04 00       	mov    $0x44988,%edx
   411b9:	be 2e 02 00 00       	mov    $0x22e,%esi
   411be:	bf 48 46 04 00       	mov    $0x44648,%edi
   411c3:	e8 c3 13 00 00       	callq  4258b <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   411c8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   411cc:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   411d3:	7e 90                	jle    41165 <check_virtual_memory+0x104>
        }
    }
}
   411d5:	90                   	nop
   411d6:	90                   	nop
   411d7:	c9                   	leaveq 
   411d8:	c3                   	retq   

00000000000411d9 <memshow_physical>:
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
   411d9:	55                   	push   %rbp
   411da:	48 89 e5             	mov    %rsp,%rbp
   411dd:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   411e1:	ba b8 49 04 00       	mov    $0x449b8,%edx
   411e6:	be 00 0f 00 00       	mov    $0xf00,%esi
   411eb:	bf 20 00 00 00       	mov    $0x20,%edi
   411f0:	b8 00 00 00 00       	mov    $0x0,%eax
   411f5:	e8 da 27 00 00       	callq  439d4 <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   411fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41201:	e9 f4 00 00 00       	jmpq   412fa <memshow_physical+0x121>
        if (pn % 64 == 0) {
   41206:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41209:	83 e0 3f             	and    $0x3f,%eax
   4120c:	85 c0                	test   %eax,%eax
   4120e:	75 3e                	jne    4124e <memshow_physical+0x75>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   41210:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41213:	c1 e0 0c             	shl    $0xc,%eax
   41216:	89 c2                	mov    %eax,%edx
   41218:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4121b:	8d 48 3f             	lea    0x3f(%rax),%ecx
   4121e:	85 c0                	test   %eax,%eax
   41220:	0f 48 c1             	cmovs  %ecx,%eax
   41223:	c1 f8 06             	sar    $0x6,%eax
   41226:	8d 48 01             	lea    0x1(%rax),%ecx
   41229:	89 c8                	mov    %ecx,%eax
   4122b:	c1 e0 02             	shl    $0x2,%eax
   4122e:	01 c8                	add    %ecx,%eax
   41230:	c1 e0 04             	shl    $0x4,%eax
   41233:	83 c0 03             	add    $0x3,%eax
   41236:	89 d1                	mov    %edx,%ecx
   41238:	ba c8 49 04 00       	mov    $0x449c8,%edx
   4123d:	be 00 0f 00 00       	mov    $0xf00,%esi
   41242:	89 c7                	mov    %eax,%edi
   41244:	b8 00 00 00 00       	mov    $0x0,%eax
   41249:	e8 86 27 00 00       	callq  439d4 <console_printf>
        }

        int owner = pageinfo[pn].owner;
   4124e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41251:	48 98                	cltq   
   41253:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   4125a:	00 
   4125b:	0f be c0             	movsbl %al,%eax
   4125e:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   41261:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41264:	48 98                	cltq   
   41266:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   4126d:	00 
   4126e:	84 c0                	test   %al,%al
   41270:	75 07                	jne    41279 <memshow_physical+0xa0>
            owner = PO_FREE;
   41272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   41279:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4127c:	83 c0 02             	add    $0x2,%eax
   4127f:	48 98                	cltq   
   41281:	0f b7 84 00 e0 45 04 	movzwl 0x445e0(%rax,%rax,1),%eax
   41288:	00 
   41289:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
   4128d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41290:	48 98                	cltq   
   41292:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   41299:	00 
   4129a:	3c 01                	cmp    $0x1,%al
   4129c:	7e 1a                	jle    412b8 <memshow_physical+0xdf>
   4129e:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   412a3:	48 c1 e8 0c          	shr    $0xc,%rax
   412a7:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   412aa:	74 0c                	je     412b8 <memshow_physical+0xdf>
#ifdef SHARED
            color = SHARED_COLOR | 0x0F00;
   412ac:	b8 53 00 00 00       	mov    $0x53,%eax
   412b1:	80 cc 0f             	or     $0xf,%ah
   412b4:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
#else
	    color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   412b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   412bb:	8d 50 3f             	lea    0x3f(%rax),%edx
   412be:	85 c0                	test   %eax,%eax
   412c0:	0f 48 c2             	cmovs  %edx,%eax
   412c3:	c1 f8 06             	sar    $0x6,%eax
   412c6:	8d 50 01             	lea    0x1(%rax),%edx
   412c9:	89 d0                	mov    %edx,%eax
   412cb:	c1 e0 02             	shl    $0x2,%eax
   412ce:	01 d0                	add    %edx,%eax
   412d0:	c1 e0 04             	shl    $0x4,%eax
   412d3:	89 c1                	mov    %eax,%ecx
   412d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
   412d8:	99                   	cltd   
   412d9:	c1 ea 1a             	shr    $0x1a,%edx
   412dc:	01 d0                	add    %edx,%eax
   412de:	83 e0 3f             	and    $0x3f,%eax
   412e1:	29 d0                	sub    %edx,%eax
   412e3:	83 c0 0c             	add    $0xc,%eax
   412e6:	01 c8                	add    %ecx,%eax
   412e8:	48 98                	cltq   
   412ea:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
   412ee:	66 89 94 00 00 80 0b 	mov    %dx,0xb8000(%rax,%rax,1)
   412f5:	00 
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   412f6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   412fa:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41301:	0f 8e ff fe ff ff    	jle    41206 <memshow_physical+0x2d>
    }
}
   41307:	90                   	nop
   41308:	90                   	nop
   41309:	c9                   	leaveq 
   4130a:	c3                   	retq   

000000000004130b <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   4130b:	55                   	push   %rbp
   4130c:	48 89 e5             	mov    %rsp,%rbp
   4130f:	48 83 ec 40          	sub    $0x40,%rsp
   41313:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   41317:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   4131b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4131f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   41325:	48 89 c2             	mov    %rax,%rdx
   41328:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4132c:	48 39 c2             	cmp    %rax,%rdx
   4132f:	74 14                	je     41345 <memshow_virtual+0x3a>
   41331:	ba d0 49 04 00       	mov    $0x449d0,%edx
   41336:	be 5f 02 00 00       	mov    $0x25f,%esi
   4133b:	bf 48 46 04 00       	mov    $0x44648,%edi
   41340:	e8 46 12 00 00       	callq  4258b <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   41345:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   41349:	48 89 c1             	mov    %rax,%rcx
   4134c:	ba fd 49 04 00       	mov    $0x449fd,%edx
   41351:	be 00 0f 00 00       	mov    $0xf00,%esi
   41356:	bf 3a 03 00 00       	mov    $0x33a,%edi
   4135b:	b8 00 00 00 00       	mov    $0x0,%eax
   41360:	e8 6f 26 00 00       	callq  439d4 <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41365:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   4136c:	00 
   4136d:	e9 80 01 00 00       	jmpq   414f2 <memshow_virtual+0x1e7>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   41372:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   41376:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4137a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   4137e:	48 89 ce             	mov    %rcx,%rsi
   41381:	48 89 c7             	mov    %rax,%rdi
   41384:	e8 c4 18 00 00       	callq  42c4d <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   41389:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4138c:	85 c0                	test   %eax,%eax
   4138e:	79 0b                	jns    4139b <memshow_virtual+0x90>
            color = ' ';
   41390:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   41396:	e9 d7 00 00 00       	jmpq   41472 <memshow_virtual+0x167>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   4139b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4139f:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   413a5:	76 14                	jbe    413bb <memshow_virtual+0xb0>
   413a7:	ba 1a 4a 04 00       	mov    $0x44a1a,%edx
   413ac:	be 68 02 00 00       	mov    $0x268,%esi
   413b1:	bf 48 46 04 00       	mov    $0x44648,%edi
   413b6:	e8 d0 11 00 00       	callq  4258b <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   413bb:	8b 45 d0             	mov    -0x30(%rbp),%eax
   413be:	48 98                	cltq   
   413c0:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   413c7:	00 
   413c8:	0f be c0             	movsbl %al,%eax
   413cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   413ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
   413d1:	48 98                	cltq   
   413d3:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   413da:	00 
   413db:	84 c0                	test   %al,%al
   413dd:	75 07                	jne    413e6 <memshow_virtual+0xdb>
                owner = PO_FREE;
   413df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   413e6:	8b 45 f0             	mov    -0x10(%rbp),%eax
   413e9:	83 c0 02             	add    $0x2,%eax
   413ec:	48 98                	cltq   
   413ee:	0f b7 84 00 e0 45 04 	movzwl 0x445e0(%rax,%rax,1),%eax
   413f5:	00 
   413f6:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   413fa:	8b 45 e0             	mov    -0x20(%rbp),%eax
   413fd:	48 98                	cltq   
   413ff:	83 e0 04             	and    $0x4,%eax
   41402:	48 85 c0             	test   %rax,%rax
   41405:	74 27                	je     4142e <memshow_virtual+0x123>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   41407:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   4140b:	c1 e0 04             	shl    $0x4,%eax
   4140e:	66 25 00 f0          	and    $0xf000,%ax
   41412:	89 c2                	mov    %eax,%edx
   41414:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41418:	c1 f8 04             	sar    $0x4,%eax
   4141b:	66 25 00 0f          	and    $0xf00,%ax
   4141f:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   41421:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41425:	0f b6 c0             	movzbl %al,%eax
   41428:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   4142a:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
   4142e:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41431:	48 98                	cltq   
   41433:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   4143a:	00 
   4143b:	3c 01                	cmp    $0x1,%al
   4143d:	7e 33                	jle    41472 <memshow_virtual+0x167>
   4143f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   41444:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41448:	74 28                	je     41472 <memshow_virtual+0x167>
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
   4144a:	b8 53 00 00 00       	mov    $0x53,%eax
   4144f:	89 c2                	mov    %eax,%edx
   41451:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41455:	66 25 00 f0          	and    $0xf000,%ax
   41459:	09 d0                	or     %edx,%eax
   4145b:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
                if(! (vam.perm & PTE_U))
   4145f:	8b 45 e0             	mov    -0x20(%rbp),%eax
   41462:	48 98                	cltq   
   41464:	83 e0 04             	and    $0x4,%eax
   41467:	48 85 c0             	test   %rax,%rax
   4146a:	75 06                	jne    41472 <memshow_virtual+0x167>
                    color = color | 0x0F00;
   4146c:	66 81 4d f6 00 0f    	orw    $0xf00,-0xa(%rbp)
#else
		color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
   41472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41476:	48 c1 e8 0c          	shr    $0xc,%rax
   4147a:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   4147d:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41480:	83 e0 3f             	and    $0x3f,%eax
   41483:	85 c0                	test   %eax,%eax
   41485:	75 34                	jne    414bb <memshow_virtual+0x1b0>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   41487:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4148a:	c1 e8 06             	shr    $0x6,%eax
   4148d:	89 c2                	mov    %eax,%edx
   4148f:	89 d0                	mov    %edx,%eax
   41491:	c1 e0 02             	shl    $0x2,%eax
   41494:	01 d0                	add    %edx,%eax
   41496:	c1 e0 04             	shl    $0x4,%eax
   41499:	05 73 03 00 00       	add    $0x373,%eax
   4149e:	89 c7                	mov    %eax,%edi
   414a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   414a4:	48 89 c1             	mov    %rax,%rcx
   414a7:	ba c8 49 04 00       	mov    $0x449c8,%edx
   414ac:	be 00 0f 00 00       	mov    $0xf00,%esi
   414b1:	b8 00 00 00 00       	mov    $0x0,%eax
   414b6:	e8 19 25 00 00       	callq  439d4 <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   414bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
   414be:	c1 e8 06             	shr    $0x6,%eax
   414c1:	89 c2                	mov    %eax,%edx
   414c3:	89 d0                	mov    %edx,%eax
   414c5:	c1 e0 02             	shl    $0x2,%eax
   414c8:	01 d0                	add    %edx,%eax
   414ca:	c1 e0 04             	shl    $0x4,%eax
   414cd:	89 c2                	mov    %eax,%edx
   414cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
   414d2:	83 e0 3f             	and    $0x3f,%eax
   414d5:	01 d0                	add    %edx,%eax
   414d7:	05 7c 03 00 00       	add    $0x37c,%eax
   414dc:	89 c2                	mov    %eax,%edx
   414de:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   414e2:	66 89 84 12 00 80 0b 	mov    %ax,0xb8000(%rdx,%rdx,1)
   414e9:	00 
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   414ea:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   414f1:	00 
   414f2:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   414f9:	00 
   414fa:	0f 86 72 fe ff ff    	jbe    41372 <memshow_virtual+0x67>
    }
}
   41500:	90                   	nop
   41501:	90                   	nop
   41502:	c9                   	leaveq 
   41503:	c3                   	retq   

0000000000041504 <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   41504:	55                   	push   %rbp
   41505:	48 89 e5             	mov    %rsp,%rbp
   41508:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   4150c:	8b 05 12 3e 01 00    	mov    0x13e12(%rip),%eax        # 55324 <last_ticks.1>
   41512:	85 c0                	test   %eax,%eax
   41514:	74 13                	je     41529 <memshow_virtual_animate+0x25>
   41516:	8b 05 04 3e 01 00    	mov    0x13e04(%rip),%eax        # 55320 <ticks>
   4151c:	8b 15 02 3e 01 00    	mov    0x13e02(%rip),%edx        # 55324 <last_ticks.1>
   41522:	29 d0                	sub    %edx,%eax
   41524:	83 f8 31             	cmp    $0x31,%eax
   41527:	76 2c                	jbe    41555 <memshow_virtual_animate+0x51>
        last_ticks = ticks;
   41529:	8b 05 f1 3d 01 00    	mov    0x13df1(%rip),%eax        # 55320 <ticks>
   4152f:	89 05 ef 3d 01 00    	mov    %eax,0x13def(%rip)        # 55324 <last_ticks.1>
        ++showing;
   41535:	8b 05 c9 4a 00 00    	mov    0x4ac9(%rip),%eax        # 46004 <showing.0>
   4153b:	83 c0 01             	add    $0x1,%eax
   4153e:	89 05 c0 4a 00 00    	mov    %eax,0x4ac0(%rip)        # 46004 <showing.0>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   41544:	eb 0f                	jmp    41555 <memshow_virtual_animate+0x51>
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
   41546:	8b 05 b8 4a 00 00    	mov    0x4ab8(%rip),%eax        # 46004 <showing.0>
   4154c:	83 c0 01             	add    $0x1,%eax
   4154f:	89 05 af 4a 00 00    	mov    %eax,0x4aaf(%rip)        # 46004 <showing.0>
    while (showing <= 2*NPROC
   41555:	8b 05 a9 4a 00 00    	mov    0x4aa9(%rip),%eax        # 46004 <showing.0>
           && processes[showing % NPROC].p_state == P_FREE) {
   4155b:	83 f8 20             	cmp    $0x20,%eax
   4155e:	7f 2e                	jg     4158e <memshow_virtual_animate+0x8a>
   41560:	8b 05 9e 4a 00 00    	mov    0x4a9e(%rip),%eax        # 46004 <showing.0>
   41566:	99                   	cltd   
   41567:	c1 ea 1c             	shr    $0x1c,%edx
   4156a:	01 d0                	add    %edx,%eax
   4156c:	83 e0 0f             	and    $0xf,%eax
   4156f:	29 d0                	sub    %edx,%eax
   41571:	48 63 d0             	movslq %eax,%rdx
   41574:	48 89 d0             	mov    %rdx,%rax
   41577:	48 c1 e0 04          	shl    $0x4,%rax
   4157b:	48 29 d0             	sub    %rdx,%rax
   4157e:	48 c1 e0 04          	shl    $0x4,%rax
   41582:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   41588:	8b 00                	mov    (%rax),%eax
   4158a:	85 c0                	test   %eax,%eax
   4158c:	74 b8                	je     41546 <memshow_virtual_animate+0x42>
    }
    showing = showing % NPROC;
   4158e:	8b 05 70 4a 00 00    	mov    0x4a70(%rip),%eax        # 46004 <showing.0>
   41594:	99                   	cltd   
   41595:	c1 ea 1c             	shr    $0x1c,%edx
   41598:	01 d0                	add    %edx,%eax
   4159a:	83 e0 0f             	and    $0xf,%eax
   4159d:	29 d0                	sub    %edx,%eax
   4159f:	89 05 5f 4a 00 00    	mov    %eax,0x4a5f(%rip)        # 46004 <showing.0>

    if (processes[showing].p_state != P_FREE && processes[showing].display_status) {
   415a5:	8b 05 59 4a 00 00    	mov    0x4a59(%rip),%eax        # 46004 <showing.0>
   415ab:	48 63 d0             	movslq %eax,%rdx
   415ae:	48 89 d0             	mov    %rdx,%rax
   415b1:	48 c1 e0 04          	shl    $0x4,%rax
   415b5:	48 29 d0             	sub    %rdx,%rax
   415b8:	48 c1 e0 04          	shl    $0x4,%rax
   415bc:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   415c2:	8b 00                	mov    (%rax),%eax
   415c4:	85 c0                	test   %eax,%eax
   415c6:	74 76                	je     4163e <memshow_virtual_animate+0x13a>
   415c8:	8b 05 36 4a 00 00    	mov    0x4a36(%rip),%eax        # 46004 <showing.0>
   415ce:	48 63 d0             	movslq %eax,%rdx
   415d1:	48 89 d0             	mov    %rdx,%rax
   415d4:	48 c1 e0 04          	shl    $0x4,%rax
   415d8:	48 29 d0             	sub    %rdx,%rax
   415db:	48 c1 e0 04          	shl    $0x4,%rax
   415df:	48 05 e8 40 05 00    	add    $0x540e8,%rax
   415e5:	0f b6 00             	movzbl (%rax),%eax
   415e8:	84 c0                	test   %al,%al
   415ea:	74 52                	je     4163e <memshow_virtual_animate+0x13a>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   415ec:	8b 15 12 4a 00 00    	mov    0x4a12(%rip),%edx        # 46004 <showing.0>
   415f2:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   415f6:	89 d1                	mov    %edx,%ecx
   415f8:	ba 34 4a 04 00       	mov    $0x44a34,%edx
   415fd:	be 04 00 00 00       	mov    $0x4,%esi
   41602:	48 89 c7             	mov    %rax,%rdi
   41605:	b8 00 00 00 00       	mov    $0x0,%eax
   4160a:	e8 43 24 00 00       	callq  43a52 <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   4160f:	8b 05 ef 49 00 00    	mov    0x49ef(%rip),%eax        # 46004 <showing.0>
   41615:	48 63 d0             	movslq %eax,%rdx
   41618:	48 89 d0             	mov    %rdx,%rax
   4161b:	48 c1 e0 04          	shl    $0x4,%rax
   4161f:	48 29 d0             	sub    %rdx,%rax
   41622:	48 c1 e0 04          	shl    $0x4,%rax
   41626:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   4162c:	48 8b 00             	mov    (%rax),%rax
   4162f:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   41633:	48 89 d6             	mov    %rdx,%rsi
   41636:	48 89 c7             	mov    %rax,%rdi
   41639:	e8 cd fc ff ff       	callq  4130b <memshow_virtual>
    }
}
   4163e:	90                   	nop
   4163f:	c9                   	leaveq 
   41640:	c3                   	retq   

0000000000041641 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
extern void virtual_memory_init(void);

void hardware_init(void) {
   41641:	55                   	push   %rbp
   41642:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   41645:	e8 53 01 00 00       	callq  4179d <segments_init>
    interrupt_init();
   4164a:	e8 d4 03 00 00       	callq  41a23 <interrupt_init>
    virtual_memory_init();
   4164f:	e8 f2 0f 00 00       	callq  42646 <virtual_memory_init>
}
   41654:	90                   	nop
   41655:	5d                   	pop    %rbp
   41656:	c3                   	retq   

0000000000041657 <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   41657:	55                   	push   %rbp
   41658:	48 89 e5             	mov    %rsp,%rbp
   4165b:	48 83 ec 18          	sub    $0x18,%rsp
   4165f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41663:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41667:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   4166a:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4166d:	48 98                	cltq   
   4166f:	48 c1 e0 2d          	shl    $0x2d,%rax
   41673:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   41677:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   4167e:	90 00 00 
   41681:	48 09 c2             	or     %rax,%rdx
    *segment = type
   41684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41688:	48 89 10             	mov    %rdx,(%rax)
}
   4168b:	90                   	nop
   4168c:	c9                   	leaveq 
   4168d:	c3                   	retq   

000000000004168e <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   4168e:	55                   	push   %rbp
   4168f:	48 89 e5             	mov    %rsp,%rbp
   41692:	48 83 ec 28          	sub    $0x28,%rsp
   41696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   4169a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   4169e:	89 55 ec             	mov    %edx,-0x14(%rbp)
   416a1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   416a5:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   416a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   416ad:	48 c1 e0 10          	shl    $0x10,%rax
   416b1:	48 89 c2             	mov    %rax,%rdx
   416b4:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   416bb:	00 00 00 
   416be:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   416c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   416c5:	48 c1 e0 20          	shl    $0x20,%rax
   416c9:	48 89 c1             	mov    %rax,%rcx
   416cc:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   416d3:	00 00 ff 
   416d6:	48 21 c8             	and    %rcx,%rax
   416d9:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   416dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   416e0:	48 83 e8 01          	sub    $0x1,%rax
   416e4:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   416e7:	48 09 d0             	or     %rdx,%rax
        | type
   416ea:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   416ee:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   416f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
   416f4:	48 98                	cltq   
   416f6:	48 c1 e0 2d          	shl    $0x2d,%rax
   416fa:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   416fd:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   41704:	80 00 00 
   41707:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   4170a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4170e:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   41711:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41715:	48 83 c0 08          	add    $0x8,%rax
   41719:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   4171d:	48 c1 ea 20          	shr    $0x20,%rdx
   41721:	48 89 10             	mov    %rdx,(%rax)
}
   41724:	90                   	nop
   41725:	c9                   	leaveq 
   41726:	c3                   	retq   

0000000000041727 <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   41727:	55                   	push   %rbp
   41728:	48 89 e5             	mov    %rsp,%rbp
   4172b:	48 83 ec 20          	sub    $0x20,%rsp
   4172f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41733:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41737:	89 55 ec             	mov    %edx,-0x14(%rbp)
   4173a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   4173e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41742:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41745:	48 0b 45 f0          	or     -0x10(%rbp),%rax
   41749:	48 89 c2             	mov    %rax,%rdx
        | ((uint64_t) dpl << 45)
   4174c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4174f:	48 98                	cltq   
   41751:	48 c1 e0 2d          	shl    $0x2d,%rax
   41755:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   41758:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4175c:	48 c1 e0 20          	shl    $0x20,%rax
   41760:	48 89 c1             	mov    %rax,%rcx
   41763:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   4176a:	00 ff ff 
   4176d:	48 21 c8             	and    %rcx,%rax
   41770:	48 09 c2             	or     %rax,%rdx
   41773:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   4177a:	80 00 00 
   4177d:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41784:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41787:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4178b:	48 c1 e8 20          	shr    $0x20,%rax
   4178f:	48 89 c2             	mov    %rax,%rdx
   41792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41796:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   4179a:	90                   	nop
   4179b:	c9                   	leaveq 
   4179c:	c3                   	retq   

000000000004179d <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   4179d:	55                   	push   %rbp
   4179e:	48 89 e5             	mov    %rsp,%rbp
   417a1:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   417a5:	48 c7 05 90 3b 01 00 	movq   $0x0,0x13b90(%rip)        # 55340 <segments>
   417ac:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   417b0:	ba 00 00 00 00       	mov    $0x0,%edx
   417b5:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   417bc:	08 20 00 
   417bf:	48 89 c6             	mov    %rax,%rsi
   417c2:	bf 48 53 05 00       	mov    $0x55348,%edi
   417c7:	e8 8b fe ff ff       	callq  41657 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   417cc:	ba 03 00 00 00       	mov    $0x3,%edx
   417d1:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   417d8:	08 20 00 
   417db:	48 89 c6             	mov    %rax,%rsi
   417de:	bf 50 53 05 00       	mov    $0x55350,%edi
   417e3:	e8 6f fe ff ff       	callq  41657 <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   417e8:	ba 00 00 00 00       	mov    $0x0,%edx
   417ed:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   417f4:	02 00 00 
   417f7:	48 89 c6             	mov    %rax,%rsi
   417fa:	bf 58 53 05 00       	mov    $0x55358,%edi
   417ff:	e8 53 fe ff ff       	callq  41657 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   41804:	ba 03 00 00 00       	mov    $0x3,%edx
   41809:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41810:	02 00 00 
   41813:	48 89 c6             	mov    %rax,%rsi
   41816:	bf 60 53 05 00       	mov    $0x55360,%edi
   4181b:	e8 37 fe ff ff       	callq  41657 <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41820:	b8 80 63 05 00       	mov    $0x56380,%eax
   41825:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   4182b:	48 89 c1             	mov    %rax,%rcx
   4182e:	ba 00 00 00 00       	mov    $0x0,%edx
   41833:	48 b8 00 00 00 00 00 	movabs $0x90000000000,%rax
   4183a:	09 00 00 
   4183d:	48 89 c6             	mov    %rax,%rsi
   41840:	bf 68 53 05 00       	mov    $0x55368,%edi
   41845:	e8 44 fe ff ff       	callq  4168e <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   4184a:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41850:	b8 40 53 05 00       	mov    $0x55340,%eax
   41855:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   41859:	ba 60 00 00 00       	mov    $0x60,%edx
   4185e:	be 00 00 00 00       	mov    $0x0,%esi
   41863:	bf 80 63 05 00       	mov    $0x56380,%edi
   41868:	e8 32 19 00 00       	callq  4319f <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   4186d:	48 c7 05 0c 4b 01 00 	movq   $0x80000,0x14b0c(%rip)        # 56384 <kernel_task_descriptor+0x4>
   41874:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   41878:	ba 00 10 00 00       	mov    $0x1000,%edx
   4187d:	be 00 00 00 00       	mov    $0x0,%esi
   41882:	bf 80 53 05 00       	mov    $0x55380,%edi
   41887:	e8 13 19 00 00       	callq  4319f <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   4188c:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41893:	eb 30                	jmp    418c5 <segments_init+0x128>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41895:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   4189a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4189d:	48 c1 e0 04          	shl    $0x4,%rax
   418a1:	48 05 80 53 05 00    	add    $0x55380,%rax
   418a7:	48 89 d1             	mov    %rdx,%rcx
   418aa:	ba 00 00 00 00       	mov    $0x0,%edx
   418af:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   418b6:	0e 00 00 
   418b9:	48 89 c7             	mov    %rax,%rdi
   418bc:	e8 66 fe ff ff       	callq  41727 <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   418c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   418c5:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   418cc:	76 c7                	jbe    41895 <segments_init+0xf8>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   418ce:	b8 36 00 04 00       	mov    $0x40036,%eax
   418d3:	48 89 c1             	mov    %rax,%rcx
   418d6:	ba 00 00 00 00       	mov    $0x0,%edx
   418db:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   418e2:	0e 00 00 
   418e5:	48 89 c6             	mov    %rax,%rsi
   418e8:	bf 80 55 05 00       	mov    $0x55580,%edi
   418ed:	e8 35 fe ff ff       	callq  41727 <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   418f2:	b8 2e 00 04 00       	mov    $0x4002e,%eax
   418f7:	48 89 c1             	mov    %rax,%rcx
   418fa:	ba 00 00 00 00       	mov    $0x0,%edx
   418ff:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41906:	0e 00 00 
   41909:	48 89 c6             	mov    %rax,%rsi
   4190c:	bf 50 54 05 00       	mov    $0x55450,%edi
   41911:	e8 11 fe ff ff       	callq  41727 <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   41916:	b8 32 00 04 00       	mov    $0x40032,%eax
   4191b:	48 89 c1             	mov    %rax,%rcx
   4191e:	ba 00 00 00 00       	mov    $0x0,%edx
   41923:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   4192a:	0e 00 00 
   4192d:	48 89 c6             	mov    %rax,%rsi
   41930:	bf 60 54 05 00       	mov    $0x55460,%edi
   41935:	e8 ed fd ff ff       	callq  41727 <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   4193a:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41941:	eb 3e                	jmp    41981 <segments_init+0x1e4>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41943:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41946:	83 e8 30             	sub    $0x30,%eax
   41949:	89 c0                	mov    %eax,%eax
   4194b:	48 8b 04 c5 e7 00 04 	mov    0x400e7(,%rax,8),%rax
   41952:	00 
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41953:	48 89 c2             	mov    %rax,%rdx
   41956:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41959:	48 c1 e0 04          	shl    $0x4,%rax
   4195d:	48 05 80 53 05 00    	add    $0x55380,%rax
   41963:	48 89 d1             	mov    %rdx,%rcx
   41966:	ba 03 00 00 00       	mov    $0x3,%edx
   4196b:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41972:	0e 00 00 
   41975:	48 89 c7             	mov    %rax,%rdi
   41978:	e8 aa fd ff ff       	callq  41727 <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   4197d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41981:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41985:	76 bc                	jbe    41943 <segments_init+0x1a6>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41987:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   4198d:	b8 80 53 05 00       	mov    $0x55380,%eax
   41992:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41996:	b8 28 00 00 00       	mov    $0x28,%eax
   4199b:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   4199f:	0f 00 d8             	ltr    %ax
   419a2:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   419a6:	0f 20 c0             	mov    %cr0,%rax
   419a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   419ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   419b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   419b4:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   419bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
   419be:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   419c1:	8b 45 f0             	mov    -0x10(%rbp),%eax
   419c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   419c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   419cc:	0f 22 c0             	mov    %rax,%cr0
}
   419cf:	90                   	nop
    lcr0(cr0);
}
   419d0:	90                   	nop
   419d1:	c9                   	leaveq 
   419d2:	c3                   	retq   

00000000000419d3 <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   419d3:	55                   	push   %rbp
   419d4:	48 89 e5             	mov    %rsp,%rbp
   419d7:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   419db:	0f b7 05 fe 49 01 00 	movzwl 0x149fe(%rip),%eax        # 563e0 <interrupts_enabled>
   419e2:	f7 d0                	not    %eax
   419e4:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   419e8:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   419ec:	0f b6 c0             	movzbl %al,%eax
   419ef:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   419f6:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   419f9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   419fd:	8b 55 f0             	mov    -0x10(%rbp),%edx
   41a00:	ee                   	out    %al,(%dx)
}
   41a01:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   41a02:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41a06:	66 c1 e8 08          	shr    $0x8,%ax
   41a0a:	0f b6 c0             	movzbl %al,%eax
   41a0d:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   41a14:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a17:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   41a1b:	8b 55 f8             	mov    -0x8(%rbp),%edx
   41a1e:	ee                   	out    %al,(%dx)
}
   41a1f:	90                   	nop
}
   41a20:	90                   	nop
   41a21:	c9                   	leaveq 
   41a22:	c3                   	retq   

0000000000041a23 <interrupt_init>:

void interrupt_init(void) {
   41a23:	55                   	push   %rbp
   41a24:	48 89 e5             	mov    %rsp,%rbp
   41a27:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   41a2b:	66 c7 05 ac 49 01 00 	movw   $0x0,0x149ac(%rip)        # 563e0 <interrupts_enabled>
   41a32:	00 00 
    interrupt_mask();
   41a34:	e8 9a ff ff ff       	callq  419d3 <interrupt_mask>
   41a39:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   41a40:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a44:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   41a48:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   41a4b:	ee                   	out    %al,(%dx)
}
   41a4c:	90                   	nop
   41a4d:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   41a54:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a58:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   41a5c:	8b 55 ac             	mov    -0x54(%rbp),%edx
   41a5f:	ee                   	out    %al,(%dx)
}
   41a60:	90                   	nop
   41a61:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   41a68:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a6c:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   41a70:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   41a73:	ee                   	out    %al,(%dx)
}
   41a74:	90                   	nop
   41a75:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   41a7c:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a80:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   41a84:	8b 55 bc             	mov    -0x44(%rbp),%edx
   41a87:	ee                   	out    %al,(%dx)
}
   41a88:	90                   	nop
   41a89:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   41a90:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a94:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   41a98:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   41a9b:	ee                   	out    %al,(%dx)
}
   41a9c:	90                   	nop
   41a9d:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   41aa4:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41aa8:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   41aac:	8b 55 cc             	mov    -0x34(%rbp),%edx
   41aaf:	ee                   	out    %al,(%dx)
}
   41ab0:	90                   	nop
   41ab1:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   41ab8:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41abc:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   41ac0:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   41ac3:	ee                   	out    %al,(%dx)
}
   41ac4:	90                   	nop
   41ac5:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   41acc:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ad0:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   41ad4:	8b 55 dc             	mov    -0x24(%rbp),%edx
   41ad7:	ee                   	out    %al,(%dx)
}
   41ad8:	90                   	nop
   41ad9:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   41ae0:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ae4:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   41ae8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   41aeb:	ee                   	out    %al,(%dx)
}
   41aec:	90                   	nop
   41aed:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   41af4:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41af8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41afc:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41aff:	ee                   	out    %al,(%dx)
}
   41b00:	90                   	nop
   41b01:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   41b08:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b0c:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41b10:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41b13:	ee                   	out    %al,(%dx)
}
   41b14:	90                   	nop
   41b15:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   41b1c:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b20:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41b24:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41b27:	ee                   	out    %al,(%dx)
}
   41b28:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   41b29:	e8 a5 fe ff ff       	callq  419d3 <interrupt_mask>
}
   41b2e:	90                   	nop
   41b2f:	c9                   	leaveq 
   41b30:	c3                   	retq   

0000000000041b31 <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   41b31:	55                   	push   %rbp
   41b32:	48 89 e5             	mov    %rsp,%rbp
   41b35:	48 83 ec 28          	sub    $0x28,%rsp
   41b39:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   41b3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   41b40:	0f 8e 9f 00 00 00    	jle    41be5 <timer_init+0xb4>
   41b46:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   41b4d:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b51:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41b55:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41b58:	ee                   	out    %al,(%dx)
}
   41b59:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   41b5a:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41b5d:	89 c2                	mov    %eax,%edx
   41b5f:	c1 ea 1f             	shr    $0x1f,%edx
   41b62:	01 d0                	add    %edx,%eax
   41b64:	d1 f8                	sar    %eax
   41b66:	05 de 34 12 00       	add    $0x1234de,%eax
   41b6b:	99                   	cltd   
   41b6c:	f7 7d dc             	idivl  -0x24(%rbp)
   41b6f:	89 c2                	mov    %eax,%edx
   41b71:	89 d0                	mov    %edx,%eax
   41b73:	c1 f8 1f             	sar    $0x1f,%eax
   41b76:	c1 e8 18             	shr    $0x18,%eax
   41b79:	89 c1                	mov    %eax,%ecx
   41b7b:	8d 04 0a             	lea    (%rdx,%rcx,1),%eax
   41b7e:	0f b6 c0             	movzbl %al,%eax
   41b81:	29 c8                	sub    %ecx,%eax
   41b83:	0f b6 c0             	movzbl %al,%eax
   41b86:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   41b8d:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b90:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41b94:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41b97:	ee                   	out    %al,(%dx)
}
   41b98:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   41b99:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41b9c:	89 c2                	mov    %eax,%edx
   41b9e:	c1 ea 1f             	shr    $0x1f,%edx
   41ba1:	01 d0                	add    %edx,%eax
   41ba3:	d1 f8                	sar    %eax
   41ba5:	05 de 34 12 00       	add    $0x1234de,%eax
   41baa:	99                   	cltd   
   41bab:	f7 7d dc             	idivl  -0x24(%rbp)
   41bae:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   41bb4:	85 c0                	test   %eax,%eax
   41bb6:	0f 48 c2             	cmovs  %edx,%eax
   41bb9:	c1 f8 08             	sar    $0x8,%eax
   41bbc:	0f b6 c0             	movzbl %al,%eax
   41bbf:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   41bc6:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41bc9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41bcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41bd0:	ee                   	out    %al,(%dx)
}
   41bd1:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   41bd2:	0f b7 05 07 48 01 00 	movzwl 0x14807(%rip),%eax        # 563e0 <interrupts_enabled>
   41bd9:	83 c8 01             	or     $0x1,%eax
   41bdc:	66 89 05 fd 47 01 00 	mov    %ax,0x147fd(%rip)        # 563e0 <interrupts_enabled>
   41be3:	eb 11                	jmp    41bf6 <timer_init+0xc5>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   41be5:	0f b7 05 f4 47 01 00 	movzwl 0x147f4(%rip),%eax        # 563e0 <interrupts_enabled>
   41bec:	83 e0 fe             	and    $0xfffffffe,%eax
   41bef:	66 89 05 ea 47 01 00 	mov    %ax,0x147ea(%rip)        # 563e0 <interrupts_enabled>
    }
    interrupt_mask();
   41bf6:	e8 d8 fd ff ff       	callq  419d3 <interrupt_mask>
}
   41bfb:	90                   	nop
   41bfc:	c9                   	leaveq 
   41bfd:	c3                   	retq   

0000000000041bfe <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   41bfe:	55                   	push   %rbp
   41bff:	48 89 e5             	mov    %rsp,%rbp
   41c02:	48 83 ec 08          	sub    $0x8,%rsp
   41c06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   41c0a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   41c0f:	74 14                	je     41c25 <physical_memory_isreserved+0x27>
   41c11:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   41c18:	00 
   41c19:	76 11                	jbe    41c2c <physical_memory_isreserved+0x2e>
   41c1b:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   41c22:	00 
   41c23:	77 07                	ja     41c2c <physical_memory_isreserved+0x2e>
   41c25:	b8 01 00 00 00       	mov    $0x1,%eax
   41c2a:	eb 05                	jmp    41c31 <physical_memory_isreserved+0x33>
   41c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
   41c31:	c9                   	leaveq 
   41c32:	c3                   	retq   

0000000000041c33 <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   41c33:	55                   	push   %rbp
   41c34:	48 89 e5             	mov    %rsp,%rbp
   41c37:	48 83 ec 10          	sub    $0x10,%rsp
   41c3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
   41c3e:	89 75 f8             	mov    %esi,-0x8(%rbp)
   41c41:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   41c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41c47:	c1 e0 10             	shl    $0x10,%eax
   41c4a:	89 c2                	mov    %eax,%edx
   41c4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41c4f:	c1 e0 0b             	shl    $0xb,%eax
   41c52:	09 c2                	or     %eax,%edx
   41c54:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41c57:	c1 e0 08             	shl    $0x8,%eax
   41c5a:	09 d0                	or     %edx,%eax
}
   41c5c:	c9                   	leaveq 
   41c5d:	c3                   	retq   

0000000000041c5e <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   41c5e:	55                   	push   %rbp
   41c5f:	48 89 e5             	mov    %rsp,%rbp
   41c62:	48 83 ec 18          	sub    $0x18,%rsp
   41c66:	89 7d ec             	mov    %edi,-0x14(%rbp)
   41c69:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   41c6c:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41c6f:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41c72:	09 d0                	or     %edx,%eax
   41c74:	0d 00 00 00 80       	or     $0x80000000,%eax
   41c79:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   41c80:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   41c83:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41c86:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41c89:	ef                   	out    %eax,(%dx)
}
   41c8a:	90                   	nop
   41c8b:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   41c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41c95:	89 c2                	mov    %eax,%edx
   41c97:	ed                   	in     (%dx),%eax
   41c98:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   41c9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   41c9e:	c9                   	leaveq 
   41c9f:	c3                   	retq   

0000000000041ca0 <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   41ca0:	55                   	push   %rbp
   41ca1:	48 89 e5             	mov    %rsp,%rbp
   41ca4:	48 83 ec 28          	sub    $0x28,%rsp
   41ca8:	89 7d dc             	mov    %edi,-0x24(%rbp)
   41cab:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   41cae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41cb5:	eb 73                	jmp    41d2a <pci_find_device+0x8a>
        for (int slot = 0; slot != 32; ++slot) {
   41cb7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   41cbe:	eb 60                	jmp    41d20 <pci_find_device+0x80>
            for (int func = 0; func != 8; ++func) {
   41cc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   41cc7:	eb 4a                	jmp    41d13 <pci_find_device+0x73>
                int configaddr = pci_make_configaddr(bus, slot, func);
   41cc9:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41ccc:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   41ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41cd2:	89 ce                	mov    %ecx,%esi
   41cd4:	89 c7                	mov    %eax,%edi
   41cd6:	e8 58 ff ff ff       	callq  41c33 <pci_make_configaddr>
   41cdb:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   41cde:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41ce1:	be 00 00 00 00       	mov    $0x0,%esi
   41ce6:	89 c7                	mov    %eax,%edi
   41ce8:	e8 71 ff ff ff       	callq  41c5e <pci_config_readl>
   41ced:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   41cf0:	8b 45 d8             	mov    -0x28(%rbp),%eax
   41cf3:	c1 e0 10             	shl    $0x10,%eax
   41cf6:	0b 45 dc             	or     -0x24(%rbp),%eax
   41cf9:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   41cfc:	75 05                	jne    41d03 <pci_find_device+0x63>
                    return configaddr;
   41cfe:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41d01:	eb 35                	jmp    41d38 <pci_find_device+0x98>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   41d03:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   41d07:	75 06                	jne    41d0f <pci_find_device+0x6f>
   41d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   41d0d:	74 0c                	je     41d1b <pci_find_device+0x7b>
            for (int func = 0; func != 8; ++func) {
   41d0f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   41d13:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   41d17:	75 b0                	jne    41cc9 <pci_find_device+0x29>
   41d19:	eb 01                	jmp    41d1c <pci_find_device+0x7c>
                    break;
   41d1b:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   41d1c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41d20:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   41d24:	75 9a                	jne    41cc0 <pci_find_device+0x20>
    for (int bus = 0; bus != 256; ++bus) {
   41d26:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41d2a:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   41d31:	75 84                	jne    41cb7 <pci_find_device+0x17>
                }
            }
        }
    }
    return -1;
   41d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   41d38:	c9                   	leaveq 
   41d39:	c3                   	retq   

0000000000041d3a <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   41d3a:	55                   	push   %rbp
   41d3b:	48 89 e5             	mov    %rsp,%rbp
   41d3e:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   41d42:	be 13 71 00 00       	mov    $0x7113,%esi
   41d47:	bf 86 80 00 00       	mov    $0x8086,%edi
   41d4c:	e8 4f ff ff ff       	callq  41ca0 <pci_find_device>
   41d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   41d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   41d58:	78 30                	js     41d8a <poweroff+0x50>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   41d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41d5d:	be 40 00 00 00       	mov    $0x40,%esi
   41d62:	89 c7                	mov    %eax,%edi
   41d64:	e8 f5 fe ff ff       	callq  41c5e <pci_config_readl>
   41d69:	25 c0 ff 00 00       	and    $0xffc0,%eax
   41d6e:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   41d71:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41d74:	83 c0 04             	add    $0x4,%eax
   41d77:	89 45 f4             	mov    %eax,-0xc(%rbp)
   41d7a:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   41d80:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   41d84:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41d87:	66 ef                	out    %ax,(%dx)
}
   41d89:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   41d8a:	ba 40 4a 04 00       	mov    $0x44a40,%edx
   41d8f:	be 00 c0 00 00       	mov    $0xc000,%esi
   41d94:	bf 80 07 00 00       	mov    $0x780,%edi
   41d99:	b8 00 00 00 00       	mov    $0x0,%eax
   41d9e:	e8 31 1c 00 00       	callq  439d4 <console_printf>
 spinloop: goto spinloop;
   41da3:	eb fe                	jmp    41da3 <poweroff+0x69>

0000000000041da5 <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   41da5:	55                   	push   %rbp
   41da6:	48 89 e5             	mov    %rsp,%rbp
   41da9:	48 83 ec 10          	sub    $0x10,%rsp
   41dad:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   41db4:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41db8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41dbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41dbf:	ee                   	out    %al,(%dx)
}
   41dc0:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   41dc1:	eb fe                	jmp    41dc1 <reboot+0x1c>

0000000000041dc3 <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   41dc3:	55                   	push   %rbp
   41dc4:	48 89 e5             	mov    %rsp,%rbp
   41dc7:	48 83 ec 10          	sub    $0x10,%rsp
   41dcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41dcf:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   41dd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41dd6:	48 83 c0 18          	add    $0x18,%rax
   41dda:	ba c0 00 00 00       	mov    $0xc0,%edx
   41ddf:	be 00 00 00 00       	mov    $0x0,%esi
   41de4:	48 89 c7             	mov    %rax,%rdi
   41de7:	e8 b3 13 00 00       	callq  4319f <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   41dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41df0:	66 c7 80 b8 00 00 00 	movw   $0x13,0xb8(%rax)
   41df7:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   41df9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41dfd:	48 c7 80 90 00 00 00 	movq   $0x23,0x90(%rax)
   41e04:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   41e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e0c:	48 c7 80 98 00 00 00 	movq   $0x23,0x98(%rax)
   41e13:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   41e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e1b:	66 c7 80 d0 00 00 00 	movw   $0x23,0xd0(%rax)
   41e22:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   41e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e28:	48 c7 80 c0 00 00 00 	movq   $0x200,0xc0(%rax)
   41e2f:	00 02 00 00 

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   41e33:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41e36:	83 e0 01             	and    $0x1,%eax
   41e39:	85 c0                	test   %eax,%eax
   41e3b:	74 1c                	je     41e59 <process_init+0x96>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   41e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e41:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   41e48:	80 cc 30             	or     $0x30,%ah
   41e4b:	48 89 c2             	mov    %rax,%rdx
   41e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e52:	48 89 90 c0 00 00 00 	mov    %rdx,0xc0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   41e59:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41e5c:	83 e0 02             	and    $0x2,%eax
   41e5f:	85 c0                	test   %eax,%eax
   41e61:	74 1c                	je     41e7f <process_init+0xbc>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   41e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e67:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   41e6e:	80 e4 fd             	and    $0xfd,%ah
   41e71:	48 89 c2             	mov    %rax,%rdx
   41e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e78:	48 89 90 c0 00 00 00 	mov    %rdx,0xc0(%rax)
    }
    p->display_status = 1;
   41e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e83:	c6 80 e8 00 00 00 01 	movb   $0x1,0xe8(%rax)
}
   41e8a:	90                   	nop
   41e8b:	c9                   	leaveq 
   41e8c:	c3                   	retq   

0000000000041e8d <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   41e8d:	55                   	push   %rbp
   41e8e:	48 89 e5             	mov    %rsp,%rbp
   41e91:	48 83 ec 28          	sub    $0x28,%rsp
   41e95:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   41e98:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   41e9c:	78 09                	js     41ea7 <console_show_cursor+0x1a>
   41e9e:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   41ea5:	7e 07                	jle    41eae <console_show_cursor+0x21>
        cpos = 0;
   41ea7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   41eae:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   41eb5:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41eb9:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   41ebd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   41ec0:	ee                   	out    %al,(%dx)
}
   41ec1:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   41ec2:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41ec5:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   41ecb:	85 c0                	test   %eax,%eax
   41ecd:	0f 48 c2             	cmovs  %edx,%eax
   41ed0:	c1 f8 08             	sar    $0x8,%eax
   41ed3:	0f b6 c0             	movzbl %al,%eax
   41ed6:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   41edd:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ee0:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41ee4:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41ee7:	ee                   	out    %al,(%dx)
}
   41ee8:	90                   	nop
   41ee9:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   41ef0:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ef4:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41ef8:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41efb:	ee                   	out    %al,(%dx)
}
   41efc:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   41efd:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41f00:	99                   	cltd   
   41f01:	c1 ea 18             	shr    $0x18,%edx
   41f04:	01 d0                	add    %edx,%eax
   41f06:	0f b6 c0             	movzbl %al,%eax
   41f09:	29 d0                	sub    %edx,%eax
   41f0b:	0f b6 c0             	movzbl %al,%eax
   41f0e:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   41f15:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f18:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41f1f:	ee                   	out    %al,(%dx)
}
   41f20:	90                   	nop
}
   41f21:	90                   	nop
   41f22:	c9                   	leaveq 
   41f23:	c3                   	retq   

0000000000041f24 <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   41f24:	55                   	push   %rbp
   41f25:	48 89 e5             	mov    %rsp,%rbp
   41f28:	48 83 ec 20          	sub    $0x20,%rsp
   41f2c:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   41f33:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41f36:	89 c2                	mov    %eax,%edx
   41f38:	ec                   	in     (%dx),%al
   41f39:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   41f3c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   41f40:	0f b6 c0             	movzbl %al,%eax
   41f43:	83 e0 01             	and    $0x1,%eax
   41f46:	85 c0                	test   %eax,%eax
   41f48:	75 0a                	jne    41f54 <keyboard_readc+0x30>
        return -1;
   41f4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   41f4f:	e9 e7 01 00 00       	jmpq   4213b <keyboard_readc+0x217>
   41f54:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   41f5b:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41f5e:	89 c2                	mov    %eax,%edx
   41f60:	ec                   	in     (%dx),%al
   41f61:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   41f64:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   41f68:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   41f6b:	0f b6 05 70 44 01 00 	movzbl 0x14470(%rip),%eax        # 563e2 <last_escape.2>
   41f72:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   41f75:	c6 05 66 44 01 00 00 	movb   $0x0,0x14466(%rip)        # 563e2 <last_escape.2>

    if (data == 0xE0) {         // mode shift
   41f7c:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   41f80:	75 11                	jne    41f93 <keyboard_readc+0x6f>
        last_escape = 0x80;
   41f82:	c6 05 59 44 01 00 80 	movb   $0x80,0x14459(%rip)        # 563e2 <last_escape.2>
        return 0;
   41f89:	b8 00 00 00 00       	mov    $0x0,%eax
   41f8e:	e9 a8 01 00 00       	jmpq   4213b <keyboard_readc+0x217>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   41f93:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f97:	84 c0                	test   %al,%al
   41f99:	79 60                	jns    41ffb <keyboard_readc+0xd7>
        int ch = keymap[(data & 0x7F) | escape];
   41f9b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f9f:	83 e0 7f             	and    $0x7f,%eax
   41fa2:	89 c2                	mov    %eax,%edx
   41fa4:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   41fa8:	09 d0                	or     %edx,%eax
   41faa:	48 98                	cltq   
   41fac:	0f b6 80 60 4a 04 00 	movzbl 0x44a60(%rax),%eax
   41fb3:	0f b6 c0             	movzbl %al,%eax
   41fb6:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   41fb9:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   41fc0:	7e 2f                	jle    41ff1 <keyboard_readc+0xcd>
   41fc2:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   41fc9:	7f 26                	jg     41ff1 <keyboard_readc+0xcd>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   41fcb:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41fce:	2d fa 00 00 00       	sub    $0xfa,%eax
   41fd3:	ba 01 00 00 00       	mov    $0x1,%edx
   41fd8:	89 c1                	mov    %eax,%ecx
   41fda:	d3 e2                	shl    %cl,%edx
   41fdc:	89 d0                	mov    %edx,%eax
   41fde:	f7 d0                	not    %eax
   41fe0:	89 c2                	mov    %eax,%edx
   41fe2:	0f b6 05 fa 43 01 00 	movzbl 0x143fa(%rip),%eax        # 563e3 <modifiers.1>
   41fe9:	21 d0                	and    %edx,%eax
   41feb:	88 05 f2 43 01 00    	mov    %al,0x143f2(%rip)        # 563e3 <modifiers.1>
        }
        return 0;
   41ff1:	b8 00 00 00 00       	mov    $0x0,%eax
   41ff6:	e9 40 01 00 00       	jmpq   4213b <keyboard_readc+0x217>
    }

    int ch = (unsigned char) keymap[data | escape];
   41ffb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41fff:	0a 45 fa             	or     -0x6(%rbp),%al
   42002:	0f b6 c0             	movzbl %al,%eax
   42005:	48 98                	cltq   
   42007:	0f b6 80 60 4a 04 00 	movzbl 0x44a60(%rax),%eax
   4200e:	0f b6 c0             	movzbl %al,%eax
   42011:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   42014:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   42018:	7e 57                	jle    42071 <keyboard_readc+0x14d>
   4201a:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   4201e:	7f 51                	jg     42071 <keyboard_readc+0x14d>
        if (modifiers & MOD_CONTROL) {
   42020:	0f b6 05 bc 43 01 00 	movzbl 0x143bc(%rip),%eax        # 563e3 <modifiers.1>
   42027:	0f b6 c0             	movzbl %al,%eax
   4202a:	83 e0 02             	and    $0x2,%eax
   4202d:	85 c0                	test   %eax,%eax
   4202f:	74 09                	je     4203a <keyboard_readc+0x116>
            ch -= 0x60;
   42031:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42035:	e9 fd 00 00 00       	jmpq   42137 <keyboard_readc+0x213>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   4203a:	0f b6 05 a2 43 01 00 	movzbl 0x143a2(%rip),%eax        # 563e3 <modifiers.1>
   42041:	0f b6 c0             	movzbl %al,%eax
   42044:	83 e0 01             	and    $0x1,%eax
   42047:	85 c0                	test   %eax,%eax
   42049:	0f 94 c2             	sete   %dl
   4204c:	0f b6 05 90 43 01 00 	movzbl 0x14390(%rip),%eax        # 563e3 <modifiers.1>
   42053:	0f b6 c0             	movzbl %al,%eax
   42056:	83 e0 08             	and    $0x8,%eax
   42059:	85 c0                	test   %eax,%eax
   4205b:	0f 94 c0             	sete   %al
   4205e:	31 d0                	xor    %edx,%eax
   42060:	84 c0                	test   %al,%al
   42062:	0f 84 cf 00 00 00    	je     42137 <keyboard_readc+0x213>
            ch -= 0x20;
   42068:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   4206c:	e9 c6 00 00 00       	jmpq   42137 <keyboard_readc+0x213>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   42071:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   42078:	7e 30                	jle    420aa <keyboard_readc+0x186>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   4207a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4207d:	2d fa 00 00 00       	sub    $0xfa,%eax
   42082:	ba 01 00 00 00       	mov    $0x1,%edx
   42087:	89 c1                	mov    %eax,%ecx
   42089:	d3 e2                	shl    %cl,%edx
   4208b:	89 d0                	mov    %edx,%eax
   4208d:	89 c2                	mov    %eax,%edx
   4208f:	0f b6 05 4d 43 01 00 	movzbl 0x1434d(%rip),%eax        # 563e3 <modifiers.1>
   42096:	31 d0                	xor    %edx,%eax
   42098:	88 05 45 43 01 00    	mov    %al,0x14345(%rip)        # 563e3 <modifiers.1>
        ch = 0;
   4209e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   420a5:	e9 8e 00 00 00       	jmpq   42138 <keyboard_readc+0x214>
    } else if (ch >= KEY_SHIFT) {
   420aa:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   420b1:	7e 2d                	jle    420e0 <keyboard_readc+0x1bc>
        modifiers |= 1 << (ch - KEY_SHIFT);
   420b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   420b6:	2d fa 00 00 00       	sub    $0xfa,%eax
   420bb:	ba 01 00 00 00       	mov    $0x1,%edx
   420c0:	89 c1                	mov    %eax,%ecx
   420c2:	d3 e2                	shl    %cl,%edx
   420c4:	89 d0                	mov    %edx,%eax
   420c6:	89 c2                	mov    %eax,%edx
   420c8:	0f b6 05 14 43 01 00 	movzbl 0x14314(%rip),%eax        # 563e3 <modifiers.1>
   420cf:	09 d0                	or     %edx,%eax
   420d1:	88 05 0c 43 01 00    	mov    %al,0x1430c(%rip)        # 563e3 <modifiers.1>
        ch = 0;
   420d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   420de:	eb 58                	jmp    42138 <keyboard_readc+0x214>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   420e0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   420e4:	7e 31                	jle    42117 <keyboard_readc+0x1f3>
   420e6:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   420ed:	7f 28                	jg     42117 <keyboard_readc+0x1f3>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   420ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
   420f2:	8d 50 80             	lea    -0x80(%rax),%edx
   420f5:	0f b6 05 e7 42 01 00 	movzbl 0x142e7(%rip),%eax        # 563e3 <modifiers.1>
   420fc:	0f b6 c0             	movzbl %al,%eax
   420ff:	83 e0 03             	and    $0x3,%eax
   42102:	48 98                	cltq   
   42104:	48 63 d2             	movslq %edx,%rdx
   42107:	0f b6 84 90 60 4b 04 	movzbl 0x44b60(%rax,%rdx,4),%eax
   4210e:	00 
   4210f:	0f b6 c0             	movzbl %al,%eax
   42112:	89 45 fc             	mov    %eax,-0x4(%rbp)
   42115:	eb 21                	jmp    42138 <keyboard_readc+0x214>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   42117:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   4211b:	7f 1b                	jg     42138 <keyboard_readc+0x214>
   4211d:	0f b6 05 bf 42 01 00 	movzbl 0x142bf(%rip),%eax        # 563e3 <modifiers.1>
   42124:	0f b6 c0             	movzbl %al,%eax
   42127:	83 e0 02             	and    $0x2,%eax
   4212a:	85 c0                	test   %eax,%eax
   4212c:	74 0a                	je     42138 <keyboard_readc+0x214>
        ch = 0;
   4212e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42135:	eb 01                	jmp    42138 <keyboard_readc+0x214>
        if (modifiers & MOD_CONTROL) {
   42137:	90                   	nop
    }

    return ch;
   42138:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   4213b:	c9                   	leaveq 
   4213c:	c3                   	retq   

000000000004213d <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   4213d:	55                   	push   %rbp
   4213e:	48 89 e5             	mov    %rsp,%rbp
   42141:	48 83 ec 20          	sub    $0x20,%rsp
   42145:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   4214c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4214f:	89 c2                	mov    %eax,%edx
   42151:	ec                   	in     (%dx),%al
   42152:	88 45 e3             	mov    %al,-0x1d(%rbp)
   42155:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   4215c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4215f:	89 c2                	mov    %eax,%edx
   42161:	ec                   	in     (%dx),%al
   42162:	88 45 eb             	mov    %al,-0x15(%rbp)
   42165:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   4216c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4216f:	89 c2                	mov    %eax,%edx
   42171:	ec                   	in     (%dx),%al
   42172:	88 45 f3             	mov    %al,-0xd(%rbp)
   42175:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   4217c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4217f:	89 c2                	mov    %eax,%edx
   42181:	ec                   	in     (%dx),%al
   42182:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   42185:	90                   	nop
   42186:	c9                   	leaveq 
   42187:	c3                   	retq   

0000000000042188 <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   42188:	55                   	push   %rbp
   42189:	48 89 e5             	mov    %rsp,%rbp
   4218c:	48 83 ec 40          	sub    $0x40,%rsp
   42190:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42194:	89 f0                	mov    %esi,%eax
   42196:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42199:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   4219c:	8b 05 42 42 01 00    	mov    0x14242(%rip),%eax        # 563e4 <initialized.0>
   421a2:	85 c0                	test   %eax,%eax
   421a4:	75 1e                	jne    421c4 <parallel_port_putc+0x3c>
   421a6:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   421ad:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   421b1:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   421b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
   421b8:	ee                   	out    %al,(%dx)
}
   421b9:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   421ba:	c7 05 20 42 01 00 01 	movl   $0x1,0x14220(%rip)        # 563e4 <initialized.0>
   421c1:	00 00 00 
    }

    for (int i = 0;
   421c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   421cb:	eb 09                	jmp    421d6 <parallel_port_putc+0x4e>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   421cd:	e8 6b ff ff ff       	callq  4213d <delay>
         ++i) {
   421d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   421d6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   421dd:	7f 18                	jg     421f7 <parallel_port_putc+0x6f>
   421df:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   421e6:	8b 45 f0             	mov    -0x10(%rbp),%eax
   421e9:	89 c2                	mov    %eax,%edx
   421eb:	ec                   	in     (%dx),%al
   421ec:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   421ef:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   421f3:	84 c0                	test   %al,%al
   421f5:	79 d6                	jns    421cd <parallel_port_putc+0x45>
    }
    outb(IO_PARALLEL1_DATA, c);
   421f7:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   421fb:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   42202:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42205:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   42209:	8b 55 d8             	mov    -0x28(%rbp),%edx
   4220c:	ee                   	out    %al,(%dx)
}
   4220d:	90                   	nop
   4220e:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   42215:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42219:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   4221d:	8b 55 e0             	mov    -0x20(%rbp),%edx
   42220:	ee                   	out    %al,(%dx)
}
   42221:	90                   	nop
   42222:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   42229:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4222d:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   42231:	8b 55 e8             	mov    -0x18(%rbp),%edx
   42234:	ee                   	out    %al,(%dx)
}
   42235:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   42236:	90                   	nop
   42237:	c9                   	leaveq 
   42238:	c3                   	retq   

0000000000042239 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   42239:	55                   	push   %rbp
   4223a:	48 89 e5             	mov    %rsp,%rbp
   4223d:	48 83 ec 20          	sub    $0x20,%rsp
   42241:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   42245:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   42249:	48 c7 45 f8 88 21 04 	movq   $0x42188,-0x8(%rbp)
   42250:	00 
    printer_vprintf(&p, 0, format, val);
   42251:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   42255:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   42259:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   4225d:	be 00 00 00 00       	mov    $0x0,%esi
   42262:	48 89 c7             	mov    %rax,%rdi
   42265:	e8 46 10 00 00       	callq  432b0 <printer_vprintf>
}
   4226a:	90                   	nop
   4226b:	c9                   	leaveq 
   4226c:	c3                   	retq   

000000000004226d <log_printf>:

void log_printf(const char* format, ...) {
   4226d:	55                   	push   %rbp
   4226e:	48 89 e5             	mov    %rsp,%rbp
   42271:	48 83 ec 60          	sub    $0x60,%rsp
   42275:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42279:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   4227d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   42281:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42285:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42289:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4228d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   42294:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42298:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   4229c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   422a0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   422a4:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   422a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   422ac:	48 89 d6             	mov    %rdx,%rsi
   422af:	48 89 c7             	mov    %rax,%rdi
   422b2:	e8 82 ff ff ff       	callq  42239 <log_vprintf>
    va_end(val);
}
   422b7:	90                   	nop
   422b8:	c9                   	leaveq 
   422b9:	c3                   	retq   

00000000000422ba <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   422ba:	55                   	push   %rbp
   422bb:	48 89 e5             	mov    %rsp,%rbp
   422be:	48 83 ec 40          	sub    $0x40,%rsp
   422c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
   422c5:	89 75 d8             	mov    %esi,-0x28(%rbp)
   422c8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   422cc:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   422d0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   422d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   422d8:	48 8b 0a             	mov    (%rdx),%rcx
   422db:	48 89 08             	mov    %rcx,(%rax)
   422de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   422e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
   422e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   422ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   422ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   422f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   422f6:	48 89 d6             	mov    %rdx,%rsi
   422f9:	48 89 c7             	mov    %rax,%rdi
   422fc:	e8 38 ff ff ff       	callq  42239 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   42301:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   42305:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42309:	8b 75 d8             	mov    -0x28(%rbp),%esi
   4230c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4230f:	89 c7                	mov    %eax,%edi
   42311:	e8 79 16 00 00       	callq  4398f <console_vprintf>
}
   42316:	c9                   	leaveq 
   42317:	c3                   	retq   

0000000000042318 <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   42318:	55                   	push   %rbp
   42319:	48 89 e5             	mov    %rsp,%rbp
   4231c:	48 83 ec 60          	sub    $0x60,%rsp
   42320:	89 7d ac             	mov    %edi,-0x54(%rbp)
   42323:	89 75 a8             	mov    %esi,-0x58(%rbp)
   42326:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   4232a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   4232e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42332:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42336:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   4233d:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42341:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   42345:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42349:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   4234d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   42351:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   42355:	8b 75 a8             	mov    -0x58(%rbp),%esi
   42358:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4235b:	89 c7                	mov    %eax,%edi
   4235d:	e8 58 ff ff ff       	callq  422ba <error_vprintf>
   42362:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   42365:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   42368:	c9                   	leaveq 
   42369:	c3                   	retq   

000000000004236a <check_keyboard>:
//    Check for the user typing a control key. 'a', 'm', and 'c' cause a soft
//    reboot where the kernel runs the allocator programs, "malloc", or
//    "alloctests", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   4236a:	55                   	push   %rbp
   4236b:	48 89 e5             	mov    %rsp,%rbp
   4236e:	53                   	push   %rbx
   4236f:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   42373:	e8 ac fb ff ff       	callq  41f24 <keyboard_readc>
   42378:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'm' || c == 'c' || c == 't'|| c =='2') {
   4237b:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   4237f:	74 1c                	je     4239d <check_keyboard+0x33>
   42381:	83 7d e4 6d          	cmpl   $0x6d,-0x1c(%rbp)
   42385:	74 16                	je     4239d <check_keyboard+0x33>
   42387:	83 7d e4 63          	cmpl   $0x63,-0x1c(%rbp)
   4238b:	74 10                	je     4239d <check_keyboard+0x33>
   4238d:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   42391:	74 0a                	je     4239d <check_keyboard+0x33>
   42393:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   42397:	0f 85 e9 00 00 00    	jne    42486 <check_keyboard+0x11c>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   4239d:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   423a4:	00 
        memset(pt, 0, PAGESIZE * 3);
   423a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423a9:	ba 00 30 00 00       	mov    $0x3000,%edx
   423ae:	be 00 00 00 00       	mov    $0x0,%esi
   423b3:	48 89 c7             	mov    %rax,%rdi
   423b6:	e8 e4 0d 00 00       	callq  4319f <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   423bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423bf:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   423c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423ca:	48 05 00 10 00 00    	add    $0x1000,%rax
   423d0:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   423d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423db:	48 05 00 20 00 00    	add    $0x2000,%rax
   423e1:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   423e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423ec:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   423f0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   423f4:	0f 22 d8             	mov    %rax,%cr3
}
   423f7:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   423f8:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "malloc";
   423ff:	48 c7 45 e8 b8 4b 04 	movq   $0x44bb8,-0x18(%rbp)
   42406:	00 
        if (c == 'a') {
   42407:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   4240b:	75 0a                	jne    42417 <check_keyboard+0xad>
            argument = "allocator";
   4240d:	48 c7 45 e8 bf 4b 04 	movq   $0x44bbf,-0x18(%rbp)
   42414:	00 
   42415:	eb 2e                	jmp    42445 <check_keyboard+0xdb>
        } else if (c == 'c') {
   42417:	83 7d e4 63          	cmpl   $0x63,-0x1c(%rbp)
   4241b:	75 0a                	jne    42427 <check_keyboard+0xbd>
            argument = "alloctests";
   4241d:	48 c7 45 e8 c9 4b 04 	movq   $0x44bc9,-0x18(%rbp)
   42424:	00 
   42425:	eb 1e                	jmp    42445 <check_keyboard+0xdb>
        } else if(c == 't'){
   42427:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   4242b:	75 0a                	jne    42437 <check_keyboard+0xcd>
            argument = "test";
   4242d:	48 c7 45 e8 d4 4b 04 	movq   $0x44bd4,-0x18(%rbp)
   42434:	00 
   42435:	eb 0e                	jmp    42445 <check_keyboard+0xdb>
        }
        else if(c == '2'){
   42437:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   4243b:	75 08                	jne    42445 <check_keyboard+0xdb>
            argument = "test2";
   4243d:	48 c7 45 e8 d9 4b 04 	movq   $0x44bd9,-0x18(%rbp)
   42444:	00 
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   42445:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42449:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   4244d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42452:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   42456:	76 14                	jbe    4246c <check_keyboard+0x102>
   42458:	ba df 4b 04 00       	mov    $0x44bdf,%edx
   4245d:	be 5c 02 00 00       	mov    $0x25c,%esi
   42462:	bf fb 4b 04 00       	mov    $0x44bfb,%edi
   42467:	e8 1f 01 00 00       	callq  4258b <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   4246c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42470:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   42473:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   42477:	48 89 c3             	mov    %rax,%rbx
   4247a:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   4247f:	e9 7c db ff ff       	jmpq   40000 <entry_from_boot>
    if (c == 'a' || c == 'm' || c == 'c' || c == 't'|| c =='2') {
   42484:	eb 11                	jmp    42497 <check_keyboard+0x12d>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   42486:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   4248a:	74 06                	je     42492 <check_keyboard+0x128>
   4248c:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   42490:	75 05                	jne    42497 <check_keyboard+0x12d>
        poweroff();
   42492:	e8 a3 f8 ff ff       	callq  41d3a <poweroff>
    }
    return c;
   42497:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   4249a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   4249e:	c9                   	leaveq 
   4249f:	c3                   	retq   

00000000000424a0 <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   424a0:	55                   	push   %rbp
   424a1:	48 89 e5             	mov    %rsp,%rbp
    while (1) {
        check_keyboard();
   424a4:	e8 c1 fe ff ff       	callq  4236a <check_keyboard>
   424a9:	eb f9                	jmp    424a4 <fail+0x4>

00000000000424ab <kernel_panic>:

// kernel_panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void kernel_panic(const char* format, ...) {
   424ab:	55                   	push   %rbp
   424ac:	48 89 e5             	mov    %rsp,%rbp
   424af:	48 83 ec 60          	sub    $0x60,%rsp
   424b3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   424b7:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   424bb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   424bf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   424c3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   424c7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   424cb:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   424d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
   424d6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   424da:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   424de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   424e2:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   424e7:	0f 84 80 00 00 00    	je     4256d <kernel_panic+0xc2>
        // Print kernel_panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   424ed:	ba 08 4c 04 00       	mov    $0x44c08,%edx
   424f2:	be 00 c0 00 00       	mov    $0xc000,%esi
   424f7:	bf 30 07 00 00       	mov    $0x730,%edi
   424fc:	b8 00 00 00 00       	mov    $0x0,%eax
   42501:	e8 12 fe ff ff       	callq  42318 <error_printf>
   42506:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   42509:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   4250d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   42511:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42514:	be 00 c0 00 00       	mov    $0xc000,%esi
   42519:	89 c7                	mov    %eax,%edi
   4251b:	e8 9a fd ff ff       	callq  422ba <error_vprintf>
   42520:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   42523:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   42526:	48 63 c1             	movslq %ecx,%rax
   42529:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   42530:	48 c1 e8 20          	shr    $0x20,%rax
   42534:	c1 f8 05             	sar    $0x5,%eax
   42537:	89 ce                	mov    %ecx,%esi
   42539:	c1 fe 1f             	sar    $0x1f,%esi
   4253c:	29 f0                	sub    %esi,%eax
   4253e:	89 c2                	mov    %eax,%edx
   42540:	89 d0                	mov    %edx,%eax
   42542:	c1 e0 02             	shl    $0x2,%eax
   42545:	01 d0                	add    %edx,%eax
   42547:	c1 e0 04             	shl    $0x4,%eax
   4254a:	29 c1                	sub    %eax,%ecx
   4254c:	89 ca                	mov    %ecx,%edx
   4254e:	85 d2                	test   %edx,%edx
   42550:	74 34                	je     42586 <kernel_panic+0xdb>
            error_printf(cpos, 0xC000, "\n");
   42552:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42555:	ba 10 4c 04 00       	mov    $0x44c10,%edx
   4255a:	be 00 c0 00 00       	mov    $0xc000,%esi
   4255f:	89 c7                	mov    %eax,%edi
   42561:	b8 00 00 00 00       	mov    $0x0,%eax
   42566:	e8 ad fd ff ff       	callq  42318 <error_printf>
   4256b:	eb 19                	jmp    42586 <kernel_panic+0xdb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   4256d:	ba 12 4c 04 00       	mov    $0x44c12,%edx
   42572:	be 00 c0 00 00       	mov    $0xc000,%esi
   42577:	bf 30 07 00 00       	mov    $0x730,%edi
   4257c:	b8 00 00 00 00       	mov    $0x0,%eax
   42581:	e8 92 fd ff ff       	callq  42318 <error_printf>
    }

    va_end(val);
    fail();
   42586:	e8 15 ff ff ff       	callq  424a0 <fail>

000000000004258b <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   4258b:	55                   	push   %rbp
   4258c:	48 89 e5             	mov    %rsp,%rbp
   4258f:	48 83 ec 20          	sub    $0x20,%rsp
   42593:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42597:	89 75 f4             	mov    %esi,-0xc(%rbp)
   4259a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    kernel_panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   4259e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   425a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
   425a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   425a9:	48 89 c6             	mov    %rax,%rsi
   425ac:	bf 18 4c 04 00       	mov    $0x44c18,%edi
   425b1:	b8 00 00 00 00       	mov    $0x0,%eax
   425b6:	e8 f0 fe ff ff       	callq  424ab <kernel_panic>

00000000000425bb <default_exception>:
}

void default_exception(proc* p){
   425bb:	55                   	push   %rbp
   425bc:	48 89 e5             	mov    %rsp,%rbp
   425bf:	48 83 ec 20          	sub    $0x20,%rsp
   425c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    x86_64_registers * reg = &(p->p_registers);
   425c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   425cb:	48 83 c0 18          	add    $0x18,%rax
   425cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    kernel_panic("Unexpected exception %d!\n", reg->reg_intno);
   425d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   425d7:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   425de:	48 89 c6             	mov    %rax,%rsi
   425e1:	bf 36 4c 04 00       	mov    $0x44c36,%edi
   425e6:	b8 00 00 00 00       	mov    $0x0,%eax
   425eb:	e8 bb fe ff ff       	callq  424ab <kernel_panic>

00000000000425f0 <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   425f0:	55                   	push   %rbp
   425f1:	48 89 e5             	mov    %rsp,%rbp
   425f4:	48 83 ec 10          	sub    $0x10,%rsp
   425f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   425fc:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   425ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   42603:	78 06                	js     4260b <pageindex+0x1b>
   42605:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   42609:	7e 14                	jle    4261f <pageindex+0x2f>
   4260b:	ba 50 4c 04 00       	mov    $0x44c50,%edx
   42610:	be 1e 00 00 00       	mov    $0x1e,%esi
   42615:	bf 69 4c 04 00       	mov    $0x44c69,%edi
   4261a:	e8 6c ff ff ff       	callq  4258b <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF;
   4261f:	b8 03 00 00 00       	mov    $0x3,%eax
   42624:	2b 45 f4             	sub    -0xc(%rbp),%eax
   42627:	89 c2                	mov    %eax,%edx
   42629:	89 d0                	mov    %edx,%eax
   4262b:	c1 e0 03             	shl    $0x3,%eax
   4262e:	01 d0                	add    %edx,%eax
   42630:	83 c0 0c             	add    $0xc,%eax
   42633:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42637:	89 c1                	mov    %eax,%ecx
   42639:	48 d3 ea             	shr    %cl,%rdx
   4263c:	48 89 d0             	mov    %rdx,%rax
   4263f:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   42644:	c9                   	leaveq 
   42645:	c3                   	retq   

0000000000042646 <virtual_memory_init>:

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;


void virtual_memory_init(void) {
   42646:	55                   	push   %rbp
   42647:	48 89 e5             	mov    %rsp,%rbp
   4264a:	48 83 ec 20          	sub    $0x20,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   4264e:	48 c7 05 a7 49 01 00 	movq   $0x58000,0x149a7(%rip)        # 57000 <kernel_pagetable>
   42655:	00 80 05 00 
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   42659:	ba 00 50 00 00       	mov    $0x5000,%edx
   4265e:	be 00 00 00 00       	mov    $0x0,%esi
   42663:	bf 00 80 05 00       	mov    $0x58000,%edi
   42668:	e8 32 0b 00 00       	callq  4319f <memset>

    // connect the pagetable pages
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   4266d:	b8 00 90 05 00       	mov    $0x59000,%eax
   42672:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   42676:	48 89 05 83 59 01 00 	mov    %rax,0x15983(%rip)        # 58000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   4267d:	b8 00 a0 05 00       	mov    $0x5a000,%eax
   42682:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   42686:	48 89 05 73 69 01 00 	mov    %rax,0x16973(%rip)        # 59000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   4268d:	b8 00 b0 05 00       	mov    $0x5b000,%eax
   42692:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   42696:	48 89 05 63 79 01 00 	mov    %rax,0x17963(%rip)        # 5a000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   4269d:	b8 00 c0 05 00       	mov    $0x5c000,%eax
   426a2:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   426a6:	48 89 05 5b 79 01 00 	mov    %rax,0x1795b(%rip)        # 5a008 <kernel_pagetables+0x2008>

    // identity map the page table
    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   426ad:	48 8b 05 4c 49 01 00 	mov    0x1494c(%rip),%rax        # 57000 <kernel_pagetable>
   426b4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   426ba:	b9 00 00 20 00       	mov    $0x200000,%ecx
   426bf:	ba 00 00 00 00       	mov    $0x0,%edx
   426c4:	be 00 00 00 00       	mov    $0x0,%esi
   426c9:	48 89 c7             	mov    %rax,%rdi
   426cc:	e8 b9 01 00 00       	callq  4288a <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W | PTE_U);

    // check if kernel is identity mapped
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   426d1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   426d8:	00 
   426d9:	eb 62                	jmp    4273d <virtual_memory_init+0xf7>
        vamapping vmap = virtual_memory_lookup(kernel_pagetable, addr);
   426db:	48 8b 0d 1e 49 01 00 	mov    0x1491e(%rip),%rcx        # 57000 <kernel_pagetable>
   426e2:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   426e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   426ea:	48 89 ce             	mov    %rcx,%rsi
   426ed:	48 89 c7             	mov    %rax,%rdi
   426f0:	e8 58 05 00 00       	callq  42c4d <virtual_memory_lookup>
        // this assert will probably fail initially!
        // have you implemented virtual_memory_map and lookup_l4pagetable ?
        assert(vmap.pa == addr);
   426f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   426f9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   426fd:	74 14                	je     42713 <virtual_memory_init+0xcd>
   426ff:	ba 72 4c 04 00       	mov    $0x44c72,%edx
   42704:	be 2d 00 00 00       	mov    $0x2d,%esi
   42709:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   4270e:	e8 78 fe ff ff       	callq  4258b <assert_fail>
        assert((vmap.perm & (PTE_P|PTE_W)) == (PTE_P|PTE_W));
   42713:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42716:	48 98                	cltq   
   42718:	83 e0 03             	and    $0x3,%eax
   4271b:	48 83 f8 03          	cmp    $0x3,%rax
   4271f:	74 14                	je     42735 <virtual_memory_init+0xef>
   42721:	ba 88 4c 04 00       	mov    $0x44c88,%edx
   42726:	be 2e 00 00 00       	mov    $0x2e,%esi
   4272b:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42730:	e8 56 fe ff ff       	callq  4258b <assert_fail>
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   42735:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4273c:	00 
   4273d:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   42744:	00 
   42745:	76 94                	jbe    426db <virtual_memory_init+0x95>
    }

    // set pointer to this pagetable in the CR3 register
    // set_pagetable also does several checks for a valid pagetable
    set_pagetable(kernel_pagetable);
   42747:	48 8b 05 b2 48 01 00 	mov    0x148b2(%rip),%rax        # 57000 <kernel_pagetable>
   4274e:	48 89 c7             	mov    %rax,%rdi
   42751:	e8 03 00 00 00       	callq  42759 <set_pagetable>
}
   42756:	90                   	nop
   42757:	c9                   	leaveq 
   42758:	c3                   	retq   

0000000000042759 <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls kernel_panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   42759:	55                   	push   %rbp
   4275a:	48 89 e5             	mov    %rsp,%rbp
   4275d:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42761:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   42765:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42769:	25 ff 0f 00 00       	and    $0xfff,%eax
   4276e:	48 85 c0             	test   %rax,%rax
   42771:	74 14                	je     42787 <set_pagetable+0x2e>
   42773:	ba b5 4c 04 00       	mov    $0x44cb5,%edx
   42778:	be 3d 00 00 00       	mov    $0x3d,%esi
   4277d:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42782:	e8 04 fe ff ff       	callq  4258b <assert_fail>
    // check for kernel space being mapped in pagetable
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   42787:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   4278c:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   42790:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42794:	48 89 ce             	mov    %rcx,%rsi
   42797:	48 89 c7             	mov    %rax,%rdi
   4279a:	e8 ae 04 00 00       	callq  42c4d <virtual_memory_lookup>
   4279f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   427a3:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   427a8:	48 39 d0             	cmp    %rdx,%rax
   427ab:	74 14                	je     427c1 <set_pagetable+0x68>
   427ad:	ba d0 4c 04 00       	mov    $0x44cd0,%edx
   427b2:	be 3f 00 00 00       	mov    $0x3f,%esi
   427b7:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   427bc:	e8 ca fd ff ff       	callq  4258b <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   427c1:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   427c5:	48 8b 0d 34 48 01 00 	mov    0x14834(%rip),%rcx        # 57000 <kernel_pagetable>
   427cc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   427d0:	48 89 ce             	mov    %rcx,%rsi
   427d3:	48 89 c7             	mov    %rax,%rdi
   427d6:	e8 72 04 00 00       	callq  42c4d <virtual_memory_lookup>
   427db:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   427df:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   427e3:	48 39 c2             	cmp    %rax,%rdx
   427e6:	74 14                	je     427fc <set_pagetable+0xa3>
   427e8:	ba 38 4d 04 00       	mov    $0x44d38,%edx
   427ed:	be 41 00 00 00       	mov    $0x41,%esi
   427f2:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   427f7:	e8 8f fd ff ff       	callq  4258b <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   427fc:	48 8b 05 fd 47 01 00 	mov    0x147fd(%rip),%rax        # 57000 <kernel_pagetable>
   42803:	48 89 c2             	mov    %rax,%rdx
   42806:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   4280a:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   4280e:	48 89 ce             	mov    %rcx,%rsi
   42811:	48 89 c7             	mov    %rax,%rdi
   42814:	e8 34 04 00 00       	callq  42c4d <virtual_memory_lookup>
   42819:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4281d:	48 8b 15 dc 47 01 00 	mov    0x147dc(%rip),%rdx        # 57000 <kernel_pagetable>
   42824:	48 39 d0             	cmp    %rdx,%rax
   42827:	74 14                	je     4283d <set_pagetable+0xe4>
   42829:	ba 98 4d 04 00       	mov    $0x44d98,%edx
   4282e:	be 43 00 00 00       	mov    $0x43,%esi
   42833:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42838:	e8 4e fd ff ff       	callq  4258b <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   4283d:	ba 8a 28 04 00       	mov    $0x4288a,%edx
   42842:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42846:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   4284a:	48 89 ce             	mov    %rcx,%rsi
   4284d:	48 89 c7             	mov    %rax,%rdi
   42850:	e8 f8 03 00 00       	callq  42c4d <virtual_memory_lookup>
   42855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42859:	ba 8a 28 04 00       	mov    $0x4288a,%edx
   4285e:	48 39 d0             	cmp    %rdx,%rax
   42861:	74 14                	je     42877 <set_pagetable+0x11e>
   42863:	ba 00 4e 04 00       	mov    $0x44e00,%edx
   42868:	be 45 00 00 00       	mov    $0x45,%esi
   4286d:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42872:	e8 14 fd ff ff       	callq  4258b <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   42877:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   4287b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   4287f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42883:	0f 22 d8             	mov    %rax,%cr3
}
   42886:	90                   	nop
}
   42887:	90                   	nop
   42888:	c9                   	leaveq 
   42889:	c3                   	retq   

000000000004288a <virtual_memory_map>:
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm);

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm) {
   4288a:	55                   	push   %rbp
   4288b:	48 89 e5             	mov    %rsp,%rbp
   4288e:	53                   	push   %rbx
   4288f:	48 83 ec 58          	sub    $0x58,%rsp
   42893:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42897:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   4289b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
   4289f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
   428a3:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)

    // sanity checks for virtual address, size, and permisions
    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   428a7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   428ab:	25 ff 0f 00 00       	and    $0xfff,%eax
   428b0:	48 85 c0             	test   %rax,%rax
   428b3:	74 14                	je     428c9 <virtual_memory_map+0x3f>
   428b5:	ba 66 4e 04 00       	mov    $0x44e66,%edx
   428ba:	be 66 00 00 00       	mov    $0x66,%esi
   428bf:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   428c4:	e8 c2 fc ff ff       	callq  4258b <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multiple of PAGESIZE
   428c9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   428cd:	25 ff 0f 00 00       	and    $0xfff,%eax
   428d2:	48 85 c0             	test   %rax,%rax
   428d5:	74 14                	je     428eb <virtual_memory_map+0x61>
   428d7:	ba 79 4e 04 00       	mov    $0x44e79,%edx
   428dc:	be 67 00 00 00       	mov    $0x67,%esi
   428e1:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   428e6:	e8 a0 fc ff ff       	callq  4258b <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   428eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   428ef:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   428f3:	48 01 d0             	add    %rdx,%rax
   428f6:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
   428fa:	76 24                	jbe    42920 <virtual_memory_map+0x96>
   428fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   42900:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42904:	48 01 d0             	add    %rdx,%rax
   42907:	48 85 c0             	test   %rax,%rax
   4290a:	74 14                	je     42920 <virtual_memory_map+0x96>
   4290c:	ba 8c 4e 04 00       	mov    $0x44e8c,%edx
   42911:	be 68 00 00 00       	mov    $0x68,%esi
   42916:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   4291b:	e8 6b fc ff ff       	callq  4258b <assert_fail>
    if (perm & PTE_P) {
   42920:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42923:	48 98                	cltq   
   42925:	83 e0 01             	and    $0x1,%eax
   42928:	48 85 c0             	test   %rax,%rax
   4292b:	74 6e                	je     4299b <virtual_memory_map+0x111>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   4292d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42931:	25 ff 0f 00 00       	and    $0xfff,%eax
   42936:	48 85 c0             	test   %rax,%rax
   42939:	74 14                	je     4294f <virtual_memory_map+0xc5>
   4293b:	ba aa 4e 04 00       	mov    $0x44eaa,%edx
   42940:	be 6a 00 00 00       	mov    $0x6a,%esi
   42945:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   4294a:	e8 3c fc ff ff       	callq  4258b <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   4294f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42953:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42957:	48 01 d0             	add    %rdx,%rax
   4295a:	48 39 45 b8          	cmp    %rax,-0x48(%rbp)
   4295e:	76 14                	jbe    42974 <virtual_memory_map+0xea>
   42960:	ba bd 4e 04 00       	mov    $0x44ebd,%edx
   42965:	be 6b 00 00 00       	mov    $0x6b,%esi
   4296a:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   4296f:	e8 17 fc ff ff       	callq  4258b <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   42974:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42978:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   4297c:	48 01 d0             	add    %rdx,%rax
   4297f:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   42985:	76 14                	jbe    4299b <virtual_memory_map+0x111>
   42987:	ba cb 4e 04 00       	mov    $0x44ecb,%edx
   4298c:	be 6c 00 00 00       	mov    $0x6c,%esi
   42991:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42996:	e8 f0 fb ff ff       	callq  4258b <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense (perm can only be 12 bits)
   4299b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
   4299f:	78 09                	js     429aa <virtual_memory_map+0x120>
   429a1:	81 7d ac ff 0f 00 00 	cmpl   $0xfff,-0x54(%rbp)
   429a8:	7e 14                	jle    429be <virtual_memory_map+0x134>
   429aa:	ba e7 4e 04 00       	mov    $0x44ee7,%edx
   429af:	be 6e 00 00 00       	mov    $0x6e,%esi
   429b4:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   429b9:	e8 cd fb ff ff       	callq  4258b <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   429be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   429c2:	25 ff 0f 00 00       	and    $0xfff,%eax
   429c7:	48 85 c0             	test   %rax,%rax
   429ca:	74 14                	je     429e0 <virtual_memory_map+0x156>
   429cc:	ba 08 4f 04 00       	mov    $0x44f08,%edx
   429d1:	be 6f 00 00 00       	mov    $0x6f,%esi
   429d6:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   429db:	e8 ab fb ff ff       	callq  4258b <assert_fail>

    int last_index123 = -1;
   429e0:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%rbp)
    x86_64_pagetable* l4pagetable = NULL;
   429e7:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
   429ee:	00 

    // for each page-aligned address, set the appropriate page entry
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   429ef:	e9 e1 00 00 00       	jmpq   42ad5 <virtual_memory_map+0x24b>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   429f4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   429f8:	48 c1 e8 15          	shr    $0x15,%rax
   429fc:	89 45 dc             	mov    %eax,-0x24(%rbp)
        if (cur_index123 != last_index123) {
   429ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42a02:	3b 45 ec             	cmp    -0x14(%rbp),%eax
   42a05:	74 20                	je     42a27 <virtual_memory_map+0x19d>
            // find pointer to last level pagetable for current va
            l4pagetable = lookup_l4pagetable(pagetable, va, perm);
   42a07:	8b 55 ac             	mov    -0x54(%rbp),%edx
   42a0a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   42a0e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42a12:	48 89 ce             	mov    %rcx,%rsi
   42a15:	48 89 c7             	mov    %rax,%rdi
   42a18:	e8 ce 00 00 00       	callq  42aeb <lookup_l4pagetable>
   42a1d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            last_index123 = cur_index123;
   42a21:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42a24:	89 45 ec             	mov    %eax,-0x14(%rbp)
        }
        if ((perm & PTE_P) && l4pagetable) { // if page is marked present
   42a27:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a2a:	48 98                	cltq   
   42a2c:	83 e0 01             	and    $0x1,%eax
   42a2f:	48 85 c0             	test   %rax,%rax
   42a32:	74 34                	je     42a68 <virtual_memory_map+0x1de>
   42a34:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42a39:	74 2d                	je     42a68 <virtual_memory_map+0x1de>
            // set page table entry to pa and perm
            l4pagetable->entry[L4PAGEINDEX(va)] = pa | perm;
   42a3b:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a3e:	48 63 d8             	movslq %eax,%rbx
   42a41:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42a45:	be 03 00 00 00       	mov    $0x3,%esi
   42a4a:	48 89 c7             	mov    %rax,%rdi
   42a4d:	e8 9e fb ff ff       	callq  425f0 <pageindex>
   42a52:	89 c2                	mov    %eax,%edx
   42a54:	48 0b 5d b8          	or     -0x48(%rbp),%rbx
   42a58:	48 89 d9             	mov    %rbx,%rcx
   42a5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42a5f:	48 63 d2             	movslq %edx,%rdx
   42a62:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42a66:	eb 55                	jmp    42abd <virtual_memory_map+0x233>
        } else if (l4pagetable) { // if page is NOT marked present
   42a68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42a6d:	74 26                	je     42a95 <virtual_memory_map+0x20b>
            // set page table entry to just perm
            l4pagetable->entry[L4PAGEINDEX(va)] = perm;
   42a6f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42a73:	be 03 00 00 00       	mov    $0x3,%esi
   42a78:	48 89 c7             	mov    %rax,%rdi
   42a7b:	e8 70 fb ff ff       	callq  425f0 <pageindex>
   42a80:	89 c2                	mov    %eax,%edx
   42a82:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a85:	48 63 c8             	movslq %eax,%rcx
   42a88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42a8c:	48 63 d2             	movslq %edx,%rdx
   42a8f:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42a93:	eb 28                	jmp    42abd <virtual_memory_map+0x233>
        } else if (perm & PTE_P) {
   42a95:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a98:	48 98                	cltq   
   42a9a:	83 e0 01             	and    $0x1,%eax
   42a9d:	48 85 c0             	test   %rax,%rax
   42aa0:	74 1b                	je     42abd <virtual_memory_map+0x233>
            // error, no allocated l4 page found for va
            log_printf("[Kern Info] failed to find l4pagetable address at " __FILE__ ": %d\n", __LINE__);
   42aa2:	be 84 00 00 00       	mov    $0x84,%esi
   42aa7:	bf 30 4f 04 00       	mov    $0x44f30,%edi
   42aac:	b8 00 00 00 00       	mov    $0x0,%eax
   42ab1:	e8 b7 f7 ff ff       	callq  4226d <log_printf>
            return -1;
   42ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42abb:	eb 28                	jmp    42ae5 <virtual_memory_map+0x25b>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42abd:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
   42ac4:	00 
   42ac5:	48 81 45 b8 00 10 00 	addq   $0x1000,-0x48(%rbp)
   42acc:	00 
   42acd:	48 81 6d b0 00 10 00 	subq   $0x1000,-0x50(%rbp)
   42ad4:	00 
   42ad5:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   42ada:	0f 85 14 ff ff ff    	jne    429f4 <virtual_memory_map+0x16a>
        }
    }
    return 0;
   42ae0:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42ae5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   42ae9:	c9                   	leaveq 
   42aea:	c3                   	retq   

0000000000042aeb <lookup_l4pagetable>:
//
//    Returns an x86_64_pagetable pointer to the last level pagetable
//    if it exists and can be accessed with the given permissions
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm) {
   42aeb:	55                   	push   %rbp
   42aec:	48 89 e5             	mov    %rsp,%rbp
   42aef:	48 83 ec 40          	sub    $0x40,%rsp
   42af3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42af7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   42afb:	89 55 cc             	mov    %edx,-0x34(%rbp)
    x86_64_pagetable* pt = pagetable;
   42afe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42b02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    // 1. Find index to the next pagetable entry using the `va`
    // 2. Check if this entry has the appropriate requested permissions
    // 3. Repeat the steps till you reach the l4 pagetable (i.e thrice)
    // 4. return the pagetable address

    for (int i = 0; i <= 2; ++i) {
   42b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42b0d:	e9 2b 01 00 00       	jmpq   42c3d <lookup_l4pagetable+0x152>
        // find page entry by finding `ith` level index of va to index pagetable entries of `pt`
        // you should read x86-64.h to understand relevant structs and macros to make this part easier
        x86_64_pageentry_t pe = pt->entry[PAGEINDEX(va, i)];
   42b12:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42b15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42b19:	89 d6                	mov    %edx,%esi
   42b1b:	48 89 c7             	mov    %rax,%rdi
   42b1e:	e8 cd fa ff ff       	callq  425f0 <pageindex>
   42b23:	89 c2                	mov    %eax,%edx
   42b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42b29:	48 63 d2             	movslq %edx,%rdx
   42b2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   42b30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

        if (!(pe & PTE_P)) { // address of next level should be present AND PTE_P should be set, error otherwise
   42b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b38:	83 e0 01             	and    $0x1,%eax
   42b3b:	48 85 c0             	test   %rax,%rax
   42b3e:	75 63                	jne    42ba3 <lookup_l4pagetable+0xb8>
            log_printf("[Kern Info] Error looking up l4pagetable: Pagetable address: 0x%x perm: 0x%x."
   42b40:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42b43:	8d 48 02             	lea    0x2(%rax),%ecx
   42b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b4a:	25 ff 0f 00 00       	and    $0xfff,%eax
   42b4f:	48 89 c2             	mov    %rax,%rdx
   42b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b56:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42b5c:	48 89 c6             	mov    %rax,%rsi
   42b5f:	bf 70 4f 04 00       	mov    $0x44f70,%edi
   42b64:	b8 00 00 00 00       	mov    $0x0,%eax
   42b69:	e8 ff f6 ff ff       	callq  4226d <log_printf>
                    " Failed to get level (%d)\n",
                    PTE_ADDR(pe), PTE_FLAGS(pe), (i+2));
            if (!(perm & PTE_P)) {
   42b6e:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42b71:	48 98                	cltq   
   42b73:	83 e0 01             	and    $0x1,%eax
   42b76:	48 85 c0             	test   %rax,%rax
   42b79:	75 0a                	jne    42b85 <lookup_l4pagetable+0x9a>
                return NULL;
   42b7b:	b8 00 00 00 00       	mov    $0x0,%eax
   42b80:	e9 c6 00 00 00       	jmpq   42c4b <lookup_l4pagetable+0x160>
            }
            log_printf("[Kern Info] failed to find pagetable address at " __FILE__ ": %d\n", __LINE__);
   42b85:	be a7 00 00 00       	mov    $0xa7,%esi
   42b8a:	bf d8 4f 04 00       	mov    $0x44fd8,%edi
   42b8f:	b8 00 00 00 00       	mov    $0x0,%eax
   42b94:	e8 d4 f6 ff ff       	callq  4226d <log_printf>
            return NULL;
   42b99:	b8 00 00 00 00       	mov    $0x0,%eax
   42b9e:	e9 a8 00 00 00       	jmpq   42c4b <lookup_l4pagetable+0x160>
        }

        // sanity-check page entry and permissions
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   42ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42ba7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42bad:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   42bb3:	76 14                	jbe    42bc9 <lookup_l4pagetable+0xde>
   42bb5:	ba 18 50 04 00       	mov    $0x45018,%edx
   42bba:	be ac 00 00 00       	mov    $0xac,%esi
   42bbf:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42bc4:	e8 c2 f9 ff ff       	callq  4258b <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   42bc9:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42bcc:	48 98                	cltq   
   42bce:	83 e0 02             	and    $0x2,%eax
   42bd1:	48 85 c0             	test   %rax,%rax
   42bd4:	74 20                	je     42bf6 <lookup_l4pagetable+0x10b>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   42bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42bda:	83 e0 02             	and    $0x2,%eax
   42bdd:	48 85 c0             	test   %rax,%rax
   42be0:	75 14                	jne    42bf6 <lookup_l4pagetable+0x10b>
   42be2:	ba 38 50 04 00       	mov    $0x45038,%edx
   42be7:	be ae 00 00 00       	mov    $0xae,%esi
   42bec:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42bf1:	e8 95 f9 ff ff       	callq  4258b <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   42bf6:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42bf9:	48 98                	cltq   
   42bfb:	83 e0 04             	and    $0x4,%eax
   42bfe:	48 85 c0             	test   %rax,%rax
   42c01:	74 20                	je     42c23 <lookup_l4pagetable+0x138>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   42c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42c07:	83 e0 04             	and    $0x4,%eax
   42c0a:	48 85 c0             	test   %rax,%rax
   42c0d:	75 14                	jne    42c23 <lookup_l4pagetable+0x138>
   42c0f:	ba 43 50 04 00       	mov    $0x45043,%edx
   42c14:	be b1 00 00 00       	mov    $0xb1,%esi
   42c19:	bf 82 4c 04 00       	mov    $0x44c82,%edi
   42c1e:	e8 68 f9 ff ff       	callq  4258b <assert_fail>
        }

        // set pt to physical address to next pagetable using `pe`
        pt = 0; // replace this
   42c23:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   42c2a:	00 
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42c2f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42c35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   42c39:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   42c3d:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   42c41:	0f 8e cb fe ff ff    	jle    42b12 <lookup_l4pagetable+0x27>
    }
    return pt;
   42c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   42c4b:	c9                   	leaveq 
   42c4c:	c3                   	retq   

0000000000042c4d <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   42c4d:	55                   	push   %rbp
   42c4e:	48 89 e5             	mov    %rsp,%rbp
   42c51:	48 83 ec 50          	sub    $0x50,%rsp
   42c55:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42c59:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   42c5d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   42c61:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42c65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = PTE_W | PTE_U | PTE_P;
   42c69:	48 c7 45 f0 07 00 00 	movq   $0x7,-0x10(%rbp)
   42c70:	00 
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42c71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
   42c78:	eb 41                	jmp    42cbb <virtual_memory_lookup+0x6e>
        pe = pt->entry[PAGEINDEX(va, i)] & ~(pe & (PTE_W | PTE_U));
   42c7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42c7d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42c81:	89 d6                	mov    %edx,%esi
   42c83:	48 89 c7             	mov    %rax,%rdi
   42c86:	e8 65 f9 ff ff       	callq  425f0 <pageindex>
   42c8b:	89 c2                	mov    %eax,%edx
   42c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c91:	48 63 d2             	movslq %edx,%rdx
   42c94:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
   42c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42c9c:	83 e0 06             	and    $0x6,%eax
   42c9f:	48 f7 d0             	not    %rax
   42ca2:	48 21 d0             	and    %rdx,%rax
   42ca5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cad:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42cb3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42cb7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
   42cbb:	83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
   42cbf:	7f 0c                	jg     42ccd <virtual_memory_lookup+0x80>
   42cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cc5:	83 e0 01             	and    $0x1,%eax
   42cc8:	48 85 c0             	test   %rax,%rax
   42ccb:	75 ad                	jne    42c7a <virtual_memory_lookup+0x2d>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   42ccd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   42cd4:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   42cdb:	ff 
   42cdc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (pe & PTE_P) {
   42ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42ce7:	83 e0 01             	and    $0x1,%eax
   42cea:	48 85 c0             	test   %rax,%rax
   42ced:	74 34                	je     42d23 <virtual_memory_lookup+0xd6>
        vam.pn = PAGENUMBER(pe);
   42cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cf3:	48 c1 e8 0c          	shr    $0xc,%rax
   42cf7:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   42cfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cfe:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42d04:	48 89 c2             	mov    %rax,%rdx
   42d07:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42d0b:	25 ff 0f 00 00       	and    $0xfff,%eax
   42d10:	48 09 d0             	or     %rdx,%rax
   42d13:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = PTE_FLAGS(pe);
   42d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42d1b:	25 ff 0f 00 00       	and    $0xfff,%eax
   42d20:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   42d23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42d27:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42d2b:	48 89 10             	mov    %rdx,(%rax)
   42d2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   42d32:	48 89 50 08          	mov    %rdx,0x8(%rax)
   42d36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   42d3a:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   42d3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42d42:	c9                   	leaveq 
   42d43:	c3                   	retq   

0000000000042d44 <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   42d44:	55                   	push   %rbp
   42d45:	48 89 e5             	mov    %rsp,%rbp
   42d48:	48 83 ec 40          	sub    $0x40,%rsp
   42d4c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42d50:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   42d53:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   42d57:	c7 45 f8 07 00 00 00 	movl   $0x7,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   42d5e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   42d62:	78 08                	js     42d6c <program_load+0x28>
   42d64:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   42d67:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   42d6a:	7c 14                	jl     42d80 <program_load+0x3c>
   42d6c:	ba 50 50 04 00       	mov    $0x45050,%edx
   42d71:	be 37 00 00 00       	mov    $0x37,%esi
   42d76:	bf 80 50 04 00       	mov    $0x45080,%edi
   42d7b:	e8 0b f8 ff ff       	callq  4258b <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   42d80:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   42d83:	48 98                	cltq   
   42d85:	48 c1 e0 04          	shl    $0x4,%rax
   42d89:	48 05 20 60 04 00    	add    $0x46020,%rax
   42d8f:	48 8b 00             	mov    (%rax),%rax
   42d92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   42d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42d9a:	8b 00                	mov    (%rax),%eax
   42d9c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   42da1:	74 14                	je     42db7 <program_load+0x73>
   42da3:	ba 8b 50 04 00       	mov    $0x4508b,%edx
   42da8:	be 39 00 00 00       	mov    $0x39,%esi
   42dad:	bf 80 50 04 00       	mov    $0x45080,%edi
   42db2:	e8 d4 f7 ff ff       	callq  4258b <assert_fail>

    // load each loadable program segment into memory
    // ph is a pointer to an array of elf_program objects (elf headers)
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   42db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42dbb:	48 8b 50 20          	mov    0x20(%rax),%rdx
   42dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42dc3:	48 01 d0             	add    %rdx,%rax
   42dc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    // for each program header
    for (int i = 0; i < eh->e_phnum; ++i) {
   42dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42dd1:	e9 94 00 00 00       	jmpq   42e6a <program_load+0x126>
        // ph[i] is the current program header
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   42dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42dd9:	48 63 d0             	movslq %eax,%rdx
   42ddc:	48 89 d0             	mov    %rdx,%rax
   42ddf:	48 c1 e0 03          	shl    $0x3,%rax
   42de3:	48 29 d0             	sub    %rdx,%rax
   42de6:	48 c1 e0 03          	shl    $0x3,%rax
   42dea:	48 89 c2             	mov    %rax,%rdx
   42ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42df1:	48 01 d0             	add    %rdx,%rax
   42df4:	8b 00                	mov    (%rax),%eax
   42df6:	83 f8 01             	cmp    $0x1,%eax
   42df9:	75 6b                	jne    42e66 <program_load+0x122>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   42dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42dfe:	48 63 d0             	movslq %eax,%rdx
   42e01:	48 89 d0             	mov    %rdx,%rax
   42e04:	48 c1 e0 03          	shl    $0x3,%rax
   42e08:	48 29 d0             	sub    %rdx,%rax
   42e0b:	48 c1 e0 03          	shl    $0x3,%rax
   42e0f:	48 89 c2             	mov    %rax,%rdx
   42e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42e16:	48 01 d0             	add    %rdx,%rax
   42e19:	48 8b 50 08          	mov    0x8(%rax),%rdx
   42e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e21:	48 01 d0             	add    %rdx,%rax
   42e24:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            // load the segment
            // increment break variable by ph[i].p_memsz
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   42e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42e2b:	48 63 d0             	movslq %eax,%rdx
   42e2e:	48 89 d0             	mov    %rdx,%rax
   42e31:	48 c1 e0 03          	shl    $0x3,%rax
   42e35:	48 29 d0             	sub    %rdx,%rax
   42e38:	48 c1 e0 03          	shl    $0x3,%rax
   42e3c:	48 89 c2             	mov    %rax,%rdx
   42e3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42e43:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   42e47:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   42e4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   42e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42e53:	48 89 c7             	mov    %rax,%rdi
   42e56:	e8 3d 00 00 00       	callq  42e98 <program_load_segment>
   42e5b:	85 c0                	test   %eax,%eax
   42e5d:	79 07                	jns    42e66 <program_load+0x122>
                return -1;
   42e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42e64:	eb 30                	jmp    42e96 <program_load+0x152>
    for (int i = 0; i < eh->e_phnum; ++i) {
   42e66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   42e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e6e:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   42e72:	0f b7 c0             	movzwl %ax,%eax
   42e75:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   42e78:	0f 8c 58 ff ff ff    	jl     42dd6 <program_load+0x92>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   42e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e82:	48 8b 50 18          	mov    0x18(%rax),%rdx
   42e86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42e8a:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    return 0;
   42e91:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42e96:	c9                   	leaveq 
   42e97:	c3                   	retq   

0000000000042e98 <program_load_segment>:
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.

static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   42e98:	55                   	push   %rbp
   42e99:	48 89 e5             	mov    %rsp,%rbp
   42e9c:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42ea0:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
   42ea4:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
   42ea8:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
   42eac:	48 89 4d 80          	mov    %rcx,-0x80(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   42eb0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
   42eb4:	48 8b 40 10          	mov    0x10(%rax),%rax
   42eb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   42ebc:	48 8b 45 90          	mov    -0x70(%rbp),%rax
   42ec0:	48 8b 50 20          	mov    0x20(%rax),%rdx
   42ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42ec8:	48 01 d0             	add    %rdx,%rax
   42ecb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   42ecf:	48 8b 45 90          	mov    -0x70(%rbp),%rax
   42ed3:	48 8b 50 28          	mov    0x28(%rax),%rdx
   42ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42edb:	48 01 d0             	add    %rdx,%rax
   42ede:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   42ee2:	48 81 65 e8 00 f0 ff 	andq   $0xfffffffffffff000,-0x18(%rbp)
   42ee9:	ff 

    // allocate memory
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42eea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42eee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   42ef2:	eb 7c                	jmp    42f70 <program_load_segment+0xd8>
        uintptr_t pa = (uintptr_t)palloc(p->p_pid);
   42ef4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   42ef8:	8b 00                	mov    (%rax),%eax
   42efa:	89 c7                	mov    %eax,%edi
   42efc:	e8 aa 0b 00 00       	callq  43aab <palloc>
   42f01:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
        if(pa == (uintptr_t)NULL || virtual_memory_map(p->p_pagetable, addr, pa, PAGESIZE,
   42f05:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
   42f0a:	74 2a                	je     42f36 <program_load_segment+0x9e>
   42f0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   42f10:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   42f17:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42f1b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   42f1f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   42f25:	b9 00 10 00 00       	mov    $0x1000,%ecx
   42f2a:	48 89 c7             	mov    %rax,%rdi
   42f2d:	e8 58 f9 ff ff       	callq  4288a <virtual_memory_map>
   42f32:	85 c0                	test   %eax,%eax
   42f34:	79 32                	jns    42f68 <program_load_segment+0xd0>
                    PTE_W | PTE_P | PTE_U) < 0) {
            console_printf(CPOS(22, 0), 0xC000,
   42f36:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   42f3a:	8b 00                	mov    (%rax),%eax
   42f3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42f40:	49 89 d0             	mov    %rdx,%r8
   42f43:	89 c1                	mov    %eax,%ecx
   42f45:	ba a8 50 04 00       	mov    $0x450a8,%edx
   42f4a:	be 00 c0 00 00       	mov    $0xc000,%esi
   42f4f:	bf e0 06 00 00       	mov    $0x6e0,%edi
   42f54:	b8 00 00 00 00       	mov    $0x0,%eax
   42f59:	e8 76 0a 00 00       	callq  439d4 <console_printf>
                    "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
            return -1;
   42f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42f63:	e9 30 01 00 00       	jmpq   43098 <program_load_segment+0x200>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42f68:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   42f6f:	00 
   42f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42f74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   42f78:	0f 82 76 ff ff ff    	jb     42ef4 <program_load_segment+0x5c>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   42f7e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   42f82:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   42f89:	48 89 c7             	mov    %rax,%rdi
   42f8c:	e8 c8 f7 ff ff       	callq  42759 <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   42f91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42f95:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   42f99:	48 89 c2             	mov    %rax,%rdx
   42f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42fa0:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42fa4:	48 89 ce             	mov    %rcx,%rsi
   42fa7:	48 89 c7             	mov    %rax,%rdi
   42faa:	e8 87 01 00 00       	callq  43136 <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   42faf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42fb3:	48 2b 45 e0          	sub    -0x20(%rbp),%rax
   42fb7:	48 89 c2             	mov    %rax,%rdx
   42fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42fbe:	be 00 00 00 00       	mov    $0x0,%esi
   42fc3:	48 89 c7             	mov    %rax,%rdi
   42fc6:	e8 d4 01 00 00       	callq  4319f <memset>

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   42fcb:	48 8b 05 2e 40 01 00 	mov    0x1402e(%rip),%rax        # 57000 <kernel_pagetable>
   42fd2:	48 89 c7             	mov    %rax,%rdi
   42fd5:	e8 7f f7 ff ff       	callq  42759 <set_pagetable>


    if((ph->p_flags & ELF_PFLAG_WRITE) == 0) {
   42fda:	48 8b 45 90          	mov    -0x70(%rbp),%rax
   42fde:	8b 40 04             	mov    0x4(%rax),%eax
   42fe1:	83 e0 02             	and    $0x2,%eax
   42fe4:	85 c0                	test   %eax,%eax
   42fe6:	75 60                	jne    43048 <program_load_segment+0x1b0>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42fec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   42ff0:	eb 4c                	jmp    4303e <program_load_segment+0x1a6>
            vamapping mapping = virtual_memory_lookup(p->p_pagetable, addr);
   42ff2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   42ff6:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   42ffd:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   43001:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   43005:	48 89 ce             	mov    %rcx,%rsi
   43008:	48 89 c7             	mov    %rax,%rdi
   4300b:	e8 3d fc ff ff       	callq  42c4d <virtual_memory_lookup>

            virtual_memory_map(p->p_pagetable, addr, mapping.pa, PAGESIZE,
   43010:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   43014:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   43018:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   4301f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   43023:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   43029:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4302e:	48 89 c7             	mov    %rax,%rdi
   43031:	e8 54 f8 ff ff       	callq  4288a <virtual_memory_map>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   43036:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   4303d:	00 
   4303e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43042:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   43046:	72 aa                	jb     42ff2 <program_load_segment+0x15a>
                    PTE_P | PTE_U);
        }
    }
    // TODO : Add code here
    uintptr_t brk = ROUNDUP(end_mem, PAGESIZE);
   43048:	48 c7 45 d0 00 10 00 	movq   $0x1000,-0x30(%rbp)
   4304f:	00 
   43050:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   43054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43058:	48 01 d0             	add    %rdx,%rax
   4305b:	48 83 e8 01          	sub    $0x1,%rax
   4305f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
   43063:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43067:	ba 00 00 00 00       	mov    $0x0,%edx
   4306c:	48 f7 75 d0          	divq   -0x30(%rbp)
   43070:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43074:	48 29 d0             	sub    %rdx,%rax
   43077:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    p->original_break = brk;
   4307b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4307f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   43083:	48 89 50 10          	mov    %rdx,0x10(%rax)
    p->program_break = brk;
   43087:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4308b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   4308f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    return 0;
   43093:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43098:	c9                   	leaveq 
   43099:	c3                   	retq   

000000000004309a <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   4309a:	48 89 f9             	mov    %rdi,%rcx
   4309d:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   4309f:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
   430a6:	00 
   430a7:	72 08                	jb     430b1 <console_putc+0x17>
        cp->cursor = console;
   430a9:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
   430b0:	00 
    }
    if (c == '\n') {
   430b1:	40 80 fe 0a          	cmp    $0xa,%sil
   430b5:	74 16                	je     430cd <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
   430b7:	48 8b 41 08          	mov    0x8(%rcx),%rax
   430bb:	48 8d 50 02          	lea    0x2(%rax),%rdx
   430bf:	48 89 51 08          	mov    %rdx,0x8(%rcx)
   430c3:	40 0f b6 f6          	movzbl %sil,%esi
   430c7:	09 fe                	or     %edi,%esi
   430c9:	66 89 30             	mov    %si,(%rax)
    }
}
   430cc:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
   430cd:	4c 8b 41 08          	mov    0x8(%rcx),%r8
   430d1:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
   430d8:	4c 89 c6             	mov    %r8,%rsi
   430db:	48 d1 fe             	sar    %rsi
   430de:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   430e5:	66 66 66 
   430e8:	48 89 f0             	mov    %rsi,%rax
   430eb:	48 f7 ea             	imul   %rdx
   430ee:	48 c1 fa 05          	sar    $0x5,%rdx
   430f2:	49 c1 f8 3f          	sar    $0x3f,%r8
   430f6:	4c 29 c2             	sub    %r8,%rdx
   430f9:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
   430fd:	48 c1 e2 04          	shl    $0x4,%rdx
   43101:	89 f0                	mov    %esi,%eax
   43103:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
   43105:	83 cf 20             	or     $0x20,%edi
   43108:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   4310c:	48 8d 72 02          	lea    0x2(%rdx),%rsi
   43110:	48 89 71 08          	mov    %rsi,0x8(%rcx)
   43114:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
   43117:	83 c0 01             	add    $0x1,%eax
   4311a:	83 f8 50             	cmp    $0x50,%eax
   4311d:	75 e9                	jne    43108 <console_putc+0x6e>
   4311f:	c3                   	retq   

0000000000043120 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
   43120:	48 8b 47 08          	mov    0x8(%rdi),%rax
   43124:	48 3b 47 10          	cmp    0x10(%rdi),%rax
   43128:	73 0b                	jae    43135 <string_putc+0x15>
        *sp->s++ = c;
   4312a:	48 8d 50 01          	lea    0x1(%rax),%rdx
   4312e:	48 89 57 08          	mov    %rdx,0x8(%rdi)
   43132:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
   43135:	c3                   	retq   

0000000000043136 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
   43136:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43139:	48 85 d2             	test   %rdx,%rdx
   4313c:	74 17                	je     43155 <memcpy+0x1f>
   4313e:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
   43143:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
   43148:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   4314c:	48 83 c1 01          	add    $0x1,%rcx
   43150:	48 39 d1             	cmp    %rdx,%rcx
   43153:	75 ee                	jne    43143 <memcpy+0xd>
}
   43155:	c3                   	retq   

0000000000043156 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
   43156:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
   43159:	48 39 fe             	cmp    %rdi,%rsi
   4315c:	72 1d                	jb     4317b <memmove+0x25>
        while (n-- > 0) {
   4315e:	b9 00 00 00 00       	mov    $0x0,%ecx
   43163:	48 85 d2             	test   %rdx,%rdx
   43166:	74 12                	je     4317a <memmove+0x24>
            *d++ = *s++;
   43168:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
   4316c:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
   43170:	48 83 c1 01          	add    $0x1,%rcx
   43174:	48 39 ca             	cmp    %rcx,%rdx
   43177:	75 ef                	jne    43168 <memmove+0x12>
}
   43179:	c3                   	retq   
   4317a:	c3                   	retq   
    if (s < d && s + n > d) {
   4317b:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
   4317f:	48 39 cf             	cmp    %rcx,%rdi
   43182:	73 da                	jae    4315e <memmove+0x8>
        while (n-- > 0) {
   43184:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
   43188:	48 85 d2             	test   %rdx,%rdx
   4318b:	74 ec                	je     43179 <memmove+0x23>
            *--d = *--s;
   4318d:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
   43191:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
   43194:	48 83 e9 01          	sub    $0x1,%rcx
   43198:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
   4319c:	75 ef                	jne    4318d <memmove+0x37>
   4319e:	c3                   	retq   

000000000004319f <memset>:
void* memset(void* v, int c, size_t n) {
   4319f:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
   431a2:	48 85 d2             	test   %rdx,%rdx
   431a5:	74 12                	je     431b9 <memset+0x1a>
   431a7:	48 01 fa             	add    %rdi,%rdx
   431aa:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
   431ad:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   431b0:	48 83 c1 01          	add    $0x1,%rcx
   431b4:	48 39 ca             	cmp    %rcx,%rdx
   431b7:	75 f4                	jne    431ad <memset+0xe>
}
   431b9:	c3                   	retq   

00000000000431ba <strlen>:
    for (n = 0; *s != '\0'; ++s) {
   431ba:	80 3f 00             	cmpb   $0x0,(%rdi)
   431bd:	74 10                	je     431cf <strlen+0x15>
   431bf:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
   431c4:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
   431c8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
   431cc:	75 f6                	jne    431c4 <strlen+0xa>
   431ce:	c3                   	retq   
   431cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
   431d4:	c3                   	retq   

00000000000431d5 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
   431d5:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   431d8:	ba 00 00 00 00       	mov    $0x0,%edx
   431dd:	48 85 f6             	test   %rsi,%rsi
   431e0:	74 11                	je     431f3 <strnlen+0x1e>
   431e2:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
   431e6:	74 0c                	je     431f4 <strnlen+0x1f>
        ++n;
   431e8:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   431ec:	48 39 d0             	cmp    %rdx,%rax
   431ef:	75 f1                	jne    431e2 <strnlen+0xd>
   431f1:	eb 04                	jmp    431f7 <strnlen+0x22>
   431f3:	c3                   	retq   
   431f4:	48 89 d0             	mov    %rdx,%rax
}
   431f7:	c3                   	retq   

00000000000431f8 <strcpy>:
char* strcpy(char* dst, const char* src) {
   431f8:	48 89 f8             	mov    %rdi,%rax
   431fb:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
   43200:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
   43204:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
   43207:	48 83 c2 01          	add    $0x1,%rdx
   4320b:	84 c9                	test   %cl,%cl
   4320d:	75 f1                	jne    43200 <strcpy+0x8>
}
   4320f:	c3                   	retq   

0000000000043210 <strcmp>:
    while (*a && *b && *a == *b) {
   43210:	0f b6 07             	movzbl (%rdi),%eax
   43213:	84 c0                	test   %al,%al
   43215:	74 1a                	je     43231 <strcmp+0x21>
   43217:	0f b6 16             	movzbl (%rsi),%edx
   4321a:	38 c2                	cmp    %al,%dl
   4321c:	75 13                	jne    43231 <strcmp+0x21>
   4321e:	84 d2                	test   %dl,%dl
   43220:	74 0f                	je     43231 <strcmp+0x21>
        ++a, ++b;
   43222:	48 83 c7 01          	add    $0x1,%rdi
   43226:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
   4322a:	0f b6 07             	movzbl (%rdi),%eax
   4322d:	84 c0                	test   %al,%al
   4322f:	75 e6                	jne    43217 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
   43231:	3a 06                	cmp    (%rsi),%al
   43233:	0f 97 c0             	seta   %al
   43236:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
   43239:	83 d8 00             	sbb    $0x0,%eax
}
   4323c:	c3                   	retq   

000000000004323d <strchr>:
    while (*s && *s != (char) c) {
   4323d:	0f b6 07             	movzbl (%rdi),%eax
   43240:	84 c0                	test   %al,%al
   43242:	74 10                	je     43254 <strchr+0x17>
   43244:	40 38 f0             	cmp    %sil,%al
   43247:	74 18                	je     43261 <strchr+0x24>
        ++s;
   43249:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
   4324d:	0f b6 07             	movzbl (%rdi),%eax
   43250:	84 c0                	test   %al,%al
   43252:	75 f0                	jne    43244 <strchr+0x7>
        return NULL;
   43254:	40 84 f6             	test   %sil,%sil
   43257:	b8 00 00 00 00       	mov    $0x0,%eax
   4325c:	48 0f 44 c7          	cmove  %rdi,%rax
}
   43260:	c3                   	retq   
   43261:	48 89 f8             	mov    %rdi,%rax
   43264:	c3                   	retq   

0000000000043265 <rand>:
    if (!rand_seed_set) {
   43265:	83 3d 98 9d 01 00 00 	cmpl   $0x0,0x19d98(%rip)        # 5d004 <rand_seed_set>
   4326c:	74 1b                	je     43289 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
   4326e:	69 05 88 9d 01 00 0d 	imul   $0x19660d,0x19d88(%rip),%eax        # 5d000 <rand_seed>
   43275:	66 19 00 
   43278:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   4327d:	89 05 7d 9d 01 00    	mov    %eax,0x19d7d(%rip)        # 5d000 <rand_seed>
    return rand_seed & RAND_MAX;
   43283:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   43288:	c3                   	retq   
    rand_seed = seed;
   43289:	c7 05 6d 9d 01 00 9e 	movl   $0x30d4879e,0x19d6d(%rip)        # 5d000 <rand_seed>
   43290:	87 d4 30 
    rand_seed_set = 1;
   43293:	c7 05 67 9d 01 00 01 	movl   $0x1,0x19d67(%rip)        # 5d004 <rand_seed_set>
   4329a:	00 00 00 
}
   4329d:	eb cf                	jmp    4326e <rand+0x9>

000000000004329f <srand>:
    rand_seed = seed;
   4329f:	89 3d 5b 9d 01 00    	mov    %edi,0x19d5b(%rip)        # 5d000 <rand_seed>
    rand_seed_set = 1;
   432a5:	c7 05 55 9d 01 00 01 	movl   $0x1,0x19d55(%rip)        # 5d004 <rand_seed_set>
   432ac:	00 00 00 
}
   432af:	c3                   	retq   

00000000000432b0 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   432b0:	55                   	push   %rbp
   432b1:	48 89 e5             	mov    %rsp,%rbp
   432b4:	41 57                	push   %r15
   432b6:	41 56                	push   %r14
   432b8:	41 55                	push   %r13
   432ba:	41 54                	push   %r12
   432bc:	53                   	push   %rbx
   432bd:	48 83 ec 58          	sub    $0x58,%rsp
   432c1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
   432c5:	0f b6 02             	movzbl (%rdx),%eax
   432c8:	84 c0                	test   %al,%al
   432ca:	0f 84 b0 06 00 00    	je     43980 <printer_vprintf+0x6d0>
   432d0:	49 89 fe             	mov    %rdi,%r14
   432d3:	49 89 d4             	mov    %rdx,%r12
            length = 1;
   432d6:	41 89 f7             	mov    %esi,%r15d
   432d9:	e9 a4 04 00 00       	jmpq   43782 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
   432de:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
   432e3:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
   432e9:	45 84 e4             	test   %r12b,%r12b
   432ec:	0f 84 82 06 00 00    	je     43974 <printer_vprintf+0x6c4>
        int flags = 0;
   432f2:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
   432f8:	41 0f be f4          	movsbl %r12b,%esi
   432fc:	bf e1 52 04 00       	mov    $0x452e1,%edi
   43301:	e8 37 ff ff ff       	callq  4323d <strchr>
   43306:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
   43309:	48 85 c0             	test   %rax,%rax
   4330c:	74 55                	je     43363 <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
   4330e:	48 81 e9 e1 52 04 00 	sub    $0x452e1,%rcx
   43315:	b8 01 00 00 00       	mov    $0x1,%eax
   4331a:	d3 e0                	shl    %cl,%eax
   4331c:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
   4331f:	48 83 c3 01          	add    $0x1,%rbx
   43323:	44 0f b6 23          	movzbl (%rbx),%r12d
   43327:	45 84 e4             	test   %r12b,%r12b
   4332a:	75 cc                	jne    432f8 <printer_vprintf+0x48>
   4332c:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
   43330:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
   43336:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
   4333d:	80 3b 2e             	cmpb   $0x2e,(%rbx)
   43340:	0f 84 a9 00 00 00    	je     433ef <printer_vprintf+0x13f>
        int length = 0;
   43346:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
   4334b:	0f b6 13             	movzbl (%rbx),%edx
   4334e:	8d 42 bd             	lea    -0x43(%rdx),%eax
   43351:	3c 37                	cmp    $0x37,%al
   43353:	0f 87 c4 04 00 00    	ja     4381d <printer_vprintf+0x56d>
   43359:	0f b6 c0             	movzbl %al,%eax
   4335c:	ff 24 c5 f0 50 04 00 	jmpq   *0x450f0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
   43363:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
   43367:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
   4336c:	3c 08                	cmp    $0x8,%al
   4336e:	77 2f                	ja     4339f <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43370:	0f b6 03             	movzbl (%rbx),%eax
   43373:	8d 50 d0             	lea    -0x30(%rax),%edx
   43376:	80 fa 09             	cmp    $0x9,%dl
   43379:	77 5e                	ja     433d9 <printer_vprintf+0x129>
   4337b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
   43381:	48 83 c3 01          	add    $0x1,%rbx
   43385:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
   4338a:	0f be c0             	movsbl %al,%eax
   4338d:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43392:	0f b6 03             	movzbl (%rbx),%eax
   43395:	8d 50 d0             	lea    -0x30(%rax),%edx
   43398:	80 fa 09             	cmp    $0x9,%dl
   4339b:	76 e4                	jbe    43381 <printer_vprintf+0xd1>
   4339d:	eb 97                	jmp    43336 <printer_vprintf+0x86>
        } else if (*format == '*') {
   4339f:	41 80 fc 2a          	cmp    $0x2a,%r12b
   433a3:	75 3f                	jne    433e4 <printer_vprintf+0x134>
            width = va_arg(val, int);
   433a5:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   433a9:	8b 07                	mov    (%rdi),%eax
   433ab:	83 f8 2f             	cmp    $0x2f,%eax
   433ae:	77 17                	ja     433c7 <printer_vprintf+0x117>
   433b0:	89 c2                	mov    %eax,%edx
   433b2:	48 03 57 10          	add    0x10(%rdi),%rdx
   433b6:	83 c0 08             	add    $0x8,%eax
   433b9:	89 07                	mov    %eax,(%rdi)
   433bb:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
   433be:	48 83 c3 01          	add    $0x1,%rbx
   433c2:	e9 6f ff ff ff       	jmpq   43336 <printer_vprintf+0x86>
            width = va_arg(val, int);
   433c7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   433cb:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   433cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
   433d3:	48 89 41 08          	mov    %rax,0x8(%rcx)
   433d7:	eb e2                	jmp    433bb <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   433d9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
   433df:	e9 52 ff ff ff       	jmpq   43336 <printer_vprintf+0x86>
        int width = -1;
   433e4:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
   433ea:	e9 47 ff ff ff       	jmpq   43336 <printer_vprintf+0x86>
            ++format;
   433ef:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
   433f3:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   433f7:	8d 48 d0             	lea    -0x30(%rax),%ecx
   433fa:	80 f9 09             	cmp    $0x9,%cl
   433fd:	76 13                	jbe    43412 <printer_vprintf+0x162>
            } else if (*format == '*') {
   433ff:	3c 2a                	cmp    $0x2a,%al
   43401:	74 33                	je     43436 <printer_vprintf+0x186>
            ++format;
   43403:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
   43406:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
   4340d:	e9 34 ff ff ff       	jmpq   43346 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43412:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
   43417:	48 83 c2 01          	add    $0x1,%rdx
   4341b:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
   4341e:	0f be c0             	movsbl %al,%eax
   43421:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43425:	0f b6 02             	movzbl (%rdx),%eax
   43428:	8d 70 d0             	lea    -0x30(%rax),%esi
   4342b:	40 80 fe 09          	cmp    $0x9,%sil
   4342f:	76 e6                	jbe    43417 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
   43431:	48 89 d3             	mov    %rdx,%rbx
   43434:	eb 1c                	jmp    43452 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
   43436:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   4343a:	8b 07                	mov    (%rdi),%eax
   4343c:	83 f8 2f             	cmp    $0x2f,%eax
   4343f:	77 23                	ja     43464 <printer_vprintf+0x1b4>
   43441:	89 c2                	mov    %eax,%edx
   43443:	48 03 57 10          	add    0x10(%rdi),%rdx
   43447:	83 c0 08             	add    $0x8,%eax
   4344a:	89 07                	mov    %eax,(%rdi)
   4344c:	8b 0a                	mov    (%rdx),%ecx
                ++format;
   4344e:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
   43452:	85 c9                	test   %ecx,%ecx
   43454:	b8 00 00 00 00       	mov    $0x0,%eax
   43459:	0f 49 c1             	cmovns %ecx,%eax
   4345c:	89 45 9c             	mov    %eax,-0x64(%rbp)
   4345f:	e9 e2 fe ff ff       	jmpq   43346 <printer_vprintf+0x96>
                precision = va_arg(val, int);
   43464:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43468:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   4346c:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43470:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43474:	eb d6                	jmp    4344c <printer_vprintf+0x19c>
        switch (*format) {
   43476:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   4347b:	e9 f3 00 00 00       	jmpq   43573 <printer_vprintf+0x2c3>
            ++format;
   43480:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
   43484:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
   43489:	e9 bd fe ff ff       	jmpq   4334b <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   4348e:	85 c9                	test   %ecx,%ecx
   43490:	74 55                	je     434e7 <printer_vprintf+0x237>
   43492:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43496:	8b 07                	mov    (%rdi),%eax
   43498:	83 f8 2f             	cmp    $0x2f,%eax
   4349b:	77 38                	ja     434d5 <printer_vprintf+0x225>
   4349d:	89 c2                	mov    %eax,%edx
   4349f:	48 03 57 10          	add    0x10(%rdi),%rdx
   434a3:	83 c0 08             	add    $0x8,%eax
   434a6:	89 07                	mov    %eax,(%rdi)
   434a8:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   434ab:	48 89 d0             	mov    %rdx,%rax
   434ae:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
   434b2:	49 89 d0             	mov    %rdx,%r8
   434b5:	49 f7 d8             	neg    %r8
   434b8:	25 80 00 00 00       	and    $0x80,%eax
   434bd:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   434c1:	0b 45 a8             	or     -0x58(%rbp),%eax
   434c4:	83 c8 60             	or     $0x60,%eax
   434c7:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
   434ca:	41 bc e7 50 04 00    	mov    $0x450e7,%r12d
            break;
   434d0:	e9 35 01 00 00       	jmpq   4360a <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   434d5:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   434d9:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   434dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
   434e1:	48 89 41 08          	mov    %rax,0x8(%rcx)
   434e5:	eb c1                	jmp    434a8 <printer_vprintf+0x1f8>
   434e7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   434eb:	8b 07                	mov    (%rdi),%eax
   434ed:	83 f8 2f             	cmp    $0x2f,%eax
   434f0:	77 10                	ja     43502 <printer_vprintf+0x252>
   434f2:	89 c2                	mov    %eax,%edx
   434f4:	48 03 57 10          	add    0x10(%rdi),%rdx
   434f8:	83 c0 08             	add    $0x8,%eax
   434fb:	89 07                	mov    %eax,(%rdi)
   434fd:	48 63 12             	movslq (%rdx),%rdx
   43500:	eb a9                	jmp    434ab <printer_vprintf+0x1fb>
   43502:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43506:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   4350a:	48 8d 42 08          	lea    0x8(%rdx),%rax
   4350e:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43512:	eb e9                	jmp    434fd <printer_vprintf+0x24d>
        int base = 10;
   43514:	be 0a 00 00 00       	mov    $0xa,%esi
   43519:	eb 58                	jmp    43573 <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   4351b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4351f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43523:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43527:	48 89 41 08          	mov    %rax,0x8(%rcx)
   4352b:	eb 60                	jmp    4358d <printer_vprintf+0x2dd>
   4352d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43531:	8b 07                	mov    (%rdi),%eax
   43533:	83 f8 2f             	cmp    $0x2f,%eax
   43536:	77 10                	ja     43548 <printer_vprintf+0x298>
   43538:	89 c2                	mov    %eax,%edx
   4353a:	48 03 57 10          	add    0x10(%rdi),%rdx
   4353e:	83 c0 08             	add    $0x8,%eax
   43541:	89 07                	mov    %eax,(%rdi)
   43543:	44 8b 02             	mov    (%rdx),%r8d
   43546:	eb 48                	jmp    43590 <printer_vprintf+0x2e0>
   43548:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4354c:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43550:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43554:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43558:	eb e9                	jmp    43543 <printer_vprintf+0x293>
   4355a:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
   4355d:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
   43564:	bf d0 52 04 00       	mov    $0x452d0,%edi
   43569:	e9 e2 02 00 00       	jmpq   43850 <printer_vprintf+0x5a0>
            base = 16;
   4356e:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43573:	85 c9                	test   %ecx,%ecx
   43575:	74 b6                	je     4352d <printer_vprintf+0x27d>
   43577:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4357b:	8b 01                	mov    (%rcx),%eax
   4357d:	83 f8 2f             	cmp    $0x2f,%eax
   43580:	77 99                	ja     4351b <printer_vprintf+0x26b>
   43582:	89 c2                	mov    %eax,%edx
   43584:	48 03 51 10          	add    0x10(%rcx),%rdx
   43588:	83 c0 08             	add    $0x8,%eax
   4358b:	89 01                	mov    %eax,(%rcx)
   4358d:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
   43590:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
   43594:	85 f6                	test   %esi,%esi
   43596:	79 c2                	jns    4355a <printer_vprintf+0x2aa>
        base = -base;
   43598:	41 89 f1             	mov    %esi,%r9d
   4359b:	f7 de                	neg    %esi
   4359d:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
   435a4:	bf b0 52 04 00       	mov    $0x452b0,%edi
   435a9:	e9 a2 02 00 00       	jmpq   43850 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
   435ae:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   435b2:	8b 07                	mov    (%rdi),%eax
   435b4:	83 f8 2f             	cmp    $0x2f,%eax
   435b7:	77 1c                	ja     435d5 <printer_vprintf+0x325>
   435b9:	89 c2                	mov    %eax,%edx
   435bb:	48 03 57 10          	add    0x10(%rdi),%rdx
   435bf:	83 c0 08             	add    $0x8,%eax
   435c2:	89 07                	mov    %eax,(%rdi)
   435c4:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   435c7:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
   435ce:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   435d3:	eb c3                	jmp    43598 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
   435d5:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   435d9:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   435dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
   435e1:	48 89 41 08          	mov    %rax,0x8(%rcx)
   435e5:	eb dd                	jmp    435c4 <printer_vprintf+0x314>
            data = va_arg(val, char*);
   435e7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   435eb:	8b 01                	mov    (%rcx),%eax
   435ed:	83 f8 2f             	cmp    $0x2f,%eax
   435f0:	0f 87 a5 01 00 00    	ja     4379b <printer_vprintf+0x4eb>
   435f6:	89 c2                	mov    %eax,%edx
   435f8:	48 03 51 10          	add    0x10(%rcx),%rdx
   435fc:	83 c0 08             	add    $0x8,%eax
   435ff:	89 01                	mov    %eax,(%rcx)
   43601:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
   43604:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
   4360a:	8b 45 a8             	mov    -0x58(%rbp),%eax
   4360d:	83 e0 20             	and    $0x20,%eax
   43610:	89 45 8c             	mov    %eax,-0x74(%rbp)
   43613:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
   43619:	0f 85 21 02 00 00    	jne    43840 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   4361f:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43622:	89 45 88             	mov    %eax,-0x78(%rbp)
   43625:	83 e0 60             	and    $0x60,%eax
   43628:	83 f8 60             	cmp    $0x60,%eax
   4362b:	0f 84 54 02 00 00    	je     43885 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43631:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43634:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
   43637:	48 c7 45 a0 e7 50 04 	movq   $0x450e7,-0x60(%rbp)
   4363e:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   4363f:	83 f8 21             	cmp    $0x21,%eax
   43642:	0f 84 79 02 00 00    	je     438c1 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   43648:	8b 7d 9c             	mov    -0x64(%rbp),%edi
   4364b:	89 f8                	mov    %edi,%eax
   4364d:	f7 d0                	not    %eax
   4364f:	c1 e8 1f             	shr    $0x1f,%eax
   43652:	89 45 84             	mov    %eax,-0x7c(%rbp)
   43655:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   43659:	0f 85 9e 02 00 00    	jne    438fd <printer_vprintf+0x64d>
   4365f:	84 c0                	test   %al,%al
   43661:	0f 84 96 02 00 00    	je     438fd <printer_vprintf+0x64d>
            len = strnlen(data, precision);
   43667:	48 63 f7             	movslq %edi,%rsi
   4366a:	4c 89 e7             	mov    %r12,%rdi
   4366d:	e8 63 fb ff ff       	callq  431d5 <strnlen>
   43672:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
   43675:	8b 45 88             	mov    -0x78(%rbp),%eax
   43678:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
   4367b:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   43682:	83 f8 22             	cmp    $0x22,%eax
   43685:	0f 84 aa 02 00 00    	je     43935 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
   4368b:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   4368f:	e8 26 fb ff ff       	callq  431ba <strlen>
   43694:	8b 55 9c             	mov    -0x64(%rbp),%edx
   43697:	03 55 98             	add    -0x68(%rbp),%edx
   4369a:	44 89 e9             	mov    %r13d,%ecx
   4369d:	29 d1                	sub    %edx,%ecx
   4369f:	29 c1                	sub    %eax,%ecx
   436a1:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
   436a4:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   436a7:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
   436ab:	75 2d                	jne    436da <printer_vprintf+0x42a>
   436ad:	85 c9                	test   %ecx,%ecx
   436af:	7e 29                	jle    436da <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
   436b1:	44 89 fa             	mov    %r15d,%edx
   436b4:	be 20 00 00 00       	mov    $0x20,%esi
   436b9:	4c 89 f7             	mov    %r14,%rdi
   436bc:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   436bf:	41 83 ed 01          	sub    $0x1,%r13d
   436c3:	45 85 ed             	test   %r13d,%r13d
   436c6:	7f e9                	jg     436b1 <printer_vprintf+0x401>
   436c8:	8b 7d 8c             	mov    -0x74(%rbp),%edi
   436cb:	85 ff                	test   %edi,%edi
   436cd:	b8 01 00 00 00       	mov    $0x1,%eax
   436d2:	0f 4f c7             	cmovg  %edi,%eax
   436d5:	29 c7                	sub    %eax,%edi
   436d7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
   436da:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   436de:	0f b6 07             	movzbl (%rdi),%eax
   436e1:	84 c0                	test   %al,%al
   436e3:	74 22                	je     43707 <printer_vprintf+0x457>
   436e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   436e9:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
   436ec:	0f b6 f0             	movzbl %al,%esi
   436ef:	44 89 fa             	mov    %r15d,%edx
   436f2:	4c 89 f7             	mov    %r14,%rdi
   436f5:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
   436f8:	48 83 c3 01          	add    $0x1,%rbx
   436fc:	0f b6 03             	movzbl (%rbx),%eax
   436ff:	84 c0                	test   %al,%al
   43701:	75 e9                	jne    436ec <printer_vprintf+0x43c>
   43703:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
   43707:	8b 45 9c             	mov    -0x64(%rbp),%eax
   4370a:	85 c0                	test   %eax,%eax
   4370c:	7e 1d                	jle    4372b <printer_vprintf+0x47b>
   4370e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43712:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
   43714:	44 89 fa             	mov    %r15d,%edx
   43717:	be 30 00 00 00       	mov    $0x30,%esi
   4371c:	4c 89 f7             	mov    %r14,%rdi
   4371f:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
   43722:	83 eb 01             	sub    $0x1,%ebx
   43725:	75 ed                	jne    43714 <printer_vprintf+0x464>
   43727:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
   4372b:	8b 45 98             	mov    -0x68(%rbp),%eax
   4372e:	85 c0                	test   %eax,%eax
   43730:	7e 27                	jle    43759 <printer_vprintf+0x4a9>
   43732:	89 c0                	mov    %eax,%eax
   43734:	4c 01 e0             	add    %r12,%rax
   43737:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   4373b:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
   4373e:	41 0f b6 34 24       	movzbl (%r12),%esi
   43743:	44 89 fa             	mov    %r15d,%edx
   43746:	4c 89 f7             	mov    %r14,%rdi
   43749:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
   4374c:	49 83 c4 01          	add    $0x1,%r12
   43750:	49 39 dc             	cmp    %rbx,%r12
   43753:	75 e9                	jne    4373e <printer_vprintf+0x48e>
   43755:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
   43759:	45 85 ed             	test   %r13d,%r13d
   4375c:	7e 14                	jle    43772 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
   4375e:	44 89 fa             	mov    %r15d,%edx
   43761:	be 20 00 00 00       	mov    $0x20,%esi
   43766:	4c 89 f7             	mov    %r14,%rdi
   43769:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
   4376c:	41 83 ed 01          	sub    $0x1,%r13d
   43770:	75 ec                	jne    4375e <printer_vprintf+0x4ae>
    for (; *format; ++format) {
   43772:	4c 8d 63 01          	lea    0x1(%rbx),%r12
   43776:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   4377a:	84 c0                	test   %al,%al
   4377c:	0f 84 fe 01 00 00    	je     43980 <printer_vprintf+0x6d0>
        if (*format != '%') {
   43782:	3c 25                	cmp    $0x25,%al
   43784:	0f 84 54 fb ff ff    	je     432de <printer_vprintf+0x2e>
            p->putc(p, *format, color);
   4378a:	0f b6 f0             	movzbl %al,%esi
   4378d:	44 89 fa             	mov    %r15d,%edx
   43790:	4c 89 f7             	mov    %r14,%rdi
   43793:	41 ff 16             	callq  *(%r14)
            continue;
   43796:	4c 89 e3             	mov    %r12,%rbx
   43799:	eb d7                	jmp    43772 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
   4379b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   4379f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   437a3:	48 8d 42 08          	lea    0x8(%rdx),%rax
   437a7:	48 89 47 08          	mov    %rax,0x8(%rdi)
   437ab:	e9 51 fe ff ff       	jmpq   43601 <printer_vprintf+0x351>
            color = va_arg(val, int);
   437b0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   437b4:	8b 07                	mov    (%rdi),%eax
   437b6:	83 f8 2f             	cmp    $0x2f,%eax
   437b9:	77 10                	ja     437cb <printer_vprintf+0x51b>
   437bb:	89 c2                	mov    %eax,%edx
   437bd:	48 03 57 10          	add    0x10(%rdi),%rdx
   437c1:	83 c0 08             	add    $0x8,%eax
   437c4:	89 07                	mov    %eax,(%rdi)
   437c6:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
   437c9:	eb a7                	jmp    43772 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
   437cb:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   437cf:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   437d3:	48 8d 42 08          	lea    0x8(%rdx),%rax
   437d7:	48 89 41 08          	mov    %rax,0x8(%rcx)
   437db:	eb e9                	jmp    437c6 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
   437dd:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   437e1:	8b 01                	mov    (%rcx),%eax
   437e3:	83 f8 2f             	cmp    $0x2f,%eax
   437e6:	77 23                	ja     4380b <printer_vprintf+0x55b>
   437e8:	89 c2                	mov    %eax,%edx
   437ea:	48 03 51 10          	add    0x10(%rcx),%rdx
   437ee:	83 c0 08             	add    $0x8,%eax
   437f1:	89 01                	mov    %eax,(%rcx)
   437f3:	8b 02                	mov    (%rdx),%eax
   437f5:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
   437f8:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   437fc:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43800:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
   43806:	e9 ff fd ff ff       	jmpq   4360a <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
   4380b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   4380f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43813:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43817:	48 89 47 08          	mov    %rax,0x8(%rdi)
   4381b:	eb d6                	jmp    437f3 <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
   4381d:	84 d2                	test   %dl,%dl
   4381f:	0f 85 39 01 00 00    	jne    4395e <printer_vprintf+0x6ae>
   43825:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
   43829:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
   4382d:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
   43831:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43835:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   4383b:	e9 ca fd ff ff       	jmpq   4360a <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
   43840:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
   43846:	bf d0 52 04 00       	mov    $0x452d0,%edi
        if (flags & FLAG_NUMERIC) {
   4384b:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
   43850:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
   43854:	4c 89 c1             	mov    %r8,%rcx
   43857:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
   4385b:	48 63 f6             	movslq %esi,%rsi
   4385e:	49 83 ec 01          	sub    $0x1,%r12
   43862:	48 89 c8             	mov    %rcx,%rax
   43865:	ba 00 00 00 00       	mov    $0x0,%edx
   4386a:	48 f7 f6             	div    %rsi
   4386d:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
   43871:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
   43875:	48 89 ca             	mov    %rcx,%rdx
   43878:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
   4387b:	48 39 d6             	cmp    %rdx,%rsi
   4387e:	76 de                	jbe    4385e <printer_vprintf+0x5ae>
   43880:	e9 9a fd ff ff       	jmpq   4361f <printer_vprintf+0x36f>
                prefix = "-";
   43885:	48 c7 45 a0 e4 50 04 	movq   $0x450e4,-0x60(%rbp)
   4388c:	00 
            if (flags & FLAG_NEGATIVE) {
   4388d:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43890:	a8 80                	test   $0x80,%al
   43892:	0f 85 b0 fd ff ff    	jne    43648 <printer_vprintf+0x398>
                prefix = "+";
   43898:	48 c7 45 a0 df 50 04 	movq   $0x450df,-0x60(%rbp)
   4389f:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
   438a0:	a8 10                	test   $0x10,%al
   438a2:	0f 85 a0 fd ff ff    	jne    43648 <printer_vprintf+0x398>
                prefix = " ";
   438a8:	a8 08                	test   $0x8,%al
   438aa:	ba e7 50 04 00       	mov    $0x450e7,%edx
   438af:	b8 e6 50 04 00       	mov    $0x450e6,%eax
   438b4:	48 0f 44 c2          	cmove  %rdx,%rax
   438b8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   438bc:	e9 87 fd ff ff       	jmpq   43648 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
   438c1:	41 8d 41 10          	lea    0x10(%r9),%eax
   438c5:	a9 df ff ff ff       	test   $0xffffffdf,%eax
   438ca:	0f 85 78 fd ff ff    	jne    43648 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
   438d0:	4d 85 c0             	test   %r8,%r8
   438d3:	75 0d                	jne    438e2 <printer_vprintf+0x632>
   438d5:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
   438dc:	0f 84 66 fd ff ff    	je     43648 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
   438e2:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
   438e6:	ba e8 50 04 00       	mov    $0x450e8,%edx
   438eb:	b8 e1 50 04 00       	mov    $0x450e1,%eax
   438f0:	48 0f 44 c2          	cmove  %rdx,%rax
   438f4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   438f8:	e9 4b fd ff ff       	jmpq   43648 <printer_vprintf+0x398>
            len = strlen(data);
   438fd:	4c 89 e7             	mov    %r12,%rdi
   43900:	e8 b5 f8 ff ff       	callq  431ba <strlen>
   43905:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   43908:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   4390c:	0f 84 63 fd ff ff    	je     43675 <printer_vprintf+0x3c5>
   43912:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
   43916:	0f 84 59 fd ff ff    	je     43675 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
   4391c:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
   4391f:	89 ca                	mov    %ecx,%edx
   43921:	29 c2                	sub    %eax,%edx
   43923:	39 c1                	cmp    %eax,%ecx
   43925:	b8 00 00 00 00       	mov    $0x0,%eax
   4392a:	0f 4e d0             	cmovle %eax,%edx
   4392d:	89 55 9c             	mov    %edx,-0x64(%rbp)
   43930:	e9 56 fd ff ff       	jmpq   4368b <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
   43935:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43939:	e8 7c f8 ff ff       	callq  431ba <strlen>
   4393e:	8b 7d 98             	mov    -0x68(%rbp),%edi
   43941:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
   43944:	44 89 e9             	mov    %r13d,%ecx
   43947:	29 f9                	sub    %edi,%ecx
   43949:	29 c1                	sub    %eax,%ecx
   4394b:	44 39 ea             	cmp    %r13d,%edx
   4394e:	b8 00 00 00 00       	mov    $0x0,%eax
   43953:	0f 4d c8             	cmovge %eax,%ecx
   43956:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
   43959:	e9 2d fd ff ff       	jmpq   4368b <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
   4395e:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
   43961:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43965:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43969:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   4396f:	e9 96 fc ff ff       	jmpq   4360a <printer_vprintf+0x35a>
        int flags = 0;
   43974:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
   4397b:	e9 b0 f9 ff ff       	jmpq   43330 <printer_vprintf+0x80>
}
   43980:	48 83 c4 58          	add    $0x58,%rsp
   43984:	5b                   	pop    %rbx
   43985:	41 5c                	pop    %r12
   43987:	41 5d                	pop    %r13
   43989:	41 5e                	pop    %r14
   4398b:	41 5f                	pop    %r15
   4398d:	5d                   	pop    %rbp
   4398e:	c3                   	retq   

000000000004398f <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
   4398f:	55                   	push   %rbp
   43990:	48 89 e5             	mov    %rsp,%rbp
   43993:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
   43997:	48 c7 45 f0 9a 30 04 	movq   $0x4309a,-0x10(%rbp)
   4399e:	00 
        cpos = 0;
   4399f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
   439a5:	b8 00 00 00 00       	mov    $0x0,%eax
   439aa:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
   439ad:	48 63 ff             	movslq %edi,%rdi
   439b0:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
   439b7:	00 
   439b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   439bc:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
   439c0:	e8 eb f8 ff ff       	callq  432b0 <printer_vprintf>
    return cp.cursor - console;
   439c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   439c9:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   439cf:	48 d1 f8             	sar    %rax
}
   439d2:	c9                   	leaveq 
   439d3:	c3                   	retq   

00000000000439d4 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
   439d4:	55                   	push   %rbp
   439d5:	48 89 e5             	mov    %rsp,%rbp
   439d8:	48 83 ec 50          	sub    $0x50,%rsp
   439dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   439e0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   439e4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
   439e8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   439ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
   439f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   439f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   439fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   439ff:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43a03:	e8 87 ff ff ff       	callq  4398f <console_vprintf>
}
   43a08:	c9                   	leaveq 
   43a09:	c3                   	retq   

0000000000043a0a <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   43a0a:	55                   	push   %rbp
   43a0b:	48 89 e5             	mov    %rsp,%rbp
   43a0e:	53                   	push   %rbx
   43a0f:	48 83 ec 28          	sub    $0x28,%rsp
   43a13:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
   43a16:	48 c7 45 d8 20 31 04 	movq   $0x43120,-0x28(%rbp)
   43a1d:	00 
    sp.s = s;
   43a1e:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
   43a22:	48 85 f6             	test   %rsi,%rsi
   43a25:	75 0b                	jne    43a32 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
   43a27:	8b 45 e0             	mov    -0x20(%rbp),%eax
   43a2a:	29 d8                	sub    %ebx,%eax
}
   43a2c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   43a30:	c9                   	leaveq 
   43a31:	c3                   	retq   
        sp.end = s + size - 1;
   43a32:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
   43a37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   43a3b:	be 00 00 00 00       	mov    $0x0,%esi
   43a40:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
   43a44:	e8 67 f8 ff ff       	callq  432b0 <printer_vprintf>
        *sp.s = 0;
   43a49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43a4d:	c6 00 00             	movb   $0x0,(%rax)
   43a50:	eb d5                	jmp    43a27 <vsnprintf+0x1d>

0000000000043a52 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   43a52:	55                   	push   %rbp
   43a53:	48 89 e5             	mov    %rsp,%rbp
   43a56:	48 83 ec 50          	sub    $0x50,%rsp
   43a5a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   43a5e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   43a62:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   43a66:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   43a6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
   43a71:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43a75:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43a79:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
   43a7d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43a81:	e8 84 ff ff ff       	callq  43a0a <vsnprintf>
    va_end(val);
    return n;
}
   43a86:	c9                   	leaveq 
   43a87:	c3                   	retq   

0000000000043a88 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43a88:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   43a8d:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
   43a92:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43a97:	48 83 c0 02          	add    $0x2,%rax
   43a9b:	48 39 d0             	cmp    %rdx,%rax
   43a9e:	75 f2                	jne    43a92 <console_clear+0xa>
    }
    cursorpos = 0;
   43aa0:	c7 05 52 55 07 00 00 	movl   $0x0,0x75552(%rip)        # b8ffc <cursorpos>
   43aa7:	00 00 00 
}
   43aaa:	c3                   	retq   

0000000000043aab <palloc>:
   43aab:	55                   	push   %rbp
   43aac:	48 89 e5             	mov    %rsp,%rbp
   43aaf:	48 83 ec 20          	sub    $0x20,%rsp
   43ab3:	89 7d ec             	mov    %edi,-0x14(%rbp)
   43ab6:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
   43abd:	00 
   43abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43ac2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43ac6:	e9 95 00 00 00       	jmpq   43b60 <palloc+0xb5>
   43acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43acf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43ad3:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43ada:	00 
   43adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43adf:	48 c1 e8 0c          	shr    $0xc,%rax
   43ae3:	48 98                	cltq   
   43ae5:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   43aec:	00 
   43aed:	84 c0                	test   %al,%al
   43aef:	75 6f                	jne    43b60 <palloc+0xb5>
   43af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43af5:	48 c1 e8 0c          	shr    $0xc,%rax
   43af9:	48 98                	cltq   
   43afb:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43b02:	00 
   43b03:	84 c0                	test   %al,%al
   43b05:	75 59                	jne    43b60 <palloc+0xb5>
   43b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43b0b:	48 c1 e8 0c          	shr    $0xc,%rax
   43b0f:	89 c2                	mov    %eax,%edx
   43b11:	48 63 c2             	movslq %edx,%rax
   43b14:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43b1b:	00 
   43b1c:	83 c0 01             	add    $0x1,%eax
   43b1f:	89 c1                	mov    %eax,%ecx
   43b21:	48 63 c2             	movslq %edx,%rax
   43b24:	88 8c 00 21 4f 05 00 	mov    %cl,0x54f21(%rax,%rax,1)
   43b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43b2f:	48 c1 e8 0c          	shr    $0xc,%rax
   43b33:	89 c1                	mov    %eax,%ecx
   43b35:	8b 45 ec             	mov    -0x14(%rbp),%eax
   43b38:	89 c2                	mov    %eax,%edx
   43b3a:	48 63 c1             	movslq %ecx,%rax
   43b3d:	88 94 00 20 4f 05 00 	mov    %dl,0x54f20(%rax,%rax,1)
   43b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43b48:	ba 00 10 00 00       	mov    $0x1000,%edx
   43b4d:	be cc 00 00 00       	mov    $0xcc,%esi
   43b52:	48 89 c7             	mov    %rax,%rdi
   43b55:	e8 45 f6 ff ff       	callq  4319f <memset>
   43b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43b5e:	eb 2c                	jmp    43b8c <palloc+0xe1>
   43b60:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   43b67:	00 
   43b68:	0f 86 5d ff ff ff    	jbe    43acb <palloc+0x20>
   43b6e:	ba e8 52 04 00       	mov    $0x452e8,%edx
   43b73:	be 00 0c 00 00       	mov    $0xc00,%esi
   43b78:	bf 80 07 00 00       	mov    $0x780,%edi
   43b7d:	b8 00 00 00 00       	mov    $0x0,%eax
   43b82:	e8 4d fe ff ff       	callq  439d4 <console_printf>
   43b87:	b8 00 00 00 00       	mov    $0x0,%eax
   43b8c:	c9                   	leaveq 
   43b8d:	c3                   	retq   

0000000000043b8e <palloc_target>:
   43b8e:	55                   	push   %rbp
   43b8f:	48 89 e5             	mov    %rsp,%rbp
   43b92:	48 8b 05 6f 94 01 00 	mov    0x1946f(%rip),%rax        # 5d008 <palloc_target_proc>
   43b99:	48 85 c0             	test   %rax,%rax
   43b9c:	75 14                	jne    43bb2 <palloc_target+0x24>
   43b9e:	ba 01 53 04 00       	mov    $0x45301,%edx
   43ba3:	be 27 00 00 00       	mov    $0x27,%esi
   43ba8:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43bad:	e8 d9 e9 ff ff       	callq  4258b <assert_fail>
   43bb2:	48 8b 05 4f 94 01 00 	mov    0x1944f(%rip),%rax        # 5d008 <palloc_target_proc>
   43bb9:	8b 00                	mov    (%rax),%eax
   43bbb:	89 c7                	mov    %eax,%edi
   43bbd:	e8 e9 fe ff ff       	callq  43aab <palloc>
   43bc2:	5d                   	pop    %rbp
   43bc3:	c3                   	retq   

0000000000043bc4 <process_free>:
   43bc4:	55                   	push   %rbp
   43bc5:	48 89 e5             	mov    %rsp,%rbp
   43bc8:	48 83 ec 60          	sub    $0x60,%rsp
   43bcc:	89 7d ac             	mov    %edi,-0x54(%rbp)
   43bcf:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43bd2:	48 63 d0             	movslq %eax,%rdx
   43bd5:	48 89 d0             	mov    %rdx,%rax
   43bd8:	48 c1 e0 04          	shl    $0x4,%rax
   43bdc:	48 29 d0             	sub    %rdx,%rax
   43bdf:	48 c1 e0 04          	shl    $0x4,%rax
   43be3:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   43be9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
   43bef:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   43bf6:	00 
   43bf7:	e9 ad 00 00 00       	jmpq   43ca9 <process_free+0xe5>
   43bfc:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43bff:	48 63 d0             	movslq %eax,%rdx
   43c02:	48 89 d0             	mov    %rdx,%rax
   43c05:	48 c1 e0 04          	shl    $0x4,%rax
   43c09:	48 29 d0             	sub    %rdx,%rax
   43c0c:	48 c1 e0 04          	shl    $0x4,%rax
   43c10:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   43c16:	48 8b 08             	mov    (%rax),%rcx
   43c19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   43c1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43c21:	48 89 ce             	mov    %rcx,%rsi
   43c24:	48 89 c7             	mov    %rax,%rdi
   43c27:	e8 21 f0 ff ff       	callq  42c4d <virtual_memory_lookup>
   43c2c:	8b 45 c8             	mov    -0x38(%rbp),%eax
   43c2f:	48 98                	cltq   
   43c31:	83 e0 01             	and    $0x1,%eax
   43c34:	48 85 c0             	test   %rax,%rax
   43c37:	74 68                	je     43ca1 <process_free+0xdd>
   43c39:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43c3c:	48 63 d0             	movslq %eax,%rdx
   43c3f:	0f b6 94 12 21 4f 05 	movzbl 0x54f21(%rdx,%rdx,1),%edx
   43c46:	00 
   43c47:	83 ea 01             	sub    $0x1,%edx
   43c4a:	48 98                	cltq   
   43c4c:	88 94 00 21 4f 05 00 	mov    %dl,0x54f21(%rax,%rax,1)
   43c53:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43c56:	48 98                	cltq   
   43c58:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43c5f:	00 
   43c60:	84 c0                	test   %al,%al
   43c62:	75 0f                	jne    43c73 <process_free+0xaf>
   43c64:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43c67:	48 98                	cltq   
   43c69:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43c70:	00 
   43c71:	eb 2e                	jmp    43ca1 <process_free+0xdd>
   43c73:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43c76:	48 98                	cltq   
   43c78:	0f b6 84 00 20 4f 05 	movzbl 0x54f20(%rax,%rax,1),%eax
   43c7f:	00 
   43c80:	0f be c0             	movsbl %al,%eax
   43c83:	39 45 ac             	cmp    %eax,-0x54(%rbp)
   43c86:	75 19                	jne    43ca1 <process_free+0xdd>
   43c88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   43c8c:	8b 55 ac             	mov    -0x54(%rbp),%edx
   43c8f:	48 89 c6             	mov    %rax,%rsi
   43c92:	bf 28 53 04 00       	mov    $0x45328,%edi
   43c97:	b8 00 00 00 00       	mov    $0x0,%eax
   43c9c:	e8 cc e5 ff ff       	callq  4226d <log_printf>
   43ca1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43ca8:	00 
   43ca9:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   43cb0:	00 
   43cb1:	0f 86 45 ff ff ff    	jbe    43bfc <process_free+0x38>
   43cb7:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43cba:	48 63 d0             	movslq %eax,%rdx
   43cbd:	48 89 d0             	mov    %rdx,%rax
   43cc0:	48 c1 e0 04          	shl    $0x4,%rax
   43cc4:	48 29 d0             	sub    %rdx,%rax
   43cc7:	48 c1 e0 04          	shl    $0x4,%rax
   43ccb:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   43cd1:	48 8b 00             	mov    (%rax),%rax
   43cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43cdc:	48 8b 00             	mov    (%rax),%rax
   43cdf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43ce5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   43ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43ced:	48 8b 00             	mov    (%rax),%rax
   43cf0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43cf6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   43cfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43cfe:	48 8b 00             	mov    (%rax),%rax
   43d01:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43d07:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
   43d0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43d0f:	48 8b 40 08          	mov    0x8(%rax),%rax
   43d13:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43d19:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
   43d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43d21:	48 c1 e8 0c          	shr    $0xc,%rax
   43d25:	48 98                	cltq   
   43d27:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43d2e:	00 
   43d2f:	3c 01                	cmp    $0x1,%al
   43d31:	74 14                	je     43d47 <process_free+0x183>
   43d33:	ba 60 53 04 00       	mov    $0x45360,%edx
   43d38:	be 4f 00 00 00       	mov    $0x4f,%esi
   43d3d:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43d42:	e8 44 e8 ff ff       	callq  4258b <assert_fail>
   43d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43d4b:	48 c1 e8 0c          	shr    $0xc,%rax
   43d4f:	48 98                	cltq   
   43d51:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43d58:	00 
   43d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43d5d:	48 c1 e8 0c          	shr    $0xc,%rax
   43d61:	48 98                	cltq   
   43d63:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43d6a:	00 
   43d6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43d6f:	48 c1 e8 0c          	shr    $0xc,%rax
   43d73:	48 98                	cltq   
   43d75:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43d7c:	00 
   43d7d:	3c 01                	cmp    $0x1,%al
   43d7f:	74 14                	je     43d95 <process_free+0x1d1>
   43d81:	ba 88 53 04 00       	mov    $0x45388,%edx
   43d86:	be 52 00 00 00       	mov    $0x52,%esi
   43d8b:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43d90:	e8 f6 e7 ff ff       	callq  4258b <assert_fail>
   43d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43d99:	48 c1 e8 0c          	shr    $0xc,%rax
   43d9d:	48 98                	cltq   
   43d9f:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43da6:	00 
   43da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43dab:	48 c1 e8 0c          	shr    $0xc,%rax
   43daf:	48 98                	cltq   
   43db1:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43db8:	00 
   43db9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43dbd:	48 c1 e8 0c          	shr    $0xc,%rax
   43dc1:	48 98                	cltq   
   43dc3:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43dca:	00 
   43dcb:	3c 01                	cmp    $0x1,%al
   43dcd:	74 14                	je     43de3 <process_free+0x21f>
   43dcf:	ba b0 53 04 00       	mov    $0x453b0,%edx
   43dd4:	be 55 00 00 00       	mov    $0x55,%esi
   43dd9:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43dde:	e8 a8 e7 ff ff       	callq  4258b <assert_fail>
   43de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43de7:	48 c1 e8 0c          	shr    $0xc,%rax
   43deb:	48 98                	cltq   
   43ded:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43df4:	00 
   43df5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43df9:	48 c1 e8 0c          	shr    $0xc,%rax
   43dfd:	48 98                	cltq   
   43dff:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43e06:	00 
   43e07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43e0b:	48 c1 e8 0c          	shr    $0xc,%rax
   43e0f:	48 98                	cltq   
   43e11:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43e18:	00 
   43e19:	3c 01                	cmp    $0x1,%al
   43e1b:	74 14                	je     43e31 <process_free+0x26d>
   43e1d:	ba d8 53 04 00       	mov    $0x453d8,%edx
   43e22:	be 58 00 00 00       	mov    $0x58,%esi
   43e27:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43e2c:	e8 5a e7 ff ff       	callq  4258b <assert_fail>
   43e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43e35:	48 c1 e8 0c          	shr    $0xc,%rax
   43e39:	48 98                	cltq   
   43e3b:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43e42:	00 
   43e43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43e47:	48 c1 e8 0c          	shr    $0xc,%rax
   43e4b:	48 98                	cltq   
   43e4d:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43e54:	00 
   43e55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43e59:	48 c1 e8 0c          	shr    $0xc,%rax
   43e5d:	48 98                	cltq   
   43e5f:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   43e66:	00 
   43e67:	3c 01                	cmp    $0x1,%al
   43e69:	74 14                	je     43e7f <process_free+0x2bb>
   43e6b:	ba 00 54 04 00       	mov    $0x45400,%edx
   43e70:	be 5b 00 00 00       	mov    $0x5b,%esi
   43e75:	bf 1c 53 04 00       	mov    $0x4531c,%edi
   43e7a:	e8 0c e7 ff ff       	callq  4258b <assert_fail>
   43e7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43e83:	48 c1 e8 0c          	shr    $0xc,%rax
   43e87:	48 98                	cltq   
   43e89:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43e90:	00 
   43e91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43e95:	48 c1 e8 0c          	shr    $0xc,%rax
   43e99:	48 98                	cltq   
   43e9b:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43ea2:	00 
   43ea3:	90                   	nop
   43ea4:	c9                   	leaveq 
   43ea5:	c3                   	retq   

0000000000043ea6 <process_config_tables>:
   43ea6:	55                   	push   %rbp
   43ea7:	48 89 e5             	mov    %rsp,%rbp
   43eaa:	48 83 ec 40          	sub    $0x40,%rsp
   43eae:	89 7d cc             	mov    %edi,-0x34(%rbp)
   43eb1:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43eb4:	89 c7                	mov    %eax,%edi
   43eb6:	e8 f0 fb ff ff       	callq  43aab <palloc>
   43ebb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43ebf:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43ec2:	89 c7                	mov    %eax,%edi
   43ec4:	e8 e2 fb ff ff       	callq  43aab <palloc>
   43ec9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43ecd:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43ed0:	89 c7                	mov    %eax,%edi
   43ed2:	e8 d4 fb ff ff       	callq  43aab <palloc>
   43ed7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   43edb:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43ede:	89 c7                	mov    %eax,%edi
   43ee0:	e8 c6 fb ff ff       	callq  43aab <palloc>
   43ee5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   43ee9:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43eec:	89 c7                	mov    %eax,%edi
   43eee:	e8 b8 fb ff ff       	callq  43aab <palloc>
   43ef3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
   43ef7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   43efc:	74 20                	je     43f1e <process_config_tables+0x78>
   43efe:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   43f03:	74 19                	je     43f1e <process_config_tables+0x78>
   43f05:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   43f0a:	74 12                	je     43f1e <process_config_tables+0x78>
   43f0c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   43f11:	74 0b                	je     43f1e <process_config_tables+0x78>
   43f13:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   43f18:	0f 85 e1 00 00 00    	jne    43fff <process_config_tables+0x159>
   43f1e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   43f23:	74 24                	je     43f49 <process_config_tables+0xa3>
   43f25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43f29:	48 c1 e8 0c          	shr    $0xc,%rax
   43f2d:	48 98                	cltq   
   43f2f:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43f36:	00 
   43f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43f3b:	48 c1 e8 0c          	shr    $0xc,%rax
   43f3f:	48 98                	cltq   
   43f41:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43f48:	00 
   43f49:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   43f4e:	74 24                	je     43f74 <process_config_tables+0xce>
   43f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43f54:	48 c1 e8 0c          	shr    $0xc,%rax
   43f58:	48 98                	cltq   
   43f5a:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43f61:	00 
   43f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43f66:	48 c1 e8 0c          	shr    $0xc,%rax
   43f6a:	48 98                	cltq   
   43f6c:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43f73:	00 
   43f74:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   43f79:	74 24                	je     43f9f <process_config_tables+0xf9>
   43f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43f7f:	48 c1 e8 0c          	shr    $0xc,%rax
   43f83:	48 98                	cltq   
   43f85:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43f8c:	00 
   43f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43f91:	48 c1 e8 0c          	shr    $0xc,%rax
   43f95:	48 98                	cltq   
   43f97:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43f9e:	00 
   43f9f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   43fa4:	74 24                	je     43fca <process_config_tables+0x124>
   43fa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43faa:	48 c1 e8 0c          	shr    $0xc,%rax
   43fae:	48 98                	cltq   
   43fb0:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43fb7:	00 
   43fb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43fbc:	48 c1 e8 0c          	shr    $0xc,%rax
   43fc0:	48 98                	cltq   
   43fc2:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43fc9:	00 
   43fca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   43fcf:	74 24                	je     43ff5 <process_config_tables+0x14f>
   43fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43fd5:	48 c1 e8 0c          	shr    $0xc,%rax
   43fd9:	48 98                	cltq   
   43fdb:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   43fe2:	00 
   43fe3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43fe7:	48 c1 e8 0c          	shr    $0xc,%rax
   43feb:	48 98                	cltq   
   43fed:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   43ff4:	00 
   43ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43ffa:	e9 f3 01 00 00       	jmpq   441f2 <process_config_tables+0x34c>
   43fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44003:	ba 00 10 00 00       	mov    $0x1000,%edx
   44008:	be 00 00 00 00       	mov    $0x0,%esi
   4400d:	48 89 c7             	mov    %rax,%rdi
   44010:	e8 8a f1 ff ff       	callq  4319f <memset>
   44015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44019:	ba 00 10 00 00       	mov    $0x1000,%edx
   4401e:	be 00 00 00 00       	mov    $0x0,%esi
   44023:	48 89 c7             	mov    %rax,%rdi
   44026:	e8 74 f1 ff ff       	callq  4319f <memset>
   4402b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4402f:	ba 00 10 00 00       	mov    $0x1000,%edx
   44034:	be 00 00 00 00       	mov    $0x0,%esi
   44039:	48 89 c7             	mov    %rax,%rdi
   4403c:	e8 5e f1 ff ff       	callq  4319f <memset>
   44041:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   44045:	ba 00 10 00 00       	mov    $0x1000,%edx
   4404a:	be 00 00 00 00       	mov    $0x0,%esi
   4404f:	48 89 c7             	mov    %rax,%rdi
   44052:	e8 48 f1 ff ff       	callq  4319f <memset>
   44057:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4405b:	ba 00 10 00 00       	mov    $0x1000,%edx
   44060:	be 00 00 00 00       	mov    $0x0,%esi
   44065:	48 89 c7             	mov    %rax,%rdi
   44068:	e8 32 f1 ff ff       	callq  4319f <memset>
   4406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44071:	48 83 c8 07          	or     $0x7,%rax
   44075:	48 89 c2             	mov    %rax,%rdx
   44078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4407c:	48 89 10             	mov    %rdx,(%rax)
   4407f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44083:	48 83 c8 07          	or     $0x7,%rax
   44087:	48 89 c2             	mov    %rax,%rdx
   4408a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4408e:	48 89 10             	mov    %rdx,(%rax)
   44091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   44095:	48 83 c8 07          	or     $0x7,%rax
   44099:	48 89 c2             	mov    %rax,%rdx
   4409c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   440a0:	48 89 10             	mov    %rdx,(%rax)
   440a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   440a7:	48 83 c8 07          	or     $0x7,%rax
   440ab:	48 89 c2             	mov    %rax,%rdx
   440ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   440b2:	48 89 50 08          	mov    %rdx,0x8(%rax)
   440b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   440ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   440c0:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   440c6:	b9 00 00 10 00       	mov    $0x100000,%ecx
   440cb:	ba 00 00 00 00       	mov    $0x0,%edx
   440d0:	be 00 00 00 00       	mov    $0x0,%esi
   440d5:	48 89 c7             	mov    %rax,%rdi
   440d8:	e8 ad e7 ff ff       	callq  4288a <virtual_memory_map>
   440dd:	85 c0                	test   %eax,%eax
   440df:	75 2f                	jne    44110 <process_config_tables+0x26a>
   440e1:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   440e6:	be 00 80 0b 00       	mov    $0xb8000,%esi
   440eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   440ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   440f5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   440fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
   44100:	48 89 c7             	mov    %rax,%rdi
   44103:	e8 82 e7 ff ff       	callq  4288a <virtual_memory_map>
   44108:	85 c0                	test   %eax,%eax
   4410a:	0f 84 bb 00 00 00    	je     441cb <process_config_tables+0x325>
   44110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44114:	48 c1 e8 0c          	shr    $0xc,%rax
   44118:	48 98                	cltq   
   4411a:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   44121:	00 
   44122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44126:	48 c1 e8 0c          	shr    $0xc,%rax
   4412a:	48 98                	cltq   
   4412c:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   44133:	00 
   44134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44138:	48 c1 e8 0c          	shr    $0xc,%rax
   4413c:	48 98                	cltq   
   4413e:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   44145:	00 
   44146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4414a:	48 c1 e8 0c          	shr    $0xc,%rax
   4414e:	48 98                	cltq   
   44150:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   44157:	00 
   44158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4415c:	48 c1 e8 0c          	shr    $0xc,%rax
   44160:	48 98                	cltq   
   44162:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   44169:	00 
   4416a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4416e:	48 c1 e8 0c          	shr    $0xc,%rax
   44172:	48 98                	cltq   
   44174:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   4417b:	00 
   4417c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   44180:	48 c1 e8 0c          	shr    $0xc,%rax
   44184:	48 98                	cltq   
   44186:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   4418d:	00 
   4418e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   44192:	48 c1 e8 0c          	shr    $0xc,%rax
   44196:	48 98                	cltq   
   44198:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   4419f:	00 
   441a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   441a4:	48 c1 e8 0c          	shr    $0xc,%rax
   441a8:	48 98                	cltq   
   441aa:	c6 84 00 20 4f 05 00 	movb   $0x0,0x54f20(%rax,%rax,1)
   441b1:	00 
   441b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   441b6:	48 c1 e8 0c          	shr    $0xc,%rax
   441ba:	48 98                	cltq   
   441bc:	c6 84 00 21 4f 05 00 	movb   $0x0,0x54f21(%rax,%rax,1)
   441c3:	00 
   441c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   441c9:	eb 27                	jmp    441f2 <process_config_tables+0x34c>
   441cb:	8b 45 cc             	mov    -0x34(%rbp),%eax
   441ce:	48 63 d0             	movslq %eax,%rdx
   441d1:	48 89 d0             	mov    %rdx,%rax
   441d4:	48 c1 e0 04          	shl    $0x4,%rax
   441d8:	48 29 d0             	sub    %rdx,%rax
   441db:	48 c1 e0 04          	shl    $0x4,%rax
   441df:	48 8d 90 e0 40 05 00 	lea    0x540e0(%rax),%rdx
   441e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   441ea:	48 89 02             	mov    %rax,(%rdx)
   441ed:	b8 00 00 00 00       	mov    $0x0,%eax
   441f2:	c9                   	leaveq 
   441f3:	c3                   	retq   

00000000000441f4 <process_load>:
   441f4:	55                   	push   %rbp
   441f5:	48 89 e5             	mov    %rsp,%rbp
   441f8:	48 83 ec 20          	sub    $0x20,%rsp
   441fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   44200:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   44203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44207:	48 89 05 fa 8d 01 00 	mov    %rax,0x18dfa(%rip)        # 5d008 <palloc_target_proc>
   4420e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
   44211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44215:	ba 8e 3b 04 00       	mov    $0x43b8e,%edx
   4421a:	89 ce                	mov    %ecx,%esi
   4421c:	48 89 c7             	mov    %rax,%rdi
   4421f:	e8 20 eb ff ff       	callq  42d44 <program_load>
   44224:	89 45 fc             	mov    %eax,-0x4(%rbp)
   44227:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4422a:	c9                   	leaveq 
   4422b:	c3                   	retq   

000000000004422c <process_setup_stack>:
   4422c:	55                   	push   %rbp
   4422d:	48 89 e5             	mov    %rsp,%rbp
   44230:	48 83 ec 20          	sub    $0x20,%rsp
   44234:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   44238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4423c:	8b 00                	mov    (%rax),%eax
   4423e:	89 c7                	mov    %eax,%edi
   44240:	e8 66 f8 ff ff       	callq  43aab <palloc>
   44245:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   44249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4424d:	48 c7 80 c8 00 00 00 	movq   $0x300000,0xc8(%rax)
   44254:	00 00 30 00 
   44258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4425c:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   44263:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   44267:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   4426d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   44273:	b9 00 10 00 00       	mov    $0x1000,%ecx
   44278:	be 00 f0 2f 00       	mov    $0x2ff000,%esi
   4427d:	48 89 c7             	mov    %rax,%rdi
   44280:	e8 05 e6 ff ff       	callq  4288a <virtual_memory_map>
   44285:	90                   	nop
   44286:	c9                   	leaveq 
   44287:	c3                   	retq   

0000000000044288 <find_free_pid>:
   44288:	55                   	push   %rbp
   44289:	48 89 e5             	mov    %rsp,%rbp
   4428c:	48 83 ec 10          	sub    $0x10,%rsp
   44290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   44297:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   4429e:	eb 24                	jmp    442c4 <find_free_pid+0x3c>
   442a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
   442a3:	48 63 d0             	movslq %eax,%rdx
   442a6:	48 89 d0             	mov    %rdx,%rax
   442a9:	48 c1 e0 04          	shl    $0x4,%rax
   442ad:	48 29 d0             	sub    %rdx,%rax
   442b0:	48 c1 e0 04          	shl    $0x4,%rax
   442b4:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   442ba:	8b 00                	mov    (%rax),%eax
   442bc:	85 c0                	test   %eax,%eax
   442be:	74 0c                	je     442cc <find_free_pid+0x44>
   442c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   442c4:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   442c8:	7e d6                	jle    442a0 <find_free_pid+0x18>
   442ca:	eb 01                	jmp    442cd <find_free_pid+0x45>
   442cc:	90                   	nop
   442cd:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   442d1:	74 05                	je     442d8 <find_free_pid+0x50>
   442d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   442d6:	eb 05                	jmp    442dd <find_free_pid+0x55>
   442d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   442dd:	c9                   	leaveq 
   442de:	c3                   	retq   

00000000000442df <process_fork>:
   442df:	55                   	push   %rbp
   442e0:	48 89 e5             	mov    %rsp,%rbp
   442e3:	48 83 ec 40          	sub    $0x40,%rsp
   442e7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   442eb:	b8 00 00 00 00       	mov    $0x0,%eax
   442f0:	e8 93 ff ff ff       	callq  44288 <find_free_pid>
   442f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
   442f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%rbp)
   442fc:	75 0a                	jne    44308 <process_fork+0x29>
   442fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   44303:	e9 67 02 00 00       	jmpq   4456f <process_fork+0x290>
   44308:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4430b:	48 63 d0             	movslq %eax,%rdx
   4430e:	48 89 d0             	mov    %rdx,%rax
   44311:	48 c1 e0 04          	shl    $0x4,%rax
   44315:	48 29 d0             	sub    %rdx,%rax
   44318:	48 c1 e0 04          	shl    $0x4,%rax
   4431c:	48 05 00 40 05 00    	add    $0x54000,%rax
   44322:	be 00 00 00 00       	mov    $0x0,%esi
   44327:	48 89 c7             	mov    %rax,%rdi
   4432a:	e8 94 da ff ff       	callq  41dc3 <process_init>
   4432f:	8b 45 f4             	mov    -0xc(%rbp),%eax
   44332:	89 c7                	mov    %eax,%edi
   44334:	e8 6d fb ff ff       	callq  43ea6 <process_config_tables>
   44339:	83 f8 ff             	cmp    $0xffffffff,%eax
   4433c:	75 0a                	jne    44348 <process_fork+0x69>
   4433e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   44343:	e9 27 02 00 00       	jmpq   4456f <process_fork+0x290>
   44348:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   4434f:	00 
   44350:	e9 79 01 00 00       	jmpq   444ce <process_fork+0x1ef>
   44355:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   44359:	8b 00                	mov    (%rax),%eax
   4435b:	48 63 d0             	movslq %eax,%rdx
   4435e:	48 89 d0             	mov    %rdx,%rax
   44361:	48 c1 e0 04          	shl    $0x4,%rax
   44365:	48 29 d0             	sub    %rdx,%rax
   44368:	48 c1 e0 04          	shl    $0x4,%rax
   4436c:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   44372:	48 8b 08             	mov    (%rax),%rcx
   44375:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   44379:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4437d:	48 89 ce             	mov    %rcx,%rsi
   44380:	48 89 c7             	mov    %rax,%rdi
   44383:	e8 c5 e8 ff ff       	callq  42c4d <virtual_memory_lookup>
   44388:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4438b:	48 98                	cltq   
   4438d:	83 e0 07             	and    $0x7,%eax
   44390:	48 83 f8 07          	cmp    $0x7,%rax
   44394:	0f 85 a1 00 00 00    	jne    4443b <process_fork+0x15c>
   4439a:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4439d:	89 c7                	mov    %eax,%edi
   4439f:	e8 07 f7 ff ff       	callq  43aab <palloc>
   443a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   443a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   443ad:	75 14                	jne    443c3 <process_fork+0xe4>
   443af:	8b 45 f4             	mov    -0xc(%rbp),%eax
   443b2:	89 c7                	mov    %eax,%edi
   443b4:	e8 0b f8 ff ff       	callq  43bc4 <process_free>
   443b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   443be:	e9 ac 01 00 00       	jmpq   4456f <process_fork+0x290>
   443c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   443c7:	48 89 c1             	mov    %rax,%rcx
   443ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   443ce:	ba 00 10 00 00       	mov    $0x1000,%edx
   443d3:	48 89 ce             	mov    %rcx,%rsi
   443d6:	48 89 c7             	mov    %rax,%rdi
   443d9:	e8 58 ed ff ff       	callq  43136 <memcpy>
   443de:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
   443e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   443e5:	48 63 d0             	movslq %eax,%rdx
   443e8:	48 89 d0             	mov    %rdx,%rax
   443eb:	48 c1 e0 04          	shl    $0x4,%rax
   443ef:	48 29 d0             	sub    %rdx,%rax
   443f2:	48 c1 e0 04          	shl    $0x4,%rax
   443f6:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   443fc:	48 8b 00             	mov    (%rax),%rax
   443ff:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   44403:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   44409:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   4440f:	b9 00 10 00 00       	mov    $0x1000,%ecx
   44414:	48 89 fa             	mov    %rdi,%rdx
   44417:	48 89 c7             	mov    %rax,%rdi
   4441a:	e8 6b e4 ff ff       	callq  4288a <virtual_memory_map>
   4441f:	85 c0                	test   %eax,%eax
   44421:	0f 84 9f 00 00 00    	je     444c6 <process_fork+0x1e7>
   44427:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4442a:	89 c7                	mov    %eax,%edi
   4442c:	e8 93 f7 ff ff       	callq  43bc4 <process_free>
   44431:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   44436:	e9 34 01 00 00       	jmpq   4456f <process_fork+0x290>
   4443b:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4443e:	48 98                	cltq   
   44440:	83 e0 05             	and    $0x5,%eax
   44443:	48 83 f8 05          	cmp    $0x5,%rax
   44447:	75 7d                	jne    444c6 <process_fork+0x1e7>
   44449:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
   4444d:	8b 45 f4             	mov    -0xc(%rbp),%eax
   44450:	48 63 d0             	movslq %eax,%rdx
   44453:	48 89 d0             	mov    %rdx,%rax
   44456:	48 c1 e0 04          	shl    $0x4,%rax
   4445a:	48 29 d0             	sub    %rdx,%rax
   4445d:	48 c1 e0 04          	shl    $0x4,%rax
   44461:	48 05 e0 40 05 00    	add    $0x540e0,%rax
   44467:	48 8b 00             	mov    (%rax),%rax
   4446a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   4446e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   44474:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   4447a:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4447f:	48 89 fa             	mov    %rdi,%rdx
   44482:	48 89 c7             	mov    %rax,%rdi
   44485:	e8 00 e4 ff ff       	callq  4288a <virtual_memory_map>
   4448a:	85 c0                	test   %eax,%eax
   4448c:	74 14                	je     444a2 <process_fork+0x1c3>
   4448e:	8b 45 f4             	mov    -0xc(%rbp),%eax
   44491:	89 c7                	mov    %eax,%edi
   44493:	e8 2c f7 ff ff       	callq  43bc4 <process_free>
   44498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4449d:	e9 cd 00 00 00       	jmpq   4456f <process_fork+0x290>
   444a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   444a6:	48 c1 e8 0c          	shr    $0xc,%rax
   444aa:	89 c2                	mov    %eax,%edx
   444ac:	48 63 c2             	movslq %edx,%rax
   444af:	0f b6 84 00 21 4f 05 	movzbl 0x54f21(%rax,%rax,1),%eax
   444b6:	00 
   444b7:	83 c0 01             	add    $0x1,%eax
   444ba:	89 c1                	mov    %eax,%ecx
   444bc:	48 63 c2             	movslq %edx,%rax
   444bf:	88 8c 00 21 4f 05 00 	mov    %cl,0x54f21(%rax,%rax,1)
   444c6:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   444cd:	00 
   444ce:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   444d5:	00 
   444d6:	0f 86 79 fe ff ff    	jbe    44355 <process_fork+0x76>
   444dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   444e0:	8b 08                	mov    (%rax),%ecx
   444e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   444e5:	48 63 d0             	movslq %eax,%rdx
   444e8:	48 89 d0             	mov    %rdx,%rax
   444eb:	48 c1 e0 04          	shl    $0x4,%rax
   444ef:	48 29 d0             	sub    %rdx,%rax
   444f2:	48 c1 e0 04          	shl    $0x4,%rax
   444f6:	48 8d b0 10 40 05 00 	lea    0x54010(%rax),%rsi
   444fd:	48 63 d1             	movslq %ecx,%rdx
   44500:	48 89 d0             	mov    %rdx,%rax
   44503:	48 c1 e0 04          	shl    $0x4,%rax
   44507:	48 29 d0             	sub    %rdx,%rax
   4450a:	48 c1 e0 04          	shl    $0x4,%rax
   4450e:	48 8d 90 10 40 05 00 	lea    0x54010(%rax),%rdx
   44515:	48 8d 46 08          	lea    0x8(%rsi),%rax
   44519:	48 83 c2 08          	add    $0x8,%rdx
   4451d:	b9 18 00 00 00       	mov    $0x18,%ecx
   44522:	48 89 c7             	mov    %rax,%rdi
   44525:	48 89 d6             	mov    %rdx,%rsi
   44528:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
   4452b:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4452e:	48 63 d0             	movslq %eax,%rdx
   44531:	48 89 d0             	mov    %rdx,%rax
   44534:	48 c1 e0 04          	shl    $0x4,%rax
   44538:	48 29 d0             	sub    %rdx,%rax
   4453b:	48 c1 e0 04          	shl    $0x4,%rax
   4453f:	48 05 18 40 05 00    	add    $0x54018,%rax
   44545:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
   4454c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4454f:	48 63 d0             	movslq %eax,%rdx
   44552:	48 89 d0             	mov    %rdx,%rax
   44555:	48 c1 e0 04          	shl    $0x4,%rax
   44559:	48 29 d0             	sub    %rdx,%rax
   4455c:	48 c1 e0 04          	shl    $0x4,%rax
   44560:	48 05 d8 40 05 00    	add    $0x540d8,%rax
   44566:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
   4456c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4456f:	c9                   	leaveq 
   44570:	c3                   	retq   

0000000000044571 <process_page_alloc>:
   44571:	55                   	push   %rbp
   44572:	48 89 e5             	mov    %rsp,%rbp
   44575:	48 83 ec 20          	sub    $0x20,%rsp
   44579:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4457d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   44581:	48 81 7d e0 ff ff 0f 	cmpq   $0xfffff,-0x20(%rbp)
   44588:	00 
   44589:	77 07                	ja     44592 <process_page_alloc+0x21>
   4458b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   44590:	eb 4b                	jmp    445dd <process_page_alloc+0x6c>
   44592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44596:	8b 00                	mov    (%rax),%eax
   44598:	89 c7                	mov    %eax,%edi
   4459a:	e8 0c f5 ff ff       	callq  43aab <palloc>
   4459f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   445a3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   445a8:	74 2e                	je     445d8 <process_page_alloc+0x67>
   445aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   445ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   445b2:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   445b9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
   445bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   445c3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   445c9:	b9 00 10 00 00       	mov    $0x1000,%ecx
   445ce:	48 89 c7             	mov    %rax,%rdi
   445d1:	e8 b4 e2 ff ff       	callq  4288a <virtual_memory_map>
   445d6:	eb 05                	jmp    445dd <process_page_alloc+0x6c>
   445d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   445dd:	c9                   	leaveq 
   445de:	c3                   	retq   
