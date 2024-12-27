#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include "config.h"
#include "defines.h"
#include "utils.h"
#include "macro.h"
#include "globals.h"
#include "hash.h"
#include "config.h"
#include "instruction.h"
#include "moscalls.h"
#include "listing.h"
#include "str2num.h"

// Total allocated memory for macros
uint24_t macromemsize;
uint8_t macroCounter;

// Temp recording buffer
char _macro_content_buffer[MACRO_BUFFERSIZE + 1];

// internal tracking number per expansion. Starts at 0 and sequentially increases each expansion to create a macro expansion scope (for labels)
uint24_t macroExpandID;

void initMacros(void) {
    macromemsize = 0;
    macroCounter = 0;
}

// define macro from temporary buffer
macro_t *recordMacro(const char *name, uint8_t argcount, const char *arguments, uint16_t startlinenumber) {
    unsigned int len, i;
    uint8_t index;
    char *ptr;
    macro_t *tmp;
    instruction_t *try, *macroinstruction;

    // allocate space in buffer for macro_t struct
    tmp = (macro_t *)allocateMemory(sizeof(macro_t));
    macromemsize += sizeof(macro_t);
    if(tmp == NULL) return NULL;

    macroinstruction = (instruction_t *)allocateMemory(sizeof(instruction_t));
    macromemsize += sizeof(instruction_t);
    if(macroinstruction == NULL) return NULL;

    // Link together
    macroinstruction->type = MACRO;
    macroinstruction->macro = tmp;

    len = (unsigned int)strlen(name)+1;
    macroinstruction->name = (char *)allocateMemory(len);
    macromemsize += len;
    if(macroinstruction->name == NULL) return NULL;

    tmp->name = macroinstruction->name;
    strcpy(macroinstruction->name, name);
    macroinstruction->next = NULL;

    // allocate space for the body and copy
    tmp->body = (char*)allocateMemory(strlen(_macro_content_buffer)+1);
    if(tmp->body == NULL) return NULL;
    strcpy(tmp->body, _macro_content_buffer);

    // Set up macro specific content
    tmp->argcount = argcount;
    tmp->substitutions = NULL;
    if(argcount == 0) tmp->arguments = NULL;
    else {
        tmp->arguments = (char **)allocateMemory(argcount * sizeof(char *)); // allocate array of char*
        macromemsize += argcount * sizeof(char *);
        if(tmp->arguments == NULL) return NULL;
        tmp->substitutions = (char **)allocateMemory(argcount * sizeof(char *));
        macromemsize += argcount * sizeof(char *);
        if(tmp->substitutions == NULL) return NULL;
        if((tmp->arguments == NULL) || (tmp->substitutions == NULL)) return NULL;

        const char *argptr = arguments;
        for(i = 0; i < argcount; i++, argptr += MACROARGLENGTH+1) {
            len = (unsigned int)strlen(argptr);
            if(len > MACROARGLENGTH) {
                error(message[ERROR_MACROARGLENGTH],0);
                return NULL;
            }
            ptr = (char*)allocateMemory(len+1);
            macromemsize += len+1;
            if(ptr == NULL) return NULL;

            strcpy(ptr, argptr);
            tmp->arguments[i] = ptr;
            tmp->substitutions[i] = NULL;
        }
    }
    tmp->originfilename = currentcontentitem->name;
    tmp->originlinenumber = startlinenumber;

    index = lowercaseHash256(name);
    try = instruction_table[index];

    // First item on index
    if(try == NULL) {
        instruction_table[index] = macroinstruction;
        macroCounter++;
        return tmp;
    }

    // Collision on index, place at end of linked list if unique
    while(true) {
        if(fast_strcasecmp(try->name, name) == 0) {
            error(message[ERROR_MACRODEFINED],"%s",name);
            return NULL;
        }
        if(try->next) {
            try = try->next;
        }
        else {
            try->next = macroinstruction;
            macroCounter++;
            return tmp;
        }
    }
}

// replace the 'argument' substring in a target string, with the 'substitution' substring
// substitution will only happen on a full word match in the target string:
// An argument 'word' is a concatenation of alphanumerical characters, ending in a non-alphanumerical character
// Example arguments:
// - word
// - wOrD8
// - arg1
void replaceArgument(char *target, const char *argument, const char *substitution)
{
    char buffer[MACROARGSUBSTITUTIONLENGTH + 1] = { 0 };
    bool bufferdirty = false;
    char *insert_point = &buffer[0];
    const char *tmp = target;
    size_t argument_len = strlen(argument);
    size_t substitution_len = strlen(substitution);

    while (1) {
        const char *p = strstr(tmp, argument);

        // walked past last occurrence of argument; copy remaining part
        if (p == NULL) {
            strcpy(insert_point, tmp);
            break;
        }

        // copy part before potential argument
        memcpy(insert_point, tmp, p - tmp);
        insert_point += p - tmp;

        if(isalnum(*(p + argument_len)) == 0) {
            // whole word argument match - copy substitution string
            memcpy(insert_point, substitution, substitution_len);
            insert_point += substitution_len;            
            bufferdirty = true;
        }
        else {
            // part match - copy original string
            memcpy(insert_point, argument, argument_len);
            insert_point += argument_len;
        }

        // adjust pointers, move on
        tmp = p + argument_len;
    }

    // write altered string back to target
    if(bufferdirty) strcpy(target, buffer);
}

uint8_t macroExpandArg(char *dst, const char *src, const macro_t *m) {
    strcpy(dst, src);
    for(uint8_t i = 0; i < m->argcount; i++) {
        replaceArgument(dst, m->arguments[i], m->substitutions[i]);
    }
    return strlen(dst);
}

// read to temporary macro buffer
bool readMacroBody(struct contentitem *ci) {
    char *strend;
    bool foundend = false;
    char macroline[LINEMAX+1];
    uint16_t linelength,macrolength;

    _macro_content_buffer[0] = 0; // empty string
    strend = _macro_content_buffer;

    if(pass == ENDPASS && (listing)) listEndLine(); // print out first line of macro definition

    macrolength = 0;
    while((linelength = getnextContentLine(macroline, ci))) {
        ci->currentlinenumber++;
        char *src = macroline;

        if(pass == ENDPASS && (listing)) {
            listStartLine(src, ci->currentlinenumber);
            listEndLine();
        }

        // skip leading space
        while(*src && (isspace(*src))) src++;
        if(fast_strncasecmp(src, "macro", 5) == 0) {
            error(message[ERROR_MACROINMACRO],0);
            return false;
        }
        uint8_t skipdot = (*src == '.')?1:0;
        if(fast_strncasecmp(src+skipdot, "endmacro", 8) == 0) { 
            if(isspace(src[8+skipdot]) || (src[8+skipdot] == 0) || (src[8+skipdot] == ';')) {
                foundend = true;
                break;
            }
        }
        // concatenate to buffer end
        if(pass == STARTPASS) {
            if((macrolength + linelength) > MACRO_BUFFERSIZE) {
                error(message[ERROR_MACROTOOLARGE],0);
                return false;
            }
            char *tmp = macroline;
            while(*tmp) {
                *strend++ = *tmp++;
                macrolength++;
            }
            *strend = 0;
        }
    }
    if(!foundend) {
        error(message[ERROR_MACROUNFINISHED],0);
        return false;
    }
    return true;
}

bool parseMacroDefinition(char *str, char **name, uint8_t *argcount, char *arglist) {
    streamtoken_t token;

    if(!str || *str == 0 || getMnemonicToken(&token, str) == 0) {
        error(message[ERROR_MACRONAME],0);
        return false;
    }
    if(strlen(token.start) > MAXNAMELENGTH) {
        error(message[ERROR_MACRONAMELENGTH], "%s", token.start);
        return false;
    }
    *name = token.start;
    *argcount = 0;

    // parse arguments into 2D array
    currentline.next = token.next;
    if((token.terminator == ' ') || (token.terminator == '\t')) {
        while(currentline.next) {
            if(*argcount == MACROMAXARGS) error(message[ERROR_MACROARGCOUNT],"%s", token.start);
            if(getDefineValueToken(&token, currentline.next)) {
                if(strlen(token.start) > MACROARGLENGTH) {
                    error(message[ERROR_MACROARGLENGTH], "%s", token.start);
                    return false;
                }
                if(instruction_lookup(token.start)) {
                    error(message[ERROR_MACROARGNAME],"%s",token.start);
                    return false;
                }
                if(isvalidNumber(token.start)) {
                    error(message[ERROR_MACROARGNAME],"%s",token.start);
                    return false;
                }
                strcpy(arglist, token.start);
                (*argcount)++;
                arglist += MACROARGLENGTH+1;
            }
            if(token.terminator == ',') currentline.next = token.next;
            else {
                if((token.terminator != 0) &&(token.terminator != ';')) error(message[ERROR_LISTFORMAT],0);
                currentline.next = NULL; 
            }
        }
    }
    return true;
}

bool defineMacro(char *definition, struct contentitem *ci) {
    uint8_t argcount;
    char arglist[MACROMAXARGS][MACROARGLENGTH + 1];
    char *macroname;

    if(!parseMacroDefinition(definition, &macroname, &argcount, (char *)arglist)) return false;

    if(!recordMacro(macroname, argcount, (char *)arglist, ci->currentlinenumber)) {
        error(message[ERROR_MACROMEMORYALLOCATION],0);
        return false;
    }
    return true;
}


bool parseMacroArguments(macro_t *macro, char *invocation, char (*substitutionlist)[MACROARGSUBSTITUTIONLENGTH + 1]) {
    streamtoken_t token;
    uint8_t argcount = 0, tokenlength;
    char listbuffer[LINEMAX+1] = {"Args: "};

    while(invocation) {
        tokenlength = getDefineValueToken(&token, invocation);
        if(tokenlength) {
            argcount++;
            if(argcount > macro->argcount) {
                error(message[ERROR_MACROINCORRECTARG],"%d provided, %d expected", argcount, macro->argcount);
                return false;
            }
            if(tokenlength > MACROARGSUBSTITUTIONLENGTH) {
                error(message[ERROR_MACROARGSUBSTLENGTH],"%s",token.start);
                return false;
            }
            strcpy(substitutionlist[argcount-1], token.start);              // copy substitution argument
            macro->substitutions[argcount-1] = substitutionlist[argcount-1];  // set pointer in macro structure for later processing
            if((pass == ENDPASS) && listing) sprintf(listbuffer + strlen(listbuffer), "%s=%s ", macro->arguments[argcount-1], token.start);
        }
        if(token.terminator == ',') invocation = token.next;
        else {
            if((token.terminator != 0) &&(token.terminator != ';')) error(message[ERROR_LISTFORMAT],0);
            invocation = NULL; 
        }
    }
    if(argcount != macro->argcount) {
        error(message[ERROR_MACROINCORRECTARG],"%d provided, %d expected", argcount, macro->argcount);
        return false;
    }
    // List out argument substitution
    if(listing && argcount == 0) sprintf(listbuffer + strlen(listbuffer), "none");
    if((pass == ENDPASS) && listing) listPrintComment(listbuffer);
    return true;
}