#include "common.h"
#include "debug.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256, TK_EQ, TK_NUM, TK_HEX, TK_NEQ, TK_AND, TK_REG, TK_DEREF
};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {
  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"==", TK_EQ},        // equal
  {"\\-", '-'},         // minus
  {"\\*", '*'},
  {"\\/", '/'},
  {"\\(", '('},
  {"\\)", ')'},
  {"0x[0-9A-Fa-f]+", TK_HEX},
  {"[0-9]+",TK_NUM},
  {"!=", TK_NEQ},
  {"&&", TK_AND},
  {"\\$0|ra|sp|gp|tp|pc", TK_REG},
  {"t[0-6]|s[0-9]|s1[0,1]|a[0-7]", TK_REG},
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))
#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      //panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        switch (rules[i].token_type) {
          case TK_NOTYPE: break;
          default: 
            tokens[nr_token].type = rules[i].token_type;
            memset(tokens[nr_token].str,'\0',32);
            strncpy(tokens[nr_token++].str, substr_start, substr_len);
            break;
        }
        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

bool check_parentheses(int p,int q){
  if(tokens[p].str[0] != '(' || tokens[q].str[0] != ')')return false;
  int flag = 1;
  for(int i = p + 1; i < q; i++){
    if(tokens[i].str[0] == '(') flag++;
    if(tokens[i].str[0] == ')') flag--;
    if(flag == 0)return false;
  }
  if(flag != 1){
    printf("bad parentheses!\n");
    assert(0);
  }
  return true;
}

uint64_t eval(int p,int q){
  uint64_t ans = 0;
  if(p > q)return 0;
  if(p == q){
    if(tokens[p].type == TK_HEX) sscanf(tokens[p].str,"%lx",&ans);
    else if(tokens[p].type == TK_NUM) sscanf(tokens[p].str,"%ld",&ans);
    else if(tokens[p].type == TK_REG) {
      bool success = false;
      ans = isa_reg_str2val(tokens[p].str, &success);
    }
    else assert(0);
    return ans;
  }
  else if(check_parentheses(p, q))return eval(p + 1, q - 1);
  else{
    uint64_t val1 = 0, val2 = 0;
    int op = 0, optype = 0, prio = 100;
    int parentnum = 0;
    for(int i = p; i <= q; i++){
      if(tokens[i].str[0] == '('){
        parentnum++;
        continue;
      }
      if(parentnum && tokens[i].str[0] == ')'){
        parentnum--;
        continue;
      }
      if(parentnum)continue;
      switch(tokens[i].type){
        case TK_EQ:
          if(prio > 1){op = i; optype = TK_EQ; prio = 1;}
          break;
        case TK_NEQ:
          if(prio > 1){op = i; optype = TK_NEQ; prio = 1;}
          break;
        case '+':
          if(prio >= 2){op = i;	optype = '+';	prio = 2;}
          break;
        case '-':
          if(prio >= 2){op = i; optype = '-';	prio = 2;}
          break;
        case '*':
          if(prio >= 3){op = i; optype = '*';	prio = 3;}
          break;
        case '/':
          if(prio >= 3){op = i;	optype = '/';	prio = 3;}
          break;
        case TK_AND:
          if(prio >= 4){op = i; optype = TK_AND; prio = 4;}
          break;
        case TK_REG:
          if(prio >= 5){op = i; optype = TK_REG; prio = 5;}
          break;
        case TK_DEREF:
          if(prio >= 6){op = i; optype = TK_DEREF; prio = 6;}
          break;
        default:break;
      }
    }

    val1 = eval(p, op - 1);
    val2 = eval(op + 1, q);
    switch (optype) {
      case '+': return val1 + val2;
      case '-': return val1 - val2;
      case '*': return val1 * val2;
      case '/': return val1 / val2;
      case TK_EQ: return val1 == val2;
      case TK_DEREF: {
        return paddr_read((paddr_t)(val2), 4);
      }
      default: assert(0);
    }
  }
}

// give a expression, return the value
word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }
  for (int i = 0; i < nr_token; i ++) {
    if (tokens[i].type == '*' && (i == 0 || tokens[i + 1].type == TK_HEX) ) {
      tokens[i].type = TK_DEREF;
    }
  }
  *success = true;
  return eval(0, nr_token - 1);
}
