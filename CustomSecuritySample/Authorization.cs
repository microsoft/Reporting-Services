#region Copyright © Microsoft Corporation. All rights reserved.
/*============================================================================
  File:     Authorization.cs

  Summary:  Demonstrates an implementation of an authorization 
            extension.
------------------------------------------------------------------------------
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

using System;
using System.IO;
using System.Collections;
using System.Collections.Specialized;
using System.Globalization;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using Microsoft.ReportingServices.Interfaces;
using System.Xml;

namespace Microsoft.Samples.ReportingServices.CustomSecurity
{
   public class Authorization: IAuthorizationExtension
   {
      private static string m_adminUserName;
      static Authorization()
      {
         InitializeMaps();
      }
      
      /// <summary>
      /// Returns a security descriptor that is stored with an individual 
      /// item in the report server database. 
      /// </summary>
      /// <param name="acl">The access code list (ACL) created by the report 
      /// server for the item. It contains a collection of access code entry 
      /// (ACE) structures.</param>
      /// <param name="itemType">The type of item for which the security 
      /// descriptor is created.</param>
      /// <param name="stringSecDesc">Optional. A user-friendly description 
      /// of the security descriptor, used for debugging. This is not stored
      /// by the report server.</param>
      /// <returns>Should be implemented to return a serialized access code 
      /// list for the item.</returns>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public byte[] CreateSecurityDescriptor(
         AceCollection acl, 
         SecurityItemType itemType, 
         out string stringSecDesc)
      {
         // Creates a memory stream and serializes the ACL for storage.
         BinaryFormatter bf = new BinaryFormatter();
		 using (MemoryStream result = new MemoryStream())
		 {
			 bf.Serialize(result, acl);
			 stringSecDesc = null;
			 return result.GetBuffer();
		 }
      }

	  public bool CheckAccess(
		string userName,
		IntPtr userToken,
		byte[] secDesc,
		ModelItemOperation modelItemOperation)
	  {
      // If the user is the administrator, allow unrestricted access.
      // Because SQL Server defaults to case-insensitive, we have to
      // perform a case insensitive comparison. Ideally you would check
      // the SQL Server instance CaseSensitivity property before making
      // a case-insensitive comparison.
      if (0 == String.Compare(userName, m_adminUserName, true,
            CultureInfo.CurrentCulture))
        return true;

      AceCollection acl = DeserializeAcl(secDesc);
      foreach (AceStruct ace in acl)
      {
        // First check to see if the user or group has an access control 
        //  entry for the item
        if (0 == String.Compare(userName, ace.PrincipalName, true,
           CultureInfo.CurrentCulture))
        {
          // If an entry is found, 
          // return true if the given required operation
          // is contained in the ACE structure
          foreach (ModelItemOperation aclOperation in ace.ModelItemOperations)
          {
            if (aclOperation == modelItemOperation)
              return true;
          }
        }
      }
      
      return false;
	  }

	  public bool CheckAccess(
	   string userName,
	   IntPtr userToken,
	   byte[] secDesc,
	   ModelOperation modelOperation)
	  {
      // If the user is the administrator, allow unrestricted access.
      // Because SQL Server defaults to case-insensitive, we have to
      // perform a case insensitive comparison. Ideally you would check
      // the SQL Server instance CaseSensitivity property before making
      // a case-insensitive comparison.
      if (0 == String.Compare(userName, m_adminUserName, true,
            CultureInfo.CurrentCulture))
        return true;

      AceCollection acl = DeserializeAcl(secDesc);
      foreach (AceStruct ace in acl)
      {
        // First check to see if the user or group has an access control 
        //  entry for the item
        if (0 == String.Compare(userName, ace.PrincipalName, true,
           CultureInfo.CurrentCulture))
        {
          // If an entry is found, 
          // return true if the given required operation
          // is contained in the ACE structure
          foreach (ModelOperation aclOperation in ace.ModelOperations)
          {
            if (aclOperation == modelOperation)
              return true;
          }
        }
      }

      return false;
	  }

      /// <summary>
      /// Indicates whether a given user is authorized to access the item 
      /// for a given catalog operation.
      /// </summary>
      /// <param name="userName">The name of the user as returned by the 
      /// GetUserInfo method.</param>
      /// <param name="userToken">Pointer to the user ID returned by 
      /// GetUserInfo.</param>
      /// <param name="secDesc">The security descriptor returned by 
      /// CreateSecurityDescriptor.</param>
      /// <param name="requiredOperation">The operation being requested by 
      /// the report server for a given user.</param>
      /// <returns>True if the user is authorized.</returns>
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         CatalogOperation requiredOperation)
      {
         // If the user is the administrator, allow unrestricted access.
         // Because SQL Server defaults to case-insensitive, we have to
         // perform a case insensitive comparison. Ideally you would check
         // the SQL Server instance CaseSensitivity property before making
         // a case-insensitive comparison.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;

         AceCollection acl = DeserializeAcl(secDesc);
         foreach(AceStruct ace in acl)
         {
            // First check to see if the user or group has an access control 
            //  entry for the item
            if (0 == String.Compare(userName, ace.PrincipalName, true, 
               CultureInfo.CurrentCulture))
            {
               // If an entry is found, 
               // return true if the given required operation
               // is contained in the ACE structure
               foreach(CatalogOperation aclOperation in ace.CatalogOperations)
               {
                  if (aclOperation == requiredOperation)
                     return true;
               }
            }
         }
         
         return false;
      }

      // Overload for array of catalog operations
      public bool CheckAccess(
         string userName,
         IntPtr userToken, 
         byte[] secDesc, 
         CatalogOperation[] requiredOperations)
      {
         foreach(CatalogOperation operation in requiredOperations)
         {
            if (!CheckAccess(userName, userToken, secDesc, operation))
               return false;
         }
         return true; 
      }

      // Overload for Report operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         ReportOperation requiredOperation)
      {
         // If the user is the administrator, allow unrestricted access.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;
         
         AceCollection acl = DeserializeAcl(secDesc);
         foreach(AceStruct ace in acl)
         {
            if (0 == String.Compare(userName, ace.PrincipalName, true,
               CultureInfo.CurrentCulture))
            {
               foreach(ReportOperation aclOperation in 
                  ace.ReportOperations)
               {
                  if (aclOperation == requiredOperation)
                     return true;
               }
            }
         }
         return false;
      }

      // Overload for Folder operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         FolderOperation requiredOperation)
      {
         // If the user is the administrator, allow unrestricted access.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;
         
         AceCollection acl = DeserializeAcl(secDesc);
         foreach(AceStruct ace in acl)
         {
            if (0 == String.Compare(userName, ace.PrincipalName, true, 
               CultureInfo.CurrentCulture))
            {
               foreach(FolderOperation aclOperation in 
                  ace.FolderOperations)
               {
                  if (aclOperation == requiredOperation)
                     return true;
               }
            }
         }
         
         return false;
      }

      // Overload for an array of Folder operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         FolderOperation[] requiredOperations)
      {
         foreach(FolderOperation operation in requiredOperations)
         {
               if (!CheckAccess(userName, userToken, secDesc, operation))
                  return false;
         }
         return true; 
      }

      // Overload for Resource operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         ResourceOperation requiredOperation)
      {
         // If the user is the administrator, allow unrestricted access.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;
            
         AceCollection acl = DeserializeAcl(secDesc);
         foreach(AceStruct ace in acl)
         {
            if (0 == String.Compare(userName, ace.PrincipalName, true, 
               CultureInfo.CurrentCulture))
            {
               foreach(ResourceOperation aclOperation in 
                  ace.ResourceOperations)
               {
                  if (aclOperation == requiredOperation)
                     return true;
               }
            }
         }
         
         return false;
      }

      // Overload for an array of Resource operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         ResourceOperation[] requiredOperations)
      {
         // If the user is the administrator, allow unrestricted access.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;
   
         foreach(ResourceOperation operation in requiredOperations)
         {
            if (!CheckAccess(userName, userToken, secDesc, operation))
               return false;
         }
         return true; 
      }

      // Overload for Datasource operations
      public bool CheckAccess(
         string userName, 
         IntPtr userToken, 
         byte[] secDesc, 
         DatasourceOperation requiredOperation)
      {
         // If the user is the administrator, allow unrestricted access.
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
            return true;

         AceCollection acl = DeserializeAcl(secDesc);
         foreach(AceStruct ace in acl)
         {
            if (0 == String.Compare(userName, ace.PrincipalName, true, 
               CultureInfo.CurrentCulture))
            {
               foreach(DatasourceOperation aclOperation in 
                  ace.DatasourceOperations)
               {
                  if (aclOperation == requiredOperation)
                     return true;
               }
            }
         }
         
         return false;
      }

      /// <summary>
      /// Returns the set of permissions a specific user has for a specific 
      /// item managed in the report server database. This provides underlying 
      /// support for the Web service method GetPermissions().
      /// </summary>
      /// <param name="userName">The name of the user as returned by the 
      /// GetUserInfo method.</param>
      /// <param name="userToken">Pointer to the user ID returned by 
      /// GetUserInfo.</param>
      /// <param name="itemType">The type of item for which the permissions 
      /// are returned.</param>
      /// <param name="secDesc">The security descriptor associated with the 
      /// item.</param>
      /// <returns></returns>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
      public StringCollection GetPermissions(string userName, IntPtr userToken,
         SecurityItemType itemType, byte[] secDesc)
      {
         StringCollection permissions = new StringCollection();
         if (0 == String.Compare(userName, m_adminUserName, true, 
               CultureInfo.CurrentCulture))
         {
			 foreach (CatalogOperation oper in m_CatOperNames.Keys)
			 {
				 if (!permissions.Contains((string)m_CatOperNames[oper]))
					 permissions.Add((string)m_CatOperNames[oper]);
			 }
            foreach(ModelItemOperation oper in m_ModelItemOperNames.Keys)
            {
              if (!permissions.Contains((string)m_ModelItemOperNames[oper]))
                permissions.Add((string)m_ModelItemOperNames[oper]);
            }
            foreach(ModelOperation oper in m_ModelOperNames.Keys)
            {
              if (!permissions.Contains((string)m_ModelOperNames[oper]))
                permissions.Add((string)m_ModelOperNames[oper]);
            }
            foreach(CatalogOperation oper in m_CatOperNames.Keys)
            {
               if (!permissions.Contains((string)m_CatOperNames[oper]))
                  permissions.Add((string)m_CatOperNames[oper]);
            }
            foreach(ReportOperation oper in m_RptOperNames.Keys)
            {
               if (!permissions.Contains((string)m_RptOperNames[oper]))
                  permissions.Add((string)m_RptOperNames[oper]);
            }
            foreach(FolderOperation oper in m_FldOperNames.Keys)
            {
               if (!permissions.Contains((string)m_FldOperNames[oper]))
                  permissions.Add((string)m_FldOperNames[oper]);
            }
            foreach(ResourceOperation oper in m_ResOperNames.Keys)
            {
               if (!permissions.Contains((string)m_ResOperNames[oper]))
                  permissions.Add((string)m_ResOperNames[oper]);
            }
            foreach(DatasourceOperation oper in m_DSOperNames.Keys)
            {
               if (!permissions.Contains((string)m_DSOperNames[oper]))
                  permissions.Add((string)m_DSOperNames[oper]);                            
            }
         }
         else
         {
            AceCollection acl = DeserializeAcl(secDesc);
            foreach(AceStruct ace in acl)
            {
               if (0 == String.Compare(userName, ace.PrincipalName, true, 
                     CultureInfo.CurrentCulture))
               {
                  foreach(ModelItemOperation aclOperation in ace.ModelItemOperations)
                  {
                     if (!permissions.Contains((string)m_ModelItemOperNames[aclOperation]))
                       permissions.Add((string)m_ModelItemOperNames[aclOperation]);
                  }
                  foreach(ModelOperation aclOperation in ace.ModelOperations)
                  {
                     if (!permissions.Contains((string)m_ModelOperNames[aclOperation]))
                       permissions.Add((string)m_ModelOperNames[aclOperation]);
                  }
                  foreach(CatalogOperation aclOperation in 
                     ace.CatalogOperations)
                  {
                     if (!permissions.Contains((string)m_CatOperNames[aclOperation]))
                        permissions.Add((string)m_CatOperNames[aclOperation]);
                  }
                  foreach(ReportOperation aclOperation in ace.ReportOperations)
                  {
                     if (!permissions.Contains((string)m_RptOperNames[aclOperation]))
                        permissions.Add((string)m_RptOperNames[aclOperation]);
                  }
                  foreach(FolderOperation aclOperation in ace.FolderOperations)
                  {
                     if (!permissions.Contains((string)m_FldOperNames[aclOperation]))
                        permissions.Add((string)m_FldOperNames[aclOperation]);
                  }
                  foreach(ResourceOperation aclOperation in ace.ResourceOperations)
                  {
                     if (!permissions.Contains((string)m_ResOperNames[aclOperation]))
                        permissions.Add((string)m_ResOperNames[aclOperation]);
                  }
                  foreach(DatasourceOperation aclOperation in ace.DatasourceOperations)
                  {
                     if (!permissions.Contains((string)m_DSOperNames[aclOperation]))
                        permissions.Add((string)m_DSOperNames[aclOperation]);                            
                  }
               }
            }
         }
                  
         return permissions;
      }

      // Used to deserialize the ACL that is stored by the report server.
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
      private AceCollection DeserializeAcl(byte[] secDesc)
      {
         AceCollection acl = new AceCollection();
         if (secDesc != null)
         {
            BinaryFormatter bf = new BinaryFormatter();
			using (MemoryStream sdStream = new MemoryStream(secDesc))
			{
				acl = (AceCollection)bf.Deserialize(sdStream);
			}
         }
         return acl;
      }

      private static Hashtable           m_ModelItemOperNames;
	    private static Hashtable           m_ModelOperNames;
      private static Hashtable           m_CatOperNames;
      private static Hashtable           m_FldOperNames;
      private static Hashtable           m_RptOperNames;
      private static Hashtable           m_ResOperNames;
      private static Hashtable           m_DSOperNames;

      private const int NrRptOperations = 27;
      private const int NrFldOperations = 10;
      private const int NrResOperations = 7; 
      private const int NrDSOperations = 7;
      private const int NrCatOperations = 16;
      private const int NrModelOperations = 11;
      private const int NrModelItemOperations = 1;

      // Utility method used to create mappings to the various
      // operations in Reporting Services. These mappings support
      // the implementation of the GetPermissions method.
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
      private static void InitializeMaps()
      {
        // create model operation names data
        m_ModelItemOperNames = new Hashtable();
        m_ModelItemOperNames.Add(ModelItemOperation.ReadProperties,
           OperationNames.OperReadProperties);

        if (m_ModelItemOperNames.Count != NrModelItemOperations)
        {
          //Model item name mismatch
          throw new Exception(string.Format(CultureInfo.InvariantCulture,
              CustomSecurity.OperationNameError));
        }

        // create model operation names data
        m_ModelOperNames = new Hashtable();
        m_ModelOperNames.Add(ModelOperation.Delete,
           OperationNames.OperDelete);
        m_ModelOperNames.Add(ModelOperation.ReadAuthorizationPolicy,
          OperationNames.OperReadAuthorizationPolicy);
        m_ModelOperNames.Add(ModelOperation.ReadContent,
          OperationNames.OperReadContent);
        m_ModelOperNames.Add(ModelOperation.ReadDatasource,
          OperationNames.OperReadDatasources);
        m_ModelOperNames.Add(ModelOperation.ReadModelItemAuthorizationPolicies,
          OperationNames.OperReadModelItemSecurityPolicies);
        m_ModelOperNames.Add(ModelOperation.ReadProperties,
          OperationNames.OperReadProperties);
        m_ModelOperNames.Add(ModelOperation.UpdateContent,
          OperationNames.OperUpdateContent);
        m_ModelOperNames.Add(ModelOperation.UpdateDatasource,
          OperationNames.OperUpdateDatasources);
        m_ModelOperNames.Add(ModelOperation.UpdateDeleteAuthorizationPolicy,
          OperationNames.OperUpdateDeleteAuthorizationPolicy);
        m_ModelOperNames.Add(ModelOperation.UpdateModelItemAuthorizationPolicies,
          OperationNames.OperUpdateModelItemSecurityPolicies);
        m_ModelOperNames.Add(ModelOperation.UpdateProperties,
          OperationNames.OperUpdatePolicy);

        if (m_ModelOperNames.Count != NrModelOperations)
        {
          //Model name mismatch
          throw new Exception(string.Format(CultureInfo.InvariantCulture,
             CustomSecurity.OperationNameError));
        }

         // create operation names data
         m_CatOperNames = new Hashtable();
         m_CatOperNames.Add(CatalogOperation.CreateRoles,
            OperationNames.OperCreateRoles);
         m_CatOperNames.Add(CatalogOperation.DeleteRoles,
            OperationNames.OperDeleteRoles);
         m_CatOperNames.Add(CatalogOperation.ReadRoleProperties,
            OperationNames.OperReadRoleProperties);
         m_CatOperNames.Add(CatalogOperation.UpdateRoleProperties,
            OperationNames.OperUpdateRoleProperties);
         m_CatOperNames.Add(CatalogOperation.ReadSystemProperties,
            OperationNames.OperReadSystemProperties);
         m_CatOperNames.Add(CatalogOperation.UpdateSystemProperties,
            OperationNames.OperUpdateSystemProperties);
         m_CatOperNames.Add(CatalogOperation.GenerateEvents,
            OperationNames.OperGenerateEvents);
         m_CatOperNames.Add(CatalogOperation.ReadSystemSecurityPolicy,
            OperationNames.OperReadSystemSecurityPolicy);
         m_CatOperNames.Add(CatalogOperation.UpdateSystemSecurityPolicy,
            OperationNames.OperUpdateSystemSecurityPolicy);
         m_CatOperNames.Add(CatalogOperation.CreateSchedules,
            OperationNames.OperCreateSchedules);
         m_CatOperNames.Add(CatalogOperation.DeleteSchedules,
            OperationNames.OperDeleteSchedules);
         m_CatOperNames.Add(CatalogOperation.ReadSchedules,
            OperationNames.OperReadSchedules);
         m_CatOperNames.Add(CatalogOperation.UpdateSchedules,
            OperationNames.OperUpdateSchedules);
         m_CatOperNames.Add(CatalogOperation.ListJobs,
            OperationNames.OperListJobs);
         m_CatOperNames.Add(CatalogOperation.CancelJobs,
            OperationNames.OperCancelJobs);
         m_CatOperNames.Add(CatalogOperation.ExecuteReportDefinition,
          OperationNames.ExecuteReportDefinition);
         if (m_CatOperNames.Count != NrCatOperations)
         {
           //Catalog name mismatch
           throw new Exception(string.Format(CultureInfo.InvariantCulture,
            CustomSecurity.OperationNameError));
         }
         
         m_FldOperNames = new Hashtable();
         m_FldOperNames.Add(FolderOperation.CreateFolder,
            OperationNames.OperCreateFolder);
         m_FldOperNames.Add(FolderOperation.Delete,
            OperationNames.OperDelete);
         m_FldOperNames.Add(FolderOperation.ReadProperties,
            OperationNames.OperReadProperties);
         m_FldOperNames.Add(FolderOperation.UpdateProperties,
            OperationNames.OperUpdateProperties);
         m_FldOperNames.Add(FolderOperation.CreateReport,
            OperationNames.OperCreateReport);
         m_FldOperNames.Add(FolderOperation.CreateResource,
            OperationNames.OperCreateResource);
         m_FldOperNames.Add(FolderOperation.ReadAuthorizationPolicy,
            OperationNames.OperReadAuthorizationPolicy);
         m_FldOperNames.Add(FolderOperation.UpdateDeleteAuthorizationPolicy,
            OperationNames.OperUpdateDeleteAuthorizationPolicy);
         m_FldOperNames.Add(FolderOperation.CreateDatasource,
            OperationNames.OperCreateDatasource);
         m_FldOperNames.Add(FolderOperation.CreateModel,
            OperationNames.OperCreateModel);
         if (m_FldOperNames.Count != NrFldOperations)
         {
           //Folder name mismatch
           throw new Exception(string.Format(CultureInfo.InvariantCulture,
            CustomSecurity.OperationNameError));
         }

         m_RptOperNames = new Hashtable();
         m_RptOperNames.Add(ReportOperation.Delete,
            OperationNames.OperDelete);
         m_RptOperNames.Add(ReportOperation.ReadProperties,
            OperationNames.OperReadProperties);
         m_RptOperNames.Add(ReportOperation.UpdateProperties,
            OperationNames.OperUpdateProperties);
         m_RptOperNames.Add(ReportOperation.UpdateParameters,
            OperationNames.OperUpdateParameters);
         m_RptOperNames.Add(ReportOperation.ReadDatasource,
            OperationNames.OperReadDatasources);
         m_RptOperNames.Add(ReportOperation.UpdateDatasource,
            OperationNames.OperUpdateDatasources);
         m_RptOperNames.Add(ReportOperation.ReadReportDefinition,
            OperationNames.OperReadReportDefinition);
         m_RptOperNames.Add(ReportOperation.UpdateReportDefinition,
            OperationNames.OperUpdateReportDefinition);
         m_RptOperNames.Add(ReportOperation.CreateSubscription,
            OperationNames.OperCreateSubscription);
         m_RptOperNames.Add(ReportOperation.DeleteSubscription,
            OperationNames.OperDeleteSubscription);
         m_RptOperNames.Add(ReportOperation.ReadSubscription,
            OperationNames.OperReadSubscription);
         m_RptOperNames.Add(ReportOperation.UpdateSubscription,
            OperationNames.OperUpdateSubscription);
         m_RptOperNames.Add(ReportOperation.CreateAnySubscription,
            OperationNames.OperCreateAnySubscription);
         m_RptOperNames.Add(ReportOperation.DeleteAnySubscription,
            OperationNames.OperDeleteAnySubscription);
         m_RptOperNames.Add(ReportOperation.ReadAnySubscription,
            OperationNames.OperReadAnySubscription);
         m_RptOperNames.Add(ReportOperation.UpdateAnySubscription,
            OperationNames.OperUpdateAnySubscription);
         m_RptOperNames.Add(ReportOperation.UpdatePolicy,
            OperationNames.OperUpdatePolicy);
         m_RptOperNames.Add(ReportOperation.ReadPolicy,
            OperationNames.OperReadPolicy);
         m_RptOperNames.Add(ReportOperation.DeleteHistory,
            OperationNames.OperDeleteHistory);
         m_RptOperNames.Add(ReportOperation.ListHistory,
            OperationNames.OperListHistory);
         m_RptOperNames.Add(ReportOperation.ExecuteAndView,
            OperationNames.OperExecuteAndView);
         m_RptOperNames.Add(ReportOperation.CreateResource,
            OperationNames.OperCreateResource);
         m_RptOperNames.Add(ReportOperation.CreateSnapshot,
            OperationNames.OperCreateSnapshot);
         m_RptOperNames.Add(ReportOperation.ReadAuthorizationPolicy,
            OperationNames.OperReadAuthorizationPolicy);
         m_RptOperNames.Add(ReportOperation.UpdateDeleteAuthorizationPolicy,
            OperationNames.OperUpdateDeleteAuthorizationPolicy);
         m_RptOperNames.Add(ReportOperation.Execute,
            OperationNames.OperExecute);
         m_RptOperNames.Add(ReportOperation.CreateLink,
            OperationNames.OperCreateLink);

         if (m_RptOperNames.Count != NrRptOperations)
         {
           //Report name mismatch
           throw new Exception(string.Format(CultureInfo.InvariantCulture,
            CustomSecurity.OperationNameError));
         }

         m_ResOperNames = new Hashtable();
         m_ResOperNames.Add(ResourceOperation.Delete,
            OperationNames.OperDelete);
         m_ResOperNames.Add(ResourceOperation.ReadProperties,
            OperationNames.OperReadProperties);
         m_ResOperNames.Add(ResourceOperation.UpdateProperties,
            OperationNames.OperUpdateProperties);
         m_ResOperNames.Add(ResourceOperation.ReadContent,
            OperationNames.OperReadContent);
         m_ResOperNames.Add(ResourceOperation.UpdateContent,
            OperationNames.OperUpdateContent);
         m_ResOperNames.Add(ResourceOperation.ReadAuthorizationPolicy,
            OperationNames.OperReadAuthorizationPolicy);
         m_ResOperNames.Add(ResourceOperation.UpdateDeleteAuthorizationPolicy,
            OperationNames.OperUpdateDeleteAuthorizationPolicy);

         if (m_ResOperNames.Count != NrResOperations)
         {
           //Resource name mismatch
           throw new Exception(string.Format(CultureInfo.InvariantCulture,
            CustomSecurity.OperationNameError));
         }

         m_DSOperNames = new Hashtable();
         m_DSOperNames.Add(DatasourceOperation.Delete,
            OperationNames.OperDelete);
         m_DSOperNames.Add(DatasourceOperation.ReadProperties,
            OperationNames.OperReadProperties);
         m_DSOperNames.Add(DatasourceOperation.UpdateProperties,
            OperationNames.OperUpdateProperties);
         m_DSOperNames.Add(DatasourceOperation.ReadContent,
            OperationNames.OperReadContent);
         m_DSOperNames.Add(DatasourceOperation.UpdateContent,
            OperationNames.OperUpdateContent);
         m_DSOperNames.Add(DatasourceOperation.ReadAuthorizationPolicy,
            OperationNames.OperReadAuthorizationPolicy);
         m_DSOperNames.Add(DatasourceOperation.UpdateDeleteAuthorizationPolicy,
            OperationNames.OperUpdateDeleteAuthorizationPolicy);

         if (m_DSOperNames.Count != NrDSOperations)
         {
           //Datasource name mismatch
           throw new Exception(string.Format(CultureInfo.InvariantCulture,
            CustomSecurity.OperationNameError));
         }
      }

      /// <summary>
      /// You must implement SetConfiguration as required by IExtension
      /// </summary>
      /// <param name="configuration">Configuration data as an XML
      /// string that is stored along with the Extension element in
      /// the configuration file.</param>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
      public void SetConfiguration(string configuration)
      {
         // Retrieve admin user and password from the config settings
         // and verify
         XmlDocument doc = new XmlDocument();
         doc.LoadXml(configuration);
         if (doc.DocumentElement.Name == "AdminConfiguration")
         {
            foreach (XmlNode child in doc.DocumentElement.ChildNodes)
            {
               if(child.Name == "UserName")
               {
                  m_adminUserName = child.InnerText;
               }
               else
               {
                  throw new Exception(string.Format(CultureInfo.InvariantCulture,
                    CustomSecurity.UnrecognizedElement));
               }
            }
         }
         else
             throw new Exception(string.Format(CultureInfo.InvariantCulture,
                CustomSecurity.AdminConfiguration));
      }

       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public string LocalizedName 
      {
         get
         {
            // Return a localized name for this extension
            return null;
         }
      }
   }
}
