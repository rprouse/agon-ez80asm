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

#ifdef UNIX
#define EXIT_ERROR EXIT_FAILURE
#else
#define EXIT_ERROR 0
#endif

char inputfilename[FILENAMEMAXLENGTH + 1];
char outputfilename[FILENAMEMAXLENGTH + 1];
bool noaction;

void printVersion(void) {
    printf("ez80asm version %d.%d, (C)2024 - Jeroen Venema\r\n",VERSION,REVISION);
}

void printHelp(void) {
    printf("Usage: ez80asm <filename> [output filename] [OPTION]\n\r\r\n");
    printf("  -v\tList version information only\r\n");
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
    printf("  -m\tMinimum memory configuration\r\n");
    printf("\r\n");
}

void displayStatistics(void) {
    int outputsize;

    FILE *fh = ioOpenfile(filename[FILE_OUTPUT], "rb");
    if(fh == 0) outputsize = 0;
    else {
        outputsize = ioGetfilesize(fh);
        fclose(fh);
    }
    printf("\r\nAssembly statistics\r\n=============================\r\nLabel memory         : %6d\r\nLabels               : %6d\r\n\r\nMacro memory         : %6d\r\nMacros               : %6d\r\n\r\nInput buffers        : %6d\r\n-----------------------------\r\nTotal dynamic memory : %6d\r\n\r\nSources parsed       : %6d\r\nBinfiles read        : %6d\r\n\r\nOutput size          : %6d\r\n\r\n", labelmemsize, getGlobalLabelCount(), macromemsize, macroCounter, filecontentsize, labelmemsize+macromemsize+filecontentsize, sourcefilecount, binfilecount, outputsize);
}

void parseOptions(int argc, char *argv[]) {
    int opt;
    int filenamecount = 0;

    while ((opt = getopt(argc, argv, "-:lidvhsxcmb:a:o:")) != -1) {
        switch(opt) {
            case 'a':
                if((strlen(optarg) != 1) || 
                   ((*optarg != '0') && (*optarg != '1'))) {
                    error("Incorrect ADL mode option -a",0);
                    return;
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
            case 'm':
                printf("Setting minimum memory configuration\r\n");
                completefilebuffering = false;
                break;
            case 'l':
                list_enabled = true;
                break;
            case 'i':
                ignore_truncation_warnings = true;
                break;
            case 'v':
                printVersion();
                noaction = true;
                return;
            case 'h':
                printHelp();
                noaction = true;
                return;
            case 'b':
                if(strlen(optarg) > 2) {
                    error("option -b: Byte range error",0);
                    return;
                }
                fillbyte = str2hex(optarg);
                if(err_str2num) {
                    error("option -b: Invalid hexadecimal format",0);
                    return;
                }
                printf("Setting fillbyte to hex %02X\r\n", fillbyte);
                break;
            case 'o':
                if(strlen(optarg) > 6) {
                    error("option -o: Address longer than 24bit",0);
                    return;
                }
                start_address = str2hex(optarg);
                if(err_str2num) {
                    error("option -o: Invalid hexadecimal format",0);
                    return;
                }
                printf("Setting org address to hex %06X\r\n", start_address);
                break;
            case '?':
                switch(optopt) {
                    case 'b':
                        error("option -b: Missing fillbyte value",0);
                        break;
                    case 'a':
                        error("option -a: Missing ADL mode value",0);
                        break;
                    case 'o':
                        error("option -o: Missing start address value",0);
                        break;
                    default:
                        error("Unknown option", "%c", optopt);
                        break;
                }
                return;
            case 1:
                if(strlen(optarg) > FILENAMEMAXLENGTH) {
                    error("Filename too long",0);
                    return;
                }
                filenamecount++;
                switch(filenamecount) {
                    case 1:
                        strcpy(inputfilename, optarg);
                        break;
                    case 2:
                        strcpy(outputfilename, optarg);
                        break;
                    default:
                        error("Too many filenames provided",0);
                        return;
                        break;
                }
                break;
        }
    }

    if((argc == 1) || (filenamecount == 0)) {
        error("No input filename",0);
        printHelp();
        return;
    }
}

int main(int argc, char *argv[]) {
    clock_t begin, end;

    // set option defaults
    noaction = false;
    fillbyte = FILLBYTE;
    list_enabled = false;
    consolelist_enabled = false;
    adlmode = ADLMODE_START;
    start_address = START_ADDRESS;
    exportsymbols = false;
    displaystatistics = false;
    coloroutput = true;
    completefilebuffering = true;
    ignore_truncation_warnings = false;

    parseOptions(argc, argv);

    if(noaction) return 0;
    if(errorcount) return EXIT_ERROR;

    if(!ioInit(inputfilename, outputfilename)) return EXIT_ERROR;
    
    printf("Assembling %s\r\n", inputfilename);
    if(list_enabled) printf("Listing to %s\r\n", filename[FILE_LISTING]);

    // Initializations
    initInstructionTable();
    initGlobalLabelTable();
    initMacros();
    initFileContentTable();
    sourcefilecount = 0;
    binfilecount = 0;
    errorcount = 0;
    errorreportlevel = 0;
    maxstackdepth = 0;
    macroexpansions = 0;
    listing = list_enabled || consolelist_enabled;
    
    // Assemble input to output
    begin = clock();
    assemble(inputfilename);
    end = clock();

    ioClose();

    if(errorcount) return EXIT_ERROR;
    else printf("Done in %.2f seconds\r\n",((double)(end - begin) / CLOCKS_PER_SEC));

    if(exportsymbols) saveGlobalLabelTable();
    if(displaystatistics) displayStatistics();

    return EXIT_SUCCESS;
}
