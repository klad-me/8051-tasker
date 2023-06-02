#ifndef TASK_H
#define TASK_H


#include <stdint.h>


typedef void (*task_code_t)(void);


void taskCreate(uint8_t __xdata *tcb, task_code_t code);
void taskRun(uint8_t __xdata *tcb);
void taskYield(void);


#endif
