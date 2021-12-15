
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  1c0000:	55                   	push   %rbp
  1c0001:	48 89 e5             	mov    %rsp,%rbp
  1c0004:	53                   	push   %rbx
  1c0005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c0009:	cd 31                	int    $0x31
  1c000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();
    srand(p);
  1c000d:	89 c7                	mov    %eax,%edi
  1c000f:	e8 87 02 00 00       	callq  1c029b <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0014:	b8 27 20 1c 00       	mov    $0x1c2027,%eax
  1c0019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c001f:	48 89 05 ea 0f 00 00 	mov    %rax,0xfea(%rip)        # 1c1010 <heap_top>
  1c0026:	48 89 05 db 0f 00 00 	mov    %rax,0xfdb(%rip)        # 1c1008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c002d:	48 89 e2             	mov    %rsp,%rdx
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c0030:	48 83 ea 01          	sub    $0x1,%rdx
  1c0034:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  1c003b:	48 89 15 be 0f 00 00 	mov    %rdx,0xfbe(%rip)        # 1c1000 <stack_bottom>

    while(heap_top + PAGESIZE < stack_bottom) {
  1c0042:	48 05 00 10 00 00    	add    $0x1000,%rax
  1c0048:	48 39 c2             	cmp    %rax,%rdx
  1c004b:	76 3a                	jbe    1c0087 <process_main+0x87>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  1c004d:	bf 00 10 00 00       	mov    $0x1000,%edi
  1c0052:	cd 3a                	int    $0x3a
  1c0054:	48 89 05 bd 0f 00 00 	mov    %rax,0xfbd(%rip)        # 1c1018 <result.0>

        void * ret = sbrk(PAGESIZE);
        if(ret == (void *) -1) break;
  1c005b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1c005f:	74 26                	je     1c0087 <process_main+0x87>

        *heap_top = p;      /* check we have write access to new page */
  1c0061:	48 8b 15 a8 0f 00 00 	mov    0xfa8(%rip),%rdx        # 1c1010 <heap_top>
  1c0068:	88 1a                	mov    %bl,(%rdx)
        heap_top = (uint8_t *)ret + PAGESIZE;
  1c006a:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  1c0071:	48 89 15 98 0f 00 00 	mov    %rdx,0xf98(%rip)        # 1c1010 <heap_top>
    while(heap_top + PAGESIZE < stack_bottom) {
  1c0078:	48 05 00 20 00 00    	add    $0x2000,%rax
  1c007e:	48 39 05 7b 0f 00 00 	cmp    %rax,0xf7b(%rip)        # 1c1000 <stack_bottom>
  1c0085:	77 cb                	ja     1c0052 <process_main+0x52>
    }

    TEST_PASS();
  1c0087:	bf 40 0c 1c 00       	mov    $0x1c0c40,%edi
  1c008c:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0091:	e8 a1 0a 00 00       	callq  1c0b37 <kernel_panic>

00000000001c0096 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0096:	48 89 f9             	mov    %rdi,%rcx
  1c0099:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c009b:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1c00a2:	00 
  1c00a3:	72 08                	jb     1c00ad <console_putc+0x17>
        cp->cursor = console;
  1c00a5:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1c00ac:	00 
    }
    if (c == '\n') {
  1c00ad:	40 80 fe 0a          	cmp    $0xa,%sil
  1c00b1:	74 16                	je     1c00c9 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1c00b3:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1c00b7:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1c00bb:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1c00bf:	40 0f b6 f6          	movzbl %sil,%esi
  1c00c3:	09 fe                	or     %edi,%esi
  1c00c5:	66 89 30             	mov    %si,(%rax)
    }
}
  1c00c8:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1c00c9:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1c00cd:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1c00d4:	4c 89 c6             	mov    %r8,%rsi
  1c00d7:	48 d1 fe             	sar    %rsi
  1c00da:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c00e1:	66 66 66 
  1c00e4:	48 89 f0             	mov    %rsi,%rax
  1c00e7:	48 f7 ea             	imul   %rdx
  1c00ea:	48 c1 fa 05          	sar    $0x5,%rdx
  1c00ee:	49 c1 f8 3f          	sar    $0x3f,%r8
  1c00f2:	4c 29 c2             	sub    %r8,%rdx
  1c00f5:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1c00f9:	48 c1 e2 04          	shl    $0x4,%rdx
  1c00fd:	89 f0                	mov    %esi,%eax
  1c00ff:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1c0101:	83 cf 20             	or     $0x20,%edi
  1c0104:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0108:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1c010c:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1c0110:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1c0113:	83 c0 01             	add    $0x1,%eax
  1c0116:	83 f8 50             	cmp    $0x50,%eax
  1c0119:	75 e9                	jne    1c0104 <console_putc+0x6e>
  1c011b:	c3                   	retq   

00000000001c011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1c011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1c0120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1c0124:	73 0b                	jae    1c0131 <string_putc+0x15>
        *sp->s++ = c;
  1c0126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1c012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1c0131:	c3                   	retq   

00000000001c0132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1c0132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0135:	48 85 d2             	test   %rdx,%rdx
  1c0138:	74 17                	je     1c0151 <memcpy+0x1f>
  1c013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1c013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1c0144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0148:	48 83 c1 01          	add    $0x1,%rcx
  1c014c:	48 39 d1             	cmp    %rdx,%rcx
  1c014f:	75 ee                	jne    1c013f <memcpy+0xd>
}
  1c0151:	c3                   	retq   

00000000001c0152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1c0152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1c0155:	48 39 fe             	cmp    %rdi,%rsi
  1c0158:	72 1d                	jb     1c0177 <memmove+0x25>
        while (n-- > 0) {
  1c015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  1c015f:	48 85 d2             	test   %rdx,%rdx
  1c0162:	74 12                	je     1c0176 <memmove+0x24>
            *d++ = *s++;
  1c0164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1c0168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1c016c:	48 83 c1 01          	add    $0x1,%rcx
  1c0170:	48 39 ca             	cmp    %rcx,%rdx
  1c0173:	75 ef                	jne    1c0164 <memmove+0x12>
}
  1c0175:	c3                   	retq   
  1c0176:	c3                   	retq   
    if (s < d && s + n > d) {
  1c0177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  1c017b:	48 39 cf             	cmp    %rcx,%rdi
  1c017e:	73 da                	jae    1c015a <memmove+0x8>
        while (n-- > 0) {
  1c0180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  1c0184:	48 85 d2             	test   %rdx,%rdx
  1c0187:	74 ec                	je     1c0175 <memmove+0x23>
            *--d = *--s;
  1c0189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1c018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1c0190:	48 83 e9 01          	sub    $0x1,%rcx
  1c0194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1c0198:	75 ef                	jne    1c0189 <memmove+0x37>
  1c019a:	c3                   	retq   

00000000001c019b <memset>:
void* memset(void* v, int c, size_t n) {
  1c019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c019e:	48 85 d2             	test   %rdx,%rdx
  1c01a1:	74 12                	je     1c01b5 <memset+0x1a>
  1c01a3:	48 01 fa             	add    %rdi,%rdx
  1c01a6:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1c01a9:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01ac:	48 83 c1 01          	add    $0x1,%rcx
  1c01b0:	48 39 ca             	cmp    %rcx,%rdx
  1c01b3:	75 f4                	jne    1c01a9 <memset+0xe>
}
  1c01b5:	c3                   	retq   

00000000001c01b6 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1c01b6:	80 3f 00             	cmpb   $0x0,(%rdi)
  1c01b9:	74 10                	je     1c01cb <strlen+0x15>
  1c01bb:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1c01c0:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1c01c4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1c01c8:	75 f6                	jne    1c01c0 <strlen+0xa>
  1c01ca:	c3                   	retq   
  1c01cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1c01d0:	c3                   	retq   

00000000001c01d1 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1c01d1:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1c01d9:	48 85 f6             	test   %rsi,%rsi
  1c01dc:	74 11                	je     1c01ef <strnlen+0x1e>
  1c01de:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1c01e2:	74 0c                	je     1c01f0 <strnlen+0x1f>
        ++n;
  1c01e4:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01e8:	48 39 d0             	cmp    %rdx,%rax
  1c01eb:	75 f1                	jne    1c01de <strnlen+0xd>
  1c01ed:	eb 04                	jmp    1c01f3 <strnlen+0x22>
  1c01ef:	c3                   	retq   
  1c01f0:	48 89 d0             	mov    %rdx,%rax
}
  1c01f3:	c3                   	retq   

00000000001c01f4 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1c01f4:	48 89 f8             	mov    %rdi,%rax
  1c01f7:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1c01fc:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1c0200:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1c0203:	48 83 c2 01          	add    $0x1,%rdx
  1c0207:	84 c9                	test   %cl,%cl
  1c0209:	75 f1                	jne    1c01fc <strcpy+0x8>
}
  1c020b:	c3                   	retq   

00000000001c020c <strcmp>:
    while (*a && *b && *a == *b) {
  1c020c:	0f b6 07             	movzbl (%rdi),%eax
  1c020f:	84 c0                	test   %al,%al
  1c0211:	74 1a                	je     1c022d <strcmp+0x21>
  1c0213:	0f b6 16             	movzbl (%rsi),%edx
  1c0216:	38 c2                	cmp    %al,%dl
  1c0218:	75 13                	jne    1c022d <strcmp+0x21>
  1c021a:	84 d2                	test   %dl,%dl
  1c021c:	74 0f                	je     1c022d <strcmp+0x21>
        ++a, ++b;
  1c021e:	48 83 c7 01          	add    $0x1,%rdi
  1c0222:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1c0226:	0f b6 07             	movzbl (%rdi),%eax
  1c0229:	84 c0                	test   %al,%al
  1c022b:	75 e6                	jne    1c0213 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1c022d:	3a 06                	cmp    (%rsi),%al
  1c022f:	0f 97 c0             	seta   %al
  1c0232:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1c0235:	83 d8 00             	sbb    $0x0,%eax
}
  1c0238:	c3                   	retq   

00000000001c0239 <strchr>:
    while (*s && *s != (char) c) {
  1c0239:	0f b6 07             	movzbl (%rdi),%eax
  1c023c:	84 c0                	test   %al,%al
  1c023e:	74 10                	je     1c0250 <strchr+0x17>
  1c0240:	40 38 f0             	cmp    %sil,%al
  1c0243:	74 18                	je     1c025d <strchr+0x24>
        ++s;
  1c0245:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1c0249:	0f b6 07             	movzbl (%rdi),%eax
  1c024c:	84 c0                	test   %al,%al
  1c024e:	75 f0                	jne    1c0240 <strchr+0x7>
        return NULL;
  1c0250:	40 84 f6             	test   %sil,%sil
  1c0253:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0258:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1c025c:	c3                   	retq   
  1c025d:	48 89 f8             	mov    %rdi,%rax
  1c0260:	c3                   	retq   

00000000001c0261 <rand>:
    if (!rand_seed_set) {
  1c0261:	83 3d bc 0d 00 00 00 	cmpl   $0x0,0xdbc(%rip)        # 1c1024 <rand_seed_set>
  1c0268:	74 1b                	je     1c0285 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c026a:	69 05 ac 0d 00 00 0d 	imul   $0x19660d,0xdac(%rip),%eax        # 1c1020 <rand_seed>
  1c0271:	66 19 00 
  1c0274:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c0279:	89 05 a1 0d 00 00    	mov    %eax,0xda1(%rip)        # 1c1020 <rand_seed>
    return rand_seed & RAND_MAX;
  1c027f:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c0284:	c3                   	retq   
    rand_seed = seed;
  1c0285:	c7 05 91 0d 00 00 9e 	movl   $0x30d4879e,0xd91(%rip)        # 1c1020 <rand_seed>
  1c028c:	87 d4 30 
    rand_seed_set = 1;
  1c028f:	c7 05 8b 0d 00 00 01 	movl   $0x1,0xd8b(%rip)        # 1c1024 <rand_seed_set>
  1c0296:	00 00 00 
}
  1c0299:	eb cf                	jmp    1c026a <rand+0x9>

00000000001c029b <srand>:
    rand_seed = seed;
  1c029b:	89 3d 7f 0d 00 00    	mov    %edi,0xd7f(%rip)        # 1c1020 <rand_seed>
    rand_seed_set = 1;
  1c02a1:	c7 05 79 0d 00 00 01 	movl   $0x1,0xd79(%rip)        # 1c1024 <rand_seed_set>
  1c02a8:	00 00 00 
}
  1c02ab:	c3                   	retq   

00000000001c02ac <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c02ac:	55                   	push   %rbp
  1c02ad:	48 89 e5             	mov    %rsp,%rbp
  1c02b0:	41 57                	push   %r15
  1c02b2:	41 56                	push   %r14
  1c02b4:	41 55                	push   %r13
  1c02b6:	41 54                	push   %r12
  1c02b8:	53                   	push   %rbx
  1c02b9:	48 83 ec 58          	sub    $0x58,%rsp
  1c02bd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1c02c1:	0f b6 02             	movzbl (%rdx),%eax
  1c02c4:	84 c0                	test   %al,%al
  1c02c6:	0f 84 b0 06 00 00    	je     1c097c <printer_vprintf+0x6d0>
  1c02cc:	49 89 fe             	mov    %rdi,%r14
  1c02cf:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1c02d2:	41 89 f7             	mov    %esi,%r15d
  1c02d5:	e9 a4 04 00 00       	jmpq   1c077e <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1c02da:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1c02df:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1c02e5:	45 84 e4             	test   %r12b,%r12b
  1c02e8:	0f 84 82 06 00 00    	je     1c0970 <printer_vprintf+0x6c4>
        int flags = 0;
  1c02ee:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1c02f4:	41 0f be f4          	movsbl %r12b,%esi
  1c02f8:	bf 61 0e 1c 00       	mov    $0x1c0e61,%edi
  1c02fd:	e8 37 ff ff ff       	callq  1c0239 <strchr>
  1c0302:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1c0305:	48 85 c0             	test   %rax,%rax
  1c0308:	74 55                	je     1c035f <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1c030a:	48 81 e9 61 0e 1c 00 	sub    $0x1c0e61,%rcx
  1c0311:	b8 01 00 00 00       	mov    $0x1,%eax
  1c0316:	d3 e0                	shl    %cl,%eax
  1c0318:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1c031b:	48 83 c3 01          	add    $0x1,%rbx
  1c031f:	44 0f b6 23          	movzbl (%rbx),%r12d
  1c0323:	45 84 e4             	test   %r12b,%r12b
  1c0326:	75 cc                	jne    1c02f4 <printer_vprintf+0x48>
  1c0328:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1c032c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1c0332:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1c0339:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1c033c:	0f 84 a9 00 00 00    	je     1c03eb <printer_vprintf+0x13f>
        int length = 0;
  1c0342:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1c0347:	0f b6 13             	movzbl (%rbx),%edx
  1c034a:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1c034d:	3c 37                	cmp    $0x37,%al
  1c034f:	0f 87 c4 04 00 00    	ja     1c0819 <printer_vprintf+0x56d>
  1c0355:	0f b6 c0             	movzbl %al,%eax
  1c0358:	ff 24 c5 70 0c 1c 00 	jmpq   *0x1c0c70(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  1c035f:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  1c0363:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1c0368:	3c 08                	cmp    $0x8,%al
  1c036a:	77 2f                	ja     1c039b <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c036c:	0f b6 03             	movzbl (%rbx),%eax
  1c036f:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c0372:	80 fa 09             	cmp    $0x9,%dl
  1c0375:	77 5e                	ja     1c03d5 <printer_vprintf+0x129>
  1c0377:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1c037d:	48 83 c3 01          	add    $0x1,%rbx
  1c0381:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1c0386:	0f be c0             	movsbl %al,%eax
  1c0389:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c038e:	0f b6 03             	movzbl (%rbx),%eax
  1c0391:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c0394:	80 fa 09             	cmp    $0x9,%dl
  1c0397:	76 e4                	jbe    1c037d <printer_vprintf+0xd1>
  1c0399:	eb 97                	jmp    1c0332 <printer_vprintf+0x86>
        } else if (*format == '*') {
  1c039b:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1c039f:	75 3f                	jne    1c03e0 <printer_vprintf+0x134>
            width = va_arg(val, int);
  1c03a1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c03a5:	8b 07                	mov    (%rdi),%eax
  1c03a7:	83 f8 2f             	cmp    $0x2f,%eax
  1c03aa:	77 17                	ja     1c03c3 <printer_vprintf+0x117>
  1c03ac:	89 c2                	mov    %eax,%edx
  1c03ae:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c03b2:	83 c0 08             	add    $0x8,%eax
  1c03b5:	89 07                	mov    %eax,(%rdi)
  1c03b7:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1c03ba:	48 83 c3 01          	add    $0x1,%rbx
  1c03be:	e9 6f ff ff ff       	jmpq   1c0332 <printer_vprintf+0x86>
            width = va_arg(val, int);
  1c03c3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c03c7:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c03cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c03cf:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c03d3:	eb e2                	jmp    1c03b7 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c03d5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1c03db:	e9 52 ff ff ff       	jmpq   1c0332 <printer_vprintf+0x86>
        int width = -1;
  1c03e0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1c03e6:	e9 47 ff ff ff       	jmpq   1c0332 <printer_vprintf+0x86>
            ++format;
  1c03eb:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1c03ef:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c03f3:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1c03f6:	80 f9 09             	cmp    $0x9,%cl
  1c03f9:	76 13                	jbe    1c040e <printer_vprintf+0x162>
            } else if (*format == '*') {
  1c03fb:	3c 2a                	cmp    $0x2a,%al
  1c03fd:	74 33                	je     1c0432 <printer_vprintf+0x186>
            ++format;
  1c03ff:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1c0402:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1c0409:	e9 34 ff ff ff       	jmpq   1c0342 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c040e:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1c0413:	48 83 c2 01          	add    $0x1,%rdx
  1c0417:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1c041a:	0f be c0             	movsbl %al,%eax
  1c041d:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0421:	0f b6 02             	movzbl (%rdx),%eax
  1c0424:	8d 70 d0             	lea    -0x30(%rax),%esi
  1c0427:	40 80 fe 09          	cmp    $0x9,%sil
  1c042b:	76 e6                	jbe    1c0413 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  1c042d:	48 89 d3             	mov    %rdx,%rbx
  1c0430:	eb 1c                	jmp    1c044e <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  1c0432:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0436:	8b 07                	mov    (%rdi),%eax
  1c0438:	83 f8 2f             	cmp    $0x2f,%eax
  1c043b:	77 23                	ja     1c0460 <printer_vprintf+0x1b4>
  1c043d:	89 c2                	mov    %eax,%edx
  1c043f:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c0443:	83 c0 08             	add    $0x8,%eax
  1c0446:	89 07                	mov    %eax,(%rdi)
  1c0448:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1c044a:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1c044e:	85 c9                	test   %ecx,%ecx
  1c0450:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0455:	0f 49 c1             	cmovns %ecx,%eax
  1c0458:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1c045b:	e9 e2 fe ff ff       	jmpq   1c0342 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  1c0460:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0464:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0468:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c046c:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0470:	eb d6                	jmp    1c0448 <printer_vprintf+0x19c>
        switch (*format) {
  1c0472:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c0477:	e9 f3 00 00 00       	jmpq   1c056f <printer_vprintf+0x2c3>
            ++format;
  1c047c:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  1c0480:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  1c0485:	e9 bd fe ff ff       	jmpq   1c0347 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c048a:	85 c9                	test   %ecx,%ecx
  1c048c:	74 55                	je     1c04e3 <printer_vprintf+0x237>
  1c048e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0492:	8b 07                	mov    (%rdi),%eax
  1c0494:	83 f8 2f             	cmp    $0x2f,%eax
  1c0497:	77 38                	ja     1c04d1 <printer_vprintf+0x225>
  1c0499:	89 c2                	mov    %eax,%edx
  1c049b:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c049f:	83 c0 08             	add    $0x8,%eax
  1c04a2:	89 07                	mov    %eax,(%rdi)
  1c04a4:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c04a7:	48 89 d0             	mov    %rdx,%rax
  1c04aa:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1c04ae:	49 89 d0             	mov    %rdx,%r8
  1c04b1:	49 f7 d8             	neg    %r8
  1c04b4:	25 80 00 00 00       	and    $0x80,%eax
  1c04b9:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c04bd:	0b 45 a8             	or     -0x58(%rbp),%eax
  1c04c0:	83 c8 60             	or     $0x60,%eax
  1c04c3:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1c04c6:	41 bc 70 0e 1c 00    	mov    $0x1c0e70,%r12d
            break;
  1c04cc:	e9 35 01 00 00       	jmpq   1c0606 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c04d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c04d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c04d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c04dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c04e1:	eb c1                	jmp    1c04a4 <printer_vprintf+0x1f8>
  1c04e3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04e7:	8b 07                	mov    (%rdi),%eax
  1c04e9:	83 f8 2f             	cmp    $0x2f,%eax
  1c04ec:	77 10                	ja     1c04fe <printer_vprintf+0x252>
  1c04ee:	89 c2                	mov    %eax,%edx
  1c04f0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c04f4:	83 c0 08             	add    $0x8,%eax
  1c04f7:	89 07                	mov    %eax,(%rdi)
  1c04f9:	48 63 12             	movslq (%rdx),%rdx
  1c04fc:	eb a9                	jmp    1c04a7 <printer_vprintf+0x1fb>
  1c04fe:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0502:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0506:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c050a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c050e:	eb e9                	jmp    1c04f9 <printer_vprintf+0x24d>
        int base = 10;
  1c0510:	be 0a 00 00 00       	mov    $0xa,%esi
  1c0515:	eb 58                	jmp    1c056f <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c0517:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c051b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c051f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0523:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0527:	eb 60                	jmp    1c0589 <printer_vprintf+0x2dd>
  1c0529:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c052d:	8b 07                	mov    (%rdi),%eax
  1c052f:	83 f8 2f             	cmp    $0x2f,%eax
  1c0532:	77 10                	ja     1c0544 <printer_vprintf+0x298>
  1c0534:	89 c2                	mov    %eax,%edx
  1c0536:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c053a:	83 c0 08             	add    $0x8,%eax
  1c053d:	89 07                	mov    %eax,(%rdi)
  1c053f:	44 8b 02             	mov    (%rdx),%r8d
  1c0542:	eb 48                	jmp    1c058c <printer_vprintf+0x2e0>
  1c0544:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0548:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c054c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0550:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0554:	eb e9                	jmp    1c053f <printer_vprintf+0x293>
  1c0556:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1c0559:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1c0560:	bf 50 0e 1c 00       	mov    $0x1c0e50,%edi
  1c0565:	e9 e2 02 00 00       	jmpq   1c084c <printer_vprintf+0x5a0>
            base = 16;
  1c056a:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c056f:	85 c9                	test   %ecx,%ecx
  1c0571:	74 b6                	je     1c0529 <printer_vprintf+0x27d>
  1c0573:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0577:	8b 01                	mov    (%rcx),%eax
  1c0579:	83 f8 2f             	cmp    $0x2f,%eax
  1c057c:	77 99                	ja     1c0517 <printer_vprintf+0x26b>
  1c057e:	89 c2                	mov    %eax,%edx
  1c0580:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c0584:	83 c0 08             	add    $0x8,%eax
  1c0587:	89 01                	mov    %eax,(%rcx)
  1c0589:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1c058c:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  1c0590:	85 f6                	test   %esi,%esi
  1c0592:	79 c2                	jns    1c0556 <printer_vprintf+0x2aa>
        base = -base;
  1c0594:	41 89 f1             	mov    %esi,%r9d
  1c0597:	f7 de                	neg    %esi
  1c0599:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1c05a0:	bf 30 0e 1c 00       	mov    $0x1c0e30,%edi
  1c05a5:	e9 a2 02 00 00       	jmpq   1c084c <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1c05aa:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c05ae:	8b 07                	mov    (%rdi),%eax
  1c05b0:	83 f8 2f             	cmp    $0x2f,%eax
  1c05b3:	77 1c                	ja     1c05d1 <printer_vprintf+0x325>
  1c05b5:	89 c2                	mov    %eax,%edx
  1c05b7:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c05bb:	83 c0 08             	add    $0x8,%eax
  1c05be:	89 07                	mov    %eax,(%rdi)
  1c05c0:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c05c3:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1c05ca:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c05cf:	eb c3                	jmp    1c0594 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1c05d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c05d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c05dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c05e1:	eb dd                	jmp    1c05c0 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1c05e3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05e7:	8b 01                	mov    (%rcx),%eax
  1c05e9:	83 f8 2f             	cmp    $0x2f,%eax
  1c05ec:	0f 87 a5 01 00 00    	ja     1c0797 <printer_vprintf+0x4eb>
  1c05f2:	89 c2                	mov    %eax,%edx
  1c05f4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c05f8:	83 c0 08             	add    $0x8,%eax
  1c05fb:	89 01                	mov    %eax,(%rcx)
  1c05fd:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1c0600:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1c0606:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0609:	83 e0 20             	and    $0x20,%eax
  1c060c:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1c060f:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1c0615:	0f 85 21 02 00 00    	jne    1c083c <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c061b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c061e:	89 45 88             	mov    %eax,-0x78(%rbp)
  1c0621:	83 e0 60             	and    $0x60,%eax
  1c0624:	83 f8 60             	cmp    $0x60,%eax
  1c0627:	0f 84 54 02 00 00    	je     1c0881 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c062d:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0630:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1c0633:	48 c7 45 a0 70 0e 1c 	movq   $0x1c0e70,-0x60(%rbp)
  1c063a:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c063b:	83 f8 21             	cmp    $0x21,%eax
  1c063e:	0f 84 79 02 00 00    	je     1c08bd <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c0644:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1c0647:	89 f8                	mov    %edi,%eax
  1c0649:	f7 d0                	not    %eax
  1c064b:	c1 e8 1f             	shr    $0x1f,%eax
  1c064e:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1c0651:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c0655:	0f 85 9e 02 00 00    	jne    1c08f9 <printer_vprintf+0x64d>
  1c065b:	84 c0                	test   %al,%al
  1c065d:	0f 84 96 02 00 00    	je     1c08f9 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  1c0663:	48 63 f7             	movslq %edi,%rsi
  1c0666:	4c 89 e7             	mov    %r12,%rdi
  1c0669:	e8 63 fb ff ff       	callq  1c01d1 <strnlen>
  1c066e:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c0671:	8b 45 88             	mov    -0x78(%rbp),%eax
  1c0674:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1c0677:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c067e:	83 f8 22             	cmp    $0x22,%eax
  1c0681:	0f 84 aa 02 00 00    	je     1c0931 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  1c0687:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c068b:	e8 26 fb ff ff       	callq  1c01b6 <strlen>
  1c0690:	8b 55 9c             	mov    -0x64(%rbp),%edx
  1c0693:	03 55 98             	add    -0x68(%rbp),%edx
  1c0696:	44 89 e9             	mov    %r13d,%ecx
  1c0699:	29 d1                	sub    %edx,%ecx
  1c069b:	29 c1                	sub    %eax,%ecx
  1c069d:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1c06a0:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06a3:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1c06a7:	75 2d                	jne    1c06d6 <printer_vprintf+0x42a>
  1c06a9:	85 c9                	test   %ecx,%ecx
  1c06ab:	7e 29                	jle    1c06d6 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1c06ad:	44 89 fa             	mov    %r15d,%edx
  1c06b0:	be 20 00 00 00       	mov    $0x20,%esi
  1c06b5:	4c 89 f7             	mov    %r14,%rdi
  1c06b8:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06bb:	41 83 ed 01          	sub    $0x1,%r13d
  1c06bf:	45 85 ed             	test   %r13d,%r13d
  1c06c2:	7f e9                	jg     1c06ad <printer_vprintf+0x401>
  1c06c4:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1c06c7:	85 ff                	test   %edi,%edi
  1c06c9:	b8 01 00 00 00       	mov    $0x1,%eax
  1c06ce:	0f 4f c7             	cmovg  %edi,%eax
  1c06d1:	29 c7                	sub    %eax,%edi
  1c06d3:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1c06d6:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c06da:	0f b6 07             	movzbl (%rdi),%eax
  1c06dd:	84 c0                	test   %al,%al
  1c06df:	74 22                	je     1c0703 <printer_vprintf+0x457>
  1c06e1:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c06e5:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1c06e8:	0f b6 f0             	movzbl %al,%esi
  1c06eb:	44 89 fa             	mov    %r15d,%edx
  1c06ee:	4c 89 f7             	mov    %r14,%rdi
  1c06f1:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1c06f4:	48 83 c3 01          	add    $0x1,%rbx
  1c06f8:	0f b6 03             	movzbl (%rbx),%eax
  1c06fb:	84 c0                	test   %al,%al
  1c06fd:	75 e9                	jne    1c06e8 <printer_vprintf+0x43c>
  1c06ff:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1c0703:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1c0706:	85 c0                	test   %eax,%eax
  1c0708:	7e 1d                	jle    1c0727 <printer_vprintf+0x47b>
  1c070a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c070e:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1c0710:	44 89 fa             	mov    %r15d,%edx
  1c0713:	be 30 00 00 00       	mov    $0x30,%esi
  1c0718:	4c 89 f7             	mov    %r14,%rdi
  1c071b:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1c071e:	83 eb 01             	sub    $0x1,%ebx
  1c0721:	75 ed                	jne    1c0710 <printer_vprintf+0x464>
  1c0723:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1c0727:	8b 45 98             	mov    -0x68(%rbp),%eax
  1c072a:	85 c0                	test   %eax,%eax
  1c072c:	7e 27                	jle    1c0755 <printer_vprintf+0x4a9>
  1c072e:	89 c0                	mov    %eax,%eax
  1c0730:	4c 01 e0             	add    %r12,%rax
  1c0733:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c0737:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1c073a:	41 0f b6 34 24       	movzbl (%r12),%esi
  1c073f:	44 89 fa             	mov    %r15d,%edx
  1c0742:	4c 89 f7             	mov    %r14,%rdi
  1c0745:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1c0748:	49 83 c4 01          	add    $0x1,%r12
  1c074c:	49 39 dc             	cmp    %rbx,%r12
  1c074f:	75 e9                	jne    1c073a <printer_vprintf+0x48e>
  1c0751:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1c0755:	45 85 ed             	test   %r13d,%r13d
  1c0758:	7e 14                	jle    1c076e <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  1c075a:	44 89 fa             	mov    %r15d,%edx
  1c075d:	be 20 00 00 00       	mov    $0x20,%esi
  1c0762:	4c 89 f7             	mov    %r14,%rdi
  1c0765:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1c0768:	41 83 ed 01          	sub    $0x1,%r13d
  1c076c:	75 ec                	jne    1c075a <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  1c076e:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  1c0772:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c0776:	84 c0                	test   %al,%al
  1c0778:	0f 84 fe 01 00 00    	je     1c097c <printer_vprintf+0x6d0>
        if (*format != '%') {
  1c077e:	3c 25                	cmp    $0x25,%al
  1c0780:	0f 84 54 fb ff ff    	je     1c02da <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  1c0786:	0f b6 f0             	movzbl %al,%esi
  1c0789:	44 89 fa             	mov    %r15d,%edx
  1c078c:	4c 89 f7             	mov    %r14,%rdi
  1c078f:	41 ff 16             	callq  *(%r14)
            continue;
  1c0792:	4c 89 e3             	mov    %r12,%rbx
  1c0795:	eb d7                	jmp    1c076e <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  1c0797:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c079b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c079f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c07a3:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c07a7:	e9 51 fe ff ff       	jmpq   1c05fd <printer_vprintf+0x351>
            color = va_arg(val, int);
  1c07ac:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c07b0:	8b 07                	mov    (%rdi),%eax
  1c07b2:	83 f8 2f             	cmp    $0x2f,%eax
  1c07b5:	77 10                	ja     1c07c7 <printer_vprintf+0x51b>
  1c07b7:	89 c2                	mov    %eax,%edx
  1c07b9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c07bd:	83 c0 08             	add    $0x8,%eax
  1c07c0:	89 07                	mov    %eax,(%rdi)
  1c07c2:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1c07c5:	eb a7                	jmp    1c076e <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1c07c7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07cb:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c07cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c07d3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c07d7:	eb e9                	jmp    1c07c2 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1c07d9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07dd:	8b 01                	mov    (%rcx),%eax
  1c07df:	83 f8 2f             	cmp    $0x2f,%eax
  1c07e2:	77 23                	ja     1c0807 <printer_vprintf+0x55b>
  1c07e4:	89 c2                	mov    %eax,%edx
  1c07e6:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c07ea:	83 c0 08             	add    $0x8,%eax
  1c07ed:	89 01                	mov    %eax,(%rcx)
  1c07ef:	8b 02                	mov    (%rdx),%eax
  1c07f1:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1c07f4:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c07f8:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c07fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1c0802:	e9 ff fd ff ff       	jmpq   1c0606 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  1c0807:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c080b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c080f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0813:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c0817:	eb d6                	jmp    1c07ef <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  1c0819:	84 d2                	test   %dl,%dl
  1c081b:	0f 85 39 01 00 00    	jne    1c095a <printer_vprintf+0x6ae>
  1c0821:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0825:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1c0829:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1c082d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c0837:	e9 ca fd ff ff       	jmpq   1c0606 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  1c083c:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1c0842:	bf 50 0e 1c 00       	mov    $0x1c0e50,%edi
        if (flags & FLAG_NUMERIC) {
  1c0847:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1c084c:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1c0850:	4c 89 c1             	mov    %r8,%rcx
  1c0853:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1c0857:	48 63 f6             	movslq %esi,%rsi
  1c085a:	49 83 ec 01          	sub    $0x1,%r12
  1c085e:	48 89 c8             	mov    %rcx,%rax
  1c0861:	ba 00 00 00 00       	mov    $0x0,%edx
  1c0866:	48 f7 f6             	div    %rsi
  1c0869:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1c086d:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1c0871:	48 89 ca             	mov    %rcx,%rdx
  1c0874:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1c0877:	48 39 d6             	cmp    %rdx,%rsi
  1c087a:	76 de                	jbe    1c085a <printer_vprintf+0x5ae>
  1c087c:	e9 9a fd ff ff       	jmpq   1c061b <printer_vprintf+0x36f>
                prefix = "-";
  1c0881:	48 c7 45 a0 5e 0c 1c 	movq   $0x1c0c5e,-0x60(%rbp)
  1c0888:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0889:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c088c:	a8 80                	test   $0x80,%al
  1c088e:	0f 85 b0 fd ff ff    	jne    1c0644 <printer_vprintf+0x398>
                prefix = "+";
  1c0894:	48 c7 45 a0 59 0c 1c 	movq   $0x1c0c59,-0x60(%rbp)
  1c089b:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c089c:	a8 10                	test   $0x10,%al
  1c089e:	0f 85 a0 fd ff ff    	jne    1c0644 <printer_vprintf+0x398>
                prefix = " ";
  1c08a4:	a8 08                	test   $0x8,%al
  1c08a6:	ba 70 0e 1c 00       	mov    $0x1c0e70,%edx
  1c08ab:	b8 6d 0e 1c 00       	mov    $0x1c0e6d,%eax
  1c08b0:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08b4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08b8:	e9 87 fd ff ff       	jmpq   1c0644 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1c08bd:	41 8d 41 10          	lea    0x10(%r9),%eax
  1c08c1:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1c08c6:	0f 85 78 fd ff ff    	jne    1c0644 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1c08cc:	4d 85 c0             	test   %r8,%r8
  1c08cf:	75 0d                	jne    1c08de <printer_vprintf+0x632>
  1c08d1:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1c08d8:	0f 84 66 fd ff ff    	je     1c0644 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1c08de:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1c08e2:	ba 60 0c 1c 00       	mov    $0x1c0c60,%edx
  1c08e7:	b8 5b 0c 1c 00       	mov    $0x1c0c5b,%eax
  1c08ec:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08f0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08f4:	e9 4b fd ff ff       	jmpq   1c0644 <printer_vprintf+0x398>
            len = strlen(data);
  1c08f9:	4c 89 e7             	mov    %r12,%rdi
  1c08fc:	e8 b5 f8 ff ff       	callq  1c01b6 <strlen>
  1c0901:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c0904:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c0908:	0f 84 63 fd ff ff    	je     1c0671 <printer_vprintf+0x3c5>
  1c090e:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1c0912:	0f 84 59 fd ff ff    	je     1c0671 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  1c0918:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1c091b:	89 ca                	mov    %ecx,%edx
  1c091d:	29 c2                	sub    %eax,%edx
  1c091f:	39 c1                	cmp    %eax,%ecx
  1c0921:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0926:	0f 4e d0             	cmovle %eax,%edx
  1c0929:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1c092c:	e9 56 fd ff ff       	jmpq   1c0687 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  1c0931:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c0935:	e8 7c f8 ff ff       	callq  1c01b6 <strlen>
  1c093a:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1c093d:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1c0940:	44 89 e9             	mov    %r13d,%ecx
  1c0943:	29 f9                	sub    %edi,%ecx
  1c0945:	29 c1                	sub    %eax,%ecx
  1c0947:	44 39 ea             	cmp    %r13d,%edx
  1c094a:	b8 00 00 00 00       	mov    $0x0,%eax
  1c094f:	0f 4d c8             	cmovge %eax,%ecx
  1c0952:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  1c0955:	e9 2d fd ff ff       	jmpq   1c0687 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  1c095a:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1c095d:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c0961:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c096b:	e9 96 fc ff ff       	jmpq   1c0606 <printer_vprintf+0x35a>
        int flags = 0;
  1c0970:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1c0977:	e9 b0 f9 ff ff       	jmpq   1c032c <printer_vprintf+0x80>
}
  1c097c:	48 83 c4 58          	add    $0x58,%rsp
  1c0980:	5b                   	pop    %rbx
  1c0981:	41 5c                	pop    %r12
  1c0983:	41 5d                	pop    %r13
  1c0985:	41 5e                	pop    %r14
  1c0987:	41 5f                	pop    %r15
  1c0989:	5d                   	pop    %rbp
  1c098a:	c3                   	retq   

00000000001c098b <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c098b:	55                   	push   %rbp
  1c098c:	48 89 e5             	mov    %rsp,%rbp
  1c098f:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  1c0993:	48 c7 45 f0 96 00 1c 	movq   $0x1c0096,-0x10(%rbp)
  1c099a:	00 
        cpos = 0;
  1c099b:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1c09a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1c09a6:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1c09a9:	48 63 ff             	movslq %edi,%rdi
  1c09ac:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1c09b3:	00 
  1c09b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c09b8:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1c09bc:	e8 eb f8 ff ff       	callq  1c02ac <printer_vprintf>
    return cp.cursor - console;
  1c09c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c09c5:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c09cb:	48 d1 f8             	sar    %rax
}
  1c09ce:	c9                   	leaveq 
  1c09cf:	c3                   	retq   

00000000001c09d0 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1c09d0:	55                   	push   %rbp
  1c09d1:	48 89 e5             	mov    %rsp,%rbp
  1c09d4:	48 83 ec 50          	sub    $0x50,%rsp
  1c09d8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c09dc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c09e0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1c09e4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c09eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c09ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c09f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c09f7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c09fb:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c09ff:	e8 87 ff ff ff       	callq  1c098b <console_vprintf>
}
  1c0a04:	c9                   	leaveq 
  1c0a05:	c3                   	retq   

00000000001c0a06 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c0a06:	55                   	push   %rbp
  1c0a07:	48 89 e5             	mov    %rsp,%rbp
  1c0a0a:	53                   	push   %rbx
  1c0a0b:	48 83 ec 28          	sub    $0x28,%rsp
  1c0a0f:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1c0a12:	48 c7 45 d8 1c 01 1c 	movq   $0x1c011c,-0x28(%rbp)
  1c0a19:	00 
    sp.s = s;
  1c0a1a:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1c0a1e:	48 85 f6             	test   %rsi,%rsi
  1c0a21:	75 0b                	jne    1c0a2e <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1c0a23:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1c0a26:	29 d8                	sub    %ebx,%eax
}
  1c0a28:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0a2c:	c9                   	leaveq 
  1c0a2d:	c3                   	retq   
        sp.end = s + size - 1;
  1c0a2e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  1c0a33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c0a37:	be 00 00 00 00       	mov    $0x0,%esi
  1c0a3c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  1c0a40:	e8 67 f8 ff ff       	callq  1c02ac <printer_vprintf>
        *sp.s = 0;
  1c0a45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0a49:	c6 00 00             	movb   $0x0,(%rax)
  1c0a4c:	eb d5                	jmp    1c0a23 <vsnprintf+0x1d>

00000000001c0a4e <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c0a4e:	55                   	push   %rbp
  1c0a4f:	48 89 e5             	mov    %rsp,%rbp
  1c0a52:	48 83 ec 50          	sub    $0x50,%rsp
  1c0a56:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0a5a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0a5e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c0a62:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0a69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0a6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0a71:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0a75:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c0a79:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0a7d:	e8 84 ff ff ff       	callq  1c0a06 <vsnprintf>
    va_end(val);
    return n;
}
  1c0a82:	c9                   	leaveq 
  1c0a83:	c3                   	retq   

00000000001c0a84 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a84:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  1c0a89:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  1c0a8e:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a93:	48 83 c0 02          	add    $0x2,%rax
  1c0a97:	48 39 d0             	cmp    %rdx,%rax
  1c0a9a:	75 f2                	jne    1c0a8e <console_clear+0xa>
    }
    cursorpos = 0;
  1c0a9c:	c7 05 56 85 ef ff 00 	movl   $0x0,-0x107aaa(%rip)        # b8ffc <cursorpos>
  1c0aa3:	00 00 00 
}
  1c0aa6:	c3                   	retq   

00000000001c0aa7 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  1c0aa7:	55                   	push   %rbp
  1c0aa8:	48 89 e5             	mov    %rsp,%rbp
  1c0aab:	48 83 ec 50          	sub    $0x50,%rsp
  1c0aaf:	49 89 f2             	mov    %rsi,%r10
  1c0ab2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1c0ab6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0aba:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0abe:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  1c0ac2:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  1c0ac7:	85 ff                	test   %edi,%edi
  1c0ac9:	78 2e                	js     1c0af9 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  1c0acb:	48 63 ff             	movslq %edi,%rdi
  1c0ace:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  1c0ad5:	cc cc cc 
  1c0ad8:	48 89 f8             	mov    %rdi,%rax
  1c0adb:	48 f7 e2             	mul    %rdx
  1c0ade:	48 89 d0             	mov    %rdx,%rax
  1c0ae1:	48 c1 e8 02          	shr    $0x2,%rax
  1c0ae5:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  1c0ae9:	48 01 c2             	add    %rax,%rdx
  1c0aec:	48 29 d7             	sub    %rdx,%rdi
  1c0aef:	0f b6 b7 9d 0e 1c 00 	movzbl 0x1c0e9d(%rdi),%esi
  1c0af6:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1c0af9:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  1c0b00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0b04:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0b08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0b0c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  1c0b10:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0b14:	4c 89 d2             	mov    %r10,%rdx
  1c0b17:	8b 3d df 84 ef ff    	mov    -0x107b21(%rip),%edi        # b8ffc <cursorpos>
  1c0b1d:	e8 69 fe ff ff       	callq  1c098b <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  1c0b22:	3d 30 07 00 00       	cmp    $0x730,%eax
  1c0b27:	ba 00 00 00 00       	mov    $0x0,%edx
  1c0b2c:	0f 4d c2             	cmovge %edx,%eax
  1c0b2f:	89 05 c7 84 ef ff    	mov    %eax,-0x107b39(%rip)        # b8ffc <cursorpos>
    }
}
  1c0b35:	c9                   	leaveq 
  1c0b36:	c3                   	retq   

00000000001c0b37 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  1c0b37:	55                   	push   %rbp
  1c0b38:	48 89 e5             	mov    %rsp,%rbp
  1c0b3b:	53                   	push   %rbx
  1c0b3c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  1c0b43:	48 89 fb             	mov    %rdi,%rbx
  1c0b46:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  1c0b4a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  1c0b4e:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  1c0b52:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  1c0b56:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  1c0b5a:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  1c0b61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0b65:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  1c0b69:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  1c0b6d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  1c0b71:	ba 07 00 00 00       	mov    $0x7,%edx
  1c0b76:	be 67 0e 1c 00       	mov    $0x1c0e67,%esi
  1c0b7b:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  1c0b82:	e8 ab f5 ff ff       	callq  1c0132 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  1c0b87:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  1c0b8b:	48 89 da             	mov    %rbx,%rdx
  1c0b8e:	be 99 00 00 00       	mov    $0x99,%esi
  1c0b93:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  1c0b9a:	e8 67 fe ff ff       	callq  1c0a06 <vsnprintf>
  1c0b9f:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  1c0ba2:	85 d2                	test   %edx,%edx
  1c0ba4:	7e 0f                	jle    1c0bb5 <kernel_panic+0x7e>
  1c0ba6:	83 c0 06             	add    $0x6,%eax
  1c0ba9:	48 98                	cltq   
  1c0bab:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  1c0bb2:	0a 
  1c0bb3:	75 2a                	jne    1c0bdf <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  1c0bb5:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  1c0bbc:	48 89 d9             	mov    %rbx,%rcx
  1c0bbf:	ba 71 0e 1c 00       	mov    $0x1c0e71,%edx
  1c0bc4:	be 00 c0 00 00       	mov    $0xc000,%esi
  1c0bc9:	bf 30 07 00 00       	mov    $0x730,%edi
  1c0bce:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0bd3:	e8 f8 fd ff ff       	callq  1c09d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  1c0bd8:	48 89 df             	mov    %rbx,%rdi
  1c0bdb:	cd 30                	int    $0x30
 loop: goto loop;
  1c0bdd:	eb fe                	jmp    1c0bdd <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  1c0bdf:	48 63 c2             	movslq %edx,%rax
  1c0be2:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  1c0be8:	0f 94 c2             	sete   %dl
  1c0beb:	0f b6 d2             	movzbl %dl,%edx
  1c0bee:	48 29 d0             	sub    %rdx,%rax
  1c0bf1:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1c0bf8:	ff 
  1c0bf9:	be 6f 0e 1c 00       	mov    $0x1c0e6f,%esi
  1c0bfe:	e8 f1 f5 ff ff       	callq  1c01f4 <strcpy>
  1c0c03:	eb b0                	jmp    1c0bb5 <kernel_panic+0x7e>

00000000001c0c05 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  1c0c05:	55                   	push   %rbp
  1c0c06:	48 89 e5             	mov    %rsp,%rbp
  1c0c09:	48 89 f9             	mov    %rdi,%rcx
  1c0c0c:	41 89 f0             	mov    %esi,%r8d
  1c0c0f:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  1c0c12:	ba 78 0e 1c 00       	mov    $0x1c0e78,%edx
  1c0c17:	be 00 c0 00 00       	mov    $0xc000,%esi
  1c0c1c:	bf 30 07 00 00       	mov    $0x730,%edi
  1c0c21:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0c26:	e8 a5 fd ff ff       	callq  1c09d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  1c0c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  1c0c30:	cd 30                	int    $0x30
 loop: goto loop;
  1c0c32:	eb fe                	jmp    1c0c32 <assert_fail+0x2d>
