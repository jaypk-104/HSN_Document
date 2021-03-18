using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace NTS_Reader_CS
{
    class TstUtil
    {
        [DllImport("DSTSPDFSig_C.dll")]
        public static extern int DSTSPdfSigVerifyF([MarshalAs(UnmanagedType.LPStr)]string pram1, byte[] pram2, byte[] pram3, byte[] pram4, byte[] pram5);
    }
}
