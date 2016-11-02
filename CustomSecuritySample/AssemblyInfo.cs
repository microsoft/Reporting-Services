#region Copyright © Microsoft Corporation. All rights reserved.
/*============================================================================
  File:      AssemblyInfo.cs
--------------------------------------------------------------------
  This file is part of Microsoft SQL Server Code Samples.
    
 This source code is intended only as a supplement to Microsoft
 Development Tools and/or on-line documentation. See these other
 materials for detailed information regarding Microsoft code 
 samples.

 THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
 ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
 PARTICULAR PURPOSE.
===========================================================================*/
#endregion

using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

//
// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
//
[assembly: AssemblyTitle("Forms Authentication Sample")]
[assembly: AssemblyDescription("Forms Authentication Sample")]
[assembly: AssemblyVersion("1.0.*")]
[assembly: System.CLSCompliant(true)]
[assembly: System.Runtime.InteropServices.ComVisible(false)]
[assembly: System.Security.Permissions.SecurityPermissionAttribute(System.Security.Permissions.SecurityAction.RequestMinimum)]
[assembly: System.Runtime.ConstrainedExecution.ReliabilityContract(System.Runtime.ConstrainedExecution.Consistency.MayCorruptInstance, System.Runtime.ConstrainedExecution.Cer.None)]


[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1810:InitializeReferenceTypeStaticFieldsInline", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization..cctor()")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.CatalogOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.CatalogOperation[]):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.DatasourceOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.FolderOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.FolderOperation[]):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ModelItemOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1725:ParameterNamesShouldMatchBaseDeclaration", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ModelItemOperation):System.Boolean", MessageId = "3#")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ModelOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1725:ParameterNamesShouldMatchBaseDeclaration", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ModelOperation):System.Boolean", MessageId = "3#")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ReportOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ResourceOperation):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.Authorization.CheckAccess(System.String,System.IntPtr,System.Byte[],Microsoft.ReportingServices.Interfaces.ResourceOperation[]):System.Boolean")]
[assembly: System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1805:DoNotInitializeUnnecessarily", Scope = "member", Target = "Microsoft.Samples.ReportingServices.CustomSecurity.ReportServerProxy..ctor()")]
