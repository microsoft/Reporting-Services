#region Copyright © Microsoft Corporation. All rights reserved.
/*============================================================================
  File:     UILogon.aspx.cs
  Summary:  The code-behind for a logon page that supports Forms
            Authentication in a custom security extension    
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
using System.Collections;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Web;
using System.Net;
using System.Web.Services;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.Security;
using System.Xml;
using Microsoft.SqlServer.ReportingServices2010;
using Microsoft.Samples.ReportingServices.CustomSecurity.App_LocalResources;
using System.Globalization;

namespace Microsoft.Samples.ReportingServices.CustomSecurity
{
   /// <summary>
   /// Summary description for WebForm1.
   /// </summary>
   public class UILogon : System.Web.UI.Page
   {
      protected System.Web.UI.WebControls.Label LblUser;
      protected System.Web.UI.WebControls.TextBox TxtPwd;
      protected System.Web.UI.WebControls.TextBox TxtUser;
      protected System.Web.UI.WebControls.Button BtnRegister;
      protected System.Web.UI.WebControls.Button BtnLogon;
      protected System.Web.UI.WebControls.Label lblMessage;
      protected System.Web.UI.WebControls.Label Label1;
      protected System.Web.UI.WebControls.Label LblPwd;

      private void Page_Load(object sender, System.EventArgs e)
      {
         // Put user code to initialize the page here
      }

      #region Web Form Designer generated code
      override protected void OnInit(EventArgs e)
      {
         //
         // CODEGEN: This call is required by the ASP.NET Web Form Designer.
         //
         InitializeComponent();
         base.OnInit(e);
      }

      /// <summary>
      /// Required method for Designer support - do not modify
      /// the contents of this method with the code editor.
      /// </summary>
      private void InitializeComponent()
      {
         this.BtnLogon.Click += new System.EventHandler(this.BtnLogon_Click);
         this.BtnRegister.Click += new System.EventHandler(this.BtnRegister_Click);
         this.Load += new System.EventHandler(this.Page_Load);

      }
      #endregion

      [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
      private void BtnRegister_Click(object sender, System.EventArgs e)
      {
         string salt = AuthenticationUtilities.CreateSalt(5);
         string passwordHash =
            AuthenticationUtilities.CreatePasswordHash(TxtPwd.Text, salt);
         if (AuthenticationUtilities.ValidateUserName(TxtUser.Text))
         {
            try
            {
               AuthenticationUtilities.StoreAccountDetails(
                 TxtUser.Text, passwordHash, salt);
            }
            catch (Exception ex)
            {
               lblMessage.Text = string.Format(CultureInfo.InvariantCulture, ex.Message); ;
            }
         }
         else
         {
            lblMessage.Text = string.Format(CultureInfo.InvariantCulture,
               UILogon_aspx.UserNameError);
         }
      }

      [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
      private void BtnLogon_Click(object sender, System.EventArgs e)
      {
         bool passwordVerified = false;
         try
         {
            ReportServerProxy server = new ReportServerProxy();

            string reportServer = ConfigurationManager.AppSettings["ReportServer"];
            string instanceName = ConfigurationManager.AppSettings["ReportServerInstance"];

            // Get the server URL from the report server using WMI
            server.Url = AuthenticationUtilities.GetReportServerUrl(reportServer, instanceName);

            server.LogonUser(TxtUser.Text, TxtPwd.Text, null);

            passwordVerified = true;

         }
         catch (Exception ex)
         {
            lblMessage.Text = string.Format(CultureInfo.InvariantCulture, ex.Message); ;
            return;
         }
         if (passwordVerified == true)
         {
            lblMessage.Text = string.Format(CultureInfo.InvariantCulture,
              UILogon_aspx.LoginSuccess);
            string redirectUrl =
               Request.QueryString["ReturnUrl"];
            if (redirectUrl != null)
               HttpContext.Current.Response.Redirect(redirectUrl, false);
            else
               HttpContext.Current.Response.Redirect(
                  "./Folder.aspx", false);
         }
         else
         {
            lblMessage.Text = string.Format(CultureInfo.InvariantCulture,
             UILogon_aspx.InvalidUsernamePassword);
         }
      }
   }

   // Because the UILogon uses the Web service to connect to the report server
   // you need to extend the server proxy to support authentication ticket
   // (cookie) management
   public class ReportServerProxy : ReportingService2010
   {
      protected override WebRequest GetWebRequest(Uri uri)
      {
         HttpWebRequest request;
         request = (HttpWebRequest)HttpWebRequest.Create(uri);
         // Create a cookie jar to hold the request cookie
         CookieContainer cookieJar = new CookieContainer();
         request.CookieContainer = cookieJar;
         Cookie authCookie = AuthCookie;
         // if the client already has an auth cookie
         // place it in the request's cookie container
         if (authCookie != null)
            request.CookieContainer.Add(authCookie);
         request.Timeout = -1;
         request.Headers.Add("Accept-Language",
            HttpContext.Current.Request.Headers["Accept-Language"]);
         return request;
      }

      [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
      protected override WebResponse GetWebResponse(WebRequest request)
      {
         WebResponse response = base.GetWebResponse(request);
         string cookieName = response.Headers["RSAuthenticationHeader"];
         // If the response contains an auth header, store the cookie
         if (cookieName != null)
         {
            Utilities.CustomAuthCookieName = cookieName;
            HttpWebResponse webResponse = (HttpWebResponse)response;
            Cookie authCookie = webResponse.Cookies[cookieName];
            // If the auth cookie is null, throw an exception
            if (authCookie == null)
            {
               throw new Exception(
                  "Authorization ticket not received by LogonUser");
            }
            // otherwise save it for this request
            AuthCookie = authCookie;
            // and send it to the client
            Utilities.RelayCookieToClient(authCookie);
         }
         return response;
      }

      private Cookie AuthCookie
      {
         get
         {
            if (m_Authcookie == null)
               m_Authcookie =
               Utilities.TranslateCookie(
                  HttpContext.Current.Request.Cookies[Utilities.CustomAuthCookieName]);
            return m_Authcookie;
         }
         set
         {
            m_Authcookie = value;
         }
      }
      private Cookie m_Authcookie = null;
   }

   [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1812:AvoidUninstantiatedInternalClasses")]
   internal sealed class Utilities
   {
      internal static string CustomAuthCookieName
      {
         get
         {
            lock (m_cookieNamelockRoot)
            {
               return m_cookieName;
            }
         }
         set
         {
            lock (m_cookieNamelockRoot)
            {
               m_cookieName = value;
            }
         }
      }
      private static string m_cookieName;
      private static object m_cookieNamelockRoot = new object();

      private static HttpCookie TranslateCookie(Cookie netCookie)
      {
         if (netCookie == null)
            return null;
         HttpCookie webCookie = new HttpCookie(netCookie.Name, netCookie.Value);
         // Add domain only if it is dotted - IE doesn't send back the cookie 
         // if we set the domain otherwise
         if (netCookie.Domain.IndexOf('.') != -1)
            webCookie.Domain = netCookie.Domain;
         webCookie.Expires = netCookie.Expires;
         webCookie.Path = netCookie.Path;
         webCookie.Secure = netCookie.Secure;
         return webCookie;
      }

      internal static Cookie TranslateCookie(HttpCookie webCookie)
      {
         if (webCookie == null)
            return null;
         Cookie netCookie = new Cookie(webCookie.Name, webCookie.Value);
         if (webCookie.Domain == null)
            netCookie.Domain =
               HttpContext.Current.Request.ServerVariables["SERVER_NAME"];
         netCookie.Expires = webCookie.Expires;
         netCookie.Path = webCookie.Path;
         netCookie.Secure = webCookie.Secure;
         return netCookie;
      }

      internal static void RelayCookieToClient(Cookie cookie)
      {
         // add the cookie if not already in there
         if (HttpContext.Current.Response.Cookies[cookie.Name] == null)
         {
            HttpContext.Current.Response.Cookies.Remove(cookie.Name);
         }

         HttpContext.Current.Response.SetCookie(TranslateCookie(cookie));
      }
   }
}
