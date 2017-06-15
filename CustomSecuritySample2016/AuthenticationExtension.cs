#region
// Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
// Licensed under the MIT License (MIT)
/*============================================================================
  File:      AuthenticationExtension.cs

  Summary:  Demonstrates an implementation of an authentication 
            extension.
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

using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Principal;
using System.Web;
using Microsoft.ReportingServices.Interfaces;
using System.Globalization;

namespace Microsoft.Samples.ReportingServices.CustomSecurity
{
 
   public class AuthenticationExtension:IAuthenticationExtension2, IExtension
   {
      /// <summary>
      /// You must implement SetConfiguration as required by IExtension
      /// </summary>
      /// <param name="configuration">Configuration data as an XML
      /// string that is stored along with the Extension element in
      /// the configuration file.</param>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public void SetConfiguration(String configuration)
      {
         // No configuration data is needed for this extension
      }

      /// <summary>
      /// You must implement LocalizedName as required by IExtension
      /// </summary>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public string LocalizedName 
      {
         get
         {
            return null;
         }
      }

      /// <summary>
      /// Indicates whether a supplied username and password are valid.
      /// </summary>
      /// <param name="userName">The supplied username</param>
      /// <param name="password">The supplied password</param>
      /// <param name="authority">Optional. The specific authority to use to
      /// authenticate a user. For example, in Windows it would be a Windows 
      /// Domain</param>
      /// <returns>true when the username and password are valid</returns>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public bool LogonUser(string userName, string password, string authority)
      {
         return AuthenticationUtilities.VerifyPassword(userName, password);
      }  
      
      /// <summary>
      /// Required by IAuthenticationExtension. The report server calls the 
      /// GetUserInfo methodfor each request to retrieve the current user 
      /// identity.
      /// </summary>
      /// <param name="userIdentity">represents the identity of the current 
      /// user. The value of IIdentity may appear in a user interface and 
      /// should be human readable</param>
      /// <param name="userId">represents a pointer to a unique user identity
      /// </param>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
       //original method that was added in the code.
       public void GetUserInfo(out IIdentity userIdentity, out IntPtr userId)
       {
           // If the current user identity is not null,
           // set the userIdentity parameter to that of the current user 
           if (HttpContext.Current != null
                 && HttpContext.Current.User != null)
           {
               userIdentity = HttpContext.Current.User.Identity;
           }
           else
           // The current user identity is null. This happens when the user attempts an anonymous logon.
           // Although it is ok to return userIdentity as a null reference, it is best to throw an appropriate
           // exception for debugging purposes.
           // To configure for anonymous logon, return a Gener
           {
               //System.Diagnostics.Debug.Assert(false, "Warning: userIdentity is null! Modify your code if you wish to support anonymous logon.");
               throw new NullReferenceException("Anonymous logon is not configured. userIdentity should not be null!");
           }

           // initialize a pointer to the current user id to zero
           userId = IntPtr.Zero;
       }

        //adding new GetUserInfo method for IAuthenticationExtension2
       public void GetUserInfo(IRSRequestContext requestContext, out IIdentity userIdentity, out IntPtr userId)
       {
           userIdentity = null;
           if (requestContext.User != null)
           {
               userIdentity = requestContext.User;
           }

           // initialize a pointer to the current user id to zero
           userId = IntPtr.Zero;
       }

      /// <summary>
      /// The IsValidPrincipalName method is called by the report server when 
      /// the report server sets security on an item. This method validates 
      /// that the user name is valid for Windows.The principal name needs to 
      /// be a user, group, or builtin account name.
      /// </summary>
      /// <param name="principalName">A user, group, or built-in account name
      /// </param>
      /// <returns>true when the principle name is valid</returns>
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2123:OverrideLinkDemandsShouldBeIdenticalToBase")]
      public bool IsValidPrincipalName(string principalName)
      {
         return VerifyUser(principalName);
      }

      // 
       [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:DisposeObjectsBeforeLosingScope")]
      public static bool VerifyUser(string userName)
      { 
         bool isValid = false;
         using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.Database_ConnectionString))
		    {
			    SqlCommand cmd = new SqlCommand("LookupUser", conn);
			    cmd.CommandType = CommandType.StoredProcedure;

			    SqlParameter sqlParam = cmd.Parameters.Add("@userName",
				    SqlDbType.VarChar,
				    255);
			    sqlParam.Value = userName;
			    try
			    {
	          conn.Open();
	          using (SqlDataReader reader = cmd.ExecuteReader())
	          {
		        // If a row exists for the user, then the user is valid.
		        if (reader.Read())
		          {
			          isValid = true;
		          }
	          }
          }
          catch (Exception ex)
          {
	          throw new Exception(string.Format(CultureInfo.InvariantCulture,
              CustomSecurity.VerifyError + ex.Message));
          }
        }
     
        return isValid;
      }
   }
}
