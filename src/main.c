#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <time.h>
#include "console.h"
#include "getopt.h"
#include "config.h"
#include "globals.h"
#include "utils.h"
#include "assemble.h"
#include "label.h"
#include "macro.h"
#include "io.h"
#include "str2num.h"

void printVersion(void) {
    printf("ez80asm version %d.%d, (C)2024 - Jeroen Venema\r\n",VERSION,REVISION);
}

void printHelp(void) {
    printf("Usage: ez80asm <filename> [output filename] [OPTION]\n\r\r\n");
    printf("  -v\tList version information\r\n");
    printf("  -h\tList help information\r\n");
    printf("  -o\tOrg start address in hexadecimal format, default is %06X\r\n", START_ADDRESS);
    printf("  -b\tFillbyte in hexadecimal format, default is %02X\r\n", FILLBYTE);
    printf("  -a\tADL mode 1/0, default is %d\r\n", ADLMODE_START);
    printf("  -i\tIgnore value truncation warnings\r\n");
    printf("  -l\tListing to file with .lst extension\r\n");
    printf("  -s\tExport symbols\r\n");
    printf("  -d\tDirect listing to console\r\n");
    printf("  -c\tNo color codes in output\r\n");
    printf("  -x\tDisplay assembly statistics\r\n");
    printf("\r\n");
}

void displayStatistics(void) {
    printf("\r\nAssembly statistics\r\n======================\r\nLabel memory  : %d\r\nLabels        : %d\r\n\r\nMacro memory  : %d\r\nMacros        : %d\r\n\r\nInput buffers : %d\r\n---------------------\r\nTotal memory  : %d\r\n\r\nSources parsed: %d\r\nBinfiles read : %d\r\n\r\nOutput size   : %d\r\n", labelmemsize, getGlobalLabelCount(), macromemsize, macroCounter, filecontentsize, labelmemsize+macromemsize+filecontentsize, sourcefilecount, binfilecount, (address - start_address));
}

int main(int argc, char *argv[]) {
    int opt;
    bool exportsymbols, displaystatistics;
    char inputfilename[FILENAMEMAXLENGTH + 1];
    char outputfilename[FILENAMEMAXLENGTH + 1];
    int filenamecount = 0;
    outputfilename[0] = 0;
    clock_t begin, end;

    #ifdef UNIX
    uint8_t errorexit = 1;
    #else
    uint8_t errorexit = 0;
    #endif
    
    // option defaults from compiled configuration
    fillbyte = FILLBYTE;
    list_enabled = false;
    adlmode = ADLMODE_START;
    start_address = START_ADDRESS;
    exportsymbols = false;
    displaystatistics = false;
    coloroutput = true;
    filesbuffered = true;
    ignore_truncation_warnings = false;

    while ((opt = getopt(argc, argv, "-:lidvhsxcb:a:o:")) != -1) {
        switch(opt) {
            case 'a':
                if((strlen(optarg) != 1) || 
                   ((*optarg != '0') && (*optarg != '1'))) {
                    error("Incorrect ADL mode option -a",0);
                    return errorexit;
                }
                adlmode = (*optarg == '1')?true:false;
                printf("Setting ADL mode to %d\r\n",adlmode);
                break;
            case 's':
                printf("Exporting symbols\r\n");
                exportsymbols = true;
                break;
            case 'x':
                displaystatistics = true;
                break;
            case 'c':
                coloroutput = false;
                break;
            case 'd':
                consolelist_enabled = true;
                break;
            case 'l':
                list_enabled = true;
                break;
            case 'i':
                ignore_truncation_warnings = true;
                break;
            case 'v':
                printVersion();
                break;
            case 'h':
                printHelp();
                return 0;
            case 'b':
                if(strlen(optarg) > 2) {
                    error("option -b: Byte range error",0);
                    return errorexit;
                }
                fillbyte = str2hex(optarg);
                if(err_str2num) {
                    error("option -b: Invalid hexadecimal format",0);
                    return errorexit;
                }
                printf("Setting fillbyte to hex %02X\r\n", fillbyte);
                break;
            case 'o':
                if(strlen(optarg) > 6) {
                    error("option -o: Address longer than 24bit",0);
                    return errorexit;
                }
                start_address = str2hex(optarg);
                if(err_str2num) {
                    error("option -o: Invalid hexadecimal format",0);
                    return errorexit;
                }
                printf("Setting org address to hex %06X\r\n", start_address);
                break;
            case '?':
                vdp_set_text_colour(BRIGHT_RED);
                switch(optopt) {
                    case 'b':
                        printf("option -b: Missing fillbyte value\r\n");
                        break;
                    case 'a':
                        printf("option -a: Missing ADL mode value\r\n");
                        break;
                    case 'o':
                        printf("option -o: Missing start address value\r\n");
                        break;
                    default:
                        printf("Unknown option \'%c\'\r\n",optopt);
                        break;
                }
                vdp_set_text_colour(BRIGHT_WHITE);
                return errorexit;
            case 1:
                if(strlen(optarg) > FILENAMEMAXLENGTH) {
                    error("Filename too long",0);
                    return errorexit;
                }
                filenamecount++;
                switch(filenamecount) {
                    case 1:
                        strncpy(inputfilename, optarg, FILENAMEMAXLENGTH);
                        inputfilename[FILENAMEMAXLENGTH] = 0;
                        break;
                    case 2:
                        strncpy(outputfilename, optarg, FILENAMEMAXLENGTH);
                        outputfilename[FILENAMEMAXLENGTH] = 0;
                        break;
                    default:
                        error("Too many filenames provided",0);
                        return errorexit;
                        break;
                }
                break;
        }
    }

    if((argc == 1) || (filenamecount == 0)) {
        error("No input filename",0);
        printHelp();
        return errorexit;
    }

    if(!io_init(inputfilename, outputfilename)) {
        vdp_set_text_colour(BRIGHT_RED);
        printf("Error opening \"%s\"\r\n", inputfilename);
        vdp_set_text_colour(BRIGHT_WHITE);
        return errorexit;
    }
    printf("Assembling %s\r\n", inputfilename);
    if(list_enabled) printf("Listing to %s\r\n", filename[FILE_LISTING]);

    // Initialization
    init_instruction_table();
    initGlobalLabelTable();
    initAnonymousLabelTable();
    initMacros();
    
    // Assemble input to output
    begin = clock();
    assemble(inputfilename);
    end = clock();

    if(!global_errors) { 
        printf("Done in %.2f seconds\r\n",((double)(end - begin) / CLOCKS_PER_SEC));
    }
    io_close();

    if(global_errors) return errorexit;
    if(exportsymbols) saveGlobalLabelTable();
    if(displaystatistics) displayStatistics();
    
    return 0;
}
