<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Турминал - О компании
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageIndexId %>);
        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %></h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>
</asp:Content>
