class MemoryLibrary
{
    __New(pLibrary)
    {
        ;check the IMAGE_DOS_HEADER structure
        If NumGet(pLibrary + 0,0,"UShort") != 23117 ;IMAGE_DOS_SIGNATURE
            throw Exception("Invalid image DOS header.",-1)
    }
}

/*
IMAGE_DOS_HEADER

0   WORD   e_magic;                     // Magic number
2   WORD   e_cblp;                      // Bytes on last page of file
4   WORD   e_cp;                        // Pages in file
6   WORD   e_crlc;                      // Relocations
8   WORD   e_cparhdr;                   // Size of header in paragraphs
10  WORD   e_minalloc;                  // Minimum extra paragraphs needed
12  WORD   e_maxalloc;                  // Maximum extra paragraphs needed
14  WORD   e_ss;                        // Initial (relative) SS value
16  WORD   e_sp;                        // Initial SP value
18  WORD   e_csum;                      // Checksum
20  WORD   e_ip;                        // Initial IP value
22  WORD   e_cs;                        // Initial (relative) CS value
24  WORD   e_lfarlc;                    // File address of relocation table
26  WORD   e_ovno;                      // Overlay number
28  WORD   e_res[4];                    // Reserved words
30  WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
32  WORD   e_oeminfo;                   // OEM information; e_oemid specific
34  WORD   e_res2[10];                  // Reserved words
36  LONG   e_lfanew;                    // File address of new exe header