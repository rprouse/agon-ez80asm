#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "listing.h"
#include "globals.h"
#include "utils.h"

char _listLine[LINEMAX];
uint32_t _listAddress;
uint8_t _listObjects[256];
uint8_t _listObjectCount;
bool _listFirstline = true;

char _listHeader[] = "PC      Output            Line   Source\n";

void listInit(void) {
    fprintf(file_list, "%s", _listHeader);
    _listFirstline = false;
    _listLine[0] = 0;
    _listObjectCount = 0;
}

void listStartLine(char *line) {
    strcpy(_listLine, line);
    trimRight(_listLine);
    _listAddress = address;
    _listObjectCount = 0;
}

void listEndLine(void) {
    uint8_t i, lines, objectnum;
    uint8_t linemax;

    linemax = (_listObjectCount / OBJECTS_PER_LINE);
    if(_listObjectCount % OBJECTS_PER_LINE) linemax ++;
    if(linemax == 0) linemax = 1;

    objectnum = 0;
    for(lines = 0; lines < linemax; lines++) {
        if(lines == 0) fprintf(file_list, "%06x  ",_listAddress);
        else fprintf(file_list, "        ");
        for(i = 0; i < OBJECTS_PER_LINE; i++) {
            if(objectnum < _listObjectCount) fprintf(file_list, "%02x ",_listObjects[objectnum++]);
            else fprintf(file_list, "   ");
        }
        if(lines == 0) fprintf(file_list, "%04d   %s\n",linenumber, _listLine);
        else fprintf(file_list, "\n");
    }
}

void listEmit8bit(uint8_t value) {
    _listObjects[_listObjectCount++] = value; 
}