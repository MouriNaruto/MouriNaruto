---
title: Using System Restore via C#
date: 2021-11-14 03:29:33
categories:
- [Technologies, Windows, Windows Research Notes, System Restore]
tags:
- Technologies
- Windows
- Windows Research Notes
- System Restore
---

This article summarizes how to use System Restore via C#.

Read [here](https://mouri.moe/zh/2021/11/14/Using-System-Restore-with-CSharp/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

## Create a system restore point via Win32 API

```
[StructLayout(LayoutKind.Sequential)]
public struct RESTOREPOINTINFO
{
    public int dwEventType;
    public int dwRestorePtType;
    public Int64 llSequenceNumber;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 257)]
    public string szDescription;
}

[StructLayout(LayoutKind.Sequential)]
public struct STATEMGRSTATUS
{
    public uint nStatus;
    public Int64 llSequenceNumber;
}

[DllImport("SrClient.dll")]
public static extern bool SRSetRestorePoint(ref RESTOREPOINTINFO SRPInfo, ref STATEMGRSTATUS SRPStatus);

static void Main(string[] args)
{
    RegistryKey SystemRestoreKey = Registry.LocalMachine.OpenSubKey("Software\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore",true);
    SystemRestoreKey.SetValue("SystemRestorePointCreationFrequency", 0,RegistryValueKind.DWord);

    bool result = false;
    RESTOREPOINTINFO RPInfo = new RESTOREPOINTINFO();
    STATEMGRSTATUS RPStatus = new STATEMGRSTATUS();

    RPInfo.dwEventType = 100;
    RPInfo.dwRestorePtType = 0;
    RPInfo.llSequenceNumber = 0;
    RPInfo.szDescription = "System Restore Point";

    result = SRSetRestorePoint(ref RPInfo, ref RPStatus);

    SystemRestoreKey.DeleteValue("SystemRestorePointCreationFrequency");
}
```

## Create a system restore point via WMI

```
private static bool CreateSRP(string RPName, int RPType, int EventType)
{
    ManagementClass SRClass = new ManagementClass("//./root/default:SystemRestore");

    ManagementBaseObject SRArgs = SRClass.GetMethodParameters("CreateRestorePoint");
    SRArgs["Description"] = RPName;
    SRArgs["RestorePointType"] = RPType;
    SRArgs["EventType"] = EventType;

    try
    {
        ManagementBaseObject outParams = SRClass.InvokeMethod("CreateRestorePoint", SRArgs, new InvokeMethodOptions(null, System.TimeSpan.MaxValue));
        return true;
    }
    catch
    {
        return false;
    }
}

static void Main(string[] args)
{
    value = CreateSRP("System Restore Point", 0, 100);
    if (value == true)
    {
        Console.Write("Success");
    }
    else
    {
        Console.Write("Failed");
    }
    Console.Read();

}
```

## Remove all system restore points via AlphaVSS library

```
using System;
using System.Collections.Generic;
using System.Linq;
using Alphaleonis.Win32.Vss;

namespace SRDemoVSS
{
    class Program
    {
        static void Main(string[] args)
        {

            IVssImplementation vssImplementation = VssUtils.LoadImplementation();
            using (IVssBackupComponents backupComponents = vssImplementation.CreateVssBackupComponents())
            {
                backupComponents.InitializeForBackup(null);

                backupComponents.SetContext(VssSnapshotContext.All);

                IList<VssSnapshotProperties> snapshots = backupComponents.QuerySnapshots().ToArray();

                if (snapshots.Count == 0)
                {
                    Console.WriteLine("There were no shadow copies on the system.");
                    return;
                }

                try
                {
                    foreach (VssSnapshotProperties snapshot in snapshots)
                    {
                        Console.WriteLine(
                            "- Deleting shadow copy {0:B} on {1} from provider {2} [{3}]...", 
                            snapshot.SnapshotId,
                            snapshot.OriginalVolumeName, 
                            snapshot.ProviderId, 
                            snapshot.SnapshotAttributes);
                        backupComponents.DeleteSnapshot(snapshot.SnapshotId, false);
                    }
                }
                finally { }

            }
        }
    }
}
```

## Remove all system restore points via Win32 API and WMI

```
using System;
using System.Management;
using System.Runtime.InteropServices;

namespace SRDeleteDemoAPI
{
    class Program
    {
        [DllImport("SrClient.dll")]
        public static extern int SRRemoveRestorePoint(int dwRPNum);
        static void Main(string[] args)
        {
            try
            {
                ManagementObjectSearcher SRObject = new ManagementObjectSearcher("root/default", "SELECT * FROM SystemRestore");
                foreach (ManagementObject SRInfo in SRObject.Get())
                {
                    SRRemoveRestorePoint(Convert.ToInt32(SRInfo["SequenceNumber"].ToString()));
                }
                Console.WriteLine("Success");
            }
            catch (Exception)
            {
                Console.WriteLine("Failure");
            }            
        }
    }
}
```

## Restore from a system restore point via WMI

```
using System;
using System.Management;

public static bool RestoreFromRestorePoint(int RPNum)
{
    ManagementClass SRClass = new ManagementClass("//./root/default:SystemRestore");

    try
    {
        object[] SRArgs = { RPNum };
        SRClass.InvokeMethod("Restore", SRArgs);
        return true;
    }
    catch
    {
        return false;
    }   
}
```

## Enable System Restore for the specific drive (C drive for example) via Win32 API

```
using System;
using System.Runtime.InteropServices;

namespace SRTest
{
        class Program
        {
                [DllImport("SrClient.dll")]
                public static extern int EnableSR([MarshalAs(UnmanagedType.LPWStr)]string Drive);
        
                public static void Main(string[] args)
                {                        
                        Console.Write(EnableSR("C:\\"));
                                                
                        Console.Write("Press any key to continue . . . ");
                        Console.ReadKey(true);
                }
        }
}
```

## Disable System Restore for the specific drive (C drive for example) via Win32 API

```
using System;
using System.Runtime.InteropServices;

namespace SRTest
{
        class Program
        {
                [DllImport("SrClient.dll")]
                public static extern int DisableSR([MarshalAs(UnmanagedType.LPWStr)]string Drive);      
        
                public static void Main(string[] args)
                {                        
                        Console.Write(DisableSR("C:\\"));
                                                
                        Console.Write("Press any key to continue . . . ");
                        Console.ReadKey(true);
                }
        }
}
```

## References

- [Windows系统还原新探（Windows系统还原的较深入研究）](https://bbs.pcbeta.com/viewthread-1507617-1-1.html)

## See also

- {% post_link The-usage-of-System-Restore %}
- {% post_link Windows-Research-Notes %}
