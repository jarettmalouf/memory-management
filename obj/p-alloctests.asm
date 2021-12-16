
obj/p-alloctests.full:     file format elf64-x86-64


Disassembly of section .text:

00000000002c0000 <process_main>:
#include "time.h"
#include "malloc.h"

extern uint8_t end[];

void process_main(void) {
  2c0000:	55                   	push   %rbp
  2c0001:	48 89 e5             	mov    %rsp,%rbp
  2c0004:	41 56                	push   %r14
  2c0006:	41 55                	push   %r13
  2c0008:	41 54                	push   %r12
  2c000a:	53                   	push   %rbx
  2c000b:	48 83 ec 20          	sub    $0x20,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  2c000f:	cd 31                	int    $0x31
  2c0011:	41 89 c4             	mov    %eax,%r12d
    
    pid_t p = getpid();
    srand(p);
  2c0014:	89 c7                	mov    %eax,%edi
  2c0016:	e8 6a 03 00 00       	callq  2c0385 <srand>

    // alloc int array of 10 elements
    int* array = (int *)malloc(sizeof(int) * 10);
  2c001b:	bf 28 00 00 00       	mov    $0x28,%edi
  2c0020:	e8 4e 12 00 00       	callq  2c1273 <malloc>
  2c0025:	48 89 c7             	mov    %rax,%rdi
  2c0028:	ba 00 00 00 00       	mov    $0x0,%edx
    
    // set array elements
    for(int  i = 0 ; i < 10; i++){
	array[i] = i;
  2c002d:	89 14 97             	mov    %edx,(%rdi,%rdx,4)
    for(int  i = 0 ; i < 10; i++){
  2c0030:	48 83 c2 01          	add    $0x1,%rdx
  2c0034:	48 83 fa 0a          	cmp    $0xa,%rdx
  2c0038:	75 f3                	jne    2c002d <process_main+0x2d>
    }

    // realloc array to size 20
    array = (int*)realloc(array, sizeof(int) * 20);
  2c003a:	be 50 00 00 00       	mov    $0x50,%esi
  2c003f:	e8 55 13 00 00       	callq  2c1399 <realloc>
  2c0044:	49 89 c5             	mov    %rax,%r13
  2c0047:	b8 00 00 00 00       	mov    $0x0,%eax

    // check if contents are same
    for(int i = 0 ; i < 10 ; i++){
	assert(array[i] == i);
  2c004c:	41 39 44 85 00       	cmp    %eax,0x0(%r13,%rax,4)
  2c0051:	75 64                	jne    2c00b7 <process_main+0xb7>
    for(int i = 0 ; i < 10 ; i++){
  2c0053:	48 83 c0 01          	add    $0x1,%rax
  2c0057:	48 83 f8 0a          	cmp    $0xa,%rax
  2c005b:	75 ef                	jne    2c004c <process_main+0x4c>
    }

    // alloc int array of size 30 using calloc
    int * array2 = (int *)calloc(30, sizeof(int));
  2c005d:	be 04 00 00 00       	mov    $0x4,%esi
  2c0062:	bf 1e 00 00 00       	mov    $0x1e,%edi
  2c0067:	e8 8d 12 00 00       	callq  2c12f9 <calloc>
  2c006c:	49 89 c6             	mov    %rax,%r14

    // assert array[i] == 0
    for(int i = 0 ; i < 30; i++){
  2c006f:	48 8d 50 78          	lea    0x78(%rax),%rdx
	assert(array2[i] == 0);
  2c0073:	8b 18                	mov    (%rax),%ebx
  2c0075:	85 db                	test   %ebx,%ebx
  2c0077:	75 52                	jne    2c00cb <process_main+0xcb>
    for(int i = 0 ; i < 30; i++){
  2c0079:	48 83 c0 04          	add    $0x4,%rax
  2c007d:	48 39 d0             	cmp    %rdx,%rax
  2c0080:	75 f1                	jne    2c0073 <process_main+0x73>
    }
    
    heap_info_struct info;
    if(heap_info(&info) == 0){
  2c0082:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
  2c0086:	e8 74 14 00 00       	callq  2c14ff <heap_info>
  2c008b:	85 c0                	test   %eax,%eax
  2c008d:	75 64                	jne    2c00f3 <process_main+0xf3>
	// check if allocations are in sorted order
	for(int  i = 1 ; i < info.num_allocs; i++){
  2c008f:	8b 55 c0             	mov    -0x40(%rbp),%edx
  2c0092:	83 fa 01             	cmp    $0x1,%edx
  2c0095:	7e 70                	jle    2c0107 <process_main+0x107>
  2c0097:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c009b:	8d 52 fe             	lea    -0x2(%rdx),%edx
  2c009e:	48 8d 54 d0 08       	lea    0x8(%rax,%rdx,8),%rdx
	    assert(info.size_array[i] < info.size_array[i-1]);
  2c00a3:	48 8b 30             	mov    (%rax),%rsi
  2c00a6:	48 39 70 08          	cmp    %rsi,0x8(%rax)
  2c00aa:	7d 33                	jge    2c00df <process_main+0xdf>
	for(int  i = 1 ; i < info.num_allocs; i++){
  2c00ac:	48 83 c0 08          	add    $0x8,%rax
  2c00b0:	48 39 d0             	cmp    %rdx,%rax
  2c00b3:	75 ee                	jne    2c00a3 <process_main+0xa3>
  2c00b5:	eb 50                	jmp    2c0107 <process_main+0x107>
	assert(array[i] == i);
  2c00b7:	ba e0 17 2c 00       	mov    $0x2c17e0,%edx
  2c00bc:	be 1a 00 00 00       	mov    $0x1a,%esi
  2c00c1:	bf ee 17 2c 00       	mov    $0x2c17ee,%edi
  2c00c6:	e8 de 16 00 00       	callq  2c17a9 <assert_fail>
	assert(array2[i] == 0);
  2c00cb:	ba fd 17 2c 00       	mov    $0x2c17fd,%edx
  2c00d0:	be 22 00 00 00       	mov    $0x22,%esi
  2c00d5:	bf ee 17 2c 00       	mov    $0x2c17ee,%edi
  2c00da:	e8 ca 16 00 00       	callq  2c17a9 <assert_fail>
	    assert(info.size_array[i] < info.size_array[i-1]);
  2c00df:	ba 20 18 2c 00       	mov    $0x2c1820,%edx
  2c00e4:	be 29 00 00 00       	mov    $0x29,%esi
  2c00e9:	bf ee 17 2c 00       	mov    $0x2c17ee,%edi
  2c00ee:	e8 b6 16 00 00       	callq  2c17a9 <assert_fail>
	}
    }
    else{
	app_printf(0, "heap_info failed\n");
  2c00f3:	be 0c 18 2c 00       	mov    $0x2c180c,%esi
  2c00f8:	bf 00 00 00 00       	mov    $0x0,%edi
  2c00fd:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0102:	e8 44 15 00 00       	callq  2c164b <app_printf>
    }
    
    // free array, array2
    free(array);
  2c0107:	4c 89 ef             	mov    %r13,%rdi
  2c010a:	e8 58 12 00 00       	callq  2c1367 <free>
    free(array2);
  2c010f:	4c 89 f7             	mov    %r14,%rdi
  2c0112:	e8 50 12 00 00       	callq  2c1367 <free>

    uint64_t total_time = 0;
  2c0117:	41 bd 00 00 00 00    	mov    $0x0,%r13d
/* rdtscp */
static uint64_t rdtsc(void) {
	uint64_t var;
	uint32_t hi, lo;

	__asm volatile
  2c011d:	0f 31                	rdtsc  
	    ("rdtsc" : "=a" (lo), "=d" (hi));

	var = ((uint64_t)hi << 32) | lo;
  2c011f:	48 c1 e2 20          	shl    $0x20,%rdx
  2c0123:	89 c0                	mov    %eax,%eax
  2c0125:	48 09 c2             	or     %rax,%rdx
  2c0128:	49 89 d6             	mov    %rdx,%r14
    int total_pages = 0;
    
    // allocate pages till no more memory
    while (1) {
	uint64_t time = rdtsc();
	void * ptr = malloc(PAGESIZE);
  2c012b:	bf 00 10 00 00       	mov    $0x1000,%edi
  2c0130:	e8 3e 11 00 00       	callq  2c1273 <malloc>
  2c0135:	48 89 c1             	mov    %rax,%rcx
	__asm volatile
  2c0138:	0f 31                	rdtsc  
	var = ((uint64_t)hi << 32) | lo;
  2c013a:	48 c1 e2 20          	shl    $0x20,%rdx
  2c013e:	89 c0                	mov    %eax,%eax
  2c0140:	48 09 c2             	or     %rax,%rdx
	total_time += (rdtsc() - time);
  2c0143:	4c 29 f2             	sub    %r14,%rdx
  2c0146:	49 01 d5             	add    %rdx,%r13
	if(ptr == NULL)
  2c0149:	48 85 c9             	test   %rcx,%rcx
  2c014c:	74 08                	je     2c0156 <process_main+0x156>
	    break;
	total_pages++;
  2c014e:	83 c3 01             	add    $0x1,%ebx
	*((int *)ptr) = p; // check write access
  2c0151:	44 89 21             	mov    %r12d,(%rcx)
    while (1) {
  2c0154:	eb c7                	jmp    2c011d <process_main+0x11d>
    }

    app_printf(p, "Total_time taken to alloc: %d Average time: %d\n", total_time, total_time/total_pages);
  2c0156:	48 63 db             	movslq %ebx,%rbx
  2c0159:	4c 89 e8             	mov    %r13,%rax
  2c015c:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0161:	48 f7 f3             	div    %rbx
  2c0164:	48 89 c1             	mov    %rax,%rcx
  2c0167:	4c 89 ea             	mov    %r13,%rdx
  2c016a:	be 50 18 2c 00       	mov    $0x2c1850,%esi
  2c016f:	44 89 e7             	mov    %r12d,%edi
  2c0172:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0177:	e8 cf 14 00 00       	callq  2c164b <app_printf>

// yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void yield(void) {
    asm volatile ("int %0" : /* no result */
  2c017c:	cd 32                	int    $0x32
  2c017e:	eb fc                	jmp    2c017c <process_main+0x17c>

00000000002c0180 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  2c0180:	48 89 f9             	mov    %rdi,%rcx
  2c0183:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  2c0185:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  2c018c:	00 
  2c018d:	72 08                	jb     2c0197 <console_putc+0x17>
        cp->cursor = console;
  2c018f:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  2c0196:	00 
    }
    if (c == '\n') {
  2c0197:	40 80 fe 0a          	cmp    $0xa,%sil
  2c019b:	74 16                	je     2c01b3 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  2c019d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  2c01a1:	48 8d 50 02          	lea    0x2(%rax),%rdx
  2c01a5:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  2c01a9:	40 0f b6 f6          	movzbl %sil,%esi
  2c01ad:	09 fe                	or     %edi,%esi
  2c01af:	66 89 30             	mov    %si,(%rax)
    }
}
  2c01b2:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  2c01b3:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  2c01b7:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  2c01be:	4c 89 c6             	mov    %r8,%rsi
  2c01c1:	48 d1 fe             	sar    %rsi
  2c01c4:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  2c01cb:	66 66 66 
  2c01ce:	48 89 f0             	mov    %rsi,%rax
  2c01d1:	48 f7 ea             	imul   %rdx
  2c01d4:	48 c1 fa 05          	sar    $0x5,%rdx
  2c01d8:	49 c1 f8 3f          	sar    $0x3f,%r8
  2c01dc:	4c 29 c2             	sub    %r8,%rdx
  2c01df:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  2c01e3:	48 c1 e2 04          	shl    $0x4,%rdx
  2c01e7:	89 f0                	mov    %esi,%eax
  2c01e9:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  2c01eb:	83 cf 20             	or     $0x20,%edi
  2c01ee:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c01f2:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  2c01f6:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  2c01fa:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  2c01fd:	83 c0 01             	add    $0x1,%eax
  2c0200:	83 f8 50             	cmp    $0x50,%eax
  2c0203:	75 e9                	jne    2c01ee <console_putc+0x6e>
  2c0205:	c3                   	retq   

00000000002c0206 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  2c0206:	48 8b 47 08          	mov    0x8(%rdi),%rax
  2c020a:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  2c020e:	73 0b                	jae    2c021b <string_putc+0x15>
        *sp->s++ = c;
  2c0210:	48 8d 50 01          	lea    0x1(%rax),%rdx
  2c0214:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  2c0218:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  2c021b:	c3                   	retq   

00000000002c021c <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  2c021c:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  2c021f:	48 85 d2             	test   %rdx,%rdx
  2c0222:	74 17                	je     2c023b <memcpy+0x1f>
  2c0224:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  2c0229:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  2c022e:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  2c0232:	48 83 c1 01          	add    $0x1,%rcx
  2c0236:	48 39 d1             	cmp    %rdx,%rcx
  2c0239:	75 ee                	jne    2c0229 <memcpy+0xd>
}
  2c023b:	c3                   	retq   

00000000002c023c <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  2c023c:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  2c023f:	48 39 fe             	cmp    %rdi,%rsi
  2c0242:	72 1d                	jb     2c0261 <memmove+0x25>
        while (n-- > 0) {
  2c0244:	b9 00 00 00 00       	mov    $0x0,%ecx
  2c0249:	48 85 d2             	test   %rdx,%rdx
  2c024c:	74 12                	je     2c0260 <memmove+0x24>
            *d++ = *s++;
  2c024e:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  2c0252:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  2c0256:	48 83 c1 01          	add    $0x1,%rcx
  2c025a:	48 39 ca             	cmp    %rcx,%rdx
  2c025d:	75 ef                	jne    2c024e <memmove+0x12>
}
  2c025f:	c3                   	retq   
  2c0260:	c3                   	retq   
    if (s < d && s + n > d) {
  2c0261:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  2c0265:	48 39 cf             	cmp    %rcx,%rdi
  2c0268:	73 da                	jae    2c0244 <memmove+0x8>
        while (n-- > 0) {
  2c026a:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  2c026e:	48 85 d2             	test   %rdx,%rdx
  2c0271:	74 ec                	je     2c025f <memmove+0x23>
            *--d = *--s;
  2c0273:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  2c0277:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  2c027a:	48 83 e9 01          	sub    $0x1,%rcx
  2c027e:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  2c0282:	75 ef                	jne    2c0273 <memmove+0x37>
  2c0284:	c3                   	retq   

00000000002c0285 <memset>:
void* memset(void* v, int c, size_t n) {
  2c0285:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  2c0288:	48 85 d2             	test   %rdx,%rdx
  2c028b:	74 12                	je     2c029f <memset+0x1a>
  2c028d:	48 01 fa             	add    %rdi,%rdx
  2c0290:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  2c0293:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  2c0296:	48 83 c1 01          	add    $0x1,%rcx
  2c029a:	48 39 ca             	cmp    %rcx,%rdx
  2c029d:	75 f4                	jne    2c0293 <memset+0xe>
}
  2c029f:	c3                   	retq   

00000000002c02a0 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  2c02a0:	80 3f 00             	cmpb   $0x0,(%rdi)
  2c02a3:	74 10                	je     2c02b5 <strlen+0x15>
  2c02a5:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  2c02aa:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  2c02ae:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  2c02b2:	75 f6                	jne    2c02aa <strlen+0xa>
  2c02b4:	c3                   	retq   
  2c02b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c02ba:	c3                   	retq   

00000000002c02bb <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  2c02bb:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  2c02be:	ba 00 00 00 00       	mov    $0x0,%edx
  2c02c3:	48 85 f6             	test   %rsi,%rsi
  2c02c6:	74 11                	je     2c02d9 <strnlen+0x1e>
  2c02c8:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  2c02cc:	74 0c                	je     2c02da <strnlen+0x1f>
        ++n;
  2c02ce:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  2c02d2:	48 39 d0             	cmp    %rdx,%rax
  2c02d5:	75 f1                	jne    2c02c8 <strnlen+0xd>
  2c02d7:	eb 04                	jmp    2c02dd <strnlen+0x22>
  2c02d9:	c3                   	retq   
  2c02da:	48 89 d0             	mov    %rdx,%rax
}
  2c02dd:	c3                   	retq   

00000000002c02de <strcpy>:
char* strcpy(char* dst, const char* src) {
  2c02de:	48 89 f8             	mov    %rdi,%rax
  2c02e1:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  2c02e6:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  2c02ea:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  2c02ed:	48 83 c2 01          	add    $0x1,%rdx
  2c02f1:	84 c9                	test   %cl,%cl
  2c02f3:	75 f1                	jne    2c02e6 <strcpy+0x8>
}
  2c02f5:	c3                   	retq   

00000000002c02f6 <strcmp>:
    while (*a && *b && *a == *b) {
  2c02f6:	0f b6 07             	movzbl (%rdi),%eax
  2c02f9:	84 c0                	test   %al,%al
  2c02fb:	74 1a                	je     2c0317 <strcmp+0x21>
  2c02fd:	0f b6 16             	movzbl (%rsi),%edx
  2c0300:	38 c2                	cmp    %al,%dl
  2c0302:	75 13                	jne    2c0317 <strcmp+0x21>
  2c0304:	84 d2                	test   %dl,%dl
  2c0306:	74 0f                	je     2c0317 <strcmp+0x21>
        ++a, ++b;
  2c0308:	48 83 c7 01          	add    $0x1,%rdi
  2c030c:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  2c0310:	0f b6 07             	movzbl (%rdi),%eax
  2c0313:	84 c0                	test   %al,%al
  2c0315:	75 e6                	jne    2c02fd <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  2c0317:	3a 06                	cmp    (%rsi),%al
  2c0319:	0f 97 c0             	seta   %al
  2c031c:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  2c031f:	83 d8 00             	sbb    $0x0,%eax
}
  2c0322:	c3                   	retq   

00000000002c0323 <strchr>:
    while (*s && *s != (char) c) {
  2c0323:	0f b6 07             	movzbl (%rdi),%eax
  2c0326:	84 c0                	test   %al,%al
  2c0328:	74 10                	je     2c033a <strchr+0x17>
  2c032a:	40 38 f0             	cmp    %sil,%al
  2c032d:	74 18                	je     2c0347 <strchr+0x24>
        ++s;
  2c032f:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  2c0333:	0f b6 07             	movzbl (%rdi),%eax
  2c0336:	84 c0                	test   %al,%al
  2c0338:	75 f0                	jne    2c032a <strchr+0x7>
        return NULL;
  2c033a:	40 84 f6             	test   %sil,%sil
  2c033d:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0342:	48 0f 44 c7          	cmove  %rdi,%rax
}
  2c0346:	c3                   	retq   
  2c0347:	48 89 f8             	mov    %rdi,%rax
  2c034a:	c3                   	retq   

00000000002c034b <rand>:
    if (!rand_seed_set) {
  2c034b:	83 3d b2 1c 00 00 00 	cmpl   $0x0,0x1cb2(%rip)        # 2c2004 <rand_seed_set>
  2c0352:	74 1b                	je     2c036f <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  2c0354:	69 05 a2 1c 00 00 0d 	imul   $0x19660d,0x1ca2(%rip),%eax        # 2c2000 <rand_seed>
  2c035b:	66 19 00 
  2c035e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  2c0363:	89 05 97 1c 00 00    	mov    %eax,0x1c97(%rip)        # 2c2000 <rand_seed>
    return rand_seed & RAND_MAX;
  2c0369:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  2c036e:	c3                   	retq   
    rand_seed = seed;
  2c036f:	c7 05 87 1c 00 00 9e 	movl   $0x30d4879e,0x1c87(%rip)        # 2c2000 <rand_seed>
  2c0376:	87 d4 30 
    rand_seed_set = 1;
  2c0379:	c7 05 81 1c 00 00 01 	movl   $0x1,0x1c81(%rip)        # 2c2004 <rand_seed_set>
  2c0380:	00 00 00 
}
  2c0383:	eb cf                	jmp    2c0354 <rand+0x9>

00000000002c0385 <srand>:
    rand_seed = seed;
  2c0385:	89 3d 75 1c 00 00    	mov    %edi,0x1c75(%rip)        # 2c2000 <rand_seed>
    rand_seed_set = 1;
  2c038b:	c7 05 6f 1c 00 00 01 	movl   $0x1,0x1c6f(%rip)        # 2c2004 <rand_seed_set>
  2c0392:	00 00 00 
}
  2c0395:	c3                   	retq   

00000000002c0396 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  2c0396:	55                   	push   %rbp
  2c0397:	48 89 e5             	mov    %rsp,%rbp
  2c039a:	41 57                	push   %r15
  2c039c:	41 56                	push   %r14
  2c039e:	41 55                	push   %r13
  2c03a0:	41 54                	push   %r12
  2c03a2:	53                   	push   %rbx
  2c03a3:	48 83 ec 58          	sub    $0x58,%rsp
  2c03a7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  2c03ab:	0f b6 02             	movzbl (%rdx),%eax
  2c03ae:	84 c0                	test   %al,%al
  2c03b0:	0f 84 b0 06 00 00    	je     2c0a66 <printer_vprintf+0x6d0>
  2c03b6:	49 89 fe             	mov    %rdi,%r14
  2c03b9:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  2c03bc:	41 89 f7             	mov    %esi,%r15d
  2c03bf:	e9 a4 04 00 00       	jmpq   2c0868 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  2c03c4:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  2c03c9:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  2c03cf:	45 84 e4             	test   %r12b,%r12b
  2c03d2:	0f 84 82 06 00 00    	je     2c0a5a <printer_vprintf+0x6c4>
        int flags = 0;
  2c03d8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  2c03de:	41 0f be f4          	movsbl %r12b,%esi
  2c03e2:	bf 81 1a 2c 00       	mov    $0x2c1a81,%edi
  2c03e7:	e8 37 ff ff ff       	callq  2c0323 <strchr>
  2c03ec:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  2c03ef:	48 85 c0             	test   %rax,%rax
  2c03f2:	74 55                	je     2c0449 <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  2c03f4:	48 81 e9 81 1a 2c 00 	sub    $0x2c1a81,%rcx
  2c03fb:	b8 01 00 00 00       	mov    $0x1,%eax
  2c0400:	d3 e0                	shl    %cl,%eax
  2c0402:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  2c0405:	48 83 c3 01          	add    $0x1,%rbx
  2c0409:	44 0f b6 23          	movzbl (%rbx),%r12d
  2c040d:	45 84 e4             	test   %r12b,%r12b
  2c0410:	75 cc                	jne    2c03de <printer_vprintf+0x48>
  2c0412:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  2c0416:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  2c041c:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  2c0423:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  2c0426:	0f 84 a9 00 00 00    	je     2c04d5 <printer_vprintf+0x13f>
        int length = 0;
  2c042c:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  2c0431:	0f b6 13             	movzbl (%rbx),%edx
  2c0434:	8d 42 bd             	lea    -0x43(%rdx),%eax
  2c0437:	3c 37                	cmp    $0x37,%al
  2c0439:	0f 87 c4 04 00 00    	ja     2c0903 <printer_vprintf+0x56d>
  2c043f:	0f b6 c0             	movzbl %al,%eax
  2c0442:	ff 24 c5 90 18 2c 00 	jmpq   *0x2c1890(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  2c0449:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  2c044d:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  2c0452:	3c 08                	cmp    $0x8,%al
  2c0454:	77 2f                	ja     2c0485 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  2c0456:	0f b6 03             	movzbl (%rbx),%eax
  2c0459:	8d 50 d0             	lea    -0x30(%rax),%edx
  2c045c:	80 fa 09             	cmp    $0x9,%dl
  2c045f:	77 5e                	ja     2c04bf <printer_vprintf+0x129>
  2c0461:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  2c0467:	48 83 c3 01          	add    $0x1,%rbx
  2c046b:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  2c0470:	0f be c0             	movsbl %al,%eax
  2c0473:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  2c0478:	0f b6 03             	movzbl (%rbx),%eax
  2c047b:	8d 50 d0             	lea    -0x30(%rax),%edx
  2c047e:	80 fa 09             	cmp    $0x9,%dl
  2c0481:	76 e4                	jbe    2c0467 <printer_vprintf+0xd1>
  2c0483:	eb 97                	jmp    2c041c <printer_vprintf+0x86>
        } else if (*format == '*') {
  2c0485:	41 80 fc 2a          	cmp    $0x2a,%r12b
  2c0489:	75 3f                	jne    2c04ca <printer_vprintf+0x134>
            width = va_arg(val, int);
  2c048b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c048f:	8b 07                	mov    (%rdi),%eax
  2c0491:	83 f8 2f             	cmp    $0x2f,%eax
  2c0494:	77 17                	ja     2c04ad <printer_vprintf+0x117>
  2c0496:	89 c2                	mov    %eax,%edx
  2c0498:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c049c:	83 c0 08             	add    $0x8,%eax
  2c049f:	89 07                	mov    %eax,(%rdi)
  2c04a1:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  2c04a4:	48 83 c3 01          	add    $0x1,%rbx
  2c04a8:	e9 6f ff ff ff       	jmpq   2c041c <printer_vprintf+0x86>
            width = va_arg(val, int);
  2c04ad:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c04b1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c04b5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c04b9:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c04bd:	eb e2                	jmp    2c04a1 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  2c04bf:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  2c04c5:	e9 52 ff ff ff       	jmpq   2c041c <printer_vprintf+0x86>
        int width = -1;
  2c04ca:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  2c04d0:	e9 47 ff ff ff       	jmpq   2c041c <printer_vprintf+0x86>
            ++format;
  2c04d5:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  2c04d9:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  2c04dd:	8d 48 d0             	lea    -0x30(%rax),%ecx
  2c04e0:	80 f9 09             	cmp    $0x9,%cl
  2c04e3:	76 13                	jbe    2c04f8 <printer_vprintf+0x162>
            } else if (*format == '*') {
  2c04e5:	3c 2a                	cmp    $0x2a,%al
  2c04e7:	74 33                	je     2c051c <printer_vprintf+0x186>
            ++format;
  2c04e9:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  2c04ec:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  2c04f3:	e9 34 ff ff ff       	jmpq   2c042c <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  2c04f8:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  2c04fd:	48 83 c2 01          	add    $0x1,%rdx
  2c0501:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  2c0504:	0f be c0             	movsbl %al,%eax
  2c0507:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  2c050b:	0f b6 02             	movzbl (%rdx),%eax
  2c050e:	8d 70 d0             	lea    -0x30(%rax),%esi
  2c0511:	40 80 fe 09          	cmp    $0x9,%sil
  2c0515:	76 e6                	jbe    2c04fd <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  2c0517:	48 89 d3             	mov    %rdx,%rbx
  2c051a:	eb 1c                	jmp    2c0538 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  2c051c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c0520:	8b 07                	mov    (%rdi),%eax
  2c0522:	83 f8 2f             	cmp    $0x2f,%eax
  2c0525:	77 23                	ja     2c054a <printer_vprintf+0x1b4>
  2c0527:	89 c2                	mov    %eax,%edx
  2c0529:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c052d:	83 c0 08             	add    $0x8,%eax
  2c0530:	89 07                	mov    %eax,(%rdi)
  2c0532:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  2c0534:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  2c0538:	85 c9                	test   %ecx,%ecx
  2c053a:	b8 00 00 00 00       	mov    $0x0,%eax
  2c053f:	0f 49 c1             	cmovns %ecx,%eax
  2c0542:	89 45 9c             	mov    %eax,-0x64(%rbp)
  2c0545:	e9 e2 fe ff ff       	jmpq   2c042c <printer_vprintf+0x96>
                precision = va_arg(val, int);
  2c054a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c054e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c0552:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c0556:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c055a:	eb d6                	jmp    2c0532 <printer_vprintf+0x19c>
        switch (*format) {
  2c055c:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  2c0561:	e9 f3 00 00 00       	jmpq   2c0659 <printer_vprintf+0x2c3>
            ++format;
  2c0566:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  2c056a:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  2c056f:	e9 bd fe ff ff       	jmpq   2c0431 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  2c0574:	85 c9                	test   %ecx,%ecx
  2c0576:	74 55                	je     2c05cd <printer_vprintf+0x237>
  2c0578:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c057c:	8b 07                	mov    (%rdi),%eax
  2c057e:	83 f8 2f             	cmp    $0x2f,%eax
  2c0581:	77 38                	ja     2c05bb <printer_vprintf+0x225>
  2c0583:	89 c2                	mov    %eax,%edx
  2c0585:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c0589:	83 c0 08             	add    $0x8,%eax
  2c058c:	89 07                	mov    %eax,(%rdi)
  2c058e:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  2c0591:	48 89 d0             	mov    %rdx,%rax
  2c0594:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  2c0598:	49 89 d0             	mov    %rdx,%r8
  2c059b:	49 f7 d8             	neg    %r8
  2c059e:	25 80 00 00 00       	and    $0x80,%eax
  2c05a3:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  2c05a7:	0b 45 a8             	or     -0x58(%rbp),%eax
  2c05aa:	83 c8 60             	or     $0x60,%eax
  2c05ad:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  2c05b0:	41 bc 1d 18 2c 00    	mov    $0x2c181d,%r12d
            break;
  2c05b6:	e9 35 01 00 00       	jmpq   2c06f0 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  2c05bb:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c05bf:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c05c3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c05c7:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c05cb:	eb c1                	jmp    2c058e <printer_vprintf+0x1f8>
  2c05cd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c05d1:	8b 07                	mov    (%rdi),%eax
  2c05d3:	83 f8 2f             	cmp    $0x2f,%eax
  2c05d6:	77 10                	ja     2c05e8 <printer_vprintf+0x252>
  2c05d8:	89 c2                	mov    %eax,%edx
  2c05da:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c05de:	83 c0 08             	add    $0x8,%eax
  2c05e1:	89 07                	mov    %eax,(%rdi)
  2c05e3:	48 63 12             	movslq (%rdx),%rdx
  2c05e6:	eb a9                	jmp    2c0591 <printer_vprintf+0x1fb>
  2c05e8:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c05ec:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  2c05f0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c05f4:	48 89 47 08          	mov    %rax,0x8(%rdi)
  2c05f8:	eb e9                	jmp    2c05e3 <printer_vprintf+0x24d>
        int base = 10;
  2c05fa:	be 0a 00 00 00       	mov    $0xa,%esi
  2c05ff:	eb 58                	jmp    2c0659 <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  2c0601:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c0605:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c0609:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c060d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c0611:	eb 60                	jmp    2c0673 <printer_vprintf+0x2dd>
  2c0613:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c0617:	8b 07                	mov    (%rdi),%eax
  2c0619:	83 f8 2f             	cmp    $0x2f,%eax
  2c061c:	77 10                	ja     2c062e <printer_vprintf+0x298>
  2c061e:	89 c2                	mov    %eax,%edx
  2c0620:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c0624:	83 c0 08             	add    $0x8,%eax
  2c0627:	89 07                	mov    %eax,(%rdi)
  2c0629:	44 8b 02             	mov    (%rdx),%r8d
  2c062c:	eb 48                	jmp    2c0676 <printer_vprintf+0x2e0>
  2c062e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c0632:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c0636:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c063a:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c063e:	eb e9                	jmp    2c0629 <printer_vprintf+0x293>
  2c0640:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  2c0643:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  2c064a:	bf 70 1a 2c 00       	mov    $0x2c1a70,%edi
  2c064f:	e9 e2 02 00 00       	jmpq   2c0936 <printer_vprintf+0x5a0>
            base = 16;
  2c0654:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  2c0659:	85 c9                	test   %ecx,%ecx
  2c065b:	74 b6                	je     2c0613 <printer_vprintf+0x27d>
  2c065d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c0661:	8b 01                	mov    (%rcx),%eax
  2c0663:	83 f8 2f             	cmp    $0x2f,%eax
  2c0666:	77 99                	ja     2c0601 <printer_vprintf+0x26b>
  2c0668:	89 c2                	mov    %eax,%edx
  2c066a:	48 03 51 10          	add    0x10(%rcx),%rdx
  2c066e:	83 c0 08             	add    $0x8,%eax
  2c0671:	89 01                	mov    %eax,(%rcx)
  2c0673:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  2c0676:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  2c067a:	85 f6                	test   %esi,%esi
  2c067c:	79 c2                	jns    2c0640 <printer_vprintf+0x2aa>
        base = -base;
  2c067e:	41 89 f1             	mov    %esi,%r9d
  2c0681:	f7 de                	neg    %esi
  2c0683:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  2c068a:	bf 50 1a 2c 00       	mov    $0x2c1a50,%edi
  2c068f:	e9 a2 02 00 00       	jmpq   2c0936 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  2c0694:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c0698:	8b 07                	mov    (%rdi),%eax
  2c069a:	83 f8 2f             	cmp    $0x2f,%eax
  2c069d:	77 1c                	ja     2c06bb <printer_vprintf+0x325>
  2c069f:	89 c2                	mov    %eax,%edx
  2c06a1:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c06a5:	83 c0 08             	add    $0x8,%eax
  2c06a8:	89 07                	mov    %eax,(%rdi)
  2c06aa:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  2c06ad:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  2c06b4:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  2c06b9:	eb c3                	jmp    2c067e <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  2c06bb:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c06bf:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c06c3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c06c7:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c06cb:	eb dd                	jmp    2c06aa <printer_vprintf+0x314>
            data = va_arg(val, char*);
  2c06cd:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c06d1:	8b 01                	mov    (%rcx),%eax
  2c06d3:	83 f8 2f             	cmp    $0x2f,%eax
  2c06d6:	0f 87 a5 01 00 00    	ja     2c0881 <printer_vprintf+0x4eb>
  2c06dc:	89 c2                	mov    %eax,%edx
  2c06de:	48 03 51 10          	add    0x10(%rcx),%rdx
  2c06e2:	83 c0 08             	add    $0x8,%eax
  2c06e5:	89 01                	mov    %eax,(%rcx)
  2c06e7:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  2c06ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  2c06f0:	8b 45 a8             	mov    -0x58(%rbp),%eax
  2c06f3:	83 e0 20             	and    $0x20,%eax
  2c06f6:	89 45 8c             	mov    %eax,-0x74(%rbp)
  2c06f9:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  2c06ff:	0f 85 21 02 00 00    	jne    2c0926 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  2c0705:	8b 45 a8             	mov    -0x58(%rbp),%eax
  2c0708:	89 45 88             	mov    %eax,-0x78(%rbp)
  2c070b:	83 e0 60             	and    $0x60,%eax
  2c070e:	83 f8 60             	cmp    $0x60,%eax
  2c0711:	0f 84 54 02 00 00    	je     2c096b <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  2c0717:	8b 45 a8             	mov    -0x58(%rbp),%eax
  2c071a:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  2c071d:	48 c7 45 a0 1d 18 2c 	movq   $0x2c181d,-0x60(%rbp)
  2c0724:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  2c0725:	83 f8 21             	cmp    $0x21,%eax
  2c0728:	0f 84 79 02 00 00    	je     2c09a7 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  2c072e:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  2c0731:	89 f8                	mov    %edi,%eax
  2c0733:	f7 d0                	not    %eax
  2c0735:	c1 e8 1f             	shr    $0x1f,%eax
  2c0738:	89 45 84             	mov    %eax,-0x7c(%rbp)
  2c073b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  2c073f:	0f 85 9e 02 00 00    	jne    2c09e3 <printer_vprintf+0x64d>
  2c0745:	84 c0                	test   %al,%al
  2c0747:	0f 84 96 02 00 00    	je     2c09e3 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  2c074d:	48 63 f7             	movslq %edi,%rsi
  2c0750:	4c 89 e7             	mov    %r12,%rdi
  2c0753:	e8 63 fb ff ff       	callq  2c02bb <strnlen>
  2c0758:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  2c075b:	8b 45 88             	mov    -0x78(%rbp),%eax
  2c075e:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  2c0761:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  2c0768:	83 f8 22             	cmp    $0x22,%eax
  2c076b:	0f 84 aa 02 00 00    	je     2c0a1b <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  2c0771:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  2c0775:	e8 26 fb ff ff       	callq  2c02a0 <strlen>
  2c077a:	8b 55 9c             	mov    -0x64(%rbp),%edx
  2c077d:	03 55 98             	add    -0x68(%rbp),%edx
  2c0780:	44 89 e9             	mov    %r13d,%ecx
  2c0783:	29 d1                	sub    %edx,%ecx
  2c0785:	29 c1                	sub    %eax,%ecx
  2c0787:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  2c078a:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  2c078d:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  2c0791:	75 2d                	jne    2c07c0 <printer_vprintf+0x42a>
  2c0793:	85 c9                	test   %ecx,%ecx
  2c0795:	7e 29                	jle    2c07c0 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  2c0797:	44 89 fa             	mov    %r15d,%edx
  2c079a:	be 20 00 00 00       	mov    $0x20,%esi
  2c079f:	4c 89 f7             	mov    %r14,%rdi
  2c07a2:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  2c07a5:	41 83 ed 01          	sub    $0x1,%r13d
  2c07a9:	45 85 ed             	test   %r13d,%r13d
  2c07ac:	7f e9                	jg     2c0797 <printer_vprintf+0x401>
  2c07ae:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  2c07b1:	85 ff                	test   %edi,%edi
  2c07b3:	b8 01 00 00 00       	mov    $0x1,%eax
  2c07b8:	0f 4f c7             	cmovg  %edi,%eax
  2c07bb:	29 c7                	sub    %eax,%edi
  2c07bd:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  2c07c0:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  2c07c4:	0f b6 07             	movzbl (%rdi),%eax
  2c07c7:	84 c0                	test   %al,%al
  2c07c9:	74 22                	je     2c07ed <printer_vprintf+0x457>
  2c07cb:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  2c07cf:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  2c07d2:	0f b6 f0             	movzbl %al,%esi
  2c07d5:	44 89 fa             	mov    %r15d,%edx
  2c07d8:	4c 89 f7             	mov    %r14,%rdi
  2c07db:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  2c07de:	48 83 c3 01          	add    $0x1,%rbx
  2c07e2:	0f b6 03             	movzbl (%rbx),%eax
  2c07e5:	84 c0                	test   %al,%al
  2c07e7:	75 e9                	jne    2c07d2 <printer_vprintf+0x43c>
  2c07e9:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  2c07ed:	8b 45 9c             	mov    -0x64(%rbp),%eax
  2c07f0:	85 c0                	test   %eax,%eax
  2c07f2:	7e 1d                	jle    2c0811 <printer_vprintf+0x47b>
  2c07f4:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  2c07f8:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  2c07fa:	44 89 fa             	mov    %r15d,%edx
  2c07fd:	be 30 00 00 00       	mov    $0x30,%esi
  2c0802:	4c 89 f7             	mov    %r14,%rdi
  2c0805:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  2c0808:	83 eb 01             	sub    $0x1,%ebx
  2c080b:	75 ed                	jne    2c07fa <printer_vprintf+0x464>
  2c080d:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  2c0811:	8b 45 98             	mov    -0x68(%rbp),%eax
  2c0814:	85 c0                	test   %eax,%eax
  2c0816:	7e 27                	jle    2c083f <printer_vprintf+0x4a9>
  2c0818:	89 c0                	mov    %eax,%eax
  2c081a:	4c 01 e0             	add    %r12,%rax
  2c081d:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  2c0821:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  2c0824:	41 0f b6 34 24       	movzbl (%r12),%esi
  2c0829:	44 89 fa             	mov    %r15d,%edx
  2c082c:	4c 89 f7             	mov    %r14,%rdi
  2c082f:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  2c0832:	49 83 c4 01          	add    $0x1,%r12
  2c0836:	49 39 dc             	cmp    %rbx,%r12
  2c0839:	75 e9                	jne    2c0824 <printer_vprintf+0x48e>
  2c083b:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  2c083f:	45 85 ed             	test   %r13d,%r13d
  2c0842:	7e 14                	jle    2c0858 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  2c0844:	44 89 fa             	mov    %r15d,%edx
  2c0847:	be 20 00 00 00       	mov    $0x20,%esi
  2c084c:	4c 89 f7             	mov    %r14,%rdi
  2c084f:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  2c0852:	41 83 ed 01          	sub    $0x1,%r13d
  2c0856:	75 ec                	jne    2c0844 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  2c0858:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  2c085c:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  2c0860:	84 c0                	test   %al,%al
  2c0862:	0f 84 fe 01 00 00    	je     2c0a66 <printer_vprintf+0x6d0>
        if (*format != '%') {
  2c0868:	3c 25                	cmp    $0x25,%al
  2c086a:	0f 84 54 fb ff ff    	je     2c03c4 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  2c0870:	0f b6 f0             	movzbl %al,%esi
  2c0873:	44 89 fa             	mov    %r15d,%edx
  2c0876:	4c 89 f7             	mov    %r14,%rdi
  2c0879:	41 ff 16             	callq  *(%r14)
            continue;
  2c087c:	4c 89 e3             	mov    %r12,%rbx
  2c087f:	eb d7                	jmp    2c0858 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  2c0881:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c0885:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  2c0889:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c088d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  2c0891:	e9 51 fe ff ff       	jmpq   2c06e7 <printer_vprintf+0x351>
            color = va_arg(val, int);
  2c0896:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c089a:	8b 07                	mov    (%rdi),%eax
  2c089c:	83 f8 2f             	cmp    $0x2f,%eax
  2c089f:	77 10                	ja     2c08b1 <printer_vprintf+0x51b>
  2c08a1:	89 c2                	mov    %eax,%edx
  2c08a3:	48 03 57 10          	add    0x10(%rdi),%rdx
  2c08a7:	83 c0 08             	add    $0x8,%eax
  2c08aa:	89 07                	mov    %eax,(%rdi)
  2c08ac:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  2c08af:	eb a7                	jmp    2c0858 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  2c08b1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c08b5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  2c08b9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c08bd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  2c08c1:	eb e9                	jmp    2c08ac <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  2c08c3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  2c08c7:	8b 01                	mov    (%rcx),%eax
  2c08c9:	83 f8 2f             	cmp    $0x2f,%eax
  2c08cc:	77 23                	ja     2c08f1 <printer_vprintf+0x55b>
  2c08ce:	89 c2                	mov    %eax,%edx
  2c08d0:	48 03 51 10          	add    0x10(%rcx),%rdx
  2c08d4:	83 c0 08             	add    $0x8,%eax
  2c08d7:	89 01                	mov    %eax,(%rcx)
  2c08d9:	8b 02                	mov    (%rdx),%eax
  2c08db:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  2c08de:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  2c08e2:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  2c08e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  2c08ec:	e9 ff fd ff ff       	jmpq   2c06f0 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  2c08f1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  2c08f5:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  2c08f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  2c08fd:	48 89 47 08          	mov    %rax,0x8(%rdi)
  2c0901:	eb d6                	jmp    2c08d9 <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  2c0903:	84 d2                	test   %dl,%dl
  2c0905:	0f 85 39 01 00 00    	jne    2c0a44 <printer_vprintf+0x6ae>
  2c090b:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  2c090f:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  2c0913:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  2c0917:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  2c091b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  2c0921:	e9 ca fd ff ff       	jmpq   2c06f0 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  2c0926:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  2c092c:	bf 70 1a 2c 00       	mov    $0x2c1a70,%edi
        if (flags & FLAG_NUMERIC) {
  2c0931:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  2c0936:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  2c093a:	4c 89 c1             	mov    %r8,%rcx
  2c093d:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  2c0941:	48 63 f6             	movslq %esi,%rsi
  2c0944:	49 83 ec 01          	sub    $0x1,%r12
  2c0948:	48 89 c8             	mov    %rcx,%rax
  2c094b:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0950:	48 f7 f6             	div    %rsi
  2c0953:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  2c0957:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  2c095b:	48 89 ca             	mov    %rcx,%rdx
  2c095e:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  2c0961:	48 39 d6             	cmp    %rdx,%rsi
  2c0964:	76 de                	jbe    2c0944 <printer_vprintf+0x5ae>
  2c0966:	e9 9a fd ff ff       	jmpq   2c0705 <printer_vprintf+0x36f>
                prefix = "-";
  2c096b:	48 c7 45 a0 85 18 2c 	movq   $0x2c1885,-0x60(%rbp)
  2c0972:	00 
            if (flags & FLAG_NEGATIVE) {
  2c0973:	8b 45 a8             	mov    -0x58(%rbp),%eax
  2c0976:	a8 80                	test   $0x80,%al
  2c0978:	0f 85 b0 fd ff ff    	jne    2c072e <printer_vprintf+0x398>
                prefix = "+";
  2c097e:	48 c7 45 a0 80 18 2c 	movq   $0x2c1880,-0x60(%rbp)
  2c0985:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  2c0986:	a8 10                	test   $0x10,%al
  2c0988:	0f 85 a0 fd ff ff    	jne    2c072e <printer_vprintf+0x398>
                prefix = " ";
  2c098e:	a8 08                	test   $0x8,%al
  2c0990:	ba 1d 18 2c 00       	mov    $0x2c181d,%edx
  2c0995:	b8 8d 1a 2c 00       	mov    $0x2c1a8d,%eax
  2c099a:	48 0f 44 c2          	cmove  %rdx,%rax
  2c099e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  2c09a2:	e9 87 fd ff ff       	jmpq   2c072e <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  2c09a7:	41 8d 41 10          	lea    0x10(%r9),%eax
  2c09ab:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  2c09b0:	0f 85 78 fd ff ff    	jne    2c072e <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  2c09b6:	4d 85 c0             	test   %r8,%r8
  2c09b9:	75 0d                	jne    2c09c8 <printer_vprintf+0x632>
  2c09bb:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  2c09c2:	0f 84 66 fd ff ff    	je     2c072e <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  2c09c8:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  2c09cc:	ba 87 18 2c 00       	mov    $0x2c1887,%edx
  2c09d1:	b8 82 18 2c 00       	mov    $0x2c1882,%eax
  2c09d6:	48 0f 44 c2          	cmove  %rdx,%rax
  2c09da:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  2c09de:	e9 4b fd ff ff       	jmpq   2c072e <printer_vprintf+0x398>
            len = strlen(data);
  2c09e3:	4c 89 e7             	mov    %r12,%rdi
  2c09e6:	e8 b5 f8 ff ff       	callq  2c02a0 <strlen>
  2c09eb:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  2c09ee:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  2c09f2:	0f 84 63 fd ff ff    	je     2c075b <printer_vprintf+0x3c5>
  2c09f8:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  2c09fc:	0f 84 59 fd ff ff    	je     2c075b <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  2c0a02:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  2c0a05:	89 ca                	mov    %ecx,%edx
  2c0a07:	29 c2                	sub    %eax,%edx
  2c0a09:	39 c1                	cmp    %eax,%ecx
  2c0a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0a10:	0f 4e d0             	cmovle %eax,%edx
  2c0a13:	89 55 9c             	mov    %edx,-0x64(%rbp)
  2c0a16:	e9 56 fd ff ff       	jmpq   2c0771 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  2c0a1b:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  2c0a1f:	e8 7c f8 ff ff       	callq  2c02a0 <strlen>
  2c0a24:	8b 7d 98             	mov    -0x68(%rbp),%edi
  2c0a27:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  2c0a2a:	44 89 e9             	mov    %r13d,%ecx
  2c0a2d:	29 f9                	sub    %edi,%ecx
  2c0a2f:	29 c1                	sub    %eax,%ecx
  2c0a31:	44 39 ea             	cmp    %r13d,%edx
  2c0a34:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0a39:	0f 4d c8             	cmovge %eax,%ecx
  2c0a3c:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  2c0a3f:	e9 2d fd ff ff       	jmpq   2c0771 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  2c0a44:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  2c0a47:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  2c0a4b:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  2c0a4f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  2c0a55:	e9 96 fc ff ff       	jmpq   2c06f0 <printer_vprintf+0x35a>
        int flags = 0;
  2c0a5a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  2c0a61:	e9 b0 f9 ff ff       	jmpq   2c0416 <printer_vprintf+0x80>
}
  2c0a66:	48 83 c4 58          	add    $0x58,%rsp
  2c0a6a:	5b                   	pop    %rbx
  2c0a6b:	41 5c                	pop    %r12
  2c0a6d:	41 5d                	pop    %r13
  2c0a6f:	41 5e                	pop    %r14
  2c0a71:	41 5f                	pop    %r15
  2c0a73:	5d                   	pop    %rbp
  2c0a74:	c3                   	retq   

00000000002c0a75 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  2c0a75:	55                   	push   %rbp
  2c0a76:	48 89 e5             	mov    %rsp,%rbp
  2c0a79:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  2c0a7d:	48 c7 45 f0 80 01 2c 	movq   $0x2c0180,-0x10(%rbp)
  2c0a84:	00 
        cpos = 0;
  2c0a85:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  2c0a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0a90:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  2c0a93:	48 63 ff             	movslq %edi,%rdi
  2c0a96:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  2c0a9d:	00 
  2c0a9e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  2c0aa2:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  2c0aa6:	e8 eb f8 ff ff       	callq  2c0396 <printer_vprintf>
    return cp.cursor - console;
  2c0aab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0aaf:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  2c0ab5:	48 d1 f8             	sar    %rax
}
  2c0ab8:	c9                   	leaveq 
  2c0ab9:	c3                   	retq   

00000000002c0aba <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  2c0aba:	55                   	push   %rbp
  2c0abb:	48 89 e5             	mov    %rsp,%rbp
  2c0abe:	48 83 ec 50          	sub    $0x50,%rsp
  2c0ac2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c0ac6:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c0aca:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  2c0ace:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  2c0ad5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c0ad9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c0add:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c0ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  2c0ae5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  2c0ae9:	e8 87 ff ff ff       	callq  2c0a75 <console_vprintf>
}
  2c0aee:	c9                   	leaveq 
  2c0aef:	c3                   	retq   

00000000002c0af0 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  2c0af0:	55                   	push   %rbp
  2c0af1:	48 89 e5             	mov    %rsp,%rbp
  2c0af4:	53                   	push   %rbx
  2c0af5:	48 83 ec 28          	sub    $0x28,%rsp
  2c0af9:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  2c0afc:	48 c7 45 d8 06 02 2c 	movq   $0x2c0206,-0x28(%rbp)
  2c0b03:	00 
    sp.s = s;
  2c0b04:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  2c0b08:	48 85 f6             	test   %rsi,%rsi
  2c0b0b:	75 0b                	jne    2c0b18 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  2c0b0d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  2c0b10:	29 d8                	sub    %ebx,%eax
}
  2c0b12:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  2c0b16:	c9                   	leaveq 
  2c0b17:	c3                   	retq   
        sp.end = s + size - 1;
  2c0b18:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  2c0b1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  2c0b21:	be 00 00 00 00       	mov    $0x0,%esi
  2c0b26:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  2c0b2a:	e8 67 f8 ff ff       	callq  2c0396 <printer_vprintf>
        *sp.s = 0;
  2c0b2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  2c0b33:	c6 00 00             	movb   $0x0,(%rax)
  2c0b36:	eb d5                	jmp    2c0b0d <vsnprintf+0x1d>

00000000002c0b38 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  2c0b38:	55                   	push   %rbp
  2c0b39:	48 89 e5             	mov    %rsp,%rbp
  2c0b3c:	48 83 ec 50          	sub    $0x50,%rsp
  2c0b40:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c0b44:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c0b48:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  2c0b4c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  2c0b53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c0b57:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c0b5b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c0b5f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  2c0b63:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  2c0b67:	e8 84 ff ff ff       	callq  2c0af0 <vsnprintf>
    va_end(val);
    return n;
}
  2c0b6c:	c9                   	leaveq 
  2c0b6d:	c3                   	retq   

00000000002c0b6e <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  2c0b6e:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  2c0b73:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  2c0b78:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  2c0b7d:	48 83 c0 02          	add    $0x2,%rax
  2c0b81:	48 39 d0             	cmp    %rdx,%rax
  2c0b84:	75 f2                	jne    2c0b78 <console_clear+0xa>
    }
    cursorpos = 0;
  2c0b86:	c7 05 6c 84 df ff 00 	movl   $0x0,-0x207b94(%rip)        # b8ffc <cursorpos>
  2c0b8d:	00 00 00 
}
  2c0b90:	c3                   	retq   

00000000002c0b91 <cmp_ptr_ascending>:
	}
    }
}

int cmp_ptr_ascending(const void *a, const void *b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  2c0b91:	48 8b 07             	mov    (%rdi),%rax
  2c0b94:	2b 06                	sub    (%rsi),%eax
}
  2c0b96:	c3                   	retq   

00000000002c0b97 <cmp_simple_descending>:
int cmp_simple_descending(const void *a, const void *b) {
    return *((long *) b) - *((long *) a);
  2c0b97:	48 8b 06             	mov    (%rsi),%rax
  2c0b9a:	2b 07                	sub    (%rdi),%eax
}
  2c0b9c:	c3                   	retq   

00000000002c0b9d <cmp_ptrs_by_size_descending>:
int cmp_ptrs_by_size_descending(const void *a, const void *b) {
    void *ptr_a = *((void **) a);
    void *ptr_b = *((void **) b);
    alloc_header *header_a = (alloc_header *) ((uintptr_t) ptr_a - ALLOC_HEADER_SIZE);
    alloc_header *header_b = (alloc_header *) ((uintptr_t) ptr_b - ALLOC_HEADER_SIZE);
    return header_b->sz - header_a->sz;
  2c0b9d:	48 8b 06             	mov    (%rsi),%rax
  2c0ba0:	48 8b 40 f8          	mov    -0x8(%rax),%rax
  2c0ba4:	48 8b 17             	mov    (%rdi),%rdx
  2c0ba7:	2b 42 f8             	sub    -0x8(%rdx),%eax
}
  2c0baa:	c3                   	retq   

00000000002c0bab <__quicksort>:
{
  2c0bab:	55                   	push   %rbp
  2c0bac:	48 89 e5             	mov    %rsp,%rbp
  2c0baf:	41 57                	push   %r15
  2c0bb1:	41 56                	push   %r14
  2c0bb3:	41 55                	push   %r13
  2c0bb5:	41 54                	push   %r12
  2c0bb7:	53                   	push   %rbx
  2c0bb8:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  2c0bbf:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  2c0bc6:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  2c0bcd:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  2c0bd4:	48 85 f6             	test   %rsi,%rsi
  2c0bd7:	0f 84 94 03 00 00    	je     2c0f71 <__quicksort+0x3c6>
  2c0bdd:	48 89 f0             	mov    %rsi,%rax
  2c0be0:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  2c0be3:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  2c0bea:	00 
  2c0beb:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  2c0bf2:	48 83 fe 04          	cmp    $0x4,%rsi
  2c0bf6:	0f 86 bd 02 00 00    	jbe    2c0eb9 <__quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  2c0bfc:	48 83 e8 01          	sub    $0x1,%rax
  2c0c00:	48 0f af c2          	imul   %rdx,%rax
  2c0c04:	48 01 f8             	add    %rdi,%rax
  2c0c07:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  2c0c0e:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  2c0c15:	00 00 00 00 
  2c0c19:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  2c0c20:	00 00 00 00 
	char *lo = base_ptr;
  2c0c24:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  2c0c2b:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  2c0c32:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  2c0c39:	48 f7 da             	neg    %rdx
  2c0c3c:	49 89 d7             	mov    %rdx,%r15
  2c0c3f:	e9 8c 01 00 00       	jmpq   2c0dd0 <__quicksort+0x225>
  2c0c44:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0c4b:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  2c0c50:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  2c0c57:	4c 89 e8             	mov    %r13,%rax
  2c0c5a:	0f b6 08             	movzbl (%rax),%ecx
  2c0c5d:	48 83 c0 01          	add    $0x1,%rax
  2c0c61:	0f b6 32             	movzbl (%rdx),%esi
  2c0c64:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  2c0c68:	48 83 c2 01          	add    $0x1,%rdx
  2c0c6c:	88 4a ff             	mov    %cl,-0x1(%rdx)
  2c0c6f:	48 39 c7             	cmp    %rax,%rdi
  2c0c72:	75 e6                	jne    2c0c5a <__quicksort+0xaf>
  2c0c74:	e9 92 01 00 00       	jmpq   2c0e0b <__quicksort+0x260>
  2c0c79:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0c80:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  2c0c85:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  2c0c8c:	4c 89 e8             	mov    %r13,%rax
  2c0c8f:	0f b6 08             	movzbl (%rax),%ecx
  2c0c92:	48 83 c0 01          	add    $0x1,%rax
  2c0c96:	0f b6 32             	movzbl (%rdx),%esi
  2c0c99:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  2c0c9d:	48 83 c2 01          	add    $0x1,%rdx
  2c0ca1:	88 4a ff             	mov    %cl,-0x1(%rdx)
  2c0ca4:	49 39 c4             	cmp    %rax,%r12
  2c0ca7:	75 e6                	jne    2c0c8f <__quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  2c0ca9:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  2c0cb0:	4c 89 ef             	mov    %r13,%rdi
  2c0cb3:	ff d3                	callq  *%rbx
  2c0cb5:	85 c0                	test   %eax,%eax
  2c0cb7:	0f 89 62 01 00 00    	jns    2c0e1f <__quicksort+0x274>
  2c0cbd:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  2c0cc4:	4c 89 e8             	mov    %r13,%rax
  2c0cc7:	0f b6 08             	movzbl (%rax),%ecx
  2c0cca:	48 83 c0 01          	add    $0x1,%rax
  2c0cce:	0f b6 32             	movzbl (%rdx),%esi
  2c0cd1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  2c0cd5:	48 83 c2 01          	add    $0x1,%rdx
  2c0cd9:	88 4a ff             	mov    %cl,-0x1(%rdx)
  2c0cdc:	49 39 c4             	cmp    %rax,%r12
  2c0cdf:	75 e6                	jne    2c0cc7 <__quicksort+0x11c>
jump_over:;
  2c0ce1:	e9 39 01 00 00       	jmpq   2c0e1f <__quicksort+0x274>
		  right_ptr -= size;
  2c0ce6:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  2c0ce9:	4c 89 e6             	mov    %r12,%rsi
  2c0cec:	4c 89 ef             	mov    %r13,%rdi
  2c0cef:	ff d3                	callq  *%rbx
  2c0cf1:	85 c0                	test   %eax,%eax
  2c0cf3:	78 f1                	js     2c0ce6 <__quicksort+0x13b>
	      if (left_ptr < right_ptr)
  2c0cf5:	4d 39 e6             	cmp    %r12,%r14
  2c0cf8:	72 1c                	jb     2c0d16 <__quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  2c0cfa:	74 5e                	je     2c0d5a <__quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  2c0cfc:	4d 39 e6             	cmp    %r12,%r14
  2c0cff:	77 63                	ja     2c0d64 <__quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  2c0d01:	4c 89 ee             	mov    %r13,%rsi
  2c0d04:	4c 89 f7             	mov    %r14,%rdi
  2c0d07:	ff d3                	callq  *%rbx
  2c0d09:	85 c0                	test   %eax,%eax
  2c0d0b:	79 dc                	jns    2c0ce9 <__quicksort+0x13e>
		  left_ptr += size;
  2c0d0d:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  2c0d14:	eb eb                	jmp    2c0d01 <__quicksort+0x156>
  2c0d16:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0d1d:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  2c0d21:	4c 89 e2             	mov    %r12,%rdx
  2c0d24:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  2c0d27:	0f b6 08             	movzbl (%rax),%ecx
  2c0d2a:	48 83 c0 01          	add    $0x1,%rax
  2c0d2e:	0f b6 32             	movzbl (%rdx),%esi
  2c0d31:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  2c0d35:	48 83 c2 01          	add    $0x1,%rdx
  2c0d39:	88 4a ff             	mov    %cl,-0x1(%rdx)
  2c0d3c:	48 39 f8             	cmp    %rdi,%rax
  2c0d3f:	75 e6                	jne    2c0d27 <__quicksort+0x17c>
		  if (mid == left_ptr)
  2c0d41:	4d 39 ee             	cmp    %r13,%r14
  2c0d44:	74 0f                	je     2c0d55 <__quicksort+0x1aa>
		  else if (mid == right_ptr)
  2c0d46:	4d 39 ec             	cmp    %r13,%r12
  2c0d49:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  2c0d4d:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  2c0d50:	49 89 fe             	mov    %rdi,%r14
  2c0d53:	eb a7                	jmp    2c0cfc <__quicksort+0x151>
  2c0d55:	4d 89 e5             	mov    %r12,%r13
  2c0d58:	eb f3                	jmp    2c0d4d <__quicksort+0x1a2>
		  left_ptr += size;
  2c0d5a:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  2c0d61:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  2c0d64:	4c 89 e0             	mov    %r12,%rax
  2c0d67:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  2c0d6e:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  2c0d75:	48 39 f8             	cmp    %rdi,%rax
  2c0d78:	0f 87 bf 00 00 00    	ja     2c0e3d <__quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  2c0d7e:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  2c0d85:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  2c0d88:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  2c0d8f:	48 39 f8             	cmp    %rdi,%rax
  2c0d92:	77 28                	ja     2c0dbc <__quicksort+0x211>
		  POP (lo, hi);
  2c0d94:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  2c0d9b:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  2c0d9f:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  2c0da6:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  2c0daa:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  2c0db1:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  2c0db5:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  2c0dbc:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  2c0dc3:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  2c0dca:	0f 86 e9 00 00 00    	jbe    2c0eb9 <__quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  2c0dd0:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  2c0dd7:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  2c0dde:	48 29 f8             	sub    %rdi,%rax
  2c0de1:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  2c0de8:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0ded:	48 f7 f1             	div    %rcx
  2c0df0:	48 d1 e8             	shr    %rax
  2c0df3:	48 0f af c1          	imul   %rcx,%rax
  2c0df7:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  2c0dfb:	48 89 fe             	mov    %rdi,%rsi
  2c0dfe:	4c 89 ef             	mov    %r13,%rdi
  2c0e01:	ff d3                	callq  *%rbx
  2c0e03:	85 c0                	test   %eax,%eax
  2c0e05:	0f 88 39 fe ff ff    	js     2c0c44 <__quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  2c0e0b:	4c 89 ee             	mov    %r13,%rsi
  2c0e0e:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  2c0e15:	ff d3                	callq  *%rbx
  2c0e17:	85 c0                	test   %eax,%eax
  2c0e19:	0f 88 5a fe ff ff    	js     2c0c79 <__quicksort+0xce>
	  left_ptr  = lo + size;
  2c0e1f:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  2c0e26:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  2c0e2d:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  2c0e34:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  2c0e38:	e9 c4 fe ff ff       	jmpq   2c0d01 <__quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  2c0e3d:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  2c0e44:	4c 29 f2             	sub    %r14,%rdx
  2c0e47:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  2c0e4e:	76 5d                	jbe    2c0ead <__quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  2c0e50:	48 39 d0             	cmp    %rdx,%rax
  2c0e53:	7e 2c                	jle    2c0e81 <__quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  2c0e55:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  2c0e5c:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  2c0e63:	48 89 38             	mov    %rdi,(%rax)
  2c0e66:	4c 89 60 08          	mov    %r12,0x8(%rax)
  2c0e6a:	48 83 c0 10          	add    $0x10,%rax
  2c0e6e:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  2c0e75:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  2c0e7c:	e9 3b ff ff ff       	jmpq   2c0dbc <__quicksort+0x211>
	      PUSH (left_ptr, hi);
  2c0e81:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  2c0e88:	4c 89 30             	mov    %r14,(%rax)
  2c0e8b:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  2c0e92:	48 89 78 08          	mov    %rdi,0x8(%rax)
  2c0e96:	48 83 c0 10          	add    $0x10,%rax
  2c0e9a:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  2c0ea1:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  2c0ea8:	e9 0f ff ff ff       	jmpq   2c0dbc <__quicksort+0x211>
	      hi = right_ptr;
  2c0ead:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  2c0eb4:	e9 03 ff ff ff       	jmpq   2c0dbc <__quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  2c0eb9:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  2c0ec0:	49 83 ef 01          	sub    $0x1,%r15
  2c0ec4:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  2c0ecb:	4c 0f af ff          	imul   %rdi,%r15
  2c0ecf:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  2c0ed6:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  2c0ed9:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  2c0ee0:	4c 01 e8             	add    %r13,%rax
  2c0ee3:	49 39 c7             	cmp    %rax,%r15
  2c0ee6:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  2c0eea:	4d 89 ec             	mov    %r13,%r12
  2c0eed:	49 01 fc             	add    %rdi,%r12
  2c0ef0:	4c 39 e0             	cmp    %r12,%rax
  2c0ef3:	72 66                	jb     2c0f5b <__quicksort+0x3b0>
  2c0ef5:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  2c0ef8:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  2c0eff:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  2c0f02:	4c 89 ee             	mov    %r13,%rsi
  2c0f05:	4c 89 f7             	mov    %r14,%rdi
  2c0f08:	ff d3                	callq  *%rbx
  2c0f0a:	85 c0                	test   %eax,%eax
  2c0f0c:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  2c0f10:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  2c0f17:	4d 39 f4             	cmp    %r14,%r12
  2c0f1a:	73 e6                	jae    2c0f02 <__quicksort+0x357>
  2c0f1c:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  2c0f23:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0f2a:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  2c0f2f:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  2c0f36:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  2c0f3d:	74 1c                	je     2c0f5b <__quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  2c0f3f:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  2c0f44:	49 83 c5 01          	add    $0x1,%r13
  2c0f48:	0f b6 30             	movzbl (%rax),%esi
  2c0f4b:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  2c0f4f:	48 83 c0 01          	add    $0x1,%rax
  2c0f53:	88 50 ff             	mov    %dl,-0x1(%rax)
  2c0f56:	49 39 cd             	cmp    %rcx,%r13
  2c0f59:	75 e4                	jne    2c0f3f <__quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  2c0f5b:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0f62:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  2c0f66:	48 f7 d8             	neg    %rax
  2c0f69:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  2c0f6c:	4d 39 f7             	cmp    %r14,%r15
  2c0f6f:	73 15                	jae    2c0f86 <__quicksort+0x3db>
}
  2c0f71:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  2c0f78:	5b                   	pop    %rbx
  2c0f79:	41 5c                	pop    %r12
  2c0f7b:	41 5d                	pop    %r13
  2c0f7d:	41 5e                	pop    %r14
  2c0f7f:	41 5f                	pop    %r15
  2c0f81:	5d                   	pop    %rbp
  2c0f82:	c3                   	retq   
		tmp_ptr -= size;
  2c0f83:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  2c0f86:	4c 89 e6             	mov    %r12,%rsi
  2c0f89:	4c 89 f7             	mov    %r14,%rdi
  2c0f8c:	ff d3                	callq  *%rbx
  2c0f8e:	85 c0                	test   %eax,%eax
  2c0f90:	78 f1                	js     2c0f83 <__quicksort+0x3d8>
	    tmp_ptr += size;
  2c0f92:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0f99:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  2c0f9d:	4c 39 f6             	cmp    %r14,%rsi
  2c0fa0:	75 17                	jne    2c0fb9 <__quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  2c0fa2:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  2c0fa9:	4c 01 f0             	add    %r14,%rax
  2c0fac:	4d 89 f4             	mov    %r14,%r12
  2c0faf:	49 39 c7             	cmp    %rax,%r15
  2c0fb2:	72 bd                	jb     2c0f71 <__quicksort+0x3c6>
  2c0fb4:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  2c0fb7:	eb cd                	jmp    2c0f86 <__quicksort+0x3db>
		while (--trav >= run_ptr)
  2c0fb9:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  2c0fbe:	4c 39 f7             	cmp    %r14,%rdi
  2c0fc1:	72 df                	jb     2c0fa2 <__quicksort+0x3f7>
  2c0fc3:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  2c0fc7:	4d 89 c2             	mov    %r8,%r10
  2c0fca:	eb 13                	jmp    2c0fdf <__quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  2c0fcc:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  2c0fcf:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  2c0fd2:	48 83 ef 01          	sub    $0x1,%rdi
  2c0fd6:	49 83 e8 01          	sub    $0x1,%r8
  2c0fda:	49 39 fa             	cmp    %rdi,%r10
  2c0fdd:	74 c3                	je     2c0fa2 <__quicksort+0x3f7>
		    char c = *trav;
  2c0fdf:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  2c0fe3:	4c 89 c0             	mov    %r8,%rax
  2c0fe6:	4c 39 c6             	cmp    %r8,%rsi
  2c0fe9:	77 e1                	ja     2c0fcc <__quicksort+0x421>
  2c0feb:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  2c0fee:	0f b6 08             	movzbl (%rax),%ecx
  2c0ff1:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  2c0ff3:	48 89 c1             	mov    %rax,%rcx
  2c0ff6:	4c 01 e8             	add    %r13,%rax
  2c0ff9:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  2c1000:	48 39 c6             	cmp    %rax,%rsi
  2c1003:	76 e9                	jbe    2c0fee <__quicksort+0x443>
  2c1005:	eb c8                	jmp    2c0fcf <__quicksort+0x424>

00000000002c1007 <append_free_list_node>:
int alloc_list_length = 0;

int break_made = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  2c1007:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  2c100e:	00 
    node->prev = NULL;
  2c100f:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  2c1016:	48 83 3d 12 10 00 00 	cmpq   $0x0,0x1012(%rip)        # 2c2030 <free_list_head>
  2c101d:	00 
  2c101e:	74 1d                	je     2c103d <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  2c1020:	48 8b 05 01 10 00 00 	mov    0x1001(%rip),%rax        # 2c2028 <free_list_tail>
  2c1027:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  2c102b:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  2c102e:	48 89 3d f3 0f 00 00 	mov    %rdi,0xff3(%rip)        # 2c2028 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  2c1035:	83 05 e4 0f 00 00 01 	addl   $0x1,0xfe4(%rip)        # 2c2020 <free_list_length>
}
  2c103c:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  2c103d:	48 83 3d e3 0f 00 00 	cmpq   $0x0,0xfe3(%rip)        # 2c2028 <free_list_tail>
  2c1044:	00 
  2c1045:	75 d9                	jne    2c1020 <append_free_list_node+0x19>
        free_list_head = node;
  2c1047:	48 89 3d e2 0f 00 00 	mov    %rdi,0xfe2(%rip)        # 2c2030 <free_list_head>
        free_list_tail = node;
  2c104e:	eb de                	jmp    2c102e <append_free_list_node+0x27>

00000000002c1050 <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  2c1050:	48 39 3d d9 0f 00 00 	cmp    %rdi,0xfd9(%rip)        # 2c2030 <free_list_head>
  2c1057:	74 30                	je     2c1089 <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  2c1059:	48 39 3d c8 0f 00 00 	cmp    %rdi,0xfc8(%rip)        # 2c2028 <free_list_tail>
  2c1060:	74 34                	je     2c1096 <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  2c1062:	48 8b 07             	mov    (%rdi),%rax
  2c1065:	48 85 c0             	test   %rax,%rax
  2c1068:	74 08                	je     2c1072 <remove_free_list_node+0x22>
  2c106a:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  2c106e:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  2c1072:	48 8b 47 08          	mov    0x8(%rdi),%rax
  2c1076:	48 85 c0             	test   %rax,%rax
  2c1079:	74 06                	je     2c1081 <remove_free_list_node+0x31>
  2c107b:	48 8b 17             	mov    (%rdi),%rdx
  2c107e:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  2c1081:	83 2d 98 0f 00 00 01 	subl   $0x1,0xf98(%rip)        # 2c2020 <free_list_length>
}
  2c1088:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  2c1089:	48 8b 47 08          	mov    0x8(%rdi),%rax
  2c108d:	48 89 05 9c 0f 00 00 	mov    %rax,0xf9c(%rip)        # 2c2030 <free_list_head>
  2c1094:	eb c3                	jmp    2c1059 <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  2c1096:	48 8b 07             	mov    (%rdi),%rax
  2c1099:	48 89 05 88 0f 00 00 	mov    %rax,0xf88(%rip)        # 2c2028 <free_list_tail>
  2c10a0:	eb c0                	jmp    2c1062 <remove_free_list_node+0x12>

00000000002c10a2 <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  2c10a2:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  2c10a9:	00 
    header->prev = NULL;
  2c10aa:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  2c10b1:	48 83 3d 5f 0f 00 00 	cmpq   $0x0,0xf5f(%rip)        # 2c2018 <alloc_list_head>
  2c10b8:	00 
  2c10b9:	74 1d                	je     2c10d8 <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  2c10bb:	48 8b 05 4e 0f 00 00 	mov    0xf4e(%rip),%rax        # 2c2010 <alloc_list_tail>
  2c10c2:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  2c10c6:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  2c10c9:	48 89 3d 40 0f 00 00 	mov    %rdi,0xf40(%rip)        # 2c2010 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  2c10d0:	83 05 35 0f 00 00 01 	addl   $0x1,0xf35(%rip)        # 2c200c <alloc_list_length>
}
  2c10d7:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  2c10d8:	48 83 3d 30 0f 00 00 	cmpq   $0x0,0xf30(%rip)        # 2c2010 <alloc_list_tail>
  2c10df:	00 
  2c10e0:	75 d9                	jne    2c10bb <append_alloc_list_node+0x19>
        alloc_list_head = header;
  2c10e2:	48 89 3d 2f 0f 00 00 	mov    %rdi,0xf2f(%rip)        # 2c2018 <alloc_list_head>
        alloc_list_tail = header;
  2c10e9:	eb de                	jmp    2c10c9 <append_alloc_list_node+0x27>

00000000002c10eb <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  2c10eb:	48 39 3d 26 0f 00 00 	cmp    %rdi,0xf26(%rip)        # 2c2018 <alloc_list_head>
  2c10f2:	74 30                	je     2c1124 <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  2c10f4:	48 39 3d 15 0f 00 00 	cmp    %rdi,0xf15(%rip)        # 2c2010 <alloc_list_tail>
  2c10fb:	74 34                	je     2c1131 <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  2c10fd:	48 8b 07             	mov    (%rdi),%rax
  2c1100:	48 85 c0             	test   %rax,%rax
  2c1103:	74 08                	je     2c110d <remove_alloc_list_node+0x22>
  2c1105:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  2c1109:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  2c110d:	48 8b 47 08          	mov    0x8(%rdi),%rax
  2c1111:	48 85 c0             	test   %rax,%rax
  2c1114:	74 06                	je     2c111c <remove_alloc_list_node+0x31>
  2c1116:	48 8b 17             	mov    (%rdi),%rdx
  2c1119:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  2c111c:	83 2d e9 0e 00 00 01 	subl   $0x1,0xee9(%rip)        # 2c200c <alloc_list_length>
}
  2c1123:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  2c1124:	48 8b 47 08          	mov    0x8(%rdi),%rax
  2c1128:	48 89 05 e9 0e 00 00 	mov    %rax,0xee9(%rip)        # 2c2018 <alloc_list_head>
  2c112f:	eb c3                	jmp    2c10f4 <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  2c1131:	48 8b 07             	mov    (%rdi),%rax
  2c1134:	48 89 05 d5 0e 00 00 	mov    %rax,0xed5(%rip)        # 2c2010 <alloc_list_tail>
  2c113b:	eb c0                	jmp    2c10fd <remove_alloc_list_node+0x12>

00000000002c113d <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  2c113d:	48 8b 05 ec 0e 00 00 	mov    0xeec(%rip),%rax        # 2c2030 <free_list_head>
    while (ptr != NULL) {
  2c1144:	48 85 c0             	test   %rax,%rax
  2c1147:	74 13                	je     2c115c <get_free_block+0x1f>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
  2c1149:	48 83 c7 18          	add    $0x18,%rdi
  2c114d:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  2c1151:	73 09                	jae    2c115c <get_free_block+0x1f>
        ptr = ptr->next;
  2c1153:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL) {
  2c1157:	48 85 c0             	test   %rax,%rax
  2c115a:	75 f1                	jne    2c114d <get_free_block+0x10>
    }
    return NULL;
}
  2c115c:	c3                   	retq   

00000000002c115d <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  2c115d:	55                   	push   %rbp
  2c115e:	48 89 e5             	mov    %rsp,%rbp
  2c1161:	53                   	push   %rbx
  2c1162:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  2c1166:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  2c116d:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  2c1174:	cc cc cc 
  2c1177:	48 89 d0             	mov    %rdx,%rax
  2c117a:	48 f7 e1             	mul    %rcx
  2c117d:	48 c1 ea 0f          	shr    $0xf,%rdx
  2c1181:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  2c1185:	48 c1 e7 0d          	shl    $0xd,%rdi
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  2c1189:	cd 3a                	int    $0x3a
  2c118b:	48 89 05 a6 0e 00 00 	mov    %rax,0xea6(%rip)        # 2c2038 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  2c1192:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  2c1196:	74 18                	je     2c11b0 <extend_heap+0x53>
  2c1198:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  2c119b:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  2c119f:	48 89 c7             	mov    %rax,%rdi
  2c11a2:	e8 60 fe ff ff       	callq  2c1007 <append_free_list_node>
    return node;
}
  2c11a7:	48 89 d8             	mov    %rbx,%rax
  2c11aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  2c11ae:	c9                   	leaveq 
  2c11af:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  2c11b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  2c11b5:	eb f0                	jmp    2c11a7 <extend_heap+0x4a>

00000000002c11b7 <contract_heap>:

void contract_heap(size_t sz) {
    size_t heap_contraction = -ROUNDUP(sz, BREAK_INCREMENT);
  2c11b7:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  2c11be:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  2c11c5:	cc cc cc 
  2c11c8:	48 89 d0             	mov    %rdx,%rax
  2c11cb:	48 f7 e1             	mul    %rcx
  2c11ce:	48 c1 ea 0f          	shr    $0xf,%rdx
  2c11d2:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  2c11d6:	48 c1 e7 0d          	shl    $0xd,%rdi
  2c11da:	48 f7 df             	neg    %rdi
  2c11dd:	cd 3a                	int    $0x3a
  2c11df:	48 89 05 52 0e 00 00 	mov    %rax,0xe52(%rip)        # 2c2038 <result.0>
    void *start = sbrk(heap_contraction);
    if (start == (void *) -1) return;
  2c11e6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  2c11ea:	74 0e                	je     2c11fa <contract_heap+0x43>
void contract_heap(size_t sz) {
  2c11ec:	55                   	push   %rbp
  2c11ed:	48 89 e5             	mov    %rsp,%rbp
  2c11f0:	48 89 c7             	mov    %rax,%rdi
    struct free_list_node *node = (struct free_list_node *) start;
    remove_free_list_node(node);
  2c11f3:	e8 58 fe ff ff       	callq  2c1050 <remove_free_list_node>
}
  2c11f8:	5d                   	pop    %rbp
  2c11f9:	c3                   	retq   
  2c11fa:	c3                   	retq   

00000000002c11fb <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  2c11fb:	55                   	push   %rbp
  2c11fc:	48 89 e5             	mov    %rsp,%rbp
  2c11ff:	41 56                	push   %r14
  2c1201:	41 55                	push   %r13
  2c1203:	41 54                	push   %r12
  2c1205:	53                   	push   %rbx
  2c1206:	48 89 fb             	mov    %rdi,%rbx
    // find a free block
    free_list_node *free_block = get_free_block(sz);
  2c1209:	e8 2f ff ff ff       	callq  2c113d <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  2c120e:	48 85 c0             	test   %rax,%rax
  2c1211:	74 57                	je     2c126a <allocate_to_free_block+0x6f>
  2c1213:	49 89 c4             	mov    %rax,%r12

    // remove that free block
    uintptr_t block_addr = (uintptr_t) free_block;
  2c1216:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  2c1219:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  2c121d:	48 89 c7             	mov    %rax,%rdi
  2c1220:	e8 2b fe ff ff       	callq  2c1050 <remove_free_list_node>

    // replace it with an alloc_header
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  2c1225:	48 8d 7b 07          	lea    0x7(%rbx),%rdi
  2c1229:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  2c122d:	49 89 7c 24 10       	mov    %rdi,0x10(%r12)

    // leftover stuff
    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  2c1232:	48 8d 47 18          	lea    0x18(%rdi),%rax
    size_t leftover = block_size - data_size;
  2c1236:	49 29 c5             	sub    %rax,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  2c1239:	49 83 fd 17          	cmp    $0x17,%r13
  2c123d:	77 1c                	ja     2c125b <allocate_to_free_block+0x60>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  2c123f:	4c 01 ef             	add    %r13,%rdi
  2c1242:	49 89 7c 24 10       	mov    %rdi,0x10(%r12)

    append_alloc_list_node(header);
  2c1247:	4c 89 e7             	mov    %r12,%rdi
  2c124a:	e8 53 fe ff ff       	callq  2c10a2 <append_alloc_list_node>
    return block_addr;
}
  2c124f:	4c 89 f0             	mov    %r14,%rax
  2c1252:	5b                   	pop    %rbx
  2c1253:	41 5c                	pop    %r12
  2c1255:	41 5d                	pop    %r13
  2c1257:	41 5e                	pop    %r14
  2c1259:	5d                   	pop    %rbp
  2c125a:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  2c125b:	49 8d 3c 04          	lea    (%r12,%rax,1),%rdi
        node->sz = leftover;
  2c125f:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  2c1263:	e8 9f fd ff ff       	callq  2c1007 <append_free_list_node>
  2c1268:	eb dd                	jmp    2c1247 <allocate_to_free_block+0x4c>
    if (free_block == NULL) return (uintptr_t) -1;
  2c126a:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  2c1271:	eb dc                	jmp    2c124f <allocate_to_free_block+0x54>

00000000002c1273 <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  2c1273:	b8 00 00 00 00       	mov    $0x0,%eax
  2c1278:	48 85 ff             	test   %rdi,%rdi
  2c127b:	74 46                	je     2c12c3 <malloc+0x50>
void *malloc(uint64_t sz) {
  2c127d:	55                   	push   %rbp
  2c127e:	48 89 e5             	mov    %rsp,%rbp
  2c1281:	53                   	push   %rbx
  2c1282:	48 83 ec 08          	sub    $0x8,%rsp
  2c1286:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  2c1289:	e8 6d ff ff ff       	callq  2c11fb <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  2c128e:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  2c1292:	75 25                	jne    2c12b9 <malloc+0x46>
        if (extend_heap(sz) == NULL) return NULL;
  2c1294:	48 89 df             	mov    %rbx,%rdi
  2c1297:	e8 c1 fe ff ff       	callq  2c115d <extend_heap>
  2c129c:	48 85 c0             	test   %rax,%rax
  2c129f:	74 1c                	je     2c12bd <malloc+0x4a>
        break_made = 1;
  2c12a1:	c7 05 5d 0d 00 00 01 	movl   $0x1,0xd5d(%rip)        # 2c2008 <break_made>
  2c12a8:	00 00 00 
        block_addr = allocate_to_free_block(sz);
  2c12ab:	48 89 df             	mov    %rbx,%rdi
  2c12ae:	e8 48 ff ff ff       	callq  2c11fb <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  2c12b3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  2c12b7:	74 db                	je     2c1294 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  2c12b9:	48 83 c0 18          	add    $0x18,%rax
}
  2c12bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  2c12c1:	c9                   	leaveq 
  2c12c2:	c3                   	retq   
  2c12c3:	c3                   	retq   

00000000002c12c4 <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  2c12c4:	48 89 f9             	mov    %rdi,%rcx
  2c12c7:	48 0f af ce          	imul   %rsi,%rcx
  2c12cb:	48 89 c8             	mov    %rcx,%rax
  2c12ce:	ba 00 00 00 00       	mov    $0x0,%edx
  2c12d3:	48 f7 f7             	div    %rdi
  2c12d6:	ba 01 00 00 00       	mov    $0x1,%edx
  2c12db:	48 39 f0             	cmp    %rsi,%rax
  2c12de:	74 03                	je     2c12e3 <overflow+0x1f>
}
  2c12e0:	89 d0                	mov    %edx,%eax
  2c12e2:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  2c12e3:	48 89 c8             	mov    %rcx,%rax
  2c12e6:	ba 00 00 00 00       	mov    $0x0,%edx
  2c12eb:	48 f7 f6             	div    %rsi
  2c12ee:	48 39 f8             	cmp    %rdi,%rax
  2c12f1:	0f 95 c2             	setne  %dl
  2c12f4:	0f b6 d2             	movzbl %dl,%edx
  2c12f7:	eb e7                	jmp    2c12e0 <overflow+0x1c>

00000000002c12f9 <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  2c12f9:	55                   	push   %rbp
  2c12fa:	48 89 e5             	mov    %rsp,%rbp
  2c12fd:	41 55                	push   %r13
  2c12ff:	41 54                	push   %r12
  2c1301:	53                   	push   %rbx
  2c1302:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  2c1306:	48 85 ff             	test   %rdi,%rdi
  2c1309:	74 54                	je     2c135f <calloc+0x66>
  2c130b:	48 89 fb             	mov    %rdi,%rbx
  2c130e:	49 89 f4             	mov    %rsi,%r12
  2c1311:	48 85 f6             	test   %rsi,%rsi
  2c1314:	74 49                	je     2c135f <calloc+0x66>
  2c1316:	e8 a9 ff ff ff       	callq  2c12c4 <overflow>
  2c131b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  2c1321:	85 c0                	test   %eax,%eax
  2c1323:	75 2c                	jne    2c1351 <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  2c1325:	49 0f af dc          	imul   %r12,%rbx
  2c1329:	48 83 c3 07          	add    $0x7,%rbx
  2c132d:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  2c1331:	48 89 df             	mov    %rbx,%rdi
  2c1334:	e8 3a ff ff ff       	callq  2c1273 <malloc>
  2c1339:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  2c133c:	48 85 c0             	test   %rax,%rax
  2c133f:	74 10                	je     2c1351 <calloc+0x58>

    memset(malloc_addr, 0, size);
  2c1341:	48 89 da             	mov    %rbx,%rdx
  2c1344:	be 00 00 00 00       	mov    $0x0,%esi
  2c1349:	48 89 c7             	mov    %rax,%rdi
  2c134c:	e8 34 ef ff ff       	callq  2c0285 <memset>
    return malloc_addr;
}
  2c1351:	4c 89 e8             	mov    %r13,%rax
  2c1354:	48 83 c4 08          	add    $0x8,%rsp
  2c1358:	5b                   	pop    %rbx
  2c1359:	41 5c                	pop    %r12
  2c135b:	41 5d                	pop    %r13
  2c135d:	5d                   	pop    %rbp
  2c135e:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  2c135f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  2c1365:	eb ea                	jmp    2c1351 <calloc+0x58>

00000000002c1367 <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  2c1367:	48 85 ff             	test   %rdi,%rdi
  2c136a:	74 2c                	je     2c1398 <free+0x31>
void free(void *ptr) {
  2c136c:	55                   	push   %rbp
  2c136d:	48 89 e5             	mov    %rsp,%rbp
  2c1370:	41 54                	push   %r12
  2c1372:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  2c1373:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  2c1377:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  2c137b:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  2c137f:	48 89 df             	mov    %rbx,%rdi
  2c1382:	e8 64 fd ff ff       	callq  2c10eb <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  2c1387:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  2c138b:	48 89 df             	mov    %rbx,%rdi
  2c138e:	e8 74 fc ff ff       	callq  2c1007 <append_free_list_node>
    return;
}
  2c1393:	5b                   	pop    %rbx
  2c1394:	41 5c                	pop    %r12
  2c1396:	5d                   	pop    %rbp
  2c1397:	c3                   	retq   
  2c1398:	c3                   	retq   

00000000002c1399 <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  2c1399:	55                   	push   %rbp
  2c139a:	48 89 e5             	mov    %rsp,%rbp
  2c139d:	41 54                	push   %r12
  2c139f:	53                   	push   %rbx
    if (ptr == NULL) return malloc(sz);
  2c13a0:	48 85 ff             	test   %rdi,%rdi
  2c13a3:	74 40                	je     2c13e5 <realloc+0x4c>
  2c13a5:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  2c13a8:	48 85 f6             	test   %rsi,%rsi
  2c13ab:	74 45                	je     2c13f2 <realloc+0x59>
    if (original_sz == sz) return ptr;
  2c13ad:	49 89 fc             	mov    %rdi,%r12
  2c13b0:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  2c13b4:	74 27                	je     2c13dd <realloc+0x44>
    void *malloc_addr = malloc(sz);
  2c13b6:	48 89 f7             	mov    %rsi,%rdi
  2c13b9:	e8 b5 fe ff ff       	callq  2c1273 <malloc>
  2c13be:	49 89 c4             	mov    %rax,%r12
    if (malloc_addr == NULL) return NULL;
  2c13c1:	48 85 c0             	test   %rax,%rax
  2c13c4:	74 17                	je     2c13dd <realloc+0x44>
    memcpy(malloc_addr, ptr, header->sz);
  2c13c6:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  2c13ca:	48 89 de             	mov    %rbx,%rsi
  2c13cd:	48 89 c7             	mov    %rax,%rdi
  2c13d0:	e8 47 ee ff ff       	callq  2c021c <memcpy>
    free(ptr);
  2c13d5:	48 89 df             	mov    %rbx,%rdi
  2c13d8:	e8 8a ff ff ff       	callq  2c1367 <free>
}
  2c13dd:	4c 89 e0             	mov    %r12,%rax
  2c13e0:	5b                   	pop    %rbx
  2c13e1:	41 5c                	pop    %r12
  2c13e3:	5d                   	pop    %rbp
  2c13e4:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  2c13e5:	48 89 f7             	mov    %rsi,%rdi
  2c13e8:	e8 86 fe ff ff       	callq  2c1273 <malloc>
  2c13ed:	49 89 c4             	mov    %rax,%r12
  2c13f0:	eb eb                	jmp    2c13dd <realloc+0x44>
    if (sz == 0) { free(ptr); return NULL; }
  2c13f2:	e8 70 ff ff ff       	callq  2c1367 <free>
  2c13f7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  2c13fd:	eb de                	jmp    2c13dd <realloc+0x44>

00000000002c13ff <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  2c13ff:	48 63 f6             	movslq %esi,%rsi
  2c1402:	48 c1 e6 04          	shl    $0x4,%rsi
  2c1406:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  2c1409:	48 8b 46 08          	mov    0x8(%rsi),%rax
  2c140d:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  2c1410:	48 63 d2             	movslq %edx,%rdx
  2c1413:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  2c1417:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  2c141b:	0f 94 c0             	sete   %al
  2c141e:	0f b6 c0             	movzbl %al,%eax
}
  2c1421:	c3                   	retq   

00000000002c1422 <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  2c1422:	55                   	push   %rbp
  2c1423:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  2c1426:	48 63 f6             	movslq %esi,%rsi
  2c1429:	48 c1 e6 04          	shl    $0x4,%rsi
  2c142d:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  2c1431:	48 63 d2             	movslq %edx,%rdx
  2c1434:	48 c1 e2 04          	shl    $0x4,%rdx
  2c1438:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  2c143c:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  2c1440:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  2c1444:	e8 07 fc ff ff       	callq  2c1050 <remove_free_list_node>
}
  2c1449:	5d                   	pop    %rbp
  2c144a:	c3                   	retq   

00000000002c144b <defrag>:

void defrag() {
  2c144b:	55                   	push   %rbp
  2c144c:	48 89 e5             	mov    %rsp,%rbp
  2c144f:	41 56                	push   %r14
  2c1451:	41 55                	push   %r13
  2c1453:	41 54                	push   %r12
  2c1455:	53                   	push   %rbx
    ptr_with_size ptrs_with_size[free_list_length];
  2c1456:	8b 0d c4 0b 00 00    	mov    0xbc4(%rip),%ecx        # 2c2020 <free_list_length>
  2c145c:	48 63 f1             	movslq %ecx,%rsi
  2c145f:	48 89 f0             	mov    %rsi,%rax
  2c1462:	48 c1 e0 04          	shl    $0x4,%rax
  2c1466:	48 29 c4             	sub    %rax,%rsp
  2c1469:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  2c146c:	48 8b 15 bd 0b 00 00 	mov    0xbbd(%rip),%rdx        # 2c2030 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  2c1473:	85 c9                	test   %ecx,%ecx
  2c1475:	7e 24                	jle    2c149b <defrag+0x50>
  2c1477:	4c 89 e8             	mov    %r13,%rax
  2c147a:	89 c9                	mov    %ecx,%ecx
  2c147c:	48 c1 e1 04          	shl    $0x4,%rcx
  2c1480:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  2c1483:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  2c1486:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  2c148a:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  2c148e:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  2c1492:	48 83 c0 10          	add    $0x10,%rax
  2c1496:	48 39 c8             	cmp    %rcx,%rax
  2c1499:	75 e8                	jne    2c1483 <defrag+0x38>
    }

    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &cmp_ptr_ascending);
  2c149b:	b9 91 0b 2c 00       	mov    $0x2c0b91,%ecx
  2c14a0:	ba 10 00 00 00       	mov    $0x10,%edx
  2c14a5:	4c 89 ef             	mov    %r13,%rdi
  2c14a8:	e8 fe f6 ff ff       	callq  2c0bab <__quicksort>

    int i = 0, length = free_list_length;
  2c14ad:	44 8b 35 6c 0b 00 00 	mov    0xb6c(%rip),%r14d        # 2c2020 <free_list_length>
    for (int j = 1; j < length; j++) {
  2c14b4:	41 83 fe 01          	cmp    $0x1,%r14d
  2c14b8:	7e 38                	jle    2c14f2 <defrag+0xa7>
  2c14ba:	bb 01 00 00 00       	mov    $0x1,%ebx
    int i = 0, length = free_list_length;
  2c14bf:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  2c14c5:	eb 15                	jmp    2c14dc <defrag+0x91>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  2c14c7:	89 da                	mov    %ebx,%edx
  2c14c9:	44 89 e6             	mov    %r12d,%esi
  2c14cc:	4c 89 ef             	mov    %r13,%rdi
  2c14cf:	e8 4e ff ff ff       	callq  2c1422 <coalesce>
    for (int j = 1; j < length; j++) {
  2c14d4:	83 c3 01             	add    $0x1,%ebx
  2c14d7:	41 39 de             	cmp    %ebx,%r14d
  2c14da:	74 16                	je     2c14f2 <defrag+0xa7>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  2c14dc:	89 da                	mov    %ebx,%edx
  2c14de:	44 89 e6             	mov    %r12d,%esi
  2c14e1:	4c 89 ef             	mov    %r13,%rdi
  2c14e4:	e8 16 ff ff ff       	callq  2c13ff <adjacent>
  2c14e9:	85 c0                	test   %eax,%eax
  2c14eb:	75 da                	jne    2c14c7 <defrag+0x7c>
  2c14ed:	41 89 dc             	mov    %ebx,%r12d
  2c14f0:	eb e2                	jmp    2c14d4 <defrag+0x89>
        else i = j;
    }
}
  2c14f2:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  2c14f6:	5b                   	pop    %rbx
  2c14f7:	41 5c                	pop    %r12
  2c14f9:	41 5d                	pop    %r13
  2c14fb:	41 5e                	pop    %r14
  2c14fd:	5d                   	pop    %rbp
  2c14fe:	c3                   	retq   

00000000002c14ff <heap_info>:

int heap_info(heap_info_struct * info) {
  2c14ff:	55                   	push   %rbp
  2c1500:	48 89 e5             	mov    %rsp,%rbp
  2c1503:	41 57                	push   %r15
  2c1505:	41 56                	push   %r14
  2c1507:	41 55                	push   %r13
  2c1509:	41 54                	push   %r12
  2c150b:	53                   	push   %rbx
  2c150c:	48 83 ec 18          	sub    $0x18,%rsp
  2c1510:	49 89 fd             	mov    %rdi,%r13
    int init_alloc_list_length = alloc_list_length;
  2c1513:	8b 05 f3 0a 00 00    	mov    0xaf3(%rip),%eax        # 2c200c <alloc_list_length>
  2c1519:	89 45 cc             	mov    %eax,-0x34(%rbp)
    
    // free space + largest free chunk
    int largest_free_chunk = 0;
    int free_space = 0;
    free_list_node *curr_ = free_list_head;
  2c151c:	48 8b 05 0d 0b 00 00 	mov    0xb0d(%rip),%rax        # 2c2030 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  2c1523:	8b 3d f7 0a 00 00    	mov    0xaf7(%rip),%edi        # 2c2020 <free_list_length>
  2c1529:	85 ff                	test   %edi,%edi
  2c152b:	7e 64                	jle    2c1591 <heap_info+0x92>
  2c152d:	ba 00 00 00 00       	mov    $0x0,%edx
    int free_space = 0;
  2c1532:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  2c1538:	bb 00 00 00 00       	mov    $0x0,%ebx
        int sz = (int) curr_->sz;
  2c153d:	48 8b 48 10          	mov    0x10(%rax),%rcx
        largest_free_chunk = MAX(largest_free_chunk, sz);
  2c1541:	39 cb                	cmp    %ecx,%ebx
  2c1543:	0f 4c d9             	cmovl  %ecx,%ebx
        free_space += sz;
  2c1546:	41 01 cc             	add    %ecx,%r12d
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  2c1549:	83 c2 01             	add    $0x1,%edx
  2c154c:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1550:	39 fa                	cmp    %edi,%edx
  2c1552:	75 e9                	jne    2c153d <heap_info+0x3e>
    }

    // size + ptr arrays
    if (init_alloc_list_length == 0) {
  2c1554:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  2c155a:	41 be 00 00 00 00    	mov    $0x0,%r14d
  2c1560:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  2c1564:	75 38                	jne    2c159e <heap_info+0x9f>
        info->size_array = NULL;
  2c1566:	4d 89 7d 08          	mov    %r15,0x8(%r13)
        info->ptr_array = NULL;
  2c156a:	4d 89 75 10          	mov    %r14,0x10(%r13)

        info->size_array = size_array;
        info->ptr_array = ptr_array;
    }

    info->num_allocs = init_alloc_list_length;
  2c156e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  2c1571:	41 89 45 00          	mov    %eax,0x0(%r13)
    info->largest_free_chunk = largest_free_chunk;
  2c1575:	41 89 5d 1c          	mov    %ebx,0x1c(%r13)
    info->free_space = free_space;
  2c1579:	45 89 65 18          	mov    %r12d,0x18(%r13)

    return 0;
  2c157d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c1582:	48 83 c4 18          	add    $0x18,%rsp
  2c1586:	5b                   	pop    %rbx
  2c1587:	41 5c                	pop    %r12
  2c1589:	41 5d                	pop    %r13
  2c158b:	41 5e                	pop    %r14
  2c158d:	41 5f                	pop    %r15
  2c158f:	5d                   	pop    %rbp
  2c1590:	c3                   	retq   
    int free_space = 0;
  2c1591:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  2c1597:	bb 00 00 00 00       	mov    $0x0,%ebx
  2c159c:	eb b6                	jmp    2c1554 <heap_info+0x55>
        long *size_array = (long *) malloc (sizeof(long) * init_alloc_list_length);
  2c159e:	48 63 45 cc          	movslq -0x34(%rbp),%rax
  2c15a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c15a6:	4c 8d 34 c5 00 00 00 	lea    0x0(,%rax,8),%r14
  2c15ad:	00 
  2c15ae:	4c 89 f7             	mov    %r14,%rdi
  2c15b1:	e8 bd fc ff ff       	callq  2c1273 <malloc>
  2c15b6:	49 89 c7             	mov    %rax,%r15
        void **ptr_array = (void **) malloc (sizeof(void *) * init_alloc_list_length);
  2c15b9:	4c 89 f7             	mov    %r14,%rdi
  2c15bc:	e8 b2 fc ff ff       	callq  2c1273 <malloc>
  2c15c1:	49 89 c6             	mov    %rax,%r14
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  2c15c4:	4d 85 ff             	test   %r15,%r15
  2c15c7:	74 68                	je     2c1631 <heap_info+0x132>
  2c15c9:	48 85 c0             	test   %rax,%rax
  2c15cc:	74 63                	je     2c1631 <heap_info+0x132>
        alloc_header *curr = alloc_list_head;
  2c15ce:	48 8b 15 43 0a 00 00 	mov    0xa43(%rip),%rdx        # 2c2018 <alloc_list_head>
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  2c15d5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  2c15d8:	85 c0                	test   %eax,%eax
  2c15da:	7e 24                	jle    2c1600 <heap_info+0x101>
  2c15dc:	89 c6                	mov    %eax,%esi
  2c15de:	b8 00 00 00 00       	mov    $0x0,%eax
            size_array[i] = (long) curr->sz;
  2c15e3:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  2c15e7:	49 89 0c c7          	mov    %rcx,(%r15,%rax,8)
            ptr_array[i] = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  2c15eb:	48 8d 4a 18          	lea    0x18(%rdx),%rcx
  2c15ef:	49 89 0c c6          	mov    %rcx,(%r14,%rax,8)
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  2c15f3:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  2c15f7:	48 83 c0 01          	add    $0x1,%rax
  2c15fb:	48 39 c6             	cmp    %rax,%rsi
  2c15fe:	75 e3                	jne    2c15e3 <heap_info+0xe4>
        __quicksort(size_array, init_alloc_list_length, sizeof(size_array[0]), &cmp_simple_descending);
  2c1600:	b9 97 0b 2c 00       	mov    $0x2c0b97,%ecx
  2c1605:	ba 08 00 00 00       	mov    $0x8,%edx
  2c160a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  2c160e:	4c 89 ff             	mov    %r15,%rdi
  2c1611:	e8 95 f5 ff ff       	callq  2c0bab <__quicksort>
        __quicksort(ptr_array, init_alloc_list_length, sizeof(size_array[0]), &cmp_ptrs_by_size_descending);
  2c1616:	b9 9d 0b 2c 00       	mov    $0x2c0b9d,%ecx
  2c161b:	ba 08 00 00 00       	mov    $0x8,%edx
  2c1620:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  2c1624:	4c 89 f7             	mov    %r14,%rdi
  2c1627:	e8 7f f5 ff ff       	callq  2c0bab <__quicksort>
        info->ptr_array = ptr_array;
  2c162c:	e9 35 ff ff ff       	jmpq   2c1566 <heap_info+0x67>
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  2c1631:	4c 89 ff             	mov    %r15,%rdi
  2c1634:	e8 2e fd ff ff       	callq  2c1367 <free>
  2c1639:	4c 89 f7             	mov    %r14,%rdi
  2c163c:	e8 26 fd ff ff       	callq  2c1367 <free>
  2c1641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  2c1646:	e9 37 ff ff ff       	jmpq   2c1582 <heap_info+0x83>

00000000002c164b <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  2c164b:	55                   	push   %rbp
  2c164c:	48 89 e5             	mov    %rsp,%rbp
  2c164f:	48 83 ec 50          	sub    $0x50,%rsp
  2c1653:	49 89 f2             	mov    %rsi,%r10
  2c1656:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  2c165a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c165e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c1662:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  2c1666:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  2c166b:	85 ff                	test   %edi,%edi
  2c166d:	78 2e                	js     2c169d <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  2c166f:	48 63 ff             	movslq %edi,%rdi
  2c1672:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  2c1679:	cc cc cc 
  2c167c:	48 89 f8             	mov    %rdi,%rax
  2c167f:	48 f7 e2             	mul    %rdx
  2c1682:	48 89 d0             	mov    %rdx,%rax
  2c1685:	48 c1 e8 02          	shr    $0x2,%rax
  2c1689:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  2c168d:	48 01 c2             	add    %rax,%rdx
  2c1690:	48 29 d7             	sub    %rdx,%rdi
  2c1693:	0f b6 b7 bd 1a 2c 00 	movzbl 0x2c1abd(%rdi),%esi
  2c169a:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  2c169d:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  2c16a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c16a8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c16ac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c16b0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  2c16b4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  2c16b8:	4c 89 d2             	mov    %r10,%rdx
  2c16bb:	8b 3d 3b 79 df ff    	mov    -0x2086c5(%rip),%edi        # b8ffc <cursorpos>
  2c16c1:	e8 af f3 ff ff       	callq  2c0a75 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  2c16c6:	3d 30 07 00 00       	cmp    $0x730,%eax
  2c16cb:	ba 00 00 00 00       	mov    $0x0,%edx
  2c16d0:	0f 4d c2             	cmovge %edx,%eax
  2c16d3:	89 05 23 79 df ff    	mov    %eax,-0x2086dd(%rip)        # b8ffc <cursorpos>
    }
}
  2c16d9:	c9                   	leaveq 
  2c16da:	c3                   	retq   

00000000002c16db <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  2c16db:	55                   	push   %rbp
  2c16dc:	48 89 e5             	mov    %rsp,%rbp
  2c16df:	53                   	push   %rbx
  2c16e0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  2c16e7:	48 89 fb             	mov    %rdi,%rbx
  2c16ea:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  2c16ee:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  2c16f2:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  2c16f6:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  2c16fa:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  2c16fe:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  2c1705:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c1709:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  2c170d:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  2c1711:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  2c1715:	ba 07 00 00 00       	mov    $0x7,%edx
  2c171a:	be 87 1a 2c 00       	mov    $0x2c1a87,%esi
  2c171f:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  2c1726:	e8 f1 ea ff ff       	callq  2c021c <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  2c172b:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  2c172f:	48 89 da             	mov    %rbx,%rdx
  2c1732:	be 99 00 00 00       	mov    $0x99,%esi
  2c1737:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  2c173e:	e8 ad f3 ff ff       	callq  2c0af0 <vsnprintf>
  2c1743:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  2c1746:	85 d2                	test   %edx,%edx
  2c1748:	7e 0f                	jle    2c1759 <kernel_panic+0x7e>
  2c174a:	83 c0 06             	add    $0x6,%eax
  2c174d:	48 98                	cltq   
  2c174f:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  2c1756:	0a 
  2c1757:	75 2a                	jne    2c1783 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  2c1759:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  2c1760:	48 89 d9             	mov    %rbx,%rcx
  2c1763:	ba 8f 1a 2c 00       	mov    $0x2c1a8f,%edx
  2c1768:	be 00 c0 00 00       	mov    $0xc000,%esi
  2c176d:	bf 30 07 00 00       	mov    $0x730,%edi
  2c1772:	b8 00 00 00 00       	mov    $0x0,%eax
  2c1777:	e8 3e f3 ff ff       	callq  2c0aba <console_printf>
    asm volatile ("int %0" : /* no result */
  2c177c:	48 89 df             	mov    %rbx,%rdi
  2c177f:	cd 30                	int    $0x30
 loop: goto loop;
  2c1781:	eb fe                	jmp    2c1781 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  2c1783:	48 63 c2             	movslq %edx,%rax
  2c1786:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  2c178c:	0f 94 c2             	sete   %dl
  2c178f:	0f b6 d2             	movzbl %dl,%edx
  2c1792:	48 29 d0             	sub    %rdx,%rax
  2c1795:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  2c179c:	ff 
  2c179d:	be 1c 18 2c 00       	mov    $0x2c181c,%esi
  2c17a2:	e8 37 eb ff ff       	callq  2c02de <strcpy>
  2c17a7:	eb b0                	jmp    2c1759 <kernel_panic+0x7e>

00000000002c17a9 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  2c17a9:	55                   	push   %rbp
  2c17aa:	48 89 e5             	mov    %rsp,%rbp
  2c17ad:	48 89 f9             	mov    %rdi,%rcx
  2c17b0:	41 89 f0             	mov    %esi,%r8d
  2c17b3:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  2c17b6:	ba 98 1a 2c 00       	mov    $0x2c1a98,%edx
  2c17bb:	be 00 c0 00 00       	mov    $0xc000,%esi
  2c17c0:	bf 30 07 00 00       	mov    $0x730,%edi
  2c17c5:	b8 00 00 00 00       	mov    $0x0,%eax
  2c17ca:	e8 eb f2 ff ff       	callq  2c0aba <console_printf>
    asm volatile ("int %0" : /* no result */
  2c17cf:	bf 00 00 00 00       	mov    $0x0,%edi
  2c17d4:	cd 30                	int    $0x30
 loop: goto loop;
  2c17d6:	eb fe                	jmp    2c17d6 <assert_fail+0x2d>
