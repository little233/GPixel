/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20160108-64
 * Copyright (c) 2000 - 2016 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of DSDT.aml, Thu May  4 15:23:40 2017
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00003B8F (15247)
 *     Revision         0x02
 *     Checksum         0x09
 *     OEM ID           "COREv4"
 *     OEM Table ID     "COREBOOT"
 *     OEM Revision     0x20110725 (537986853)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20140114 (538181908)
 */
DefinitionBlock ("DSDT.aml", "DSDT", 2, "COREv4", "COREBOOT", 0x20110725)
{
    /*
     * iASL Warning: There were 2 external control methods found during
     * disassembly, but additional ACPI tables to resolve these externals
     * were not specified. This resulting disassembler output file may not
     * compile because the disassembler did not know how many arguments
     * to assign to these methods. To specify the tables needed to resolve
     * external control method references, the -e option can be used to
     * specify the filenames. Note: SSDTs can be dynamically loaded at
     * runtime and may or may not be available via the host OS.
     * Example iASL invocations:
     *     iasl -e ssdt1.aml ssdt2.aml ssdt3.aml -d dsdt.aml
     *     iasl -e dsdt.aml ssdt2.aml -d ssdt1.aml
     *     iasl -e ssdt*.aml -d dsdt.aml
     *
     * In addition, the -fe option can be used to specify a file containing
     * control method external declarations with the associated method
     * argument counts. Each line of the file must be of the form:
     *     External (<method pathname>, MethodObj, <argument count>)
     * Invocation:
     *     iasl -fe refs.txt -d dsdt.aml
     *
     * The following methods were unresolved and many not compile properly
     * because the disassembler had to guess at the number of arguments
     * required for each:
     */
    External (_SB_.DPTF.TEVT, MethodObj)    // Warning: Unresolved method, guessing 1 arguments
    External (_TZ_.THRT, MethodObj)    // Warning: Unresolved method, guessing 1 arguments

    External (_PR_.CPU0, UnknownObj)
    External (_PR_.CPU0._PSS, UnknownObj)
    External (_PR_.CPU1, UnknownObj)
    External (_PR_.CPU2, UnknownObj)
    External (_PR_.CPU3, UnknownObj)
    External (_PR_.CPU4, UnknownObj)
    External (_PR_.CPU5, UnknownObj)
    External (_PR_.CPU6, UnknownObj)
    External (_PR_.CPU7, UnknownObj)
    External (_TZ_.SKIN, UnknownObj)

    OperationRegion (APMP, SystemIO, 0xB2, 0x02)
    Field (APMP, ByteAcc, NoLock, Preserve)
    {
        APMC,   8, 
        APMS,   8
    }

    OperationRegion (POST, SystemIO, 0x80, One)
    Field (POST, ByteAcc, Lock, Preserve)
    {
        DBG0,   8
    }

    Method (TRAP, 1, Serialized)
    {
        SMIF = Arg0
        TRP0 = Zero
        Return (SMIF) /* \SMIF */
    }

    Method (_PIC, 1, NotSerialized)  // _PIC: Interrupt Model
    {
        PICM = Arg0
    }

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        GP36 = Zero
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        Local0 = \_SB.PCI0.LPCB.EC0.ACEX
        If ((Local0 != PWRS))
        {
            PWRS = Local0
            Notify (\_SB.PCI0.LPCB.EC0.AC, 0x80) // Status Change
        }

        Local0 = \_SB.PCI0.LPCB.EC0.LIDS
        If ((Local0 != LIDS))
        {
            LIDS = Local0
            Notify (\_SB.LID0, 0x80) // Status Change
        }

        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    Scope (_SB)
    {
        Device (LID0)
        {
            Name (_HID, EisaId ("PNP0C0D") /* Lid Device */)  // _HID: Hardware ID
            Method (_LID, 0, NotSerialized)  // _LID: Lid Status
            {
                LIDS = ^^PCI0.LPCB.EC0.LIDS /* \_SB_.PCI0.LPCB.EC0_.LIDS */
                Return (LIDS) /* \LIDS */
            }

            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x1F, 
                0x05
            })
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID
        }

        Device (TPAD)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_UID, One)  // _UID: Unique ID
            Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x1C, 
                0x03
            })
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Interrupt (ResourceConsumer, Edge, ActiveLow, Exclusive, ,, )
                {
                    0x00000014,
                }
                VendorShort ()      // Length = 0x01
                {
                     0x4B                                             /* K */
                }
            })
        }

        Device (TSCR)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x1E, 
                0x03
            })
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Interrupt (ResourceConsumer, Edge, ActiveLow, Exclusive, ,, )
                {
                    0x00000016,
                }
                VendorShort ()      // Length = 0x01
                {
                     0x4A                                             /* J */
                }
            })
        }

        Device (KBLT)
        {
            Name (_HID, EisaId ("GGL0002"))  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_ADR, Zero)  // _ADR: Address
            Method (KBQC, 0, NotSerialized)
            {
                Return (^^PCI0.LPCB.EC0.KBLV) /* \_SB_.PCI0.LPCB.EC0_.KBLV */
            }

            Method (KBCM, 1, NotSerialized)
            {
                ^^PCI0.LPCB.EC0.KBLV = Arg0
            }
        }
    }

    Name (PICM, Zero)
    Name (DSEN, One)
    OperationRegion (GNVS, SystemMemory, 0xACFF4FD0, 0x0F00)
    Field (GNVS, ByteAcc, NoLock, Preserve)
    {
        OSYS,   16, 
        SMIF,   8, 
        PRM0,   8, 
        PRM1,   8, 
        SCIF,   8, 
        PRM2,   8, 
        PRM3,   8, 
        LCKF,   8, 
        PRM4,   8, 
        PRM5,   8, 
        P80D,   32, 
        LIDS,   8, 
        PWRS,   8, 
        TLVL,   8, 
        FLVL,   8, 
        TCRT,   8, 
        TPSV,   8, 
        TMAX,   8, 
        F0OF,   8, 
        F0ON,   8, 
        F0PW,   8, 
        F1OF,   8, 
        F1ON,   8, 
        F1PW,   8, 
        F2OF,   8, 
        F2ON,   8, 
        F2PW,   8, 
        F3OF,   8, 
        F3ON,   8, 
        F3PW,   8, 
        F4OF,   8, 
        F4ON,   8, 
        F4PW,   8, 
        TMPS,   8, 
        Offset (0x28), 
        APIC,   8, 
        MPEN,   8, 
        PCP0,   8, 
        PCP1,   8, 
        PPCM,   8, 
        PCNT,   8, 
        Offset (0x32), 
        NATP,   8, 
        S5U0,   8, 
        S5U1,   8, 
        S3U0,   8, 
        S3U1,   8, 
        S33G,   8, 
        CMEM,   32, 
        IGDS,   8, 
        TLST,   8, 
        CADL,   8, 
        PADL,   8, 
        CSTE,   16, 
        NSTE,   16, 
        SSTE,   16, 
        NDID,   8, 
        DID1,   32, 
        DID2,   32, 
        DID3,   32, 
        DID4,   32, 
        DID5,   32, 
        Offset (0x64), 
        BLCS,   8, 
        BRTL,   8, 
        ODDS,   8, 
        Offset (0x6E), 
        ALSE,   8, 
        ALAF,   8, 
        LLOW,   8, 
        LHIH,   8, 
        Offset (0x78), 
        EMAE,   8, 
        EMAP,   16, 
        EMAL,   16, 
        Offset (0x82), 
        MEFE,   8, 
        Offset (0x8C), 
        TPMP,   8, 
        TPME,   8, 
        Offset (0x96), 
        GTF0,   56, 
        GTF1,   56, 
        GTF2,   56, 
        IDEM,   8, 
        IDET,   8, 
        Offset (0xB2), 
        XHCI,   8, 
        Offset (0xB4), 
        ASLB,   32, 
        IBTT,   8, 
        IPAT,   8, 
        ITVF,   8, 
        ITVM,   8, 
        IPSC,   8, 
        IBLC,   8, 
        IBIA,   8, 
        ISSC,   8, 
        I409,   8, 
        I509,   8, 
        I609,   8, 
        I709,   8, 
        IDMM,   8, 
        IDMS,   8, 
        IF1E,   8, 
        HVCO,   8, 
        NXD1,   32, 
        NXD2,   32, 
        NXD3,   32, 
        NXD4,   32, 
        NXD5,   32, 
        NXD6,   32, 
        NXD7,   32, 
        NXD8,   32, 
        ISCI,   8, 
        PAVP,   8, 
        Offset (0xEB), 
        OSCC,   8, 
        NPCE,   8, 
        PLFL,   8, 
        BREV,   8, 
        DPBM,   8, 
        DPCM,   8, 
        DPDM,   8, 
        ALFP,   8, 
        IMON,   8, 
        MMIO,   8, 
        Offset (0x100), 
        VBT0,   32, 
        VBT1,   32, 
        VBT2,   32, 
        VBT3,   16, 
        VBT4,   2048, 
        VBT5,   512, 
        VBT6,   512, 
        VBT7,   32, 
        VBT8,   32, 
        VBT9,   32, 
        CHVD,   24576, 
        VBTA,   32, 
        MEHH,   256, 
        RMOB,   32, 
        RMOL,   32
    }

    Method (S3UE, 0, NotSerialized)
    {
        S3U0 = One
        S3U1 = One
    }

    Method (S3UD, 0, NotSerialized)
    {
        S3U0 = Zero
        S3U1 = Zero
    }

    Method (S5UE, 0, NotSerialized)
    {
        S5U0 = One
        S5U1 = One
    }

    Method (S5UD, 0, NotSerialized)
    {
        S5U0 = Zero
        S5U1 = Zero
    }

    Method (S3GE, 0, NotSerialized)
    {
        S33G = One
    }

    Method (S3GD, 0, NotSerialized)
    {
        S33G = Zero
    }

    Method (XHCE, 0, NotSerialized)
    {
        XHCI = One
    }

    Method (XHCD, 0, NotSerialized)
    {
        XHCI = Zero
    }

    Method (TZUP, 0, NotSerialized)
    {
        If (CondRefOf (\_TZ.THRM, Local0))
        {
            Notify (\_TZ.THRM, 0x81) // Thermal Trip Point Change
        }

        If (CondRefOf (\_TZ.SKIN, Local0))
        {
            Notify (\_TZ.SKIN, 0x81) // Information Change
        }
    }

    Method (F0UT, 2, NotSerialized)
    {
        F0OF = Arg0
        F0ON = Arg1
        TZUP ()
    }

    Method (F1UT, 2, NotSerialized)
    {
        F1OF = Arg0
        F1ON = Arg1
        TZUP ()
    }

    Method (F2UT, 2, NotSerialized)
    {
        F2OF = Arg0
        F2ON = Arg1
        TZUP ()
    }

    Method (F3UT, 2, NotSerialized)
    {
        F3OF = Arg0
        F3ON = Arg1
        TZUP ()
    }

    Method (F4UT, 2, NotSerialized)
    {
        F4OF = Arg0
        F4ON = Arg1
        TZUP ()
    }

    Method (TMPU, 1, NotSerialized)
    {
        TMPS = Arg0
        TZUP ()
    }

    Scope (_TZ)
    {
        ThermalZone (CRIT)
        {
            Name (_TZP, 0x32)  // _TZP: Thermal Zone Polling
            Method (CTOK, 1, NotSerialized)
            {
                Local0 = (Arg0 * 0x0A)
                Local0 += 0x0AAC
                Return (Local0)
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (CTOK (TCRT))
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                Local0 = \_SB.PCI0.LPCB.EC0.TIN9
                If ((Local0 == \_SB.PCI0.LPCB.EC0.TNCA))
                {
                    Return (CTOK (Zero))
                }

                If ((Local0 == \_SB.PCI0.LPCB.EC0.TNPR))
                {
                    Return (CTOK (Zero))
                }

                If ((Local0 == \_SB.PCI0.LPCB.EC0.TNOP))
                {
                    Return (CTOK (Zero))
                }

                If ((Local0 == \_SB.PCI0.LPCB.EC0.TBAD))
                {
                    Return (CTOK (Zero))
                }

                Local0 += \_SB.PCI0.LPCB.EC0.TOFS
                Local0 *= 0x0A
                Return (Local0)
            }
        }

        ThermalZone (THRM)
        {
            Name (_TC1, 0x02)  // _TC1: Thermal Constant 1
            Name (_TC2, 0x05)  // _TC2: Thermal Constant 2
            Name (_TZP, 0x64)  // _TZP: Thermal Zone Polling
            Name (_TSP, 0x14)  // _TSP: Thermal Sampling Period
            Method (CTOK, 1, NotSerialized)
            {
                Local0 = (Arg0 * 0x0A)
                Local0 += 0x0AAC
                Return (Local0)
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (CTOK (TCRT))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (CTOK (TPSV))
            }

            Method (_PSL, 0, Serialized)  // _PSL: Passive List
            {
                Return (PPKG ())
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                Local0 = \_SB.PCI0.LPCB.EC0.TINS (TMPS)
                If ((Local0 == \_SB.PCI0.LPCB.EC0.TNPR))
                {
                    Return (CTOK (Zero))
                }

                If ((Local0 == \_SB.PCI0.LPCB.EC0.TNOP))
                {
                    Return (CTOK (Zero))
                }

                If ((Local0 == \_SB.PCI0.LPCB.EC0.TBAD))
                {
                    Return (CTOK (Zero))
                }

                Local0 += \_SB.PCI0.LPCB.EC0.TOFS
                Local0 *= 0x0A
                Return (Local0)
            }

            Method (_AC0, 0, NotSerialized)  // _ACx: Active Cooling
            {
                If ((FLVL <= Zero))
                {
                    Return (CTOK (F0OF))
                }
                Else
                {
                    Return (CTOK (F0ON))
                }
            }

            Method (_AC1, 0, NotSerialized)  // _ACx: Active Cooling
            {
                If ((FLVL <= One))
                {
                    Return (CTOK (F1OF))
                }
                Else
                {
                    Return (CTOK (F1ON))
                }
            }

            Name (_AL0, Package (0x01)  // _ALx: Active List
            {
                TDP0
            })
            Name (_AL1, Package (0x01)  // _ALx: Active List
            {
                TDP1
            })
            PowerResource (TNP0, 0x00, 0x0000)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((FLVL <= Zero))
                    {
                        Return (One)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_ON, 0, NotSerialized)  // _ON_: Power On
                {
                    FLVL = Zero
                    \_SB.PCI0.MCHC.STND ()
                    Notify (THRM, 0x81) // Thermal Trip Point Change
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    FLVL = One
                    \_SB.PCI0.MCHC.STDN ()
                    Notify (THRM, 0x81) // Thermal Trip Point Change
                }
            }

            PowerResource (TNP1, 0x00, 0x0000)
            {
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((FLVL <= One))
                    {
                        Return (One)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_ON, 0, NotSerialized)  // _ON_: Power On
                {
                    FLVL = One
                    Notify (THRM, 0x81) // Thermal Trip Point Change
                }

                Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
                {
                    FLVL = One
                    Notify (THRM, 0x81) // Thermal Trip Point Change
                }
            }

            Device (TDP0)
            {
                Name (_HID, EisaId ("PNP0C0B") /* Fan (Thermal Solution) */)  // _HID: Hardware ID
                Name (_UID, Zero)  // _UID: Unique ID
                Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
                {
                    TNP0
                })
            }

            Device (TDP1)
            {
                Name (_HID, EisaId ("PNP0C0B") /* Fan (Thermal Solution) */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
                {
                    TNP1
                })
            }
        }
    }

    Method (PNOT, 0, NotSerialized)
    {
        If ((PCNT >= 0x02))
        {
            Notify (\_PR.CPU0, 0x81) // Information Change
            Notify (\_PR.CPU1, 0x81) // Information Change
        }

        If ((PCNT >= 0x04))
        {
            Notify (\_PR.CPU2, 0x81) // Information Change
            Notify (\_PR.CPU3, 0x81) // Information Change
        }

        If ((PCNT >= 0x08))
        {
            Notify (\_PR.CPU4, 0x81) // Information Change
            Notify (\_PR.CPU5, 0x81) // Information Change
            Notify (\_PR.CPU6, 0x81) // Information Change
            Notify (\_PR.CPU7, 0x81) // Information Change
        }
    }

    Method (PPCN, 0, NotSerialized)
    {
        If ((PCNT >= 0x02))
        {
            Notify (\_PR.CPU0, 0x80) // Status Change
            Notify (\_PR.CPU1, 0x80) // Status Change
        }

        If ((PCNT >= 0x04))
        {
            Notify (\_PR.CPU2, 0x80) // Status Change
            Notify (\_PR.CPU3, 0x80) // Status Change
        }

        If ((PCNT >= 0x08))
        {
            Notify (\_PR.CPU4, 0x80) // Status Change
            Notify (\_PR.CPU5, 0x80) // Status Change
            Notify (\_PR.CPU6, 0x80) // Status Change
            Notify (\_PR.CPU7, 0x80) // Status Change
        }
    }

    Method (TNOT, 0, NotSerialized)
    {
        If ((PCNT >= 0x02))
        {
            Notify (\_PR.CPU0, 0x82) // Device-Specific Change
            Notify (\_PR.CPU1, 0x82) // Device-Specific Change
        }

        If ((PCNT >= 0x04))
        {
            Notify (\_PR.CPU2, 0x82) // Device-Specific Change
            Notify (\_PR.CPU3, 0x82) // Device-Specific Change
        }

        If ((PCNT >= 0x08))
        {
            Notify (\_PR.CPU4, 0x82) // Device-Specific Change
            Notify (\_PR.CPU5, 0x82) // Device-Specific Change
            Notify (\_PR.CPU6, 0x82) // Device-Specific Change
            Notify (\_PR.CPU7, 0x82) // Device-Specific Change
        }
    }

    Method (PPKG, 0, NotSerialized)
    {
        If ((PCNT >= 0x08))
        {
            Return (Package (0x08)
            {
                \_PR.CPU0, 
                \_PR.CPU1, 
                \_PR.CPU2, 
                \_PR.CPU3, 
                \_PR.CPU4, 
                \_PR.CPU5, 
                \_PR.CPU6, 
                \_PR.CPU7
            })
        }
        ElseIf ((PCNT >= 0x04))
        {
            Return (Package (0x04)
            {
                \_PR.CPU0, 
                \_PR.CPU1, 
                \_PR.CPU2, 
                \_PR.CPU3
            })
        }
        ElseIf ((PCNT >= 0x02))
        {
            Return (Package (0x02)
            {
                \_PR.CPU0, 
                \_PR.CPU1
            })
        }
        Else
        {
            Return (Package (0x01)
            {
                \_PR.CPU0
            })
        }
    }

    Scope (_SB)
    {
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Device (MCHC)
            {
                Name (_ADR, Zero)  // _ADR: Address
                OperationRegion (MCHP, PCI_Config, Zero, 0x0100)
                Field (MCHP, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x40), 
                    EPEN,   1, 
                        ,   11, 
                    EPBR,   24, 
                    Offset (0x48), 
                    MHEN,   1, 
                        ,   13, 
                    MHBR,   22, 
                    Offset (0x60), 
                    PXEN,   1, 
                    PXSZ,   2, 
                        ,   23, 
                    PXBR,   10, 
                    Offset (0x68), 
                    DMEN,   1, 
                        ,   11, 
                    DMBR,   24, 
                    Offset (0x70), 
                    MEBA,   64, 
                    Offset (0x80), 
                        ,   4, 
                    PM0H,   2, 
                    Offset (0x81), 
                    PM1L,   2, 
                        ,   2, 
                    PM1H,   2, 
                    Offset (0x82), 
                    PM2L,   2, 
                        ,   2, 
                    PM2H,   2, 
                    Offset (0x83), 
                    PM3L,   2, 
                        ,   2, 
                    PM3H,   2, 
                    Offset (0x84), 
                    PM4L,   2, 
                        ,   2, 
                    PM4H,   2, 
                    Offset (0x85), 
                    PM5L,   2, 
                        ,   2, 
                    PM5H,   2, 
                    Offset (0x86), 
                    PM6L,   2, 
                        ,   2, 
                    PM6H,   2, 
                    Offset (0x87), 
                    Offset (0xA0), 
                    TOM,    64, 
                    Offset (0xBC), 
                    TLUD,   32
                }

                Mutex (CTCM, 0x01)
                Name (CTCC, Zero)
                Name (CTCN, Zero)
                Name (CTCD, One)
                Name (CTCU, 0x02)
                OperationRegion (MCHB, SystemMemory, 0xFED10000, 0x8000)
                Field (MCHB, DWordAcc, Lock, Preserve)
                {
                    Offset (0x5930), 
                    CTDN,   15, 
                    Offset (0x59A0), 
                    PL1V,   15, 
                    PL1E,   1, 
                    PL1C,   1, 
                    PL1T,   7, 
                    Offset (0x59A4), 
                    PL2V,   15, 
                    PL2E,   1, 
                    PL2C,   1, 
                    PL2T,   7, 
                    Offset (0x5F3C), 
                    TARN,   8, 
                    Offset (0x5F40), 
                    CTDD,   15, 
                    Offset (0x5F42), 
                    TARD,   8, 
                    Offset (0x5F48), 
                    CTDU,   15, 
                    Offset (0x5F4A), 
                    TARU,   8, 
                    Offset (0x5F50), 
                    CTCS,   2, 
                    Offset (0x5F54), 
                    TARS,   8
                }

                Method (PSSS, 1, NotSerialized)
                {
                    Local0 = One
                    Local1 = SizeOf (\_PR.CPU0._PSS)
                    While ((Local0 < Local1))
                    {
                        Local2 = (DerefOf (DerefOf (\_PR.CPU0._PSS [Local0]) [0x04]) >> 0x08)
                        If ((Local2 == Arg0))
                        {
                            Return ((Local0 - One))
                        }

                        Local0++
                    }

                    Return (Zero)
                }

                Method (STND, 0, Serialized)
                {
                    If (Acquire (CTCM, 0x0064))
                    {
                        Return (Zero)
                    }

                    If ((CTCD == CTCC))
                    {
                        Release (CTCM)
                        Return (Zero)
                    }

                    Debug = "Set TDP Down"
                    CTCS = CTCD /* \_SB_.PCI0.MCHC.CTCD */
                    TARS = TARD /* \_SB_.PCI0.MCHC.TARD */
                    PPCM = PSSS (TARD)
                    PPCN ()
                    Divide ((CTDD * 0x7D), 0x64, Local0, PL2V) /* \_SB_.PCI0.MCHC.PL2V */
                    PL1V = CTDD /* \_SB_.PCI0.MCHC.CTDD */
                    CTCC = CTCD /* \_SB_.PCI0.MCHC.CTCD */
                    Release (CTCM)
                    Return (One)
                }

                Method (STDN, 0, Serialized)
                {
                    If (Acquire (CTCM, 0x0064))
                    {
                        Return (Zero)
                    }

                    If ((CTCN == CTCC))
                    {
                        Release (CTCM)
                        Return (Zero)
                    }

                    Debug = "Set TDP Nominal"
                    PL1V = CTDN /* \_SB_.PCI0.MCHC.CTDN */
                    Divide ((CTDN * 0x7D), 0x64, Local0, PL2V) /* \_SB_.PCI0.MCHC.PL2V */
                    PPCM = PSSS (TARN)
                    PPCN ()
                    TARS = TARN /* \_SB_.PCI0.MCHC.TARN */
                    CTCS = CTCN /* \_SB_.PCI0.MCHC.CTCN */
                    CTCC = CTCN /* \_SB_.PCI0.MCHC.CTCN */
                    Release (CTCM)
                    Return (One)
                }
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (MCRS, ResourceTemplate ()
                {
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x00FF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0100,             // Length
                        ,, )
                    DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x00000000,         // Granularity
                        0x00000000,         // Range Minimum
                        0x00000CF7,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00000CF8,         // Length
                        ,, , TypeStatic)
                    IO (Decode16,
                        0x0CF8,             // Range Minimum
                        0x0CF8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x00000000,         // Granularity
                        0x00000D00,         // Range Minimum
                        0x0000FFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x0000F300,         // Length
                        ,, , TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000A0000,         // Range Minimum
                        0x000BFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00020000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C0000,         // Range Minimum
                        0x000C3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C4000,         // Range Minimum
                        0x000C7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C8000,         // Range Minimum
                        0x000CBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000CC000,         // Range Minimum
                        0x000CFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D0000,         // Range Minimum
                        0x000D3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D4000,         // Range Minimum
                        0x000D7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D8000,         // Range Minimum
                        0x000DBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000DC000,         // Range Minimum
                        0x000DFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E0000,         // Range Minimum
                        0x000E3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E4000,         // Range Minimum
                        0x000E7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E8000,         // Range Minimum
                        0x000EBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000EC000,         // Range Minimum
                        0x000EFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000F0000,         // Range Minimum
                        0x000FFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00010000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x00000000,         // Range Minimum
                        0xFEBFFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0xFEC00000,         // Length
                        ,, _Y00, AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0xFED40000,         // Range Minimum
                        0xFED44FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00005000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                })
                CreateDWordField (MCRS, \_SB.PCI0._CRS._Y00._MIN, PMIN)  // _MIN: Minimum Base Address
                CreateDWordField (MCRS, \_SB.PCI0._CRS._Y00._MAX, PMAX)  // _MAX: Maximum Base Address
                CreateDWordField (MCRS, \_SB.PCI0._CRS._Y00._LEN, PLEN)  // _LEN: Length
                Local0 = ^MCHC.TLUD /* \_SB_.PCI0.MCHC.TLUD */
                Local1 = ^MCHC.MEBA /* \_SB_.PCI0.MCHC.MEBA */
                If ((Local0 == Local1))
                {
                    Local0 = ^MCHC.TOM /* \_SB_.PCI0.MCHC.TOM_ */
                }

                PMIN = Local0
                PLEN = ((PMAX - PMIN) + One)
                Return (MCRS) /* \_SB_.PCI0._CRS.MCRS */
            }

            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                If (PICM)
                {
                    Return (Package (0x0C)
                    {
                        Package (0x04)
                        {
                            0x0002FFFF, 
                            Zero, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001BFFFF, 
                            Zero, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            Zero, 
                            Zero, 
                            0x13
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            One, 
                            Zero, 
                            0x14
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x02, 
                            Zero, 
                            0x11
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x03, 
                            Zero, 
                            0x12
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            Zero, 
                            Zero, 
                            0x13
                        }, 

                        Package (0x04)
                        {
                            0x001AFFFF, 
                            Zero, 
                            Zero, 
                            0x15
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            Zero, 
                            Zero, 
                            0x11
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            One, 
                            Zero, 
                            0x17
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x02, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x03, 
                            Zero, 
                            0x12
                        }
                    })
                }
                Else
                {
                    Return (Package (0x0C)
                    {
                        Package (0x04)
                        {
                            0x0002FFFF, 
                            Zero, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001BFFFF, 
                            Zero, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            Zero, 
                            ^LPCB.LNKD, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            One, 
                            ^LPCB.LNKE, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x02, 
                            ^LPCB.LNKB, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x03, 
                            ^LPCB.LNKC, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            Zero, 
                            ^LPCB.LNKD, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001AFFFF, 
                            Zero, 
                            ^LPCB.LNKF, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            Zero, 
                            ^LPCB.LNKB, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            One, 
                            ^LPCB.LNKH, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x02, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x03, 
                            ^LPCB.LNKC, 
                            Zero
                        }
                    })
                }
            }

            Device (PDRC)
            {
                Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Name (PDRS, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0xFED1C000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED10000,         // Address Base
                        0x00008000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED18000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED19000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xF0000000,         // Address Base
                        0x04000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED20000,         // Address Base
                        0x00020000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED40000,         // Address Base
                        0x00005000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED45000,         // Address Base
                        0x0004B000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x20000000,         // Address Base
                        0x00200000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x40000000,         // Address Base
                        0x00200000,         // Address Length
                        )
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Return (PDRS) /* \_SB_.PCI0.PDRC.PDRS */
                }
            }

            Device (GFX0)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                OperationRegion (GFXC, PCI_Config, Zero, 0x0100)
                Field (GFXC, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x10), 
                    BAR0,   64
                }

                OperationRegion (GFRG, SystemMemory, (BAR0 & 0xFFFFFFFFFFFFFFF0), 0x00400000)
                Field (GFRG, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x48254), 
                    BCLV,   16, 
                    Offset (0xC8250), 
                    CR1,    32, 
                    CR2,    32
                }

                Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
                {
                    DSEN = (Arg0 & 0x07)
                }

                Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
                {
                    If ((NDID == One))
                    {
                        Name (DOD1, Package (0x01)
                        {
                            0xFFFFFFFF
                        })
                        DOD1 [Zero] = (0x00010000 | DID1)
                        Return (DOD1) /* \_SB_.PCI0.GFX0._DOD.DOD1 */
                    }

                    If ((NDID == 0x02))
                    {
                        Name (DOD2, Package (0x02)
                        {
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        DOD2 [Zero] = (0x00010000 | DID2)
                        DOD2 [One] = (0x00010000 | DID2)
                        Return (DOD2) /* \_SB_.PCI0.GFX0._DOD.DOD2 */
                    }

                    If ((NDID == 0x03))
                    {
                        Name (DOD3, Package (0x03)
                        {
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        DOD3 [Zero] = (0x00010000 | DID3)
                        DOD3 [One] = (0x00010000 | DID3)
                        DOD3 [0x02] = (0x00010000 | DID3)
                        Return (DOD3) /* \_SB_.PCI0.GFX0._DOD.DOD3 */
                    }

                    If ((NDID == 0x04))
                    {
                        Name (DOD4, Package (0x04)
                        {
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        DOD4 [Zero] = (0x00010000 | DID4)
                        DOD4 [One] = (0x00010000 | DID4)
                        DOD4 [0x02] = (0x00010000 | DID4)
                        DOD4 [0x03] = (0x00010000 | DID4)
                        Return (DOD4) /* \_SB_.PCI0.GFX0._DOD.DOD4 */
                    }

                    If ((NDID > 0x04))
                    {
                        Name (DOD5, Package (0x05)
                        {
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        DOD5 [Zero] = (0x00010000 | DID5)
                        DOD5 [One] = (0x00010000 | DID5)
                        DOD5 [0x02] = (0x00010000 | DID5)
                        DOD5 [0x03] = (0x00010000 | DID5)
                        DOD5 [0x04] = (0x00010000 | DID5)
                        Return (DOD5) /* \_SB_.PCI0.GFX0._DOD.DOD5 */
                    }

                    Return (Package (0x01)
                    {
                        0x0400
                    })
                }

                Device (DD01)
                {
                    Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        If ((DID1 == Zero))
                        {
                            Return (One)
                        }
                        Else
                        {
                            Return ((0xFFFF & DID1))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                    {
                        TRAP (One)
                        If ((CSTE & One))
                        {
                            Return (0x1F)
                        }

                        Return (0x1D)
                    }

                    Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                    {
                        If ((NSTE & One))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                    {
                        If (((Arg0 & 0xC0000000) == 0xC0000000))
                        {
                            CSTE = NSTE /* \NSTE */
                        }
                    }
                }

                Device (DD02)
                {
                    Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        If ((DID2 == Zero))
                        {
                            Return (0x02)
                        }
                        Else
                        {
                            Return ((0xFFFF & DID2))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                    {
                        TRAP (One)
                        If ((CSTE & 0x02))
                        {
                            Return (0x1F)
                        }

                        Return (0x1D)
                    }

                    Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                    {
                        If ((NSTE & 0x02))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                    {
                        If (((Arg0 & 0xC0000000) == 0xC0000000))
                        {
                            CSTE = NSTE /* \NSTE */
                        }
                    }
                }

                Device (DD03)
                {
                    Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        If ((DID3 == Zero))
                        {
                            Return (0x03)
                        }
                        Else
                        {
                            Return ((0xFFFF & DID3))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                    {
                        TRAP (One)
                        If ((CSTE & 0x04))
                        {
                            Return (0x1F)
                        }

                        Return (0x1D)
                    }

                    Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                    {
                        If ((NSTE & 0x04))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                    {
                        If (((Arg0 & 0xC0000000) == 0xC0000000))
                        {
                            CSTE = NSTE /* \NSTE */
                        }
                    }
                }

                Device (DD04)
                {
                    Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        If ((DID4 == Zero))
                        {
                            Return (0x04)
                        }
                        Else
                        {
                            Return ((0xFFFF & DID4))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                    {
                        TRAP (One)
                        If ((CSTE & 0x08))
                        {
                            Return (0x1F)
                        }

                        Return (0x1D)
                    }

                    Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                    {
                        If ((NSTE & 0x04))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                    {
                        If (((Arg0 & 0xC0000000) == 0xC0000000))
                        {
                            CSTE = NSTE /* \NSTE */
                        }
                    }
                }

                Device (DD05)
                {
                    Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        If ((DID5 == Zero))
                        {
                            Return (0x05)
                        }
                        Else
                        {
                            Return ((0xFFFF & DID5))
                        }
                    }

                    Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
                    {
                        TRAP (One)
                        If ((CSTE & 0x10))
                        {
                            Return (0x1F)
                        }

                        Return (0x1D)
                    }

                    Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
                    {
                        If ((NSTE & 0x04))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
                    {
                        If (((Arg0 & 0xC0000000) == 0xC0000000))
                        {
                            CSTE = NSTE /* \NSTE */
                        }
                    }
                }
            }

            Scope (\)
            {
                OperationRegion (IO_T, SystemIO, 0x0800, 0x10)
                Field (IO_T, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x08), 
                    TRP0,   8
                }

                OperationRegion (PMIO, SystemIO, 0x0500, 0x80)
                Field (PMIO, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x20), 
                    Offset (0x22), 
                    GS00,   1, 
                    GS01,   1, 
                    GS02,   1, 
                    GS03,   1, 
                    GS04,   1, 
                    GS05,   1, 
                    GS06,   1, 
                    GS07,   1, 
                    GS08,   1, 
                    GS09,   1, 
                    GS10,   1, 
                    GS11,   1, 
                    GS12,   1, 
                    GS13,   1, 
                    GS14,   1, 
                    GS15,   1, 
                    Offset (0x28), 
                    Offset (0x2A), 
                    GE00,   1, 
                    GE01,   1, 
                    GE02,   1, 
                    GE03,   1, 
                    GE04,   1, 
                    GE05,   1, 
                    GE06,   1, 
                    GE07,   1, 
                    GE08,   1, 
                    GE09,   1, 
                    GE10,   1, 
                    GE11,   1, 
                    GE12,   1, 
                    GE13,   1, 
                    GE14,   1, 
                    GE15,   1, 
                    Offset (0x42), 
                        ,   1, 
                    GPEC,   1
                }

                OperationRegion (GPIO, SystemIO, 0x0480, 0x6C)
                Field (GPIO, ByteAcc, NoLock, Preserve)
                {
                    GU00,   8, 
                    GU01,   8, 
                    GU02,   8, 
                    GU03,   8, 
                    GIO0,   8, 
                    GIO1,   8, 
                    GIO2,   8, 
                    GIO3,   8, 
                    Offset (0x0C), 
                    GL00,   1, 
                    GP01,   1, 
                    GP02,   1, 
                    GP03,   1, 
                    GP04,   1, 
                    GP05,   1, 
                    GP06,   1, 
                    GP07,   1, 
                    GP08,   1, 
                    GP09,   1, 
                    GP10,   1, 
                    GP11,   1, 
                    GP12,   1, 
                    GP13,   1, 
                    GP14,   1, 
                    GP15,   1, 
                    GP16,   1, 
                    GP17,   1, 
                    GP18,   1, 
                    GP19,   1, 
                    GP20,   1, 
                    GP21,   1, 
                    GP22,   1, 
                    GP23,   1, 
                    GP24,   1, 
                    GP25,   1, 
                    GP26,   1, 
                    GP27,   1, 
                    GP28,   1, 
                    GP29,   1, 
                    GP30,   1, 
                    GP31,   1, 
                    Offset (0x18), 
                    GB00,   8, 
                    GB01,   8, 
                    GB02,   8, 
                    GB03,   8, 
                    Offset (0x2C), 
                    GIV0,   8, 
                    GIV1,   8, 
                    GIV2,   8, 
                    GIV3,   8, 
                    GU04,   8, 
                    GU05,   8, 
                    GU06,   8, 
                    GU07,   8, 
                    GIO4,   8, 
                    GIO5,   8, 
                    GIO6,   8, 
                    GIO7,   8, 
                    GP32,   1, 
                    GP33,   1, 
                    GP34,   1, 
                    GP35,   1, 
                    GP36,   1, 
                    GP37,   1, 
                    GP38,   1, 
                    GP39,   1, 
                    GP40,   1, 
                    GP41,   1, 
                    GP42,   1, 
                    GP43,   1, 
                    GP44,   1, 
                    GP45,   1, 
                    GP46,   1, 
                    GP47,   1, 
                    GP48,   1, 
                    GP49,   1, 
                    GP50,   1, 
                    GP51,   1, 
                    GP52,   1, 
                    GP53,   1, 
                    GP54,   1, 
                    GP55,   1, 
                    GP56,   1, 
                    GP57,   1, 
                    GP58,   1, 
                    GP59,   1, 
                    GP60,   1, 
                    GP61,   1, 
                    GP62,   1, 
                    GP63,   1, 
                    Offset (0x40), 
                    GU08,   8, 
                    GU09,   4, 
                    Offset (0x44), 
                    GIO8,   8, 
                    GIO9,   4, 
                    Offset (0x48), 
                    GP64,   1, 
                    GP65,   1, 
                    GP66,   1, 
                    GP67,   1, 
                    GP68,   1, 
                    GP69,   1, 
                    GP70,   1, 
                    GP71,   1, 
                    GP72,   1, 
                    GP73,   1, 
                    GP74,   1, 
                    GP75,   1
                }

                OperationRegion (RCRB, SystemMemory, 0xFED1C000, 0x4000)
                Field (RCRB, DWordAcc, Lock, Preserve)
                {
                    Offset (0x1000), 
                    Offset (0x3000), 
                    Offset (0x3404), 
                    HPAS,   2, 
                        ,   5, 
                    HPTE,   1, 
                    Offset (0x3418), 
                        ,   1, 
                    PCID,   1, 
                    SA1D,   1, 
                    SMBD,   1, 
                    HDAD,   1, 
                        ,   8, 
                    EH2D,   1, 
                    LPBD,   1, 
                    EH1D,   1, 
                    RP1D,   1, 
                    RP2D,   1, 
                    RP3D,   1, 
                    RP4D,   1, 
                    RP5D,   1, 
                    RP6D,   1, 
                    RP7D,   1, 
                    RP8D,   1, 
                    TTRD,   1, 
                    SA2D,   1, 
                    Offset (0x3428), 
                    BDFD,   1, 
                    ME1D,   1, 
                    ME2D,   1, 
                    IDRD,   1, 
                    KTCT,   1
                }
            }

            Device (HDEF)
            {
                Name (_ADR, 0x001B0000)  // _ADR: Address
                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    0x0D, 
                    0x04
                })
            }

            Method (IRQM, 1, Serialized)
            {
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                Name (IQAA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x13
                    }
                })
                Name (IQAP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        ^LPCB.LNKA, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        ^LPCB.LNKB, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        ^LPCB.LNKC, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        ^LPCB.LNKD, 
                        Zero
                    }
                })
                Name (IQBA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x10
                    }
                })
                Name (IQBP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        ^LPCB.LNKB, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        ^LPCB.LNKC, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        ^LPCB.LNKD, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        ^LPCB.LNKA, 
                        Zero
                    }
                })
                Name (IQCA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x11
                    }
                })
                Name (IQCP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        ^LPCB.LNKC, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        ^LPCB.LNKD, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        ^LPCB.LNKA, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        ^LPCB.LNKB, 
                        Zero
                    }
                })
                Name (IQDA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x12
                    }
                })
                Name (IQDP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        ^LPCB.LNKD, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        ^LPCB.LNKA, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        ^LPCB.LNKB, 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        ^LPCB.LNKC, 
                        Zero
                    }
                })
                While (One)
                {
                    _T_0 = ToInteger (Arg0)
                    If ((Match (Package (0x02)
                                    {
                                        One, 
                                        0x05
                                    }, MEQ, _T_0, MTR, Zero, Zero) != Ones))
                    {
                        If (PICM)
                        {
                            Return (IQAA) /* \_SB_.PCI0.IRQM.IQAA */
                        }
                        Else
                        {
                            Return (IQAP) /* \_SB_.PCI0.IRQM.IQAP */
                        }
                    }
                    ElseIf ((Match (Package (0x02)
                                    {
                                        0x02, 
                                        0x06
                                    }, MEQ, _T_0, MTR, Zero, Zero) != Ones))
                    {
                        If (PICM)
                        {
                            Return (IQBA) /* \_SB_.PCI0.IRQM.IQBA */
                        }
                        Else
                        {
                            Return (IQBP) /* \_SB_.PCI0.IRQM.IQBP */
                        }
                    }
                    ElseIf ((Match (Package (0x02)
                                    {
                                        0x03, 
                                        0x07
                                    }, MEQ, _T_0, MTR, Zero, Zero) != Ones))
                    {
                        If (PICM)
                        {
                            Return (IQCA) /* \_SB_.PCI0.IRQM.IQCA */
                        }
                        Else
                        {
                            Return (IQCP) /* \_SB_.PCI0.IRQM.IQCP */
                        }
                    }
                    ElseIf ((Match (Package (0x02)
                                    {
                                        0x04, 
                                        0x08
                                    }, MEQ, _T_0, MTR, Zero, Zero) != Ones))
                    {
                        If (PICM)
                        {
                            Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                        }
                        Else
                        {
                            Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                        }
                    }
                    ElseIf (PICM)
                    {
                        Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                    }
                    Else
                    {
                        Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                    }

                    Break
                }
            }

            Device (RP01)
            {
                Name (_ADR, 0x001C0000)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP02)
            {
                Name (_ADR, 0x001C0001)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP03)
            {
                Name (_ADR, 0x001C0002)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP04)
            {
                Name (_ADR, 0x001C0003)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP05)
            {
                Name (_ADR, 0x001C0004)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP06)
            {
                Name (_ADR, 0x001C0005)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP07)
            {
                Name (_ADR, 0x001C0006)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP08)
            {
                Name (_ADR, 0x001C0007)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, Zero, 0xFF)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x4C), 
                    Offset (0x4F), 
                    RPPN,   8, 
                    Offset (0x5A), 
                        ,   3, 
                    PDC,    1, 
                    Offset (0xDF), 
                        ,   6, 
                    HPCS,   1
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (EHC1)
            {
                Name (_ADR, 0x001D0000)  // _ADR: Address
                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    0x0D, 
                    0x04
                })
                Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
                {
                    Return (0x02)
                }

                Device (HUB7)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                    }
                }
            }

            Device (EHC2)
            {
                Name (_ADR, 0x001A0000)  // _ADR: Address
                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    0x0D, 
                    0x04
                })
                Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
                {
                    Return (0x02)
                }

                Device (HUB7)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                    }
                }
            }

            Device (XHC)
            {
                Name (_ADR, 0x00140000)  // _ADR: Address
                OperationRegion (XDEV, PCI_Config, Zero, 0x0100)
                Field (XDEV, DWordAcc, NoLock, Preserve)
                {
                    Offset (0xD0), 
                    X2PR,   32, 
                    PRM2,   32, 
                    SSEN,   32, 
                    RPM3,   32, 
                    XPRT,   32
                }

                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    0x0D, 
                    0x04
                })
                Method (POSC, 3, Serialized)
                {
                    CreateDWordField (Arg2, Zero, CDW1)
                    If ((Arg1 != One))
                    {
                        CDW1 |= 0x08
                    }

                    If ((XHCI == Zero))
                    {
                        CDW1 |= 0x02
                    }

                    If ((!(CDW1 & One) && ((XHCI == 0x02) || (
                        XHCI == 0x03))))
                    {
                        Debug = "XHCI Switch"
                        Local0 = Zero
                        Local0 = (XPRT & 0x03)
                        If (((Local0 == Zero) || (Local0 == One)))
                        {
                            Local1 = 0x0F
                        }
                        ElseIf ((Local0 == 0x02))
                        {
                            Local1 = 0x03
                        }
                        ElseIf ((Local0 == 0x03))
                        {
                            Local1 = Zero
                        }

                        Local0 = (RPM3 & 0xFFFFFFF0)
                        RPM3 = (Local0 | Local1)
                        Local0 = (PRM2 & 0xFFFFFFF0)
                        PRM2 = (Local0 | Local1)
                        Local0 = (SSEN & 0xFFFFFFF0)
                        SSEN = (Local0 | Local1)
                        Local0 = (X2PR & 0xFFFFFFF0)
                        X2PR = (Local0 | Local1)
                    }

                    Return (Arg2)
                }

                Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)  // _S4D: S4 Device State
                {
                    Return (0x02)
                }
            }

            Device (LPCB)
            {
                Name (_ADR, 0x001F0000)  // _ADR: Address
                OperationRegion (LPC0, PCI_Config, Zero, 0x0100)
                Field (LPC0, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x40), 
                    PMBS,   16, 
                    Offset (0x60), 
                    PRTA,   8, 
                    PRTB,   8, 
                    PRTC,   8, 
                    PRTD,   8, 
                    Offset (0x68), 
                    PRTE,   8, 
                    PRTF,   8, 
                    PRTG,   8, 
                    PRTH,   8, 
                    Offset (0x80), 
                    IOD0,   8, 
                    IOD1,   8, 
                    Offset (0xB8), 
                    GR00,   2, 
                    GR01,   2, 
                    GR02,   2, 
                    GR03,   2, 
                    GR04,   2, 
                    GR05,   2, 
                    GR06,   2, 
                    GR07,   2, 
                    GR08,   2, 
                    GR09,   2, 
                    GR10,   2, 
                    GR11,   2, 
                    GR12,   2, 
                    GR13,   2, 
                    GR14,   2, 
                    GR15,   2, 
                    Offset (0xF0), 
                    RCEN,   1, 
                        ,   13, 
                    RCBA,   18
                }

                Device (LNKA)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, One)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTA = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLA, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLA, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTA & 0x0F))
                        Return (RTLA) /* \_SB_.PCI0.LPCB.LNKA._CRS.RTLA */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTA = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTA & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKB)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x02)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTB = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLB, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLB, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTB & 0x0F))
                        Return (RTLB) /* \_SB_.PCI0.LPCB.LNKB._CRS.RTLB */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTB = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTB & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKC)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x03)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTC = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLC, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLC, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTC & 0x0F))
                        Return (RTLC) /* \_SB_.PCI0.LPCB.LNKC._CRS.RTLC */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTC = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTC & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKD)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x04)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTD = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLD, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLD, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTD & 0x0F))
                        Return (RTLD) /* \_SB_.PCI0.LPCB.LNKD._CRS.RTLD */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTD = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTD & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKE)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x05)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTE = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLE, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLE, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTE & 0x0F))
                        Return (RTLE) /* \_SB_.PCI0.LPCB.LNKE._CRS.RTLE */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTE = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTE & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKF)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x06)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTF = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLF, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLF, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTF & 0x0F))
                        Return (RTLF) /* \_SB_.PCI0.LPCB.LNKF._CRS.RTLF */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTF = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTF & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKG)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x07)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTG = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLG, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLG, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTG & 0x0F))
                        Return (RTLG) /* \_SB_.PCI0.LPCB.LNKG._CRS.RTLG */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTG = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTG & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKH)
                {
                    Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                    Name (_UID, 0x08)  // _UID: Unique ID
                    Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                    {
                        PRTH = 0x80
                    }

                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (RTLH, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLH, One, IRQ0)
                        IRQ0 = Zero
                        IRQ0 = (One << (PRTH & 0x0F))
                        Return (RTLH) /* \_SB_.PCI0.LPCB.LNKH._CRS.RTLH */
                    }

                    Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Local0--
                        PRTH = Local0
                    }

                    Method (_STA, 0, Serialized)  // _STA: Status
                    {
                        If ((PRTH & 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (EC0)
                {
                    Name (_HID, EisaId ("PNP0C09") /* Embedded Controller Device */)  // _HID: Hardware ID
                    Name (_UID, One)  // _UID: Unique ID
                    Name (_GPE, 0x17)  // _GPE: General Purpose Events
                    Name (TOFS, 0xC8)
                    Name (TNCA, 0xFC)
                    Name (TNOP, 0xFD)
                    Name (TBAD, 0xFE)
                    Name (TNPR, 0xFF)
                    Name (DWRN, 0x0F)
                    Name (DLOW, 0x0A)
                    OperationRegion (ERAM, EmbeddedControl, Zero, 0xFF)
                    Field (ERAM, ByteAcc, Lock, Preserve)
                    {
                        RAMV,   8, 
                        TSTB,   8, 
                        TSTC,   8, 
                        KBLV,   8, 
                        FAND,   8, 
                        PATI,   8, 
                        PATT,   8, 
                        PATC,   8
                    }

                    OperationRegion (EMEM, SystemIO, 0x0900, 0xFF)
                    Field (EMEM, ByteAcc, NoLock, Preserve)
                    {
                        TIN0,   8, 
                        TIN1,   8, 
                        TIN2,   8, 
                        TIN3,   8, 
                        TIN4,   8, 
                        TIN5,   8, 
                        TIN6,   8, 
                        TIN7,   8, 
                        TIN8,   8, 
                        TIN9,   8, 
                        Offset (0x10), 
                        FAN0,   16, 
                        Offset (0x30), 
                        LIDS,   1, 
                        PBTN,   1, 
                        WPDI,   1, 
                        RECK,   1, 
                        RECD,   1, 
                        Offset (0x40), 
                        BTVO,   32, 
                        BTPR,   32, 
                        BTRA,   32, 
                        ACEX,   1, 
                        BTEX,   1, 
                        BFDC,   1, 
                        BFCG,   1, 
                        BFCR,   1, 
                        Offset (0x50), 
                        BTDA,   32, 
                        BTDV,   32, 
                        BTDF,   32, 
                        BTCC,   32, 
                        BMFG,   64, 
                        BMOD,   64, 
                        BSER,   64, 
                        BTYP,   64, 
                        ALS0,   16
                    }

                    Method (TINS, 1, Serialized)
                    {
                        Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                        While (One)
                        {
                            _T_0 = ToInteger (Arg0)
                            If ((_T_0 == Zero))
                            {
                                Return (TIN0) /* \_SB_.PCI0.LPCB.EC0_.TIN0 */
                            }
                            ElseIf ((_T_0 == One))
                            {
                                Return (TIN1) /* \_SB_.PCI0.LPCB.EC0_.TIN1 */
                            }
                            ElseIf ((_T_0 == 0x02))
                            {
                                Return (TIN2) /* \_SB_.PCI0.LPCB.EC0_.TIN2 */
                            }
                            ElseIf ((_T_0 == 0x03))
                            {
                                Return (TIN3) /* \_SB_.PCI0.LPCB.EC0_.TIN3 */
                            }
                            ElseIf ((_T_0 == 0x04))
                            {
                                Return (TIN4) /* \_SB_.PCI0.LPCB.EC0_.TIN4 */
                            }
                            ElseIf ((_T_0 == 0x05))
                            {
                                Return (TIN5) /* \_SB_.PCI0.LPCB.EC0_.TIN5 */
                            }
                            ElseIf ((_T_0 == 0x06))
                            {
                                Return (TIN6) /* \_SB_.PCI0.LPCB.EC0_.TIN6 */
                            }
                            ElseIf ((_T_0 == 0x07))
                            {
                                Return (TIN7) /* \_SB_.PCI0.LPCB.EC0_.TIN7 */
                            }
                            ElseIf ((_T_0 == 0x08))
                            {
                                Return (TIN8) /* \_SB_.PCI0.LPCB.EC0_.TIN8 */
                            }
                            ElseIf ((_T_0 == 0x09))
                            {
                                Return (TIN9) /* \_SB_.PCI0.LPCB.EC0_.TIN9 */
                            }
                            Else
                            {
                                Return (TIN0) /* \_SB_.PCI0.LPCB.EC0_.TIN0 */
                            }

                            Break
                        }
                    }

                    Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                    {
                        Name (ECMD, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0062,             // Range Minimum
                                0x0062,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0066,             // Range Minimum
                                0x0066,             // Range Maximum
                                0x00,               // Alignment
                                0x01,               // Length
                                )
                        })
                        Return (ECMD) /* \_SB_.PCI0.LPCB.EC0_._CRS.ECMD */
                    }

                    Method (_REG, 2, NotSerialized)  // _REG: Region Availability
                    {
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        \LIDS = LIDS /* \_SB_.PCI0.LPCB.EC0_.LIDS */
                    }

                    Method (TSRD, 1, Serialized)
                    {
                        Local0 = TINS (Arg0)
                        If ((Local0 == TNCA))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TNPR))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TNOP))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TBAD))
                        {
                            Return (Zero)
                        }

                        Local0 += TOFS
                        Local0 *= 0x0A
                        Return (Local0)
                    }

                    Method (_Q01, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: LID CLOSE"
                        \LIDS = LIDS /* \_SB_.PCI0.LPCB.EC0_.LIDS */
                        Notify (LID0, 0x80) // Status Change
                    }

                    Method (_Q02, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: LID OPEN"
                        \LIDS = LIDS /* \_SB_.PCI0.LPCB.EC0_.LIDS */
                        Notify (LID0, 0x80) // Status Change
                    }

                    Method (_Q03, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: POWER BUTTON"
                        Notify (PWRB, 0x80) // Status Change
                    }

                    Method (_Q04, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: AC CONNECTED"
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        Notify (AC, 0x80) // Status Change
                        PNOT ()
                    }

                    Method (_Q05, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: AC DISCONNECTED"
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        Notify (AC, 0x80) // Status Change
                        PNOT ()
                    }

                    Method (_Q06, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: BATTERY LOW"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q07, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: BATTERY CRITICAL"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q08, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: BATTERY INFO"
                        Notify (BAT0, 0x81) // Information Change
                    }

                    Method (_Q0A, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: THERMAL OVERLOAD"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q0B, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: THERMAL"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q0C, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: USB CHARGER"
                    }

                    Method (_Q0D, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: KEY PRESSED"
                    }

                    Method (_Q10, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: THERMAL SHUTDOWN"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q11, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: BATTERY SHUTDOWN"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q12, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: THROTTLE START"
                        If (CondRefOf (\_TZ.THRT, Local0))
                        {
                            \_TZ.THRT (One)
                        }
                    }

                    Method (_Q13, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        Debug = "EC: THROTTLE STOP"
                        If (CondRefOf (\_TZ.THRT, Local0))
                        {
                            \_TZ.THRT (Zero)
                        }
                    }

                    Mutex (PATM, 0x01)
                    Method (PAT0, 2, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        Divide (ToInteger (Arg1), 0x0A, Local0, Local1)
                        PATT = (Local1 - TOFS) /* \_SB_.PCI0.LPCB.EC0_.TOFS */
                        PATC = 0x02
                        Release (PATM)
                        Return (One)
                    }

                    Method (PAT1, 2, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        Divide (ToInteger (Arg1), 0x0A, Local0, Local1)
                        PATT = (Local1 - TOFS) /* \_SB_.PCI0.LPCB.EC0_.TOFS */
                        PATC = 0x03
                        Release (PATM)
                        Return (One)
                    }

                    Method (PATD, 1, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        PATT = Zero
                        PATC = Zero
                        PATC = One
                        Release (PATM)
                        Return (One)
                    }

                    Method (_Q09, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        Local0 = PATI /* \_SB_.PCI0.LPCB.EC0_.PATI */
                        While ((Local0 != 0xFF))
                        {
                            If (CondRefOf (\_SB.DPTF.TEVT, Local1))
                            {
                                ^^^^DPTF.TEVT (Local0)
                            }

                            Local0 = PATI /* \_SB_.PCI0.LPCB.EC0_.PATI */
                        }

                        Release (PATM)
                    }

                    Device (AC)
                    {
                        Name (_HID, "ACPI0003" /* Power Source Device */)  // _HID: Hardware ID
                        Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
                        {
                            _SB
                        })
                        Method (_PSR, 0, NotSerialized)  // _PSR: Power Source
                        {
                            Return (ACEX) /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }

                    Device (BAT0)
                    {
                        Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
                        {
                            _SB
                        })
                        Name (PBIF, Package (0x0D)
                        {
                            One, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            0xFFFFFFFF, 
                            0x03, 
                            0xFFFFFFFF, 
                            One, 
                            One, 
                            "", 
                            "", 
                            "LION", 
                            ""
                        })
                        Name (PBIX, Package (0x14)
                        {
                            Zero, 
                            One, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            0xFFFFFFFF, 
                            0x03, 
                            0xFFFFFFFF, 
                            Zero, 
                            0x00018000, 
                            0x01F4, 
                            0x0A, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            One, 
                            "", 
                            "", 
                            "LION", 
                            ""
                        })
                        Name (PBST, Package (0x04)
                        {
                            Zero, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        Name (BSTP, Zero)
                        Name (BFWK, One)
                        Method (BFWE, 0, NotSerialized)
                        {
                            BFWK = One
                        }

                        Method (BFWD, 0, NotSerialized)
                        {
                            BFWK = Zero
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            If (BTEX)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x0F)
                            }
                        }

                        Method (_BIF, 0, Serialized)  // _BIF: Battery Information
                        {
                            PBIF [0x02] = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                            PBIF [0x04] = BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
                            Local0 = BTDA /* \_SB_.PCI0.LPCB.EC0_.BTDA */
                            PBIF [One] = Local0
                            Divide ((Local0 * DWRN), 0x64, Local1, Local2)
                            PBIF [0x05] = Local2
                            Divide ((Local0 * DLOW), 0x64, Local1, Local2)
                            PBIF [0x06] = Local2
                            PBIF [0x09] = ToString (BMOD, Ones)
                            PBIF [0x0A] = ToString (BSER, Ones)
                            PBIF [0x0C] = ToString (BMFG, Ones)
                            Return (PBIF) /* \_SB_.PCI0.LPCB.EC0_.BAT0.PBIF */
                        }

                        Method (XBIX, 0, Serialized)
                        {
                            PBIX [0x03] = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                            PBIX [0x05] = BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
                            Local0 = BTDA /* \_SB_.PCI0.LPCB.EC0_.BTDA */
                            PBIX [0x02] = Local0
                            Divide ((Local0 * DWRN), 0x64, Local1, Local2)
                            PBIX [0x06] = Local2
                            Divide ((Local0 * DLOW), 0x64, Local1, Local2)
                            PBIX [0x07] = Local2
                            PBIX [0x08] = BTCC /* \_SB_.PCI0.LPCB.EC0_.BTCC */
                            PBIX [0x10] = ToString (BMOD, Ones)
                            PBIX [0x11] = ToString (BSER, Ones)
                            PBIX [0x13] = ToString (BMFG, Ones)
                            Return (PBIX) /* \_SB_.PCI0.LPCB.EC0_.BAT0.PBIX */
                        }

                        Method (_BST, 0, Serialized)  // _BST: Battery Status
                        {
                            Local1 = Zero
                            If (ACEX)
                            {
                                If (BFCG)
                                {
                                    Local1 = 0x02
                                }
                                ElseIf (BFDC)
                                {
                                    Local1 = One
                                }
                            }
                            Else
                            {
                                Local1 = One
                            }

                            If (BFCR)
                            {
                                Local1 |= 0x04
                            }

                            PBST [Zero] = Local1
                            If ((Local1 != BSTP))
                            {
                                BSTP = Local1
                                Notify (BAT0, 0x80) // Status Change
                            }

                            PBST [One] = BTPR /* \_SB_.PCI0.LPCB.EC0_.BTPR */
                            Local1 = BTRA /* \_SB_.PCI0.LPCB.EC0_.BTRA */
                            If ((BFWK && (ACEX && !(BFDC && BFCG))))
                            {
                                Local2 = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                                Local3 = (Local2 >> 0x05)
                                If (((Local1 > (Local2 - Local3)) && (Local1 < (Local2 + 
                                    Local3))))
                                {
                                    Local1 = Local2
                                }
                            }

                            PBST [0x02] = Local1
                            PBST [0x03] = BTVO /* \_SB_.PCI0.LPCB.EC0_.BTVO */
                            Return (PBST) /* \_SB_.PCI0.LPCB.EC0_.BAT0.PBST */
                        }
                    }
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x11,               // Length
                            )
                        IO (Decode16,
                            0x0093,             // Range Minimum
                            0x0093,             // Range Maximum
                            0x01,               // Alignment
                            0x0D,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }

                Device (FWH)
                {
                    Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        Memory32Fixed (ReadOnly,
                            0xFF000000,         // Address Base
                            0x01000000,         // Address Length
                            )
                    })
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
                    Name (_CID, EisaId ("PNP0C01") /* System Board */)  // _CID: Compatible ID
                    Name (BUF0, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xFED00000,         // Address Base
                            0x00000400,         // Address Length
                            _Y01)
                    })
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (HPTE)
                        {
                            If ((OSYS >= 0x07D1))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0B)
                            }
                        }

                        Return (Zero)
                    }

                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        If (HPTE)
                        {
                            CreateDWordField (BUF0, \_SB.PCI0.LPCB.HPET._Y01._BAS, HPT0)  // _BAS: Base Address
                            If ((HPAS == One))
                            {
                                HPT0 = 0xFED01000
                            }

                            If ((HPAS == 0x02))
                            {
                                HPT0 = 0xFED02000
                            }

                            If ((HPAS == 0x03))
                            {
                                HPT0 = 0xFED03000
                            }
                        }

                        Return (BUF0) /* \_SB_.PCI0.LPCB.HPET.BUF0 */
                    }
                }

                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000") /* 8259-compatible Programmable Interrupt Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0024,             // Range Minimum
                            0x0024,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0028,             // Range Minimum
                            0x0028,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x002C,             // Range Minimum
                            0x002C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0030,             // Range Minimum
                            0x0030,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0034,             // Range Minimum
                            0x0034,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0038,             // Range Minimum
                            0x0038,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x003C,             // Range Minimum
                            0x003C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A4,             // Range Minimum
                            0x00A4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A8,             // Range Minimum
                            0x00A8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00AC,             // Range Minimum
                            0x00AC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B4,             // Range Minimum
                            0x00B4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B8,             // Range Minimum
                            0x00B8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00BC,             // Range Minimum
                            0x00BC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }

                Device (LDRC)
                {
                    Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                    Name (_UID, 0x02)  // _UID: Unique ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x002E,             // Range Minimum
                            0x002E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x004E,             // Range Minimum
                            0x004E,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0092,             // Range Minimum
                            0x0092,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00B2,             // Range Minimum
                            0x00B2,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0500,             // Range Minimum
                            0x0500,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x0480,             // Range Minimum
                            0x0480,             // Range Maximum
                            0x01,               // Alignment
                            0x40,               // Length
                            )
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x08,               // Length
                            )
                    })
                }

                Device (TIMR)
                {
                    Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0050,             // Range Minimum
                            0x0050,             // Range Maximum
                            0x10,               // Alignment
                            0x04,               // Length
                            )
                        IRQNoFlags ()
                            {0}
                    })
                }

                Device (SIO)
                {
                    Name (_UID, Zero)  // _UID: Unique ID
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (ECMM)
                    {
                        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0900,             // Range Minimum
                                0x0900,             // Range Maximum
                                0x08,               // Alignment
                                0xFF,               // Length
                                )
                        })
                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            IO (Decode16,
                                0x0900,             // Range Minimum
                                0x0900,             // Range Maximum
                                0x08,               // Alignment
                                0xFF,               // Length
                                )
                        })
                    }

                    Device (ECUI)
                    {
                        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                        Name (_UID, 0x03)  // _UID: Unique ID
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0200,             // Range Minimum
                                0x0200,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0204,             // Range Minimum
                                0x0204,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0800,             // Range Minimum
                                0x0800,             // Range Maximum
                                0x08,               // Alignment
                                0x80,               // Length
                                )
                            IO (Decode16,
                                0x0880,             // Range Minimum
                                0x0800,             // Range Maximum
                                0x08,               // Alignment
                                0x80,               // Length
                                )
                        })
                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            StartDependentFn (0x00, 0x00)
                            {
                                IO (Decode16,
                                    0x0200,             // Range Minimum
                                    0x0200,             // Range Maximum
                                    0x01,               // Alignment
                                    0x01,               // Length
                                    )
                                IO (Decode16,
                                    0x0204,             // Range Minimum
                                    0x0204,             // Range Maximum
                                    0x01,               // Alignment
                                    0x01,               // Length
                                    )
                                IO (Decode16,
                                    0x0800,             // Range Minimum
                                    0x0800,             // Range Maximum
                                    0x08,               // Alignment
                                    0x80,               // Length
                                    )
                                IO (Decode16,
                                    0x0880,             // Range Minimum
                                    0x0880,             // Range Maximum
                                    0x08,               // Alignment
                                    0x80,               // Length
                                    )
                            }
                            EndDependentFn ()
                        })
                    }

                    Device (COM1)
                    {
                        Name (_HID, EisaId ("PNP0501") /* 16550A-compatible COM Serial Port */)  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x03F8,             // Range Minimum
                                0x03F8,             // Range Maximum
                                0x08,               // Alignment
                                0x08,               // Length
                                )
                            IRQNoFlags ()
                                {4}
                        })
                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            StartDependentFn (0x00, 0x00)
                            {
                                IO (Decode16,
                                    0x03F8,             // Range Minimum
                                    0x03F8,             // Range Maximum
                                    0x08,               // Alignment
                                    0x08,               // Length
                                    )
                                IRQNoFlags ()
                                    {4}
                            }
                            EndDependentFn ()
                        })
                    }

                    Device (PS2K)
                    {
                        Name (_UID, Zero)  // _UID: Unique ID
                        Name (_ADR, Zero)  // _ADR: Address
                        Name (_HID, EisaId ("PNP0303") /* IBM Enhanced Keyboard (101/102-key, PS/2 Mouse) */)  // _HID: Hardware ID
                        Name (_CID, EisaId ("PNP030B"))  // _CID: Compatible ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0060,             // Range Minimum
                                0x0060,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                )
                            IO (Decode16,
                                0x0064,             // Range Minimum
                                0x0064,             // Range Maximum
                                0x01,               // Alignment
                                0x01,               // Length
                                )
                            IRQNoFlags ()
                                {1}
                        })
                        Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                        {
                            StartDependentFn (0x00, 0x00)
                            {
                                IO (Decode16,
                                    0x0060,             // Range Minimum
                                    0x0060,             // Range Maximum
                                    0x01,               // Alignment
                                    0x01,               // Length
                                    )
                                IO (Decode16,
                                    0x0064,             // Range Minimum
                                    0x0064,             // Range Maximum
                                    0x01,               // Alignment
                                    0x01,               // Length
                                    )
                                IRQNoFlags ()
                                    {1}
                            }
                            EndDependentFn ()
                        })
                    }
                }
            }

            Device (SATA)
            {
                Name (_ADR, 0x001F0002)  // _ADR: Address
                Device (PRID)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_GTM, 0, NotSerialized)  // _GTM: Get Timing Mode
                    {
                        Name (PBUF, Buffer (0x14)
                        {
                            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* ........ */
                            /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* ........ */
                            /* 0010 */  0x00, 0x00, 0x00, 0x00                           /* .... */
                        })
                        CreateDWordField (PBUF, Zero, PIO0)
                        CreateDWordField (PBUF, 0x04, DMA0)
                        CreateDWordField (PBUF, 0x08, PIO1)
                        CreateDWordField (PBUF, 0x0C, DMA1)
                        CreateDWordField (PBUF, 0x10, FLAG)
                        Return (PBUF) /* \_SB_.PCI0.SATA.PRID._GTM.PBUF */
                    }

                    Method (_STM, 3, NotSerialized)  // _STM: Set Timing Mode
                    {
                        CreateDWordField (Arg0, Zero, PIO0)
                        CreateDWordField (Arg0, 0x04, DMA0)
                        CreateDWordField (Arg0, 0x08, PIO1)
                        CreateDWordField (Arg0, 0x0C, DMA1)
                        CreateDWordField (Arg0, 0x10, FLAG)
                    }

                    Device (DSK0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                    }

                    Device (DSK1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                    }
                }
            }

            Device (SBUS)
            {
                Name (_ADR, 0x001F0003)  // _ADR: Address
            }

            Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
            {
                If ((Arg0 == ToUUID ("7c9512a9-1705-4cb4-af7d-506a2423ab71")))
                {
                    Return (^XHC.POSC (Arg1, Arg2, Arg3))
                }

                If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
                {
                    Return (Arg3)
                }

                CreateDWordField (Arg3, Zero, CDW1)
                CDW1 |= 0x04
                Return (Arg3)
            }
        }
    }

    Name (OIPG, Package (0x02)
    {
        Package (0x04)
        {
            One, 
            Zero, 
            0x09, 
            "PantherPoint"
        }, 

        Package (0x04)
        {
            0x03, 
            One, 
            0x39, 
            "PantherPoint"
        }
    })
    Device (CRHW)
    {
        Name (_HID, EisaId ("GGL0001"))  // _HID: Hardware ID
        Method (_STA, 0, Serialized)  // _STA: Status
        {
            Return (0x0B)
        }

        Method (CHSW, 0, Serialized)
        {
            Name (WSHC, Package (0x01)
            {
                VBT3
            })
            Return (WSHC) /* \CRHW.CHSW.WSHC */
        }

        Method (FWID, 0, Serialized)
        {
            Name (DIW1, "")
            ToString (VBT5, 0x3F, DIW1) /* \CRHW.FWID.DIW1 */
            Name (DIWF, Package (0x01)
            {
                DIW1
            })
            Return (DIWF) /* \CRHW.FWID.DIWF */
        }

        Method (FRID, 0, Serialized)
        {
            Name (DIR1, "")
            ToString (VBT6, 0x3F, DIR1) /* \CRHW.FRID.DIR1 */
            Name (DIRF, Package (0x01)
            {
                DIR1
            })
            Return (DIRF) /* \CRHW.FRID.DIRF */
        }

        Method (HWID, 0, Serialized)
        {
            Name (DIW0, "")
            ToString (VBT4, 0xFF, DIW0) /* \CRHW.HWID.DIW0 */
            Name (DIWH, Package (0x01)
            {
                DIW0
            })
            Return (DIWH) /* \CRHW.HWID.DIWH */
        }

        Method (BINF, 0, Serialized)
        {
            Name (FNIB, Package (0x05)
            {
                VBT0, 
                VBT1, 
                VBT2, 
                VBT7, 
                VBT8
            })
            Return (FNIB) /* \CRHW.BINF.FNIB */
        }

        Method (GPIO, 0, Serialized)
        {
            Return (OIPG) /* \OIPG */
        }

        Method (VBNV, 0, Serialized)
        {
            Name (VNBV, Package (0x02)
            {
                Zero, 
                Zero
            })
            Return (VNBV) /* \CRHW.VBNV.VNBV */
        }

        Method (VDAT, 0, Serialized)
        {
            Name (TAD0, "")
            ToBuffer (CHVD, TAD0) /* \CRHW.VDAT.TAD0 */
            Name (TADV, Package (0x01)
            {
                TAD0
            })
            Return (TADV) /* \CRHW.VDAT.TADV */
        }

        Method (FMAP, 0, Serialized)
        {
            Name (PAMF, Package (0x01)
            {
                VBT9
            })
            Return (PAMF) /* \CRHW.FMAP.PAMF */
        }

        Method (MECK, 0, Serialized)
        {
            Name (HASH, Package (0x01)
            {
                MEHH
            })
            Return (HASH) /* \CRHW.MECK.HASH */
        }

        Method (MLST, 0, Serialized)
        {
            Name (TSLM, Package (0x0A)
            {
                "CHSW", 
                "FWID", 
                "HWID", 
                "FRID", 
                "BINF", 
                "GPIO", 
                "VBNV", 
                "VDAT", 
                "FMAP", 
                "MECK"
            })
            Return (TSLM) /* \CRHW.MLST.TSLM */
        }
    }

    Scope (_SB)
    {
        Device (RMOP)
        {
            Name (_HID, "GOOG9999")  // _HID: Hardware ID
            Name (_CID, "GOOG9999")  // _CID: Compatible ID
            Name (_UID, One)  // _UID: Unique ID
            Name (RBUF, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x00000000,         // Address Base
                    0x00000000,         // Address Length
                    _Y02)
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                CreateDWordField (RBUF, \_SB.RMOP._Y02._BAS, RBAS)  // _BAS: Base Address
                CreateDWordField (RBUF, \_SB.RMOP._Y02._LEN, RLEN)  // _LEN: Length
                RBAS = RMOB /* \RMOB */
                RLEN = RMOL /* \RMOL */
                Return (RBUF) /* \_SB_.RMOP.RBUF */
            }
        }
    }

    Name (_S0, Package (0x04)  // _S0_: S0 System State
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    Name (_S3, Package (0x04)  // _S3_: S3 System State
    {
        0x05, 
        0x05, 
        Zero, 
        Zero
    })
    Name (_S4, Package (0x04)  // _S4_: S4 System State
    {
        0x06, 
        0x06, 
        Zero, 
        Zero
    })
    Name (_S5, Package (0x04)  // _S5_: S5 System State
    {
        0x07, 
        0x07, 
        Zero, 
        Zero
    })
}

