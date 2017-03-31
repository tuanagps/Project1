﻿<%@ Page Language="C#" PageTemplate="/DefaultMaster.master" Inherits="CM.Web.ViewPageEx<dynamic>" Title="<%$ Metadata:value(.Title)%>" MetaKeywords="<%$ Metadata:value(.Keywords)%>" MetaDescription="<%$ Metadata:value(.Description)%>"%>





<asp:Content ContentPlaceHolderID="cphHead" Runat="Server">

</asp:Content>





<asp:Content ContentPlaceHolderID="cphMain" Runat="Server">

<% Html.RenderPartial("/Components/ListContent", this.ViewData.Merge(new { @SideMenuTitle = this.GetMetadata(".SideMenuTitle"), @MetadataPath = "/Metadata/TermsConditions", @Category = this.ViewData["actionName"], @SubCategory = this.ViewData["parameter"] })); %>

</asp:Content>


