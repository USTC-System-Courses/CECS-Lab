#include <readline/readline.h>
#include <readline/history.h>
#include "../include/common.h"
#include <stdlib.h>

extern void cpu_exec(unsigned int n);

extern word_t expr(char *e, bool *success);

static int is_batch_mode = false;

void init_regex();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(sim) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 0;
}

static int cmd_q(char *args) {
  // Lab2 TODO: implement the quit command
  return 0;
}

static int cmd_si(char *args) {
  char *arg = strtok(NULL, " ");
  // Lab2 TODO: implement the si [N] command
  return 0;
}

static int cmd_info(char *args) {
  char *arg = strtok(NULL, " ");
  if (arg == NULL) {
    /* no argument given */
    printf("Usage: info r\n");
  } 
  else if(strcmp(arg, "r") == 0) {
  // Lab2 TODO: implement the info r command

  } 
  else {
    printf("Usage: info r\n");
  }
  return 0;
}

static int cmd_x(char *args) {
  char *arg = strtok(NULL, " ");
  if (arg == NULL) {
    /* no argument given */
    printf("Usage: x n addr\n");
    return 0;
  }
  int n = atoi(arg);
  char *tokens = strtok(NULL, " ");
  if(tokens == NULL){
    printf("Usage: x n addr\n");
    return 0;
  }
  bool success;

  paddr_t addr = expr(tokens, &success);

  if(addr < (paddr_t)CONFIG_MBASE || addr >= (paddr_t)CONFIG_MBASE + (paddr_t)CONFIG_MSIZE){
    printf("addr out of scope!\n");
    return 0;
  }
  for(int i = 0; i < n; i++){
    printf(FMT_WORD ":\t" FMT_WORD "\n", addr + 4 * i, paddr_read(addr + 4 * i, 4));
  }
  return 0;
}

static int cmd_p(char *args) {
  bool success = false;
  if(args == NULL){
    printf("Usage: p [expr]\n");
    return 0;
  }
  word_t val = expr(args, &success);
  if (success){
    printf("DEC: %d\n", val);
    printf("HEX: " FMT_WORD "\n", val);
  }
  else printf("p: wrong expr!\n");
  return 0;
}

static int cmd_help(char *args);

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display informations about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },
  { "si", "Excute several steps", cmd_si },
  { "info", "Print the info of rigisters(r)", cmd_info },
  { "x", "Scan the mem", cmd_x },
  { "p", "Calc expressions", cmd_p},
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

// if batch mode is set, the simulator will execute the program without stop
void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    // run until end
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb(char *mode) {
  /* Compile the regular expressions. */
  init_regex();

  // if mode == "-b", then set batch mode
  if (mode && strcmp(mode, "-b") == 0) sdb_set_batch_mode();
}
