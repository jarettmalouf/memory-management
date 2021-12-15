
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
  10005f:	e8 34 11 00 00       	callq  101198 <malloc>
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
  1002d3:	bf 11 19 10 00       	mov    $0x101911,%edi
  1002d8:	e8 37 ff ff ff       	callq  100214 <strchr>
  1002dd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1002e0:	48 85 c0             	test   %rax,%rax
  1002e3:	74 55                	je     10033a <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1002e5:	48 81 e9 11 19 10 00 	sub    $0x101911,%rcx
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
  100333:	ff 24 c5 20 17 10 00 	jmpq   *0x101720(,%rax,8)
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
  1004a1:	41 bc 32 19 10 00    	mov    $0x101932,%r12d
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
  10053b:	bf 00 19 10 00       	mov    $0x101900,%edi
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
  10057b:	bf e0 18 10 00       	mov    $0x1018e0,%edi
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
  10060e:	48 c7 45 a0 32 19 10 	movq   $0x101932,-0x60(%rbp)
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
  10081d:	bf 00 19 10 00       	mov    $0x101900,%edi
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
  10085c:	48 c7 45 a0 15 17 10 	movq   $0x101715,-0x60(%rbp)
  100863:	00 
            if (flags & FLAG_NEGATIVE) {
  100864:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100867:	a8 80                	test   $0x80,%al
  100869:	0f 85 b0 fd ff ff    	jne    10061f <printer_vprintf+0x398>
                prefix = "+";
  10086f:	48 c7 45 a0 10 17 10 	movq   $0x101710,-0x60(%rbp)
  100876:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100877:	a8 10                	test   $0x10,%al
  100879:	0f 85 a0 fd ff ff    	jne    10061f <printer_vprintf+0x398>
                prefix = " ";
  10087f:	a8 08                	test   $0x8,%al
  100881:	ba 32 19 10 00       	mov    $0x101932,%edx
  100886:	b8 2f 19 10 00       	mov    $0x10192f,%eax
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
  1008bd:	ba 17 17 10 00       	mov    $0x101717,%edx
  1008c2:	b8 12 17 10 00       	mov    $0x101712,%eax
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

0000000000100a82 <ptr_comparator_ptr_ascending>:
	    }
	}
    }
}
int ptr_comparator_ptr_ascending( const void * a, const void * b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  100a82:	48 8b 07             	mov    (%rdi),%rax
  100a85:	2b 06                	sub    (%rsi),%eax
}
  100a87:	c3                   	retq   

0000000000100a88 <ptr_comparator_size_descending>:
int ptr_comparator_size_descending( const void * a, const void * b){
    return (size_t)((ptr_with_size *) b)->size - (size_t)((ptr_with_size *) a)->size;
  100a88:	48 8b 46 08          	mov    0x8(%rsi),%rax
  100a8c:	2b 47 08             	sub    0x8(%rdi),%eax
}
  100a8f:	c3                   	retq   

0000000000100a90 <__quicksort>:
{
  100a90:	55                   	push   %rbp
  100a91:	48 89 e5             	mov    %rsp,%rbp
  100a94:	41 57                	push   %r15
  100a96:	41 56                	push   %r14
  100a98:	41 55                	push   %r13
  100a9a:	41 54                	push   %r12
  100a9c:	53                   	push   %rbx
  100a9d:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  100aa4:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  100aab:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  100ab2:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  100ab9:	48 85 f6             	test   %rsi,%rsi
  100abc:	0f 84 94 03 00 00    	je     100e56 <__quicksort+0x3c6>
  100ac2:	48 89 f0             	mov    %rsi,%rax
  100ac5:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  100ac8:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  100acf:	00 
  100ad0:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  100ad7:	48 83 fe 04          	cmp    $0x4,%rsi
  100adb:	0f 86 bd 02 00 00    	jbe    100d9e <__quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  100ae1:	48 83 e8 01          	sub    $0x1,%rax
  100ae5:	48 0f af c2          	imul   %rdx,%rax
  100ae9:	48 01 f8             	add    %rdi,%rax
  100aec:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  100af3:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  100afa:	00 00 00 00 
  100afe:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  100b05:	00 00 00 00 
	char *lo = base_ptr;
  100b09:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  100b10:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  100b17:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  100b1e:	48 f7 da             	neg    %rdx
  100b21:	49 89 d7             	mov    %rdx,%r15
  100b24:	e9 8c 01 00 00       	jmpq   100cb5 <__quicksort+0x225>
  100b29:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b30:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100b35:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100b3c:	4c 89 e8             	mov    %r13,%rax
  100b3f:	0f b6 08             	movzbl (%rax),%ecx
  100b42:	48 83 c0 01          	add    $0x1,%rax
  100b46:	0f b6 32             	movzbl (%rdx),%esi
  100b49:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100b4d:	48 83 c2 01          	add    $0x1,%rdx
  100b51:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100b54:	48 39 c7             	cmp    %rax,%rdi
  100b57:	75 e6                	jne    100b3f <__quicksort+0xaf>
  100b59:	e9 92 01 00 00       	jmpq   100cf0 <__quicksort+0x260>
  100b5e:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b65:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100b6a:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  100b71:	4c 89 e8             	mov    %r13,%rax
  100b74:	0f b6 08             	movzbl (%rax),%ecx
  100b77:	48 83 c0 01          	add    $0x1,%rax
  100b7b:	0f b6 32             	movzbl (%rdx),%esi
  100b7e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100b82:	48 83 c2 01          	add    $0x1,%rdx
  100b86:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100b89:	49 39 c4             	cmp    %rax,%r12
  100b8c:	75 e6                	jne    100b74 <__quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100b8e:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  100b95:	4c 89 ef             	mov    %r13,%rdi
  100b98:	ff d3                	callq  *%rbx
  100b9a:	85 c0                	test   %eax,%eax
  100b9c:	0f 89 62 01 00 00    	jns    100d04 <__quicksort+0x274>
  100ba2:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100ba9:	4c 89 e8             	mov    %r13,%rax
  100bac:	0f b6 08             	movzbl (%rax),%ecx
  100baf:	48 83 c0 01          	add    $0x1,%rax
  100bb3:	0f b6 32             	movzbl (%rdx),%esi
  100bb6:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100bba:	48 83 c2 01          	add    $0x1,%rdx
  100bbe:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100bc1:	49 39 c4             	cmp    %rax,%r12
  100bc4:	75 e6                	jne    100bac <__quicksort+0x11c>
jump_over:;
  100bc6:	e9 39 01 00 00       	jmpq   100d04 <__quicksort+0x274>
		  right_ptr -= size;
  100bcb:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  100bce:	4c 89 e6             	mov    %r12,%rsi
  100bd1:	4c 89 ef             	mov    %r13,%rdi
  100bd4:	ff d3                	callq  *%rbx
  100bd6:	85 c0                	test   %eax,%eax
  100bd8:	78 f1                	js     100bcb <__quicksort+0x13b>
	      if (left_ptr < right_ptr)
  100bda:	4d 39 e6             	cmp    %r12,%r14
  100bdd:	72 1c                	jb     100bfb <__quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  100bdf:	74 5e                	je     100c3f <__quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  100be1:	4d 39 e6             	cmp    %r12,%r14
  100be4:	77 63                	ja     100c49 <__quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  100be6:	4c 89 ee             	mov    %r13,%rsi
  100be9:	4c 89 f7             	mov    %r14,%rdi
  100bec:	ff d3                	callq  *%rbx
  100bee:	85 c0                	test   %eax,%eax
  100bf0:	79 dc                	jns    100bce <__quicksort+0x13e>
		  left_ptr += size;
  100bf2:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100bf9:	eb eb                	jmp    100be6 <__quicksort+0x156>
  100bfb:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100c02:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  100c06:	4c 89 e2             	mov    %r12,%rdx
  100c09:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  100c0c:	0f b6 08             	movzbl (%rax),%ecx
  100c0f:	48 83 c0 01          	add    $0x1,%rax
  100c13:	0f b6 32             	movzbl (%rdx),%esi
  100c16:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100c1a:	48 83 c2 01          	add    $0x1,%rdx
  100c1e:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100c21:	48 39 f8             	cmp    %rdi,%rax
  100c24:	75 e6                	jne    100c0c <__quicksort+0x17c>
		  if (mid == left_ptr)
  100c26:	4d 39 ee             	cmp    %r13,%r14
  100c29:	74 0f                	je     100c3a <__quicksort+0x1aa>
		  else if (mid == right_ptr)
  100c2b:	4d 39 ec             	cmp    %r13,%r12
  100c2e:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  100c32:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  100c35:	49 89 fe             	mov    %rdi,%r14
  100c38:	eb a7                	jmp    100be1 <__quicksort+0x151>
  100c3a:	4d 89 e5             	mov    %r12,%r13
  100c3d:	eb f3                	jmp    100c32 <__quicksort+0x1a2>
		  left_ptr += size;
  100c3f:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  100c46:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  100c49:	4c 89 e0             	mov    %r12,%rax
  100c4c:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  100c53:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  100c5a:	48 39 f8             	cmp    %rdi,%rax
  100c5d:	0f 87 bf 00 00 00    	ja     100d22 <__quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c63:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100c6a:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  100c6d:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c74:	48 39 f8             	cmp    %rdi,%rax
  100c77:	77 28                	ja     100ca1 <__quicksort+0x211>
		  POP (lo, hi);
  100c79:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100c80:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  100c84:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  100c8b:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  100c8f:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  100c96:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  100c9a:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  100ca1:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  100ca8:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  100caf:	0f 86 e9 00 00 00    	jbe    100d9e <__quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  100cb5:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100cbc:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100cc3:	48 29 f8             	sub    %rdi,%rax
  100cc6:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  100ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  100cd2:	48 f7 f1             	div    %rcx
  100cd5:	48 d1 e8             	shr    %rax
  100cd8:	48 0f af c1          	imul   %rcx,%rax
  100cdc:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100ce0:	48 89 fe             	mov    %rdi,%rsi
  100ce3:	4c 89 ef             	mov    %r13,%rdi
  100ce6:	ff d3                	callq  *%rbx
  100ce8:	85 c0                	test   %eax,%eax
  100cea:	0f 88 39 fe ff ff    	js     100b29 <__quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100cf0:	4c 89 ee             	mov    %r13,%rsi
  100cf3:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100cfa:	ff d3                	callq  *%rbx
  100cfc:	85 c0                	test   %eax,%eax
  100cfe:	0f 88 5a fe ff ff    	js     100b5e <__quicksort+0xce>
	  left_ptr  = lo + size;
  100d04:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  100d0b:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  100d12:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100d19:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  100d1d:	e9 c4 fe ff ff       	jmpq   100be6 <__quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  100d22:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  100d29:	4c 29 f2             	sub    %r14,%rdx
  100d2c:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  100d33:	76 5d                	jbe    100d92 <__quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  100d35:	48 39 d0             	cmp    %rdx,%rax
  100d38:	7e 2c                	jle    100d66 <__quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  100d3a:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d41:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100d48:	48 89 38             	mov    %rdi,(%rax)
  100d4b:	4c 89 60 08          	mov    %r12,0x8(%rax)
  100d4f:	48 83 c0 10          	add    $0x10,%rax
  100d53:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  100d5a:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  100d61:	e9 3b ff ff ff       	jmpq   100ca1 <__quicksort+0x211>
	      PUSH (left_ptr, hi);
  100d66:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d6d:	4c 89 30             	mov    %r14,(%rax)
  100d70:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100d77:	48 89 78 08          	mov    %rdi,0x8(%rax)
  100d7b:	48 83 c0 10          	add    $0x10,%rax
  100d7f:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  100d86:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100d8d:	e9 0f ff ff ff       	jmpq   100ca1 <__quicksort+0x211>
	      hi = right_ptr;
  100d92:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100d99:	e9 03 ff ff ff       	jmpq   100ca1 <__quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  100d9e:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  100da5:	49 83 ef 01          	sub    $0x1,%r15
  100da9:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  100db0:	4c 0f af ff          	imul   %rdi,%r15
  100db4:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  100dbb:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  100dbe:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  100dc5:	4c 01 e8             	add    %r13,%rax
  100dc8:	49 39 c7             	cmp    %rax,%r15
  100dcb:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100dcf:	4d 89 ec             	mov    %r13,%r12
  100dd2:	49 01 fc             	add    %rdi,%r12
  100dd5:	4c 39 e0             	cmp    %r12,%rax
  100dd8:	72 66                	jb     100e40 <__quicksort+0x3b0>
  100dda:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  100ddd:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100de4:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100de7:	4c 89 ee             	mov    %r13,%rsi
  100dea:	4c 89 f7             	mov    %r14,%rdi
  100ded:	ff d3                	callq  *%rbx
  100def:	85 c0                	test   %eax,%eax
  100df1:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100df5:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100dfc:	4d 39 f4             	cmp    %r14,%r12
  100dff:	73 e6                	jae    100de7 <__quicksort+0x357>
  100e01:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  100e08:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e0f:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  100e14:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  100e1b:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  100e22:	74 1c                	je     100e40 <__quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  100e24:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  100e29:	49 83 c5 01          	add    $0x1,%r13
  100e2d:	0f b6 30             	movzbl (%rax),%esi
  100e30:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  100e34:	48 83 c0 01          	add    $0x1,%rax
  100e38:	88 50 ff             	mov    %dl,-0x1(%rax)
  100e3b:	49 39 cd             	cmp    %rcx,%r13
  100e3e:	75 e4                	jne    100e24 <__quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  100e40:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e47:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  100e4b:	48 f7 d8             	neg    %rax
  100e4e:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  100e51:	4d 39 f7             	cmp    %r14,%r15
  100e54:	73 15                	jae    100e6b <__quicksort+0x3db>
}
  100e56:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  100e5d:	5b                   	pop    %rbx
  100e5e:	41 5c                	pop    %r12
  100e60:	41 5d                	pop    %r13
  100e62:	41 5e                	pop    %r14
  100e64:	41 5f                	pop    %r15
  100e66:	5d                   	pop    %rbp
  100e67:	c3                   	retq   
		tmp_ptr -= size;
  100e68:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100e6b:	4c 89 e6             	mov    %r12,%rsi
  100e6e:	4c 89 f7             	mov    %r14,%rdi
  100e71:	ff d3                	callq  *%rbx
  100e73:	85 c0                	test   %eax,%eax
  100e75:	78 f1                	js     100e68 <__quicksort+0x3d8>
	    tmp_ptr += size;
  100e77:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e7e:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  100e82:	4c 39 f6             	cmp    %r14,%rsi
  100e85:	75 17                	jne    100e9e <__quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  100e87:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e8e:	4c 01 f0             	add    %r14,%rax
  100e91:	4d 89 f4             	mov    %r14,%r12
  100e94:	49 39 c7             	cmp    %rax,%r15
  100e97:	72 bd                	jb     100e56 <__quicksort+0x3c6>
  100e99:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100e9c:	eb cd                	jmp    100e6b <__quicksort+0x3db>
		while (--trav >= run_ptr)
  100e9e:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  100ea3:	4c 39 f7             	cmp    %r14,%rdi
  100ea6:	72 df                	jb     100e87 <__quicksort+0x3f7>
  100ea8:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  100eac:	4d 89 c2             	mov    %r8,%r10
  100eaf:	eb 13                	jmp    100ec4 <__quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100eb1:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  100eb4:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  100eb7:	48 83 ef 01          	sub    $0x1,%rdi
  100ebb:	49 83 e8 01          	sub    $0x1,%r8
  100ebf:	49 39 fa             	cmp    %rdi,%r10
  100ec2:	74 c3                	je     100e87 <__quicksort+0x3f7>
		    char c = *trav;
  100ec4:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ec8:	4c 89 c0             	mov    %r8,%rax
  100ecb:	4c 39 c6             	cmp    %r8,%rsi
  100ece:	77 e1                	ja     100eb1 <__quicksort+0x421>
  100ed0:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  100ed3:	0f b6 08             	movzbl (%rax),%ecx
  100ed6:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ed8:	48 89 c1             	mov    %rax,%rcx
  100edb:	4c 01 e8             	add    %r13,%rax
  100ede:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  100ee5:	48 39 c6             	cmp    %rax,%rsi
  100ee8:	76 e9                	jbe    100ed3 <__quicksort+0x443>
  100eea:	eb c8                	jmp    100eb4 <__quicksort+0x424>

0000000000100eec <print_ptrs_with_size>:
void print_ptrs_with_size(ptr_with_size *ptrs_with_size, int end) {
  100eec:	55                   	push   %rbp
  100eed:	48 89 e5             	mov    %rsp,%rbp
  100ef0:	41 55                	push   %r13
  100ef2:	41 54                	push   %r12
  100ef4:	53                   	push   %rbx
  100ef5:	48 83 ec 08          	sub    $0x8,%rsp
  100ef9:	49 89 fd             	mov    %rdi,%r13
  100efc:	41 89 f4             	mov    %esi,%r12d

// mem_tog
// toggles kernels printing of memory space for process if pid is its processID
// if pid == 0, toggles state globally (preference to global over local)
static inline void mem_tog(pid_t p) {
    asm volatile ("int %0" : /* no result */
  100eff:	bf 00 00 00 00       	mov    $0x0,%edi
  100f04:	cd 38                	int    $0x38
    mem_tog(0);
    app_printf(1, "Start");
  100f06:	be 17 19 10 00       	mov    $0x101917,%esi
  100f0b:	bf 01 00 00 00       	mov    $0x1,%edi
  100f10:	b8 00 00 00 00       	mov    $0x0,%eax
  100f15:	e8 66 06 00 00       	callq  101580 <app_printf>
    for (int i = 0; i < end; i++) {
  100f1a:	45 85 e4             	test   %r12d,%r12d
  100f1d:	7e 35                	jle    100f54 <print_ptrs_with_size+0x68>
  100f1f:	4c 89 eb             	mov    %r13,%rbx
  100f22:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  100f27:	48 c1 e0 04          	shl    $0x4,%rax
  100f2b:	4d 8d 64 05 10       	lea    0x10(%r13,%rax,1),%r12
        app_printf(1, " %x-%x ", ptrs_with_size[i].ptr, ptrs_with_size[i].size);
  100f30:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  100f34:	48 8b 13             	mov    (%rbx),%rdx
  100f37:	be 1d 19 10 00       	mov    $0x10191d,%esi
  100f3c:	bf 01 00 00 00       	mov    $0x1,%edi
  100f41:	b8 00 00 00 00       	mov    $0x0,%eax
  100f46:	e8 35 06 00 00       	callq  101580 <app_printf>
    for (int i = 0; i < end; i++) {
  100f4b:	48 83 c3 10          	add    $0x10,%rbx
  100f4f:	4c 39 e3             	cmp    %r12,%rbx
  100f52:	75 dc                	jne    100f30 <print_ptrs_with_size+0x44>
    }
    app_printf(1, "End");
  100f54:	be 25 19 10 00       	mov    $0x101925,%esi
  100f59:	bf 01 00 00 00       	mov    $0x1,%edi
  100f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  100f63:	e8 18 06 00 00       	callq  101580 <app_printf>
}
  100f68:	48 83 c4 08          	add    $0x8,%rsp
  100f6c:	5b                   	pop    %rbx
  100f6d:	41 5c                	pop    %r12
  100f6f:	41 5d                	pop    %r13
  100f71:	5d                   	pop    %rbp
  100f72:	c3                   	retq   

0000000000100f73 <append_free_list_node>:
alloc_header *alloc_list_head = NULL;
alloc_header *alloc_list_tail = NULL;
int alloc_list_length = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  100f73:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  100f7a:	00 
    node->prev = NULL;
  100f7b:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  100f82:	48 83 3d b6 10 00 00 	cmpq   $0x0,0x10b6(%rip)        # 102040 <free_list_head>
  100f89:	00 
  100f8a:	74 1d                	je     100fa9 <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  100f8c:	48 8b 05 a5 10 00 00 	mov    0x10a5(%rip),%rax        # 102038 <free_list_tail>
  100f93:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  100f97:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  100f9a:	48 89 3d 97 10 00 00 	mov    %rdi,0x1097(%rip)        # 102038 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  100fa1:	83 05 88 10 00 00 01 	addl   $0x1,0x1088(%rip)        # 102030 <free_list_length>
}
  100fa8:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  100fa9:	48 83 3d 87 10 00 00 	cmpq   $0x0,0x1087(%rip)        # 102038 <free_list_tail>
  100fb0:	00 
  100fb1:	75 d9                	jne    100f8c <append_free_list_node+0x19>
        free_list_head = node;
  100fb3:	48 89 3d 86 10 00 00 	mov    %rdi,0x1086(%rip)        # 102040 <free_list_head>
        free_list_tail = node;
  100fba:	eb de                	jmp    100f9a <append_free_list_node+0x27>

0000000000100fbc <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  100fbc:	48 39 3d 7d 10 00 00 	cmp    %rdi,0x107d(%rip)        # 102040 <free_list_head>
  100fc3:	74 30                	je     100ff5 <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  100fc5:	48 39 3d 6c 10 00 00 	cmp    %rdi,0x106c(%rip)        # 102038 <free_list_tail>
  100fcc:	74 34                	je     101002 <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  100fce:	48 8b 07             	mov    (%rdi),%rax
  100fd1:	48 85 c0             	test   %rax,%rax
  100fd4:	74 08                	je     100fde <remove_free_list_node+0x22>
  100fd6:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100fda:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  100fde:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100fe2:	48 85 c0             	test   %rax,%rax
  100fe5:	74 06                	je     100fed <remove_free_list_node+0x31>
  100fe7:	48 8b 17             	mov    (%rdi),%rdx
  100fea:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  100fed:	83 2d 3c 10 00 00 01 	subl   $0x1,0x103c(%rip)        # 102030 <free_list_length>
}
  100ff4:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  100ff5:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100ff9:	48 89 05 40 10 00 00 	mov    %rax,0x1040(%rip)        # 102040 <free_list_head>
  101000:	eb c3                	jmp    100fc5 <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  101002:	48 8b 07             	mov    (%rdi),%rax
  101005:	48 89 05 2c 10 00 00 	mov    %rax,0x102c(%rip)        # 102038 <free_list_tail>
  10100c:	eb c0                	jmp    100fce <remove_free_list_node+0x12>

000000000010100e <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  10100e:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  101015:	00 
    header->prev = NULL;
  101016:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  10101d:	48 83 3d 03 10 00 00 	cmpq   $0x0,0x1003(%rip)        # 102028 <alloc_list_head>
  101024:	00 
  101025:	74 1d                	je     101044 <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  101027:	48 8b 05 f2 0f 00 00 	mov    0xff2(%rip),%rax        # 102020 <alloc_list_tail>
  10102e:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  101032:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  101035:	48 89 3d e4 0f 00 00 	mov    %rdi,0xfe4(%rip)        # 102020 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  10103c:	83 05 d5 0f 00 00 01 	addl   $0x1,0xfd5(%rip)        # 102018 <alloc_list_length>
}
  101043:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  101044:	48 83 3d d4 0f 00 00 	cmpq   $0x0,0xfd4(%rip)        # 102020 <alloc_list_tail>
  10104b:	00 
  10104c:	75 d9                	jne    101027 <append_alloc_list_node+0x19>
        alloc_list_head = header;
  10104e:	48 89 3d d3 0f 00 00 	mov    %rdi,0xfd3(%rip)        # 102028 <alloc_list_head>
        alloc_list_tail = header;
  101055:	eb de                	jmp    101035 <append_alloc_list_node+0x27>

0000000000101057 <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  101057:	48 39 3d ca 0f 00 00 	cmp    %rdi,0xfca(%rip)        # 102028 <alloc_list_head>
  10105e:	74 30                	je     101090 <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  101060:	48 39 3d b9 0f 00 00 	cmp    %rdi,0xfb9(%rip)        # 102020 <alloc_list_tail>
  101067:	74 34                	je     10109d <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  101069:	48 8b 07             	mov    (%rdi),%rax
  10106c:	48 85 c0             	test   %rax,%rax
  10106f:	74 08                	je     101079 <remove_alloc_list_node+0x22>
  101071:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  101075:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  101079:	48 8b 47 08          	mov    0x8(%rdi),%rax
  10107d:	48 85 c0             	test   %rax,%rax
  101080:	74 06                	je     101088 <remove_alloc_list_node+0x31>
  101082:	48 8b 17             	mov    (%rdi),%rdx
  101085:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  101088:	83 2d 89 0f 00 00 01 	subl   $0x1,0xf89(%rip)        # 102018 <alloc_list_length>
}
  10108f:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  101090:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101094:	48 89 05 8d 0f 00 00 	mov    %rax,0xf8d(%rip)        # 102028 <alloc_list_head>
  10109b:	eb c3                	jmp    101060 <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  10109d:	48 8b 07             	mov    (%rdi),%rax
  1010a0:	48 89 05 79 0f 00 00 	mov    %rax,0xf79(%rip)        # 102020 <alloc_list_tail>
  1010a7:	eb c0                	jmp    101069 <remove_alloc_list_node+0x12>

00000000001010a9 <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  1010a9:	48 8b 05 90 0f 00 00 	mov    0xf90(%rip),%rax        # 102040 <free_list_head>
    while (ptr != NULL) {
  1010b0:	48 85 c0             	test   %rax,%rax
  1010b3:	74 13                	je     1010c8 <get_free_block+0x1f>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
  1010b5:	48 83 c7 18          	add    $0x18,%rdi
  1010b9:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  1010bd:	73 09                	jae    1010c8 <get_free_block+0x1f>
        ptr = ptr->next;
  1010bf:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL) {
  1010c3:	48 85 c0             	test   %rax,%rax
  1010c6:	75 f1                	jne    1010b9 <get_free_block+0x10>
    }
    return NULL;
}
  1010c8:	c3                   	retq   

00000000001010c9 <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  1010c9:	55                   	push   %rbp
  1010ca:	48 89 e5             	mov    %rsp,%rbp
  1010cd:	53                   	push   %rbx
  1010ce:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  1010d2:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  1010d9:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  1010e0:	cc cc cc 
  1010e3:	48 89 d0             	mov    %rdx,%rax
  1010e6:	48 f7 e1             	mul    %rcx
  1010e9:	48 c1 ea 0f          	shr    $0xf,%rdx
  1010ed:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  1010f1:	48 c1 e7 0d          	shl    $0xd,%rdi
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  1010f5:	cd 3a                	int    $0x3a
  1010f7:	48 89 05 4a 0f 00 00 	mov    %rax,0xf4a(%rip)        # 102048 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  1010fe:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  101102:	74 18                	je     10111c <extend_heap+0x53>
  101104:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  101107:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  10110b:	48 89 c7             	mov    %rax,%rdi
  10110e:	e8 60 fe ff ff       	callq  100f73 <append_free_list_node>
    return node;
}
  101113:	48 89 d8             	mov    %rbx,%rax
  101116:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  10111a:	c9                   	leaveq 
  10111b:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  10111c:	bb 00 00 00 00       	mov    $0x0,%ebx
  101121:	eb f0                	jmp    101113 <extend_heap+0x4a>

0000000000101123 <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  101123:	55                   	push   %rbp
  101124:	48 89 e5             	mov    %rsp,%rbp
  101127:	41 56                	push   %r14
  101129:	41 55                	push   %r13
  10112b:	41 54                	push   %r12
  10112d:	53                   	push   %rbx
  10112e:	48 89 fb             	mov    %rdi,%rbx
    free_list_node *free_block = get_free_block(sz);
  101131:	e8 73 ff ff ff       	callq  1010a9 <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  101136:	48 85 c0             	test   %rax,%rax
  101139:	74 54                	je     10118f <allocate_to_free_block+0x6c>
  10113b:	49 89 c4             	mov    %rax,%r12

    uintptr_t block_addr = (uintptr_t) free_block;
  10113e:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  101141:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  101145:	48 89 c7             	mov    %rax,%rdi
  101148:	e8 6f fe ff ff       	callq  100fbc <remove_free_list_node>

    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  10114d:	48 83 c3 07          	add    $0x7,%rbx
  101151:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  101155:	49 89 5c 24 10       	mov    %rbx,0x10(%r12)
    append_alloc_list_node(header);
  10115a:	4c 89 e7             	mov    %r12,%rdi
  10115d:	e8 ac fe ff ff       	callq  10100e <append_alloc_list_node>

    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  101162:	48 83 c3 18          	add    $0x18,%rbx
    size_t leftover = block_size - data_size;
  101166:	49 29 dd             	sub    %rbx,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  101169:	49 83 fd 17          	cmp    $0x17,%r13
  10116d:	77 11                	ja     101180 <allocate_to_free_block+0x5d>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  10116f:	4d 01 6c 24 10       	add    %r13,0x10(%r12)

    return block_addr;
}
  101174:	4c 89 f0             	mov    %r14,%rax
  101177:	5b                   	pop    %rbx
  101178:	41 5c                	pop    %r12
  10117a:	41 5d                	pop    %r13
  10117c:	41 5e                	pop    %r14
  10117e:	5d                   	pop    %rbp
  10117f:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  101180:	49 8d 3c 1c          	lea    (%r12,%rbx,1),%rdi
        node->sz = leftover;
  101184:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  101188:	e8 e6 fd ff ff       	callq  100f73 <append_free_list_node>
  10118d:	eb e5                	jmp    101174 <allocate_to_free_block+0x51>
    if (free_block == NULL) return (uintptr_t) -1;
  10118f:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  101196:	eb dc                	jmp    101174 <allocate_to_free_block+0x51>

0000000000101198 <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  101198:	b8 00 00 00 00       	mov    $0x0,%eax
  10119d:	48 85 ff             	test   %rdi,%rdi
  1011a0:	74 3c                	je     1011de <malloc+0x46>
void *malloc(uint64_t sz) {
  1011a2:	55                   	push   %rbp
  1011a3:	48 89 e5             	mov    %rsp,%rbp
  1011a6:	53                   	push   %rbx
  1011a7:	48 83 ec 08          	sub    $0x8,%rsp
  1011ab:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  1011ae:	e8 70 ff ff ff       	callq  101123 <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1011b3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1011b7:	75 1b                	jne    1011d4 <malloc+0x3c>
        if (extend_heap(sz) == NULL) return NULL;
  1011b9:	48 89 df             	mov    %rbx,%rdi
  1011bc:	e8 08 ff ff ff       	callq  1010c9 <extend_heap>
  1011c1:	48 85 c0             	test   %rax,%rax
  1011c4:	74 12                	je     1011d8 <malloc+0x40>
        block_addr = allocate_to_free_block(sz);
  1011c6:	48 89 df             	mov    %rbx,%rdi
  1011c9:	e8 55 ff ff ff       	callq  101123 <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1011ce:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1011d2:	74 e5                	je     1011b9 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  1011d4:	48 83 c0 18          	add    $0x18,%rax
}
  1011d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1011dc:	c9                   	leaveq 
  1011dd:	c3                   	retq   
  1011de:	c3                   	retq   

00000000001011df <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  1011df:	48 89 f9             	mov    %rdi,%rcx
  1011e2:	48 0f af ce          	imul   %rsi,%rcx
  1011e6:	48 89 c8             	mov    %rcx,%rax
  1011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1011ee:	48 f7 f7             	div    %rdi
  1011f1:	ba 01 00 00 00       	mov    $0x1,%edx
  1011f6:	48 39 f0             	cmp    %rsi,%rax
  1011f9:	74 03                	je     1011fe <overflow+0x1f>
}
  1011fb:	89 d0                	mov    %edx,%eax
  1011fd:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  1011fe:	48 89 c8             	mov    %rcx,%rax
  101201:	ba 00 00 00 00       	mov    $0x0,%edx
  101206:	48 f7 f6             	div    %rsi
  101209:	48 39 f8             	cmp    %rdi,%rax
  10120c:	0f 95 c2             	setne  %dl
  10120f:	0f b6 d2             	movzbl %dl,%edx
  101212:	eb e7                	jmp    1011fb <overflow+0x1c>

0000000000101214 <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  101214:	55                   	push   %rbp
  101215:	48 89 e5             	mov    %rsp,%rbp
  101218:	41 55                	push   %r13
  10121a:	41 54                	push   %r12
  10121c:	53                   	push   %rbx
  10121d:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  101221:	48 85 ff             	test   %rdi,%rdi
  101224:	74 54                	je     10127a <calloc+0x66>
  101226:	48 89 fb             	mov    %rdi,%rbx
  101229:	49 89 f4             	mov    %rsi,%r12
  10122c:	48 85 f6             	test   %rsi,%rsi
  10122f:	74 49                	je     10127a <calloc+0x66>
  101231:	e8 a9 ff ff ff       	callq  1011df <overflow>
  101236:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  10123c:	85 c0                	test   %eax,%eax
  10123e:	75 2c                	jne    10126c <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  101240:	49 0f af dc          	imul   %r12,%rbx
  101244:	48 83 c3 07          	add    $0x7,%rbx
  101248:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  10124c:	48 89 df             	mov    %rbx,%rdi
  10124f:	e8 44 ff ff ff       	callq  101198 <malloc>
  101254:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  101257:	48 85 c0             	test   %rax,%rax
  10125a:	74 10                	je     10126c <calloc+0x58>

    memset(malloc_addr, 0, size);
  10125c:	48 89 da             	mov    %rbx,%rdx
  10125f:	be 00 00 00 00       	mov    $0x0,%esi
  101264:	48 89 c7             	mov    %rax,%rdi
  101267:	e8 0a ef ff ff       	callq  100176 <memset>
    return malloc_addr;
}
  10126c:	4c 89 e8             	mov    %r13,%rax
  10126f:	48 83 c4 08          	add    $0x8,%rsp
  101273:	5b                   	pop    %rbx
  101274:	41 5c                	pop    %r12
  101276:	41 5d                	pop    %r13
  101278:	5d                   	pop    %rbp
  101279:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  10127a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101280:	eb ea                	jmp    10126c <calloc+0x58>

0000000000101282 <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  101282:	48 85 ff             	test   %rdi,%rdi
  101285:	74 2c                	je     1012b3 <free+0x31>
void free(void *ptr) {
  101287:	55                   	push   %rbp
  101288:	48 89 e5             	mov    %rsp,%rbp
  10128b:	41 54                	push   %r12
  10128d:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  10128e:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  101292:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  101296:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  10129a:	48 89 df             	mov    %rbx,%rdi
  10129d:	e8 b5 fd ff ff       	callq  101057 <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  1012a2:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  1012a6:	48 89 df             	mov    %rbx,%rdi
  1012a9:	e8 c5 fc ff ff       	callq  100f73 <append_free_list_node>
    return;
}
  1012ae:	5b                   	pop    %rbx
  1012af:	41 5c                	pop    %r12
  1012b1:	5d                   	pop    %rbp
  1012b2:	c3                   	retq   
  1012b3:	c3                   	retq   

00000000001012b4 <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  1012b4:	55                   	push   %rbp
  1012b5:	48 89 e5             	mov    %rsp,%rbp
  1012b8:	41 54                	push   %r12
  1012ba:	53                   	push   %rbx
    if (ptr == NULL) return malloc(sz);
  1012bb:	48 85 ff             	test   %rdi,%rdi
  1012be:	74 40                	je     101300 <realloc+0x4c>
  1012c0:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  1012c3:	48 85 f6             	test   %rsi,%rsi
  1012c6:	74 45                	je     10130d <realloc+0x59>
    if (original_sz == sz) return ptr;
  1012c8:	49 89 fc             	mov    %rdi,%r12
  1012cb:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  1012cf:	74 27                	je     1012f8 <realloc+0x44>
    void *malloc_addr = malloc(sz);
  1012d1:	48 89 f7             	mov    %rsi,%rdi
  1012d4:	e8 bf fe ff ff       	callq  101198 <malloc>
  1012d9:	49 89 c4             	mov    %rax,%r12
    if (malloc_addr == NULL) return NULL;
  1012dc:	48 85 c0             	test   %rax,%rax
  1012df:	74 17                	je     1012f8 <realloc+0x44>
    memcpy(malloc_addr, ptr, header->sz);
  1012e1:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  1012e5:	48 89 de             	mov    %rbx,%rsi
  1012e8:	48 89 c7             	mov    %rax,%rdi
  1012eb:	e8 1d ee ff ff       	callq  10010d <memcpy>
    free(ptr);
  1012f0:	48 89 df             	mov    %rbx,%rdi
  1012f3:	e8 8a ff ff ff       	callq  101282 <free>
}
  1012f8:	4c 89 e0             	mov    %r12,%rax
  1012fb:	5b                   	pop    %rbx
  1012fc:	41 5c                	pop    %r12
  1012fe:	5d                   	pop    %rbp
  1012ff:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  101300:	48 89 f7             	mov    %rsi,%rdi
  101303:	e8 90 fe ff ff       	callq  101198 <malloc>
  101308:	49 89 c4             	mov    %rax,%r12
  10130b:	eb eb                	jmp    1012f8 <realloc+0x44>
    if (sz == 0) { free(ptr); return NULL; }
  10130d:	e8 70 ff ff ff       	callq  101282 <free>
  101312:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  101318:	eb de                	jmp    1012f8 <realloc+0x44>

000000000010131a <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  10131a:	48 63 f6             	movslq %esi,%rsi
  10131d:	48 c1 e6 04          	shl    $0x4,%rsi
  101321:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101324:	48 8b 46 08          	mov    0x8(%rsi),%rax
  101328:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  10132b:	48 63 d2             	movslq %edx,%rdx
  10132e:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101332:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  101336:	0f 94 c0             	sete   %al
  101339:	0f b6 c0             	movzbl %al,%eax
}
  10133c:	c3                   	retq   

000000000010133d <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  10133d:	55                   	push   %rbp
  10133e:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  101341:	48 63 f6             	movslq %esi,%rsi
  101344:	48 c1 e6 04          	shl    $0x4,%rsi
  101348:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  10134c:	48 63 d2             	movslq %edx,%rdx
  10134f:	48 c1 e2 04          	shl    $0x4,%rdx
  101353:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  101357:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  10135b:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  10135f:	e8 58 fc ff ff       	callq  100fbc <remove_free_list_node>
}
  101364:	5d                   	pop    %rbp
  101365:	c3                   	retq   

0000000000101366 <defrag>:

void defrag() {
  101366:	55                   	push   %rbp
  101367:	48 89 e5             	mov    %rsp,%rbp
  10136a:	41 55                	push   %r13
  10136c:	41 54                	push   %r12
  10136e:	53                   	push   %rbx
  10136f:	48 83 ec 08          	sub    $0x8,%rsp
    ptr_with_size ptrs_with_size[free_list_length];
  101373:	8b 0d b7 0c 00 00    	mov    0xcb7(%rip),%ecx        # 102030 <free_list_length>
  101379:	48 63 f1             	movslq %ecx,%rsi
  10137c:	48 89 f0             	mov    %rsi,%rax
  10137f:	48 c1 e0 04          	shl    $0x4,%rax
  101383:	48 29 c4             	sub    %rax,%rsp
  101386:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  101389:	48 8b 15 b0 0c 00 00 	mov    0xcb0(%rip),%rdx        # 102040 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  101390:	85 c9                	test   %ecx,%ecx
  101392:	7e 24                	jle    1013b8 <defrag+0x52>
  101394:	4c 89 e8             	mov    %r13,%rax
  101397:	89 c9                	mov    %ecx,%ecx
  101399:	48 c1 e1 04          	shl    $0x4,%rcx
  10139d:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  1013a0:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  1013a3:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  1013a7:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  1013ab:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1013af:	48 83 c0 10          	add    $0x10,%rax
  1013b3:	48 39 c8             	cmp    %rcx,%rax
  1013b6:	75 e8                	jne    1013a0 <defrag+0x3a>
    }
    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_ptr_ascending);
  1013b8:	b9 82 0a 10 00       	mov    $0x100a82,%ecx
  1013bd:	ba 10 00 00 00       	mov    $0x10,%edx
  1013c2:	4c 89 ef             	mov    %r13,%rdi
  1013c5:	e8 c6 f6 ff ff       	callq  100a90 <__quicksort>

    int i = 0, j = 1;
    for (; j < free_list_length; j++) {
  1013ca:	83 3d 5f 0c 00 00 01 	cmpl   $0x1,0xc5f(%rip)        # 102030 <free_list_length>
  1013d1:	7e 3b                	jle    10140e <defrag+0xa8>
    int i = 0, j = 1;
  1013d3:	bb 01 00 00 00       	mov    $0x1,%ebx
  1013d8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1013de:	eb 18                	jmp    1013f8 <defrag+0x92>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  1013e0:	89 da                	mov    %ebx,%edx
  1013e2:	44 89 e6             	mov    %r12d,%esi
  1013e5:	4c 89 ef             	mov    %r13,%rdi
  1013e8:	e8 50 ff ff ff       	callq  10133d <coalesce>
    for (; j < free_list_length; j++) {
  1013ed:	83 c3 01             	add    $0x1,%ebx
  1013f0:	39 1d 3a 0c 00 00    	cmp    %ebx,0xc3a(%rip)        # 102030 <free_list_length>
  1013f6:	7e 16                	jle    10140e <defrag+0xa8>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  1013f8:	89 da                	mov    %ebx,%edx
  1013fa:	44 89 e6             	mov    %r12d,%esi
  1013fd:	4c 89 ef             	mov    %r13,%rdi
  101400:	e8 15 ff ff ff       	callq  10131a <adjacent>
  101405:	85 c0                	test   %eax,%eax
  101407:	75 d7                	jne    1013e0 <defrag+0x7a>
  101409:	41 89 dc             	mov    %ebx,%r12d
  10140c:	eb df                	jmp    1013ed <defrag+0x87>
        else i = j;
    }
}
  10140e:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  101412:	5b                   	pop    %rbx
  101413:	41 5c                	pop    %r12
  101415:	41 5d                	pop    %r13
  101417:	5d                   	pop    %rbp
  101418:	c3                   	retq   

0000000000101419 <heap_info>:
// and should NOT be included in the heap info
// return 0 for a successfull call
// if for any reason the information cannot be saved, return -1


int heap_info(heap_info_struct * info) {
  101419:	55                   	push   %rbp
  10141a:	48 89 e5             	mov    %rsp,%rbp
  10141d:	41 56                	push   %r14
  10141f:	41 55                	push   %r13
  101421:	41 54                	push   %r12
  101423:	53                   	push   %rbx
  101424:	48 89 fb             	mov    %rdi,%rbx
    // alloc_list_length
    info->num_allocs = alloc_list_length;
  101427:	8b 0d eb 0b 00 00    	mov    0xbeb(%rip),%ecx        # 102018 <alloc_list_length>
  10142d:	89 0f                	mov    %ecx,(%rdi)

    // size+ptr arrays
    if (alloc_list_length == 0) {
  10142f:	85 c9                	test   %ecx,%ecx
  101431:	75 68                	jne    10149b <heap_info+0x82>
        info->size_array = NULL;
  101433:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  10143a:	00 
        info->ptr_array = NULL;
  10143b:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  101442:	00 
    }
   
    // free space
    size_t free_space = 0;
    size_t largest_free_chunk = 0;
    free_list_node *curr_ = free_list_head;
  101443:	48 8b 0d f6 0b 00 00 	mov    0xbf6(%rip),%rcx        # 102040 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  10144a:	44 8b 05 df 0b 00 00 	mov    0xbdf(%rip),%r8d        # 102030 <free_list_length>
  101451:	45 85 c0             	test   %r8d,%r8d
  101454:	0f 8e 17 01 00 00    	jle    101571 <heap_info+0x158>
  10145a:	be 00 00 00 00       	mov    $0x0,%esi
    size_t largest_free_chunk = 0;
  10145f:	ba 00 00 00 00       	mov    $0x0,%edx
    size_t free_space = 0;
  101464:	bf 00 00 00 00       	mov    $0x0,%edi
        largest_free_chunk = MAX(largest_free_chunk, curr_->sz);
  101469:	48 8b 41 10          	mov    0x10(%rcx),%rax
  10146d:	48 39 c2             	cmp    %rax,%rdx
  101470:	48 0f 42 d0          	cmovb  %rax,%rdx
        free_space += curr_->sz;
  101474:	48 01 c7             	add    %rax,%rdi
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  101477:	83 c6 01             	add    $0x1,%esi
  10147a:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  10147e:	44 39 c6             	cmp    %r8d,%esi
  101481:	75 e6                	jne    101469 <heap_info+0x50>
    }
    info->free_space = (int) free_space;
  101483:	89 7b 18             	mov    %edi,0x18(%rbx)
    info->largest_free_chunk = (int) largest_free_chunk;
  101486:	89 53 1c             	mov    %edx,0x1c(%rbx)
    
    return 0;
  101489:	b8 00 00 00 00       	mov    $0x0,%eax
  10148e:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  101492:	5b                   	pop    %rbx
  101493:	41 5c                	pop    %r12
  101495:	41 5d                	pop    %r13
  101497:	41 5e                	pop    %r14
  101499:	5d                   	pop    %rbp
  10149a:	c3                   	retq   
    } else {
  10149b:	49 89 e4             	mov    %rsp,%r12
        ptr_with_size ptrs_with_size[alloc_list_length];
  10149e:	48 63 f9             	movslq %ecx,%rdi
  1014a1:	48 89 f8             	mov    %rdi,%rax
  1014a4:	48 c1 e0 04          	shl    $0x4,%rax
  1014a8:	48 29 c4             	sub    %rax,%rsp
  1014ab:	49 89 e6             	mov    %rsp,%r14
        alloc_header *curr = alloc_list_head;
  1014ae:	48 8b 15 73 0b 00 00 	mov    0xb73(%rip),%rdx        # 102028 <alloc_list_head>
        for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  1014b5:	85 c9                	test   %ecx,%ecx
  1014b7:	7e 28                	jle    1014e1 <heap_info+0xc8>
  1014b9:	4c 89 f0             	mov    %r14,%rax
  1014bc:	89 c9                	mov    %ecx,%ecx
  1014be:	48 c1 e1 04          	shl    $0x4,%rcx
  1014c2:	4c 01 f1             	add    %r14,%rcx
            ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  1014c5:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  1014c9:	48 89 30             	mov    %rsi,(%rax)
            ptrs_with_size[i].size = curr->sz;
  1014cc:	48 8b 72 10          	mov    0x10(%rdx),%rsi
  1014d0:	48 89 70 08          	mov    %rsi,0x8(%rax)
        for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  1014d4:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1014d8:	48 83 c0 10          	add    $0x10,%rax
  1014dc:	48 39 c8             	cmp    %rcx,%rax
  1014df:	75 e4                	jne    1014c5 <heap_info+0xac>
        __quicksort(ptrs_with_size, alloc_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_size_descending);
  1014e1:	b9 88 0a 10 00       	mov    $0x100a88,%ecx
  1014e6:	ba 10 00 00 00       	mov    $0x10,%edx
  1014eb:	48 89 fe             	mov    %rdi,%rsi
  1014ee:	4c 89 f7             	mov    %r14,%rdi
  1014f1:	e8 9a f5 ff ff       	callq  100a90 <__quicksort>
        long *size_array = (long *) malloc(sizeof(long) * alloc_list_length);
  1014f6:	48 63 3d 1b 0b 00 00 	movslq 0xb1b(%rip),%rdi        # 102018 <alloc_list_length>
  1014fd:	48 c1 e7 03          	shl    $0x3,%rdi
  101501:	e8 92 fc ff ff       	callq  101198 <malloc>
  101506:	49 89 c5             	mov    %rax,%r13
        uintptr_t *ptr_array = (uintptr_t *) malloc(sizeof(uintptr_t) * alloc_list_length);
  101509:	48 63 3d 08 0b 00 00 	movslq 0xb08(%rip),%rdi        # 102018 <alloc_list_length>
  101510:	48 c1 e7 03          	shl    $0x3,%rdi
  101514:	e8 7f fc ff ff       	callq  101198 <malloc>
        if (size_array == NULL || ptr_array == NULL) return -1;
  101519:	4d 85 ed             	test   %r13,%r13
  10151c:	74 46                	je     101564 <heap_info+0x14b>
  10151e:	48 85 c0             	test   %rax,%rax
  101521:	74 41                	je     101564 <heap_info+0x14b>
        for (int i = 0; i < alloc_list_length; i++) {
  101523:	4c 89 f1             	mov    %r14,%rcx
  101526:	ba 00 00 00 00       	mov    $0x0,%edx
  10152b:	83 3d e6 0a 00 00 00 	cmpl   $0x0,0xae6(%rip)        # 102018 <alloc_list_length>
  101532:	7e 20                	jle    101554 <heap_info+0x13b>
            size_array[i] = ptrs_with_size[i].size;
  101534:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  101538:	49 89 74 d5 00       	mov    %rsi,0x0(%r13,%rdx,8)
            ptr_array[i] = (uintptr_t) ptrs_with_size[i].ptr;
  10153d:	48 8b 31             	mov    (%rcx),%rsi
  101540:	48 89 34 d0          	mov    %rsi,(%rax,%rdx,8)
        for (int i = 0; i < alloc_list_length; i++) {
  101544:	48 83 c2 01          	add    $0x1,%rdx
  101548:	48 83 c1 10          	add    $0x10,%rcx
  10154c:	39 15 c6 0a 00 00    	cmp    %edx,0xac6(%rip)        # 102018 <alloc_list_length>
  101552:	7f e0                	jg     101534 <heap_info+0x11b>
        info->size_array = size_array;
  101554:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
        info->ptr_array = (void **) ptr_array;
  101558:	48 89 43 10          	mov    %rax,0x10(%rbx)
  10155c:	4c 89 e4             	mov    %r12,%rsp
  10155f:	e9 df fe ff ff       	jmpq   101443 <heap_info+0x2a>
        if (size_array == NULL || ptr_array == NULL) return -1;
  101564:	4c 89 e4             	mov    %r12,%rsp
  101567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10156c:	e9 1d ff ff ff       	jmpq   10148e <heap_info+0x75>
    size_t largest_free_chunk = 0;
  101571:	ba 00 00 00 00       	mov    $0x0,%edx
    size_t free_space = 0;
  101576:	bf 00 00 00 00       	mov    $0x0,%edi
  10157b:	e9 03 ff ff ff       	jmpq   101483 <heap_info+0x6a>

0000000000101580 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  101580:	55                   	push   %rbp
  101581:	48 89 e5             	mov    %rsp,%rbp
  101584:	48 83 ec 50          	sub    $0x50,%rsp
  101588:	49 89 f2             	mov    %rsi,%r10
  10158b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  10158f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  101593:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101597:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  10159b:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  1015a0:	85 ff                	test   %edi,%edi
  1015a2:	78 2e                	js     1015d2 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  1015a4:	48 63 ff             	movslq %edi,%rdi
  1015a7:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  1015ae:	cc cc cc 
  1015b1:	48 89 f8             	mov    %rdi,%rax
  1015b4:	48 f7 e2             	mul    %rdx
  1015b7:	48 89 d0             	mov    %rdx,%rax
  1015ba:	48 c1 e8 02          	shr    $0x2,%rax
  1015be:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  1015c2:	48 01 c2             	add    %rax,%rdx
  1015c5:	48 29 d7             	sub    %rdx,%rdi
  1015c8:	0f b6 b7 5d 19 10 00 	movzbl 0x10195d(%rdi),%esi
  1015cf:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1015d2:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  1015d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1015dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1015e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1015e5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  1015e9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1015ed:	4c 89 d2             	mov    %r10,%rdx
  1015f0:	8b 3d 06 7a fb ff    	mov    -0x485fa(%rip),%edi        # b8ffc <cursorpos>
  1015f6:	e8 6b f3 ff ff       	callq  100966 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  1015fb:	3d 30 07 00 00       	cmp    $0x730,%eax
  101600:	ba 00 00 00 00       	mov    $0x0,%edx
  101605:	0f 4d c2             	cmovge %edx,%eax
  101608:	89 05 ee 79 fb ff    	mov    %eax,-0x48612(%rip)        # b8ffc <cursorpos>
    }
}
  10160e:	c9                   	leaveq 
  10160f:	c3                   	retq   

0000000000101610 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  101610:	55                   	push   %rbp
  101611:	48 89 e5             	mov    %rsp,%rbp
  101614:	53                   	push   %rbx
  101615:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  10161c:	48 89 fb             	mov    %rdi,%rbx
  10161f:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  101623:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  101627:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  10162b:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  10162f:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  101633:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  10163a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10163e:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  101642:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  101646:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  10164a:	ba 07 00 00 00       	mov    $0x7,%edx
  10164f:	be 29 19 10 00       	mov    $0x101929,%esi
  101654:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  10165b:	e8 ad ea ff ff       	callq  10010d <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  101660:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  101664:	48 89 da             	mov    %rbx,%rdx
  101667:	be 99 00 00 00       	mov    $0x99,%esi
  10166c:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  101673:	e8 69 f3 ff ff       	callq  1009e1 <vsnprintf>
  101678:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  10167b:	85 d2                	test   %edx,%edx
  10167d:	7e 0f                	jle    10168e <kernel_panic+0x7e>
  10167f:	83 c0 06             	add    $0x6,%eax
  101682:	48 98                	cltq   
  101684:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  10168b:	0a 
  10168c:	75 2a                	jne    1016b8 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  10168e:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  101695:	48 89 d9             	mov    %rbx,%rcx
  101698:	ba 33 19 10 00       	mov    $0x101933,%edx
  10169d:	be 00 c0 00 00       	mov    $0xc000,%esi
  1016a2:	bf 30 07 00 00       	mov    $0x730,%edi
  1016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  1016ac:	e8 fa f2 ff ff       	callq  1009ab <console_printf>
    asm volatile ("int %0" : /* no result */
  1016b1:	48 89 df             	mov    %rbx,%rdi
  1016b4:	cd 30                	int    $0x30
 loop: goto loop;
  1016b6:	eb fe                	jmp    1016b6 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  1016b8:	48 63 c2             	movslq %edx,%rax
  1016bb:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  1016c1:	0f 94 c2             	sete   %dl
  1016c4:	0f b6 d2             	movzbl %dl,%edx
  1016c7:	48 29 d0             	sub    %rdx,%rax
  1016ca:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1016d1:	ff 
  1016d2:	be 31 19 10 00       	mov    $0x101931,%esi
  1016d7:	e8 f3 ea ff ff       	callq  1001cf <strcpy>
  1016dc:	eb b0                	jmp    10168e <kernel_panic+0x7e>

00000000001016de <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  1016de:	55                   	push   %rbp
  1016df:	48 89 e5             	mov    %rsp,%rbp
  1016e2:	48 89 f9             	mov    %rdi,%rcx
  1016e5:	41 89 f0             	mov    %esi,%r8d
  1016e8:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  1016eb:	ba 38 19 10 00       	mov    $0x101938,%edx
  1016f0:	be 00 c0 00 00       	mov    $0xc000,%esi
  1016f5:	bf 30 07 00 00       	mov    $0x730,%edi
  1016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  1016ff:	e8 a7 f2 ff ff       	callq  1009ab <console_printf>
    asm volatile ("int %0" : /* no result */
  101704:	bf 00 00 00 00       	mov    $0x0,%edi
  101709:	cd 30                	int    $0x30
 loop: goto loop;
  10170b:	eb fe                	jmp    10170b <assert_fail+0x2d>
