#ifndef WEENSYOS_PROCESS_H
#define WEENSYOS_PROCESS_H
#include "lib.h"
#include "x86-64.h"
#if WEENSYOS_KERNEL
#error "process.h should not be used by kernel code."
#endif

// process.h
//
//    Support code for WeensyOS processes.


// SYSTEM CALLS

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
                  : "i" (INT_SYS_GETPID)
                  : "cc", "memory");
    return result;
}

// yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void yield(void) {
    asm volatile ("int %0" : /* no result */
                  : "i" (INT_SYS_YIELD)
                  : "cc", "memory");
}

// sys_page_alloc(addr)
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    static int result;
    asm volatile ("int %1" :  "=a" (result)
                  : "i" (INT_SYS_PAGE_ALLOC), "D" /* %rdi */ (addr)
                  : "cc", "memory");
    return result;
}


// fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
                  : "i" (INT_SYS_FORK)
                  : "cc", "memory");
    return result;
}

// exit()
//    Exit this process. Does not return.
static inline void exit(void) __attribute__((noreturn));
static inline void exit(void) {
    asm volatile ("int %0" : /* no result */
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
}

// panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
}

// mapping
// looks up the virtual memory mapping for addr for the current process 
// and stores it inside map. [map, sizeof(vampping)) address should be 
// allocated, writable addresses to the process, otherwise syscall will 
// not write anything to the variable
static inline void mapping(uintptr_t addr, void * map){
    asm volatile ("int %0" : /* no result */
                  : "i" (INT_SYS_MAPPING), "D" /* %rdi */ (map), "S" /* %rsi */ (addr)
                  : "cc", "memory");
}

// mem_tog
// toggles kernels printing of memory space for process if pid is its processID
// if pid == 0, toggles state globally (preference to global over local)
static inline void mem_tog(pid_t p) {
    asm volatile ("int %0" : /* no result */
                  : "i" (INT_SYS_MEM_TOG), "D" /* %rdi */ (p)
                  : "cc", "memory");
}

// brk(addr)
//     change the location of the program break to addr
//     program break defines the end of the process's data segment
//     increasing the program break has the effect of allocating memory to the process
//     decreasing the break deallocates memory
//     on success, returns 0
//     on failure, return -1
//     brk cannot exceed MEMSIZE_VIRTUAL, and cannot be lower than data segment (loaded
//     by the loader)

static inline int brk(const void* addr) {
    static int result;
    asm volatile ("int %1" :  "=a" (result)
                  : "i" (INT_SYS_BRK), "D" /* %rdi */ (addr)
                  : "cc", "memory");
    return result;
}

// sbrk(increment)
//     increment the location of the program break by `increment` bytes
//     program break defines the end of the process's data segment
//     Calling sbrk() with an increment of 0 can be used to find the current location of the program break
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
                  : "i" (INT_SYS_SBRK), "D" /* %rdi */ (increment)
                  : "cc", "memory");
    return result;
}

// OTHER HELPER FUNCTIONS

// app_printf(format, ...)
//    Calls console_printf() (see lib.h). The cursor position is read from
//    `cursorpos`, a shared variable defined by the kernel, and written back
//    into that variable. The initial color is based on the current process ID.
void app_printf(int colorid, const char* format, ...);

#endif
