Simple cooperative task switcher for 8051
=========================================

For use with SDCC.

Example:


```C
static __xdata uint8_t tcb1[64];
void code1(void)
{
	uint8_t n=0;
	while (1)
	{
		uart_hex(n++);
		uart_txs("code1\n");
		taskYield();
	}
}


static __xdata uint8_t tcb2[64];
void code2(void)
{
	uint8_t n=0;
	while (1)
	{
		uart_hex(n);
		n+=2;
		uart_txs("code2\n");
		taskYield();
	}
}



void scheduler(void)
{
	taskCreate(tcb1, code1);
	taskCreate(tcb2, code2);
	
	while (1)
	{
		taskRun(tcb1);
		taskRun(tcb2);
	}
}

```
