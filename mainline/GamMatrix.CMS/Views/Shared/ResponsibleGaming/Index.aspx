﻿<%@ Page Language="C#" PageTemplate="/DefaultMaster.master" ValidateRequest="false" Inherits="CM.Web.ViewPageEx<dynamic>" Title="<%$ Metadata:value(.Title)%>" MetaKeywords="<%$ Metadata:value(.Keywords)%>" MetaDescription="<%$ Metadata:value(.Description)%>"%>

<script runat="server" type="text/C#">
    protected string MetadataPath { get { return "/Metadata/ResponsibleGaming"; } }
</script>

<asp:Content ContentPlaceHolderID="cphHead" Runat="Server">
</asp:Content>


<asp:Content ContentPlaceHolderID="cphMain" Runat="Server">
<% Html.RenderPartial("/Components/GeneralContent", this.ViewData.Merge(new{ @MetadataPath= MetadataPath})); %>

</asp:Content>
