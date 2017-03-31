﻿<%@ Page Language="C#" PageTemplate="/DefaultMaster.master" Inherits="CM.Web.ViewPageEx<Finance.PaymentMethod>" Title="<%$ Metadata:value(.Title)%>" MetaKeywords="<%$ Metadata:value(.Keywords)%>" MetaDescription="<%$ Metadata:value(.Description)%>"%>
<%@ Import Namespace="GamMatrix.CMS.Models.MobileShared.Components" %>
<%@ Import Namespace="GamMatrixAPI" %>
<%@ Import Namespace="Finance" %>
<%@ Import Namespace="GmCore" %>
<%@ Import Namespace="GamMatrix.CMS.Models.MobileShared.Components" %>

<script language="C#" type="text/C#" runat="server">
    private GetTransInfoRequest GetTransactionInfo()
    {
        return this.ViewData["getTransInfoRequest"] as GetTransInfoRequest;
    }

    private PrepareTransRequest GetPrepareTransRequest()
    {
        return this.ViewData["prepareTransRequest"] as PrepareTransRequest;
    }

    private ProcessTransRequest GetProcessTransRequest()
    {
        return this.ViewData["processTransRequest"] as ProcessTransRequest;
    }

    private ProcessAsyncTransRequest GetProcessAsyncTransRequest()
    {
        return this.ViewData["processAsyncTransRequest"] as ProcessAsyncTransRequest;
    }

    private string GetCreditMessage()
    {       
        return this.GetMetadata(".Receipt_Credit");
    }

    private string GetDebitMessage()
    {
        PayCardRec payCard = GamMatrixClient.GetPayCard(GetPrepareTransRequest().Record.DebitPayCardID);

        if (Model.VendorID == VendorID.MoneyMatrix && Model.UniqueName == "MoneyMatrix")
            return this.GetMetadataEx(".Debit_Card", payCard.DisplayName).SafeHtmlEncode();

        if( this.Model.VendorID != VendorID.PaymentTrust )
            return this.GetMetadataEx(".Receipt_Debit", this.Model.GetTitleHtml()).HtmlEncodeSpecialCharactors();

        if (payCard != null)
            return this.GetMetadataEx(".Debit_Card", payCard.DisplayNumber).SafeHtmlEncode();

        return string.Empty;
    }
</script>

<asp:Content ContentPlaceHolderID="cphHead" Runat="Server">
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="expires" content="Wed, 26 Feb 1997 08:21:57 GMT" />
<meta http-equiv="expires" content="0" />
</asp:Content>


<asp:Content ContentPlaceHolderID="cphMain" Runat="Server">
<div class="UserBox DepositBox CenterBox">
<div class="BoxContent">
<% Html.RenderPartial("/Components/UserFlowStatus", new UserFlowStatusViewModel { FlowSteps = 4, CurrentStep = 4 }); %>
        <h2 class="SubHeading"><%= this.GetMetadata(".Receipt").SafeHtmlEncode()%></h2>
<% Html.RenderPartial("/Components/StatusNotification", new StatusNotificationViewModel(StatusType.Success, this.GetMetadata(".Success_Message"))); %>

<%-------------------------------
    UKash receipt
-------------------------------%>
<% if (this.Model.VendorID == VendorID.Ukash || this.Model.VendorID == VendorID.BoCash )
{
    ProcessTransRequest processTransRequest = GetProcessTransRequest();
    if (processTransRequest != null &&
        processTransRequest.ResponseFields.ContainsKey("changeIssueVoucherNumber") &&
        !string.IsNullOrWhiteSpace(processTransRequest.ResponseFields["changeIssueVoucherNumber"]))
    {%>
        <%: Html.WarningMessage( this.GetMetadata(".Ukash_Notes") ) %>
<div class="MenuList L DetailContainer">
<ol class="DetailPairs ProfileList">
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Ukash_Number") %></span> <span class="DetailValue"><%= processTransRequest.ResponseFields["changeIssueVoucherNumber"].SafeHtmlEncode() %></span>
</div>
</li>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Ukash_Currency") %></span> <span class="DetailValue"><%= processTransRequest.ResponseFields["changeIssueVoucherCurr"].SafeHtmlEncode()%></span>
</div>
</li>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Ukash_Value") %></span> <span class="DetailValue"><%= processTransRequest.ResponseFields["changeIssueAmount"].SafeHtmlEncode()%></span>
</div>
</li>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Ukash_Expiry_Date")%></span> <span class="DetailValue"><%= DateTime.Parse(processTransRequest.ResponseFields["changeIssueExpiryDate"]).ToString( "dd/MM/yyyy" )%></span>
</div>
</li>
</ol>
</div>
<%   }
} %>
<% Html.RenderPartial("/Components/StatusNotification", new StatusNotificationViewModel(StatusType.Info, this.GetMetadata(".Information_Message"))); %>

          <%------------------------
            The receipt table
          ------------------------%>
 <div class="MenuList L DetailContainer">
<ol class="DetailPairs ProfileList">
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Transaction_ID").SafeHtmlEncode() %></span> <span class="DetailValue"><%= GetTransactionInfo().TransID %></span>
</div>
</li>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Date_Time").SafeHtmlEncode() %></span> <span class="DetailValue"><%= GetTransactionInfo().TransData.TransCompleted.ToString("dd/MM/yyyy HH:mm:ss"
, System.Globalization.DateTimeFormatInfo.InvariantInfo).SafeHtmlEncode() %></span>
</div>
</li>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= GetCreditMessage().SafeHtmlEncode() %></span> <span class="DetailValue"><%= MoneyHelper.FormatWithCurrency( GetTransactionInfo().PostingData[1].Record.Currency
  , GetTransactionInfo().PostingData[1].Record.Amount 
  ) %></span>
<script src="https://zz.connextra.com/dcs/tagController/tag/7d61b44fefd2/depositconfirm?Stake=<%= MoneyHelper.FormatWithCurrency( GetTransactionInfo().PostingData[1].Record.Currency
  , GetTransactionInfo().PostingData[1].Record.Amount 
  ) %>" async defer></script>
</div>
</li>
<% 
if (GetTransactionInfo().FeeData != null)
{
foreach (TransFeeData fee in GetTransactionInfo().FeeData)
{
%>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= this.GetMetadata(".Receipt_Fee")%></span> <span class="DetailValue"><%= MoneyHelper.FormatWithCurrency( GetTransactionInfo().PostingData[0].Record.Currency
  , GetTransactionInfo().PostingData[0].Record.Amount 
  ) %></span>
</div>
</li>
<%
}
}
%>
<li>
<div class="ProfileDetail">
<span class="DetailName"><%= GetDebitMessage() %></span> <span class="DetailValue"><%= MoneyHelper.FormatWithCurrency( GetTransactionInfo().PostingData[0].Record.Currency
  , GetTransactionInfo().PostingData[0].Record.Amount 
  ) %></span>
</div>
</li>
</ol>
</div>
    </div>
</div>
<script type="text/javascript">
    (function ($) {
        var cmsViews = CMS.views;

        cmsViews.BackBtn = function (selector) {
            $(selector).click(function () {
                window.location = '/Deposit';
                return false;
            });
        }
    })(jQuery);

$(CMS.mobile360.Generic.init);
</script>
</asp:Content>
