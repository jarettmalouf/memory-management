
obj/p-allocator3.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000180000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  180000:	55                   	push   %rbp
  180001:	48 89 e5             	mov    %rsp,%rbp
  180004:	53                   	push   %rbx
  180005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  180009:	cd 31                	int    $0x31
  18000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();
    srand(p);
  18000d:	89 c7                	mov    %eax,%edi
  18000f:	e8 87 02 00 00       	callq  18029b <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  180014:	b8 27 20 18 00       	mov    $0x182027,%eax
  180019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  18001f:	48 89 05 ea 0f 00 00 	mov    %rax,0xfea(%rip)        # 181010 <heap_top>
  180026:	48 89 05 db 0f 00 00 	mov    %rax,0xfdb(%rip)        # 181008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  18002d:	48 89 e2             	mov    %rsp,%rdx
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  180030:	48 83 ea 01          	sub    $0x1,%rdx
  180034:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  18003b:	48 89 15 be 0f 00 00 	mov    %rdx,0xfbe(%rip)        # 181000 <stack_bottom>

    while(heap_top + PAGESIZE < stack_bottom) {
  180042:	48 05 00 10 00 00    	add    $0x1000,%rax
  180048:	48 39 c2             	cmp    %rax,%rdx
  18004b:	76 3a                	jbe    180087 <process_main+0x87>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  18004d:	bf 00 10 00 00       	mov    $0x1000,%edi
  180052:	cd 3a                	int    $0x3a
  180054:	48 89 05 bd 0f 00 00 	mov    %rax,0xfbd(%rip)        # 181018 <result.0>

        void * ret = sbrk(PAGESIZE);
        if(ret == (void *) -1) break;
  18005b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  18005f:	74 26                	je     180087 <process_main+0x87>

        *heap_top = p;      /* check we have write access to new page */
  180061:	48 8b 15 a8 0f 00 00 	mov    0xfa8(%rip),%rdx        # 181010 <heap_top>
  180068:	88 1a                	mov    %bl,(%rdx)
        heap_top = (uint8_t *)ret + PAGESIZE;
  18006a:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  180071:	48 89 15 98 0f 00 00 	mov    %rdx,0xf98(%rip)        # 181010 <heap_top>
    while(heap_top + PAGESIZE < stack_bottom) {
  180078:	48 05 00 20 00 00    	add    $0x2000,%rax
  18007e:	48 39 05 7b 0f 00 00 	cmp    %rax,0xf7b(%rip)        # 181000 <stack_bottom>
  180085:	77 cb                	ja     180052 <process_main+0x52>
    }

    TEST_PASS();
  180087:	bf 40 0c 18 00       	mov    $0x180c40,%edi
  18008c:	b8 00 00 00 00       	mov    $0x0,%eax
  180091:	e8 a1 0a 00 00       	callq  180b37 <kernel_panic>

0000000000180096 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  180096:	48 89 f9             	mov    %rdi,%rcx
  180099:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  18009b:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1800a2:	00 
  1800a3:	72 08                	jb     1800ad <console_putc+0x17>
        cp->cursor = console;
  1800a5:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1800ac:	00 
    }
    if (c == '\n') {
  1800ad:	40 80 fe 0a          	cmp    $0xa,%sil
  1800b1:	74 16                	je     1800c9 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1800b3:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1800b7:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1800bb:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1800bf:	40 0f b6 f6          	movzbl %sil,%esi
  1800c3:	09 fe                	or     %edi,%esi
  1800c5:	66 89 30             	mov    %si,(%rax)
    }
}
  1800c8:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1800c9:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1800cd:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1800d4:	4c 89 c6             	mov    %r8,%rsi
  1800d7:	48 d1 fe             	sar    %rsi
  1800da:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1800e1:	66 66 66 
  1800e4:	48 89 f0             	mov    %rsi,%rax
  1800e7:	48 f7 ea             	imul   %rdx
  1800ea:	48 c1 fa 05          	sar    $0x5,%rdx
  1800ee:	49 c1 f8 3f          	sar    $0x3f,%r8
  1800f2:	4c 29 c2             	sub    %r8,%rdx
  1800f5:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1800f9:	48 c1 e2 04          	shl    $0x4,%rdx
  1800fd:	89 f0                	mov    %esi,%eax
  1800ff:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  180101:	83 cf 20             	or     $0x20,%edi
  180104:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180108:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  18010c:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  180110:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  180113:	83 c0 01             	add    $0x1,%eax
  180116:	83 f8 50             	cmp    $0x50,%eax
  180119:	75 e9                	jne    180104 <console_putc+0x6e>
  18011b:	c3                   	retq   

000000000018011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  18011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  180120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  180124:	73 0b                	jae    180131 <string_putc+0x15>
        *sp->s++ = c;
  180126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  18012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  18012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  180131:	c3                   	retq   

0000000000180132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  180132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180135:	48 85 d2             	test   %rdx,%rdx
  180138:	74 17                	je     180151 <memcpy+0x1f>
  18013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  18013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  180144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180148:	48 83 c1 01          	add    $0x1,%rcx
  18014c:	48 39 d1             	cmp    %rdx,%rcx
  18014f:	75 ee                	jne    18013f <memcpy+0xd>
}
  180151:	c3                   	retq   

0000000000180152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  180152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  180155:	48 39 fe             	cmp    %rdi,%rsi
  180158:	72 1d                	jb     180177 <memmove+0x25>
        while (n-- > 0) {
  18015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  18015f:	48 85 d2             	test   %rdx,%rdx
  180162:	74 12                	je     180176 <memmove+0x24>
            *d++ = *s++;
  180164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  180168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  18016c:	48 83 c1 01          	add    $0x1,%rcx
  180170:	48 39 ca             	cmp    %rcx,%rdx
  180173:	75 ef                	jne    180164 <memmove+0x12>
}
  180175:	c3                   	retq   
  180176:	c3                   	retq   
    if (s < d && s + n > d) {
  180177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  18017b:	48 39 cf             	cmp    %rcx,%rdi
  18017e:	73 da                	jae    18015a <memmove+0x8>
        while (n-- > 0) {
  180180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  180184:	48 85 d2             	test   %rdx,%rdx
  180187:	74 ec                	je     180175 <memmove+0x23>
            *--d = *--s;
  180189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  18018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  180190:	48 83 e9 01          	sub    $0x1,%rcx
  180194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  180198:	75 ef                	jne    180189 <memmove+0x37>
  18019a:	c3                   	retq   

000000000018019b <memset>:
void* memset(void* v, int c, size_t n) {
  18019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  18019e:	48 85 d2             	test   %rdx,%rdx
  1801a1:	74 12                	je     1801b5 <memset+0x1a>
  1801a3:	48 01 fa             	add    %rdi,%rdx
  1801a6:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1801a9:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801ac:	48 83 c1 01          	add    $0x1,%rcx
  1801b0:	48 39 ca             	cmp    %rcx,%rdx
  1801b3:	75 f4                	jne    1801a9 <memset+0xe>
}
  1801b5:	c3                   	retq   

00000000001801b6 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1801b6:	80 3f 00             	cmpb   $0x0,(%rdi)
  1801b9:	74 10                	je     1801cb <strlen+0x15>
  1801bb:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1801c0:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1801c4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1801c8:	75 f6                	jne    1801c0 <strlen+0xa>
  1801ca:	c3                   	retq   
  1801cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1801d0:	c3                   	retq   

00000000001801d1 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1801d1:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1801d9:	48 85 f6             	test   %rsi,%rsi
  1801dc:	74 11                	je     1801ef <strnlen+0x1e>
  1801de:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1801e2:	74 0c                	je     1801f0 <strnlen+0x1f>
        ++n;
  1801e4:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801e8:	48 39 d0             	cmp    %rdx,%rax
  1801eb:	75 f1                	jne    1801de <strnlen+0xd>
  1801ed:	eb 04                	jmp    1801f3 <strnlen+0x22>
  1801ef:	c3                   	retq   
  1801f0:	48 89 d0             	mov    %rdx,%rax
}
  1801f3:	c3                   	retq   

00000000001801f4 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1801f4:	48 89 f8             	mov    %rdi,%rax
  1801f7:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1801fc:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  180200:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  180203:	48 83 c2 01          	add    $0x1,%rdx
  180207:	84 c9                	test   %cl,%cl
  180209:	75 f1                	jne    1801fc <strcpy+0x8>
}
  18020b:	c3                   	retq   

000000000018020c <strcmp>:
    while (*a && *b && *a == *b) {
  18020c:	0f b6 07             	movzbl (%rdi),%eax
  18020f:	84 c0                	test   %al,%al
  180211:	74 1a                	je     18022d <strcmp+0x21>
  180213:	0f b6 16             	movzbl (%rsi),%edx
  180216:	38 c2                	cmp    %al,%dl
  180218:	75 13                	jne    18022d <strcmp+0x21>
  18021a:	84 d2                	test   %dl,%dl
  18021c:	74 0f                	je     18022d <strcmp+0x21>
        ++a, ++b;
  18021e:	48 83 c7 01          	add    $0x1,%rdi
  180222:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  180226:	0f b6 07             	movzbl (%rdi),%eax
  180229:	84 c0                	test   %al,%al
  18022b:	75 e6                	jne    180213 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  18022d:	3a 06                	cmp    (%rsi),%al
  18022f:	0f 97 c0             	seta   %al
  180232:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  180235:	83 d8 00             	sbb    $0x0,%eax
}
  180238:	c3                   	retq   

0000000000180239 <strchr>:
    while (*s && *s != (char) c) {
  180239:	0f b6 07             	movzbl (%rdi),%eax
  18023c:	84 c0                	test   %al,%al
  18023e:	74 10                	je     180250 <strchr+0x17>
  180240:	40 38 f0             	cmp    %sil,%al
  180243:	74 18                	je     18025d <strchr+0x24>
        ++s;
  180245:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  180249:	0f b6 07             	movzbl (%rdi),%eax
  18024c:	84 c0                	test   %al,%al
  18024e:	75 f0                	jne    180240 <strchr+0x7>
        return NULL;
  180250:	40 84 f6             	test   %sil,%sil
  180253:	b8 00 00 00 00       	mov    $0x0,%eax
  180258:	48 0f 44 c7          	cmove  %rdi,%rax
}
  18025c:	c3                   	retq   
  18025d:	48 89 f8             	mov    %rdi,%rax
  180260:	c3                   	retq   

0000000000180261 <rand>:
    if (!rand_seed_set) {
  180261:	83 3d bc 0d 00 00 00 	cmpl   $0x0,0xdbc(%rip)        # 181024 <rand_seed_set>
  180268:	74 1b                	je     180285 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  18026a:	69 05 ac 0d 00 00 0d 	imul   $0x19660d,0xdac(%rip),%eax        # 181020 <rand_seed>
  180271:	66 19 00 
  180274:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  180279:	89 05 a1 0d 00 00    	mov    %eax,0xda1(%rip)        # 181020 <rand_seed>
    return rand_seed & RAND_MAX;
  18027f:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  180284:	c3                   	retq   
    rand_seed = seed;
  180285:	c7 05 91 0d 00 00 9e 	movl   $0x30d4879e,0xd91(%rip)        # 181020 <rand_seed>
  18028c:	87 d4 30 
    rand_seed_set = 1;
  18028f:	c7 05 8b 0d 00 00 01 	movl   $0x1,0xd8b(%rip)        # 181024 <rand_seed_set>
  180296:	00 00 00 
}
  180299:	eb cf                	jmp    18026a <rand+0x9>

000000000018029b <srand>:
    rand_seed = seed;
  18029b:	89 3d 7f 0d 00 00    	mov    %edi,0xd7f(%rip)        # 181020 <rand_seed>
    rand_seed_set = 1;
  1802a1:	c7 05 79 0d 00 00 01 	movl   $0x1,0xd79(%rip)        # 181024 <rand_seed_set>
  1802a8:	00 00 00 
}
  1802ab:	c3                   	retq   

00000000001802ac <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1802ac:	55                   	push   %rbp
  1802ad:	48 89 e5             	mov    %rsp,%rbp
  1802b0:	41 57                	push   %r15
  1802b2:	41 56                	push   %r14
  1802b4:	41 55                	push   %r13
  1802b6:	41 54                	push   %r12
  1802b8:	53                   	push   %rbx
  1802b9:	48 83 ec 58          	sub    $0x58,%rsp
  1802bd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1802c1:	0f b6 02             	movzbl (%rdx),%eax
  1802c4:	84 c0                	test   %al,%al
  1802c6:	0f 84 b0 06 00 00    	je     18097c <printer_vprintf+0x6d0>
  1802cc:	49 89 fe             	mov    %rdi,%r14
  1802cf:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1802d2:	41 89 f7             	mov    %esi,%r15d
  1802d5:	e9 a4 04 00 00       	jmpq   18077e <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1802da:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1802df:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1802e5:	45 84 e4             	test   %r12b,%r12b
  1802e8:	0f 84 82 06 00 00    	je     180970 <printer_vprintf+0x6c4>
        int flags = 0;
  1802ee:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1802f4:	41 0f be f4          	movsbl %r12b,%esi
  1802f8:	bf 61 0e 18 00       	mov    $0x180e61,%edi
  1802fd:	e8 37 ff ff ff       	callq  180239 <strchr>
  180302:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  180305:	48 85 c0             	test   %rax,%rax
  180308:	74 55                	je     18035f <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  18030a:	48 81 e9 61 0e 18 00 	sub    $0x180e61,%rcx
  180311:	b8 01 00 00 00       	mov    $0x1,%eax
  180316:	d3 e0                	shl    %cl,%eax
  180318:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  18031b:	48 83 c3 01          	add    $0x1,%rbx
  18031f:	44 0f b6 23          	movzbl (%rbx),%r12d
  180323:	45 84 e4             	test   %r12b,%r12b
  180326:	75 cc                	jne    1802f4 <printer_vprintf+0x48>
  180328:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  18032c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  180332:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  180339:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  18033c:	0f 84 a9 00 00 00    	je     1803eb <printer_vprintf+0x13f>
        int length = 0;
  180342:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  180347:	0f b6 13             	movzbl (%rbx),%edx
  18034a:	8d 42 bd             	lea    -0x43(%rdx),%eax
  18034d:	3c 37                	cmp    $0x37,%al
  18034f:	0f 87 c4 04 00 00    	ja     180819 <printer_vprintf+0x56d>
  180355:	0f b6 c0             	movzbl %al,%eax
  180358:	ff 24 c5 70 0c 18 00 	jmpq   *0x180c70(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  18035f:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  180363:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  180368:	3c 08                	cmp    $0x8,%al
  18036a:	77 2f                	ja     18039b <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  18036c:	0f b6 03             	movzbl (%rbx),%eax
  18036f:	8d 50 d0             	lea    -0x30(%rax),%edx
  180372:	80 fa 09             	cmp    $0x9,%dl
  180375:	77 5e                	ja     1803d5 <printer_vprintf+0x129>
  180377:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  18037d:	48 83 c3 01          	add    $0x1,%rbx
  180381:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  180386:	0f be c0             	movsbl %al,%eax
  180389:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  18038e:	0f b6 03             	movzbl (%rbx),%eax
  180391:	8d 50 d0             	lea    -0x30(%rax),%edx
  180394:	80 fa 09             	cmp    $0x9,%dl
  180397:	76 e4                	jbe    18037d <printer_vprintf+0xd1>
  180399:	eb 97                	jmp    180332 <printer_vprintf+0x86>
        } else if (*format == '*') {
  18039b:	41 80 fc 2a          	cmp    $0x2a,%r12b
  18039f:	75 3f                	jne    1803e0 <printer_vprintf+0x134>
            width = va_arg(val, int);
  1803a1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1803a5:	8b 07                	mov    (%rdi),%eax
  1803a7:	83 f8 2f             	cmp    $0x2f,%eax
  1803aa:	77 17                	ja     1803c3 <printer_vprintf+0x117>
  1803ac:	89 c2                	mov    %eax,%edx
  1803ae:	48 03 57 10          	add    0x10(%rdi),%rdx
  1803b2:	83 c0 08             	add    $0x8,%eax
  1803b5:	89 07                	mov    %eax,(%rdi)
  1803b7:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1803ba:	48 83 c3 01          	add    $0x1,%rbx
  1803be:	e9 6f ff ff ff       	jmpq   180332 <printer_vprintf+0x86>
            width = va_arg(val, int);
  1803c3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1803c7:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1803cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1803cf:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1803d3:	eb e2                	jmp    1803b7 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1803d5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1803db:	e9 52 ff ff ff       	jmpq   180332 <printer_vprintf+0x86>
        int width = -1;
  1803e0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1803e6:	e9 47 ff ff ff       	jmpq   180332 <printer_vprintf+0x86>
            ++format;
  1803eb:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1803ef:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1803f3:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1803f6:	80 f9 09             	cmp    $0x9,%cl
  1803f9:	76 13                	jbe    18040e <printer_vprintf+0x162>
            } else if (*format == '*') {
  1803fb:	3c 2a                	cmp    $0x2a,%al
  1803fd:	74 33                	je     180432 <printer_vprintf+0x186>
            ++format;
  1803ff:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  180402:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  180409:	e9 34 ff ff ff       	jmpq   180342 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  18040e:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  180413:	48 83 c2 01          	add    $0x1,%rdx
  180417:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  18041a:	0f be c0             	movsbl %al,%eax
  18041d:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180421:	0f b6 02             	movzbl (%rdx),%eax
  180424:	8d 70 d0             	lea    -0x30(%rax),%esi
  180427:	40 80 fe 09          	cmp    $0x9,%sil
  18042b:	76 e6                	jbe    180413 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  18042d:	48 89 d3             	mov    %rdx,%rbx
  180430:	eb 1c                	jmp    18044e <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  180432:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180436:	8b 07                	mov    (%rdi),%eax
  180438:	83 f8 2f             	cmp    $0x2f,%eax
  18043b:	77 23                	ja     180460 <printer_vprintf+0x1b4>
  18043d:	89 c2                	mov    %eax,%edx
  18043f:	48 03 57 10          	add    0x10(%rdi),%rdx
  180443:	83 c0 08             	add    $0x8,%eax
  180446:	89 07                	mov    %eax,(%rdi)
  180448:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  18044a:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  18044e:	85 c9                	test   %ecx,%ecx
  180450:	b8 00 00 00 00       	mov    $0x0,%eax
  180455:	0f 49 c1             	cmovns %ecx,%eax
  180458:	89 45 9c             	mov    %eax,-0x64(%rbp)
  18045b:	e9 e2 fe ff ff       	jmpq   180342 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  180460:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180464:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180468:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18046c:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180470:	eb d6                	jmp    180448 <printer_vprintf+0x19c>
        switch (*format) {
  180472:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  180477:	e9 f3 00 00 00       	jmpq   18056f <printer_vprintf+0x2c3>
            ++format;
  18047c:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  180480:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  180485:	e9 bd fe ff ff       	jmpq   180347 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  18048a:	85 c9                	test   %ecx,%ecx
  18048c:	74 55                	je     1804e3 <printer_vprintf+0x237>
  18048e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180492:	8b 07                	mov    (%rdi),%eax
  180494:	83 f8 2f             	cmp    $0x2f,%eax
  180497:	77 38                	ja     1804d1 <printer_vprintf+0x225>
  180499:	89 c2                	mov    %eax,%edx
  18049b:	48 03 57 10          	add    0x10(%rdi),%rdx
  18049f:	83 c0 08             	add    $0x8,%eax
  1804a2:	89 07                	mov    %eax,(%rdi)
  1804a4:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1804a7:	48 89 d0             	mov    %rdx,%rax
  1804aa:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1804ae:	49 89 d0             	mov    %rdx,%r8
  1804b1:	49 f7 d8             	neg    %r8
  1804b4:	25 80 00 00 00       	and    $0x80,%eax
  1804b9:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1804bd:	0b 45 a8             	or     -0x58(%rbp),%eax
  1804c0:	83 c8 60             	or     $0x60,%eax
  1804c3:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1804c6:	41 bc 70 0e 18 00    	mov    $0x180e70,%r12d
            break;
  1804cc:	e9 35 01 00 00       	jmpq   180606 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1804d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1804d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1804d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1804dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1804e1:	eb c1                	jmp    1804a4 <printer_vprintf+0x1f8>
  1804e3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804e7:	8b 07                	mov    (%rdi),%eax
  1804e9:	83 f8 2f             	cmp    $0x2f,%eax
  1804ec:	77 10                	ja     1804fe <printer_vprintf+0x252>
  1804ee:	89 c2                	mov    %eax,%edx
  1804f0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1804f4:	83 c0 08             	add    $0x8,%eax
  1804f7:	89 07                	mov    %eax,(%rdi)
  1804f9:	48 63 12             	movslq (%rdx),%rdx
  1804fc:	eb a9                	jmp    1804a7 <printer_vprintf+0x1fb>
  1804fe:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180502:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180506:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18050a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  18050e:	eb e9                	jmp    1804f9 <printer_vprintf+0x24d>
        int base = 10;
  180510:	be 0a 00 00 00       	mov    $0xa,%esi
  180515:	eb 58                	jmp    18056f <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  180517:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18051b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18051f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180523:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180527:	eb 60                	jmp    180589 <printer_vprintf+0x2dd>
  180529:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18052d:	8b 07                	mov    (%rdi),%eax
  18052f:	83 f8 2f             	cmp    $0x2f,%eax
  180532:	77 10                	ja     180544 <printer_vprintf+0x298>
  180534:	89 c2                	mov    %eax,%edx
  180536:	48 03 57 10          	add    0x10(%rdi),%rdx
  18053a:	83 c0 08             	add    $0x8,%eax
  18053d:	89 07                	mov    %eax,(%rdi)
  18053f:	44 8b 02             	mov    (%rdx),%r8d
  180542:	eb 48                	jmp    18058c <printer_vprintf+0x2e0>
  180544:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180548:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18054c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180550:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180554:	eb e9                	jmp    18053f <printer_vprintf+0x293>
  180556:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  180559:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  180560:	bf 50 0e 18 00       	mov    $0x180e50,%edi
  180565:	e9 e2 02 00 00       	jmpq   18084c <printer_vprintf+0x5a0>
            base = 16;
  18056a:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  18056f:	85 c9                	test   %ecx,%ecx
  180571:	74 b6                	je     180529 <printer_vprintf+0x27d>
  180573:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180577:	8b 01                	mov    (%rcx),%eax
  180579:	83 f8 2f             	cmp    $0x2f,%eax
  18057c:	77 99                	ja     180517 <printer_vprintf+0x26b>
  18057e:	89 c2                	mov    %eax,%edx
  180580:	48 03 51 10          	add    0x10(%rcx),%rdx
  180584:	83 c0 08             	add    $0x8,%eax
  180587:	89 01                	mov    %eax,(%rcx)
  180589:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  18058c:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  180590:	85 f6                	test   %esi,%esi
  180592:	79 c2                	jns    180556 <printer_vprintf+0x2aa>
        base = -base;
  180594:	41 89 f1             	mov    %esi,%r9d
  180597:	f7 de                	neg    %esi
  180599:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1805a0:	bf 30 0e 18 00       	mov    $0x180e30,%edi
  1805a5:	e9 a2 02 00 00       	jmpq   18084c <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1805aa:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1805ae:	8b 07                	mov    (%rdi),%eax
  1805b0:	83 f8 2f             	cmp    $0x2f,%eax
  1805b3:	77 1c                	ja     1805d1 <printer_vprintf+0x325>
  1805b5:	89 c2                	mov    %eax,%edx
  1805b7:	48 03 57 10          	add    0x10(%rdi),%rdx
  1805bb:	83 c0 08             	add    $0x8,%eax
  1805be:	89 07                	mov    %eax,(%rdi)
  1805c0:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1805c3:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1805ca:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1805cf:	eb c3                	jmp    180594 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1805d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1805d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1805dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1805e1:	eb dd                	jmp    1805c0 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1805e3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805e7:	8b 01                	mov    (%rcx),%eax
  1805e9:	83 f8 2f             	cmp    $0x2f,%eax
  1805ec:	0f 87 a5 01 00 00    	ja     180797 <printer_vprintf+0x4eb>
  1805f2:	89 c2                	mov    %eax,%edx
  1805f4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1805f8:	83 c0 08             	add    $0x8,%eax
  1805fb:	89 01                	mov    %eax,(%rcx)
  1805fd:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  180600:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  180606:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180609:	83 e0 20             	and    $0x20,%eax
  18060c:	89 45 8c             	mov    %eax,-0x74(%rbp)
  18060f:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  180615:	0f 85 21 02 00 00    	jne    18083c <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  18061b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  18061e:	89 45 88             	mov    %eax,-0x78(%rbp)
  180621:	83 e0 60             	and    $0x60,%eax
  180624:	83 f8 60             	cmp    $0x60,%eax
  180627:	0f 84 54 02 00 00    	je     180881 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  18062d:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180630:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  180633:	48 c7 45 a0 70 0e 18 	movq   $0x180e70,-0x60(%rbp)
  18063a:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  18063b:	83 f8 21             	cmp    $0x21,%eax
  18063e:	0f 84 79 02 00 00    	je     1808bd <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  180644:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  180647:	89 f8                	mov    %edi,%eax
  180649:	f7 d0                	not    %eax
  18064b:	c1 e8 1f             	shr    $0x1f,%eax
  18064e:	89 45 84             	mov    %eax,-0x7c(%rbp)
  180651:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  180655:	0f 85 9e 02 00 00    	jne    1808f9 <printer_vprintf+0x64d>
  18065b:	84 c0                	test   %al,%al
  18065d:	0f 84 96 02 00 00    	je     1808f9 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  180663:	48 63 f7             	movslq %edi,%rsi
  180666:	4c 89 e7             	mov    %r12,%rdi
  180669:	e8 63 fb ff ff       	callq  1801d1 <strnlen>
  18066e:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  180671:	8b 45 88             	mov    -0x78(%rbp),%eax
  180674:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  180677:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  18067e:	83 f8 22             	cmp    $0x22,%eax
  180681:	0f 84 aa 02 00 00    	je     180931 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  180687:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  18068b:	e8 26 fb ff ff       	callq  1801b6 <strlen>
  180690:	8b 55 9c             	mov    -0x64(%rbp),%edx
  180693:	03 55 98             	add    -0x68(%rbp),%edx
  180696:	44 89 e9             	mov    %r13d,%ecx
  180699:	29 d1                	sub    %edx,%ecx
  18069b:	29 c1                	sub    %eax,%ecx
  18069d:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1806a0:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806a3:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1806a7:	75 2d                	jne    1806d6 <printer_vprintf+0x42a>
  1806a9:	85 c9                	test   %ecx,%ecx
  1806ab:	7e 29                	jle    1806d6 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1806ad:	44 89 fa             	mov    %r15d,%edx
  1806b0:	be 20 00 00 00       	mov    $0x20,%esi
  1806b5:	4c 89 f7             	mov    %r14,%rdi
  1806b8:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806bb:	41 83 ed 01          	sub    $0x1,%r13d
  1806bf:	45 85 ed             	test   %r13d,%r13d
  1806c2:	7f e9                	jg     1806ad <printer_vprintf+0x401>
  1806c4:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1806c7:	85 ff                	test   %edi,%edi
  1806c9:	b8 01 00 00 00       	mov    $0x1,%eax
  1806ce:	0f 4f c7             	cmovg  %edi,%eax
  1806d1:	29 c7                	sub    %eax,%edi
  1806d3:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1806d6:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1806da:	0f b6 07             	movzbl (%rdi),%eax
  1806dd:	84 c0                	test   %al,%al
  1806df:	74 22                	je     180703 <printer_vprintf+0x457>
  1806e1:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1806e5:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1806e8:	0f b6 f0             	movzbl %al,%esi
  1806eb:	44 89 fa             	mov    %r15d,%edx
  1806ee:	4c 89 f7             	mov    %r14,%rdi
  1806f1:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1806f4:	48 83 c3 01          	add    $0x1,%rbx
  1806f8:	0f b6 03             	movzbl (%rbx),%eax
  1806fb:	84 c0                	test   %al,%al
  1806fd:	75 e9                	jne    1806e8 <printer_vprintf+0x43c>
  1806ff:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  180703:	8b 45 9c             	mov    -0x64(%rbp),%eax
  180706:	85 c0                	test   %eax,%eax
  180708:	7e 1d                	jle    180727 <printer_vprintf+0x47b>
  18070a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  18070e:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  180710:	44 89 fa             	mov    %r15d,%edx
  180713:	be 30 00 00 00       	mov    $0x30,%esi
  180718:	4c 89 f7             	mov    %r14,%rdi
  18071b:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  18071e:	83 eb 01             	sub    $0x1,%ebx
  180721:	75 ed                	jne    180710 <printer_vprintf+0x464>
  180723:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  180727:	8b 45 98             	mov    -0x68(%rbp),%eax
  18072a:	85 c0                	test   %eax,%eax
  18072c:	7e 27                	jle    180755 <printer_vprintf+0x4a9>
  18072e:	89 c0                	mov    %eax,%eax
  180730:	4c 01 e0             	add    %r12,%rax
  180733:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  180737:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  18073a:	41 0f b6 34 24       	movzbl (%r12),%esi
  18073f:	44 89 fa             	mov    %r15d,%edx
  180742:	4c 89 f7             	mov    %r14,%rdi
  180745:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  180748:	49 83 c4 01          	add    $0x1,%r12
  18074c:	49 39 dc             	cmp    %rbx,%r12
  18074f:	75 e9                	jne    18073a <printer_vprintf+0x48e>
  180751:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  180755:	45 85 ed             	test   %r13d,%r13d
  180758:	7e 14                	jle    18076e <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  18075a:	44 89 fa             	mov    %r15d,%edx
  18075d:	be 20 00 00 00       	mov    $0x20,%esi
  180762:	4c 89 f7             	mov    %r14,%rdi
  180765:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  180768:	41 83 ed 01          	sub    $0x1,%r13d
  18076c:	75 ec                	jne    18075a <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  18076e:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  180772:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  180776:	84 c0                	test   %al,%al
  180778:	0f 84 fe 01 00 00    	je     18097c <printer_vprintf+0x6d0>
        if (*format != '%') {
  18077e:	3c 25                	cmp    $0x25,%al
  180780:	0f 84 54 fb ff ff    	je     1802da <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  180786:	0f b6 f0             	movzbl %al,%esi
  180789:	44 89 fa             	mov    %r15d,%edx
  18078c:	4c 89 f7             	mov    %r14,%rdi
  18078f:	41 ff 16             	callq  *(%r14)
            continue;
  180792:	4c 89 e3             	mov    %r12,%rbx
  180795:	eb d7                	jmp    18076e <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  180797:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18079b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  18079f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1807a3:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1807a7:	e9 51 fe ff ff       	jmpq   1805fd <printer_vprintf+0x351>
            color = va_arg(val, int);
  1807ac:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1807b0:	8b 07                	mov    (%rdi),%eax
  1807b2:	83 f8 2f             	cmp    $0x2f,%eax
  1807b5:	77 10                	ja     1807c7 <printer_vprintf+0x51b>
  1807b7:	89 c2                	mov    %eax,%edx
  1807b9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1807bd:	83 c0 08             	add    $0x8,%eax
  1807c0:	89 07                	mov    %eax,(%rdi)
  1807c2:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1807c5:	eb a7                	jmp    18076e <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1807c7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807cb:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1807cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1807d3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1807d7:	eb e9                	jmp    1807c2 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1807d9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807dd:	8b 01                	mov    (%rcx),%eax
  1807df:	83 f8 2f             	cmp    $0x2f,%eax
  1807e2:	77 23                	ja     180807 <printer_vprintf+0x55b>
  1807e4:	89 c2                	mov    %eax,%edx
  1807e6:	48 03 51 10          	add    0x10(%rcx),%rdx
  1807ea:	83 c0 08             	add    $0x8,%eax
  1807ed:	89 01                	mov    %eax,(%rcx)
  1807ef:	8b 02                	mov    (%rdx),%eax
  1807f1:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1807f4:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1807f8:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1807fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  180802:	e9 ff fd ff ff       	jmpq   180606 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  180807:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18080b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  18080f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180813:	48 89 47 08          	mov    %rax,0x8(%rdi)
  180817:	eb d6                	jmp    1807ef <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  180819:	84 d2                	test   %dl,%dl
  18081b:	0f 85 39 01 00 00    	jne    18095a <printer_vprintf+0x6ae>
  180821:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  180825:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  180829:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  18082d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  180837:	e9 ca fd ff ff       	jmpq   180606 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  18083c:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  180842:	bf 50 0e 18 00       	mov    $0x180e50,%edi
        if (flags & FLAG_NUMERIC) {
  180847:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  18084c:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  180850:	4c 89 c1             	mov    %r8,%rcx
  180853:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  180857:	48 63 f6             	movslq %esi,%rsi
  18085a:	49 83 ec 01          	sub    $0x1,%r12
  18085e:	48 89 c8             	mov    %rcx,%rax
  180861:	ba 00 00 00 00       	mov    $0x0,%edx
  180866:	48 f7 f6             	div    %rsi
  180869:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  18086d:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  180871:	48 89 ca             	mov    %rcx,%rdx
  180874:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  180877:	48 39 d6             	cmp    %rdx,%rsi
  18087a:	76 de                	jbe    18085a <printer_vprintf+0x5ae>
  18087c:	e9 9a fd ff ff       	jmpq   18061b <printer_vprintf+0x36f>
                prefix = "-";
  180881:	48 c7 45 a0 5e 0c 18 	movq   $0x180c5e,-0x60(%rbp)
  180888:	00 
            if (flags & FLAG_NEGATIVE) {
  180889:	8b 45 a8             	mov    -0x58(%rbp),%eax
  18088c:	a8 80                	test   $0x80,%al
  18088e:	0f 85 b0 fd ff ff    	jne    180644 <printer_vprintf+0x398>
                prefix = "+";
  180894:	48 c7 45 a0 59 0c 18 	movq   $0x180c59,-0x60(%rbp)
  18089b:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  18089c:	a8 10                	test   $0x10,%al
  18089e:	0f 85 a0 fd ff ff    	jne    180644 <printer_vprintf+0x398>
                prefix = " ";
  1808a4:	a8 08                	test   $0x8,%al
  1808a6:	ba 70 0e 18 00       	mov    $0x180e70,%edx
  1808ab:	b8 6d 0e 18 00       	mov    $0x180e6d,%eax
  1808b0:	48 0f 44 c2          	cmove  %rdx,%rax
  1808b4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808b8:	e9 87 fd ff ff       	jmpq   180644 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1808bd:	41 8d 41 10          	lea    0x10(%r9),%eax
  1808c1:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1808c6:	0f 85 78 fd ff ff    	jne    180644 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1808cc:	4d 85 c0             	test   %r8,%r8
  1808cf:	75 0d                	jne    1808de <printer_vprintf+0x632>
  1808d1:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1808d8:	0f 84 66 fd ff ff    	je     180644 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1808de:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1808e2:	ba 60 0c 18 00       	mov    $0x180c60,%edx
  1808e7:	b8 5b 0c 18 00       	mov    $0x180c5b,%eax
  1808ec:	48 0f 44 c2          	cmove  %rdx,%rax
  1808f0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808f4:	e9 4b fd ff ff       	jmpq   180644 <printer_vprintf+0x398>
            len = strlen(data);
  1808f9:	4c 89 e7             	mov    %r12,%rdi
  1808fc:	e8 b5 f8 ff ff       	callq  1801b6 <strlen>
  180901:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  180904:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  180908:	0f 84 63 fd ff ff    	je     180671 <printer_vprintf+0x3c5>
  18090e:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  180912:	0f 84 59 fd ff ff    	je     180671 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  180918:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  18091b:	89 ca                	mov    %ecx,%edx
  18091d:	29 c2                	sub    %eax,%edx
  18091f:	39 c1                	cmp    %eax,%ecx
  180921:	b8 00 00 00 00       	mov    $0x0,%eax
  180926:	0f 4e d0             	cmovle %eax,%edx
  180929:	89 55 9c             	mov    %edx,-0x64(%rbp)
  18092c:	e9 56 fd ff ff       	jmpq   180687 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  180931:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  180935:	e8 7c f8 ff ff       	callq  1801b6 <strlen>
  18093a:	8b 7d 98             	mov    -0x68(%rbp),%edi
  18093d:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  180940:	44 89 e9             	mov    %r13d,%ecx
  180943:	29 f9                	sub    %edi,%ecx
  180945:	29 c1                	sub    %eax,%ecx
  180947:	44 39 ea             	cmp    %r13d,%edx
  18094a:	b8 00 00 00 00       	mov    $0x0,%eax
  18094f:	0f 4d c8             	cmovge %eax,%ecx
  180952:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  180955:	e9 2d fd ff ff       	jmpq   180687 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  18095a:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  18095d:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  180961:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  18096b:	e9 96 fc ff ff       	jmpq   180606 <printer_vprintf+0x35a>
        int flags = 0;
  180970:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  180977:	e9 b0 f9 ff ff       	jmpq   18032c <printer_vprintf+0x80>
}
  18097c:	48 83 c4 58          	add    $0x58,%rsp
  180980:	5b                   	pop    %rbx
  180981:	41 5c                	pop    %r12
  180983:	41 5d                	pop    %r13
  180985:	41 5e                	pop    %r14
  180987:	41 5f                	pop    %r15
  180989:	5d                   	pop    %rbp
  18098a:	c3                   	retq   

000000000018098b <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  18098b:	55                   	push   %rbp
  18098c:	48 89 e5             	mov    %rsp,%rbp
  18098f:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  180993:	48 c7 45 f0 96 00 18 	movq   $0x180096,-0x10(%rbp)
  18099a:	00 
        cpos = 0;
  18099b:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1809a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1809a6:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1809a9:	48 63 ff             	movslq %edi,%rdi
  1809ac:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1809b3:	00 
  1809b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1809b8:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1809bc:	e8 eb f8 ff ff       	callq  1802ac <printer_vprintf>
    return cp.cursor - console;
  1809c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1809c5:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1809cb:	48 d1 f8             	sar    %rax
}
  1809ce:	c9                   	leaveq 
  1809cf:	c3                   	retq   

00000000001809d0 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1809d0:	55                   	push   %rbp
  1809d1:	48 89 e5             	mov    %rsp,%rbp
  1809d4:	48 83 ec 50          	sub    $0x50,%rsp
  1809d8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1809dc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1809e0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1809e4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1809eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1809ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1809f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1809f7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1809fb:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1809ff:	e8 87 ff ff ff       	callq  18098b <console_vprintf>
}
  180a04:	c9                   	leaveq 
  180a05:	c3                   	retq   

0000000000180a06 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  180a06:	55                   	push   %rbp
  180a07:	48 89 e5             	mov    %rsp,%rbp
  180a0a:	53                   	push   %rbx
  180a0b:	48 83 ec 28          	sub    $0x28,%rsp
  180a0f:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  180a12:	48 c7 45 d8 1c 01 18 	movq   $0x18011c,-0x28(%rbp)
  180a19:	00 
    sp.s = s;
  180a1a:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  180a1e:	48 85 f6             	test   %rsi,%rsi
  180a21:	75 0b                	jne    180a2e <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  180a23:	8b 45 e0             	mov    -0x20(%rbp),%eax
  180a26:	29 d8                	sub    %ebx,%eax
}
  180a28:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  180a2c:	c9                   	leaveq 
  180a2d:	c3                   	retq   
        sp.end = s + size - 1;
  180a2e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  180a33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  180a37:	be 00 00 00 00       	mov    $0x0,%esi
  180a3c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  180a40:	e8 67 f8 ff ff       	callq  1802ac <printer_vprintf>
        *sp.s = 0;
  180a45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180a49:	c6 00 00             	movb   $0x0,(%rax)
  180a4c:	eb d5                	jmp    180a23 <vsnprintf+0x1d>

0000000000180a4e <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  180a4e:	55                   	push   %rbp
  180a4f:	48 89 e5             	mov    %rsp,%rbp
  180a52:	48 83 ec 50          	sub    $0x50,%rsp
  180a56:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180a5a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180a5e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  180a62:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180a69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180a6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180a71:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180a75:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  180a79:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180a7d:	e8 84 ff ff ff       	callq  180a06 <vsnprintf>
    va_end(val);
    return n;
}
  180a82:	c9                   	leaveq 
  180a83:	c3                   	retq   

0000000000180a84 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a84:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  180a89:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  180a8e:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a93:	48 83 c0 02          	add    $0x2,%rax
  180a97:	48 39 d0             	cmp    %rdx,%rax
  180a9a:	75 f2                	jne    180a8e <console_clear+0xa>
    }
    cursorpos = 0;
  180a9c:	c7 05 56 85 f3 ff 00 	movl   $0x0,-0xc7aaa(%rip)        # b8ffc <cursorpos>
  180aa3:	00 00 00 
}
  180aa6:	c3                   	retq   

0000000000180aa7 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  180aa7:	55                   	push   %rbp
  180aa8:	48 89 e5             	mov    %rsp,%rbp
  180aab:	48 83 ec 50          	sub    $0x50,%rsp
  180aaf:	49 89 f2             	mov    %rsi,%r10
  180ab2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  180ab6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180aba:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180abe:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  180ac2:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  180ac7:	85 ff                	test   %edi,%edi
  180ac9:	78 2e                	js     180af9 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  180acb:	48 63 ff             	movslq %edi,%rdi
  180ace:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  180ad5:	cc cc cc 
  180ad8:	48 89 f8             	mov    %rdi,%rax
  180adb:	48 f7 e2             	mul    %rdx
  180ade:	48 89 d0             	mov    %rdx,%rax
  180ae1:	48 c1 e8 02          	shr    $0x2,%rax
  180ae5:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  180ae9:	48 01 c2             	add    %rax,%rdx
  180aec:	48 29 d7             	sub    %rdx,%rdi
  180aef:	0f b6 b7 9d 0e 18 00 	movzbl 0x180e9d(%rdi),%esi
  180af6:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  180af9:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  180b00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180b04:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180b08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180b0c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  180b10:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180b14:	4c 89 d2             	mov    %r10,%rdx
  180b17:	8b 3d df 84 f3 ff    	mov    -0xc7b21(%rip),%edi        # b8ffc <cursorpos>
  180b1d:	e8 69 fe ff ff       	callq  18098b <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  180b22:	3d 30 07 00 00       	cmp    $0x730,%eax
  180b27:	ba 00 00 00 00       	mov    $0x0,%edx
  180b2c:	0f 4d c2             	cmovge %edx,%eax
  180b2f:	89 05 c7 84 f3 ff    	mov    %eax,-0xc7b39(%rip)        # b8ffc <cursorpos>
    }
}
  180b35:	c9                   	leaveq 
  180b36:	c3                   	retq   

0000000000180b37 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  180b37:	55                   	push   %rbp
  180b38:	48 89 e5             	mov    %rsp,%rbp
  180b3b:	53                   	push   %rbx
  180b3c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  180b43:	48 89 fb             	mov    %rdi,%rbx
  180b46:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  180b4a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  180b4e:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  180b52:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  180b56:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  180b5a:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  180b61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180b65:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  180b69:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  180b6d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  180b71:	ba 07 00 00 00       	mov    $0x7,%edx
  180b76:	be 67 0e 18 00       	mov    $0x180e67,%esi
  180b7b:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  180b82:	e8 ab f5 ff ff       	callq  180132 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  180b87:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  180b8b:	48 89 da             	mov    %rbx,%rdx
  180b8e:	be 99 00 00 00       	mov    $0x99,%esi
  180b93:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  180b9a:	e8 67 fe ff ff       	callq  180a06 <vsnprintf>
  180b9f:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  180ba2:	85 d2                	test   %edx,%edx
  180ba4:	7e 0f                	jle    180bb5 <kernel_panic+0x7e>
  180ba6:	83 c0 06             	add    $0x6,%eax
  180ba9:	48 98                	cltq   
  180bab:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  180bb2:	0a 
  180bb3:	75 2a                	jne    180bdf <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  180bb5:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  180bbc:	48 89 d9             	mov    %rbx,%rcx
  180bbf:	ba 71 0e 18 00       	mov    $0x180e71,%edx
  180bc4:	be 00 c0 00 00       	mov    $0xc000,%esi
  180bc9:	bf 30 07 00 00       	mov    $0x730,%edi
  180bce:	b8 00 00 00 00       	mov    $0x0,%eax
  180bd3:	e8 f8 fd ff ff       	callq  1809d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  180bd8:	48 89 df             	mov    %rbx,%rdi
  180bdb:	cd 30                	int    $0x30
 loop: goto loop;
  180bdd:	eb fe                	jmp    180bdd <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  180bdf:	48 63 c2             	movslq %edx,%rax
  180be2:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  180be8:	0f 94 c2             	sete   %dl
  180beb:	0f b6 d2             	movzbl %dl,%edx
  180bee:	48 29 d0             	sub    %rdx,%rax
  180bf1:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  180bf8:	ff 
  180bf9:	be 6f 0e 18 00       	mov    $0x180e6f,%esi
  180bfe:	e8 f1 f5 ff ff       	callq  1801f4 <strcpy>
  180c03:	eb b0                	jmp    180bb5 <kernel_panic+0x7e>

0000000000180c05 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  180c05:	55                   	push   %rbp
  180c06:	48 89 e5             	mov    %rsp,%rbp
  180c09:	48 89 f9             	mov    %rdi,%rcx
  180c0c:	41 89 f0             	mov    %esi,%r8d
  180c0f:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  180c12:	ba 78 0e 18 00       	mov    $0x180e78,%edx
  180c17:	be 00 c0 00 00       	mov    $0xc000,%esi
  180c1c:	bf 30 07 00 00       	mov    $0x730,%edi
  180c21:	b8 00 00 00 00       	mov    $0x0,%eax
  180c26:	e8 a5 fd ff ff       	callq  1809d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  180c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  180c30:	cd 30                	int    $0x30
 loop: goto loop;
  180c32:	eb fe                	jmp    180c32 <assert_fail+0x2d>
