﻿<%@ Control Language="C#" Inherits="CM.Web.ViewUserControlEx<Finance.PaymentMethod>" %>

<%@ Import Namespace="GamMatrix.CMS.Models.Common.Components" %>
<%@ Import Namespace="GamMatrixAPI" %>

<% Html.RenderPartial(
         "/Components/MoneyMatrix_PaymentSolutionPayCard",
         new MoneyMatrixPaymentSolutionPrepareViewModel(
             TransactionType.Withdraw,
             "Neteller",
             VendorID.Neteller,
             new List<MmInputField>
             {
                new MmInputField("NetellerEmailAddressOrAccountId", this.GetMetadata(".NetellerEmailAddressOrAccountId_Label")) { IsRequired = true }
             })); %>