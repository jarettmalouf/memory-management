
obj/p-malloc.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 31                	int    $0x31
  10000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10000d:	b8 4f 30 10 00       	mov    $0x10304f,%eax
  100012:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100018:	48 89 05 e9 1f 00 00 	mov    %rax,0x1fe9(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10001f:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100022:	48 83 e8 01          	sub    $0x1,%rax
  100026:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10002c:	48 89 05 cd 1f 00 00 	mov    %rax,0x1fcd(%rip)        # 102000 <stack_bottom>
  100033:	eb 02                	jmp    100037 <process_main+0x37>

// yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void yield(void) {
    asm volatile ("int %0" : /* no result */
  100035:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
	if ((rand() % ALLOC_SLOWDOWN) < p) {
  100037:	e8 00 02 00 00       	callq  10023c <rand>
  10003c:	48 63 d0             	movslq %eax,%rdx
  10003f:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100046:	48 c1 fa 25          	sar    $0x25,%rdx
  10004a:	89 c1                	mov    %eax,%ecx
  10004c:	c1 f9 1f             	sar    $0x1f,%ecx
  10004f:	29 ca                	sub    %ecx,%edx
  100051:	6b d2 64             	imul   $0x64,%edx,%edx
  100054:	29 d0                	sub    %edx,%eax
  100056:	39 d8                	cmp    %ebx,%eax
  100058:	7d db                	jge    100035 <process_main+0x35>
	    void * ret = malloc(PAGESIZE);
  10005a:	bf 00 10 00 00       	mov    $0x1000,%edi
  10005f:	e8 00 11 00 00       	callq  101164 <malloc>
	    if(ret == NULL)
  100064:	48 85 c0             	test   %rax,%rax
  100067:	74 04                	je     10006d <process_main+0x6d>
		break;
	    *((int*)ret) = p;       // check we have write access
  100069:	89 18                	mov    %ebx,(%rax)
  10006b:	eb c8                	jmp    100035 <process_main+0x35>
  10006d:	cd 32                	int    $0x32
  10006f:	eb fc                	jmp    10006d <process_main+0x6d>

0000000000100071 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100071:	48 89 f9             	mov    %rdi,%rcx
  100074:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100076:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  10007d:	00 
  10007e:	72 08                	jb     100088 <console_putc+0x17>
        cp->cursor = console;
  100080:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  100087:	00 
    }
    if (c == '\n') {
  100088:	40 80 fe 0a          	cmp    $0xa,%sil
  10008c:	74 16                	je     1000a4 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  10008e:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100092:	48 8d 50 02          	lea    0x2(%rax),%rdx
  100096:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  10009a:	40 0f b6 f6          	movzbl %sil,%esi
  10009e:	09 fe                	or     %edi,%esi
  1000a0:	66 89 30             	mov    %si,(%rax)
    }
}
  1000a3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1000a4:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1000a8:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1000af:	4c 89 c6             	mov    %r8,%rsi
  1000b2:	48 d1 fe             	sar    %rsi
  1000b5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1000bc:	66 66 66 
  1000bf:	48 89 f0             	mov    %rsi,%rax
  1000c2:	48 f7 ea             	imul   %rdx
  1000c5:	48 c1 fa 05          	sar    $0x5,%rdx
  1000c9:	49 c1 f8 3f          	sar    $0x3f,%r8
  1000cd:	4c 29 c2             	sub    %r8,%rdx
  1000d0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1000d4:	48 c1 e2 04          	shl    $0x4,%rdx
  1000d8:	89 f0                	mov    %esi,%eax
  1000da:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1000dc:	83 cf 20             	or     $0x20,%edi
  1000df:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1000e3:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1000e7:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1000eb:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1000ee:	83 c0 01             	add    $0x1,%eax
  1000f1:	83 f8 50             	cmp    $0x50,%eax
  1000f4:	75 e9                	jne    1000df <console_putc+0x6e>
  1000f6:	c3                   	retq   

00000000001000f7 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1000f7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1000fb:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1000ff:	73 0b                	jae    10010c <string_putc+0x15>
        *sp->s++ = c;
  100101:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100105:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100109:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  10010c:	c3                   	retq   

000000000010010d <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  10010d:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100110:	48 85 d2             	test   %rdx,%rdx
  100113:	74 17                	je     10012c <memcpy+0x1f>
  100115:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  10011a:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  10011f:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100123:	48 83 c1 01          	add    $0x1,%rcx
  100127:	48 39 d1             	cmp    %rdx,%rcx
  10012a:	75 ee                	jne    10011a <memcpy+0xd>
}
  10012c:	c3                   	retq   

000000000010012d <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  10012d:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100130:	48 39 fe             	cmp    %rdi,%rsi
  100133:	72 1d                	jb     100152 <memmove+0x25>
        while (n-- > 0) {
  100135:	b9 00 00 00 00       	mov    $0x0,%ecx
  10013a:	48 85 d2             	test   %rdx,%rdx
  10013d:	74 12                	je     100151 <memmove+0x24>
            *d++ = *s++;
  10013f:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100143:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100147:	48 83 c1 01          	add    $0x1,%rcx
  10014b:	48 39 ca             	cmp    %rcx,%rdx
  10014e:	75 ef                	jne    10013f <memmove+0x12>
}
  100150:	c3                   	retq   
  100151:	c3                   	retq   
    if (s < d && s + n > d) {
  100152:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100156:	48 39 cf             	cmp    %rcx,%rdi
  100159:	73 da                	jae    100135 <memmove+0x8>
        while (n-- > 0) {
  10015b:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10015f:	48 85 d2             	test   %rdx,%rdx
  100162:	74 ec                	je     100150 <memmove+0x23>
            *--d = *--s;
  100164:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100168:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  10016b:	48 83 e9 01          	sub    $0x1,%rcx
  10016f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100173:	75 ef                	jne    100164 <memmove+0x37>
  100175:	c3                   	retq   

0000000000100176 <memset>:
void* memset(void* v, int c, size_t n) {
  100176:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100179:	48 85 d2             	test   %rdx,%rdx
  10017c:	74 12                	je     100190 <memset+0x1a>
  10017e:	48 01 fa             	add    %rdi,%rdx
  100181:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  100184:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100187:	48 83 c1 01          	add    $0x1,%rcx
  10018b:	48 39 ca             	cmp    %rcx,%rdx
  10018e:	75 f4                	jne    100184 <memset+0xe>
}
  100190:	c3                   	retq   

0000000000100191 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  100191:	80 3f 00             	cmpb   $0x0,(%rdi)
  100194:	74 10                	je     1001a6 <strlen+0x15>
  100196:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  10019b:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  10019f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001a3:	75 f6                	jne    10019b <strlen+0xa>
  1001a5:	c3                   	retq   
  1001a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1001ab:	c3                   	retq   

00000000001001ac <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1001ac:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001af:	ba 00 00 00 00       	mov    $0x0,%edx
  1001b4:	48 85 f6             	test   %rsi,%rsi
  1001b7:	74 11                	je     1001ca <strnlen+0x1e>
  1001b9:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1001bd:	74 0c                	je     1001cb <strnlen+0x1f>
        ++n;
  1001bf:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001c3:	48 39 d0             	cmp    %rdx,%rax
  1001c6:	75 f1                	jne    1001b9 <strnlen+0xd>
  1001c8:	eb 04                	jmp    1001ce <strnlen+0x22>
  1001ca:	c3                   	retq   
  1001cb:	48 89 d0             	mov    %rdx,%rax
}
  1001ce:	c3                   	retq   

00000000001001cf <strcpy>:
char* strcpy(char* dst, const char* src) {
  1001cf:	48 89 f8             	mov    %rdi,%rax
  1001d2:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1001d7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1001db:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1001de:	48 83 c2 01          	add    $0x1,%rdx
  1001e2:	84 c9                	test   %cl,%cl
  1001e4:	75 f1                	jne    1001d7 <strcpy+0x8>
}
  1001e6:	c3                   	retq   

00000000001001e7 <strcmp>:
    while (*a && *b && *a == *b) {
  1001e7:	0f b6 07             	movzbl (%rdi),%eax
  1001ea:	84 c0                	test   %al,%al
  1001ec:	74 1a                	je     100208 <strcmp+0x21>
  1001ee:	0f b6 16             	movzbl (%rsi),%edx
  1001f1:	38 c2                	cmp    %al,%dl
  1001f3:	75 13                	jne    100208 <strcmp+0x21>
  1001f5:	84 d2                	test   %dl,%dl
  1001f7:	74 0f                	je     100208 <strcmp+0x21>
        ++a, ++b;
  1001f9:	48 83 c7 01          	add    $0x1,%rdi
  1001fd:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  100201:	0f b6 07             	movzbl (%rdi),%eax
  100204:	84 c0                	test   %al,%al
  100206:	75 e6                	jne    1001ee <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  100208:	3a 06                	cmp    (%rsi),%al
  10020a:	0f 97 c0             	seta   %al
  10020d:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  100210:	83 d8 00             	sbb    $0x0,%eax
}
  100213:	c3                   	retq   

0000000000100214 <strchr>:
    while (*s && *s != (char) c) {
  100214:	0f b6 07             	movzbl (%rdi),%eax
  100217:	84 c0                	test   %al,%al
  100219:	74 10                	je     10022b <strchr+0x17>
  10021b:	40 38 f0             	cmp    %sil,%al
  10021e:	74 18                	je     100238 <strchr+0x24>
        ++s;
  100220:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  100224:	0f b6 07             	movzbl (%rdi),%eax
  100227:	84 c0                	test   %al,%al
  100229:	75 f0                	jne    10021b <strchr+0x7>
        return NULL;
  10022b:	40 84 f6             	test   %sil,%sil
  10022e:	b8 00 00 00 00       	mov    $0x0,%eax
  100233:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100237:	c3                   	retq   
  100238:	48 89 f8             	mov    %rdi,%rax
  10023b:	c3                   	retq   

000000000010023c <rand>:
    if (!rand_seed_set) {
  10023c:	83 3d d1 1d 00 00 00 	cmpl   $0x0,0x1dd1(%rip)        # 102014 <rand_seed_set>
  100243:	74 1b                	je     100260 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100245:	69 05 c1 1d 00 00 0d 	imul   $0x19660d,0x1dc1(%rip),%eax        # 102010 <rand_seed>
  10024c:	66 19 00 
  10024f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100254:	89 05 b6 1d 00 00    	mov    %eax,0x1db6(%rip)        # 102010 <rand_seed>
    return rand_seed & RAND_MAX;
  10025a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10025f:	c3                   	retq   
    rand_seed = seed;
  100260:	c7 05 a6 1d 00 00 9e 	movl   $0x30d4879e,0x1da6(%rip)        # 102010 <rand_seed>
  100267:	87 d4 30 
    rand_seed_set = 1;
  10026a:	c7 05 a0 1d 00 00 01 	movl   $0x1,0x1da0(%rip)        # 102014 <rand_seed_set>
  100271:	00 00 00 
}
  100274:	eb cf                	jmp    100245 <rand+0x9>

0000000000100276 <srand>:
    rand_seed = seed;
  100276:	89 3d 94 1d 00 00    	mov    %edi,0x1d94(%rip)        # 102010 <rand_seed>
    rand_seed_set = 1;
  10027c:	c7 05 8e 1d 00 00 01 	movl   $0x1,0x1d8e(%rip)        # 102014 <rand_seed_set>
  100283:	00 00 00 
}
  100286:	c3                   	retq   

0000000000100287 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100287:	55                   	push   %rbp
  100288:	48 89 e5             	mov    %rsp,%rbp
  10028b:	41 57                	push   %r15
  10028d:	41 56                	push   %r14
  10028f:	41 55                	push   %r13
  100291:	41 54                	push   %r12
  100293:	53                   	push   %rbx
  100294:	48 83 ec 58          	sub    $0x58,%rsp
  100298:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  10029c:	0f b6 02             	movzbl (%rdx),%eax
  10029f:	84 c0                	test   %al,%al
  1002a1:	0f 84 b0 06 00 00    	je     100957 <printer_vprintf+0x6d0>
  1002a7:	49 89 fe             	mov    %rdi,%r14
  1002aa:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1002ad:	41 89 f7             	mov    %esi,%r15d
  1002b0:	e9 a4 04 00 00       	jmpq   100759 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1002b5:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1002ba:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1002c0:	45 84 e4             	test   %r12b,%r12b
  1002c3:	0f 84 82 06 00 00    	je     10094b <printer_vprintf+0x6c4>
        int flags = 0;
  1002c9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1002cf:	41 0f be f4          	movsbl %r12b,%esi
  1002d3:	bf 41 17 10 00       	mov    $0x101741,%edi
  1002d8:	e8 37 ff ff ff       	callq  100214 <strchr>
  1002dd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1002e0:	48 85 c0             	test   %rax,%rax
  1002e3:	74 55                	je     10033a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1002e5:	48 81 e9 41 17 10 00 	sub    $0x101741,%rcx
  1002ec:	b8 01 00 00 00       	mov    $0x1,%eax
  1002f1:	d3 e0                	shl    %cl,%eax
  1002f3:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1002f6:	48 83 c3 01          	add    $0x1,%rbx
  1002fa:	44 0f b6 23          	movzbl (%rbx),%r12d
  1002fe:	45 84 e4             	test   %r12b,%r12b
  100301:	75 cc                	jne    1002cf <printer_vprintf+0x48>
  100303:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  100307:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  10030d:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  100314:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  100317:	0f 84 a9 00 00 00    	je     1003c6 <printer_vprintf+0x13f>
        int length = 0;
  10031d:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  100322:	0f b6 13             	movzbl (%rbx),%edx
  100325:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100328:	3c 37                	cmp    $0x37,%al
  10032a:	0f 87 c4 04 00 00    	ja     1007f4 <printer_vprintf+0x56d>
  100330:	0f b6 c0             	movzbl %al,%eax
  100333:	ff 24 c5 50 15 10 00 	jmpq   *0x101550(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  10033a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  10033e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  100343:	3c 08                	cmp    $0x8,%al
  100345:	77 2f                	ja     100376 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100347:	0f b6 03             	movzbl (%rbx),%eax
  10034a:	8d 50 d0             	lea    -0x30(%rax),%edx
  10034d:	80 fa 09             	cmp    $0x9,%dl
  100350:	77 5e                	ja     1003b0 <printer_vprintf+0x129>
  100352:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100358:	48 83 c3 01          	add    $0x1,%rbx
  10035c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100361:	0f be c0             	movsbl %al,%eax
  100364:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100369:	0f b6 03             	movzbl (%rbx),%eax
  10036c:	8d 50 d0             	lea    -0x30(%rax),%edx
  10036f:	80 fa 09             	cmp    $0x9,%dl
  100372:	76 e4                	jbe    100358 <printer_vprintf+0xd1>
  100374:	eb 97                	jmp    10030d <printer_vprintf+0x86>
        } else if (*format == '*') {
  100376:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10037a:	75 3f                	jne    1003bb <printer_vprintf+0x134>
            width = va_arg(val, int);
  10037c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100380:	8b 07                	mov    (%rdi),%eax
  100382:	83 f8 2f             	cmp    $0x2f,%eax
  100385:	77 17                	ja     10039e <printer_vprintf+0x117>
  100387:	89 c2                	mov    %eax,%edx
  100389:	48 03 57 10          	add    0x10(%rdi),%rdx
  10038d:	83 c0 08             	add    $0x8,%eax
  100390:	89 07                	mov    %eax,(%rdi)
  100392:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100395:	48 83 c3 01          	add    $0x1,%rbx
  100399:	e9 6f ff ff ff       	jmpq   10030d <printer_vprintf+0x86>
            width = va_arg(val, int);
  10039e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1003a2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1003a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1003aa:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1003ae:	eb e2                	jmp    100392 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003b0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1003b6:	e9 52 ff ff ff       	jmpq   10030d <printer_vprintf+0x86>
        int width = -1;
  1003bb:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1003c1:	e9 47 ff ff ff       	jmpq   10030d <printer_vprintf+0x86>
            ++format;
  1003c6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1003ca:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1003ce:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1003d1:	80 f9 09             	cmp    $0x9,%cl
  1003d4:	76 13                	jbe    1003e9 <printer_vprintf+0x162>
            } else if (*format == '*') {
  1003d6:	3c 2a                	cmp    $0x2a,%al
  1003d8:	74 33                	je     10040d <printer_vprintf+0x186>
            ++format;
  1003da:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1003dd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1003e4:	e9 34 ff ff ff       	jmpq   10031d <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1003e9:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1003ee:	48 83 c2 01          	add    $0x1,%rdx
  1003f2:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1003f5:	0f be c0             	movsbl %al,%eax
  1003f8:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1003fc:	0f b6 02             	movzbl (%rdx),%eax
  1003ff:	8d 70 d0             	lea    -0x30(%rax),%esi
  100402:	40 80 fe 09          	cmp    $0x9,%sil
  100406:	76 e6                	jbe    1003ee <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  100408:	48 89 d3             	mov    %rdx,%rbx
  10040b:	eb 1c                	jmp    100429 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  10040d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100411:	8b 07                	mov    (%rdi),%eax
  100413:	83 f8 2f             	cmp    $0x2f,%eax
  100416:	77 23                	ja     10043b <printer_vprintf+0x1b4>
  100418:	89 c2                	mov    %eax,%edx
  10041a:	48 03 57 10          	add    0x10(%rdi),%rdx
  10041e:	83 c0 08             	add    $0x8,%eax
  100421:	89 07                	mov    %eax,(%rdi)
  100423:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100425:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100429:	85 c9                	test   %ecx,%ecx
  10042b:	b8 00 00 00 00       	mov    $0x0,%eax
  100430:	0f 49 c1             	cmovns %ecx,%eax
  100433:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100436:	e9 e2 fe ff ff       	jmpq   10031d <printer_vprintf+0x96>
                precision = va_arg(val, int);
  10043b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10043f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100443:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100447:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10044b:	eb d6                	jmp    100423 <printer_vprintf+0x19c>
        switch (*format) {
  10044d:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100452:	e9 f3 00 00 00       	jmpq   10054a <printer_vprintf+0x2c3>
            ++format;
  100457:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10045b:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100460:	e9 bd fe ff ff       	jmpq   100322 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100465:	85 c9                	test   %ecx,%ecx
  100467:	74 55                	je     1004be <printer_vprintf+0x237>
  100469:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10046d:	8b 07                	mov    (%rdi),%eax
  10046f:	83 f8 2f             	cmp    $0x2f,%eax
  100472:	77 38                	ja     1004ac <printer_vprintf+0x225>
  100474:	89 c2                	mov    %eax,%edx
  100476:	48 03 57 10          	add    0x10(%rdi),%rdx
  10047a:	83 c0 08             	add    $0x8,%eax
  10047d:	89 07                	mov    %eax,(%rdi)
  10047f:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100482:	48 89 d0             	mov    %rdx,%rax
  100485:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100489:	49 89 d0             	mov    %rdx,%r8
  10048c:	49 f7 d8             	neg    %r8
  10048f:	25 80 00 00 00       	and    $0x80,%eax
  100494:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100498:	0b 45 a8             	or     -0x58(%rbp),%eax
  10049b:	83 c8 60             	or     $0x60,%eax
  10049e:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1004a1:	41 bc 48 15 10 00    	mov    $0x101548,%r12d
            break;
  1004a7:	e9 35 01 00 00       	jmpq   1005e1 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1004ac:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004b0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004b4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004b8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004bc:	eb c1                	jmp    10047f <printer_vprintf+0x1f8>
  1004be:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004c2:	8b 07                	mov    (%rdi),%eax
  1004c4:	83 f8 2f             	cmp    $0x2f,%eax
  1004c7:	77 10                	ja     1004d9 <printer_vprintf+0x252>
  1004c9:	89 c2                	mov    %eax,%edx
  1004cb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004cf:	83 c0 08             	add    $0x8,%eax
  1004d2:	89 07                	mov    %eax,(%rdi)
  1004d4:	48 63 12             	movslq (%rdx),%rdx
  1004d7:	eb a9                	jmp    100482 <printer_vprintf+0x1fb>
  1004d9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004dd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1004e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004e5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1004e9:	eb e9                	jmp    1004d4 <printer_vprintf+0x24d>
        int base = 10;
  1004eb:	be 0a 00 00 00       	mov    $0xa,%esi
  1004f0:	eb 58                	jmp    10054a <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1004f2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004f6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004fa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004fe:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100502:	eb 60                	jmp    100564 <printer_vprintf+0x2dd>
  100504:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100508:	8b 07                	mov    (%rdi),%eax
  10050a:	83 f8 2f             	cmp    $0x2f,%eax
  10050d:	77 10                	ja     10051f <printer_vprintf+0x298>
  10050f:	89 c2                	mov    %eax,%edx
  100511:	48 03 57 10          	add    0x10(%rdi),%rdx
  100515:	83 c0 08             	add    $0x8,%eax
  100518:	89 07                	mov    %eax,(%rdi)
  10051a:	44 8b 02             	mov    (%rdx),%r8d
  10051d:	eb 48                	jmp    100567 <printer_vprintf+0x2e0>
  10051f:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100523:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100527:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10052b:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10052f:	eb e9                	jmp    10051a <printer_vprintf+0x293>
  100531:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100534:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  10053b:	bf 30 17 10 00       	mov    $0x101730,%edi
  100540:	e9 e2 02 00 00       	jmpq   100827 <printer_vprintf+0x5a0>
            base = 16;
  100545:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10054a:	85 c9                	test   %ecx,%ecx
  10054c:	74 b6                	je     100504 <printer_vprintf+0x27d>
  10054e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100552:	8b 01                	mov    (%rcx),%eax
  100554:	83 f8 2f             	cmp    $0x2f,%eax
  100557:	77 99                	ja     1004f2 <printer_vprintf+0x26b>
  100559:	89 c2                	mov    %eax,%edx
  10055b:	48 03 51 10          	add    0x10(%rcx),%rdx
  10055f:	83 c0 08             	add    $0x8,%eax
  100562:	89 01                	mov    %eax,(%rcx)
  100564:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100567:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  10056b:	85 f6                	test   %esi,%esi
  10056d:	79 c2                	jns    100531 <printer_vprintf+0x2aa>
        base = -base;
  10056f:	41 89 f1             	mov    %esi,%r9d
  100572:	f7 de                	neg    %esi
  100574:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  10057b:	bf 10 17 10 00       	mov    $0x101710,%edi
  100580:	e9 a2 02 00 00       	jmpq   100827 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  100585:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100589:	8b 07                	mov    (%rdi),%eax
  10058b:	83 f8 2f             	cmp    $0x2f,%eax
  10058e:	77 1c                	ja     1005ac <printer_vprintf+0x325>
  100590:	89 c2                	mov    %eax,%edx
  100592:	48 03 57 10          	add    0x10(%rdi),%rdx
  100596:	83 c0 08             	add    $0x8,%eax
  100599:	89 07                	mov    %eax,(%rdi)
  10059b:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10059e:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1005a5:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1005aa:	eb c3                	jmp    10056f <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1005ac:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005b0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005b4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005b8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005bc:	eb dd                	jmp    10059b <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1005be:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005c2:	8b 01                	mov    (%rcx),%eax
  1005c4:	83 f8 2f             	cmp    $0x2f,%eax
  1005c7:	0f 87 a5 01 00 00    	ja     100772 <printer_vprintf+0x4eb>
  1005cd:	89 c2                	mov    %eax,%edx
  1005cf:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005d3:	83 c0 08             	add    $0x8,%eax
  1005d6:	89 01                	mov    %eax,(%rcx)
  1005d8:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1005db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1005e1:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1005e4:	83 e0 20             	and    $0x20,%eax
  1005e7:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1005ea:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1005f0:	0f 85 21 02 00 00    	jne    100817 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1005f6:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1005f9:	89 45 88             	mov    %eax,-0x78(%rbp)
  1005fc:	83 e0 60             	and    $0x60,%eax
  1005ff:	83 f8 60             	cmp    $0x60,%eax
  100602:	0f 84 54 02 00 00    	je     10085c <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100608:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10060b:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  10060e:	48 c7 45 a0 48 15 10 	movq   $0x101548,-0x60(%rbp)
  100615:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100616:	83 f8 21             	cmp    $0x21,%eax
  100619:	0f 84 79 02 00 00    	je     100898 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  10061f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100622:	89 f8                	mov    %edi,%eax
  100624:	f7 d0                	not    %eax
  100626:	c1 e8 1f             	shr    $0x1f,%eax
  100629:	89 45 84             	mov    %eax,-0x7c(%rbp)
  10062c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100630:	0f 85 9e 02 00 00    	jne    1008d4 <printer_vprintf+0x64d>
  100636:	84 c0                	test   %al,%al
  100638:	0f 84 96 02 00 00    	je     1008d4 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  10063e:	48 63 f7             	movslq %edi,%rsi
  100641:	4c 89 e7             	mov    %r12,%rdi
  100644:	e8 63 fb ff ff       	callq  1001ac <strnlen>
  100649:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  10064c:	8b 45 88             	mov    -0x78(%rbp),%eax
  10064f:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100652:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100659:	83 f8 22             	cmp    $0x22,%eax
  10065c:	0f 84 aa 02 00 00    	je     10090c <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100662:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100666:	e8 26 fb ff ff       	callq  100191 <strlen>
  10066b:	8b 55 9c             	mov    -0x64(%rbp),%edx
  10066e:	03 55 98             	add    -0x68(%rbp),%edx
  100671:	44 89 e9             	mov    %r13d,%ecx
  100674:	29 d1                	sub    %edx,%ecx
  100676:	29 c1                	sub    %eax,%ecx
  100678:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  10067b:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10067e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100682:	75 2d                	jne    1006b1 <printer_vprintf+0x42a>
  100684:	85 c9                	test   %ecx,%ecx
  100686:	7e 29                	jle    1006b1 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  100688:	44 89 fa             	mov    %r15d,%edx
  10068b:	be 20 00 00 00       	mov    $0x20,%esi
  100690:	4c 89 f7             	mov    %r14,%rdi
  100693:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100696:	41 83 ed 01          	sub    $0x1,%r13d
  10069a:	45 85 ed             	test   %r13d,%r13d
  10069d:	7f e9                	jg     100688 <printer_vprintf+0x401>
  10069f:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1006a2:	85 ff                	test   %edi,%edi
  1006a4:	b8 01 00 00 00       	mov    $0x1,%eax
  1006a9:	0f 4f c7             	cmovg  %edi,%eax
  1006ac:	29 c7                	sub    %eax,%edi
  1006ae:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1006b1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1006b5:	0f b6 07             	movzbl (%rdi),%eax
  1006b8:	84 c0                	test   %al,%al
  1006ba:	74 22                	je     1006de <printer_vprintf+0x457>
  1006bc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1006c0:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1006c3:	0f b6 f0             	movzbl %al,%esi
  1006c6:	44 89 fa             	mov    %r15d,%edx
  1006c9:	4c 89 f7             	mov    %r14,%rdi
  1006cc:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1006cf:	48 83 c3 01          	add    $0x1,%rbx
  1006d3:	0f b6 03             	movzbl (%rbx),%eax
  1006d6:	84 c0                	test   %al,%al
  1006d8:	75 e9                	jne    1006c3 <printer_vprintf+0x43c>
  1006da:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1006de:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1006e1:	85 c0                	test   %eax,%eax
  1006e3:	7e 1d                	jle    100702 <printer_vprintf+0x47b>
  1006e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1006e9:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1006eb:	44 89 fa             	mov    %r15d,%edx
  1006ee:	be 30 00 00 00       	mov    $0x30,%esi
  1006f3:	4c 89 f7             	mov    %r14,%rdi
  1006f6:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1006f9:	83 eb 01             	sub    $0x1,%ebx
  1006fc:	75 ed                	jne    1006eb <printer_vprintf+0x464>
  1006fe:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  100702:	8b 45 98             	mov    -0x68(%rbp),%eax
  100705:	85 c0                	test   %eax,%eax
  100707:	7e 27                	jle    100730 <printer_vprintf+0x4a9>
  100709:	89 c0                	mov    %eax,%eax
  10070b:	4c 01 e0             	add    %r12,%rax
  10070e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100712:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  100715:	41 0f b6 34 24       	movzbl (%r12),%esi
  10071a:	44 89 fa             	mov    %r15d,%edx
  10071d:	4c 89 f7             	mov    %r14,%rdi
  100720:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  100723:	49 83 c4 01          	add    $0x1,%r12
  100727:	49 39 dc             	cmp    %rbx,%r12
  10072a:	75 e9                	jne    100715 <printer_vprintf+0x48e>
  10072c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  100730:	45 85 ed             	test   %r13d,%r13d
  100733:	7e 14                	jle    100749 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  100735:	44 89 fa             	mov    %r15d,%edx
  100738:	be 20 00 00 00       	mov    $0x20,%esi
  10073d:	4c 89 f7             	mov    %r14,%rdi
  100740:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  100743:	41 83 ed 01          	sub    $0x1,%r13d
  100747:	75 ec                	jne    100735 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100749:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  10074d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100751:	84 c0                	test   %al,%al
  100753:	0f 84 fe 01 00 00    	je     100957 <printer_vprintf+0x6d0>
        if (*format != '%') {
  100759:	3c 25                	cmp    $0x25,%al
  10075b:	0f 84 54 fb ff ff    	je     1002b5 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100761:	0f b6 f0             	movzbl %al,%esi
  100764:	44 89 fa             	mov    %r15d,%edx
  100767:	4c 89 f7             	mov    %r14,%rdi
  10076a:	41 ff 16             	callq  *(%r14)
            continue;
  10076d:	4c 89 e3             	mov    %r12,%rbx
  100770:	eb d7                	jmp    100749 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100772:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100776:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10077a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10077e:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100782:	e9 51 fe ff ff       	jmpq   1005d8 <printer_vprintf+0x351>
            color = va_arg(val, int);
  100787:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10078b:	8b 07                	mov    (%rdi),%eax
  10078d:	83 f8 2f             	cmp    $0x2f,%eax
  100790:	77 10                	ja     1007a2 <printer_vprintf+0x51b>
  100792:	89 c2                	mov    %eax,%edx
  100794:	48 03 57 10          	add    0x10(%rdi),%rdx
  100798:	83 c0 08             	add    $0x8,%eax
  10079b:	89 07                	mov    %eax,(%rdi)
  10079d:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1007a0:	eb a7                	jmp    100749 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1007a2:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007a6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1007aa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007ae:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1007b2:	eb e9                	jmp    10079d <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1007b4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007b8:	8b 01                	mov    (%rcx),%eax
  1007ba:	83 f8 2f             	cmp    $0x2f,%eax
  1007bd:	77 23                	ja     1007e2 <printer_vprintf+0x55b>
  1007bf:	89 c2                	mov    %eax,%edx
  1007c1:	48 03 51 10          	add    0x10(%rcx),%rdx
  1007c5:	83 c0 08             	add    $0x8,%eax
  1007c8:	89 01                	mov    %eax,(%rcx)
  1007ca:	8b 02                	mov    (%rdx),%eax
  1007cc:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1007cf:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1007d3:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1007d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1007dd:	e9 ff fd ff ff       	jmpq   1005e1 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  1007e2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007e6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1007ea:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007ee:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1007f2:	eb d6                	jmp    1007ca <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  1007f4:	84 d2                	test   %dl,%dl
  1007f6:	0f 85 39 01 00 00    	jne    100935 <printer_vprintf+0x6ae>
  1007fc:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  100800:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100804:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100808:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10080c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100812:	e9 ca fd ff ff       	jmpq   1005e1 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  100817:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  10081d:	bf 30 17 10 00       	mov    $0x101730,%edi
        if (flags & FLAG_NUMERIC) {
  100822:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100827:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  10082b:	4c 89 c1             	mov    %r8,%rcx
  10082e:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100832:	48 63 f6             	movslq %esi,%rsi
  100835:	49 83 ec 01          	sub    $0x1,%r12
  100839:	48 89 c8             	mov    %rcx,%rax
  10083c:	ba 00 00 00 00       	mov    $0x0,%edx
  100841:	48 f7 f6             	div    %rsi
  100844:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100848:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  10084c:	48 89 ca             	mov    %rcx,%rdx
  10084f:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100852:	48 39 d6             	cmp    %rdx,%rsi
  100855:	76 de                	jbe    100835 <printer_vprintf+0x5ae>
  100857:	e9 9a fd ff ff       	jmpq   1005f6 <printer_vprintf+0x36f>
                prefix = "-";
  10085c:	48 c7 45 a0 45 15 10 	movq   $0x101545,-0x60(%rbp)
  100863:	00 
            if (flags & FLAG_NEGATIVE) {
  100864:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100867:	a8 80                	test   $0x80,%al
  100869:	0f 85 b0 fd ff ff    	jne    10061f <printer_vprintf+0x398>
                prefix = "+";
  10086f:	48 c7 45 a0 40 15 10 	movq   $0x101540,-0x60(%rbp)
  100876:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100877:	a8 10                	test   $0x10,%al
  100879:	0f 85 a0 fd ff ff    	jne    10061f <printer_vprintf+0x398>
                prefix = " ";
  10087f:	a8 08                	test   $0x8,%al
  100881:	ba 48 15 10 00       	mov    $0x101548,%edx
  100886:	b8 47 15 10 00       	mov    $0x101547,%eax
  10088b:	48 0f 44 c2          	cmove  %rdx,%rax
  10088f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100893:	e9 87 fd ff ff       	jmpq   10061f <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  100898:	41 8d 41 10          	lea    0x10(%r9),%eax
  10089c:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1008a1:	0f 85 78 fd ff ff    	jne    10061f <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1008a7:	4d 85 c0             	test   %r8,%r8
  1008aa:	75 0d                	jne    1008b9 <printer_vprintf+0x632>
  1008ac:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1008b3:	0f 84 66 fd ff ff    	je     10061f <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1008b9:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1008bd:	ba 49 15 10 00       	mov    $0x101549,%edx
  1008c2:	b8 42 15 10 00       	mov    $0x101542,%eax
  1008c7:	48 0f 44 c2          	cmove  %rdx,%rax
  1008cb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008cf:	e9 4b fd ff ff       	jmpq   10061f <printer_vprintf+0x398>
            len = strlen(data);
  1008d4:	4c 89 e7             	mov    %r12,%rdi
  1008d7:	e8 b5 f8 ff ff       	callq  100191 <strlen>
  1008dc:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1008df:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1008e3:	0f 84 63 fd ff ff    	je     10064c <printer_vprintf+0x3c5>
  1008e9:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1008ed:	0f 84 59 fd ff ff    	je     10064c <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  1008f3:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1008f6:	89 ca                	mov    %ecx,%edx
  1008f8:	29 c2                	sub    %eax,%edx
  1008fa:	39 c1                	cmp    %eax,%ecx
  1008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  100901:	0f 4e d0             	cmovle %eax,%edx
  100904:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100907:	e9 56 fd ff ff       	jmpq   100662 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  10090c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100910:	e8 7c f8 ff ff       	callq  100191 <strlen>
  100915:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100918:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  10091b:	44 89 e9             	mov    %r13d,%ecx
  10091e:	29 f9                	sub    %edi,%ecx
  100920:	29 c1                	sub    %eax,%ecx
  100922:	44 39 ea             	cmp    %r13d,%edx
  100925:	b8 00 00 00 00       	mov    $0x0,%eax
  10092a:	0f 4d c8             	cmovge %eax,%ecx
  10092d:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  100930:	e9 2d fd ff ff       	jmpq   100662 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  100935:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100938:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  10093c:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100946:	e9 96 fc ff ff       	jmpq   1005e1 <printer_vprintf+0x35a>
        int flags = 0;
  10094b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100952:	e9 b0 f9 ff ff       	jmpq   100307 <printer_vprintf+0x80>
}
  100957:	48 83 c4 58          	add    $0x58,%rsp
  10095b:	5b                   	pop    %rbx
  10095c:	41 5c                	pop    %r12
  10095e:	41 5d                	pop    %r13
  100960:	41 5e                	pop    %r14
  100962:	41 5f                	pop    %r15
  100964:	5d                   	pop    %rbp
  100965:	c3                   	retq   

0000000000100966 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100966:	55                   	push   %rbp
  100967:	48 89 e5             	mov    %rsp,%rbp
  10096a:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  10096e:	48 c7 45 f0 71 00 10 	movq   $0x100071,-0x10(%rbp)
  100975:	00 
        cpos = 0;
  100976:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  10097c:	b8 00 00 00 00       	mov    $0x0,%eax
  100981:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100984:	48 63 ff             	movslq %edi,%rdi
  100987:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  10098e:	00 
  10098f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100993:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100997:	e8 eb f8 ff ff       	callq  100287 <printer_vprintf>
    return cp.cursor - console;
  10099c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1009a0:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1009a6:	48 d1 f8             	sar    %rax
}
  1009a9:	c9                   	leaveq 
  1009aa:	c3                   	retq   

00000000001009ab <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1009ab:	55                   	push   %rbp
  1009ac:	48 89 e5             	mov    %rsp,%rbp
  1009af:	48 83 ec 50          	sub    $0x50,%rsp
  1009b3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1009b7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1009bb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1009bf:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1009c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1009ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1009ce:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1009d2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1009d6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1009da:	e8 87 ff ff ff       	callq  100966 <console_vprintf>
}
  1009df:	c9                   	leaveq 
  1009e0:	c3                   	retq   

00000000001009e1 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1009e1:	55                   	push   %rbp
  1009e2:	48 89 e5             	mov    %rsp,%rbp
  1009e5:	53                   	push   %rbx
  1009e6:	48 83 ec 28          	sub    $0x28,%rsp
  1009ea:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1009ed:	48 c7 45 d8 f7 00 10 	movq   $0x1000f7,-0x28(%rbp)
  1009f4:	00 
    sp.s = s;
  1009f5:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1009f9:	48 85 f6             	test   %rsi,%rsi
  1009fc:	75 0b                	jne    100a09 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1009fe:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100a01:	29 d8                	sub    %ebx,%eax
}
  100a03:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100a07:	c9                   	leaveq 
  100a08:	c3                   	retq   
        sp.end = s + size - 1;
  100a09:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100a0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100a12:	be 00 00 00 00       	mov    $0x0,%esi
  100a17:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100a1b:	e8 67 f8 ff ff       	callq  100287 <printer_vprintf>
        *sp.s = 0;
  100a20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100a24:	c6 00 00             	movb   $0x0,(%rax)
  100a27:	eb d5                	jmp    1009fe <vsnprintf+0x1d>

0000000000100a29 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100a29:	55                   	push   %rbp
  100a2a:	48 89 e5             	mov    %rsp,%rbp
  100a2d:	48 83 ec 50          	sub    $0x50,%rsp
  100a31:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a35:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a39:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100a3d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a44:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a4c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a50:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100a54:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a58:	e8 84 ff ff ff       	callq  1009e1 <vsnprintf>
    va_end(val);
    return n;
}
  100a5d:	c9                   	leaveq 
  100a5e:	c3                   	retq   

0000000000100a5f <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a5f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100a64:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100a69:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a6e:	48 83 c0 02          	add    $0x2,%rax
  100a72:	48 39 d0             	cmp    %rdx,%rax
  100a75:	75 f2                	jne    100a69 <console_clear+0xa>
    }
    cursorpos = 0;
  100a77:	c7 05 7b 85 fb ff 00 	movl   $0x0,-0x47a85(%rip)        # b8ffc <cursorpos>
  100a7e:	00 00 00 
}
  100a81:	c3                   	retq   

0000000000100a82 <cmp_ptr_ascending>:
	}
    }
}

int cmp_ptr_ascending(const void *a, const void *b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  100a82:	48 8b 07             	mov    (%rdi),%rax
  100a85:	2b 06                	sub    (%rsi),%eax
}
  100a87:	c3                   	retq   

0000000000100a88 <cmp_simple_descending>:
int cmp_simple_descending(const void *a, const void *b) {
    return *((long *) b) - *((long *) a);
  100a88:	48 8b 06             	mov    (%rsi),%rax
  100a8b:	2b 07                	sub    (%rdi),%eax
}
  100a8d:	c3                   	retq   

0000000000100a8e <cmp_ptrs_by_size_descending>:
int cmp_ptrs_by_size_descending(const void *a, const void *b) {
    void *ptr_a = *((void **) a);
    void *ptr_b = *((void **) b);
    alloc_header *header_a = (alloc_header *) ((uintptr_t) ptr_a - ALLOC_HEADER_SIZE);
    alloc_header *header_b = (alloc_header *) ((uintptr_t) ptr_b - ALLOC_HEADER_SIZE);
    return header_b->sz - header_a->sz;
  100a8e:	48 8b 06             	mov    (%rsi),%rax
  100a91:	48 8b 40 f8          	mov    -0x8(%rax),%rax
  100a95:	48 8b 17             	mov    (%rdi),%rdx
  100a98:	2b 42 f8             	sub    -0x8(%rdx),%eax
}
  100a9b:	c3                   	retq   

0000000000100a9c <__quicksort>:
{
  100a9c:	55                   	push   %rbp
  100a9d:	48 89 e5             	mov    %rsp,%rbp
  100aa0:	41 57                	push   %r15
  100aa2:	41 56                	push   %r14
  100aa4:	41 55                	push   %r13
  100aa6:	41 54                	push   %r12
  100aa8:	53                   	push   %rbx
  100aa9:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  100ab0:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  100ab7:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  100abe:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  100ac5:	48 85 f6             	test   %rsi,%rsi
  100ac8:	0f 84 94 03 00 00    	je     100e62 <__quicksort+0x3c6>
  100ace:	48 89 f0             	mov    %rsi,%rax
  100ad1:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  100ad4:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  100adb:	00 
  100adc:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  100ae3:	48 83 fe 04          	cmp    $0x4,%rsi
  100ae7:	0f 86 bd 02 00 00    	jbe    100daa <__quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  100aed:	48 83 e8 01          	sub    $0x1,%rax
  100af1:	48 0f af c2          	imul   %rdx,%rax
  100af5:	48 01 f8             	add    %rdi,%rax
  100af8:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  100aff:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  100b06:	00 00 00 00 
  100b0a:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  100b11:	00 00 00 00 
	char *lo = base_ptr;
  100b15:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  100b1c:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  100b23:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  100b2a:	48 f7 da             	neg    %rdx
  100b2d:	49 89 d7             	mov    %rdx,%r15
  100b30:	e9 8c 01 00 00       	jmpq   100cc1 <__quicksort+0x225>
  100b35:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b3c:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100b41:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100b48:	4c 89 e8             	mov    %r13,%rax
  100b4b:	0f b6 08             	movzbl (%rax),%ecx
  100b4e:	48 83 c0 01          	add    $0x1,%rax
  100b52:	0f b6 32             	movzbl (%rdx),%esi
  100b55:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100b59:	48 83 c2 01          	add    $0x1,%rdx
  100b5d:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100b60:	48 39 c7             	cmp    %rax,%rdi
  100b63:	75 e6                	jne    100b4b <__quicksort+0xaf>
  100b65:	e9 92 01 00 00       	jmpq   100cfc <__quicksort+0x260>
  100b6a:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b71:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100b76:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  100b7d:	4c 89 e8             	mov    %r13,%rax
  100b80:	0f b6 08             	movzbl (%rax),%ecx
  100b83:	48 83 c0 01          	add    $0x1,%rax
  100b87:	0f b6 32             	movzbl (%rdx),%esi
  100b8a:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100b8e:	48 83 c2 01          	add    $0x1,%rdx
  100b92:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100b95:	49 39 c4             	cmp    %rax,%r12
  100b98:	75 e6                	jne    100b80 <__quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100b9a:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  100ba1:	4c 89 ef             	mov    %r13,%rdi
  100ba4:	ff d3                	callq  *%rbx
  100ba6:	85 c0                	test   %eax,%eax
  100ba8:	0f 89 62 01 00 00    	jns    100d10 <__quicksort+0x274>
  100bae:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100bb5:	4c 89 e8             	mov    %r13,%rax
  100bb8:	0f b6 08             	movzbl (%rax),%ecx
  100bbb:	48 83 c0 01          	add    $0x1,%rax
  100bbf:	0f b6 32             	movzbl (%rdx),%esi
  100bc2:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100bc6:	48 83 c2 01          	add    $0x1,%rdx
  100bca:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100bcd:	49 39 c4             	cmp    %rax,%r12
  100bd0:	75 e6                	jne    100bb8 <__quicksort+0x11c>
jump_over:;
  100bd2:	e9 39 01 00 00       	jmpq   100d10 <__quicksort+0x274>
		  right_ptr -= size;
  100bd7:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  100bda:	4c 89 e6             	mov    %r12,%rsi
  100bdd:	4c 89 ef             	mov    %r13,%rdi
  100be0:	ff d3                	callq  *%rbx
  100be2:	85 c0                	test   %eax,%eax
  100be4:	78 f1                	js     100bd7 <__quicksort+0x13b>
	      if (left_ptr < right_ptr)
  100be6:	4d 39 e6             	cmp    %r12,%r14
  100be9:	72 1c                	jb     100c07 <__quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  100beb:	74 5e                	je     100c4b <__quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  100bed:	4d 39 e6             	cmp    %r12,%r14
  100bf0:	77 63                	ja     100c55 <__quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  100bf2:	4c 89 ee             	mov    %r13,%rsi
  100bf5:	4c 89 f7             	mov    %r14,%rdi
  100bf8:	ff d3                	callq  *%rbx
  100bfa:	85 c0                	test   %eax,%eax
  100bfc:	79 dc                	jns    100bda <__quicksort+0x13e>
		  left_ptr += size;
  100bfe:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100c05:	eb eb                	jmp    100bf2 <__quicksort+0x156>
  100c07:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100c0e:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  100c12:	4c 89 e2             	mov    %r12,%rdx
  100c15:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  100c18:	0f b6 08             	movzbl (%rax),%ecx
  100c1b:	48 83 c0 01          	add    $0x1,%rax
  100c1f:	0f b6 32             	movzbl (%rdx),%esi
  100c22:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100c26:	48 83 c2 01          	add    $0x1,%rdx
  100c2a:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100c2d:	48 39 f8             	cmp    %rdi,%rax
  100c30:	75 e6                	jne    100c18 <__quicksort+0x17c>
		  if (mid == left_ptr)
  100c32:	4d 39 ee             	cmp    %r13,%r14
  100c35:	74 0f                	je     100c46 <__quicksort+0x1aa>
		  else if (mid == right_ptr)
  100c37:	4d 39 ec             	cmp    %r13,%r12
  100c3a:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  100c3e:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  100c41:	49 89 fe             	mov    %rdi,%r14
  100c44:	eb a7                	jmp    100bed <__quicksort+0x151>
  100c46:	4d 89 e5             	mov    %r12,%r13
  100c49:	eb f3                	jmp    100c3e <__quicksort+0x1a2>
		  left_ptr += size;
  100c4b:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  100c52:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  100c55:	4c 89 e0             	mov    %r12,%rax
  100c58:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  100c5f:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  100c66:	48 39 f8             	cmp    %rdi,%rax
  100c69:	0f 87 bf 00 00 00    	ja     100d2e <__quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c6f:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100c76:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  100c79:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c80:	48 39 f8             	cmp    %rdi,%rax
  100c83:	77 28                	ja     100cad <__quicksort+0x211>
		  POP (lo, hi);
  100c85:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100c8c:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  100c90:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  100c97:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  100c9b:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  100ca2:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  100ca6:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  100cad:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  100cb4:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  100cbb:	0f 86 e9 00 00 00    	jbe    100daa <__quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  100cc1:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100cc8:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100ccf:	48 29 f8             	sub    %rdi,%rax
  100cd2:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  100cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  100cde:	48 f7 f1             	div    %rcx
  100ce1:	48 d1 e8             	shr    %rax
  100ce4:	48 0f af c1          	imul   %rcx,%rax
  100ce8:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100cec:	48 89 fe             	mov    %rdi,%rsi
  100cef:	4c 89 ef             	mov    %r13,%rdi
  100cf2:	ff d3                	callq  *%rbx
  100cf4:	85 c0                	test   %eax,%eax
  100cf6:	0f 88 39 fe ff ff    	js     100b35 <__quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100cfc:	4c 89 ee             	mov    %r13,%rsi
  100cff:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100d06:	ff d3                	callq  *%rbx
  100d08:	85 c0                	test   %eax,%eax
  100d0a:	0f 88 5a fe ff ff    	js     100b6a <__quicksort+0xce>
	  left_ptr  = lo + size;
  100d10:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  100d17:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  100d1e:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100d25:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  100d29:	e9 c4 fe ff ff       	jmpq   100bf2 <__quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  100d2e:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  100d35:	4c 29 f2             	sub    %r14,%rdx
  100d38:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  100d3f:	76 5d                	jbe    100d9e <__quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  100d41:	48 39 d0             	cmp    %rdx,%rax
  100d44:	7e 2c                	jle    100d72 <__quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  100d46:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d4d:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100d54:	48 89 38             	mov    %rdi,(%rax)
  100d57:	4c 89 60 08          	mov    %r12,0x8(%rax)
  100d5b:	48 83 c0 10          	add    $0x10,%rax
  100d5f:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  100d66:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  100d6d:	e9 3b ff ff ff       	jmpq   100cad <__quicksort+0x211>
	      PUSH (left_ptr, hi);
  100d72:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d79:	4c 89 30             	mov    %r14,(%rax)
  100d7c:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100d83:	48 89 78 08          	mov    %rdi,0x8(%rax)
  100d87:	48 83 c0 10          	add    $0x10,%rax
  100d8b:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  100d92:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100d99:	e9 0f ff ff ff       	jmpq   100cad <__quicksort+0x211>
	      hi = right_ptr;
  100d9e:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100da5:	e9 03 ff ff ff       	jmpq   100cad <__quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  100daa:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  100db1:	49 83 ef 01          	sub    $0x1,%r15
  100db5:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  100dbc:	4c 0f af ff          	imul   %rdi,%r15
  100dc0:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  100dc7:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  100dca:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  100dd1:	4c 01 e8             	add    %r13,%rax
  100dd4:	49 39 c7             	cmp    %rax,%r15
  100dd7:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100ddb:	4d 89 ec             	mov    %r13,%r12
  100dde:	49 01 fc             	add    %rdi,%r12
  100de1:	4c 39 e0             	cmp    %r12,%rax
  100de4:	72 66                	jb     100e4c <__quicksort+0x3b0>
  100de6:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  100de9:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100df0:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100df3:	4c 89 ee             	mov    %r13,%rsi
  100df6:	4c 89 f7             	mov    %r14,%rdi
  100df9:	ff d3                	callq  *%rbx
  100dfb:	85 c0                	test   %eax,%eax
  100dfd:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100e01:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100e08:	4d 39 f4             	cmp    %r14,%r12
  100e0b:	73 e6                	jae    100df3 <__quicksort+0x357>
  100e0d:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  100e14:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e1b:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  100e20:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  100e27:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  100e2e:	74 1c                	je     100e4c <__quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  100e30:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  100e35:	49 83 c5 01          	add    $0x1,%r13
  100e39:	0f b6 30             	movzbl (%rax),%esi
  100e3c:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  100e40:	48 83 c0 01          	add    $0x1,%rax
  100e44:	88 50 ff             	mov    %dl,-0x1(%rax)
  100e47:	49 39 cd             	cmp    %rcx,%r13
  100e4a:	75 e4                	jne    100e30 <__quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  100e4c:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e53:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  100e57:	48 f7 d8             	neg    %rax
  100e5a:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  100e5d:	4d 39 f7             	cmp    %r14,%r15
  100e60:	73 15                	jae    100e77 <__quicksort+0x3db>
}
  100e62:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  100e69:	5b                   	pop    %rbx
  100e6a:	41 5c                	pop    %r12
  100e6c:	41 5d                	pop    %r13
  100e6e:	41 5e                	pop    %r14
  100e70:	41 5f                	pop    %r15
  100e72:	5d                   	pop    %rbp
  100e73:	c3                   	retq   
		tmp_ptr -= size;
  100e74:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100e77:	4c 89 e6             	mov    %r12,%rsi
  100e7a:	4c 89 f7             	mov    %r14,%rdi
  100e7d:	ff d3                	callq  *%rbx
  100e7f:	85 c0                	test   %eax,%eax
  100e81:	78 f1                	js     100e74 <__quicksort+0x3d8>
	    tmp_ptr += size;
  100e83:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e8a:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  100e8e:	4c 39 f6             	cmp    %r14,%rsi
  100e91:	75 17                	jne    100eaa <__quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  100e93:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e9a:	4c 01 f0             	add    %r14,%rax
  100e9d:	4d 89 f4             	mov    %r14,%r12
  100ea0:	49 39 c7             	cmp    %rax,%r15
  100ea3:	72 bd                	jb     100e62 <__quicksort+0x3c6>
  100ea5:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100ea8:	eb cd                	jmp    100e77 <__quicksort+0x3db>
		while (--trav >= run_ptr)
  100eaa:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  100eaf:	4c 39 f7             	cmp    %r14,%rdi
  100eb2:	72 df                	jb     100e93 <__quicksort+0x3f7>
  100eb4:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  100eb8:	4d 89 c2             	mov    %r8,%r10
  100ebb:	eb 13                	jmp    100ed0 <__quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ebd:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  100ec0:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  100ec3:	48 83 ef 01          	sub    $0x1,%rdi
  100ec7:	49 83 e8 01          	sub    $0x1,%r8
  100ecb:	49 39 fa             	cmp    %rdi,%r10
  100ece:	74 c3                	je     100e93 <__quicksort+0x3f7>
		    char c = *trav;
  100ed0:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ed4:	4c 89 c0             	mov    %r8,%rax
  100ed7:	4c 39 c6             	cmp    %r8,%rsi
  100eda:	77 e1                	ja     100ebd <__quicksort+0x421>
  100edc:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  100edf:	0f b6 08             	movzbl (%rax),%ecx
  100ee2:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ee4:	48 89 c1             	mov    %rax,%rcx
  100ee7:	4c 01 e8             	add    %r13,%rax
  100eea:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  100ef1:	48 39 c6             	cmp    %rax,%rsi
  100ef4:	76 e9                	jbe    100edf <__quicksort+0x443>
  100ef6:	eb c8                	jmp    100ec0 <__quicksort+0x424>

0000000000100ef8 <append_free_list_node>:
int alloc_list_length = 0;

int break_made = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  100ef8:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  100eff:	00 
    node->prev = NULL;
  100f00:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  100f07:	48 83 3d 31 11 00 00 	cmpq   $0x0,0x1131(%rip)        # 102040 <free_list_head>
  100f0e:	00 
  100f0f:	74 1d                	je     100f2e <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  100f11:	48 8b 05 20 11 00 00 	mov    0x1120(%rip),%rax        # 102038 <free_list_tail>
  100f18:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  100f1c:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  100f1f:	48 89 3d 12 11 00 00 	mov    %rdi,0x1112(%rip)        # 102038 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  100f26:	83 05 03 11 00 00 01 	addl   $0x1,0x1103(%rip)        # 102030 <free_list_length>
}
  100f2d:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  100f2e:	48 83 3d 02 11 00 00 	cmpq   $0x0,0x1102(%rip)        # 102038 <free_list_tail>
  100f35:	00 
  100f36:	75 d9                	jne    100f11 <append_free_list_node+0x19>
        free_list_head = node;
  100f38:	48 89 3d 01 11 00 00 	mov    %rdi,0x1101(%rip)        # 102040 <free_list_head>
        free_list_tail = node;
  100f3f:	eb de                	jmp    100f1f <append_free_list_node+0x27>

0000000000100f41 <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  100f41:	48 39 3d f8 10 00 00 	cmp    %rdi,0x10f8(%rip)        # 102040 <free_list_head>
  100f48:	74 30                	je     100f7a <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  100f4a:	48 39 3d e7 10 00 00 	cmp    %rdi,0x10e7(%rip)        # 102038 <free_list_tail>
  100f51:	74 34                	je     100f87 <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  100f53:	48 8b 07             	mov    (%rdi),%rax
  100f56:	48 85 c0             	test   %rax,%rax
  100f59:	74 08                	je     100f63 <remove_free_list_node+0x22>
  100f5b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100f5f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  100f63:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100f67:	48 85 c0             	test   %rax,%rax
  100f6a:	74 06                	je     100f72 <remove_free_list_node+0x31>
  100f6c:	48 8b 17             	mov    (%rdi),%rdx
  100f6f:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  100f72:	83 2d b7 10 00 00 01 	subl   $0x1,0x10b7(%rip)        # 102030 <free_list_length>
}
  100f79:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  100f7a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100f7e:	48 89 05 bb 10 00 00 	mov    %rax,0x10bb(%rip)        # 102040 <free_list_head>
  100f85:	eb c3                	jmp    100f4a <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  100f87:	48 8b 07             	mov    (%rdi),%rax
  100f8a:	48 89 05 a7 10 00 00 	mov    %rax,0x10a7(%rip)        # 102038 <free_list_tail>
  100f91:	eb c0                	jmp    100f53 <remove_free_list_node+0x12>

0000000000100f93 <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  100f93:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  100f9a:	00 
    header->prev = NULL;
  100f9b:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  100fa2:	48 83 3d 7e 10 00 00 	cmpq   $0x0,0x107e(%rip)        # 102028 <alloc_list_head>
  100fa9:	00 
  100faa:	74 1d                	je     100fc9 <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  100fac:	48 8b 05 6d 10 00 00 	mov    0x106d(%rip),%rax        # 102020 <alloc_list_tail>
  100fb3:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  100fb7:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  100fba:	48 89 3d 5f 10 00 00 	mov    %rdi,0x105f(%rip)        # 102020 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  100fc1:	83 05 54 10 00 00 01 	addl   $0x1,0x1054(%rip)        # 10201c <alloc_list_length>
}
  100fc8:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  100fc9:	48 83 3d 4f 10 00 00 	cmpq   $0x0,0x104f(%rip)        # 102020 <alloc_list_tail>
  100fd0:	00 
  100fd1:	75 d9                	jne    100fac <append_alloc_list_node+0x19>
        alloc_list_head = header;
  100fd3:	48 89 3d 4e 10 00 00 	mov    %rdi,0x104e(%rip)        # 102028 <alloc_list_head>
        alloc_list_tail = header;
  100fda:	eb de                	jmp    100fba <append_alloc_list_node+0x27>

0000000000100fdc <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  100fdc:	48 39 3d 45 10 00 00 	cmp    %rdi,0x1045(%rip)        # 102028 <alloc_list_head>
  100fe3:	74 30                	je     101015 <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  100fe5:	48 39 3d 34 10 00 00 	cmp    %rdi,0x1034(%rip)        # 102020 <alloc_list_tail>
  100fec:	74 34                	je     101022 <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  100fee:	48 8b 07             	mov    (%rdi),%rax
  100ff1:	48 85 c0             	test   %rax,%rax
  100ff4:	74 08                	je     100ffe <remove_alloc_list_node+0x22>
  100ff6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100ffa:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  100ffe:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101002:	48 85 c0             	test   %rax,%rax
  101005:	74 06                	je     10100d <remove_alloc_list_node+0x31>
  101007:	48 8b 17             	mov    (%rdi),%rdx
  10100a:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  10100d:	83 2d 08 10 00 00 01 	subl   $0x1,0x1008(%rip)        # 10201c <alloc_list_length>
}
  101014:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  101015:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101019:	48 89 05 08 10 00 00 	mov    %rax,0x1008(%rip)        # 102028 <alloc_list_head>
  101020:	eb c3                	jmp    100fe5 <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  101022:	48 8b 07             	mov    (%rdi),%rax
  101025:	48 89 05 f4 0f 00 00 	mov    %rax,0xff4(%rip)        # 102020 <alloc_list_tail>
  10102c:	eb c0                	jmp    100fee <remove_alloc_list_node+0x12>

000000000010102e <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  10102e:	48 8b 05 0b 10 00 00 	mov    0x100b(%rip),%rax        # 102040 <free_list_head>
    while (ptr != NULL) {
  101035:	48 85 c0             	test   %rax,%rax
  101038:	74 13                	je     10104d <get_free_block+0x1f>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
  10103a:	48 83 c7 18          	add    $0x18,%rdi
  10103e:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  101042:	73 09                	jae    10104d <get_free_block+0x1f>
        ptr = ptr->next;
  101044:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL) {
  101048:	48 85 c0             	test   %rax,%rax
  10104b:	75 f1                	jne    10103e <get_free_block+0x10>
    }
    return NULL;
}
  10104d:	c3                   	retq   

000000000010104e <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  10104e:	55                   	push   %rbp
  10104f:	48 89 e5             	mov    %rsp,%rbp
  101052:	53                   	push   %rbx
  101053:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  101057:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  10105e:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  101065:	cc cc cc 
  101068:	48 89 d0             	mov    %rdx,%rax
  10106b:	48 f7 e1             	mul    %rcx
  10106e:	48 c1 ea 0f          	shr    $0xf,%rdx
  101072:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  101076:	48 c1 e7 0d          	shl    $0xd,%rdi
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  10107a:	cd 3a                	int    $0x3a
  10107c:	48 89 05 c5 0f 00 00 	mov    %rax,0xfc5(%rip)        # 102048 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  101083:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  101087:	74 18                	je     1010a1 <extend_heap+0x53>
  101089:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  10108c:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  101090:	48 89 c7             	mov    %rax,%rdi
  101093:	e8 60 fe ff ff       	callq  100ef8 <append_free_list_node>
    return node;
}
  101098:	48 89 d8             	mov    %rbx,%rax
  10109b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  10109f:	c9                   	leaveq 
  1010a0:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  1010a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  1010a6:	eb f0                	jmp    101098 <extend_heap+0x4a>

00000000001010a8 <contract_heap>:

void contract_heap(size_t sz) {
    size_t heap_contraction = -ROUNDUP(sz, BREAK_INCREMENT);
  1010a8:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  1010af:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  1010b6:	cc cc cc 
  1010b9:	48 89 d0             	mov    %rdx,%rax
  1010bc:	48 f7 e1             	mul    %rcx
  1010bf:	48 c1 ea 0f          	shr    $0xf,%rdx
  1010c3:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  1010c7:	48 c1 e7 0d          	shl    $0xd,%rdi
  1010cb:	48 f7 df             	neg    %rdi
  1010ce:	cd 3a                	int    $0x3a
  1010d0:	48 89 05 71 0f 00 00 	mov    %rax,0xf71(%rip)        # 102048 <result.0>
    void *start = sbrk(heap_contraction);
    if (start == (void *) -1) return;
  1010d7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1010db:	74 0e                	je     1010eb <contract_heap+0x43>
void contract_heap(size_t sz) {
  1010dd:	55                   	push   %rbp
  1010de:	48 89 e5             	mov    %rsp,%rbp
  1010e1:	48 89 c7             	mov    %rax,%rdi
    struct free_list_node *node = (struct free_list_node *) start;
    remove_free_list_node(node);
  1010e4:	e8 58 fe ff ff       	callq  100f41 <remove_free_list_node>
}
  1010e9:	5d                   	pop    %rbp
  1010ea:	c3                   	retq   
  1010eb:	c3                   	retq   

00000000001010ec <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  1010ec:	55                   	push   %rbp
  1010ed:	48 89 e5             	mov    %rsp,%rbp
  1010f0:	41 56                	push   %r14
  1010f2:	41 55                	push   %r13
  1010f4:	41 54                	push   %r12
  1010f6:	53                   	push   %rbx
  1010f7:	48 89 fb             	mov    %rdi,%rbx
    // find a free block
    free_list_node *free_block = get_free_block(sz);
  1010fa:	e8 2f ff ff ff       	callq  10102e <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  1010ff:	48 85 c0             	test   %rax,%rax
  101102:	74 57                	je     10115b <allocate_to_free_block+0x6f>
  101104:	49 89 c4             	mov    %rax,%r12

    // remove that free block
    uintptr_t block_addr = (uintptr_t) free_block;
  101107:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  10110a:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  10110e:	48 89 c7             	mov    %rax,%rdi
  101111:	e8 2b fe ff ff       	callq  100f41 <remove_free_list_node>

    // replace it with an alloc_header
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  101116:	48 8d 7b 07          	lea    0x7(%rbx),%rdi
  10111a:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  10111e:	49 89 7c 24 10       	mov    %rdi,0x10(%r12)

    // leftover stuff
    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  101123:	48 8d 47 18          	lea    0x18(%rdi),%rax
    size_t leftover = block_size - data_size;
  101127:	49 29 c5             	sub    %rax,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  10112a:	49 83 fd 17          	cmp    $0x17,%r13
  10112e:	77 1c                	ja     10114c <allocate_to_free_block+0x60>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  101130:	4c 01 ef             	add    %r13,%rdi
  101133:	49 89 7c 24 10       	mov    %rdi,0x10(%r12)

    append_alloc_list_node(header);
  101138:	4c 89 e7             	mov    %r12,%rdi
  10113b:	e8 53 fe ff ff       	callq  100f93 <append_alloc_list_node>
    return block_addr;
}
  101140:	4c 89 f0             	mov    %r14,%rax
  101143:	5b                   	pop    %rbx
  101144:	41 5c                	pop    %r12
  101146:	41 5d                	pop    %r13
  101148:	41 5e                	pop    %r14
  10114a:	5d                   	pop    %rbp
  10114b:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  10114c:	49 8d 3c 04          	lea    (%r12,%rax,1),%rdi
        node->sz = leftover;
  101150:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  101154:	e8 9f fd ff ff       	callq  100ef8 <append_free_list_node>
  101159:	eb dd                	jmp    101138 <allocate_to_free_block+0x4c>
    if (free_block == NULL) return (uintptr_t) -1;
  10115b:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  101162:	eb dc                	jmp    101140 <allocate_to_free_block+0x54>

0000000000101164 <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  101164:	b8 00 00 00 00       	mov    $0x0,%eax
  101169:	48 85 ff             	test   %rdi,%rdi
  10116c:	74 46                	je     1011b4 <malloc+0x50>
void *malloc(uint64_t sz) {
  10116e:	55                   	push   %rbp
  10116f:	48 89 e5             	mov    %rsp,%rbp
  101172:	53                   	push   %rbx
  101173:	48 83 ec 08          	sub    $0x8,%rsp
  101177:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  10117a:	e8 6d ff ff ff       	callq  1010ec <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  10117f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  101183:	75 25                	jne    1011aa <malloc+0x46>
        if (extend_heap(sz) == NULL) return NULL;
  101185:	48 89 df             	mov    %rbx,%rdi
  101188:	e8 c1 fe ff ff       	callq  10104e <extend_heap>
  10118d:	48 85 c0             	test   %rax,%rax
  101190:	74 1c                	je     1011ae <malloc+0x4a>
        break_made = 1;
  101192:	c7 05 7c 0e 00 00 01 	movl   $0x1,0xe7c(%rip)        # 102018 <break_made>
  101199:	00 00 00 
        block_addr = allocate_to_free_block(sz);
  10119c:	48 89 df             	mov    %rbx,%rdi
  10119f:	e8 48 ff ff ff       	callq  1010ec <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1011a4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1011a8:	74 db                	je     101185 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  1011aa:	48 83 c0 18          	add    $0x18,%rax
}
  1011ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1011b2:	c9                   	leaveq 
  1011b3:	c3                   	retq   
  1011b4:	c3                   	retq   

00000000001011b5 <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  1011b5:	48 89 f9             	mov    %rdi,%rcx
  1011b8:	48 0f af ce          	imul   %rsi,%rcx
  1011bc:	48 89 c8             	mov    %rcx,%rax
  1011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  1011c4:	48 f7 f7             	div    %rdi
  1011c7:	ba 01 00 00 00       	mov    $0x1,%edx
  1011cc:	48 39 f0             	cmp    %rsi,%rax
  1011cf:	74 03                	je     1011d4 <overflow+0x1f>
}
  1011d1:	89 d0                	mov    %edx,%eax
  1011d3:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  1011d4:	48 89 c8             	mov    %rcx,%rax
  1011d7:	ba 00 00 00 00       	mov    $0x0,%edx
  1011dc:	48 f7 f6             	div    %rsi
  1011df:	48 39 f8             	cmp    %rdi,%rax
  1011e2:	0f 95 c2             	setne  %dl
  1011e5:	0f b6 d2             	movzbl %dl,%edx
  1011e8:	eb e7                	jmp    1011d1 <overflow+0x1c>

00000000001011ea <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  1011ea:	55                   	push   %rbp
  1011eb:	48 89 e5             	mov    %rsp,%rbp
  1011ee:	41 55                	push   %r13
  1011f0:	41 54                	push   %r12
  1011f2:	53                   	push   %rbx
  1011f3:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  1011f7:	48 85 ff             	test   %rdi,%rdi
  1011fa:	74 54                	je     101250 <calloc+0x66>
  1011fc:	48 89 fb             	mov    %rdi,%rbx
  1011ff:	49 89 f4             	mov    %rsi,%r12
  101202:	48 85 f6             	test   %rsi,%rsi
  101205:	74 49                	je     101250 <calloc+0x66>
  101207:	e8 a9 ff ff ff       	callq  1011b5 <overflow>
  10120c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101212:	85 c0                	test   %eax,%eax
  101214:	75 2c                	jne    101242 <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  101216:	49 0f af dc          	imul   %r12,%rbx
  10121a:	48 83 c3 07          	add    $0x7,%rbx
  10121e:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  101222:	48 89 df             	mov    %rbx,%rdi
  101225:	e8 3a ff ff ff       	callq  101164 <malloc>
  10122a:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  10122d:	48 85 c0             	test   %rax,%rax
  101230:	74 10                	je     101242 <calloc+0x58>

    memset(malloc_addr, 0, size);
  101232:	48 89 da             	mov    %rbx,%rdx
  101235:	be 00 00 00 00       	mov    $0x0,%esi
  10123a:	48 89 c7             	mov    %rax,%rdi
  10123d:	e8 34 ef ff ff       	callq  100176 <memset>
    return malloc_addr;
}
  101242:	4c 89 e8             	mov    %r13,%rax
  101245:	48 83 c4 08          	add    $0x8,%rsp
  101249:	5b                   	pop    %rbx
  10124a:	41 5c                	pop    %r12
  10124c:	41 5d                	pop    %r13
  10124e:	5d                   	pop    %rbp
  10124f:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  101250:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101256:	eb ea                	jmp    101242 <calloc+0x58>

0000000000101258 <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  101258:	48 85 ff             	test   %rdi,%rdi
  10125b:	74 2c                	je     101289 <free+0x31>
void free(void *ptr) {
  10125d:	55                   	push   %rbp
  10125e:	48 89 e5             	mov    %rsp,%rbp
  101261:	41 54                	push   %r12
  101263:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  101264:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  101268:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  10126c:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  101270:	48 89 df             	mov    %rbx,%rdi
  101273:	e8 64 fd ff ff       	callq  100fdc <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  101278:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  10127c:	48 89 df             	mov    %rbx,%rdi
  10127f:	e8 74 fc ff ff       	callq  100ef8 <append_free_list_node>
    return;
}
  101284:	5b                   	pop    %rbx
  101285:	41 5c                	pop    %r12
  101287:	5d                   	pop    %rbp
  101288:	c3                   	retq   
  101289:	c3                   	retq   

000000000010128a <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  10128a:	55                   	push   %rbp
  10128b:	48 89 e5             	mov    %rsp,%rbp
  10128e:	41 54                	push   %r12
  101290:	53                   	push   %rbx
    if (ptr == NULL) return malloc(sz);
  101291:	48 85 ff             	test   %rdi,%rdi
  101294:	74 40                	je     1012d6 <realloc+0x4c>
  101296:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  101299:	48 85 f6             	test   %rsi,%rsi
  10129c:	74 45                	je     1012e3 <realloc+0x59>
    if (original_sz == sz) return ptr;
  10129e:	49 89 fc             	mov    %rdi,%r12
  1012a1:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  1012a5:	74 27                	je     1012ce <realloc+0x44>
    void *malloc_addr = malloc(sz);
  1012a7:	48 89 f7             	mov    %rsi,%rdi
  1012aa:	e8 b5 fe ff ff       	callq  101164 <malloc>
  1012af:	49 89 c4             	mov    %rax,%r12
    if (malloc_addr == NULL) return NULL;
  1012b2:	48 85 c0             	test   %rax,%rax
  1012b5:	74 17                	je     1012ce <realloc+0x44>
    memcpy(malloc_addr, ptr, header->sz);
  1012b7:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  1012bb:	48 89 de             	mov    %rbx,%rsi
  1012be:	48 89 c7             	mov    %rax,%rdi
  1012c1:	e8 47 ee ff ff       	callq  10010d <memcpy>
    free(ptr);
  1012c6:	48 89 df             	mov    %rbx,%rdi
  1012c9:	e8 8a ff ff ff       	callq  101258 <free>
}
  1012ce:	4c 89 e0             	mov    %r12,%rax
  1012d1:	5b                   	pop    %rbx
  1012d2:	41 5c                	pop    %r12
  1012d4:	5d                   	pop    %rbp
  1012d5:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  1012d6:	48 89 f7             	mov    %rsi,%rdi
  1012d9:	e8 86 fe ff ff       	callq  101164 <malloc>
  1012de:	49 89 c4             	mov    %rax,%r12
  1012e1:	eb eb                	jmp    1012ce <realloc+0x44>
    if (sz == 0) { free(ptr); return NULL; }
  1012e3:	e8 70 ff ff ff       	callq  101258 <free>
  1012e8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1012ee:	eb de                	jmp    1012ce <realloc+0x44>

00000000001012f0 <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  1012f0:	48 63 f6             	movslq %esi,%rsi
  1012f3:	48 c1 e6 04          	shl    $0x4,%rsi
  1012f7:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  1012fa:	48 8b 46 08          	mov    0x8(%rsi),%rax
  1012fe:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  101301:	48 63 d2             	movslq %edx,%rdx
  101304:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101308:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  10130c:	0f 94 c0             	sete   %al
  10130f:	0f b6 c0             	movzbl %al,%eax
}
  101312:	c3                   	retq   

0000000000101313 <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  101313:	55                   	push   %rbp
  101314:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  101317:	48 63 f6             	movslq %esi,%rsi
  10131a:	48 c1 e6 04          	shl    $0x4,%rsi
  10131e:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  101322:	48 63 d2             	movslq %edx,%rdx
  101325:	48 c1 e2 04          	shl    $0x4,%rdx
  101329:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  10132d:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  101331:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  101335:	e8 07 fc ff ff       	callq  100f41 <remove_free_list_node>
}
  10133a:	5d                   	pop    %rbp
  10133b:	c3                   	retq   

000000000010133c <defrag>:

void defrag() {
  10133c:	55                   	push   %rbp
  10133d:	48 89 e5             	mov    %rsp,%rbp
  101340:	41 56                	push   %r14
  101342:	41 55                	push   %r13
  101344:	41 54                	push   %r12
  101346:	53                   	push   %rbx
    ptr_with_size ptrs_with_size[free_list_length];
  101347:	8b 0d e3 0c 00 00    	mov    0xce3(%rip),%ecx        # 102030 <free_list_length>
  10134d:	48 63 f1             	movslq %ecx,%rsi
  101350:	48 89 f0             	mov    %rsi,%rax
  101353:	48 c1 e0 04          	shl    $0x4,%rax
  101357:	48 29 c4             	sub    %rax,%rsp
  10135a:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  10135d:	48 8b 15 dc 0c 00 00 	mov    0xcdc(%rip),%rdx        # 102040 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  101364:	85 c9                	test   %ecx,%ecx
  101366:	7e 24                	jle    10138c <defrag+0x50>
  101368:	4c 89 e8             	mov    %r13,%rax
  10136b:	89 c9                	mov    %ecx,%ecx
  10136d:	48 c1 e1 04          	shl    $0x4,%rcx
  101371:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  101374:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  101377:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  10137b:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  10137f:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  101383:	48 83 c0 10          	add    $0x10,%rax
  101387:	48 39 c8             	cmp    %rcx,%rax
  10138a:	75 e8                	jne    101374 <defrag+0x38>
    }

    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &cmp_ptr_ascending);
  10138c:	b9 82 0a 10 00       	mov    $0x100a82,%ecx
  101391:	ba 10 00 00 00       	mov    $0x10,%edx
  101396:	4c 89 ef             	mov    %r13,%rdi
  101399:	e8 fe f6 ff ff       	callq  100a9c <__quicksort>

    int i = 0, length = free_list_length;
  10139e:	44 8b 35 8b 0c 00 00 	mov    0xc8b(%rip),%r14d        # 102030 <free_list_length>
    for (int j = 1; j < length; j++) {
  1013a5:	41 83 fe 01          	cmp    $0x1,%r14d
  1013a9:	7e 38                	jle    1013e3 <defrag+0xa7>
  1013ab:	bb 01 00 00 00       	mov    $0x1,%ebx
    int i = 0, length = free_list_length;
  1013b0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1013b6:	eb 15                	jmp    1013cd <defrag+0x91>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  1013b8:	89 da                	mov    %ebx,%edx
  1013ba:	44 89 e6             	mov    %r12d,%esi
  1013bd:	4c 89 ef             	mov    %r13,%rdi
  1013c0:	e8 4e ff ff ff       	callq  101313 <coalesce>
    for (int j = 1; j < length; j++) {
  1013c5:	83 c3 01             	add    $0x1,%ebx
  1013c8:	41 39 de             	cmp    %ebx,%r14d
  1013cb:	74 16                	je     1013e3 <defrag+0xa7>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  1013cd:	89 da                	mov    %ebx,%edx
  1013cf:	44 89 e6             	mov    %r12d,%esi
  1013d2:	4c 89 ef             	mov    %r13,%rdi
  1013d5:	e8 16 ff ff ff       	callq  1012f0 <adjacent>
  1013da:	85 c0                	test   %eax,%eax
  1013dc:	75 da                	jne    1013b8 <defrag+0x7c>
  1013de:	41 89 dc             	mov    %ebx,%r12d
  1013e1:	eb e2                	jmp    1013c5 <defrag+0x89>
        else i = j;
    }
}
  1013e3:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  1013e7:	5b                   	pop    %rbx
  1013e8:	41 5c                	pop    %r12
  1013ea:	41 5d                	pop    %r13
  1013ec:	41 5e                	pop    %r14
  1013ee:	5d                   	pop    %rbp
  1013ef:	c3                   	retq   

00000000001013f0 <heap_info>:

int heap_info(heap_info_struct * info) {
  1013f0:	55                   	push   %rbp
  1013f1:	48 89 e5             	mov    %rsp,%rbp
  1013f4:	41 57                	push   %r15
  1013f6:	41 56                	push   %r14
  1013f8:	41 55                	push   %r13
  1013fa:	41 54                	push   %r12
  1013fc:	53                   	push   %rbx
  1013fd:	48 83 ec 18          	sub    $0x18,%rsp
  101401:	49 89 fd             	mov    %rdi,%r13
    int init_alloc_list_length = alloc_list_length;
  101404:	8b 05 12 0c 00 00    	mov    0xc12(%rip),%eax        # 10201c <alloc_list_length>
  10140a:	89 45 cc             	mov    %eax,-0x34(%rbp)
    
    // free space + largest free chunk
    int largest_free_chunk = 0;
    int free_space = 0;
    free_list_node *curr_ = free_list_head;
  10140d:	48 8b 05 2c 0c 00 00 	mov    0xc2c(%rip),%rax        # 102040 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  101414:	8b 3d 16 0c 00 00    	mov    0xc16(%rip),%edi        # 102030 <free_list_length>
  10141a:	85 ff                	test   %edi,%edi
  10141c:	7e 64                	jle    101482 <heap_info+0x92>
  10141e:	ba 00 00 00 00       	mov    $0x0,%edx
    int free_space = 0;
  101423:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  101429:	bb 00 00 00 00       	mov    $0x0,%ebx
        int sz = (int) curr_->sz;
  10142e:	48 8b 48 10          	mov    0x10(%rax),%rcx
        largest_free_chunk = MAX(largest_free_chunk, sz);
  101432:	39 cb                	cmp    %ecx,%ebx
  101434:	0f 4c d9             	cmovl  %ecx,%ebx
        free_space += sz;
  101437:	41 01 cc             	add    %ecx,%r12d
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  10143a:	83 c2 01             	add    $0x1,%edx
  10143d:	48 8b 40 08          	mov    0x8(%rax),%rax
  101441:	39 fa                	cmp    %edi,%edx
  101443:	75 e9                	jne    10142e <heap_info+0x3e>
    }

    // size + ptr arrays
    if (init_alloc_list_length == 0) {
  101445:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  10144b:	41 be 00 00 00 00    	mov    $0x0,%r14d
  101451:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  101455:	75 38                	jne    10148f <heap_info+0x9f>
        info->size_array = NULL;
  101457:	4d 89 7d 08          	mov    %r15,0x8(%r13)
        info->ptr_array = NULL;
  10145b:	4d 89 75 10          	mov    %r14,0x10(%r13)

        info->size_array = size_array;
        info->ptr_array = ptr_array;
    }

    info->num_allocs = init_alloc_list_length;
  10145f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  101462:	41 89 45 00          	mov    %eax,0x0(%r13)
    info->largest_free_chunk = largest_free_chunk;
  101466:	41 89 5d 1c          	mov    %ebx,0x1c(%r13)
    info->free_space = free_space;
  10146a:	45 89 65 18          	mov    %r12d,0x18(%r13)

    return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101473:	48 83 c4 18          	add    $0x18,%rsp
  101477:	5b                   	pop    %rbx
  101478:	41 5c                	pop    %r12
  10147a:	41 5d                	pop    %r13
  10147c:	41 5e                	pop    %r14
  10147e:	41 5f                	pop    %r15
  101480:	5d                   	pop    %rbp
  101481:	c3                   	retq   
    int free_space = 0;
  101482:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  101488:	bb 00 00 00 00       	mov    $0x0,%ebx
  10148d:	eb b6                	jmp    101445 <heap_info+0x55>
        long *size_array = (long *) malloc (sizeof(long) * init_alloc_list_length);
  10148f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
  101493:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101497:	4c 8d 34 c5 00 00 00 	lea    0x0(,%rax,8),%r14
  10149e:	00 
  10149f:	4c 89 f7             	mov    %r14,%rdi
  1014a2:	e8 bd fc ff ff       	callq  101164 <malloc>
  1014a7:	49 89 c7             	mov    %rax,%r15
        void **ptr_array = (void **) malloc (sizeof(void *) * init_alloc_list_length);
  1014aa:	4c 89 f7             	mov    %r14,%rdi
  1014ad:	e8 b2 fc ff ff       	callq  101164 <malloc>
  1014b2:	49 89 c6             	mov    %rax,%r14
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  1014b5:	4d 85 ff             	test   %r15,%r15
  1014b8:	74 68                	je     101522 <heap_info+0x132>
  1014ba:	48 85 c0             	test   %rax,%rax
  1014bd:	74 63                	je     101522 <heap_info+0x132>
        alloc_header *curr = alloc_list_head;
  1014bf:	48 8b 15 62 0b 00 00 	mov    0xb62(%rip),%rdx        # 102028 <alloc_list_head>
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  1014c6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  1014c9:	85 c0                	test   %eax,%eax
  1014cb:	7e 24                	jle    1014f1 <heap_info+0x101>
  1014cd:	89 c6                	mov    %eax,%esi
  1014cf:	b8 00 00 00 00       	mov    $0x0,%eax
            size_array[i] = (long) curr->sz;
  1014d4:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  1014d8:	49 89 0c c7          	mov    %rcx,(%r15,%rax,8)
            ptr_array[i] = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  1014dc:	48 8d 4a 18          	lea    0x18(%rdx),%rcx
  1014e0:	49 89 0c c6          	mov    %rcx,(%r14,%rax,8)
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  1014e4:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1014e8:	48 83 c0 01          	add    $0x1,%rax
  1014ec:	48 39 c6             	cmp    %rax,%rsi
  1014ef:	75 e3                	jne    1014d4 <heap_info+0xe4>
        __quicksort(size_array, init_alloc_list_length, sizeof(size_array[0]), &cmp_simple_descending);
  1014f1:	b9 88 0a 10 00       	mov    $0x100a88,%ecx
  1014f6:	ba 08 00 00 00       	mov    $0x8,%edx
  1014fb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  1014ff:	4c 89 ff             	mov    %r15,%rdi
  101502:	e8 95 f5 ff ff       	callq  100a9c <__quicksort>
        __quicksort(ptr_array, init_alloc_list_length, sizeof(size_array[0]), &cmp_ptrs_by_size_descending);
  101507:	b9 8e 0a 10 00       	mov    $0x100a8e,%ecx
  10150c:	ba 08 00 00 00       	mov    $0x8,%edx
  101511:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  101515:	4c 89 f7             	mov    %r14,%rdi
  101518:	e8 7f f5 ff ff       	callq  100a9c <__quicksort>
        info->ptr_array = ptr_array;
  10151d:	e9 35 ff ff ff       	jmpq   101457 <heap_info+0x67>
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  101522:	4c 89 ff             	mov    %r15,%rdi
  101525:	e8 2e fd ff ff       	callq  101258 <free>
  10152a:	4c 89 f7             	mov    %r14,%rdi
  10152d:	e8 26 fd ff ff       	callq  101258 <free>
  101532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101537:	e9 37 ff ff ff       	jmpq   101473 <heap_info+0x83>
