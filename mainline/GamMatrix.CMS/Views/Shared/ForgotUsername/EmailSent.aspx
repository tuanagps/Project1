﻿<%@ Page Language="C#" PageTemplate="/DefaultMaster.master" Inherits="CM.Web.ViewPageEx<dynamic>" Title="<%$ Metadata:value(.Title)%>" MetaKeywords="<%$ Metadata:value(.Keywords)%>" MetaDescription="<%$ Metadata:value(.Description)%>"%>


<asp:Content ContentPlaceHolderID="cphHead" Runat="Server">
</asp:Content>


<asp:Content ContentPlaceHolderID="cphMain" Runat="Server">
<div id="forgot-pwd-wrapper" class="content-wrapper">
<%: Html.H1(this.GetMetadata(".HEAD_TEXT")) %>

<ui:Panel runat="server" ID="pnForgotPwd">
    <center>
        <br />
        <%: Html.SuccessMessage( this.GetMetadata(".Success_Message") ) %>
        <br />
        <%: Html.InformationMessage( this.GetMetadata(".Info_Message") ) %>
    </center>
</ui:Panel>

</div>
</asp:Content>
