#region
// Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
// Modified (c) 2020 cfitzg. All Rights Forfitted.
// Licensed under the MIT License (MIT)
/*============================================================================
  File:     Logon.aspx.cs
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

(BUT YOU CAN DO SOME PRETTY COOL STUFF WITH SSRS CUSTOM AUTH)
===========================================================================*/
#endregion

using System;
using System.Web.Security;

namespace Microsoft.Samples.ReportingServices.CustomSecurity
{
   public class Logon : System.Web.UI.Page
   {
        protected System.Web.UI.WebControls.Button BtnLogon;

        private void Page_Load(object sender, EventArgs e)
        {
            //Your secret authentication sauce goes here.. (this init commit is just anon/admin access for all)
            //appHash should get dynamically generated from the app calling SSRS (ideally for each request if performant enough)
            //ie. 
            //if (CheckAuth(System.Web.HttpContext.Current.Request.Cookies["origAppHash"].ToString()))
            //if (CheckAuth(System.Web.HttpContext.Current.Session["otroAppHash"].ToString()))
            if (System.Web.HttpContext.Current.Request.IsLocal)
                FormsAuthentication.RedirectFromLoginPage("daylite", true);
        }

        private bool CheckAuth(string appHash)
        {
            //DecodeandCrytoChecks on appHash 
                return true;
        }
           
        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            InitializeComponent();
            base.OnInit(e);
        }

        private void InitializeComponent()
        {
            this.Load += new EventHandler(this.Page_Load);
        }
        #endregion
   }
}