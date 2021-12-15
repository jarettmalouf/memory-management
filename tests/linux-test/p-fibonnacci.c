#include "process-linux.h"
#include "lib.h"
#include "malloc.h"
#include "stdlib.h"

#define ALLOC_SLOWDOWN 100
#define MAX_ALLOC 100
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

int fib(int n){
    if(n == 0)
        return 1;
    if(n == 1)
        return 1;
    return fib(n-1) + fib(n-2);
}

int is_char_num(char c){
    return c >= '0' && c <= '9';
}

int is_char_space(char c){
    return c == ' ' || c == '\n' || c == '\t' || c == '\f' || c == '\v' || c == '\r';
}

void process_main(void) {
    pid_t p = getpid();
    //clear console and toggle memory function off
    mem_tog(0);
    console_clear();
    // lets write a simple function
    // get input from serial
    char input[33] = {0};
    read_line(input, 32);
    app_printf(0, "input: %s\n", input);
    int mode = 0;
    int num = 0;
    for(uint64_t i = 0; i < sizeof(input) ; i++){
        if(mode == 0 && is_char_space(input[i]))
            continue;
        mode = 1;
        if(mode == 1 && !is_char_num(input[i]))
            break;
        num = num * 10 + (input[i] - '0');
    }
    if(num == 0)
        num = 5;


    app_printf(0, "Start of fib function with %d nums\n", num);
    int * str = malloc(sizeof(int) * num);
    assert(str != NULL);
    for(int i = 0 ; i < num; i++){
        str[i] = fib(i);
        app_printf(0, "%d ", str[i]);
    }
    exit(0);
    // After running out of memory, do nothing forever
    //while (1) {
    //    yield();
    //}
    //while (1) {
    //    yield();
    //}
    
}
